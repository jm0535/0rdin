# Ördin 2.x/3.x — Quick Start Guide (legacy)

> ⚠️ **Legacy document (Ördin 3.x).** This describes the R Shiny + Electron
> application in `shiny/` and `src/`, which is kept for maintenance only.
> For the current release see [Documentation Index](DOCS-INDEX.md) ·
> [Quick Start](QUICKSTART.md) · [Architecture](ARCHITECTURE.md).

## 🚀 Getting Started in 5 Minutes

Welcome to **Ördin** - your enterprise-grade biodiversity analysis desktop application!

---

## 📦 Installation

### Windows
1. Download `Ördin-2.0.0 Setup.exe`
2. Run the installer
3. Launch Ördin from Start Menu or Desktop
4. **Professional splash screen** appears during startup
5. Main application window opens automatically

### macOS
1. Download `Ordin-darwin-x64-2.0.0.zip`
2. Extract the ZIP file
3. Drag `Ordin.app` to Applications folder
4. Launch from Applications

### Linux (Debian/Ubuntu)
```bash
sudo dpkg -i ordin_2.0.0_amd64.deb
ordin
```

### Linux (Fedora/RHEL)
```bash
sudo dnf install ordin-2.0.0-1.x86_64.rpm
ordin
```

---

## 📊 Your First Analysis

### Step 1: Prepare Your Data

Ördin accepts **CSV files** with the following structure:

**For Abundance Data** (individual counts):
```csv
Site,Species1,Species2,Species3
Site1,12,5,8
Site2,8,3,12
Site3,15,7,6
```

**For Incidence Data** (presence/absence):
```csv
Site,Species1,Species2,Species3
Trap1,1,0,1
Trap2,0,1,1
Trap3,1,1,0
```

💡 **Tip**: Try the included sample datasets first! Find them in the "Sample Data" dropdown.

---

### Step 2: Upload Your Data

1. Click **"Browse"** button in the sidebar
2. Select your CSV file
3. Ördin automatically previews your data
4. ✅ Data validation happens in real-time

---

### Step 3: Choose Analysis Type

#### 📊 **Diversity Estimation** (iNEXT)
Calculates species diversity using rarefaction/extrapolation:

**Data Type Selection**:
- **Abundance** - Individual counts (e.g., spider surveys, bird counts)
- **Incidence (Frequency)** - Trap-based data (e.g., pitfall traps, camera traps)
- **Incidence (Raw)** - Presence/absence matrix

**Plot Type** (3 options):
1. **Sample-size based** (Type 1) - Standard rarefaction curves
2. **Sample completeness** (Type 2) - How complete is your survey?
3. **Coverage-based** (Type 3) - Fair comparison at equal completeness

**Advanced Options** (⚛️ Optional):
- **Hill Numbers**: Select q=0 (richness), q=1 (Shannon), q=2 (Simpson)
- **Knots**: Curve smoothness (10-200, default: 40)
- **Bootstrap Replicates**: Confidence interval accuracy (10-500, default: 50)
- **Confidence Level**: CI width (0.80-0.99, default: 0.95)
- **Extrapolation Endpoint**: How far to extrapolate (default: double sample size)

#### 🗺️ **Ordination Analysis** (vegan NMDS)
Visualizes community composition patterns:

**Parameters**:
- **Dimensions**: 2D or 3D ordination (default: 2)
- **Distance Method**: Bray-Curtis dissimilarity (default)

---

### Step 4: Run Analysis

1. Click **"▶️ Run Analysis"** button
2. **Progress indicator** shows real-time status:
   - "Validating data..." (10%)
   - "Checking data quality..." (5%)
   - "Validating requirements..." (5%)
   - "Running analysis..." (80%)
3. Results appear automatically when complete!

---

### Step 5: Explore Results

#### 📊 Summary Table
- Interactive table with sorting and filtering
- Click column headers to sort
- Use search box to find specific sites/species
- **Download CSV**: Click "CSV" button in table toolbar

#### 📈 Visualization
- High-quality plot with dark theme
- Shaded confidence intervals (for iNEXT)
- Professional styling for publications
- **Zoom**: Click and drag to zoom into plot areas

---

### Step 6: Export Publication-Quality Plots

#### Choose Your Format:

**Raster Formats** (300 DPI):
- **PNG** → General use, presentations, web
- **TIFF** → Journal submission, archival
- **JPEG** → Smaller file size, presentations

**Vector Formats** (scalable):
- **SVG** → Web, infinite zoom, modern journals
- **PostScript** → LaTeX documents, academic publishing

#### Export Steps:
1. Above the plot, click the **format selector dropdown**
2. Choose your desired format (PNG, TIFF, JPEG, SVG, or PS)
3. Click **"Download Plot"** button
4. File saved as: `ordin_[analysis-type]_plot_[date].[format]`

#### Export Specifications:
- **Dimensions**: 12" × 8" (standard publication size)
- **Resolution**: 300 DPI for raster formats (journal standard)
- **Background**: Dark theme (#222222) preserved
- **Font**: Helvetica family (PostScript compatible)

---

## 📚 Sample Datasets

Ördin includes 4 real research datasets:

### 1. 🕷️ **Spider Abundance**
- **Type**: Abundance data
- **Description**: Spider communities from Girdled/logged forests
- **Use for**: Individual-based rarefaction
- **Recommended**: Plot Type 1 or 3

### 2. 🐦 **Bird Abundance**
- **Type**: Abundance data
- **Description**: Breeding bird surveys from mixed forests
- **Use for**: Diversity comparison across sites
- **Recommended**: Plot Type 3 (coverage-based)

### 3. 🦠 **Ciliates Abundance**
- **Type**: Abundance data
- **Description**: Soil ciliate communities
- **Use for**: Microorganism diversity analysis
- **Recommended**: Plot Type 1 or 2

### 4. 🐜 **Ant Incidence**
- **Type**: Incidence-frequency data
- **Description**: Ant species from Malaysian rainforest (trap-based)
- **Use for**: Incidence-based rarefaction
- **Recommended**: Plot Type 1, select "Incidence (Frequency)"

---

## 🛠️ Advanced Features

### iNEXT Advanced Options

#### Hill Numbers (q values)
- **q=0** (Species Richness) - Counts all species equally
- **q=1** (Shannon Diversity) - Weighted by abundance
- **q=2** (Simpson Diversity) - Emphasizes dominant species

💡 **Tip**: Select multiple to compare diversity perspectives!

#### Knots (10-200)
- Controls curve smoothness
- **Lower** (10-20) = Rougher, follows data closely
- **Higher** (100-200) = Smoother, more interpolation
- **Default** (40) = Balanced, recommended for most analyses

#### Bootstrap Replicates (10-500)
- Accuracy of confidence intervals
- **More replicates** = More accurate, but slower
- **Default** (50) = Good balance
- **Publication** (200+) = High accuracy for papers

#### Confidence Level (0.80-0.99)
- Width of confidence interval ribbons
- **0.95** (95%) = Standard for most journals
- **0.99** (99%) = Wider intervals, more conservative

#### Extrapolation Endpoint
- How far to project beyond your sample
- **Default**: 2× your largest sample size
- **Conservative**: 1.5× sample size
- **Exploratory**: 3× sample size

---

## ✨ What's New in v2.0?

### 🎨 Professional Splash Screen
- **Animated Ö logo** during app loading
- Rotating status messages
- Smooth transition to main window
- Enterprise-grade first impression

### 💾 Publication-Quality Exports
- **5 export formats**: PNG, TIFF, JPEG, SVG, PostScript
- **300 DPI** raster output (journal standard)
- **Vector formats** for infinite scalability
- **Consistent 12"×8"** dimensions

### 🔄 Enhanced Progress Indicators
- Real-time feedback for all data types
- Incremental progress updates
- Fixed: Progress not showing for incidence data
- Validation steps clearly communicated

### 🎯 Improved UI/UX
- Removed redundant download buttons
- Contextual export controls (above each plot)
- Better parameter organization
- Professional visual hierarchy

### 🐛 Critical Fixes
- **Results display**: 100% reliable, no more stuck welcome page
- **Logo rendering**: Ö fully visible at all zoom levels
- **Progress feedback**: Immediate response for all analyses
- **Icon cleanup**: No duplicate download icons

---

## 🔍 Troubleshooting

### Results Not Showing?
- ✅ **Fixed in v2.0!** Results now display reliably
- If issues persist, try refreshing the page (Ctrl+R / Cmd+R)

### Progress Indicator Not Appearing?
- ✅ **Fixed in v2.0!** Progress shows immediately for all data types
- Validation steps now provide incremental feedback

### Logo Cut Off at Top?
- ✅ **Fixed in v2.0!** Ö logo fully visible at 100% zoom
- Proper spacing for umlaut dots at all zoom levels

### Data Upload Fails?
- Check CSV format: First column = Site names, rest = numeric data
- Ensure no empty cells or text in species columns
- Try a sample dataset first to verify app is working

### Analysis Takes Too Long?
- Large datasets may take time (normal)
- Progress bar shows current step
- For iNEXT: Reduce bootstrap replicates (e.g., 50 → 20)

### Plot Export Issues?
- Ensure you've run analysis first
- Select format from dropdown before clicking download
- Check download folder for saved file

---

## 📚 Further Reading

### Essential Documentation
- **README.md** - Installation and setup guide
- **CHANGELOG.md** - Version history and new features
- **IMPLEMENTATION-STATUS.md** - Current status and future roadmap

### Analysis Guides
- **ESTIMATES-AND-RAREFACTION-TYPES.md** - Rarefaction theory
- **docs/RAREFACTION-QUICK-GUIDE.md** - Which analysis to choose?
- **docs/RAREFACTION-IMPLEMENTATION.md** - Technical implementation
- **docs/INEXT-PARAMETERS-GUIDE.md** - Complete parameter reference

### Technical Documentation
- **docs/SPLASH-SCREEN-IMPLEMENTATION.md** - Splash screen technical guide
- **docs/FIX-SUMMARY-RESULTS-DISPLAY.md** - Results display fix explanation
- **docs/VEGAN-COMPREHENSIVE-RESEARCH.md** - Future expansion plans

---

## 💬 Support

### Get Help
- **GitHub Issues**: [Report bugs or request features](https://github.com/jm0535/0rdin/issues)
- **GitHub Discussions**: [Ask questions or share ideas](https://github.com/jm0535/0rdin/discussions)
- **Email**: jmoses@pnguot.ac.pg

### Community
- Share your analyses and feedback!
- Contribute sample datasets
- Suggest new features for future versions

---

## 🏆 Best Practices

### For Publication-Ready Results:

1. **Use appropriate data type**:
   - Abundance data → "Abundance"
   - Trap-based data → "Incidence (Frequency)"
   - Presence/absence matrix → "Incidence (Raw)"

2. **Choose the right plot type**:
   - **Type 1** - Standard comparison
   - **Type 2** - Survey completeness assessment
   - **Type 3** - Fair comparison (recommended for papers!)

3. **Optimize parameters**:
   - Bootstrap replicates: 200+ for publications
   - Confidence level: 0.95 (standard)
   - All Hill numbers (q=0,1,2) for comprehensive view

4. **Export for journals**:
   - **TIFF** (300 DPI) - Most journal requirements
   - **SVG** - Modern journals accepting vector graphics
   - **PostScript** - LaTeX documents

5. **Document your analysis**:
   - Download summary CSV for data tables
   - Note all parameter settings used
   - Include Ördin version in methods section

---

## 🚀 What's Next?

### Future Modules (v2.1+)

Ördin v2.0 establishes the foundation for expansion:

1. **Ordination Module** (v2.1) - Expand from NMDS to 8 methods (PCA, CA, DCA, CCA, RDA, etc.)
2. **Diversity Indices** (v2.2) - Shannon, Simpson, evenness indices
3. **Community Analysis** (v2.3) - Dissimilarity matrices, clustering, beta diversity
4. **Hypothesis Testing** (v2.4) - PERMANOVA, ANOSIM, envfit
5. **Advanced Tools** (v2.5+) - Null models, nestedness, species-area curves

See **IMPLEMENTATION-STATUS.md** for complete roadmap!

---

## 👏 Acknowledgments

- **iNEXT team** (Anne Chao, T.C. Hsieh, K.H. Ma) - Rarefaction framework
- **vegan developers** - Community ecology toolkit
- **Electron & R Shiny communities** - Development frameworks
- **You!** - For using Ördin in your research

---

## 🎓 Citation

If you use Ördin in your research:

```
Moses, J. (2025). Ördin v2.0: Enterprise-grade biodiversity analysis desktop application. 
GitHub: https://github.com/jm0535/0rdin
```

**For iNEXT methods, also cite**:
```
Hsieh, T.C., Ma, K.H. and Chao, A. (2016). iNEXT: an R package for rarefaction and 
extrapolation of species diversity (Hill numbers). Methods in Ecology and Evolution, 
7(12), pp.1451-1456.
```

---

**Happy Analyzing! 🌿🔍**

*Version 2.0.0 | Last Updated: 2025-01-25*
