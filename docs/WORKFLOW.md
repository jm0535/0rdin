# Ordin 4 — Workflow (JASP/jamovi-informed, R/Python-mapped) — 2026-09-25

> How Explorer connects Data → Ordination → Diversity → Tests → Beta → Results as an **explicit, gated, auditable pipeline** — like an R script, with the discoverability of JASP/jamovi. Enterprise rule: **no result before Run**.

## 1. Why a workflow — the problem you saw

Before this redesign the Explorer was a flat link list (`DATA SOURCES / WORKSPACE / ANALYSES / RECENT`) with every graph pre-rendered on page load (`nmds.png`, `beta.png` …) even with no data. That breaks the core contract of statistical tooling: inputs → assumptions → explicit compute → auditable output. This doc explains the fix and how to use it.

## 2. Research — JASP & jamovi (and what we kept / changed)

We studied the two state-of-art GUI stats platforms (sources in `session memory`).

### JASP (`jasp-stats.org`)
- **Ribbon top** (Descriptives, T-Tests, ANOVA, Regression, Frequencies, Factor, Bayesian). Click a ribbon button → analysis is *appended below the previous output*, data table stays visible.
- **Split vertical** — data spreadsheet **left**, results **right**. Two panes scroll independently.
- **Live update** — toggling an option instantly re-runs and reflows the output; no OK/Cancel. Reopen an analysis by clicking its output.
- **.jasp file** saves **data + every analysis + results + annotations/notes**. APA-ready copy.

### jamovi (`jamovi.org`, `docs.jamovi.org`)
- **Four tabs** `Variables | Data | Analyses | Edit`. `Analyses` hosts a **ribbon** (`Exploration, T-Tests, ANOVA, Regression, Frequencies, Factor`) plus **+ Modules** (40+ R packages: `jmv`, etc).
- **Left = assignment, Right = output.** Variable list → drag-drop into Roles (Dependent, Factors, Covariates). Result stack grows downward; annotate between outputs.
- **Shortcuts** `Alt+S` Variables, `Alt+D` Data, `Alt+A` Analyses. **Syntax Mode** shows the underlying R (`jmv::ttestIS(...)`). **Rj Editor** exposes `data` dataframe for arbitrary R.
- **.omv** bundles data + analyses + outputs similarly.

### What Ordin borrows

| Pattern | Ordin mapping |
|---|---|
| **VS-code-like shell** (activity bar → explorer → editor → inspector) | `ActivityBar` (vertical app switcher) + `Sidebar Explorer` (left) + `Toolbar + Canvas` (center, paper grid not map) + `RightInspector` (right: Details/Env/SQL) — same UX quality as GeoLibre, **statistical content only**. |
| **Ribbon / quick actions** | Explorer header `EXPLORER — WORKFLOW` plus `QUICK ACTIONS — like JASP ribbon` grid (Data / Import / Run next / Results) and `⌘K` Command Palette. Central `Dashboard` also exposes quick cards. |
| **Split data/results** | Explorer **shows workflow state**; center panel **is the result stack** per analysis (JASP's right pane idea, but one analysis at a time with Next/Prev navigation). |
| **.jasp / .omv bundle** | **`.ordin.json`** — `project: {meta, data: {species, env}, analyses, view, version}` with per-analysis `method/distance/k + ranAt + provenance`. Single source of truth, reproducible, downloadable in `Results`. |
| **Progressive disclosure** | Empty → Warning → Dashed "No results yet → Run CTA" → Only-after-Run plot + `Ran at · provenance`. Minimal tables until asked. |

### What we changed (enterprise audit)

- **Gated not live.** JASP/jamovi re-run on every click (great for exploration). Ordin **requires an explicit `Run`** and persists the result with `ranAt`. Nothing renders before Run — even if `sample-results.json` exists on disk. Enables validation (≥3 sites, ≥2 species), avoids phantom p-values, and gives audit trail per Rad/CRAN provenance.
- **Linear workflow with dependencies** (next section) rather than free-append. Ordination/Tests/Beta **disable** until `hasData` (validated matrix). `Results` disables until `hasAnyResult`. This mirrors how an **R/Python script fails fast** without data.

## 3. R / Python reference pipeline

```r
# R — canonical vegan workflow (the single source of truth for our panels)
library(vegan); library(iNEXT); library(betapart)

# 1. Data — long → wide matrix, NA → 0, validate
dune <- read.csv("sample-data/dune_species.csv", row.names=1)  # 20 sites × 30 spp
env  <- read.csv("sample-data/dune_environment.csv", row.names=1)
stopifnot(nrow(dune) >= 3, ncol(dune) >= 2)                     # Ordin: validateSpeciesMatrix()

# 2. Ordination — scree → metaMDS → stress → envfit
library(vegan); d <- vegdist(dune, "bray")
NMDS.scree(d, k=1:6)                                            # pick k
set.seed(33); ord <- metaMDS(dune, distance="bray", k=2, trymax=100)
stressplot(ord); ord$stress  # <0.1 excellent, <0.2 usable
envfit(ord, env, perm=999); ordiellipse(ord, env$Management)

# 3. Diversity — iNEXT + indices
library(iNEXT); inext(dune, q=0:2, datatype="abundance") # rarefaction/extrapolation
diversity(dune, "shannon"); specnumber(dune)

# 4. Tests — hypotheses on communities
adonis2(dune ~ Management, data=env, permutations=999, method="bray") # PERMANOVA
anosim(dune, grouping=env$Management, distance="bray")
mantel(d, dist(env$Moisture))

# 5. Beta — turnover vs nestedness
library(betapart); beta.pair(dune, index.family="sorensen")  # → turnover + nestedness = Sorensen

# 6. Report — reproducible bundle
# Ordin: project → .ordin.json + copyable APA tables
```

```python
# Python — analogous (skbio + scanpy style) — Ordin's Data → DuckDB part replaces pandas, webR replaces skbio
import pandas as pd; from skbio.diversity import alpha_diversity, beta_diversity
from skbio.stats.ordination import pcoa
species = pd.read_csv("dune_species.csv", index_col=0)
assert species.shape[0] >= 3 and species.shape[1] >= 2
bc = beta_diversity("braycurtis", species.values, ids=species.index)
ord = pcoa(bc)  # vs R metaMDS — Ordin normalizes on webR/vegan for parity
```

## 4. Ordin workflow — the 6 steps

```
┌─────────────────────────────────────────────────────────────────────────┐
│  1  Data            Import & validate  → enables everything             │
│  │   CSV/Parquet via DuckDB (GeoLibre pattern, now for eco tables)     │
│  ├── 2  Ordination  9 methods via webR · vegan (+ stress)              │ ──┐
│  │   NMDS·PCA·CA·DCA·PCoA·CCA·RDA·dbRDA·CAP · deck.gl biplot              │   │
│  ├── 3  Diversity   iNEXT + Shannon/Simpson/Hill · via webR               │   ├─ require hasData (validated matrix)
│  │                                                                       │   │
│  ├── 4  Tests       PERMANOVA(adonis2) · ANOSIM · Mantel · envfit        │ ──┘
│  │                          best after Ordination, needs Data + env        │
│  ├── 5  Beta        Sørensen = turnover + nestedness · betapart            │
│  │                                                                         │
│  └─► 6  Results     .ordin.json (auditable) · APA export & share           │
│                     requires ≥1 explicit Run  (blocked → ready → done)      │
└─────────────────────────────────────────────────────────────────────────┘
     R equivalents per panel are shown as muted hints in the UI.
```

### Dependency table

| Step | Requires | Why (R/Python) | UI signal |
|---|---|---|---|
| **1 Data** | — | `read.csv` + `validate_species_data()` | Progress `0/6`, badge `— empty —` → `20×30` on success, `WORKSPACE live` green OK |
| **2 Ordination** | Data valid (≥3×≥2) | `vegdist` / `metaMDS` needs matrix | `Lock` dashed blocked until Data → then badge `9 methods` / `stress 0.186` when done, hint `Rank-1 in R: metaMDS(dune) → stress → envfit` |
| **3 Diversity** | Data | `iNEXT(species)` | Same gating, badge `iNEXT` → `iNEXT done` |
| **4 Tests** | Data (+ Ordination recommended) | `adonis2(dune ~ Management)`; envfit overlays ordination | `Requires Data (+ Ordination)` — runs without ord but warns; badge `adonis2` → `p < 0.05 available` |
| **5 Beta** | Data | `betapart::beta.pair` | `betapart` → `Sør 0.64` |
| **6 Results** | ≥1 analysis | Reproducible report | `— none yet —` → `3 analyses`, Download .ordin.json only when hasAnyResult |

## 5. UI implementation

### Sidebar — `Explorer — Workflow` (stepper, not flat links)

- **Progress bar** `done/6 done` → `width: (done/6)*100%` forest green `#2e8b57`.
- **Vertical line** left + **step rows**:  `dot (Lock / icon / Check)` · `label + badge right` · `desc` · `hint/requires` line. States:
  - `blocked` (needs prerequisite) → `border-dashed opacity-60 cursor-not-allowed`, Lock, tooltip `Blocked — requires …`, click disabled.
  - `ready` → solid `bg-[#252526] hover:bg[#2a2a2a]`.
  - `active` (current `project.view.activePanel`) → `bg-[#2e8b57] text-white shadow`.
  - `done` (has result) → dot `bg-[#2e8b57] Check`, badge `bg-white/20` (stress / Sør / counts).
- **Filter** `Filter workflow…` matches `label + desc`.
- **QUICK ACTIONS — like JASP ribbon** — 2×2 buttons `Data / Import (popup) / Run next / Results` + `R equivalent:` explainer `dune <- read.csv(); metaMDS; iNEXT; adonis2; beta.pair()` — note: each panel has explicit `Run` with provenance + `.ordin.json` lineage; JASP auto-updates live, Ordin gates for audit.
- **WORKSPACE — live** — Species `20×30` / Env `5 vars` / Validation `OK|blocked|— no data —` (derived from `validateSpeciesMatrix`), not hardcoded.
- **Bottom** `Project: dune • .ordin.json • 3 analyses • reproducible`.

### ActivityBar — app switcher (order = workflow)

`Dashboard (1) | Data (2) | Ordination (3) | Diversity (4) | Tests (5) | Beta (6) | Results (7)` → vertical 52px rail, `⌘K` palette on top, Settings/Help bottom. Aligns with stepper order (changed from diversity↔ordination).

### Center — `WorkflowFooter` on every analysis panel

```tsx
// ORDER: [data, ordination, diversity, tests, beta, results]
// prev/next Buttons, next disabled if !hasData && next !== data
// breadcrumb Workflow: Data → Ordination → Diversity → Tests → Beta → Results (active bold green)
```

Appears as muted pill `mt-6 rounded-xl border bg[#252526]/60 p-3`. Disabled state `opacity-50 cursor-not-allowed` + title `Requires Data — import & validate first`.

### Center panels — gated states

1. `!hasData` → amber warning `No data. Load a dataset first (Data → Sample → dune or Import file…). Nothing is computed until you explicitly Run.`
2. `hasData && !hasResult` → dashed Card `No X results yet → Configure & Run. … No phantom graphs.` + primary `▶ Run … (webR)` CTA (or per-method in Ordination with Method/k/Distance).
3. `hasResult` → grid `Plot — deck.gl … (bg-white)` + `Stats — auditable (stress / Ran at / provenance)` + `↻ Re-run` (same button now enabled). No static PNG before this state.

`OrdinationPanel` additionally gates `nmds` via `project.analyses.nmds` with `method/distance/k/ranAt/provenance` (enterprise) and deck.gl description `same GPU layer GeoLibre uses for vector tiles, here for NMDS points + env-vector arrows`.

### RightInspector — companion to workflow

`Details / Env / SQL` tabs: `Details` shows project meta + `LAST ORDINATION` gated preview (dashed `No ordination yet — go to Ordination → Run` otherwise preview + `stress`), + reproducibility R snippet. `Env` shows env table aligned rows. `SQL` shows DuckDB-WASM workspace (same engine GeoLibre uses, no map): `read_csv/read_parquet` on eco tables — current snippet, real editor scaffolded.

### Popups

- **ImportDialog** — drag-drop CSV/Parquet (DuckDB), Browse, Quick samples `dune/varespec/BCI`; centered modal `bg-black/55 backdrop-blur`, triggers `setSpecies` validated + clears analyses.
- **CommandPalette** `⌘K` — `NAV` (go to any of the 6 steps) + `Quick Actions` (Import / Load dune / SQL).

### .ordin.json — the reproducible bundle

Saved via `Results → ⤓ Download .ordin.json` or `Inspector Details → Copy .ordin.json`. Contains `meta.name`, `data.species {columns, rownames, matrix}`, `data.env`, `analyses {nmds: {stress, grade, points, method,distance,k,ranAt,provenance}, diversity, permanova_nmds, …, beta}`. Clearing `analyses` on `loadSample` / new `setSpecies` ensures lineage is not polluted.

## 6. How to run a workflow (happy path)

1. Fresh load → `Sidebar 0/6`, all downstream steps `Lock blocked`, `Data` shows `No data`.
2. `Data` → `FallbackDrop` a CSV or `Sample → dune` (or `⌘K → Load dune`) → `WORKSPACE live` `20×30 OK`, `Progress 1/6`, `Ordination/Diversity/Tests/Beta` unlock to `ready`.
3. Click **2 Ordination** (Stepper or ActivityBar or WorkflowFooter Next). Set `Method=NMDs, k=2, Distance=bray` → `▶ Run NMDS` → gated grid appears: biplot + `Stress 0.186 (Good) — vegan::metaMDS via webR Worker … • Ran at <time>`. `Tests` hint now `Tests fit on ordination (…)`.
4. **3 Diversity** → `▶ Run iNEXT` → rarefaction + indices.
5. **4 Tests** → per-card `▶ Run PERMANOVA` (etc) → `p / pseudo-F` appears only now.
6. **5 Beta** → `▶ Partition Beta` → `Sør 0.646 = turnover + nestedness` bar.
7. **6 Results** → `3 analyses stored · 20×30 · dune` + `Download .ordin.json`. Inspect provenance; share.

Navigate any time with `WorkflowFooter ←/→` or `ActivityBar 2..7` or `⌘K`. Re-run any analysis with `↻` — overwrites that key with fresh `ranAt`.

## 7. What we deliberately didn't clone from JASP/jamovi

- No live recompute on option drag — enterprise trade-off for auditability and to keep the `hasData` gate. A future `Live (JASP mode)` toggle could stream webR results, keeping the current gated mode as `Audited (default)`.
- No drag-drop variable roles in-left (our matrix is wide species: sites × taxa). `Data` preview is read-only table; assignment lives in test `~` formulas later.
- No APA copy per table yet (stub in Results JSON) — next: per-card `Copy APA` + inline annotations between outputs (jamovi style).

## 8. Verification checklist

- No `hasData` → no PNG, no `Download`, no `provenance` line; every Run button `disabled` (footer Next too disabled with title).
- After `loadSample('dune')` → `validateSpeciesMatrix` passes → steps 2–5 unlock, `Results` still `— none yet —` with `Go to Ordination/Diversity`.
- After each `Run` → that step dot `Check`, badge updates (`stress…`, `Sør…`), `Results` count increments, `.ordin.json` contains that entry.
- Deep link: `Sidebar filter=tests` narrows to Tests row, `ActivityBar 5` opens Tests, `WorkflowFooter → Results` jumps, all gated correctly.

---
*Teams: this is the contract to test.* `validateSpeciesMatrix ≥3×≥2`, `loadSample clears analyses`, `Run writes ranAt+provenance`, `render gated`. Future work: wire real `packages/processing.getWebR` + `@duckdb/duckdb-wasm` Worker, replace fixture PNGs with live deck.gl scatter, add Syntax Mode mirroring R.

