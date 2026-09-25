# Ördin 4 — Features Overview

Everything Ördin 4.0.0 can do, panel by panel. Terminology and defaults follow the package allow-list in [`ORDIN_STACK_AUDIT_2026-09-26.md`](ORDIN_STACK_AUDIT_2026-09-26.md).

> Legacy note: the v2/v3 feature list (splash screen, Shiny tabs, Electron window chrome) lives in [`QUICK-START-GUIDE.md`](QUICK-START-GUIDE.md) and the other documents marked *legacy*.

---

## 1. Runtime & delivery

| Feature | Detail |
|---|---|
| **R without installing R** | R 4.4 compiled to WebAssembly (webR 0.4) runs in a worker |
| **Three delivery targets** | Web app (`ordin.in4metrix.dev`), Tauri desktop bundle, installable PWA |
| **Offline** | Desktop bundles the runtime; web caches it after the first load |
| **Private by default** | Data never leaves the device — no upload, no server-side computation |
| **In-browser data engine** | DuckDB-WASM + Apache Arrow, with OPFS persistence |
| **Provenance labelling** | Every result shows how it was computed (`REAL … via webR` vs. preview/mock) |

---

## 2. Data panel (1)

- Import CSV, TSV, Excel and Parquet; drag-and-drop or file picker.
- Bundled datasets: `dune`, `varespec`, `BCI`, plus the files in [`sample-data/`](../sample-data).
- Virtualised grid preview for large matrices (`@tanstack/react-virtual`).
- Structural validation: unique site ids, numeric cells, no negatives/NA, minimum sites and species.
- Separate species, environmental and trait tables sharing a site key.
- Transformations with live preview: Hellinger, chord, chi-square, log, square root, Wisconsin double standardisation, presence/absence (`vegan::decostand`).
- SQL inspector tab for ad-hoc DuckDB queries against the loaded tables.
- Automatic abundance vs. incidence detection — see [`AUTO-SELECT-DATA-TYPE.md`](AUTO-SELECT-DATA-TYPE.md).

---

## 3. Diversity panel (2)

- `iNEXT` rarefaction and extrapolation with bootstrap confidence intervals.
- Hill numbers `q = 0` (richness), `q = 1` (exp Shannon), `q = 2` (inverse Simpson).
- Data types: `abundance`, `incidence_raw`, `incidence_freq`.
- Curve types: sample-size (type 1), sample coverage (type 3), coverage completeness (type 2).
- Controls for `knots`, `endpoint` (default 2× the reference sample), `nboot`, `conf`.
- Asymptotic estimators (`AsyEst`) and sample summary (`DataInfo`) tables.
- Classic indices: Shannon, Simpson, inverse Simpson, Fisher's alpha, richness, Pielou's J′, Simpson's E.

Guides: [iNEXT parameters](INEXT-PARAMETERS-GUIDE.md) · [rarefaction types](RAREFACTION-QUICK-GUIDE.md) · [extrapolation endpoint](EXTRAPOLATION-ENDPOINT-GUIDE.md) · [incidence vs abundance](guides/INCIDENCE-VS-ABUNDANCE.md)

---

## 4. Beta panel (3)

- Dissimilarity matrices via `vegan::vegdist` (Bray-Curtis, Jaccard, Kulczynski, Horn, Morisita, Gower, Euclidean, Canberra…).
- Baselga partitioning: total Sørensen (`sor`) into turnover (`sim`) and nestedness (`sne`), pairwise and multi-site.
- `adespatial::beta.div.comp` replacement / richness-difference components, LCBD and SCBD.
- Instant JavaScript preview (`betaPartitionJS`) followed by the R-verified result.
- Heatmap and component plots with ecological interpretation text.

---

## 5. Ordination panel (4)

**Unconstrained:** NMDS (`metaMDS`), PCA (`rda`), tb-PCA (Hellinger + `rda`), CA (`cca`), DCA (`decorana`), PCoA (`wcmdscale`).

**Constrained:** CCA, RDA, partial models with `Condition()`, db-RDA (`dbrda`), CAP (`capscale`).

**Support:**
- DCA gradient-length adviser (linear vs. unimodal, Ter Braak's < 3 SD rule).
- Variation partitioning (`varpart`, 2–3 explanatory groups) and forward selection (`ordiR2step`, adjusted R² + p-adjustment).
- `envfit` vectors and factors, `ordisurf` surfaces, confidence ellipses and spiders.
- Site, species and environmental scores with scaling options; eigenvalues and explained variance on the axes.
- NMDS stress with quality grading and a Shepard/stress plot.

Guides: [ordination settings](guides/ENTERPRISE_ORDINATION_GUIDE.md) · [CCA/RDA](guides/CCA_RDA_GUIDE.md) · [biplots](guides/BIPLOT_GUIDE.md)

---

## 6. Tests panel (5)

- **PERMANOVA** (`adonis2`) with restricted permutation designs (`permute::how`: blocks, plots, series).
- **PERMDISP** (`betadisper`) to check dispersion homogeneity.
- **ANOSIM** (`anosim`).
- **Mantel** and partial Mantel tests.
- **envfit** significance for environmental vectors and factors.
- **`anova.cca`** permutation tests for constrained models (overall, by term, by axis).
- Configurable permutation count, seed control, and full reporting of the test statistic, permutations and p-value.

---

## 7. Classification panel

- Hierarchical clustering: Ward D2, average, complete, single linkage.
- k-means with configurable `k` and iterations.
- Diagnostics: cophenetic correlation, silhouette widths (per point and mean).
- Cluster group assignment feeds directly into PERMANOVA/ANOSIM grouping.
- JS implementations run instantly; R verification available for reporting.

---

## 8. Traits panel

- Community-weighted means (CWM) from a taxa × traits table.
- RLQ and fourth-corner analysis relating traits, species and environment.
- Hooks for functional diversity (`FD::dbFD` — FDis, Rao) and phylogenetic diversity (`picante::pd`, `mpd`, `mntd`).

---

## 9. Interface

- VS Code-inspired shell: activity bar, collapsible sidebar, right inspector (details / env / SQL), status bar and a numbered workflow footer.
- Command palette (`Ctrl/Cmd + K`); sidebar (`Ctrl/Cmd + B`) and inspector (`Ctrl/Cmd + I`) toggles.
- Dark and light themes; internationalisation scaffolding via i18next.
- Error boundary around the panel area so a failed analysis never blanks the app.
- Plugin marketplace scaffold for optional analysis modules.
- Optional MapLibre + deck.gl site map when the data has lon/lat columns.

---

## 10. Plot customisation & export

- Live customisation without re-running the analysis: themes, typography (family and sizes), point shapes/sizes, line widths, major/minor grids, CI ribbon transparency, legend position and size, facet labels.
- Figure export as SVG and PNG with configurable dimensions and DPI (publication defaults provided).
- Table export as CSV and JSON; scores, eigenvalues and test statistics included.
- Reproducible R snippet per panel, mirroring what was executed in webR.
- `.ordin` project files bundle data, analyses, parameters, timestamps and provenance.

Guides: [plot customisation](guides/PLOT-CUSTOMIZATION-GUIDE.md) · [quick reference](guides/PLOT-QUICK-REFERENCE.md) · [publication-quality plots](PUBLICATION-QUALITY-PLOTS.md) · [export](PLOT-EXPORT-QUICK-GUIDE.md)

---

## 11. How Ördin compares

| Capability | Ördin 4 | EstimateS | PAST | R + vegan |
|---|---|---|---|---|
| Install required | none (browser) | yes | yes | R + packages |
| iNEXT rarefaction/extrapolation | ✅ | partial | partial | ✅ |
| Full ordination family | ✅ 9+ methods | ❌ | partial | ✅ |
| Constrained ordination + varpart | ✅ | ❌ | partial | ✅ |
| Beta partitioning (Baselga) | ✅ | ❌ | partial | ✅ |
| Restricted permutation designs | ✅ | ❌ | ❌ | ✅ |
| Publication export presets | ✅ | limited | limited | manual |
| Reproducible project file | ✅ `.ordin` | ❌ | ❌ | scripts |
| Coding required | none | none | none | yes |

---

## 12. Roadmap

Planned after 1.0 (see [`ANADAT-R-ROADMAP.md`](ANADAT-R-ROADMAP.md) and the [stack audit](ORDIN_STACK_AUDIT_2026-09-26.md)):

- `adespatial` dbMEM/PCNM spatial analysis and PRC.
- Co-correspondence analysis (CoCA) and TWINSPAN-style classification.
- Joint species distribution models (`Hmsc`) as a desktop sidecar.
- Tauri mobile shell alongside the existing PWA.
