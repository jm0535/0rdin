# Ördin v3.0 - Core Packages Expansion

**Date:** October 25, 2025  
**Author:** Jimmy Moses (jmoses@pnguot.ac.pg)  
**Status:** ✅ Implementation Complete

---

## Overview

Expanded Ördin's core package dependencies to include comprehensive ecosystems for data science, ecology, spatial analysis, modeling, and development tools. The package list now totals **80 packages** organized into 11 functional categories.

## Package Categories

### 1. Shiny & UI Components (9 packages)
**Purpose:** Web application framework and interactive UI components

- `shiny` - Core Shiny framework
- `bslib` - Bootstrap theming
- `shinyjs` - JavaScript integration
- `waiter` - Loading screens & progress bars
- `shinyFeedback` - Inline validation messages
- `shinycssloaders` - Loading spinners
- `shinyWidgets` - Enhanced UI widgets
- `shinyBS` - Bootstrap components
- `shinyalert` - Professional alert dialogs

### 2. Tidyverse Ecosystem (11 packages)
**Purpose:** Modern data manipulation and visualization

- `tidyverse` - Meta-package containing core tidyverse
- `dplyr` - Data manipulation (filter, select, mutate)
- `ggplot2` - Grammar of graphics visualization
- `tidyr` - Data tidying (pivot, separate, unite)
- `readr` - Fast CSV/TSV reading
- `purrr` - Functional programming tools
- `tibble` - Modern data frames
- `stringr` - String manipulation
- `forcats` - Factor handling
- `lubridate` - Date-time manipulation
- `patchwork` - Combine ggplot2 plots

### 3. Tidymodels Ecosystem (8 packages)
**Purpose:** Unified modeling and machine learning framework

- `tidymodels` - Meta-package for modeling
- `parsnip` - Unified modeling interface
- `recipes` - Feature engineering & preprocessing
- `rsample` - Resampling infrastructure (cross-validation, bootstrapping)
- `tune` - Hyperparameter tuning
- `workflows` - Modeling workflows
- `yardstick` - Model performance metrics
- `broom` - Tidy model outputs

### 4. Community Ecology & Biodiversity (5 packages)
**Purpose:** Ecological community analysis and diversity metrics

- `vegan` - Community ecology (NMDS, PERMANOVA, diversity)
- `iNEXT` - Interpolation/extrapolation for diversity
- `betapart` - Beta diversity partitioning (turnover vs nestedness)
- `BiodiversityR` - Comprehensive biodiversity analysis
- `vegetarian` - Diversity indices (Jost's diversity numbers)

**Note:** `betapart` is integrated as a separate module under 'Diversity Analysis' → 'BETA PARTITIONING (betapart)' for specialized turnover/nestedness analysis.

### 5. Spatial Analysis (8 packages)
**Purpose:** Geospatial data processing and visualization

- `sf` - Simple features (modern spatial vectors)
- `terra` - Raster and vector analysis (modern, fast)
- `raster` - Raster data (legacy but widely used)
- `sp` - Spatial data classes (legacy support)
- `rgdal` - Geospatial data abstraction library
- `rgeos` - Geometry operations
- `mapview` - Interactive spatial viewing
- `leaflet` - Interactive maps for Shiny apps

**System Dependencies (Linux):**
- `libgdal-dev` - GDAL library for rgdal
- `libgeos-dev` - GEOS library for rgeos
- `libudunits2-dev` - Units library for sf

### 6. Database Connectivity (4 packages)
**Purpose:** Database interfaces and backends

- `DBI` - Database interface (abstract layer)
- `RSQLite` - SQLite backend
- `RPostgres` - PostgreSQL backend
- `odbc` - ODBC connectivity (SQL Server, MySQL, etc.)

### 7. Data Import/Export (9 packages)
**Purpose:** Read/write data in various formats

- `DT` - Interactive DataTables in Shiny
- `openxlsx` - Excel (.xlsx) read/write
- `writexl` - Fast Excel writing
- `jsonlite` - JSON data
- `xml2` - XML parsing
- `haven` - SPSS/Stata/SAS files
- `readxl` - Excel file reading
- `clipr` - Clipboard operations

### 8. Report Generation (8 packages)
**Purpose:** Dynamic reports in PDF, HTML, Word formats

- `rmarkdown` - R Markdown documents
- `tinytex` - LaTeX backend for PDFs
- `knitr` - Dynamic report generation
- `quarto` - Next-gen scientific publishing
- `flextable` - Professional tables
- `officer` - Word/PowerPoint generation
- `gt` - Grammar of tables
- `kableExtra` - Enhanced knitr tables

**System Dependencies:**
- **Pandoc** ≥ 1.12.3 (document converter)
- **TinyTeX** (minimal LaTeX distribution)

### 9. Development Tools (7 packages)
**Purpose:** Package development, testing, and debugging

- `devtools` - Package development workflow
- `usethis` - Workflow automation
- `roxygen2` - Documentation generation
- `testthat` - Unit testing
- `profvis` - Performance profiling
- `here` - Project-relative paths

### 10. Statistical Analysis (6 packages)
**Purpose:** Advanced statistical modeling

- `lme4` - Linear mixed-effects models
- `nlme` - Nonlinear mixed-effects models
- `mgcv` - Generalized additive models (GAM)
- `car` - Companion to applied regression
- `MASS` - Modern applied statistics
- `multcomp` - Multiple comparisons

### 11. Utilities (7 packages)
**Purpose:** Helper functions and data processing tools

- `scales` - Scale functions for ggplot2
- `glue` - String interpolation
- `janitor` - Data cleaning
- `naniar` - Missing data visualization
- `skimr` - Summary statistics
- `assertthat` - Input validation
- `progress` - Progress bars

---

## Installation

### Automated Installation

Run the updated installation script:

```bash
Rscript install-v3-packages.R
```

This will:
1. Check for missing packages
2. Install new packages automatically
3. Verify all packages load successfully
4. Display version information

### Manual Installation

If needed, install specific packages:

```r
install.packages(c("tidyverse", "tidymodels", "sf", "terra", "betapart"))
```

### Linux System Dependencies

On Linux, install system libraries before R packages:

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2-dev \
  libfontconfig1-dev \
  libharfbuzz-dev \
  libfribidi-dev \
  libfreetype6-dev \
  libpng-dev \
  libtiff5-dev \
  libjpeg-dev \
  libgdal-dev \
  libgeos-dev \
  libudunits2-dev

# Fedora/RHEL
sudo dnf install -y \
  libcurl-devel \
  openssl-devel \
  libxml2-devel \
  fontconfig-devel \
  harfbuzz-devel \
  fribidi-devel \
  freetype-devel \
  libpng-devel \
  libtiff-devel \
  libjpeg-turbo-devel \
  gdal-devel \
  geos-devel \
  udunits2-devel
```

---

## Package Count Summary

| Category | Count | Key Packages |
|----------|-------|--------------|
| Shiny/UI | 9 | shiny, bslib, shinyjs |
| Tidyverse | 11 | dplyr, ggplot2, tidyr |
| Tidymodels | 8 | parsnip, recipes, tune |
| Ecology | 5 | vegan, iNEXT, betapart |
| Spatial | 8 | sf, terra, leaflet |
| Database | 4 | DBI, RSQLite, RPostgres |
| Data I/O | 9 | DT, openxlsx, jsonlite |
| Reporting | 8 | rmarkdown, tinytex, quarto |
| Development | 7 | devtools, testthat, roxygen2 |
| Statistics | 6 | lme4, mgcv, car |
| Utilities | 7 | scales, glue, janitor |
| **TOTAL** | **80** | **Comprehensive ecosystem** |

---

## Integration with Ördin Features

### Data Management
- **tidyverse**: Data cleaning, transformation, summarization
- **DT**: Interactive data tables
- **openxlsx/writexl**: Excel import/export
- **janitor**: Column name cleaning, data validation

### Diversity Analysis
- **vegan**: NMDS, PERMANOVA, diversity indices (Shannon, Simpson)
- **iNEXT**: Rarefaction/extrapolation curves
- **betapart**: Turnover vs. nestedness analysis
- **BiodiversityR**: Accumulation curves, species-area relationships

### Ordination
- **vegan**: NMDS, PCA, CA, DCA, PCoA
- **ggplot2 + patchwork**: Publication-quality plots
- **sf**: Spatial ordination with geographic data

### Spatial Analysis (Future)
- **sf**: Vector data (points, polygons, lines)
- **terra**: Raster analysis (elevation, climate)
- **mapview + leaflet**: Interactive maps in Shiny

### Machine Learning (Future)
- **tidymodels**: Species distribution modeling (SDM)
- **parsnip**: Random forests, boosted trees
- **recipes**: Feature engineering for predictors

### Reporting
- **rmarkdown + knitr**: Dynamic HTML/PDF reports
- **quarto**: Scientific manuscripts
- **flextable**: Professional tables for reports

---

## Version Information

Package installation was tested on:
- **OS:** Windows 11 (25H2)
- **R:** 4.5.1
- **Date:** 2025-10-25

All packages install successfully on Windows using binary packages from CRAN.

---

## Future Enhancements

### Planned Features Using New Packages

1. **Spatial Ecology Module**
   - Use `sf` + `terra` for spatial diversity analysis
   - `leaflet` maps showing sample locations
   - Environmental variable overlay

2. **Machine Learning Module**
   - `tidymodels` for species distribution modeling
   - Predictive modeling for diversity patterns
   - Feature importance analysis

3. **Advanced Reporting**
   - `quarto` for scientific manuscripts
   - Multi-format export (PDF, HTML, Word, DOCX)
   - Parameterized reports for batch analysis

4. **Database Integration**
   - `DBI` + `RSQLite` for local data storage
   - `RPostgres` for PostgreSQL cloud databases
   - Data versioning and provenance tracking

5. **Interactive Dashboards**
   - `leaflet` for geographic visualization
   - `plotly` for interactive plots
   - Real-time data updates

---

## Troubleshooting

### Package Installation Failures

If packages fail to install:

1. **Check R version:** Ensure R ≥ 4.1.0
   ```r
   R.version.string
   ```

2. **Update existing packages:**
   ```r
   update.packages(ask = FALSE)
   ```

3. **Install from source (if binary unavailable):**
   ```r
   install.packages("package_name", type = "source")
   ```

4. **Check system dependencies (Linux):**
   - Ensure all dev libraries are installed
   - Run `setup-linux.sh` for automated setup

### Common Issues

**rgdal/rgeos installation fails:**
- **Linux:** Install `libgdal-dev` and `libgeos-dev`
- **Windows:** Should work with binary packages
- **Alternative:** Use `sf` + `terra` (modern replacements)

**tidymodels installation is slow:**
- Normal - installs many dependencies (~50+ packages)
- Allow 5-10 minutes for complete installation

**Pandoc not found for PDF export:**
- Install Pandoc: `winget install --id=JohnMacFarlane.Pandoc -e`
- Or download from: https://pandoc.org/installing.html

---

## References

- [Tidyverse Documentation](https://www.tidyverse.org/)
- [Tidymodels Documentation](https://www.tidymodels.org/)
- [sf Package](https://r-spatial.github.io/sf/)
- [terra Package](https://rspatial.github.io/terra/)
- [vegan Tutorial](https://cran.r-project.org/web/packages/vegan/vignettes/intro-vegan.pdf)
- [betapart Documentation](https://cran.r-project.org/web/packages/betapart/index.html)

---

**Last Updated:** 2025-10-25  
**Maintainer:** Jimmy Moses (jmoses@pnguot.ac.pg)  
**License:** As per individual package licenses (mostly GPL-2/GPL-3/MIT)
