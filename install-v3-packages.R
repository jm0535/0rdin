# Ördin v3.0 - Install Enterprise-Grade R Package Dependencies
# Run this script to install all required packages for v3.0 features

cat("═══════════════════════════════════════════════════════════════\n")
cat("  Ördin v3.0 - Enterprise Package Installation\n")
cat("═══════════════════════════════════════════════════════════════\n\n")

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# List of required packages for v3.0
v3_packages <- c(
  # Core Shiny packages
  "shiny",
  "bslib",
  "shinyjs",          # Enhanced JavaScript interactivity & keyboard shortcuts
  "waiter",           # Professional loading screens & progress bars
  "shinyFeedback",    # Inline validation messages
  "shinycssloaders",  # Loading spinners for plots
  "shinyWidgets",     # Enhanced UI widgets (tooltips, dropdowns)
  "shinyBS",          # Bootstrap components (tooltips, popovers)
  "shinyalert",       # Professional alert dialogs
  
  # Tidyverse ecosystem (data manipulation & visualization)
  "tidyverse",        # Meta-package: dplyr, ggplot2, tidyr, readr, purrr, tibble, stringr, forcats
  "dplyr",            # Data manipulation
  "ggplot2",          # Data visualization
  "tidyr",            # Data tidying
  "readr",            # Fast data reading
  "purrr",            # Functional programming
  "tibble",           # Modern data frames
  "stringr",          # String manipulation
  "forcats",          # Factor manipulation
  "lubridate",        # Date-time manipulation
  "patchwork",        # Combine ggplot2 plots
  
  # Tidymodels ecosystem (modeling & machine learning)
  "tidymodels",       # Meta-package for modeling
  "parsnip",          # Unified modeling interface
  "recipes",          # Feature engineering
  "rsample",          # Resampling infrastructure
  "tune",             # Hyperparameter tuning
  "workflows",        # Modeling workflows
  "yardstick",        # Model performance metrics
  "broom",            # Tidy model outputs
  
  # Community ecology & biodiversity
  "vegan",            # Community ecology analysis (NMDS, PERMANOVA, diversity indices)
  "iNEXT",            # Interpolation/extrapolation for diversity
  "betapart",         # Beta diversity partitioning (turnover vs nestedness)
  "BiodiversityR",    # Biodiversity analysis tools
  "vegetarian",       # Diversity indices
  "codyn",            # Community dynamics over time (temporal ecology)
  
  # Phylogenetic & Functional Diversity
  "ape",              # Analysis of Phylogenetics and Evolution
  "picante",          # Phylogenetic community ecology (Faith's PD, MPD, MNTD)
  "FD",               # Functional diversity analysis
  
  # Network Analysis
  "igraph",           # Network analysis and visualization
  "bipartite",        # Bipartite ecological networks (plant-pollinator, etc.)
  
  # Spatial analysis
  "sf",               # Simple features for spatial vector data
  "terra",            # Spatial raster and vector analysis
  "raster",           # Raster data (legacy, but still widely used)
  "sp",               # Spatial data classes (legacy support)
  "rgdal",            # Geospatial data abstraction
  "rgeos",            # Geometry operations
  "mapview",          # Interactive spatial data viewing
  "leaflet",          # Interactive maps for Shiny
  "spdep",            # Spatial dependence & autocorrelation (Moran's I, spatial regression)
  
  # Database connectivity
  "DBI",              # Database interface
  "RSQLite",          # SQLite database backend
  "RPostgres",        # PostgreSQL database backend
  "odbc",             # ODBC database connectivity
  
  # Data export/import
  "DT",               # Interactive data tables
  "openxlsx",         # Excel export (.xlsx)
  "writexl",          # Fast Excel writing
  "jsonlite",         # JSON export for APIs
  "xml2",             # XML parsing
  "haven",            # SPSS, Stata, SAS file import
  "readxl",           # Excel file reading
  "clipr",            # Clipboard support
  
  # Report generation (PDF/HTML/Word)
  "rmarkdown",        # R Markdown document generation
  "tinytex",          # LaTeX backend for PDF reports
  "knitr",            # Dynamic report generation
  "quarto",           # Next-generation scientific publishing
  "flextable",        # Professional tables for reports
  "officer",          # Word/PowerPoint document generation
  "gt",               # Grammar of tables
  "kableExtra",       # Enhanced knitr tables
  
  # Development & debugging tools
  "devtools",         # Package development tools
  "usethis",          # Workflow automation for R projects
  "roxygen2",         # Documentation generation
  "testthat",         # Unit testing framework
  "profvis",          # Performance profiling
  "here",             # Path management
  
  # Statistical analysis
  "lme4",             # Linear mixed-effects models
  "nlme",             # Nonlinear mixed-effects models
  "mgcv",             # Generalized additive models
  "car",              # Companion to applied regression
  "MASS",             # Modern applied statistics
  "multcomp",         # Multiple comparisons
  "glmmTMB",          # Generalized linear mixed models with Template Model Builder
  "geepack",          # Generalized estimating equations
  "MuMIn",            # Multi-model inference (AIC, BIC, model averaging)
  "DHARMa",           # Residual diagnostics for GLMMs
  "emmeans",          # Estimated marginal means & post-hoc comparisons
  
  # Asynchronous / parallel computing (Ördin async NMDS + PERMANOVA)
  "promises",         # Promise-based async programming for Shiny
  "future",           # Unified parallel computing (multisession workers)
  "later",            # Event loop scheduling for promise resolution
  "furrr",            # future + purrr (parallel map helpers)
  "R6",               # Reference classes (DataService)

  # Utilities
  "scales",           # Scale functions for visualization
  "glue",             # String interpolation
  "janitor",          # Data cleaning
  "naniar",           # Missing data visualization
  "skimr",            # Summary statistics
  "assertthat",       # Input validation
  "progress",         # Progress bars
  "pacman",           # Package management and loading
  "data.table",       # Fast data manipulation for large datasets
  
  # Species Distribution Modeling (SDM)
  "biomod2",          # Ensemble platform for species distribution modeling
  "maxnet",           # MaxEnt species distribution modeling (formerly 'maxent')
  "dismo",            # Species distribution modeling (includes MaxEnt interface)
  
  # Python integration
  "reticulate",       # R interface to Python
  
  # IDE & Development support
  "rstudioapi",       # RStudio API access
  "languageserver",   # Language Server Protocol for R
  "remotes",          # Install packages from remote repositories
  
  # Visualization enhancements
  "ggpubr",           # Publication-ready plots with ggplot2
  "plotly",           # Interactive web-based plots (3D ordination, dashboards)
  "ggraph",           # Network visualization with ggplot2
  
  # Study Design & Meta-Analysis
  "pwr",              # Power analysis & sample size calculation
  "metafor"           # Meta-analysis (fixed/random effects, forest plots)
)

cat("📦 Packages to install/update:\n")
print(v3_packages)
cat("\n")

# Check which packages are already installed
installed_pkgs <- rownames(installed.packages())
to_install <- v3_packages[!v3_packages %in% installed_pkgs]

if (length(to_install) == 0) {
  cat("✅ All v3.0 packages are already installed!\n\n")
} else {
  cat("📥 Installing", length(to_install), "new packages...\n\n")
  
  # Install missing packages with progress
  for (i in seq_along(to_install)) {
    pkg <- to_install[i]
    cat(sprintf("[%d/%d] Installing %s...", i, length(to_install), pkg))
    
    tryCatch({
      install.packages(pkg, quiet = TRUE)
      cat(" ✅\n")
    }, error = function(e) {
      cat(" ❌ FAILED\n")
      cat("  Error:", conditionMessage(e), "\n")
    })
  }
}

# Verify all packages can be loaded
cat("\n🔍 Verifying package installation...\n")
all_loaded <- TRUE

for (pkg in v3_packages) {
  result <- tryCatch({
    library(pkg, character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE)
    TRUE
  }, error = function(e) {
    FALSE
  })
  
  status <- if (result) "✅" else "❌"
  cat(sprintf("  %s %s\n", status, pkg))
  
  if (!result) all_loaded <- FALSE
}

cat("\n")
if (all_loaded) {
  cat("═══════════════════════════════════════════════════════════════\n")
  cat("  ✅ SUCCESS! All v3.0 packages installed and verified\n")
  cat("═══════════════════════════════════════════════════════════════\n\n")
  cat("🚀 You can now run Ördin v3.0 with all enterprise features!\n\n")
  cat("Next steps:\n")
  cat("1. Replace shiny/app.R with the new v3.0 version\n")
  cat("2. Update package.json version to 3.0.0\n")
  cat("3. Run 'npm start' to test the new features\n\n")
} else {
  cat("═══════════════════════════════════════════════════════════════\n")
  cat("  ⚠️  Some packages failed to install\n")
  cat("═══════════════════════════════════════════════════════════════\n\n")
  cat("Please check the errors above and try installing failed packages manually:\n")
  cat("  install.packages(c('package_name'))\n\n")
}

# Display package versions for troubleshooting
cat("📋 Installed package versions:\n")
for (pkg in v3_packages) {
  if (pkg %in% installed_pkgs) {
    version <- packageVersion(pkg)
    cat(sprintf("  %s: %s\n", pkg, version))
  }
}

cat("\n═══════════════════════════════════════════════════════════════\n")
cat("  Installation script completed!\n")
cat("═══════════════════════════════════════════════════════════════\n")
