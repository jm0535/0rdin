# Ordin 4.0 — Stack Audit (2026-09-26)
> **Goal:** lightweight hybrid of **CANOCO 5 + vegan + iNEXT** that runs **anywhere** — `ordin.in4metrix.dev` (Vercel, webR WASM) + **Tauri desktop** (bundled offline, same webR) + **future PWA/mobile**. Real `R` on your data, publication figures, mock fallback only in the `E2B` iframe preview.

Source: `canoco5.com` + `CAN OCO 5 Arrives.pdf` (Microcomputer Power, Ter Braak & Šmilauer) + CRAN (`vegan 2.7-5/2.7-6`, `iNEXT 2.0.20`, `betapart 1.6.1`, `adespatial 0.3-23`, `FD`, `ape`, `picante`, `cluster`) + `WEGAN (Front. Ecol. Evol. 2025)` cross-coverage table. Verified: `ordin-desktop vite 5`, `webR 0.4.2`, `DuckDB-WASM 1.33`.

## 1. What CANOCO 5 is (context, not target)
- **All ordination family in one project:** `PCA`, `RDA` (+ partial), `CA`, `DCA`, `DCCA`, `CCA` (+ partial), `PCoA`, `db-RDA` (11 distances: Bray-Curtis, Jaccard, Gower…), `NMDS`, `CoCA` (symmetric, two communities), `PRC` — with **Canoco Adviser** picking linear vs unimodal by `DCA gradient length <3 → linear (PCA/RDA) else CCA` [Ter Braak rule].
- **Constrained testing done right:** Monte-Carlo permutation with **correct restricted design** for hierarchical / split-plot / time series (via `permute` in `R`), **forward selection** with `FDR/Holm/Bonferroni`, **variation partitioning 2–3 groups** (`varpart`), individual fractions, `PCNM/dbMEM`, `Procrustes` comparison of ordinations, **loess/GLM/GAM** surfaces (`ordisurf`).
- **Why CANOCO mattered:** integrated **spreadsheet + analyses + CanoDraw** in one `.con` project; Ordin copies the **project** idea (`.ordin` = data + analyses + results + provenance) and the **Data→Transform→Choose→Constrain→Test→Visualize** flow — but **browser-native, R-verified, reproducible `R` script per panel** (WEGAN-style history).

## 2. Canonical packages in 2025–2026 (latest common best)

| Domain | **Primary (must)** | Why / version | Complement | Used in Ordin panel |
|---|---|---|---|---|
| **Diversity alpha + Hill + rarefaction** | **`iNEXT` 3.0 / `iNEXT.3D` + `vegan`** | Hill unified framework `q=0 richness / q=1 exp(Shannon) / q=2 inv(Simpson)`, sample-size (`type 1`) vs sample-coverage (`type 3`) vs completeness (`type 2`), CI `nboot/conf`, `endpoint NULL→2×`, `knots 40`, `datatype abundance/incidence(_raw/_freq)` — `Hsieh et al. 2016 MEE`. `vegan::diversity/renyi/specpool/estimateR/rarefy/specaccum` for quick indices. | `MeanRarity`, `hillR` | **Diversity (2)** — `runInextViaWebR()` already |
| **Dissimilarity + beta (pairwise)** | **`vegan::vegdist` + `adespatial::beta.div.comp` + `betapart::beta.pair`** | `vegdist` 20+ indices (`bray`/`jaccard`/`kulczynski`…), `beta.div.comp(J/S, quant, coef= Podani/Baselga)` → `Repl + RichDiff/BDtotal`, `betapart` Baselga turnover/nestedness (`beta.pair`, `beta.multi` multi-site). Latest `betapart 1.6.1 (2025-07)`, `adespatial 0.3-23`. | `adespatial::beta.div` (`Var(Y)` = Whittaker), `LCBD/SCBD` | **Beta (3)** |
| **Ordination unconstrained** | **`vegan: rda` (PCA, scaling 1/2), `cca`, `decorana` (DCA), `metaMDS` (monoMDS+vegdist), `wcmdscale/cmdscale` (PCoA), `dbrda/capscale`** | Covers CANOCO's full list. `vegan 2.7-5 (2026-05-25)` latest. Adviser rule `decorana axis1 length` → pick. | `ade4::dudi.*`, `labdsv` | **Ordination (4)** |
| **Ordination constrained** | **`vegan: rda/cca/dbrda + ordiR2step (forward), varpart (2-3), envfit, ordisurf, ordiellipse, ordispider`** | CANOCO's RDA/CCA/partial, `varpart`, stepwise `ordiR2step` with `R2adj` + `p.adjust`. | `adespatial::dbMEM / PCNM`, `adespatial::aem` | **Ordination (4) constrained** |
| **Permutation / hypothesis** | **`vegan::adonis2 (PERMANOVA), betadisper (PERMDISP), anosim, mantel/mantel.partial, anova.cca (permutation), permute::how`** | Correct restricted permutations (`permute` `how(blocks/plots/within)`). `pairwiseAdonis` for pairwise. | `RRPP` | **Tests (5)** |
| **Clustering / classification** | **`cluster + vegan: hclust (ward.D2), kmeans, cascadeKM, vegclust`** | Covers PC-ORD/TWINSPAN territory lite. `twinspanR` if needed (heavier). | `labdsv` | **Classification plugin** |
| **Trait / functional / phylo** | **`FD::dbFD (FDis/Rao), picante::pd/mpd/mntd, ape, vegan::treedive`** | CANOCO 5.1 traits + phylogenetic CoCA. | `betapart::functional.beta.*`, `iNextPD` | **Traits plugin** |
| **Joint modelling (future)** | **`Hmsc` / `boral`** | Hierarchical JSDM (traits+phylo+space) — too heavy for WASM now (Gibbs+C++), keep as **desktop sidecar** post-1.0. | `mvabund` | Roadmap |
| **Graphics** | **`ggplot2 + vegan::ordiplot + ggiNEXT`** | Ordin's `SVG` already mirrors `ggiNEXT` faceting (`facet.var=Order.q`) + `vegan` biplot/triplot. | `patchwork` | all |

> **Rule of thumb from WEGAN audit (2025, 22 sub-categories):** `vegan` covers **18/22**, `betapart`+`adespatial`+`iNEXT` fill the remaining diversity/beta/transform gaps → **95%** of a community ecologist's routine. That is Ordin's `1.0` target.

## 3. Ordin → CANOCO mapping (today vs 1.0)

```
CANOCO 5 project          → Ordin project  (.ordin = DuckDB Parquet + JSON, see packages/core)
Spreadsheet editor          → Data (1): grid + decostand (hellinger/chord/log) + transform preview
DCA gradient length adviser → Ordination (4): decorana → auto-suggest PCA/RDA vs CA/CCA
Unconstrained (PCA/CA/DCA/PCoA/NMDS) → Ordination unconstrained (vegan wrappers, deck.gl triplot)
Constrained (RDA/CCA/dCCA/partial/dbrda) → Ordination constrained + varpart + ordiR2step
Monte-Carlo perm (restricted) → Tests (5): anova.cca + adonis2 + how() UI
Variation partitioning 2–3   → Ordination: varpart (venn)
PCNM/dbMEM, PRC, CoCA        → Plugins/advanced (adespatial dbMEM/PRC via vegan::prc)
CanoDraw (loess/GLM/GAM, ellipses) → Plots: envfit vectors + ordisurf + ordiellipse + plot-customization
Species/trait tables         → Traits plugin (FD)
```

## 4. What to run in webR (current + next)
- **Now wired:** `vegan::metaMDS/diversity/renyi/vegdist/adonis2/betadisper/anova.cca` + **`iNEXT::iNEXT / ChaoRichness/Shannon/Simpson / estimateD / ggiNEXT(type 1/2/3)`** via `packages/processing/runInextViaWebR` (provenance `REAL … via webR`, mock fallback `sample-results.json`). Builds `webr-DrTIcb_O.js 63k`, `index-CpdOWzOV.js 385k`.
- **Next (no new WASM needed — same `webR` mount):**
  1. `beta.div` + `beta.div.comp(S,J quant)` + `LCBD` → **Beta panel** real `vegan/adespatial/betapart` (replace mock `Bray-Curtis 0.42`).
  2. `rda/cca/decorana/wcmdscale/dbrda` → **Ordination panel** already calls `metaMDS`; add `rda ~ env + Condition()` + `varpart`.
  3. `adonis2 + betadisper + mantel + anosim` → **Tests panel** real permutations (currently mock `p 0.01**`).
  4. `FD::dbFD + picante::pd` → **Traits** plugin.
- **Install set to mount in webR (prod bundling):** `install.packages(c('vegan','permute','cluster','MASS','mgcv','ggplot2','iNEXT','betapart','adespatial','FD','ape','picante'))` — Tauri bundles `webr.wasm` + `R` + repo offline (no 30 MB fetch); `ordin.in4metrix.dev` fetches once then cached (Vercel `COOP/COEP` via `vercel.json` already shipped `16dabe4`).

## 5. Deployment — why `ordin.in4metrix.dev` already works
- `vercel.json` sets `Cross-Origin-Opener-Policy: same-origin` + `Cross-Origin-Embedder-Policy: require-corp` (required for `SharedArrayBuffer` → `webR` + `DuckDB-WASM`). E2B preview (`:9054`) intentionally **without** (iframe-safe, mock), `Vercel prod` + `Tauri` → `crossOriginIsolated=true` → toggle `Use REAL iNEXT` enabled.
- **Mobile (future):** same Vite build → **PWA** (`vite-plugin-pwa` + DuckDB OPFS + webR cached) — no native code needed; light datasets run offline on phone. Native shell later via **Tauri mobile**.

## 6. Recommended defaults (align with recent papers)
- Distances: `bray` for abundance, `jaccard` binary for incidence — offer `gower/kulczynski/horn/morisita` as advanced.
- Beta: `beta.div.comp(..., coef="S", quant=TRUE)` (%diff = Bray-Curtis quantitative Sorensen) → report `Repl/BDtotal` vs `RichDiff/BDtotal`.
- Ordination: default `metaMDS(k=2, trymax=100)` + `stressplot` + `envfit 999` + `ordisurf` for key env.
- `iNEXT`: `q=c(0,1,2) datatype=abundance knots=40 endpoint=NULL (2×) se=TRUE conf=0.95 nboot=50` + `type 1/3` views (already in Diversity controls).

---
*Keep this audit as the package allow-list — do not add niche `HMSC`/`boral` to the browser until `1.0` ships with the core six panels + two plugins green on real data.*
