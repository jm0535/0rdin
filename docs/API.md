# Ördin API Reference

> Ördin **4.0.0**. Documents the TypeScript API exported by the `@ordin/*` workspace
> packages in `packages/`. The legacy v3 Shiny module/service API is preserved as an
> [appendix](#appendix--legacy-v3-shiny-api).

## Package map

| Package | Path | Responsibility |
| --- | --- | --- |
| `@ordin/core` | `packages/core` | Project schema, validation, global Zustand store |
| `@ordin/processing` | `packages/processing` | webR bridge + JavaScript statistics |
| `@ordin/ui` | `packages/ui` | Shared presentational primitives |
| `@ordin/map` | `packages/map` | MapLibre helper for optional site maps |

---

## `@ordin/core`

### Types

| Export | Description |
| --- | --- |
| `SpeciesMatrixSchema`, `SpeciesMatrix` | zod schema / type for a sites × taxa matrix (`rownames`, `colnames`, `values`) |
| `EnvTableSchema`, `EnvTable` | zod schema / type for the environmental table |
| `PanelId` | `'dashboard' \| 'data' \| 'diversity' \| 'ordination' \| 'tests' \| 'beta' \| 'classification' \| 'traits' \| 'results' \| 'settings' \| 'help'` |
| `OrdinProject` | Serialisable project: `version`, `meta`, `data`, `analyses`, `view` |

### Functions

| Export | Signature | Description |
| --- | --- | --- |
| `validateSpeciesMatrix` | `(m: SpeciesMatrix \| null) => { valid: boolean; reason?: string }` | Structural check before an analysis runs |
| `defaultProject` | `() => OrdinProject` | Empty project (`version: '4.0'`, dashboard panel, dark theme) |
| `useOrdinStore` | Zustand hook | Global state; see below |

### Store (`useOrdinStore`)

State:

| Key | Description |
| --- | --- |
| `project` | The active `OrdinProject` |
| `webrReady` | `true` once the webR runtime has booted |
| `ui` | `{ sidebarOpen, inspectorOpen, commandOpen, importOpen, pluginOpen, inspectorTab }` |

Actions:

| Action | Description |
| --- | --- |
| `setPanel(panel)` | Switch the active panel |
| `setSpecies(matrix)` / `setEnv(table)` / `setTraits(matrix)` | Replace a dataset (validated) |
| `loadSample('dune' \| 'varespec' \| 'BCI')` | Load a bundled dataset |
| `runNMDS({ k, distance })` | Run NMDS and store the result in `project.analyses.nmds` |
| `clearData()` | Reset all datasets and analyses |
| `setWebRReady(v)` | Runtime status, used by the status bar |
| `setSidebarOpen` / `setInspectorOpen` / `setCommandOpen` / `setImportOpen` / `setPluginOpen` / `setInspectorTab` | UI toggles |

Usage:

```ts
import { useOrdinStore } from '@ordin/core';

const species = useOrdinStore((s) => s.project.data.species);
const runNMDS = useOrdinStore((s) => s.runNMDS);
await runNMDS({ k: 2, distance: 'bray' });
```

Mutations are applied through Immer producers, so reducers may "mutate" the draft safely.

---

## `@ordin/processing`

### Runtime

| Export | Signature | Description |
| --- | --- | --- |
| `WebRStatus` | `'idle' \| 'loading' \| 'ready' \| 'error'` | Runtime state |
| `getWebR()` | `() => Promise<WebR>` | Boots (once) and returns the shared webR instance |

All `*ViaWebR` helpers return a `provenance` string describing how the number was produced (for example `REAL vegan::adonis2 via webR`). Panels must display it.

### R-backed analyses

| Export | Purpose | R behind it |
| --- | --- | --- |
| `runNMDSViaWebR(matrix, { k, distance, trymax? })` | NMDS stress + point scores | `vegan::metaMDS` |
| `runOrdinationViaWebR(matrix, envMatrix, envColNames, { method, distance, k })` | Site/species/env scores, eigenvalues, variance, DCA grade for NMDS, PCA, tb-PCA, CA, DCA, PCoA, CCA, RDA, db-RDA, CAP | `vegan::metaMDS / rda / cca / decorana / wcmdscale / dbrda / capscale` + `envfit` |
| `runInextViaWebR(matrix, { q, datatype, knots, endpoint, nboot, conf })` | `DataInfo`, `AsyEst`, `iNextEst` | `iNEXT::iNEXT` |
| `runBetaViaWebR(matrix)` | Sørensen `sor`, turnover `sim`, nestedness `sne` + percentages | `betapart::beta.multi` / `vegan::vegdist` |
| `runTestViaWebR(matrix, envRows, envCols, type, opts?)` | `'permanova' \| 'anosim' \| 'mantel' \| 'envfit'` | `vegan::adonis2 / anosim / mantel / envfit` |
| `runVarpartViaWebR(speciesMatrix, envRows, envCols)` | Variation-partitioning fractions | `vegan::varpart` |
| `runAnovaViaWebR(speciesMatrix, envRows, envCols, by?)` | Permutation `F` and `p` for constrained models | `vegan::anova.cca` |
| `runRLQViaWebR(species, env, envCols, traits, traitRows, traitCols)` | Eigenvalues and site/species/trait scores | `ade4` RLQ via `vegan`/`ade4` |

### JavaScript fast paths

Used for instant previews and as a fallback when cross-origin isolation is unavailable.

| Export | Description |
| --- | --- |
| `shannon(row)` / `simpson(row)` | Alpha-diversity indices for one site |
| `brayCurtis(a, b)`, `jaccard(a, b)`, `euclidean(a, b)`, `chordDistance(a, b)`, `hellingerDistance(a, b)`, `chisqDistance(a, b, colSums?, total?)` | Pairwise dissimilarities |
| `distanceMatrix(matrix, method)` | Full dissimilarity matrix for the methods above |
| `betaPartitionJS(matrix)` | Baselga partitioning (`sor`, `sim`, `sne`, percentages, pair count) |
| `hclustJS(distMatrix, linkage)` | Hierarchical clustering; returns `merge`, `height`, `order`, `groupsForK(k)` |
| `copheneticCorrelation(distMatrix, hclust)` | Clustering quality |
| `silhouetteScores(distMatrix, groups)` | `{ perPoint, mean }` |
| `kmeansJS(matrix, k, maxIter?)` | `{ groups, totss, withinss }` |
| `computeCWM(speciesMatrix, rownames, speciesCols, traitsMatrix, traitsRows, traitsCols)` | Community-weighted means |

---

## `@ordin/ui`

React primitives styled for the Ördin shell: `Button` (`default \| ghost \| outline \| subtle`), `Card`, `Badge` (`success \| info \| warn \| neutral`), `Input`, `Separator` (`horizontal \| vertical`), `Dialog` (`open`, `onOpenChange`), `Sheet` (`side: 'left' \| 'right'`). All accept `className` for Tailwind overrides and forward native props.

---

## `@ordin/map`

| Export | Signature | Description |
| --- | --- | --- |
| `MapProps` | type | `container` options: style URL, centre, zoom, points |
| `createMap(container, opts)` | `=> maplibregl.Map` | Creates the optional site map; only used when the dataset has lon/lat |
| `maplibregl` | re-export | Direct access to the MapLibre API |

---

## Project file format (`.ordin`)

A `.ordin` bundle serialises the whole `OrdinProject` (schema `version: '4.0'`) together with the imported tables, written by `apps/ordin-desktop/src/lib/downloadOrdin.ts`. Because analyses store their parameters, timestamps (`ranAt`) and `provenance`, reopening a project reproduces the exact reported results.

---

# Appendix — legacy v3 Shiny API

> The following documents `shiny/` (Ördin 3.0). The app is not an installable R
> package: `shiny/app.R` sources everything with relative paths and runs via
> `shiny::runApp("shiny")`. Kept for maintenance of the legacy tree only.

## Architecture Overview

```
shiny/app.R                    # bootstraps: config -> error_handler -> performance
                               # -> future plan -> DataService -> modules -> UI
shiny/services/DataService.R   # R6 central data store (reactiveVals)
shiny/ui/*_ui.R                # per-tab UI, calls module *_ui() functions
shiny/modules/*_module.R       # Shiny modules: snake_case *_ui(id) / *_server(...)
shiny/R/performance.R          # async helpers (promises + future)
shiny/R/error_handler.R        # validation & error-handling helpers
shiny/utils/                   # plotting, interpretation, reproducibility helpers
```

Data flow: `DataService` owns four reactive values (`species_data`,
`env_data`, `phylo_tree`, `trait_data`). The import module writes into them;
analysis modules read from them. Modules return no value — they render their
own outputs and store results in internal reactiveVals.

## Service: DataService (R6)

`shiny/services/DataService.R`

| Member | Description |
| --- | --- |
| `species_data` | reactiveVal: community matrix (sites × species, numeric) |
| `env_data` | reactiveVal: environmental data frame |
| `phylo_tree` | reactiveVal: phylo object (ape) |
| `trait_data` | reactiveVal: functional-trait data frame |
| `load_sample_data(dataset_name)` | Loads a bundled sample dataset (e.g. `"dune"`); returns `list(success, message, ...)` |
| `load_file(file_path, type)` | Reads a CSV/XLSX file (`type` = `"species"`, `"env"`, `"traits"`), validates it (species: `validate_species_data`; env: `validate_env_data` against loaded species data), stores it; returns `list(success, message)` |
| `reset()` | Clears all stored datasets |

## Module: Data Import

`shiny/modules/import_module.R`

- `import_ui(id)` — upload widget, file-type selector, sample-dataset picker
- `import_server(id, data_service)` — handles `input$file` (upload →
  `data_service$load_file()`), `input$load_sample` (→
  `data_service$load_sample_data()`); shows waiter spinner + notifications

## Modules: Ordination

One module per method; all follow `*_ui(id)` / `*_server(id, data, env_data)`,
where `data` and `env_data` are reactiveVals from `DataService`.

| Module file | Functions | Method |
| --- | --- | --- |
| `ordination_module.R` | `nmds_ui`, `nmds_server` | NMDS (**asynchronous**, see below) |
| `ordination_pca_module.R` | `pca_ui`, `pca_server` | PCA (`vegan::rda`) |
| `ordination_ca_module.R` | `ca_ui`, `ca_server` | CA (`vegan::cca`) |
| `ordination_dca_module.R` | `dca_ui`, `dca_server` | DCA (`vegan::decorana`) |
| `ordination_pcoa_module.R` | `pcoa_ui`, `pcoa_server` | PCoA |
| `ordination_cca_module.R` | `cca_ui`, `cca_server` | CCA (constrained) |
| `ordination_rda_module.R` | `rda_ui`, `rda_server` | RDA (constrained) |
| `ordination_dbrda_module.R` | `dbrda_ui`, `dbrda_server` | db-RDA (`vegan::dbrda`) |
| `ordination_cap_module.R` | `cap_ui`, `cap_server` | CAP (`vegan::capscale`) |

### Asynchronous NMDS

`nmds_server()` runs `vegan::metaMDS` in a background R process via
`async_ordination()` (see below), so the UI never freezes. On success it also
launches PERMANOVA asynchronously (`async_permanova()`) when environmental
data is present, then resolves `nmds_result` / `permanova_result` reactiveVals
used by the plot, statistics, interpretation and PDF/CSV export handlers.
PDF export embeds analysis metadata (`utils/reproducibility.R`) and checks for
tinytex before offering PDF (Suggests — optional).

## Modules: Diversity

| Module file | Functions | Content |
| --- | --- | --- |
| `diversity_estimation_module.R` | `diversity_estimation_ui`, `diversity_estimation_server` | iNEXT rarefaction/extrapolation, coverage curves, Hill numbers |
| `diversity_indices_module.R` | `diversity_indices_ui`, `diversity_indices_server` | Shannon, Simpson, Fisher's alpha, Pielou evenness; phylogenetic diversity (picante) |

## Modules: Statistical Tests

| Module file | Functions | Content |
| --- | --- | --- |
| `tests_permanova_module.R` | `permanova_ui`, `permanova_server` | `vegan::adonis2` |
| `tests_anosim_module.R` | `anosim_ui`, `anosim_server` | `vegan::anosim` |
| `tests_mantel_envfit_module.R` | `mantel_envfit_ui`, `mantel_envfit_server` | Mantel test, `vegan::envfit` |

## Module: Beta Diversity

`shiny/modules/beta_partition_module.R`

- `beta_partition_ui(id)` / `beta_partition_server(id, data, env_data, ...)`
- Turnover/nestedness partitioning via betapart (Sørensen/Simpson families);
  combined ggplot panels via patchwork; `generate_beta_interpretation()`,
  `create_beta_plot()`

## Async Helpers — `shiny/R/performance.R`

A concurrent `future::plan(multisession)` is configured once at startup in
`shiny/app.R` (with sequential fallback if workers cannot be started).

| Function | Description |
| --- | --- |
| `async_ordination(data, method, distance, k, trymax, autotransform, trace)` | `promises::future_promise` wrapper for NMDS/PCA/CA/DCA; `packages = "vegan"`, `seed = TRUE` |
| `async_permanova(comm, env, permutations, distance)` | `adonis2` in a worker process |
| `parallel_nmds(data, k, n_tries)` | furrr-based multi-start NMDS; temporarily switches the future plan and restores it on exit |
| `cached_reactive(expr, cache_key)` | digest-keyed reactive caching |
| `debounced_input(input_reactive, millis)` | input debouncing |
| `batch_process(data, batch_size, process_fn)` | chunked processing with progress |
| `with_progress(n, expr)` | progress-bar wrapper |
| `get_distance_matrix(data, method)` / `clear_distance_cache()` | cached `vegdist` |
| `optimize_dataset(data, max_sites, method)` | subsampling for very large matrices |

## Error Handling — `shiny/R/error_handler.R`

- `safe_analysis(expr, fallback, message)` — tryCatch wrapper with logging
- `validate_species_data(data)` — data.frame/matrix, ≥3 sites, ≥2 species,
  all numeric, no NA, no negatives → `list(valid, message)`
- `validate_env_data(species_data, env_data)` — row compatibility checks
- `interpretNMDSStress(stress)` — stress grading/interpretation
- `log_warning()` / `log_error()` / `show_loading()` / `hide_loading()`

## UI Tab Files — `shiny/ui/`

`dashboard_ui.R`, `data_ui.R`, `diversity_ui.R`, `ordination_ui.R`,
`tests_ui.R`, `beta_ui.R`, `results_ui.R`, `settings_ui.R`, `help_ui.R` —
sourced at render time by `ui <- function(req)` in `app.R`
(`source("ui/<tab>_ui.R", local = TRUE)$value`); method panels are wrapped in
`conditionalPanel("input.ordination_method == '<method>'", ...)`.

## Export Formats

- CSV (results tables, ordination scores)
- JSON (metadata + scores, jsonlite)
- PDF reports (rmarkdown templates in `shiny/templates/`, tinytex optional)
- Plots as PNG via ggplot2/`ggsave`
