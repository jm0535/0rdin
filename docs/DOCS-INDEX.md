# Ördin Documentation Index

Documentation for Ördin **4.0.0** (Tauri · React · Vite · DuckDB-WASM · webR).

Legend: **v4** = current application · **legacy** = describes the v3 Shiny/Electron app in `shiny/`, kept for maintenance · **reference** = research / planning material.

## Start here

| Document | Scope | |
|---|---|---|
| [Quick Start](QUICKSTART.md) | Install, prepare data, first analysis | v4 |
| [Workflow](WORKFLOW.md) | Data → Transform → Choose → Constrain → Test → Visualise | v4 |
| [Features Overview](FEATURES-OVERVIEW.md) | Panel-by-panel capability list | v4 |
| [Help Guide](HELP_GUIDE.md) | In-app help content | v4 |

## Architecture & development

| Document | Scope | |
|---|---|---|
| [Architecture](ARCHITECTURE.md) | Stack, monorepo layout, data flow, webR bridge | v4 |
| [Development Guide](DEVELOPMENT.md) | Scripts, conventions, testing, releases | v4 |
| [API Reference](API.md) | `@ordin/core`, `@ordin/processing`, `@ordin/ui`, `@ordin/map` (+ legacy appendix) | v4 |
| [Project Overview](development/PROJECT_OVERVIEW.md) | High-level project description | v4 |
| [Reproducibility Guide](development/DEVELOPER-GUIDE-REPRODUCIBILITY.md) | Recording provenance and parameters | legacy |
| [Security Audit](development/SECURITY-AUDIT.md) | Security review | legacy |
| [Test Checklist](development/TEST_CHECKLIST.md) | Manual QA passes | legacy |
| [Stack Audit 2026-09-26](ORDIN_STACK_AUDIT_2026-09-26.md) | R package allow-list, CANOCO 5 mapping | reference |
| [Enterprise Audit 2026-09-25](ENTERPRISE-AUDIT-2026-09-25.md) | Quality/robustness review | reference |

## Analysis guides

| Document | Topic |
|---|---|
| [Ordination Guide](guides/ENTERPRISE_ORDINATION_GUIDE.md) | Method choice, settings, interpretation |
| [CCA & RDA Guide](guides/CCA_RDA_GUIDE.md) | Constrained ordination |
| [Biplot Guide](guides/BIPLOT_GUIDE.md) | CANOCO-style overlays, scaling |
| [Incidence vs Abundance](guides/INCIDENCE-VS-ABUNDANCE.md) | Choosing a data type |
| [EstimateS & Rarefaction Types](guides/ESTIMATES-AND-RAREFACTION-TYPES.md) | Sample-size, coverage, completeness |
| [Rarefaction Quick Guide](RAREFACTION-QUICK-GUIDE.md) | Which curve to use |
| [iNEXT Parameters](INEXT-PARAMETERS-GUIDE.md) | `q`, `knots`, `endpoint`, `nboot`, `conf` |
| [Extrapolation Endpoint](EXTRAPOLATION-ENDPOINT-GUIDE.md) | Safe extrapolation limits |
| [Auto-Select Data Type](AUTO-SELECT-DATA-TYPE.md) | Automatic abundance/incidence detection |

## Data

| Document | Topic |
|---|---|
| [Data Structure Guide](guides/DATA-STRUCTURE-GUIDE.md) | Required table layouts |
| [Data Management Guide](guides/DATA_MANAGEMENT_GUIDE.md) | Import, validation, transformation |
| [New Incidence-Raw Dataset](NEW-INCIDENCE-RAW-DATASET.md) | `plant-presence.csv` sample |
| [Ciliates Data Issue](CILIATES-DATA-ISSUE.md) · [Troubleshooting Ciliates](TROUBLESHOOTING-CILIATES.md) | Worked diagnostic case |

## Plots & export

| Document | Topic |
|---|---|
| [Plot Customization Guide](guides/PLOT-CUSTOMIZATION-GUIDE.md) | Every customisation control |
| [Plot Quick Reference](guides/PLOT-QUICK-REFERENCE.md) | One-page cheat sheet |
| [Plot Code Examples](guides/PLOT-CODE-EXAMPLES.md) | Equivalent R/ggplot2 snippets |
| [Publication-Quality Plots](PUBLICATION-QUALITY-PLOTS.md) | Journal-ready output |
| [Plot Export Quick Guide](PLOT-EXPORT-QUICK-GUIDE.md) | Formats, DPI, dimensions |
| [Export Features](guides/EXPORT-FEATURES.md) | Tables, scores, reports |

## Setup & publishing

| Document | Topic | |
|---|---|---|
| [Linux Setup](setup/SETUP-LINUX.md) | Dependencies and build on Linux | legacy/v4 |
| [WSL Setup](setup/SETUP-WSL.md) | Windows Subsystem for Linux | legacy |
| [Fedora Quick Start](setup/FEDORA-QUICKSTART.md) | Fedora/RHEL specifics | legacy |
| [Publishing Guide](setup/PUBLISH.md) · [Quick Publish](setup/QUICK-PUBLISH.md) | Releasing to GitHub | v4 |
| [GitHub Pages Setup](setup/GITHUB-PAGES-SETUP.md) · [Enable Pages](setup/ENABLE-GITHUB-PAGES.md) | The `docs/` landing site | v4 |
| [Screenshots Guide](assets/screenshots/README.md) | Capturing site imagery | v4 |

## Troubleshooting

- [Results Not Displaying](TROUBLESHOOTING-RESULTS-DISPLAY.md)
- [Troubleshooting Ciliates Data](TROUBLESHOOTING-CILIATES.md)
- Quick Start [troubleshooting table](QUICKSTART.md#5-troubleshooting)

## Roadmap & research

- [Ordin ↔ AnaDat-R Coverage Plan](ANADAT-R-ROADMAP.md)
- [vegan Integration Research](VEGAN-COMPREHENSIVE-RESEARCH.md)
- [Ördin 4.0 Redesign](REDESIGN-GEOLIBRE.md)

## Legacy v3 documents

These describe the Shiny/Electron application in `shiny/` and `src/`:
[Quick Start Guide (v2/v3)](QUICK-START-GUIDE.md) ·
[Settings Guide](guides/SETTINGS_GUIDE.md) ·
[How to Display Data in Shiny](guides/HOW_TO_DISPLAY_DATA_IN_SHINY.md) ·
[Splash Screen](SPLASH-SCREEN-QUICK-GUIDE.md) ·
[Welcome Page](WELCOME-PAGE-QUICK-GUIDE.md)

## Project-root documents

[README](../README.md) · [CHANGELOG](../CHANGELOG.md) · [SECURITY](../SECURITY.md) · [Contributing](../.github/CONTRIBUTING.md) · [Code of Conduct](../.github/CODE_OF_CONDUCT.md) · [Code Standards](../.github/CODE_STANDARDS.md)
