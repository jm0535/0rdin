# Quick Start — Ördin 4

Ördin runs R (`vegan`, `iNEXT`, `betapart`) directly in the browser through WebAssembly. **You do not need R installed.**

## 1. Choose how to run it

### A. Online (fastest)

Open <https://ordin.in4metrix.dev>. The first visit downloads the R runtime once, then caches it — later visits work offline. You can also install it as an app from your browser's address bar (PWA).

### B. Desktop app

Download the installer for your platform from the [Releases page](https://github.com/jm0535/0rdin/releases) and run it. The desktop build bundles R offline.

### C. From source (developers)

```bash
git clone https://github.com/jm0535/0rdin.git
cd 0rdin
npm install     # Node.js >= 22
npm run dev     # open http://localhost:9054
```

See [`DEVELOPMENT.md`](DEVELOPMENT.md) for the full developer workflow.

## 2. Prepare your data

A species matrix is a CSV/Excel table with **sites in rows** and **taxa in columns**:

```csv
Site,Species_A,Species_B,Species_C
Site1,12,0,3
Site2,5,7,0
Site3,0,4,9
```

Rules of thumb:

- First column = site identifiers (unique, no blanks).
- All other cells numeric, no negatives, no missing values.
- At least 3 sites and 2 species for most analyses.
- Environmental data goes in a separate file with the same site column.
- Trait data is taxa × traits.

Details: [`guides/DATA-STRUCTURE-GUIDE.md`](guides/DATA-STRUCTURE-GUIDE.md) · [`guides/INCIDENCE-VS-ABUNDANCE.md`](guides/INCIDENCE-VS-ABUNDANCE.md)

No data yet? Open the **Data** panel and load a bundled dataset (`dune`, `varespec`, `BCI`) or pick a file from [`sample-data/`](../sample-data).

## 3. Run your first analysis

1. **Data (1)** — import your file (or load a sample). Check the preview grid and, if needed, apply a transformation (Hellinger for ordination of abundances, presence/absence for incidence work).
2. **Diversity (2)** — set `q = 0, 1, 2`, choose `abundance` or `incidence`, then run. You get rarefaction/extrapolation curves with bootstrap confidence intervals and asymptotic estimates.
3. **Ordination (4)** — start with NMDS + Bray-Curtis (`k = 2`). Check the stress value: < 0.05 excellent, < 0.1 good, < 0.2 usable, > 0.2 suspect. Use the DCA gradient-length adviser to decide between linear (PCA/RDA) and unimodal (CA/CCA) methods.
4. **Tests (5)** — run PERMANOVA (`adonis2`) on a grouping variable, and PERMDISP (`betadisper`) to confirm the result is not driven by unequal dispersion.
5. **Beta (3)** — partition total dissimilarity into turnover and nestedness.
6. Export the figure (SVG/PNG at your chosen DPI) and the tables (CSV/JSON), or save the whole session as a `.ordin` project.

## 4. Useful shortcuts

| Shortcut | Action |
|---|---|
| `Ctrl/Cmd + K` | Command palette |
| `Ctrl/Cmd + B` | Toggle left sidebar |
| `Ctrl/Cmd + I` | Toggle right inspector |

The **status bar** shows the webR runtime state and the provenance of the current result — always check that a result says `REAL … via webR` before reporting it.

## 5. Troubleshooting

| Symptom | Fix |
|---|---|
| Results labelled as mock/preview | The page is not cross-origin isolated. Use the deployed site, the desktop app, or the local dev server (all send COOP/COEP headers). |
| "Analysis unavailable" on first run | The R runtime is still downloading. Wait for the status bar to read *ready*. |
| Import rejected | Check for non-numeric cells, blank rows, or a missing site column. |
| Very slow analysis on a big matrix | Reduce permutations/bootstraps first; consider the desktop build for large datasets. |
| Port 9054 already in use (dev) | `npm run dev -- --port 5173` |

More: [`TROUBLESHOOTING-RESULTS-DISPLAY.md`](TROUBLESHOOTING-RESULTS-DISPLAY.md) · [`HELP_GUIDE.md`](HELP_GUIDE.md)

## 6. Where to next

- [Workflow](WORKFLOW.md) — the full Data → Transform → Choose → Constrain → Test → Visualise path
- [Features overview](FEATURES-OVERVIEW.md)
- [Ordination guide](guides/ENTERPRISE_ORDINATION_GUIDE.md) · [CCA/RDA guide](guides/CCA_RDA_GUIDE.md)
- [iNEXT parameters](INEXT-PARAMETERS-GUIDE.md) · [Publication-quality plots](PUBLICATION-QUALITY-PLOTS.md)
