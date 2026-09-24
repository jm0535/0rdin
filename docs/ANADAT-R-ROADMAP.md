# Ordin ↔ AnaDat-R (davidzeleny.net/anadat-r) — Full Community Ecology Coverage Plan

> **Source audited:** `davidzeleny.net/anadat-r/doku.php/en:start` (intro, biased to vegetation, real datasets + exercises) [1](https://www.davidzeleny.net/anadat-r/doku.php/en:start) + sidebar export PDF showing full syllabus [2](https://davidzeleny.net/anadat-r/doku.php/en:sidebar?do=export_pdf&rev=1684568251) + `en:ordination` Table 1 of ordination methods [3](https://www.davidzeleny.net/anadat-r/doku.php/en:ordination) + `en:div-ind` diversity indices [4](https://www.davidzeleny.net/anadat-r/doku.php/en:div-ind) + `en:hier-divisive` TWINSPAN [5](https://www.davidzeleny.net/anadat-r/doku.php/en:hier-divisive?do=export_pdf). Checked 2026-09-25.

## 1. AnaDat-R inventory — what Ordin must eventually cover

AnaDat-R is **not** a single “method” but a taught course [Numerical Methods in Community Ecology] with ~30 wiki pages. The sidebar PDF [2] is the canonical TOC:

```
Theory, R functions & Examples
├─ Overview of analyses
├─ Data types and import into R
├─ Preparation of data for analysis
├─ Sampling design
├─ Ecological resemblance (distance / similarity coefficients)
├─ Ordination analysis  ← largest block
│   ├─ PCA & tb-PCA (linear unconstrained)
│   ├─ CA & DCA (unimodal unconstrained)
│   ├─ PCoA & NMDS (distance-based unconstrained)
│   ├─ RDA, tb-RDA, CCA & db-RDA (constrained; linear vs unimodal vs distance)
│   ├─ Ordination diagrams (biplots/triplots, scaling 1 vs 2, species/sites/env)
│   ├─ Supplementary variables (passive env fit → envfit)
│   ├─ Explained variation (eigenvalues, total inertia, % explained, scree, R²adj)
│   ├─ Permutation test (anova.cca, Monte Carlo)
│   ├─ Variable selection (forward sel, ordistep, vif.cca, ordiR2step, Blanchet)
│   └─ Variation partitioning (varpart / varpart2, Venn diagrams)
├─ Numerical classification
│   ├─ Cluster analysis (hierarchical agglomerative: single/complete/average/Ward/Centroid/UPGMA + dendrogram + cutting)
│   ├─ TWINSPAN (hierarchical divisive, indicator species, pseudospecies)
│   ├─ K-means (kmeans, cascadeKM, k-selection)
│   └─ Evaluation of classification (cophenetic correlation, silhouette, IndVal/multipatt, goodness-of-fit)
├─ Diversity analysis
│   ├─ Diversity indices (S, Shannon H' = -Σ p_i log p_i, Simpson D = Σ p_i², Gini-Simpson 1-D, evenness Pielou J, ENS, Hill numbers q=0,1,2, diversity profiles)
│   └─ Comparing diversity (rarefaction, species accumulation, iNEXT, diversity t-test, bootstrap)
├─ Species attributes (trait–environment)
│   ├─ CWM & fourth-corner (community weighted means, trait ~ environment)
│   └─ CWM-RDA & RLQ (three-table analysis: R env × L species × Q traits)
└─ Appendices: References, Animation of ordination, Artefacts in ordinations (arch/horseshoe, detrending)
```

Detailed ordination matrix from `en:ordination` [3]:

|              | (a) Raw-data classical | (b) Transformation-based | (c) Distance-based |
|--------------|------------------------|--------------------------|---------------------|
| **(1) Unconstrained (indirect)** Shiny `uncordi` | **PCA** (linear) / **CA & DCA** (unimodal) | **tb-PCA** (Hellinger/chord → Euclidean → Hellinger distance) | **PCoA**, **NMDS** (Bray/Jaccard → NMDS k-choice, stressplot) |
| **(2) Constrained (direct, canonical)** Shiny `conordi` | **RDA** / **CCA** | **tb-RDA** | **db-RDA** (PCoA eigenvectors → RDA) |

Key conceptual distinctions [3]:
- **Unconstrained** = gradients from species only, env fitted *post hoc* (envfit, supplementary variables) — exploratory, does not test hypothesis.
- **Constrained** = axes constrained by env, decomposes variance into explained/unexplained, enables `anova.cca`, `ordistep`, `varpart` — confirmatory.
- **Raw vs tb vs distance** = different handling of double-zero problem (Euclidean vs Hellinger vs Bray). Rule of thumb [Lepš & Šmilauer 2003]: run DCA first, gradient length >4 SD → unimodal (CA/CCA), <3 SD → linear (PCA/RDA), 3–4 either; else Hellinger-transform then linear is safe for heterogeneous data.

Diversity theory [4]: `p_i = abundance_i / Σ abundance`, `H' = -Σ p_i log p_i`, `D = Σ p_i²`, `GS = 1-D`, `ENS = exp(H)`, `Hill N_q`, evenness, diversity profiles [4]. TWINSPAN theory: CA-based recursive divisive, indicator species, pseudospecies cut levels, modified version divides only most heterogeneous cluster [5].

## 2. Ordin today vs AnaDat-R — gap map

| AnaDat-R block | Ordin 4.0 (ead9b5f) status — workflow `Data(1)→Diversity(2)→Beta(3)→Ordination(4)→Tests(5)→Results(6)` | Gap |
|---|---|---|
| **Data types / import / preparation / sampling design / resemblance** | `Data` panel: `FallbackDrop` naive CSV split + `ImportDialog` drag-drop + `sample dune/varespec/BCI` → `species{columns,rownames,matrix}` + `env{rows}` + DuckDB-WASM SQL Workspace snippet, `validateSpeciesMatrix ≥3×≥2 finite≥0` gated. Distance = `bray` select only in Ordination. | **No transformations** (Hellinger, chord, log1p, Wisconsin, standardize), no resemblance matrix UI, no NA handling, no trait table, no sampling design check. |
| **PCA / tb-PCA / CA/DCA / PCoA/NMDS** | `OrdinationPanel` 9 methods select (NMDS,PCA,CA,DCA,PCoA,CCA,RDA,dbRDA,CAP) but only **NMDS is wired** (`fetch sample-results.json` → nmds with stress/provenance). Other 8 are UI stubs. No tb- variants. No `metaMDS trymax/seed`, no `stressplot`, no `decorana` details, no `wcmdscale`. | Wire `vegan::rda/cca/decorana/wcmdscale` via webR Worker; add tb- options (Hellinger transform checkbox). |
| **RDA/tb-RDA/CCA/db-RDA + triplots + scaling** | Same panel stub, no triplot, no scaling 1/2, no eigenvalue table. | Need vegan `rda( spe ~ env )`, `cca`, `dbrda`, `capscale` + deck.gl triplot (sites=points, species=text, env=arrows) + explained variation table. |
| **Ordination diagrams** | Static `nmds.png` post-Run, description “deck.gl biplot” but not rendered. | Replace PNG with live `deck.gl ScatterplotLayer` (sites) + `TextLayer` (species) + `LineLayer` (env arrows) fed by `project.analyses.nmds.points`. |
| **Supplementary variables** (`envfit`) | `Tests` panel has `envfit` card (one of 4) but as hypothesis test, not as passive projection on unconstrained ordination. | Add `envfit` sub-flow in Ordination: unconstrained → `envfit(ord, env, perm=999)` → vectors/centroids + `r²` + `p.adjust`. Separate from constrained. |
| **Explained variation / scree** | Only `Stress 0.186 (Good)`. | Need eigenvalue barplot, cumulative %, scree (`NMDS.scree k=1:10 vs stress`), R²adj for constrained. |
| **Permutation test** (`anova.cca`) | `Tests` has PERMANOVA `adonis2` but not `anova(cca)` for RDA/CCA significance (overall / axis / terms). | Add `anova.cca(ordination, perm=999)` cards. |
| **Variable selection** (`forward.sel`, `ordistep`, `vif.cca`) | Not present. | Add forward selection UI (Blanchet double-stopping) + VIF table. |
| **Variation partitioning** (`varpart`) | Not present. | Add Venn diagram (2–4 groups) partitioning `fractions [a],[b],[c]` + tests. |
| **Cluster: hclust / kmeans** | Not present. | **New plugin/ panel** needed: `vegdist → hclust(method=single/complete/average/ward.D2)` → dendrogram (deck.gl? or d3), `kmeans/cascadeKM`, `cutree`. |
| **TWINSPAN** | Not present (R `twinspan/twinspanR` Windows-only .exe). | Need `twinspan` (Oksanen) via webR if FORTRAN compiled to WASM, or call `twinspanR` fallback with pseudospecies cut levels UI. |
| **Evaluation of classification** | Not present. | `silhouette`, `cophenetic`, `indval/multipatt` (`labdsv/indicspecies`). |
| **Diversity indices** | `Diversity` panel gated iNEXT + indices (Shannon/Simpson/Hill) via fixture, not live calc. | Complete Hill numbers 0,1,2, evenness J, ENS, diversity profiles curve, per-site table editable. |
| **Comparing diversity / rarefaction** | `iNEXT` card only. | Add `vegan::rarefy`, `specaccum`, `renyi`, diversity t-test. |
| **Beta partitioning** | `Beta` panel: `betapart::beta.pair` Sørensen turnover+nestedness → Sør 0.64. | Expand to pairwise + multi-site, Baselga family (Sørensen/Jaccard). Current is MVP. |
| **CWM / fourth-corner / RLQ** | No trait table at all. | **New Trait panel/ plugin**: `traits{taxa×traits}` + `CWM = traits^T %*% (species/rowSums)` + `fourthcorner` + `ade4::rlq`. Requires 3-table model. |
| **Animations / artefacts** | Help mentions artefacts not visualized. | Nice-to-have: animated NMDS stress iterations, arch effect demo. |

**Bottom line:** Ordin’s core 6 steps cover the *skeleton* (≈40% of AnaDat-R). The *muscle* — transformations, diagrams, explained variation, permutation/variable-selection/varpart, classification/TWINSPAN, full diversity, CWM/RLQ — is missing and too large to cram into 6 panels without bloating.

## 3. Should Ordin have a plugin system for statistical tools? **Yes — required**

### Why plugins beat monolith (lesson from AnaDat-R itself)
AnaDat-R [1] says the aim is *not* exhaustive — “I focus mostly on … those I found useful… in my purely subjective view” and the site is “constantly under construction” with locked exercise pages. Community ecology is *opinionated and expanding* (new beta-diversity, trait methods every year). A monolith that tries to ship all 30 wiki pages at once will:
- bloat download (vegan alone + dependencies ~30 MB WASM),
- confuse beginners (30 methods in one Ordination dropdown, as now),
- block contributors (adding `twinspan` requires fork).

**jamovi proves the alternative:** 6 core menus `Exploration/T-Tests/ANOVA/Regression/Frequencies/Factor` + `+Modules` (40+ R modules, each a standalone `jmv` library, syntax mode shows `jmv::ttestIS`) — same split. **JASP** does 8 top ribbons + `+R` modules. **QGIS / GeoLibre’s `whitebox` + DuckDB spatial** also ship as processing providers. Ordin should follow that.

### Proposed Ordin plugin architecture (Tauri-friendly)

```
ordin/
├─ packages/plugins  @ordin/plugin-sdk  ← new
│   ├─ manifest.schema.json  { id, name, version, author, kind: "ordination"|"classification"|"diversity"|"trait",
│   │                           vegan: ["vegan","betapart"],  webR: { packages: ["vegan"] },
│   │                           panels: [{ id: "twinspan", component: "./src/TwinspanPanel.tsx", mount: "classification" }],
│   │                           duckdb: { tables: ["species","env","traits"] },
│   │                           permissions: ["fs:read","webR:run"] }
│   ├─ loader.ts  — validates manifest (Zod), checks vegan R pkg availability via webR, installs from local `plugins/` or remote registry (GitHub release zip)
│   └─ registry.ts  Zustand `installedPlugins[]` persisted in .ordin.json `meta.plugins`
├─ apps/ordin-desktop/src/components/plugins
│   ├─ PluginHost.tsx  — error boundary + lazy import + webR worker compartment
│   └─ MarketplaceDialog.tsx  — list available (twinspan, varpart, cwm-rlq), one-click install
└─ workers/
    ├─ webr.worker.ts  — per-plugin Comlink namespace so `vegan::rda` from core doesn’t clash with `twinspan::twinspan`
    └─ duckdb.worker.ts — plugins can register SQL views: `CREATE VIEW traits_cwm AS ...`
```

**Kinds of plugins:**
- **Panel plugins** — add a new `ActivityBar` icon + `Sidebar` step (e.g., `Classification` adds step `3b` or `4a` between Beta and Ordination when installed). Core workflow stays `1→2→3→4→5→6` when no plugin, expands to 7–8 when plugins mounted — progress becomes `done / total` where `total` counts installed panels.
- **Method plugins** — inject into existing panel (e.g., `varpart` adds a “Variation partitioning” tab inside `Tests`, `tb-PCA` adds a transform toggle inside `Ordination`).
- **Compute plugins** — pure webR: `vegan`, `betapart`, `adespatial`, `indicspecies`, `ade4` (for RLQ). Each declares its R dependencies; `getWebR()` installs them from WASM repo on demand, not baked into core bundle.

**Security / perf:**
- Plugins run in workers (never main thread), timeout 30s, revokable.
- `validateSpeciesMatrix` still gates plugin Runs (enterprise provenance `ranAt + provenance` written to `project.analyses[pluginId]` so Results bundle stays reproducible).
- Versioned: `.ordin.json` stores `meta.plugins: [{id:"twinspan", ver:"1.0.1", r: "twinspan 1.2"}]` → re-run on another machine re-installs same ver.

**Marketplace (local first):** `plugins/` folder shipped empty; user drag-drops `.ordin-plugin.zip` (contains `manifest.json + panel.js + R wrapper`). Later, remote registry `plugins.ordin.app/index.json` lists reviewed plugins (like jamovi library) — no auto-update, explicit install.

**Without plugins, Ordin would need to ship all of AnaDat-R at day 1** → 290k gz82k would become >600k, with many rarely-used methods (TWINSPAN is niche to vegetation ecologists). Plugins keep core lean and let labs install exactly their syllabus (e.g., NTU course installs `twinspan + varpart + RLQ`).

**Verdict:** *Yes — plugins are not optional if Ordin wants to faithfully mirror AnaDat-R.* Core = the 6 gated steps; plugins = the remaining ~60% of wiki pages.

## 4. Spreadsheet like Airtable — feasible, where to put it

### What “like Airtable” means (vs plain `<table>`)
- **Inline editing**: double-click cell → edit, enter to commit, undo
- **Column types**: Text, Number, Single Select (e.g., `Management = SF/BF/ME/HE/HF/LE`), Multi-select, Date, Attachment, Formula (`=TOTAL species`), Linked record (species → trait)
- **Views**: Grid (default), Filtered (`Management=SF`), Sorted (`Moisture desc`), Grouped (`Group by Management`), Gallery/Kanban (not needed for ecology but nice)
- **Computed columns** (`Row sum = Σ species`, `Shannon` live)
- **Undo / validation** (≥0, numeric, no NA) + `validateSpeciesMatrix` live badge
- **Sheet tabs**: like Airtable base: `Species` (sites×taxa) + `Env` (sites×vars) + `Traits` (taxa×traits) for CWM/RLQ

Ordin’s current `Data → Data Preview` is a *read-only* `<table>` capped at `10/25` rows [DataPanel.tsx], `FallbackDrop` naive CSV split, no editing. To become ecological “Base”, it needs to be *the* notebook.

### Where to put it — three options evaluated

| Location | Pros | Cons | Verdict |
|---|---|---|---|
| **A. Enrich existing `Data` panel’s preview area (center canvas)** — replace `<table>` with full-height Airtable grid + sheet tabs at bottom (`Species | Env | Traits`) + toolbar (Add row/col, Filter, Sort, Group, Import, Duplicate). Sidebar stays `EXPLORER—WORKFLOW`, center is the editable base. | Keeps workflow linear `1 Data` → editing is step 1, no new top nav, `validateSpeciesMatrix` badge updates live, DuckDB-WASM stays source of truth, collapsible sidebars give full width when editing (like jamovi’s `Data` tab which *is* the spreadsheet). No new concept to learn. | `Data` panel becomes dense (Import + Sheet + SQL). Needs virtualization for BCI 50×225+. | **✅ Recommended** — best teaching flow, matches `jamovi Data = spreadsheet`; AnaDat-R’s chapter `Data types and import` + `Preparation` *is* step 1. |
| **B. New top-level panel `Sheet` / `Base` (ActivityBar icon between Data and Diversity)** — dedicated full-screen spreadsheet, Data stays importer only. | Maximum space, could host Kanban/Gallery later, feels like Airtable app. | Splits “data” into two panels (confusing: where do I edit vs import?), breaks `Data→Diversity→…` 6-step narrative, adds another rail icon already at 7. | ❌ Not now — only if base grows to >10 tables. |
| **C. `RightInspector` or popup dialog** — spreadsheet as 340px inspector or modal | Quick glance without leaving analysis | Far too narrow for 30 taxa, no room for filters; popups are for `Import`/`Command palette`, not for full base. | ❌ |

**Recommendation: A — evolve `Data` panel center into Airtable, keep `Data` as step 1.**

### How it would look in Ordin (proposed layout)

```
┌─ ActivityBar (52px) ─┬─ Explorer 320px ─┬─ Data (center, when panel=data) ─┬─ Inspector 340px ┐
│  Dashboard            │  1 Data ●        │  ┌─ Toolbar: +Row +Column Filter Sort Group Undo Validate OK ┐ │ Details/Env/SQL   │
│ *Data                  │  2 Diversity ○  │  │  Tabs: [ Species (20×30) | Env (20×5) | Traits (30×4) ]     │ │                 │
│  Diversity            │  3 Beta ○       │  │  ┌─────────────────────────────────────────────────┐  │ │  Species: Achillea  │
│  Beta                 │  4 Ordination ○ │  │  │ Glide Data Grid — canvas, virtualized           │  │ │  mean 3.2 ±...    │
│  Ordination           │  5 Tests ○      │  │  │ Site | Ach_mil | Agr_sto | ... | Management▾    │  │ │  CWM: Height ...  │
│  Tests                │  6 Results ○    │  │  │ 1    |  1       |  0       | ... | SF (select)   │  │ │                 │
│  Results              │  QUICK ACTIONS  │  │  │ 2    |  3       | 12       | ... | BF            │  │ │  SQL preview    │
│                       │  WORKSPACE live │  │  └─────────────────────────────────────────────────┘  │ │                 │
│  Settings/Help        │                  │  │  Bottom: `DuckDB: SELECT * FROM species WHERE …`           │ │                 │
└───────────────────────┴──────────────────┴──────────────────────────────────────────────────────┴─────────────────┘
```

* Sheet tabs* at bottom switch underlying DuckDB table (`species`, `env`, `traits`). Column headers show type icon (hash=number, `A`=text, `▾`=select) and allow drag to reorder, right-click to `Insert left / Delete / Duplicate / Hide`.
* Filter bar like Airtable: `+ Add filter → Management is SF` translates to DuckDB `WHERE Management='SF'` and Zustand selector.
* Group like Airtable: `Group by Management` → collapsible sections (`BF 3 sites`, `SF 5 sites`) — useful for seeing composition per association before ordination.
* Formula column: `Shannon = -SUM(p*LOG(p))` computed in webR `vegan::diversity` or in DuckDB `SELECT -SUM(p*LN(p))` per row, updates live.
* Validation: edited cell that makes `species matrix` have NA/negative/too few sites → `validateSpeciesMatrix` → Explorer badge `Validation blocked` + Run disabled + toast “Species matrix invalid: row 7 col Agr_sto = -1”.

### Tech choice for the grid

| Grid | Pros | Why fit Ordin |
|---|---|---|
| **Glide Data Grid** (`glideapps/glide-data-grid`, canvas, MIT) | Canvas-drawn, handles 100k+ cells at 60fps, used by Neon/DuckDB UIs, supports custom cells (dropdown, sparkline), row virtualization, undo. Tauri-friendly. | **Top pick** — same philosophy as deck.gl (GPU) and DuckDB-WASM (browser SQL) — high perf for BCI 225 taxa. |
| AG Grid Enterprise | Feature richest (pivot, aggregation) but 50k DOM nodes, heavy licence, overkill for matrix. | Only if need enterprise pivot. |
| Handsontable | Excel-like formulas, but DOM + slower with 225 cols | Okay for small dune, not BCI. |
| TanStack Table + virtual | Flexible but need to build editing/filter ourselves | Could compose but more work. |
| Univer / Luckysheet | Full Excel clone — too much (charts, merges) not needed | No. |

**Backing store:** `DuckDB-WASM` (`@duckdb/duckdb-wasm 1.33`) + `apache-arrow`. Flow: `File drop → DuckDB read_csv/read_parquet → Arrow → Glide rows` (typed). On inline edit → write through `Zustand setSpecies` (validates) + `DuckDB UPDATE species SET Ach_mil=... WHERE rowid=...` → both stores stay sync, so `Results .ordin.json` is truth but SQL workspace can still query `SELECT Management, AVG(Moisture) FROM env GROUP BY 1`.

**Implementation phases:**

- **M0 (2 weeks):** replace `DataPanel.tsx` `<table>` with `Glide Data Grid` read-only, 2 tabs Species/Env, column types inferred (text vs number), row virtualization to 500 rows, `Filter/Sort` via DuckDB `WHERE/ORDER BY`. No edit yet.
- **M1:** inline editing (double-click → `NumberField` with ≥0 clamp), `+Row/+Column`, `Delete`, undo stack, live `validateSpeciesMatrix` + Inspector detail `mean/ sd per species`.
- **M2:** Airtable goodies: `Single Select` for `Management` (edit enum), `Group by`, `Formula column` (row sums, Shannon HL calc via webR), import `traits` table + link (`Traits` sheet where taxa rows link to `Species` columns) to unblock CWM/RLQ plugins.
- **M3:** Save/load `.ordin.json` includes `data.species + env + traits` + column meta (types, filters, groups) — so sharing a project preserves the view state like Airtable base.

## 5. Best overall approach to implement *all* AnaDat-R — phased roadmap

This keeps your reordered `Data(1)→Diversity(2)→Beta(3)→Ordination(4)→Tests(5)→Results(6)` core stable, and adds extras as plugins or core sub-tabs.

### Phase 0 — Foundation (2–3 weeks) — *Airtable Data*
- Glide grid in `Data` as above, 3 sheets Species/Env/Traits, DuckDB as truth, validation, import Parquet via `read_parquet`.
- Data prep helpers: `Hellinger`, `chord`, `log1p`, `Wisconsin`, `standardize` as row in `Data → Transform` popover (transformation-based approach [3]).
- Expose `ecological resemblance` matrix picker (Bray, Jaccard, Euclidean, Hellinger, chi-square) as DuckDB `vegdist` equivalent (store as `distance` param for PCoA/NMDS/db-RDA).

### Phase 1 — Complete ordination (3–4 weeks) — *core*
- Wire webR: `vegan::rda`, `cca`, `decorana` (DCA), `wcmdscale` (PCoA), `metaMDS(trymax=100)`, `capscale` (+ `dbrda`), Hellinger transform path (`vegan::decostand`).
- Replace `nmds.png` with live `deck.gl` ordination (points + text + arrows), scaling 1/2 toggle, scree plot for NMDS/PCoA.
- Add sub-tabs in `Ordination`: `Unconstrained` vs `Constrained` vs `Diagrams` vs `Explained variation` (eigenvalues, %).
- Add `Supplementary variables` (`envfit(perm=999)` with p.adjust) as passive vectors/centroids feature.

### Phase 2 — Inferential ordination (2 weeks) — *core Tests*
- `Permutation test` (`anova.cca`, `anova.cca(by="axis")`, `by="terms"`) → new `Tests → Permutation` cards.
- `Variable selection` (`ordistep`, `ordiR2step`, `vif.cca`) → stepwise UI with forward/backward + VIF table.
- `Variation partitioning` (`vegan::varpart` with 2–4 groups, `varpart::plot` → Venn) → new Venn diagram panel in `Tests`.

### Phase 3 — Classification (3 weeks) — *first plugin: `ordin-classification`*
- `hclust` agglomerative (methods: `single, complete, average, Ward.D2, centroid`) → d3 dendrogram (not deck.gl), `cutree k=2..10`, `fviz_nbclust`.
- `k-means` (`kmeans`, `cascadeKM`) + elbow/silhouette.
- `TWINSPAN` via `twinspan` (Oksanen) WASM build; fallback `twinspanR` cut levels UI (pseudospecies 0,2,5,10,20).
- Evaluation: `cophenetic`, `silhouette`, `labdsv::indval` / `indicspecies::multipatt`.

### Phase 4 — Diversity complete (1–2 weeks) — *Diversity panel upgrade*
- Hill numbers `q=0,1,2`, ENS, Pielou `J`, diversity profiles `renyi`, evenness, per-site table editable + formula column.
- `specaccum`, `rarefy`, comparison tests.

### Phase 5 — Trait–environment (2 weeks) — *second plugin: `ordin-traits`*
- Requires trait sheet from Phase 0. Implement `CWM` (matrix multiply), `fourthcorner`, `ade4::rlq` + `fourthcorner.rlq`. UI in new `Traits` panel (mounted as `5b` between Beta and Ordination when plugin installed).

### Phase 6 — Polish & marketplace (ongoing)
- Animation of ordination (`rgl` trace), artefacts page (horseshoe/arch demo).
- Plugin SDK `manifest.schema.json` + `MarketplaceDialog` + `plugins/ordin-classification.zip` example.
- `docs/ENTERPRISE-AUDIT` extension: per-analysis `RPackageVersion` provenance, seed control, `set.seed` for NMDS.

### What stays core vs plugin — final line

| Stay core (always installed) | Plugin |
|---|---|
| Data (import, validate, Glide grid, resemblance), Diversity (Hill/iNEXT), Beta (Sør), Ordination unconstrained+constrained basics (PCA/CA/DCA/PCoA/NMDS/RDA/CCA/db-RDA) + diagrams, Tests (PERMANOVA, permutation test), Results bundle | `classification` (hclust/TWINSPAN/kmeans + eval), `varpart` advanced, `trait-rlq` (CWM/fourth-corner/RLQ), `div-comparison` deep, `animation-artefacts` |

This gives a new user a working ecologist workbench on first launch (covers 80% of syllabus), power users install `+Classification` and `+Traits` like jamovi `+Modules`.

---

## 6. Concrete next steps you can ship this week

1. **Create `docs/ANADAT-R-ROADMAP.md` (this file)** and link from `README`.
2. **Scaffold `@ordin/plugin-sdk`** empty (`manifest.schema.json` + `PluginHost` stub) so future `twinspan` doesn’t require core refactor.
3. **Prototype Glide grid** in `DataPanel`: branch `feat/airtable-grid`, replace `<table>` with read-only Glide for species 20×30, add `Env` tab, measure perf on BCI 50×225. If smooth, enable inline edit M1.
4. **Add transformation row** in `Data → Transform` popover: checkbox `Hellinger` (preview `decostand(species, "hell")` via webR) — unlocks tb-PCA/tb-RDA without new panel.
5. **Wire one missing ordination** (`vegan::rda`) via same `runNMDSViaWebR` path to prove pipeline, then replicate to `cca/dbrda`.

Preview is live on `:9054` with reordered workflow; these phases can land incrementally without breaking that workflow.

---

*AnaDat-R is CC-like open wiki by David Zelený (NTU) — method names, R functions (`vegan`, `betapart`, `ade4`, `labdsv`, `twinspan`) and the DCA 3–4 SD rule are his synthesis of `Lepš & Šmilauer (2003)` + `Legendre & Legendre (2012)` + `Legendre & Gallagher (2001)`; this roadmap maps them 1:1 to Ordin’s Tauri+webR+deck.gl+ DuckDB stack.*

