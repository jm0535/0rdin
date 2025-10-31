# 🌿 Getting Started with Ördin

Welcome to **Ördin** - your desktop companion for community ecology analysis! This guide will get you up and running in just a few minutes.

## What is Ördin?

Ördin (inspired by Odin from Norse mythology) is a professional-grade desktop application for community ecology analysis. It combines:

- **iNEXT** for diversity estimation and rarefaction
- **vegan** for ordination (9 methods), diversity indices, and community analysis
- **Real-time plot customization** with 18+ controls via right panel
- **Interactive help system** with 17 topic pages
- **Comprehensive settings** with 6 sections for personalization
- A modern, VS Code-inspired interface with dark/light theme toggle
- Cross-platform support (Windows, macOS & Linux)

No command-line expertise needed - just upload your data, customize in real-time, and explore!

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

### Real-Time Plot Customization (NEW in v3.0!)

Ördin now features a **right panel** with 18+ controls for instant plot customization:

1. **Open the right panel**:
   - Click any plot in Diversity or Ordination modules
   - Look for the **"Customize Plot (Right Panel)"** menu item in the sidebar
   - Or click the **"PROPERTIES"** panel on the far right of the window

2. **Customize instantly** (no re-running needed!):
   - **Themes**: Clean, Minimal, Dark, Classic, Light, Void
   - **Typography**: Font family, sizes (base, title, axis, legend)
   - **Lines & Points**: Line width, point size, shapes, colors
   - **Grids**: Show/hide major and minor grids
   - **Legends**: Row count, size, position
   - **Export**: DPI, format, dimensions

3. **See changes immediately**:
   - All modifications apply in real-time
   - No need to click "Run Analysis" again
   - Perfect for exploring different visualizations!

**Example Workflow**:
1. Run NMDS analysis → See initial plot
2. Open right panel → Change theme to "Publication"
3. Adjust point size → See instant update
4. Toggle minor grids → See instant update
5. Set DPI to 600 → Download high-res plot

### Access the Settings System (NEW in v3.0!)

Ördin includes a comprehensive settings system with 6 sections:

1. Click **Settings (⚙️)** icon in the activity bar (left side)
2. Use the sidebar to navigate between sections:
   - **🌨️ Appearance**: Theme, font, UI zoom
   - **🎨 Plot Defaults**: Default theme, DPI, format, dimensions
   - **🧪 Analysis Defaults**: NMDS distance, k-dimensions, bootstrap, permutations
   - **📊 Data Management**: Auto-save, validation, cache
   - **⚡ Performance**: Performance mode, caching options
   - **🔧 Advanced**: R configuration, package versions
3. Click **"Save Settings"** to persist your preferences

### Use the Interactive Help System (NEW in v3.0!)

Ördin features comprehensive help documentation:

1. Click **Help (❓)** icon in the activity bar
2. Browse 17 topic pages via the sidebar:
   - **Getting Started**: Quick Start, What is Ördin, First Steps, Data Import
   - **Analysis Methods**: Ordination, Diversity, Statistics, Visualization
   - **Tutorials**: Import Guide, NMDS, iNEXT, Publication Plots
   - **Reference**: Citations, Shortcuts, Export, Troubleshooting
   - **Support**: FAQs, Bug Reports, Feature Requests
   - **About**: Version, Author, GitHub
3. Click any item → View that topic only (no scrolling!)

### Toggle Dark/Light Theme

Ördin includes a professional theme toggle:

1. Look at the **far right of the navbar** (if using old version)
2. Or use **Settings → Appearance → Theme** dropdown
3. Click the **☀️ (sun)** icon to switch to light theme
4. Click the **🌙 (moon)** icon to switch back to dark theme
5. Your preference is **automatically saved**!

**Benefits**:
- 🌞 **Light theme** for bright environments
- 🌙 **Dark theme** for low-light work (default)
- 💾 **Persistent** - choice is remembered
- ⚡ **Smooth** - animated transitions

### Change Theme Colors

Edit `shiny/app.R` and modify:

```r
bs_theme(
  version = 5,
  preset = "shiny",
  bg = "#1e1e1e",      # Dark background
  fg = "#cccccc",      # Light text
  primary = "#007acc", # VS Code blue (change to your color!)
  "enable-rounded" = FALSE,  # Flat design (no rounded corners)
  "enable-shadows" = FALSE   # Flat design (no shadows)
)
```

**Popular primary colors**:
- `#007acc` - VS Code blue (default)
- `#2e8b57` - Sea green
- `#e74c3c` - Red
- `#3498db` - Sky blue
- `#9b59b6` - Purple

**Note**: The built-in theme toggle will override these for light mode automatically!

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

- **Real-time customization**: Use right panel for instant plot changes (no re-running!)
- **Help system**: Press F1 or click Help icon for comprehensive documentation
- **Settings**: Access Settings icon to personalize app behavior
- **Toggle theme**: Use Settings → Appearance or navbar toggle
- **Faster NMDS**: Use fewer dimensions (1 or 2)
- **Better plots**: Customize theme, fonts, and colors in real-time
- **Interactive tables**: Click column headers to sort
- **Keyboard shortcuts**: Ctrl+Shift+I for DevTools

---

## 🤝 Support

Having issues? Reach out:
- **Email**: jimmy.moses@pnguot.ac.pg
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

*Ördin - Bringing wisdom to community ecology data*

---

**Version**: 3.0.0  
**Author**: Jimmy Moses  
**License**: MIT
