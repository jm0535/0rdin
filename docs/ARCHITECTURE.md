# Ördin 4 — Architecture

> Applies to Ördin **4.0.0** (`apps/ordin-desktop` + `packages/*`).
> The v3 Shiny/Electron architecture is documented in [`development/PROJECT_OVERVIEW.md`](development/PROJECT_OVERVIEW.md#legacy-v3-architecture).

## 1. Goals

1. **Statistical first** — real `vegan`/`iNEXT`/`betapart` results, not re-implementations.
2. **Runs anywhere** — the same bundle serves the web app, the Tauri desktop build and a PWA.
3. **Zero install for users** — R ships as WebAssembly (webR); no local R, no server round-trips.
4. **Reproducible** — every analysis records parameters, provenance and an equivalent R snippet.

## 2. Stack

| Layer | Technology |
|---|---|
| Shell | Tauri 2 (desktop) / browser / PWA |
| UI | React 18 + TypeScript 5.8 + Tailwind CSS 3 |
| Build | Vite 6 (`vite-plugin-wasm`, `vite-plugin-pwa`) |
| State | Zustand 5 + Immer, schema validated with zod |
| Data | DuckDB-WASM 1.33 + Apache Arrow 21 |
| Statistics | webR 0.4 (R + vegan, iNEXT, betapart, adespatial, FD, picante, ape…) |
| Graphics | SVG renderers in-app, `ggplot2`/`ggiNEXT` output from webR |
| Maps (optional) | MapLibre GL 6 + deck.gl 9 |
| Workers | Comlink for off-main-thread calls |

## 3. Monorepo layout

```
apps/ordin-desktop     # the application (Vite front end + Tauri shell)
packages/core          # OrdinProject schema, Zustand store, panel ids, validators
packages/processing    # webR bridge + JS fast paths for statistics
packages/ui            # shared presentational primitives
packages/map           # MapLibre helper (createMap)
tests/                 # node:test + Playwright suites
scripts/ tools/ ci/    # build helpers, linters, R CI bootstrap
shiny/ src/            # legacy v3 app (maintenance only)
```

npm workspaces (`apps/*`, `packages/*`, `workers/*`) tie them together; `@ordin/*` packages are consumed directly from source by Vite.

## 4. Data flow

```
File (CSV/XLSX/Parquet)
   ↓ ImportDialog
DuckDB-WASM table  ──SQL──▶ Inspector (SQL tab)
   ↓ typed extraction
@ordin/core store  (project.data.species / env / traits)
   ↓ panel action
@ordin/processing
   ├── JS fast path        → instant preview (distances, hclust, k-means, indices)
   └── webR call           → authoritative result + provenance string
   ↓
project.analyses.<key>   → panel render (SVG plots, tables) → export / .ordin file
```

### Project model

`OrdinProject` (`packages/core/src/index.ts`) is the single serialisable unit:

```ts
{
  version: '4.0',
  meta: { name, created, modified, plugins },
  data: { species, env, traits },
  analyses: { nmds, pca, ca, dca, pcoa, cca, rda, dbrda, cap,
              diversity, indices, inext, beta,
              cluster, twinspan, kmeans,
              varpart, forwardSel,
              permanova, permanova_nmds, anosim, mantel, envfit,
              cwm, fourthcorner, rlq },
  view: { activePanel, mapStyle, theme }
}
```

Saving a project writes this object (plus data blobs) to a `.ordin` bundle; loading restores the full session, which is what makes results portable between the web app and the desktop build.

## 5. The webR bridge

`packages/processing` owns all R interaction:

- `getWebR()` lazily boots a single shared webR instance and mounts the package library.
- `runNMDSViaWebR`, `runOrdinationViaWebR`, `runInextViaWebR`, `runBetaViaWebR`, `runTestViaWebR`, `runVarpartViaWebR`, `runAnovaViaWebR`, `runRLQViaWebR` wrap R calls, marshal matrices in and typed results out.
- Every result carries a `provenance` string (for example `REAL vegan::metaMDS via webR`). Panels display it as a badge, so mock values can never be mistaken for real ones.
- JS implementations (`distanceMatrix`, `betaPartitionJS`, `hclustJS`, `kmeansJS`, `silhouetteScores`, `copheneticCorrelation`, `computeCWM`, `shannon`, `simpson`) provide sub-second previews and a fallback where webR cannot run.

### Cross-origin isolation

webR and DuckDB-WASM need `SharedArrayBuffer`, which requires:

```
Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Embedder-Policy: require-corp
```

These are set in `vercel.json` for production and by the Vite dev server locally. Tauri is isolated by default. Sandboxed iframe previews that cannot send these headers run in mock mode with an explicit banner.

## 6. UI shell

```
Titlebar (Tauri drag region)
├── ActivityBar        panel switcher
├── Sidebar            panel-specific inputs        (Ctrl/Cmd + B)
├── Main canvas        active panel
├── RightInspector     details / env / SQL tabs     (Ctrl/Cmd + I)
├── WorkflowFooter     1 Data → 2 Diversity → 3 Beta → 4 Ordination → 5 Tests
└── StatusBar          webR status, row counts, provenance
```

`CommandPalette` (`Ctrl/Cmd + K`), `ImportDialog` and `PluginMarketplace` are global overlays. `ErrorBoundary` wraps the panel area so a failing analysis never blanks the app.

## 7. Distribution targets

| Target | Command | Notes |
|---|---|---|
| Web (Vercel) | `npm run build` | `ordin.in4metrix.dev`; COOP/COEP from `vercel.json` |
| Desktop | `npm run tauri:build -w ordin-desktop` | Bundles webR + R packages for offline use |
| PWA | same build | `vite-plugin-pwa`; DuckDB uses OPFS, webR cached |
| Preview sandbox | `npm run dev` | Mock mode when headers are unavailable |

## 8. Performance notes

- DuckDB keeps large tables out of JS memory; only the active slice is materialised.
- The data grid is virtualised (`@tanstack/react-virtual`).
- Long R calls run in the webR worker; the UI stays responsive and shows progress in the status bar.
- webR boots lazily on the first analysis, not at app start.

## 9. Related documents

- [`ORDIN_STACK_AUDIT_2026-09-26.md`](ORDIN_STACK_AUDIT_2026-09-26.md) — package allow-list and CANOCO mapping
- [`ENTERPRISE-AUDIT-2026-09-25.md`](ENTERPRISE-AUDIT-2026-09-25.md) — quality/robustness audit
- [`API.md`](API.md) — exported functions and types
- [`DEVELOPMENT.md`](DEVELOPMENT.md) — day-to-day workflow
