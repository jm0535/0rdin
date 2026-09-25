<div align="center">

<img src="build/icon.png" alt="Ördin Logo" width="128" height="128">

# Ördin

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-3.0.0-blue.svg)](https://github.com/jm0535/0rdin/releases)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)](https://github.com/jm0535/0rdin)
[![R](https://img.shields.io/badge/R-%E2%89%A54.4-blue)](https://www.r-project.org/)
[![Node.js](https://img.shields.io/badge/Node.js-18%20%7C%2020-green)](https://nodejs.org/)
[![Code Quality](https://img.shields.io/badge/code%20quality-A%2B-brightgreen)](https://github.com/jm0535/0rdin)

**Next-Gen Open-Source Community Ecology Analysis Platform**

*Combining R's statistical power with modern UX design*

[Features](#-key-features) • [Installation](#installation) • [Documentation](#documentation) • [Citation](#citation)

</div>

---

## 🌟 Why Ördin?

Most ecological analysis software faces a critical trade-off:
- **User-friendly tools** lack statistical rigor
- **Rigorous tools** sacrifice usability

**Ördin solves both.** Built on battle-tested R packages (vegan, iNEXT, betapart) with an intuitive, modern interface inspired by VS Code.

### ✨ At a Glance

| Feature | Ördin |
|---------|-------|
| **Ordination Methods** | 9 (NMDS, PCA, CA, DCA, PCoA, CCA, RDA, db-RDA, CAP) |
| **Diversity Analysis** | iNEXT rarefaction + 8 diversity indices |
| **Beta Diversity** | Full partitioning (turnover & nestedness) |
| **Statistical Tests** | PERMANOVA, ANOSIM, Mantel, envfit |
| **Plot Export** | Up to 600 DPI (PNG, PDF, SVG, TIFF) |
| **Real-time Customization** | 18+ plot parameters |
| **Code Quality** | A+ (98/100) |
| **Learning Curve** | Minutes, not weeks |

## Overview

Ördin is a **next-gen, open-source, cross-platform desktop application** that brings modern community ecology analysis to everyone. No R coding required—just upload your data and start analyzing.

### 🎯 Perfect For

- **Researchers** - Publication-ready analyses and exports
- **Students** - Learn ecology without programming barriers  
- **Consultants** - Next-gen reports with minimal setup
- **Educators** - Teaching tool with reproducible workflows

### ✨ What's New in v3.0

**UI/UX Improvements:**
- **🪟 Frameless Window Design**: Custom title bar with NO OS chrome for clean, modern look
- **🎨 VS Code-Inspired Interface**: Professional flat design matching industry standards
- **🎯 Activity Bar Navigation**: Left-side activity bar with collapsible sidebar panels
- **📑 Tab Bar System**: Multi-tab workspace with breadcrumb navigation
- **⚡ Window Controls**: Custom minimize, maximize, close buttons integrated into title bar
- **🖱️ Draggable Title Bar**: Native window dragging with `-webkit-app-region`
- **📐 Responsive Layout**: Flexbox-based layout preventing overlap issues
- **🔧 Right Properties Panel**: Collapsible properties panel with real-time plot customization
- **⚙️ Settings System**: Comprehensive settings with 6 sections (Appearance, Plot Defaults, Analysis, Data, Performance, Advanced)
- **📚 Help System**: Interactive help with 17 individual topic pages and smooth navigation
- **✅ Error-Free Console**: Suppressed conflicting package JavaScript errors

**Analysis Features:**
- **📊 Enhanced Ordination Analysis**: 9 ordination methods + 2 diversity modules with modular architecture
  - **Ordination**: NMDS, PCA, CA, DCA, PCoA, CCA, RDA, db-RDA, CAP
  - **Diversity**: iNEXT Estimation, Diversity Indices
- **🎨 Real-Time Plot Customization**: Right panel with 18+ controls for instant plot updates
  - **Themes**: Clean, Minimal, Dark, Classic, Light, Void (ggplot2-based)
  - **Typography**: Font family, sizes (base, title, axis, legend, strip)
  - **Lines & Points**: Line width, point size, shapes, colors
  - **Grids**: Major/minor grid toggle, axis line width
  - **CI Ribbons**: Show/hide confidence intervals, transparency control
  - **Legends**: Row count, size, position customization
  - **Facets**: Label size for multi-panel plots
- **📉 Advanced Ordination Features**: Confidence ellipses, species scores, environmental vectors
- **💾 Dynamic Updates**: All plot changes apply in real-time without re-running analyses
- **📤 Publication Exports**: PNG, TIFF, SVG at 300 DPI with customizable dimensions
- **📈 Comprehensive Settings**: 6 settings sections with persistent browser storage

**Technical Improvements:**
- **⚡ Optimized Startup**: Splash screen with smooth transition to main window
- **🔒 Secure IPC**: Preload script for window control communication
- **📱 DevTools Integration**: Built-in developer tools for debugging
- **🎯 Production Ready**: Fully tested and stable for deployment

### ✨ What's New in v2.3

- **🎨 Dark/Light Theme Toggle**: Professional theme switching with persistent preferences
- **☀️ Theme Button**: Positioned on far right of navbar (sun/moon icons)
- **💾 localStorage Persistence**: Theme preference saved across sessions
- **🎨 Complete UI Adaptation**: All elements respond to theme changes
- **⚡ Smooth Transitions**: 0.2s ease animations on theme switch
- **🐛 CSS Architecture Fix**: Eliminated quote escaping issues with class-based approach

### ✨ What's New in v2.2

- **🗺️ Ordination Module**: 5 methods (NMDS, PCA, CA, DCA, PCoA) with 5 distance measures
- **📈 Diversity Indices Module**: Shannon, Simpson, evenness, rarefaction, accumulation curves
- **🎯 Modular Architecture**: Professional tab-based navigation (Diversity | Ordination | Indices | Help)
- **📊 Enhanced vegan Integration**: 19 vegan functions (~9.5% coverage, up from 0.5%)
- **🎨 Enterprise UX**: Clean, organized interface with dedicated modules

### Core Features

#### 🧬 **Diversity Analysis**
- **Diversity Estimation**: iNEXT-based rarefaction and extrapolation
  - Individual-based and incidence-based data support
  - Rarefaction and extrapolation methods
  - Three visualization types: sample-size, coverage, completeness
  - Hill numbers (q=0, 1, 2): Species richness, Shannon, Simpson diversity
  - Bootstrap confidence intervals (95% default)
- **Diversity Indices**: Classic diversity and evenness metrics
  - Alpha diversity: Shannon, Simpson, Inverse Simpson, Fisher's Alpha, Richness
  - Evenness indices: Pielou's J', Simpson's E, Evar
- **Export Formats**: CSV, Excel, JSON

#### 🗺️ **Ordination Analysis**
- **7 Ordination Methods**:
  - **NMDS**: Non-metric Multidimensional Scaling
  - **PCA**: Principal Components Analysis
  - **CA**: Correspondence Analysis
  - **DCA**: Detrended Correspondence Analysis
  - **CCA**: Canonical Correspondence Analysis (constrained)
  - **RDA**: Redundancy Analysis (constrained)
  - **PCoA**: Principal Coordinates Analysis
- **Advanced Visualization**:
  - 5 Distance measures: Bray-Curtis, Jaccard, Euclidean, Manhattan, Canberra
  - Confidence ellipses for site groups with automatic validation
  - Species scores overlay with customizable display options
  - Environmental vectors (biplot arrows) for interpretation
  - 5 Plot themes: Dark, Light, Classic, Minimal, Publication
  - Dynamic theme switching without re-running analyses
  - Comprehensive legends explaining all plot elements
- **Technical Features**:
  - 1-5 dimensions support
  - Multiple scaling options (1, 2, 3)
  - Data transformations: Hellinger, Chi-square, Log, Sqrt, PA, Wisconsin
  - Stress values and quality assessment (NMDS)
  - Eigenvalue percentages on axes
  - Downloadable scores and eigenvalues (CSV)

#### 🎨 **Enterprise-Grade Interface**
- **Modern Design**: VS Code-inspired flat design with professional aesthetics
- **Three-Panel Layout**: Activity bar + collapsible sidebars (left & right) + main canvas
- **Dynamic Sidebars**: Context-aware content (Home, Data, Diversity, Ordination, Tests, Settings, Help)
- **Theme System**: Dark/light theme toggle with persistent preferences
- **Real-Time Customization**: Right panel with instant plot updates (no re-rendering needed)
- **Settings System**: 6 comprehensive sections:
  - **Appearance**: Theme, font family, UI zoom (75-150%)
  - **Plot Defaults**: Theme, DPI, format, dimensions
  - **Analysis Defaults**: NMDS distance, k-dimensions, iNEXT bootstrap, permutations
  - **Data Management**: Auto-save, validation, cache clearing
  - **Performance**: Performance mode, caching options
  - **Advanced**: R configuration, package versions (read-only)
- **Help System**: 17 individual topic pages with smooth navigation:
  - **Getting Started**: Quick Start, What is Ördin, First Steps, Data Import
  - **Analysis Methods**: Ordination, Diversity, Statistics, Visualization
  - **Tutorials**: Import Guide, NMDS, iNEXT, Publication Plots
  - **Reference**: Citations, Shortcuts, Export, Troubleshooting
  - **Support**: FAQs, Bug Reports, Feature Requests
  - **About**: Version info, Author, GitHub repository
- **Modular Navigation**: Tab-based interface with clear module separation
- **Interactive Elements**: Enhanced widgets, accordions, and form controls
- **Loading States**: Modern progress indicators and loading screens

#### 📤 **Publication-Quality Exports**
- **Multiple Formats**: PNG, TIFF, SVG at publication quality (300 DPI)
- **Consistent Dimensions**: 12"×8" standard sizes
- **Theme Support**: Exports respect selected plot themes
- **Data Exports**: CSV, Excel, JSON for all analysis results
- **Plot Components**: Download scores, eigenvalues, and summary statistics

#### 🛠️ **Data Management**
- **Flexible Input**: CSV files with automatic data type detection
- **Environmental Data**: Separate upload for environmental variables
- **Data Validation**: Automatic checking for common issues
- **Sample Datasets**: Included research data (spiders, birds, ciliates, ants)
- **Cross-Platform**: Works on Windows, macOS, and Linux

## Prerequisites

Before building Ördin, ensure you have:

1. **Node.js** (LTS version 18.x or 20.x)
   - Download from [nodejs.org](https://nodejs.org)
   - Verify: `node -v` and `npm -v`

2. **Git**
   - Download from [git-scm.com](https://git-scm.com)
   - Verify: `git --version`

3. **R** (version 4.4 or higher)
   - Download from [r-project.org](https://www.r-project.org/)
   - Verify: `R --version`

4. **Windows-Specific Tools**:
   - **Cygwin**: Install from [cygwin.com](https://cygwin.com) with `wget` package
   - **Innoextract**: Run `choco install innoextract` (requires Chocolatey)

5. **Linux-Specific** (Debian/Ubuntu):
   ```bash
   sudo apt-get install -y libcurl4-openssl-dev libssl-dev libxml2-dev \
     libfontconfig1-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev \
     libpng-dev libtiff5-dev libjpeg-dev libcairo2-dev
   ```

6. **Linux-Specific** (Fedora/RHEL):
   ```bash
   sudo dnf install -y libcurl-devel openssl-devel libxml2-devel \
     fontconfig-devel harfbuzz-devel fribidi-devel freetype-devel \
     libpng-devel libtiff-devel libjpeg-turbo-devel cairo-devel
   ```

## Installation

### 1. Clone or Download the Repository

```bash
git clone https://github.com/jm0535/0rdin.git
cd ordin
```

### 2. Install Node.js Dependencies

```bash
npm install
```

### 3. Set Up Portable R

#### Windows
```bash
# Open Cygwin terminal
cd /cygdrive/c/path/to/ordin
./get-r-win.sh
```

#### macOS
```bash
./get-r-mac.sh
```

#### Linux
```bash
# Use automated setup script (recommended)
chmod +x setup-linux.sh
./setup-linux.sh

# Or install R from your distribution's package manager
# Ubuntu/Debian: sudo apt install r-base r-base-dev
# Fedora: sudo dnf install R R-devel
# Arch: sudo pacman -S r
```

### 4. Install R Packages

```bash
Rscript install-v3-packages.R
```

This installs the required R packages into the portable R installation:
- shiny
- bslib
- vegan
- iNEXT
- ggplot2
- DT
- readr
- readxl
- dplyr
- tidyr
- shinyjs
- waiter
- shinyFeedback
- shinycssloaders
- shinyWidgets
- openxlsx
- jsonlite
- clipr
- shinyBS
- shinyalert
- viridis
- RColorBrewer

## Development

### Run in Development Mode

```bash
npm start
```

This launches the Electron app in development mode with DevTools available.

### Testing the App

1. Upload a CSV file with species abundance data:
   - First column: Site names
   - Remaining columns: Species abundances (numeric)

2. Select analysis type:
   - **Diversity Estimation**: Uses iNEXT for rarefaction curves
   - **Ordination**: Uses vegan for multivariate analysis
   - **Diversity Indices**: Calculates classic diversity metrics

3. Configure parameters and click Run

4. Explore results with dynamic theme switching

5. Download summary tables and plots using the download buttons

## Building for Distribution

### Create Distributable Package

```bash
npm run make
```

This creates platform-specific installers in the `out/` directory:

- **Windows**: `out/make/squirrel.windows/x64/Ördin-3.0.0 Setup.exe`
- **macOS**: `out/make/zip/darwin/x64/Ordin-darwin-x64-3.0.0.zip`
- **Linux (Debian/Ubuntu)**: `out/make/deb/x64/ordin_3.0.0_amd64.deb`
- **Linux (Fedora/RHEL)**: `out/make/rpm/x64/ordin-3.0.0-1.x86_64.rpm`
- **Linux (Generic)**: `out/make/zip/linux/x64/ordin-linux-x64-3.0.0.zip`

### Distribution

Share the generated installer with users. The app includes a portable R installation, so users don't need R installed on their system.

**Installation:**
- **Windows**: Run `.exe` installer - includes splash screen on first launch
- **macOS**: Unzip and drag `.app` to Applications
- **Debian/Ubuntu**: `sudo dpkg -i ordin_3.0.0_amd64.deb`
- **Fedora/RHEL**: `sudo dnf install ordin-3.0.0-1.x86_64.rpm`
- **Other Linux**: Extract `.zip` and run `./ordin`

## Project Structure

```
ordin/
├── src/
│   ├── index.js          # Electron main process
│   ├── preload.js        # Electron preload (context bridge)
│   └── start-shiny.R     # R Shiny server startup script
├── shiny/
│   ├── app.R             # Main Shiny application
│   └── www/              # Static assets (logo, etc.)
├── build/
│   ├── icon.ico          # Windows icon
│   └── icon.icns         # macOS icon
├── docs/                 # Comprehensive documentation
├── sample-data/          # Example datasets
├── get-r-win.sh          # Windows R installation script
├── get-r-mac.sh          # macOS R installation script
├── install-v3-packages.R # R package installation script
└── package.json          # Node.js configuration

```

## Customization

### Toggle Between Dark and Light Themes

**Ördin v2.3+** includes a theme toggle button on the far right of the navbar:
- Click the **☀️ (sun)** icon in dark mode to switch to light theme
- Click the **🌙 (moon)** icon in light mode to switch to dark theme
- Your preference is automatically saved and persists across app restarts

**Dark Theme** (default):
- Background: #1e1e1e (VS Code dark)
- Sidebar: #252526
- Text: #cccccc

**Light Theme**:
- Background: #ffffff
- Sidebar: #f8f8f8  
- Text: #1e1e1e

### Changing Plot Themes

**Ördin v3.0** introduces advanced plot theming:
- **Dark**: High-contrast dark background with bright colors
- **Light**: Clean white background with strong colors
- **Classic**: Traditional academic styling
- **Minimal**: Subtle grids and clean presentation
- **Publication**: Black-and-white for journal submissions

Themes can be changed dynamically without re-running analyses.

### Adding Custom Branding

1. Place your logo in `shiny/www/logo.png`
2. Update the UI to include it:

```r
title = tagList(img(src = "logo.png", height = "50px"), "Ördin")
```

## Troubleshooting

### npm Installation Errors
```bash
npm audit fix
# or
rm -rf node_modules package-lock.json
npm install
```

### R Package Installation Fails
- Ensure `automagic` is installed: `install.packages("automagic")`
- Check R version compatibility (4.4+)
- Try installing packages manually in RStudio

### Electron Build Issues
- Clear the cache: `rm -rf out/`
- Rebuild: `npm run make`

### Port Already in Use
- The app uses port 9054 by default
- Change it in `src/start-shiny.R`: `options(shiny.port = 9054)`

## Community Ecology Analysis in Ördin

### 📊 Diversity Analysis Approaches

Ördin implements comprehensive diversity analysis following modern ecological standards:

**Diversity Estimation (iNEXT)**:
- Individual-based rarefaction (abundance data)
- Incidence-based rarefaction (presence/absence data)
- Coverage-based comparison (standardizes by sample completeness)
- Hill numbers (q=0, 1, 2) for true diversity measures
- Bootstrap confidence intervals for robust inference

**Diversity Indices (vegan)**:
- Alpha diversity metrics for within-community diversity
- Evenness measures for distribution uniformity
- Rarefaction for standardized comparisons
- Species accumulation curves for sampling sufficiency

### 🗺️ Ordination Methods

Ördin provides 7 ordination methods for community pattern analysis:

1. **NMDS**: Non-metric dimensional scaling for non-linear relationships
2. **PCA**: Principal components analysis for linear relationships
3. **CA**: Correspondence analysis for unimodal species responses
4. **DCA**: Detrended correspondence analysis to remove arch effect
5. **CCA**: Canonical correspondence analysis for constrained ordination
6. **RDA**: Redundancy analysis for linear constrained ordination
7. **PCoA**: Principal coordinates analysis for distance-based methods

### 📈 Advanced Visualization Features

**Ördin v3.0** introduces next-gen visualization capabilities:

- **Confidence Ellipses**: Statistical ellipses for site groups with validation
- **Species Scores**: Overlay species positions with customizable display
- **Environmental Vectors**: Biplot arrows showing environmental relationships
- **Dynamic Theming**: 5 plot themes with instant switching
- **Comprehensive Legends**: Clear explanation of all plot elements
- **Axis Labels**: Variance percentages for interpretability
- **Export Options**: Publication-quality images and data downloads

### 💾 Publication-Quality Exports

Ördin provides publication-quality export options for all analyses:

**Raster Formats** (300 DPI - publication standard):
- **PNG** - Universal compatibility, lossless compression
- **TIFF** - Journal submission standard, archival quality
- **SVG** - Vector format for scalable graphics

**Data Exports**:
- **CSV** - Universal data format
- **Excel** - Spreadsheet compatibility
- **JSON** - Structured data for programming

**Export Settings**:
- Dimensions: 12" × 8" (standard publication size)
- DPI: 300 for raster formats (journal requirement)
- Theme consistency: Respects selected plot themes
- Background: Theme-appropriate backgrounds preserved

## Documentation

### 📚 User Guides

Detailed guides organized in the [`docs/`](docs/) directory:

**Analysis Guides** (`docs/guides/`):
- [Ordination Guide](docs/guides/ENTERPRISE_ORDINATION_GUIDE.md) - Comprehensive ordination analysis
- [Data Management](docs/guides/DATA_MANAGEMENT_GUIDE.md) - Data handling and validation
- [Biplot Guide](docs/guides/BIPLOT_GUIDE.md) - Biplot interpretation
- [CCA/RDA Guide](docs/guides/CCA_RDA_GUIDE.md) - Constrained ordination
- [Plot Customization](docs/guides/PLOT-CUSTOMIZATION-GUIDE.md) - Customization options
- [Settings Guide](docs/guides/SETTINGS_GUIDE.md) - Application configuration

**Setup Guides** (`docs/setup/`):
- [Linux Setup](docs/setup/SETUP-LINUX.md) - Linux installation
- [WSL Setup](docs/setup/SETUP-WSL.md) - Windows Subsystem for Linux
- [Fedora Quick Start](docs/setup/FEDORA-QUICKSTART.md) - Fedora-specific setup
- [Publishing Guide](docs/setup/PUBLISH.md) - How to publish releases

**Developer Documentation** (`docs/development/`):
- [Project Overview](docs/development/PROJECT_OVERVIEW.md) - Architecture and technology stack
- [Reproducibility Guide](docs/development/DEVELOPER-GUIDE-REPRODUCIBILITY.md) - Reproducible research
- [Security Audit](docs/development/SECURITY-AUDIT.md) - Security review
- [Test Checklist](docs/development/TEST_CHECKLIST.md) - Testing guidelines

### 📘 Community Guidelines

- [Getting Started](.github/GETTING_STARTED.md) - Quick start guide
- [Contributing](.github/CONTRIBUTING.md) - Development guidelines
- [Code of Conduct](.github/CODE_OF_CONDUCT.md) - Community standards
- [Code Standards](.github/CODE_STANDARDS.md) - Coding conventions

### 📜 Version History

- [CHANGELOG.md](CHANGELOG.md) - Complete version history and release notes

## License

MIT License - See LICENSE file for details

## Author

Jimmy Moses (jimmy.moses@pnguot.ac.pg)

## Acknowledgments

- Inspired by Odin's wisdom from Norse mythology
- Built with [Electron](https://www.electronjs.org/)
- Powered by [R Shiny](https://shiny.rstudio.com/)
- Uses [vegan](https://github.com/vegandevs/vegan) and [iNEXT](https://github.com/JohnsonHsieh/iNEXT) packages

---

## Star History

If you find Ördin useful, please consider giving it a ⭐️ on GitHub!

## Support

- **Issues**: [GitHub Issues](https://github.com/jm0535/0rdin/issues)
- **Discussions**: [GitHub Discussions](https://github.com/jm0535/0rdin/discussions)
- **Email**: jimmy.moses@pnguot.ac.pg

## Citation

If you use Ördin in your research, please cite:

```
Moses, J. (2025). Ördin: A cross-platform desktop application for community ecology analysis. 
GitHub repository: https://github.com/jm0535/0rdin
```