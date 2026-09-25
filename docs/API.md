# Ördin API Documentation

> Documents the module/service API as implemented in `shiny/` (v3.0).
> The app is not an installable R package: `shiny/app.R` sources everything
> with relative paths and runs via `shiny::runApp("shiny")`.

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
