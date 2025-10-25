# Ördin v3.0 - Package Quick Reference

**80 Core Packages** | **11 Categories** | **Enterprise-Grade Ecosystem**

---

## 📦 Installation

```bash
# Install all packages
Rscript install-v3-packages.R

# Verify installation
Rscript verify-pdf-setup.R
```

---

## 🎯 Package Categories (80 total)

| # | Category | Count | Key Packages |
|---|----------|-------|--------------|
| 1 | Shiny/UI | 9 | shiny, bslib, shinyjs, waiter |
| 2 | Tidyverse | 11 | dplyr, ggplot2, tidyr, purrr |
| 3 | Tidymodels | 8 | parsnip, recipes, tune |
| 4 | Ecology | 5 | vegan, iNEXT, **betapart** |
| 5 | Spatial | 8 | **sf**, **terra**, leaflet |
| 6 | Database | 4 | DBI, RSQLite, RPostgres |
| 7 | Data I/O | 9 | DT, openxlsx, jsonlite |
| 8 | Reporting | 8 | rmarkdown, **quarto**, tinytex |
| 9 | Development | 7 | **devtools**, testthat, roxygen2 |
| 10 | Statistics | 6 | lme4, mgcv, car |
| 11 | Utilities | 7 | janitor, glue, scales |

---

## ⭐ Most Important New Additions

### 1. tidyverse
**The** modern data science toolkit
- `dplyr` - Data manipulation
- `ggplot2` - Visualization
- `tidyr` - Data reshaping
- `purrr` - Functional programming

### 2. tidymodels
Unified machine learning framework
- `parsnip` - Model interface
- `recipes` - Feature engineering
- `tune` - Hyperparameter tuning
- `workflows` - Modeling pipelines

### 3. betapart ⭐
Beta diversity partitioning (turnover vs. nestedness)
- Integrated as separate module in Ördin
- **Location:** 'Diversity Analysis' → 'BETA PARTITIONING'

### 4. sf + terra
Modern spatial analysis
- `sf` - Vector data (points, polygons)
- `terra` - Raster data (climate, elevation)
- Replaces legacy `sp` + `rgdal`

### 5. devtools
Professional package development
- Build and test packages
- Code profiling
- Documentation generation

---

## 🔧 Quick Usage Examples

### Tidyverse - Data Manipulation
```r
library(tidyverse)

# Read and clean data
data <- read_csv("samples.csv") %>%
  janitor::clean_names() %>%
  filter(abundance > 0) %>%
  group_by(site) %>%
  summarize(richness = n())

# Visualize
ggplot(data, aes(x = site, y = richness)) +
  geom_col() +
  theme_minimal()
```

### betapart - Diversity Partitioning
```r
library(betapart)

# Compute beta diversity
beta <- beta.pair(community_matrix, index.family = "sorensen")

# Separate turnover from nestedness
beta$beta.sim  # Turnover component
beta$beta.sne  # Nestedness component
beta$beta.sor  # Total beta diversity
```

### sf - Spatial Analysis
```r
library(sf)
library(leaflet)

# Read spatial data
sites <- st_read("sampling_sites.shp")

# Interactive map
leaflet(sites) %>%
  addTiles() %>%
  addCircleMarkers()
```

### tidymodels - Machine Learning
```r
library(tidymodels)

# Create recipe
rec <- recipe(richness ~ ., data = env_data) %>%
  step_normalize(all_numeric_predictors())

# Model specification
model <- rand_forest() %>%
  set_engine("ranger") %>%
  set_mode("regression")

# Workflow
wf <- workflow() %>%
  add_recipe(rec) %>%
  add_model(model)
```

---

## 📊 Package Purpose Matrix

| Task | Package(s) | Purpose |
|------|-----------|---------|
| Data import | readr, readxl, haven | CSV, Excel, SPSS files |
| Data cleaning | dplyr, tidyr, janitor | Filter, reshape, standardize |
| Visualization | ggplot2, patchwork | Plots and combined figures |
| Ordination | vegan | NMDS, PCA, CA, DCA |
| Diversity | vegan, iNEXT, betapart | Alpha, beta, gamma diversity |
| Spatial | sf, terra, leaflet | GIS, maps, rasters |
| Modeling | tidymodels, lme4 | ML, mixed models |
| Reporting | rmarkdown, quarto | PDF, HTML, Word |
| Database | DBI, RSQLite | Data persistence |
| Testing | testthat | Unit tests |

---

## 🌍 System Dependencies

### Linux
```bash
# Ubuntu/Debian
sudo apt-get install -y \
  libgdal-dev libgeos-dev libudunits2-dev \
  libcurl4-openssl-dev libssl-dev

# Fedora/RHEL  
sudo dnf install -y \
  gdal-devel geos-devel udunits2-devel \
  libcurl-devel openssl-devel
```

### macOS
```bash
brew install gdal geos udunits
```

### Windows
✅ No additional dependencies (binary packages)

---

## 📁 File Structure

```
ordin/
├── install-v3-packages.R          ⭐ Main installation script
├── verify-pdf-setup.R             Check PDF export setup
├── setup-pdf-export.R             Auto-setup PDF dependencies
├── CORE-PACKAGES-UPDATE-v3.0.md   📖 Detailed documentation
├── CORE-PACKAGES-SUMMARY.md       📋 Summary document
└── PACKAGES-QUICK-REFERENCE.md    📄 This file
```

---

## ✅ Verification Checklist

After installation, verify:

- [ ] All 80 packages installed
- [ ] Tidyverse loads: `library(tidyverse)`
- [ ] Tidymodels loads: `library(tidymodels)`
- [ ] betapart loads: `library(betapart)`
- [ ] Spatial packages load: `library(sf); library(terra)`
- [ ] PDF export works (requires Pandoc + TinyTeX)

---

## 🚀 Quick Start

```r
# 1. Load core ecosystem
library(tidyverse)   # Data science
library(vegan)       # Community ecology

# 2. Read community data
comm <- read_csv("community_data.csv") %>%
  column_to_rownames("site") %>%
  select(where(is.numeric))

# 3. Run ordination
nmds <- metaMDS(comm, distance = "bray", k = 2)

# 4. Visualize
scores(nmds, display = "sites") %>%
  as_tibble(rownames = "site") %>%
  ggplot(aes(NMDS1, NMDS2, label = site)) +
  geom_point(size = 3) +
  geom_text(vjust = -0.5) +
  theme_minimal() +
  labs(title = "NMDS Ordination")
```

---

## 📚 Documentation

- **Tidyverse:** https://www.tidyverse.org/
- **Tidymodels:** https://www.tidymodels.org/
- **vegan:** https://github.com/vegandevs/vegan
- **betapart:** https://cran.r-project.org/web/packages/betapart/
- **sf:** https://r-spatial.github.io/sf/
- **terra:** https://rspatial.github.io/terra/

---

**Version:** 3.0  
**Last Updated:** 2025-10-25  
**Maintainer:** Jimmy Moses (jmoses@pnguot.ac.pg)
