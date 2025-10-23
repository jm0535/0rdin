<div align="center">

<img src="build/icon.png" alt="Ördin Logo" width="128" height="128">

# Ördin

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-2.3.0-blue.svg)](https://github.com/jm0535/0rdin/releases)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)](https://github.com/jm0535/0rdin)
[![R](https://img.shields.io/badge/R-%E2%89%A54.0-blue)](https://www.r-project.org/)
[![Node.js](https://img.shields.io/badge/Node.js-18%20%7C%2020-green)](https://nodejs.org/)

**Ördin** - Enterprise-grade desktop application for community ecology analysis, combining the power of R with modern UX design. Complete modular architecture with diversity estimation, ordination, and ecological indices!

</div>

## Overview

Ördin is an enterprise-grade Electron-based desktop application that combines R's powerful community ecology packages (`vegan`, `iNEXT`) with a modern, professional interface built using Shiny and Bootstrap 5. Analyze community composition, diversity patterns, ordination, and ecological indices with publication-quality exports and a professional user experience.

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

### What's New in v2.0

- **🎨 Professional Splash Screen**: Enterprise-grade loading experience with animated Ö logo
- **📊 Publication-Quality Exports**: 5 formats (PNG, TIFF, JPEG, SVG, PostScript) at 300 DPI
- **🔄 Enhanced Progress Indicators**: Real-time feedback for all analysis steps
- **🎯 Improved UI/UX**: Contextual controls, better organization, no redundancy
- **🐛 Critical Fixes**: Reliable results display, logo rendering, progress feedback
- **📚 Comprehensive Documentation**: 4,500+ lines of technical guides

### Core Features

- **Diversity Estimation**: Calculate species diversity using iNEXT
  - **Individual-based rarefaction** (abundance data)
  - **Incidence-based rarefaction** (presence/absence data)
  - Three visualization types: sample-size, coverage, completeness
  - Rarefaction and extrapolation curves
  - Hill numbers (q=0, 1, 2): Species richness, Shannon, Simpson
  - 95% confidence intervals
  
- **Ordination Analysis**: Perform NMDS ordination using vegan
  - Non-metric multidimensional scaling
  - Bray-Curtis dissimilarity matrices
  - Customizable dimensions
  - Stress values and quality assessment

- **Modern Interface**: VS Code-inspired flat design with dark/light theme toggle and full-screen capabilities
- **Theme Toggle**: Switch between dark and light themes with one click (preference saved automatically)
- **Publication-Ready Exports**: 
  - **5 format options**: PNG, TIFF, JPEG (300 DPI), SVG, PostScript (vector)
  - **Consistent dimensions**: 12"×8" professional standard
  - **Format selector**: Contextual dropdown above each plot
  - Download summary tables (CSV) directly from interactive tables
- **Sample Datasets**: Includes real research data (spiders, birds, ciliates, ants)
- **Cross-Platform**: Works on Windows, macOS, and Linux (Debian/Ubuntu, Fedora/RHEL, Arch)
- **Professional UX**: Progress indicators, welcome screen, organized controls

## Prerequisites

Before building Ördin, ensure you have:

1. **Node.js** (LTS version 18.x or 20.x)
   - Download from [nodejs.org](https://nodejs.org)
   - Verify: `node -v` and `npm -v`

2. **Git**
   - Download from [git-scm.com](https://git-scm.com)
   - Verify: `git --version`

3. **R** (version 4.0 or higher)
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
git clone <repository-url>
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
Rscript add-cran-binary-pkgs.R
```

This installs the required R packages into the portable R installation:
- shiny
- bslib
- vegan
- iNEXT
- ggplot2
- DT
- readr

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
   - **Ordination**: Uses vegan for NMDS analysis

3. Click "Run Analysis" to generate results

4. Download summary tables and plots using the download buttons

## Building for Distribution

### Create Distributable Package

```bash
npm run make
```

This creates platform-specific installers in the `out/` directory:

- **Windows**: `out/make/squirrel.windows/x64/Ördin-2.0.0 Setup.exe`
- **macOS**: `out/make/zip/darwin/x64/Ordin-darwin-x64-2.0.0.zip`
- **Linux (Debian/Ubuntu)**: `out/make/deb/x64/ordin_2.0.0_amd64.deb`
- **Linux (Fedora/RHEL)**: `out/make/rpm/x64/ordin-2.0.0-1.x86_64.rpm`
- **Linux (Generic)**: `out/make/zip/linux/x64/ordin-linux-x64-2.0.0.zip`

### Distribution

Share the generated installer with users. The app includes a portable R installation, so users don't need R installed on their system.

**Installation:**
- **Windows**: Run `.exe` installer - includes splash screen on first launch
- **macOS**: Unzip and drag `.app` to Applications
- **Debian/Ubuntu**: `sudo dpkg -i ordin_2.0.0_amd64.deb`
- **Fedora/RHEL**: `sudo dnf install ordin-2.0.0-1.x86_64.rpm`
- **Other Linux**: Extract `.zip` and run `./ordin`

## Project Structure

```
ordin/
├── src/
│   ├── index.js          # Electron main process
│   ├── start-shiny.R     # R Shiny server startup script
│   └── helpers.js        # Utility functions
├── shiny/
│   ├── app.R             # Main Shiny application
│   └── www/              # Static assets (logo, etc.)
├── build/
│   ├── icon.ico          # Windows icon
│   └── icon.icns         # macOS icon
├── get-r-win.sh          # Windows R installation script
├── get-r-mac.sh          # macOS R installation script
├── add-cran-binary-pkgs.R # R package installation script
└── package.json          # Node.js configuration

```

## Customization

### Toggle Between Dark and Light Themes

**Ördin v2.3** includes a professional theme toggle button on the far right of the navbar:
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

### Changing the Theme Colors

Edit `shiny/app.R` and modify the `bs_theme()` parameters:

```r
bs_theme(
  version = 5,
  preset = "shiny",  # Base preset (can also try: "bootstrap", "shiny")
  bg = "#1e1e1e",    # Background color (dark)
  fg = "#cccccc",    # Foreground/text color
  primary = "#007acc",  # Primary accent color (VS Code blue)
  secondary = "#2d2d30",  # Secondary color
  "enable-rounded" = FALSE,  # Keep flat design (no rounded corners)
  "enable-shadows" = FALSE   # Keep flat design (no shadows)
)
```

**Note**: The theme toggle uses custom CSS classes that override these base colors for light mode.

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
- Check R version compatibility (4.0+)
- Try installing packages manually in RStudio

### Electron Build Issues
- Clear the cache: `rm -rf out/`
- Rebuild: `npm run make`

### Port Already in Use
- The app uses port 8888 by default
- Change it in `src/start-shiny.R`: `options(shiny.port = 8888)`

## Rarefaction Analysis in Ördin

### 📊 Three Types of Rarefaction Supported

Ördin implements all major rarefaction approaches from EstimateS software:

1. **Individual-Based Rarefaction** (Abundance data)
   - Standardizes by number of individuals
   - Use for: Population studies, community ecology
   - Datasets: spider, bird, ciliates

2. **Incidence-Based Rarefaction** (Presence/absence data)
   - Standardizes by sampling units (e.g., trap-days)
   - Use for: Trap studies, detection surveys, rare species
   - Datasets: ant

3. **Coverage-Based Comparison** (iNEXT innovation)
   - Standardizes by sample completeness
   - Use for: Fair comparison across different sampling efforts
   - Best for: Publication-quality analyses

### 📈 Three Visualization Types

- **Type 1: Sample-size-based** - Standard rarefaction curves
- **Type 2: Sample completeness** - Evaluate survey quality
- **Type 3: Coverage-based** - Fair comparison at equal completeness

### 💾 Publication-Quality Exports (v2.0)

Ördin v2.0 provides professional export options for all plots:

**Raster Formats** (300 DPI - publication standard):
- **PNG** - Universal compatibility, lossless compression
- **TIFF** - Journal submission standard, archival quality
- **JPEG** - Presentations, smaller file size

**Vector Formats** (infinite resolution):
- **SVG** - Web, presentations, scalable graphics
- **PostScript** - LaTeX documents, academic publishing

**Export Settings**:
- Dimensions: 12" × 8" (standard publication size)
- DPI: 300 for raster formats (journal requirement)
- Background: Dark (#222222) preserved in all formats
- Font: Helvetica family for PostScript compatibility

**How to Export**:
1. Run your analysis to generate plots
2. Above each plot, use the format selector dropdown
3. Choose your desired format (PNG, TIFF, JPEG, SVG, or PS)
4. Click "Download Plot" button
5. File saved as: `ordin_[analysis-type]_plot_[date].[format]`

### 📚 Documentation

Detailed guides available in the repository:

- [`ESTIMATES-AND-RAREFACTION-TYPES.md`](ESTIMATES-AND-RAREFACTION-TYPES.md) - Comprehensive theory
- [`docs/RAREFACTION-QUICK-GUIDE.md`](docs/RAREFACTION-QUICK-GUIDE.md) - Decision tree and examples
- [`docs/RAREFACTION-IMPLEMENTATION.md`](docs/RAREFACTION-IMPLEMENTATION.md) - Technical details
- [`INCIDENCE-VS-ABUNDANCE.md`](INCIDENCE-VS-ABUNDANCE.md) - Data format guide

### 🆚 Comparison with EstimateS

Ördin matches and exceeds EstimateS capabilities:

| Feature | EstimateS | Ördin |
|---------|-----------|-------|
| Individual-based rarefaction | ✅ | ✅ |
| Incidence-based rarefaction | ✅ | ✅ |
| Sample-based rarefaction | ✅ | ⚠️ Partial |
| Extrapolation | Limited | ✅ Full |
| Coverage-based | ❌ | ✅ Yes |
| Hill numbers (q=0,1,2) | Partial | ✅ Full |
| Confidence intervals | Bootstrap | Analytical + Bootstrap |
| Cross-platform | Windows/Mac | Windows/Mac/Linux |

---

## License

MIT License - See LICENSE file for details

## Author

Jimmy Moses (jmoses@pnguot.ac.pg)

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
- **Email**: jmoses@pnguot.ac.pg

## Citation

If you use Ördin in your research, please cite:

```
Moses, J. (2025). Ördin: A cross-platform desktop application for community ecology analysis. 
GitHub repository: https://github.com/jm0535/0rdin
```
