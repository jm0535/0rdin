# Developer Guide: Implementing Reproducibility in Ördin Modules

**Author:** Jimmy Moses (jimmy.moses@pnguot.ac.pg)  
**Date:** October 25, 2025  
**Version:** 1.0  
**Applies to:** Ördin v3.0 and later

---

## Overview

This guide ensures **all analysis modules** in Ördin include comprehensive reproducibility documentation in their PDF reports. This is a **mandatory requirement** for all future development.

## Why Reproducibility Matters

✅ **Scientific Integrity** - Peers can verify and replicate findings  
✅ **Publication Requirements** - Meets journal reproducibility standards  
✅ **Audit Trail** - Complete record for data management and quality assurance  
✅ **Teaching & Learning** - Students see exact methodology  
✅ **FAIR Principles** - Findable, Accessible, Interoperable, Reusable data

---

## Architecture

### 1. Utility Functions (`shiny/utils/reproducibility.R`)

**Core functions for all modules:**

- `captureAnalysisMetadata()` - Captures comprehensive metadata
- `getReportParameters()` - Converts metadata to report params
- `generateReproducibilityTable()` - Creates parameter tables
- `getSoftwareTable()` - Generates software environment table
- `generateReproductionCode()` - Creates R code snippets
- `printReproducibilitySummary()` - Console debugging output

### 2. Reusable Template (`shiny/templates/reproducibility_section.Rmd`)

**Standardized reproducibility section** that can be included in any report via child document or copy-paste.

### 3. Module Implementation Pattern

**Three-step process for any analysis module:**

1. **Capture metadata** in server function
2. **Pass comprehensive parameters** to report
3. **Include reproducibility section** in RMD template

---

## Step-by-Step Implementation Guide

### Step 1: Source Reproducibility Utilities in Your Module

```r
# In your module server function (e.g., ordination_module.R)
source("utils/reproducibility.R", local = TRUE)
```

### Step 2: Capture Metadata When Generating Report

```r
# In your downloadHandler for PDF export
output$export_report <- downloadHandler(
  filename = function() {
    paste0("analysis_report_", Sys.Date(), ".pdf")
  },
  content = function(file) {
    req(analysis_result())  # Your analysis result
    
    # STEP 1: Capture metadata using utility function
    metadata <- captureAnalysisMetadata(
      dataset_name = "Your Dataset Name",  # From input or reactive
      n_sites = nrow(data()),
      n_species = ncol(data()),
      analysis_type = "Your Analysis Type",  # e.g., "NMDS Ordination"
      analysis_params = list(
        # All user-configurable parameters
        parameter1 = input$parameter1,
        parameter2 = input$parameter2
        # ... etc
      ),
      result = analysis_result()
    )
    
    # STEP 2: Build analysis-specific parameters
    analysis_specific <- list(
      # Include result object
      analysis_result = analysis_result(),
      
      # Include any interpretation objects
      interpretation = interpretation_result(),
      
      # Include user inputs
      parameter1 = input$parameter1,
      parameter2 = input$parameter2,
      # ... etc
      
      # Include derived values
      some_calculated_value = some_value
    )
    
    # STEP 3: Get complete report parameters
    params <- getReportParameters(metadata, analysis_specific)
    
    # STEP 4: Render report
    rmarkdown::render(
      input = "templates/your_report.Rmd",
      output_format = "pdf_document",
      output_file = file,
      params = params,
      envir = new.env()
    )
  }
)
```

### Step 3: Update Your RMD Template YAML Header

```yaml
---
title: "Your Analysis Report"
author: "Ördin v3.0"
date: "`r format(Sys.Date(), '%B %d, %Y')`"
output: 
  pdf_document:
    latex_engine: xelatex
    toc: true
    toc_depth: 2
    number_sections: true
geometry: margin=1in
header-includes:
  - \usepackage{xcolor}
  - \usepackage{colortbl}
  - \usepackage{fancyhdr}
  - \usepackage{booktabs}
  - \usepackage{longtable}
  - \usepackage{array}
  - \usepackage{multirow}
  - \usepackage{wrapfig}
  - \usepackage{float}
  - \usepackage{pdflscape}
  - \usepackage{tabu}
  - \usepackage{threeparttable}
  - \usepackage{threeparttablex}
  - \usepackage[normalem]{ulem}
  - \usepackage{makecell}
params:
  # STANDARD REPRODUCIBILITY PARAMETERS (ALWAYS INCLUDE)
  dataset_name: "Community Data"
  n_sites: NULL
  n_species: NULL
  analysis_type: "Analysis"
  analysis_date: NULL
  analysis_time: NULL
  r_version: NULL
  ordin_version: "3.0"
  os: NULL
  platform: NULL
  
  # PACKAGE VERSIONS (as needed)
  vegan_version: NULL
  inext_version: NULL
  ggplot2_version: NULL
  
  # YOUR ANALYSIS-SPECIFIC PARAMETERS
  analysis_result: NULL
  parameter1: NULL
  parameter2: NULL
  # ... etc
---
```

### Step 4: Add Reproducibility Section to Your Report

**Option A: Include as child document (recommended)**

```markdown
# Reproducibility

```{r reproducibility_section, child='reproducibility_section.Rmd'}
```
```

**Option B: Copy section directly from template**

Copy the entire contents of `templates/reproducibility_section.Rmd` into your report.

### Step 5: Define Analysis-Specific Tables

Before the reproducibility section, define the parameter table:

```r
```{r prepare_repro_tables}
# Build parameter description table
repro_df <- data.frame(
  Parameter = c(
    "Parameter 1 Name",
    "Parameter 2 Name",
    "Parameter 3 Name"
    # ... etc
  ),
  Value = c(
    as.character(params$parameter1),
    as.character(params$parameter2),
    sprintf("%.4f", params$parameter3)  # Format as needed
    # ... etc
  ),
  Description = c(
    "What parameter 1 means",
    "What parameter 2 does",
    "Why parameter 3 matters"
    # ... etc
  ),
  stringsAsFactors = FALSE
)

# Define reproduction code (optional)
repro_code <- paste0(
  "```r\n",
  "# Install required packages\n",
  "install.packages('your_package')\n",
  "library(your_package)\n\n",
  "# Run analysis with identical parameters\n",
  "result <- your_function(\n",
  "  data = your_data,\n",
  "  parameter1 = ", params$parameter1, ",\n",
  "  parameter2 = '", params$parameter2, "'\n",
  ")\n",
  "```\n"
)
```
```

---

## Complete Example: NMDS Module

See the reference implementation in:
- **Module:** `shiny/modules/ordination_module.R`
- **Template:** `shiny/templates/nmds_report.Rmd`

### Key Code from NMDS Module:

```r
# In ordination_module.R
metadata <- captureAnalysisMetadata(
  dataset_name = "Community Data",
  n_sites = nrow(data()),
  n_species = ncol(data()),
  analysis_type = "NMDS Ordination",
  analysis_params = list(
    distance = input$distance,
    k = input$k,
    permutations = input$permutations,
    trymax = 20,
    autotransform = FALSE
  ),
  result = nmds_result()
)

params <- getReportParameters(metadata, list(
  nmds_result = nmds_result(),
  stress_interp = stress_interp,
  distance = input$distance,
  k = input$k,
  permutations = input$permutations,
  trymax = 20,
  autotransform = FALSE
))
```

---

## Required Parameters for All Reports

### Minimum Required (Always Include):

```yaml
params:
  dataset_name: "Dataset name"
  n_sites: NULL          # Number of samples/sites
  n_species: NULL        # Number of variables/species
  analysis_type: "Type"  # e.g., "PCA", "Diversity Estimation"
  analysis_date: NULL
  analysis_time: NULL
  r_version: NULL
  ordin_version: "3.0"
```

### Recommended Additional:

```yaml
params:
  os: NULL               # Operating system
  platform: NULL         # R platform
  vegan_version: NULL    # If using vegan
  inext_version: NULL    # If using iNEXT
  ggplot2_version: NULL  # If using ggplot2
```

---

## Checklist for New Modules

When creating a new analysis module with PDF export, ensure:

- [ ] Source `utils/reproducibility.R` in module
- [ ] Call `captureAnalysisMetadata()` before rendering
- [ ] Pass all user inputs as parameters
- [ ] Include standard reproducibility params in YAML
- [ ] Add reproducibility section to RMD template
- [ ] Create `repro_df` table with parameter descriptions
- [ ] Provide `repro_code` for reproduction instructions
- [ ] Test PDF generation with sample data
- [ ] Verify all parameters appear in final PDF
- [ ] Document any module-specific requirements

---

## Testing Reproducibility

### Unit Test Template:

```r
# test-reproducibility.R
test_that("Report includes reproducibility section", {
  # Generate test report
  params <- list(
    dataset_name = "Test Data",
    n_sites = 10,
    n_species = 5,
    analysis_type = "Test Analysis",
    # ... other params
  )
  
  output <- rmarkdown::render(
    "templates/your_report.Rmd",
    params = params,
    output_format = "pdf_document"
  )
  
  expect_true(file.exists(output))
  expect_gt(file.size(output), 0)
})
```

### Manual Testing Steps:

1. Load sample data
2. Configure analysis with specific parameters
3. Generate PDF report
4. Verify reproducibility section contains:
   - ✓ Dataset information
   - ✓ Analysis parameters table
   - ✓ Software environment table
   - ✓ Reproduction code
5. Copy reproduction code to R console
6. Verify it runs without errors

---

## Common Pitfalls & Solutions

### Problem: LaTeX compilation errors

**Solution:** Ensure all required LaTeX packages are in header-includes:

```yaml
header-includes:
  - \usepackage{xcolor}
  - \usepackage{colortbl}
  - \usepackage{booktabs}
  - \usepackage{longtable}
  - \usepackage{array}
  - \usepackage{multirow}
  # ... (see full list in template)
```

### Problem: Unicode characters fail

**Solution:** Use XeLaTeX engine:

```yaml
output: 
  pdf_document:
    latex_engine: xelatex
```

### Problem: Parameters showing as NULL

**Solution:** Ensure metadata is captured BEFORE rendering:

```r
# WRONG - metadata captured inside render
rmarkdown::render(..., params = list(...))

# CORRECT - metadata captured first
metadata <- captureAnalysisMetadata(...)
params <- getReportParameters(metadata, ...)
rmarkdown::render(..., params = params)
```

### Problem: Table formatting breaks

**Solution:** Keep table alignment simple:

```r
kable(..., align = c("l", "l", "l"))  # Good
kable(..., align = c("l", "p{6cm}", "r"))  # Can cause issues
```

---

## Future Enhancements

Planned for future Ördin versions:

- [ ] Auto-generate data checksums (SHA-256)
- [ ] Export R script alongside PDF
- [ ] Include complete session info
- [ ] Add data provenance tracking
- [ ] Generate machine-readable metadata (YAML/JSON)
- [ ] Support for version control integration

---

## Standards & Compliance

This implementation ensures Ördin meets:

✅ **FAIR Data Principles**  
✅ **Journal reproducibility requirements** (Nature, Science, PLOS, etc.)  
✅ **Open Science best practices**  
✅ **Research Data Management (RDM) standards**  
✅ **Good Scientific Practice guidelines**

---

## References

### Scientific Reproducibility:

- Gentleman, R., & Temple Lang, D. (2007). Statistical analyses and reproducible research. *Journal of Computational and Graphical Statistics*, 16(1), 1-23.
- Peng, R. D. (2011). Reproducible research in computational science. *Science*, 334(6060), 1226-1227.
- Wilson, G., et al. (2017). Good enough practices in scientific computing. *PLoS Computational Biology*, 13(6), e1005510.

### FAIR Principles:

- Wilkinson, M. D., et al. (2016). The FAIR Guiding Principles for scientific data management and stewardship. *Scientific Data*, 3, 160018.

---

## Support

For questions or issues with reproducibility implementation:

**Developer:** Jimmy Moses  
**Email:** jimmy.moses@pnguot.ac.pg  
**Institution:** Papua New Guinea University of Technology  
**GitHub:** https://github.com/jm0535/ordin

---

## Changelog

### v1.0 (2025-10-25)
- Initial reproducibility framework
- Created utility functions
- Implemented NMDS reference example
- Created developer documentation

---

**Last Updated:** October 25, 2025  
**Mandatory for:** All Ördin v3.0+ modules with PDF export
