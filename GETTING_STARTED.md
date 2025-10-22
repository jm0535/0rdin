# 🌿 Getting Started with Ördin

Welcome to **Ördin** - your desktop companion for biodiversity analysis! This guide will get you up and running in just a few minutes.

## What is Ördin?

Ördin (inspired by Odin from Norse mythology) is a desktop application that makes biodiversity analysis accessible and beautiful. It combines:

- **iNEXT** for diversity estimation
- **vegan** for ordination analysis (NMDS)
- A modern, dark-themed interface
- Cross-platform support (Windows & macOS)

No command-line expertise needed - just upload your data and explore!

---

## 🚀 Quick Setup (5 minutes)

### Step 1: Install Node.js

Download and install Node.js LTS (v18 or v20) from [nodejs.org](https://nodejs.org)

**Verify installation:**
```bash
node --version
npm --version
```

### Step 2: Run Setup Script

**On Windows:**
```bash
cd c:\path\to\ordin
setup.bat
```

**On macOS/Linux:**
```bash
cd /path/to/ordin
chmod +x setup.sh
./setup.sh
```

This installs all Node.js dependencies automatically.

### Step 3: Set Up Portable R

#### Windows (requires Cygwin)

First, install [Cygwin](https://cygwin.com) with the `wget` package, then:

```bash
# In Cygwin terminal
cd /cygdrive/c/path/to/ordin
./get-r-win.sh
```

**Don't have Cygwin?** You can also:
1. Install R from [r-project.org](https://www.r-project.org/)
2. Edit `src/index.js` to point to your system R installation

#### macOS

```bash
./get-r-mac.sh
```

**This takes 5-10 minutes** - R is downloading and extracting.

### Step 4: Install R Packages

```bash
Rscript add-cran-binary-pkgs.R
```

This installs:
- `shiny`, `bslib` - Web interface
- `vegan` - Ordination
- `iNEXT` - Diversity estimation
- `ggplot2`, `DT`, `readr` - Visualization and data handling

**Takes another 5-10 minutes** depending on your internet speed.

### Step 5: Launch Ördin!

```bash
npm start
```

🎉 Ördin should open in a new window!

---

## 📊 Your First Analysis

### 1. Try the Sample Data

1. Click **"Upload Species Abundance CSV"**
2. Navigate to `sample-data/example-biodiversity.csv`
3. Select **"Diversity Estimation (iNEXT)"**
4. Click **"Run Analysis"**

You should see:
- A summary table with diversity indices
- A rarefaction/extrapolation curve
- Download buttons for CSV and PNG

### 2. Try NMDS Ordination

1. Keep the same data loaded
2. Select **"Ordination (NMDS via vegan)"**
3. Set **NMDS Dimensions** to `2`
4. Click **"Run Analysis"**

You should see:
- A scatter plot showing site similarity
- Stress value (< 0.1 is excellent)
- Sites closer together have similar species compositions

### 3. Use Your Own Data

**Format your CSV like this:**

| Site | Species_A | Species_B | Species_C |
|------|-----------|-----------|-----------|
| Plot1 | 15 | 23 | 8 |
| Plot2 | 18 | 19 | 12 |
| Plot3 | 5 | 45 | 2 |

- **First column**: Site/sample names
- **Other columns**: Species abundances (integers)
- **Missing species**: Enter `0` (not blank)

---

## 🎨 Customization

### Change the Theme

Edit `shiny/app.R` and modify:

```r
bs_theme(
  version = 5, 
  bootswatch = "flatly",  # Try: darkly, cosmo, united, etc.
  primary = "#3498db"     # Your favorite color
)
```

Available themes: darkly, flatly, cosmo, united, sandstone, cerulean, journal, and more!

### Add Your Logo

1. Place `logo.png` in `shiny/www/`
2. Edit the `title` parameter in `shiny/app.R`:

```r
title = tagList(
  img(src = "logo.png", height = "50px"),
  "Ördin: Biodiversity Analysis"
)
```

---

## 📦 Building for Distribution

### Create a Standalone App

```bash
npm run make
```

**Output:**
- **Windows**: `out/make/squirrel.windows/x64/Ördin-1.0.0 Setup.exe`
- **macOS**: `out/make/zip/darwin/x64/Ordin-darwin-x64-1.0.0.zip`

Share these files with colleagues - they don't need R or Node.js installed! Everything is bundled.

---

## 🆘 Troubleshooting

### "npm install" fails

**Solution:**
```bash
rm -rf node_modules package-lock.json
npm install
```

### "Port 8888 already in use"

**Solution:** Edit `src/start-shiny.R` and change:
```r
options(shiny.port = 9999)  # Use different port
```

Also update `SHINY_PORT` in `src/index.js` to match.

### R packages won't install

**Solution:** Install manually in RStudio:
```r
install.packages(c("shiny", "bslib", "vegan", "iNEXT", "ggplot2", "DT", "readr"))
```

Then update `src/index.js` to use system R instead of portable R.

### App window is blank

1. Open DevTools (Ctrl+Shift+I)
2. Check Console tab for errors
3. Verify Shiny server started (check terminal output)

**Common fix:** Increase timeout in `src/index.js`:
```javascript
setTimeout(() => {
  checkShinyReady().then(resolve).catch(reject);
}, 10000);  // 10 seconds instead of 5
```

---

## 📚 Learn More

- **[README.md](README.md)** - Full documentation
- **[docs/QUICKSTART.md](docs/QUICKSTART.md)** - Detailed setup guide
- **[docs/DEVELOPMENT.md](docs/DEVELOPMENT.md)** - Developer guide
- **[sample-data/README.md](sample-data/README.md)** - Data format help

## 💡 Tips

- **Faster NMDS**: Use fewer dimensions (1 or 2)
- **Better plots**: Increase DPI in `ggsave()` calls
- **Dark mode plots**: Already enabled! Check the NMDS plot background
- **Interactive tables**: Click column headers to sort in the summary table

---

## 🤝 Support

Having issues? Reach out:
- **Email**: jmoses@pnguot.ac.pg
- **GitHub**: Open an issue on the repository

---

## 🌟 What's Next?

Now that you have Ördin running:

1. ✅ Test with sample data
2. ✅ Try your own biodiversity datasets
3. ✅ Customize the theme and branding
4. ✅ Build a standalone app for colleagues
5. 📖 Explore advanced features in [DEVELOPMENT.md](docs/DEVELOPMENT.md)

**Happy analyzing!** 🦅📊🌿

*Ördin - Bringing wisdom to ecological data*

---

**Version**: 1.0.0  
**Author**: Jimmy Moses  
**License**: MIT
