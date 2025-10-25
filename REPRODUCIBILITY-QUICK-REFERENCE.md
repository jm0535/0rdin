# Reproducibility Quick Reference Card

**For Ördin v3.0+ Module Developers**

---

## 3-Step Implementation

### 1️⃣ In Module Server (R)

```r
# Source utilities
source("utils/reproducibility.R", local = TRUE)

# In PDF export downloadHandler
metadata <- captureAnalysisMetadata(
  dataset_name = "Your Dataset",
  n_sites = nrow(data()),
  n_species = ncol(data()),
  analysis_type = "Your Analysis Type",
  analysis_params = list(
    param1 = input$param1,
    param2 = input$param2
  ),
  result = your_result()
)

params <- getReportParameters(metadata, list(
  your_result = your_result(),
  param1 = input$param1,
  param2 = input$param2
))

rmarkdown::render(..., params = params)
```

### 2️⃣ In Report YAML (RMD)

```yaml
params:
  # REQUIRED STANDARD PARAMS
  dataset_name: "Data"
  n_sites: NULL
  n_species: NULL
  analysis_type: "Analysis"
  analysis_date: NULL
  analysis_time: NULL
  r_version: NULL
  ordin_version: "3.0"
  
  # YOUR ANALYSIS PARAMS
  your_result: NULL
  param1: NULL
  param2: NULL
```

### 3️⃣ In Report Body (RMD)

```markdown
# Reproducibility

```{r prepare_repro}
repro_df <- data.frame(
  Parameter = c("Param 1", "Param 2"),
  Value = c(params$param1, params$param2),
  Description = c("What param 1 does", "What param 2 means")
)

repro_code <- "
```r
library(package)
result <- function(
  data,
  param1 = {param1},
  param2 = '{param2}'
)
```
"
```

```{r reproducibility_section, child='reproducibility_section.Rmd'}
```
```

---

## Required Files

✅ `shiny/utils/reproducibility.R` - Utility functions  
✅ `shiny/templates/reproducibility_section.Rmd` - Reusable template

---

## Example

See: `shiny/modules/ordination_nmds_module.R` (line 129, 444-472)

---

## Full Guide

📖 See `DEVELOPER-GUIDE-REPRODUCIBILITY.md` for complete documentation

---

**Author:** Jimmy Moses | **Date:** 2025-10-25
