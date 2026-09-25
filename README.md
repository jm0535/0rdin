<div align="center">

<img src="build/icon.png" alt="Ördin Logo" width="128" height="128">

# Ördin 4

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-4.0.0-blue.svg)](https://github.com/jm0535/0rdin/releases)
[![Platform](https://img.shields.io/badge/platform-Web%20%7C%20Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)](https://github.com/jm0535/0rdin)
[![Node.js](https://img.shields.io/badge/Node.js-%E2%89%A522-green)](https://nodejs.org/)
[![Stack](https://img.shields.io/badge/stack-Tauri%20%C2%B7%20React%20%C2%B7%20Vite%20%C2%B7%20webR-8a2be2)](docs/ARCHITECTURE.md)

**Next-Gen Open-Source Community Ecology Workbench**

*Real R statistics (vegan · iNEXT · betapart) running in the browser and on the desktop — no R installation required*

[Features](#-key-features) • [Quick start](#-quick-start) • [Architecture](#-architecture) • [Documentation](#-documentation) • [Citation](#citation)

</div>

---

## 🌟 Why Ördin?

Most ecological analysis software forces a trade-off: friendly tools lack statistical rigour, rigorous tools lack usability. Ördin 4 keeps the rigour (the same `vegan`/`iNEXT` code a reviewer would expect) and drops the friction — it runs **R in WebAssembly via [webR](https://docs.r-wasm.org/webr/latest/)**, so there is nothing to install on a user's machine.

### At a glance

| | Ördin 4 |
|---|---|
| **Runtime** | webR (R 4.4 compiled to WASM) + DuckDB-WASM for data |
| **Delivery** | Web app (`ordin.in4metrix.dev`), Tauri desktop bundle, installable PWA |
| **Panels** | Dashboard, Data, Diversity, Ordination, Tests, Beta, Classification, Traits, Settings, Help |
| **Ordination** | NMDS, PCA, CA, DCA, PCoA, CCA, RDA, db-RDA, CAP (+ varpart, forward selection) |
| **Diversity** | iNEXT rarefaction/extrapolation (Hill q=0/1/2, types 1–3) + classic indices |
| **Beta diversity** | Baselga turnover/nestedness partitioning, LCBD/SCBD |
| **Tests** | PERMANOVA, PERMDISP, ANOSIM, Mantel, envfit, `anova.cca` |
| **Projects** | `.ordin` bundle = data + analyses + provenance, portable across web/desktop |
| **Offline** | Desktop bundles webR + packages; web caches them after first load |

> **Provenance first.** Every result is labelled with how it was produced (`REAL … via webR` vs. mock preview data), so you always know whether a number came from R.

---

## ✨ Key features

### 📊 Analysis panels

- **Data (1)** — CSV/Excel/Parquet import into DuckDB-WASM, virtualised grid preview, `decostand` transforms (Hellinger, chord, log, Wisconsin, presence/absence) with live preview, SQL inspector.
- **Diversity (2)** — `iNEXT` rarefaction & extrapolation: `q = 0/1/2`, abundance / incidence-raw / incidence-freq, sample-size (type 1), coverage (type 3) and completeness (type 2) curves, bootstrap CIs.
- **Beta (3)** — `vegdist` dissimilarities, Baselga partitioning (`beta.pair`, `beta.multi`), `beta.div.comp` replacement/richness-difference components.
- **Ordination (4)** — unconstrained (PCA, CA, DCA, PCoA, NMDS) and constrained (RDA, CCA, db-RDA, CAP, partial models) with DCA gradient-length adviser, `varpart` and `ordiR2step`.
- **Tests (5)** — `adonis2`, `betadisper`, `anosim`, `mantel`/`mantel.partial`, `envfit`, restricted permutation designs.
- **Classification** — hierarchical clustering (Ward D2, average, complete), k-means, cophenetic correlation and silhouette diagnostics (JS fast path, R verification).
- **Traits** — community-weighted means, RLQ / fourth-corner, functional diversity hooks (`FD`, `picante`).

### 🎨 Interface

- VS Code-inspired shell: activity bar, collapsible sidebar, right inspector, status bar, workflow footer.
- Command palette (`Ctrl/Cmd + K`), sidebar toggle (`Ctrl/Cmd + B`), inspector toggle (`Ctrl/Cmd + I`).
- Plot customisation panel (themes, typography, points/lines, grids, CI ribbons, legends, facets) applied without re-running analyses.
- Optional MapLibre + deck.gl site map for datasets with lon/lat columns — statistics first, maps only when useful.
- Plugin marketplace scaffold for optional analysis modules.

### 📤 Export

- Publication-quality figures (SVG/PNG, configurable DPI and dimensions).
- Tabular exports (CSV, JSON, Parquet) and reproducible R snippets per panel.
- `.ordin` project files bundling data, results and provenance.

---

## 🚀 Quick start

### Use it online

Open **<https://ordin.in4metrix.dev>** — no install. The first load fetches webR and the R package bundle, then caches them for offline use.

### Run from source

```bash
git clone https://github.com/jm0535/0rdin.git
cd 0rdin
npm install          # Node.js >= 22
npm run dev          # Vite dev server on http://localhost:9054
```

Other workspace scripts:

| Command | What it does |
|---|---|
| `npm run dev` | Dev server for `apps/ordin-desktop` (port 9054, bound to `0.0.0.0`) |
| `npm run build` | Type-check + production build to `apps/ordin-desktop/dist` |
| `npm run preview` | Serve the production build locally |
| `npm run tauri:dev` | Run the desktop shell in dev mode |
| `npm run typecheck` | `tsc --noEmit` across all workspaces |
| `npm run lint` | ESLint over `apps`, `packages`, `workers`, `tests` |
| `npm test` | Workspace test suites |
| `npm run test:frontend` | Node test runner over `tests/*.test.ts` |

> **Cross-origin isolation.** Real R execution needs `SharedArrayBuffer`, which requires the COOP/COEP headers already configured in `vercel.json` and the Vite dev server. Sandboxed iframe previews without those headers fall back to mock results, clearly labelled in the UI.

### Build the desktop app

```bash
npm run tauri:build -w ordin-desktop
```

Requires the [Tauri prerequisites](https://tauri.app/start/prerequisites/) for your platform (Rust toolchain, plus WebKitGTK on Linux). Bundles land in the Tauri `target/release/bundle` directory and ship webR offline — end users never install R.

---

## 🧱 Architecture

```
0rdin/
├── apps/
│   └── ordin-desktop/        # Vite + React 18 app (also the Tauri front end)
│       └── src/
│           ├── components/layout/   # ActivityBar, Sidebar, RightInspector, CommandPalette, …
│           ├── components/panels/   # Dashboard, Data, Diversity, Ordination, Tests, Beta, …
│           └── components/map/      # optional MapLibre + deck.gl view
├── packages/
│   ├── core/                 # Zustand store, OrdinProject schema (zod), panel types
│   ├── processing/           # webR bridge + JS fast paths (distances, hclust, k-means, CWM)
│   ├── ui/                   # shared primitives (Button, Card, Badge, Dialog, Sheet, …)
│   └── map/                  # MapLibre helpers
├── docs/                     # documentation + GitHub Pages site
├── sample-data/              # example datasets
├── scripts/ · tools/ · ci/   # build helpers, linters, R CI bootstrap
├── shiny/ · src/             # legacy v3 Shiny + Electron app (maintenance only)
└── vercel.json               # COOP/COEP headers for SharedArrayBuffer
```

Data flows **file → DuckDB-WASM → typed store (`@ordin/core`) → analysis call (`@ordin/processing`) → panel render**. Analyses run in webR when cross-origin isolation is available; lightweight JS implementations provide instant previews and a deterministic fallback.

Details: [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) · [`docs/DEVELOPMENT.md`](docs/DEVELOPMENT.md) · [`docs/API.md`](docs/API.md) · [`docs/ORDIN_STACK_AUDIT_2026-09-26.md`](docs/ORDIN_STACK_AUDIT_2026-09-26.md).

---

## 📚 Documentation

Start at the [documentation index](docs/DOCS-INDEX.md).

**Core**
- [Quick start](docs/QUICKSTART.md) — install, first analysis
- [Architecture](docs/ARCHITECTURE.md) — stack, data flow, webR bridge
- [Development guide](docs/DEVELOPMENT.md) — monorepo workflow, testing, releases
- [API reference](docs/API.md) — `@ordin/core`, `@ordin/processing`, `@ordin/ui`, `@ordin/map`
- [Workflow](docs/WORKFLOW.md) · [Features overview](docs/FEATURES-OVERVIEW.md)

**Analysis guides** (`docs/guides/`)
- [Ordination](docs/guides/ENTERPRISE_ORDINATION_GUIDE.md) · [CCA/RDA](docs/guides/CCA_RDA_GUIDE.md) · [Biplots](docs/guides/BIPLOT_GUIDE.md)
- [Data structure](docs/guides/DATA-STRUCTURE-GUIDE.md) · [Data management](docs/guides/DATA_MANAGEMENT_GUIDE.md)
- [Incidence vs abundance](docs/guides/INCIDENCE-VS-ABUNDANCE.md) · [Estimates & rarefaction types](docs/guides/ESTIMATES-AND-RAREFACTION-TYPES.md)
- [Plot customisation](docs/guides/PLOT-CUSTOMIZATION-GUIDE.md) · [Export features](docs/guides/EXPORT-FEATURES.md)

**Setup & publishing** (`docs/setup/`) — [Linux](docs/setup/SETUP-LINUX.md) · [WSL](docs/setup/SETUP-WSL.md) · [Fedora](docs/setup/FEDORA-QUICKSTART.md) · [Publishing](docs/setup/PUBLISH.md) · [GitHub Pages](docs/setup/GITHUB-PAGES-SETUP.md)

**Development** (`docs/development/`) — [Project overview](docs/development/PROJECT_OVERVIEW.md) · [Reproducibility](docs/development/DEVELOPER-GUIDE-REPRODUCIBILITY.md) · [Security audit](docs/development/SECURITY-AUDIT.md) · [Test checklist](docs/development/TEST_CHECKLIST.md)

**Community** — [Contributing](.github/CONTRIBUTING.md) · [Code of Conduct](.github/CODE_OF_CONDUCT.md) · [Code standards](.github/CODE_STANDARDS.md) · [Security policy](SECURITY.md) · [Changelog](CHANGELOG.md)

> Documents describing the v3 Shiny/Electron application are marked with a **legacy** banner at the top. They remain accurate for the `shiny/` tree, which is kept for reference and maintenance only.

---

## 🧪 Data format

A species matrix is a table with sites in rows and taxa in columns:

| Site | Species_A | Species_B | Species_C |
|---|---|---|---|
| Site1 | 12 | 0 | 3 |
| Site2 | 5 | 7 | 0 |

Environmental tables share the same site column and hold numeric or factor variables; trait tables are taxa × traits. Incidence-raw data uses one matrix per assemblage; incidence-frequency data uses the number of sampling units in the first cell. See [`docs/guides/DATA-STRUCTURE-GUIDE.md`](docs/guides/DATA-STRUCTURE-GUIDE.md).

Sample datasets live in [`sample-data/`](sample-data/) and `dune`, `varespec` and `BCI` can be loaded directly from the Data panel.

---

## 🔁 Migrating from Ördin 3

| v3 (Shiny + Electron) | v4 (React + webR) |
|---|---|
| Requires local/portable R install | R ships as WASM, zero install |
| `npm start` (Electron + Shiny server on port 9054) | `npm run dev` (Vite on port 9054) |
| Analyses in the R process | Analyses in webR worker, JS fast paths for previews |
| Results tied to the session | `.ordin` project files with provenance |
| Legacy code in `shiny/`, `src/` | Active code in `apps/`, `packages/` |

The legacy app is still runnable — see [`docs/DEVELOPMENT.md`](docs/DEVELOPMENT.md#legacy-v3-shiny--electron-app).

---

## 🤝 Contributing

Issues and pull requests are welcome. Please read [`.github/CONTRIBUTING.md`](.github/CONTRIBUTING.md) and run `npm run lint && npm run typecheck && npm test` before opening a PR.

## License

MIT — see [LICENSE](LICENSE).

## Author

Jimmy Moses (jimmy.moses@pnguot.ac.pg)

## Acknowledgments

- Built with [Tauri](https://tauri.app/), [React](https://react.dev/), [Vite](https://vite.dev/), [Zustand](https://zustand.docs.pmnd.rs/), [DuckDB-WASM](https://duckdb.org/docs/api/wasm/overview.html) and [deck.gl](https://deck.gl/)
- R in the browser thanks to [webR](https://docs.r-wasm.org/webr/latest/)
- Statistics powered by [vegan](https://github.com/vegandevs/vegan), [iNEXT](https://github.com/JohnsonHsieh/iNEXT), [betapart](https://cran.r-project.org/package=betapart) and [adespatial](https://cran.r-project.org/package=adespatial)
- Design inspiration from CANOCO 5 and VS Code

## Support

- **Issues**: [GitHub Issues](https://github.com/jm0535/0rdin/issues)
- **Discussions**: [GitHub Discussions](https://github.com/jm0535/0rdin/discussions)
- **Email**: jimmy.moses@pnguot.ac.pg

## Citation

```
Moses, J. (2026). Ördin 4: A browser-native and desktop workbench for community ecology analysis.
GitHub repository: https://github.com/jm0535/0rdin
```
