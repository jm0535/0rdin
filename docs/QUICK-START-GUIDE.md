# \u00d6rdin v2.0 - Quick Start Guide

## \ud83d\ude80 Getting Started in 5 Minutes

Welcome to **\u00d6rdin** - your enterprise-grade biodiversity analysis desktop application!

---

## \ud83d\udce6 Installation

### Windows
1. Download `\u00d6rdin-2.0.0 Setup.exe`
2. Run the installer
3. Launch \u00d6rdin from Start Menu or Desktop
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

## \ud83d\udcca Your First Analysis

### Step 1: Prepare Your Data

\u00d6rdin accepts **CSV files** with the following structure:

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

\ud83d\udca1 **Tip**: Try the included sample datasets first! Find them in the "Sample Data" dropdown.

---

### Step 2: Upload Your Data

1. Click **"Browse"** button in the sidebar
2. Select your CSV file
3. \u00d6rdin automatically previews your data
4. \u2705 Data validation happens in real-time

---

### Step 3: Choose Analysis Type

#### \ud83d\udcca **Diversity Estimation** (iNEXT)
Calculates species diversity using rarefaction/extrapolation:

**Data Type Selection**:
- **Abundance** - Individual counts (e.g., spider surveys, bird counts)
- **Incidence (Frequency)** - Trap-based data (e.g., pitfall traps, camera traps)
- **Incidence (Raw)** - Presence/absence matrix

**Plot Type** (3 options):
1. **Sample-size based** (Type 1) - Standard rarefaction curves
2. **Sample completeness** (Type 2) - How complete is your survey?
3. **Coverage-based** (Type 3) - Fair comparison at equal completeness

**Advanced Options** (\u269b\ufe0f Optional):
- **Hill Numbers**: Select q=0 (richness), q=1 (Shannon), q=2 (Simpson)
- **Knots**: Curve smoothness (10-200, default: 40)
- **Bootstrap Replicates**: Confidence interval accuracy (10-500, default: 50)
- **Confidence Level**: CI width (0.80-0.99, default: 0.95)
- **Extrapolation Endpoint**: How far to extrapolate (default: double sample size)

#### \ud83d\uddfa\ufe0f **Ordination Analysis** (vegan NMDS)
Visualizes community composition patterns:

**Parameters**:
- **Dimensions**: 2D or 3D ordination (default: 2)
- **Distance Method**: Bray-Curtis dissimilarity (default)

---

### Step 4: Run Analysis

1. Click **"\u25b6\ufe0f Run Analysis"** button
2. **Progress indicator** shows real-time status:
   - "Validating data..." (10%)
   - "Checking data quality..." (5%)
   - "Validating requirements..." (5%)
   - "Running analysis..." (80%)
3. Results appear automatically when complete!

---

### Step 5: Explore Results

#### \ud83d\udcca Summary Table
- Interactive table with sorting and filtering
- Click column headers to sort
- Use search box to find specific sites/species
- **Download CSV**: Click "CSV" button in table toolbar

#### \ud83d\udcc8 Visualization
- High-quality plot with dark theme
- Shaded confidence intervals (for iNEXT)
- Professional styling for publications
- **Zoom**: Click and drag to zoom into plot areas

---

### Step 6: Export Publication-Quality Plots

#### Choose Your Format:

**Raster Formats** (300 DPI):
- **PNG** \u2192 General use, presentations, web
- **TIFF** \u2192 Journal submission, archival
- **JPEG** \u2192 Smaller file size, presentations

**Vector Formats** (scalable):
- **SVG** \u2192 Web, infinite zoom, modern journals
- **PostScript** \u2192 LaTeX documents, academic publishing

#### Export Steps:
1. Above the plot, click the **format selector dropdown**
2. Choose your desired format (PNG, TIFF, JPEG, SVG, or PS)
3. Click **"Download Plot"** button
4. File saved as: `ordin_[analysis-type]_plot_[date].[format]`

#### Export Specifications:
- **Dimensions**: 12" \u00d7 8" (standard publication size)
- **Resolution**: 300 DPI for raster formats (journal standard)
- **Background**: Dark theme (#222222) preserved
- **Font**: Helvetica family (PostScript compatible)

---

## \ud83d\udcda Sample Datasets

\u00d6rdin includes 4 real research datasets:

### 1. \ud83d\udd77\ufe0f **Spider Abundance**
- **Type**: Abundance data
- **Description**: Spider communities from Girdled/logged forests
- **Use for**: Individual-based rarefaction
- **Recommended**: Plot Type 1 or 3

### 2. \ud83d\udc26 **Bird Abundance**
- **Type**: Abundance data
- **Description**: Breeding bird surveys from mixed forests
- **Use for**: Diversity comparison across sites
- **Recommended**: Plot Type 3 (coverage-based)

### 3. \ud83e\udda0 **Ciliates Abundance**
- **Type**: Abundance data
- **Description**: Soil ciliate communities
- **Use for**: Microorganism diversity analysis
- **Recommended**: Plot Type 1 or 2

### 4. \ud83d\udc1c **Ant Incidence**
- **Type**: Incidence-frequency data
- **Description**: Ant species from Malaysian rainforest (trap-based)
- **Use for**: Incidence-based rarefaction
- **Recommended**: Plot Type 1, select "Incidence (Frequency)"

---

## \ud83d\udee0\ufe0f Advanced Features

### iNEXT Advanced Options

#### Hill Numbers (q values)
- **q=0** (Species Richness) - Counts all species equally
- **q=1** (Shannon Diversity) - Weighted by abundance
- **q=2** (Simpson Diversity) - Emphasizes dominant species

\ud83d\udca1 **Tip**: Select multiple to compare diversity perspectives!

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
- **Default**: 2\u00d7 your largest sample size
- **Conservative**: 1.5\u00d7 sample size
- **Exploratory**: 3\u00d7 sample size

---

## \u2728 What's New in v2.0?

### \ud83c\udfa8 Professional Splash Screen
- **Animated \u00d6 logo** during app loading
- Rotating status messages
- Smooth transition to main window
- Enterprise-grade first impression

### \ud83d\udcbe Publication-Quality Exports
- **5 export formats**: PNG, TIFF, JPEG, SVG, PostScript
- **300 DPI** raster output (journal standard)
- **Vector formats** for infinite scalability
- **Consistent 12"\u00d78"** dimensions

### \ud83d\udd04 Enhanced Progress Indicators
- Real-time feedback for all data types
- Incremental progress updates
- Fixed: Progress not showing for incidence data
- Validation steps clearly communicated

### \ud83c\udfaf Improved UI/UX
- Removed redundant download buttons
- Contextual export controls (above each plot)
- Better parameter organization
- Professional visual hierarchy

### \ud83d\udc1b Critical Fixes
- **Results display**: 100% reliable, no more stuck welcome page
- **Logo rendering**: \u00d6 fully visible at all zoom levels
- **Progress feedback**: Immediate response for all analyses
- **Icon cleanup**: No duplicate download icons

---

## \ud83d\udd0d Troubleshooting

### Results Not Showing?
- \u2705 **Fixed in v2.0!** Results now display reliably
- If issues persist, try refreshing the page (Ctrl+R / Cmd+R)

### Progress Indicator Not Appearing?
- \u2705 **Fixed in v2.0!** Progress shows immediately for all data types
- Validation steps now provide incremental feedback

### Logo Cut Off at Top?
- \u2705 **Fixed in v2.0!** \u00d6 logo fully visible at 100% zoom
- Proper spacing for umlaut dots at all zoom levels

### Data Upload Fails?
- Check CSV format: First column = Site names, rest = numeric data
- Ensure no empty cells or text in species columns
- Try a sample dataset first to verify app is working

### Analysis Takes Too Long?
- Large datasets may take time (normal)
- Progress bar shows current step
- For iNEXT: Reduce bootstrap replicates (e.g., 50 \u2192 20)

### Plot Export Issues?
- Ensure you've run analysis first
- Select format from dropdown before clicking download
- Check download folder for saved file

---

## \ud83d\udcda Further Reading

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

## \ud83d\udcac Support

### Get Help
- **GitHub Issues**: [Report bugs or request features](https://github.com/jm0535/0rdin/issues)
- **GitHub Discussions**: [Ask questions or share ideas](https://github.com/jm0535/0rdin/discussions)
- **Email**: jmoses@pnguot.ac.pg

### Community
- Share your analyses and feedback!
- Contribute sample datasets
- Suggest new features for future versions

---

## \ud83c\udfc6 Best Practices

### For Publication-Ready Results:

1. **Use appropriate data type**:
   - Abundance data \u2192 "Abundance"
   - Trap-based data \u2192 "Incidence (Frequency)"
   - Presence/absence matrix \u2192 "Incidence (Raw)"

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
   - Include \u00d6rdin version in methods section

---

## \ud83d\ude80 What's Next?

### Future Modules (v2.1+)

\u00d6rdin v2.0 establishes the foundation for expansion:

1. **Ordination Module** (v2.1) - Expand from NMDS to 8 methods (PCA, CA, DCA, CCA, RDA, etc.)
2. **Diversity Indices** (v2.2) - Shannon, Simpson, evenness indices
3. **Community Analysis** (v2.3) - Dissimilarity matrices, clustering, beta diversity
4. **Hypothesis Testing** (v2.4) - PERMANOVA, ANOSIM, envfit
5. **Advanced Tools** (v2.5+) - Null models, nestedness, species-area curves

See **IMPLEMENTATION-STATUS.md** for complete roadmap!

---

## \ud83d\udc4f Acknowledgments

- **iNEXT team** (Anne Chao, T.C. Hsieh, K.H. Ma) - Rarefaction framework
- **vegan developers** - Community ecology toolkit
- **Electron & R Shiny communities** - Development frameworks
- **You!** - For using \u00d6rdin in your research

---

## \ud83c\udf93 Citation

If you use \u00d6rdin in your research:

```
Moses, J. (2025). \u00d6rdin v2.0: Enterprise-grade biodiversity analysis desktop application. 
GitHub: https://github.com/jm0535/0rdin
```

**For iNEXT methods, also cite**:
```
Hsieh, T.C., Ma, K.H. and Chao, A. (2016). iNEXT: an R package for rarefaction and 
extrapolation of species diversity (Hill numbers). Methods in Ecology and Evolution, 
7(12), pp.1451-1456.
```

---

**Happy Analyzing! \ud83c\udf3f\ud83d\udd0d**

*Version 2.0.0 | Last Updated: 2025-01-25*
