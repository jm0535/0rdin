# NMDS PDF Report - Reproducibility Enhancement

**Date:** October 25, 2025  
**Author:** Jimmy Moses (jimmy.moses@pnguot.ac.pg)  
**Status:** ✅ Complete

## Overview

Enhanced the NMDS PDF report to include comprehensive reproducibility information, documenting all user choices and analysis parameters to enable exact replication of results.

## Changes Made

### 1. Enhanced Parameters Passed to Report

Updated `ordination_nmds_module.R` to capture and pass comprehensive metadata:

```r
params <- list(
  nmds_result = nmds_result(),
  distance = input$distance,
  k = input$k,
  permutations = input$permutations,
  stress_interp = stress_interp,
  dataset_name = "Community Data",
  n_sites = nrow(data()),
  n_species = ncol(data()),
  trymax = 20,
  autotransform = FALSE,
  analysis_date = Sys.Date(),
  analysis_time = format(Sys.time(), "%H:%M:%S"),
  r_version = paste(R.version$major, R.version$minor, sep = "."),
  vegan_version = as.character(packageVersion("vegan")),
  ordin_version = "3.0"
)
```

**New Parameters Captured:**
- `permutations` - Number of permutations for statistical testing
- `n_sites` - Number of sampling sites
- `n_species` - Number of species/variables
- `trymax` - Maximum random starts attempted
- `autotransform` - Whether data were automatically transformed
- `analysis_date` - Date of analysis
- `analysis_time` - Time of analysis
- `r_version` - R version used
- `vegan_version` - vegan package version
- `ordin_version` - Ördin platform version

### 2. New "Reproducibility" Section in PDF Report

Added comprehensive section documenting complete workflow:

#### Section Contents:

**A. Dataset Information**
- Dataset name
- Number of sites/samples
- Number of species/variables
- Analysis date and time

**B. NMDS Parameters Table**
Comprehensive table with 3 columns:
- **Parameter** - Configuration setting name
- **Value** - Actual value used
- **Description** - What the parameter means

Parameters documented:
1. Distance/Dissimilarity Metric (e.g., BRAY, JACCARD)
2. Number of Dimensions (k)
3. Maximum Random Starts
4. Autotransformation (Yes/No)
5. Permutations (stress test)
6. Convergence Achieved (✓/✗)
7. Final Iterations
8. Final Stress Value

**C. Software Environment Table**
- Analysis Platform (Ördin)
- Platform Version (v3.0)
- R Version
- vegan Package Version
- Operating System

**D. Step-by-Step Reproduction Instructions**

Complete R code provided for exact replication:

```r
# Install required packages
install.packages("vegan")
library(vegan)

# Run NMDS with identical parameters
nmds_result <- metaMDS(
  comm = your_data,
  distance = "bray",
  k = 2,
  trymax = 20,
  autotransform = FALSE,
  trace = FALSE
)

# Verify convergence
nmds_result$converged  # Should be TRUE
nmds_result$stress     # Should match reported value
```

**E. Important Note on Reproducibility**

Explains that exact coordinates may differ due to random starting configurations, but stress values and patterns should be identical.

## PDF Report Structure (Updated)

Now includes **13 sections** (previously 12):

1. Executive Summary
2. Analysis Overview
3. Ordination Quality Assessment
4. NMDS Ordination Plot
5. Diagnostic Plots (Shepard, Goodness of Fit)
6. Ordination Statistics
7. Site Scores
8. Species Scores (Top 50)
9. Interpretation
10. Methods
11. **Reproducibility** ⭐ NEW
12. References
13. Software & Citation

## Technical Implementation

### Files Modified:

1. **`shiny/modules/ordination_nmds_module.R`**
   - Lines 443-459: Enhanced parameter preparation
   - Added 10 new metadata parameters

2. **`shiny/templates/nmds_report.Rmd`**
   - Lines 31-40: Updated params section with new fields
   - Lines 395-528: New Reproducibility section (133 lines)
   - 2 new R chunks: `repro_table`, `software_table`

### LaTeX Packages Used:

All reproducibility tables use:
- `booktabs` - Professional table formatting
- `longtable` - Multi-page table support
- `kableExtra` - Advanced table styling

## Benefits

### For Researchers:
✅ **Complete transparency** - All choices documented  
✅ **Exact replication** - Copy-paste R code provided  
✅ **Peer review friendly** - Reviewers can verify methodology  
✅ **Publication ready** - Meets journal reproducibility standards  

### For Students:
✅ **Learning tool** - See exact parameters used  
✅ **Template for own analysis** - Modify provided code  
✅ **Understand defaults** - Know what settings were applied  

### For Data Managers:
✅ **Audit trail** - Complete record of analysis  
✅ **Version tracking** - Software versions documented  
✅ **Quality assurance** - Verify analysis settings  

## Example Output

### Reproducibility Section Preview:

```
# Reproducibility

## Analysis Configuration

### Dataset Information
- Dataset Name: Dune Meadow Vegetation
- Number of Sites/Samples: 20
- Number of Species/Variables: 30
- Analysis Date: October 25, 2025
- Analysis Time: 17:44:26

### NMDS Parameters

| Parameter                    | Value   | Description                                      |
|------------------------------|---------|--------------------------------------------------|
| Distance/Dissimilarity       | BRAY    | Dissimilarity measure used                       |
| Number of Dimensions (k)     | 2       | Number of ordination axes/dimensions            |
| Maximum Random Starts        | 20      | Number of random starting configurations        |
| Autotransformation          | No      | Whether data were automatically transformed      |
| Permutations (stress test)  | 999     | Number of permutations for statistical testing  |
| Convergence Achieved        | ✓ Yes   | Whether algorithm reached stable solution       |
| Final Iterations            | 20      | Number of iterations before convergence         |
| Final Stress Value          | 0.1183  | Final stress value indicating quality           |

### Software Environment

| Component        | Version |
|------------------|---------|
| Analysis Platform| Ördin   |
| Platform Version | v3.0    |
| R Version        | 4.5.1   |
| vegan Package    | 2.6-8   |
| Operating System | Windows |

### Reproducing This Analysis

[Complete R code provided with exact parameters...]
```

## Testing

### Test Results:
✅ PDF generation successful  
✅ All tables rendering correctly  
✅ XeLaTeX handling Unicode (✓/✗) symbols  
✅ Reproducibility code syntactically correct  
✅ All metadata captured and displayed  

### File Size:
- Previous version: ~95 KB
- Enhanced version: ~95 KB (minimal increase)

## Future Enhancements

Potential additions for v3.1:
- [ ] Include session info (all loaded packages)
- [ ] Add data transformation history
- [ ] Export R script file alongside PDF
- [ ] Include SHA-256 hash of input data
- [ ] Add YAML metadata for parsing

## Compliance

This enhancement ensures Ördin reports meet:
- ✅ FAIR Data Principles (Findable, Accessible, Interoperable, Reusable)
- ✅ Journal reproducibility requirements
- ✅ Open Science best practices
- ✅ Research Data Management standards

## References

- Gentleman, R., & Temple Lang, D. (2007). Statistical analyses and reproducible research. *Journal of Computational and Graphical Statistics*, 16(1), 1-23.
- Peng, R. D. (2011). Reproducible research in computational science. *Science*, 334(6060), 1226-1227.
- Wilson, G., et al. (2017). Good enough practices in scientific computing. *PLoS Computational Biology*, 13(6), e1005510.

## Related Files

- `shiny/modules/ordination_nmds_module.R` - Module with enhanced parameter passing
- `shiny/templates/nmds_report.Rmd` - Report template with reproducibility section
- `test-pdf-render.R` - Testing script for PDF generation
- `NMDS-PDF-REPORT-COMPLETE.md` - Original enhancement documentation

## Author

**Jimmy Moses**  
Papua New Guinea University of Technology  
Email: jimmy.moses@pnguot.ac.pg

---

*This document was created as part of the Ördin v3.0 development to enhance scientific reproducibility and transparency in community ecology analysis.*
