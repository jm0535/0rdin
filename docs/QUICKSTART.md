# Quick Start Guide for Ördin

Welcome to **Ördin** - your desktop biodiversity analysis companion!

## First Time Setup

### 1. Prerequisites Check

Before running Ördin for the first time, ensure you have:

- ✅ **Node.js** (v18 or v20 LTS) - [Download here](https://nodejs.org)
- ✅ **Git** - [Download here](https://git-scm.com)
- ✅ **R** (v4.0+) - [Download here](https://www.r-project.org/)

#### Windows Only:
- ✅ **Cygwin** with `wget` - [Download here](https://cygwin.com)
- ✅ **Innoextract** - Install via: `choco install innoextract`

### 2. Install Dependencies

Open a terminal in the `ordin` folder and run:

```bash
npm install
```

This will install all required Node.js packages for Electron.

### 3. Set Up Portable R

#### On Windows (using Cygwin):
```bash
cd /cygdrive/c/path/to/ordin
./get-r-win.sh
```

#### On macOS:
```bash
./get-r-mac.sh
```

This downloads and extracts a portable R installation (no admin rights needed).

### 4. Install R Packages

```bash
Rscript add-cran-binary-pkgs.R
```

This installs all required biodiversity packages:
- `shiny` - Web application framework
- `bslib` - Modern UI theming
- `vegan` - Community ecology package (NMDS ordination)
- `iNEXT` - Diversity estimation
- `ggplot2` - Data visualization
- `DT` - Interactive tables
- `readr` - CSV file reading

**Note**: This may take 5-10 minutes depending on your internet connection.

## Running Ördin

### Development Mode

To test the app during development:

```bash
npm start
```

This opens Ördin in a window with developer tools available (Ctrl+Shift+I).

### Building for Production

To create a standalone executable:

```bash
npm run make
```

**Output locations:**
- **Windows**: `out/make/squirrel.windows/x64/Ördin-1.0.0 Setup.exe`
- **macOS**: `out/make/zip/darwin/x64/Ordin-darwin-x64-1.0.0.zip`

The executable includes everything needed - users don't need R installed!

## Using Ördin

### 1. Prepare Your Data

Create a CSV file with:
- **First column**: Site/sample names
- **Other columns**: Species abundances (numeric)

Example: `sample-data/example-biodiversity.csv`

### 2. Upload Data

Click "Upload Species Abundance CSV" and select your file.

### 3. Choose Analysis

**Option A: Diversity Estimation (iNEXT)**
- Calculates species richness, Shannon, and Simpson diversity
- Generates rarefaction/extrapolation curves
- Best for comparing diversity across sites

**Option B: Ordination (NMDS via vegan)**
- Visualizes similarity between sites
- Set dimensions (2 recommended for visualization)
- Lower stress values indicate better fit (< 0.1 is excellent)

### 4. Run Analysis

Click "Run Analysis" and wait for results (usually < 30 seconds).

### 5. Explore Results

- **Summary Table**: Interactive table with key statistics
- **Visualization**: Plot showing diversity curves or ordination
- **Downloads**: Export tables (CSV) and plots (PNG)

## Tips & Tricks

### Data Quality
- Ensure all abundance values are integers (whole numbers)
- Use `0` for absent species (not blank cells)
- Remove empty columns before upload

### NMDS Interpretation
- **Stress < 0.05**: Excellent representation
- **Stress 0.05-0.1**: Good representation
- **Stress 0.1-0.2**: Acceptable (usable but some distortion)
- **Stress > 0.2**: Poor fit - consider fewer dimensions

### Performance
- Large datasets (>100 species, >50 sites) may take longer
- For NMDS, fewer dimensions = faster computation
- Close other applications if Ördin runs slowly

## Troubleshooting

### "Port already in use" error
Another app is using port 8888. Either:
- Close the other app, or
- Edit `src/start-shiny.R` and change `options(shiny.port = 8888)` to a different port

### R packages fail to install
Try installing manually in RStudio:
```r
install.packages(c("shiny", "bslib", "vegan", "iNEXT", "ggplot2", "DT", "readr"))
```

### App won't start
1. Check Node.js version: `node -v` (should be v18 or v20)
2. Reinstall dependencies: `rm -rf node_modules && npm install`
3. Check R installation: `R --version`

### CSV upload errors
- Verify CSV format (first column = sites, others = numeric)
- Check for special characters in column names
- Ensure file is comma-separated (not semicolon or tab)

## Getting Help

For issues or questions:
1. Check the [README.md](../README.md) for detailed information
2. Review sample data in `sample-data/` folder
3. Contact: Jimmy Moses (jmoses@pnguot.ac.pg)

## Next Steps

- Customize the theme in `shiny/app.R`
- Add your own logo to `build/icon.png`
- Explore advanced vegan features (see [vegan documentation](https://github.com/vegandevs/vegan))
- Try different ordination methods by editing the R code

---

**Happy analyzing!** 🌿📊

*Ördin - Bringing Odin's wisdom to your ecological data*
