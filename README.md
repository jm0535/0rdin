# Ördin

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)](https://github.com/jm0535/0rdin)
[![R](https://img.shields.io/badge/R-%E2%89%A54.0-blue)](https://www.r-project.org/)
[![Node.js](https://img.shields.io/badge/Node.js-18%20%7C%2020-green)](https://nodejs.org/)

**Ördin** - A desktop application for biodiversity analysis, inspired by Odin's wisdom and oversight over ecological data.

## Overview

Ördin is an Electron-based desktop application that combines R's powerful biodiversity analysis packages (`vegan`, `iNEXT`) with a modern, user-friendly interface built using Shiny and Bootstrap 5.

### Features

- **Diversity Estimation**: Calculate species diversity indices using iNEXT
  - Rarefaction and extrapolation curves
  - Shannon, Simpson, and species richness estimates
  
- **Ordination Analysis**: Perform NMDS ordination using vegan
  - Non-metric multidimensional scaling
  - Bray-Curtis dissimilarity matrices
  - Customizable dimensions

- **Modern Interface**: Dark-themed Bootstrap 5 UI with full-screen capabilities
- **Export Capabilities**: Download summary tables (CSV) and plots (PNG)
- **Cross-Platform**: Works on Windows, macOS, and Linux (Debian/Ubuntu, Fedora/RHEL, Arch)

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

- **Windows**: `out/make/squirrel.windows/x64/Ördin-1.0.0 Setup.exe`
- **macOS**: `out/make/zip/darwin/x64/Ordin-darwin-x64-1.0.0.zip`
- **Linux (Debian/Ubuntu)**: `out/make/deb/x64/ordin_1.0.0_amd64.deb`
- **Linux (Fedora/RHEL)**: `out/make/rpm/x64/ordin-1.0.0-1.x86_64.rpm`
- **Linux (Generic)**: `out/make/zip/linux/x64/ordin-linux-x64-1.0.0.zip`

### Distribution

Share the generated installer with users. The app includes a portable R installation, so users don't need R installed on their system.

**Installation:**
- **Windows**: Run `.exe` installer
- **macOS**: Unzip and drag `.app` to Applications
- **Debian/Ubuntu**: `sudo dpkg -i ordin_1.0.0_amd64.deb`
- **Fedora/RHEL**: `sudo dnf install ordin-1.0.0-1.x86_64.rpm`
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

### Changing the Theme

Edit `shiny/app.R` and modify the `bs_theme()` parameters:

```r
bs_theme(
  version = 5, 
  bootswatch = "darkly",  # Try: flatly, cosmo, united, etc.
  primary = "#2e8b57",    # Change primary color
  "font-scale" = 1.1
)
```

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
Moses, J. (2025). Ördin: A cross-platform desktop application for biodiversity analysis. 
GitHub repository: https://github.com/jm0535/0rdin
```
