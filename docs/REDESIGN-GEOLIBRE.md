# Ördin 4.0 — Next-Gen Community Ecology, rebuilt on GeoLibre's stack

> Rebuild Ördin v3 (Electron + Shiny/R) as a **Community Ecology statistical app** that reuses GeoLibre's *engineering stack*:
> **Tauri v2 (Rust) + React 18 + TypeScript 5 + Vite 6 + Zustand + DuckDB-WASM 1.33 + deck.gl 9 + webR (WASM R)** — with **MapLibre GL only as an optional site viewer** if env has lon/lat.
> Product identity stays statistical (ordination / diversity / tests / beta via vegan+iNEXT+betapart), not a GIS mapper. deck.gl draws **ordination biplots**, DuckDB runs **SQL on species/env tables**.

## 1. Why GeoLibre's stack

| Concern | v3 (current) | v4 (GeoLibre stack, statistical reuse) | Win |
|---|---|---|---|
| Shell | Electron 28 (~180 MB) + bundled R | Tauri v2 (Rust, ~12 MB) | 15× smaller, native menu, auto-update |
| UI | Shiny server-rendered HTML, jQuery | React 18 + Vite 6, client-rendered | Instant interactions, no round-trip |
| State | Shiny reactives (R) | Zustand + Immer (TS) | Time-travel, persist to `.ordin.json` |
| Plot | Base R + ggplot2 (blocking) | **deck.gl ScatterplotLayer** for ordination biplots | GPU scatter/biplot, env vector arrows |
| Map | None (not needed for stats) | **Optional** MapLibre, only if env has lon/lat | No GIS dependency; statistical by default |
| Query | R only | DuckDB-WASM in browser on species/env CSV/Parquet | SQL without server |
| Compute | R process (vegan/iNEXT) blocking* | **webR** (WASM R) in Worker | Truly async, no R install |
| Build | Forge + R installer scripts | `npm` workspaces + `cargo` | One `npm run dev` |
| Tests | R testthat (needs R) | Vitest + Playwright (JS) | Runs in CI without R |

* v3 already fixed with `future::multisession` but still needs system R.

## 2. Monorepo (npm workspaces) — mirrors GeoLibre

```
0rdin/
├─ package.json                 # workspaces: ["apps/*","packages/*","workers/*"]
├─ apps/
│  └─ ordin-desktop/            # Vite + React app + Tauri shell (mirrors apps/geolibre-desktop's stack, not its map)
│     ├─ src/
│     │  ├─ components/
│     │  │  ├─ layout/         # AppShell, ActivityBar, Sidebar, Toolbar, StatusBar
│     │  │  ├─ panels/         # DataPanel, OrdinationPanel, DiversityPanel, TestsPanel, BetaPanel, ResultsPanel (all statistical)
│     │  │  ├─ map/            # *Optional* SiteMap — only if env has lon/lat (MapLibre + deck.gl, collapsed by default)
│     │  │  └─ ui/             # shadcn-style primitives (Button, Select, Card, Tabs)
│     │  ├─ store/             # useOrdinStore (Zustand) — single .ordin.json project file
│     │  ├─ lib/
│     │  │  ├─ webr/           # webR worker singleton, vegan/iNEXT bridge
│     │  │  ├─ duckdb/         # DuckDB-WASM init, SQL workspace
│     │  │  └─ processing/     # Pure-JS fallbacks (Bray-Curtis, Shannon, betapart)
│     │  ├─ workers/
│     │  │  ├─ webr.worker.ts  # Comlink wrapper around webR
│     │  │  └─ duckdb.worker.ts
│     │  └─ tauri/             # placeholder until Rust toolchain available
│     ├─ index.html
│     ├─ vite.config.ts        # + vite-plugin-pwa, + wasm
│     └─ tsconfig.json
├─ packages/
│  ├─ core/                    # @ordin/core — Types, Zod schema for .ordin.json, Zustand slices
│  ├─ map/                     # @ordin/map — optional MapLibre lifecycle, only for lon/lat site view
│  ├─ processing/              # @ordin/processing — vegan/iNEXT wrappers (deck.gl biplot helpers)
│  └─ ui/                      # @ordin/ui — shared design tokens (matches GeoLibre's packages/ui)
├─ workers/
│  ├─ geolibre-viewer-worker/  # (stub) mirrors GeoLibre workers/* for future Cloudflare
│  └─ ...
├─ shiny/                      # kept, becomes `backend/r-legacy/` for reference / Tauri sidecar fallback
├─ sample-data/                # unchanged, now also as Parquet for DuckDB demo
└─ scripts/
   ├─ build-jupyterlite.mjs    # (future) embed in Jupyter as GeoLibre does
   └─ tauri-build.mjs
```

## 3. Data / State — single `.ordin.json` (like `.geolibre.json`)

```ts
// packages/core/src/schema.ts
type OrdinProject = {
  version: "4.0";
  data: {
    species: { columns: string[]; rownames: string[]; matrix: number[][] }; // 20×30 dune
    env?: { columns: string[]; rows: string[][]; rownames: string[] };
    sitesMeta?: { id: string; lon: number; lat: number }[]; // for MapLibre
  };
  analyses: {
    nmds?: { stress: number; points: [number,number][]; stressPlot?: string };
    pca?:  { eigenvalues: number[]; variance: number[] };
    // ... ca, dca, pcoa, cca, rda, dbrda, cap
    permanova?: PERMANOVAResult[];
    // ...
  };
  view: { activePanel: PanelId; mapStyle: string; theme: "dark"|"light" };
};
```

Zustand store (`useOrdinStore`) persists to `localStorage` + file via Tauri FS, and syncs to Jupyter via `postMessage` (like GeoLibre's anywidget).

## 4. Compute — webR over DuckDB

GeoLibre runs WhiteboxTools compiled to WASM via a Python sidecar for heavy work.
Ördin will do the same with **webR**:

```
UI → Zustand action → Worker (Comlink)
                         ├─ webR: library(vegan); metaMDS(dune, k=2) → {stress, points}
                         └─ DuckDB: SELECT Management, AVG(Shannon) FROM 'dune.parquet' GROUP BY ...
```

- **Primary:** `webr` 0.4+ with `vegan` + `iNEXT` + `betapart` + `picante` pre-built in `webr::mount`.
  Runs in a `Worker`, so NMDS never blocks the main thread (true async, not even Electron's `future::multisession`).
- **Fallback:** pure-JS for simple indices (Shannon, Simpson, Bray) via `@ordin/processing` (so UI works even if WASM disabled).
- **DuckDB-WASM** for the SQL Workspace panel (new, GeoLibre-parity): `SELECT ... FROM read_csv('dune_species.csv')`.

## 5. UI — GeoLibre layout, Ördin **statistical** content

GeoLibre: ActivityBar (left) → Sidebar (layers) → MapCanvas → Toolbar → StatusBar.

Ördin 4.0 reuses the **layout pattern** but replaces the GIS canvas with statistical panels:

```
[ActivityBar]  Home | Data | Diversity | Ordination | Tests | Beta | Results | Settings | Help
[Sidebar]      DATA SOURCES, WORKSPACE (badges), ANALYSES (Ordination/Diversity/Beta) — Zustand-driven
[MainCanvas]   Toolbar + Panel (e.g. OrdinationPanel with deck.gl biplot, not a map; optional SiteMap only if env has lon/lat)
[StatusBar]    Ready | 20×30 | webR 0.4.2 | statistical engine (vegan/iNEXT/betapart) | RAM
```

*Mapping note:* `MapLibre` + `deck.gl` + PMTiles exist only as an **optional, collapsed** secondary when the env table has `lon`/`lat`/`dec.long` columns. The primary visual is deck.gl **ordination scatters/biplots** and DuckDB **table SQL** — not tiles.

Styling: copy GeoLibre's tokens — `IBM Plex Sans` via `@fontsource`, Radix + Tailwind-like utility classes (no Tailwind dependency in v3, but we add it), dark theme `#1e1e1e / #252526 / #2e8b57` already matches GeoLibre's dark.

## 6. Full parity checklist

- [ ] **Data**: CSV/XLSX drop + sample datasets (dune, varespec, BCI, phylocom) via DuckDB `read_csv` + webR `data(dune)`
- [ ] **Ordination 9×**: NMDS (async webR metaMDS), PCA (rda), CA (cca), DCA (decorana), PCoA (wcmdscale), CCA, RDA, db-RDA (dbrda), CAP (capscale) — each as a `@ordin/processing` tool with Zod params
- [ ] **Diversity**: iNEXT (rarefy), Shannon/Simpson/Fisher/Evenness, Hill numbers — via iNEXT WASM
- [ ] **Tests**: PERMANOVA (adonis2), ANOSIM, Mantel, envfit — via vegan WASM
- [ ] **Beta**: betapart Sørensen turnover/nestedness, PMTiles-style tiling for large site×site matrices
- [ ] **Exports**: CSV/JSON + PDF report via `rmarkdown` in webR (fallback: jsPDF + html2canvas)
- [ ] **Optional site map**: if env has lon/lat, collapsed secondary MapLibre + deck.gl site scatter — never the primary view
- [ ] **SQL Workspace**: DuckDB panel on **species / env / site×site tables** (GeoLibre pattern, ecological tables)
- [ ] **Plugins**: like GeoLibre `packages/plugins` — ordination methods as statistical plugins (deck.gl biplot layers)

## 7. Migration — keep shiny/ alive

- `shiny/` stays at `shiny/` (or moves to `legacy/shiny/` after 4.0 stable) and is still runnable via `R -e "shiny::runApp('shiny')"` for validation.
- Tauri sidecar fallback: if webR unavailable (e.g. no SharedArrayBuffer), spawn `Rscript` via Tauri `shell` plugin — same UX, different backend.
- Tests: keep `shiny/tests/testthat` + add `vitest` for new packages.

## 8. Next steps (this PR)

1. Scaffold monorepo + Vite app + Zustand store + stub workers (done — statistical, not GIS)
2. Implement ActivityBar/Sidebar/Toolbar/StatusBar shell (done)
3. Wire one e2e flow: **Load dune → validate (Zustand) → NMDS (webR Worker) → deck.gl biplot + Stress** (done; MapLibre demoted to optional)
4. Later: fill remaining 8 ordinations + diversity + tests + beta as plugins (same stack).

## 9. Product identity (correction 2026-09-24)

Ordin is **not a mapping application** — it is a Community Ecology statistical platform. GeoLibre is the *stack reference* (Tauri+Vite+Zustand+DuckDB+deck.gl+webR), not the product template. `packages/map` is secondary. The primary canvas is statistical: ordination biplots (deck.gl), SQL on ecological tables (DuckDB-WASM), and vegan/iNEXT/betapart via webR.
