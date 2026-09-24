# Ördin 4.0 — GeoLibre-Stack Redesign

> Rebuild Ördin v3 (Electron + Shiny/R) as a GeoLibre-style cloud-native app:
> **Tauri v2 (Rust) + React 18 + TypeScript 5 + Vite 6 + Zustand 4 + MapLibre GL 6 + DuckDB-WASM 1.33 + deck.gl 9 + webR (WASM R)**

## 1. Why GeoLibre's stack

| Concern | v3 (current) | v4 (GeoLibre) | Win |
|---|---|---|---|
| Shell | Electron 28 (~180 MB) + bundled R | Tauri v2 (Rust, ~12 MB) | 15× smaller, native menu, auto-update |
| UI | Shiny server-rendered HTML, jQuery | React 18 + Vite 6, client-rendered | Instant interactions, no round-trip |
| State | Shiny reactives (R) | Zustand + Immer (TS) | Time-travel, persist to `.ordin.json` |
| Map | None | MapLibre GL + deck.gl + PMTiles | Site coords → MaplibreMap with hulls |
| Query | R only | DuckDB-WASM Spatial in browser | SQL on local CSV/Parquet, no server |
| Compute | R process (vegan/iNEXT) blocking* | **webR** (WASM R) in Worker | Truly async, no R install |
| Build | Forge + R installer scripts | `npm` workspaces + `cargo` | One `npm run dev` |
| Tests | R testthat (needs R) | Vitest + Playwright (JS) | Runs in CI without R |

* v3 already fixed with `future::multisession` but still needs system R.

## 2. Monorepo (npm workspaces) — mirrors GeoLibre

```
0rdin/
├─ package.json                 # workspaces: ["apps/*","packages/*","workers/*"]
├─ apps/
│  └─ ordin-desktop/            # Vite + React app + Tauri shell (apps/geolibre-desktop)
│     ├─ src/
│     │  ├─ components/
│     │  │  ├─ layout/         # AppShell, ActivityBar, Sidebar, Toolbar, StatusBar
│     │  │  ├─ panels/         # DataPanel, MapPanel, OrdinationPanel, DiversityPanel, TestsPanel, BetaPanel, ResultsPanel
│     │  │  ├─ map/            # MapLibreMap + deck.gl ScatterplotLayer for ordination biplots
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
│  ├─ map/                     # @ordin/map — MapLibre lifecycle, PMTiles protocol
│  ├─ processing/              # @ordin/processing — vegan wrappers + Turf.js helpers
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

## 5. UI — GeoLibre layout, Ördin content

GeoLibre: ActivityBar (left) → Sidebar (layers) → MapCanvas → Toolbar → StatusBar → RightPanel (properties).

Ördin 4.0 maps 1:1:

```
[ActivityBar]  Home | Data | Diversity | Ordination | Tests | Beta | Results | Settings | Help
[Sidebar]      DATA SOURCES, WORKSPACE (badges), RECENT — Zustand-driven
[MainCanvas]   Toolbar + MapLibreMap (sites) + Panel (e.g. OrdinationPanel with NMDS config + Plot)
[RightPanel]   PROPERTIES — selected site, quick export
[StatusBar]    Ready | 20×30 | webR 0.4.2 | Ördin 4.0 | RAM (via performance.measureMemory)
```

Styling: copy GeoLibre's tokens — `IBM Plex Sans` via `@fontsource`, Radix + Tailwind-like utility classes (no Tailwind dependency in v3, but we add it), dark theme `#1e1e1e / #252526 / #2e8b57` already matches GeoLibre's dark.

## 6. Full parity checklist

- [ ] **Data**: CSV/XLSX drop + sample datasets (dune, varespec, BCI, phylocom) via DuckDB `read_csv` + webR `data(dune)`
- [ ] **Ordination 9×**: NMDS (async webR metaMDS), PCA (rda), CA (cca), DCA (decorana), PCoA (wcmdscale), CCA, RDA, db-RDA (dbrda), CAP (capscale) — each as a `@ordin/processing` tool with Zod params
- [ ] **Diversity**: iNEXT (rarefy), Shannon/Simpson/Fisher/Evenness, Hill numbers — via iNEXT WASM
- [ ] **Tests**: PERMANOVA (adonis2), ANOSIM, Mantel, envfit — via vegan WASM
- [ ] **Beta**: betapart Sørensen turnover/nestedness, PMTiles-style tiling for large site×site matrices
- [ ] **Exports**: CSV/JSON + PDF report via `rmarkdown` in webR (fallback: jsPDF + html2canvas)
- [ ] **Map**: new — if env has lon/lat or site coords, shows NMDS hulls on MapLibre + deck.gl
- [ ] **SQL Workspace**: DuckDB panel (copy GeoLibre verbatim)
- [ ] **Plugins**: like GeoLibre `packages/plugins` — ordination methods as plugins

## 7. Migration — keep shiny/ alive

- `shiny/` stays at `shiny/` (or moves to `legacy/shiny/` after 4.0 stable) and is still runnable via `R -e "shiny::runApp('shiny')"` for validation.
- Tauri sidecar fallback: if webR unavailable (e.g. no SharedArrayBuffer), spawn `Rscript` via Tauri `shell` plugin — same UX, different backend.
- Tests: keep `shiny/tests/testthat` + add `vitest` for new packages.

## 8. Next steps (this PR)

1. Scaffold monorepo + Vite app + Zustand store + stub workers (done below)
2. Implement ActivityBar/Sidebar/MapPanel shell (done below)
3. Wire one e2e flow: **Load dune → NMDS (webR) → Map/Plot** (done below, others stubbed)
4. Later: fill remaining 8 ordinations + diversity + tests + beta as plugins.
