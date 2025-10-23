# Changelog - Ördin

All notable changes to this project will be documented in this file.

## [2.2.0] - 2025-10-23

### 🎉 Major Release: Complete Modular Architecture + vegan Integration

Version 2.2.0 represents a complete architectural transformation with modular tab-based navigation and comprehensive vegan package integration, increasing coverage from 0.5% to 9.5%.

### ✨ Added

#### Modular Tab-Based Architecture
- **4 independent modules** with dedicated interfaces:
  - 📊 **Diversity Estimation** - iNEXT rarefaction/extrapolation (from v2.0)
  - 🗺️ **Ordination Analysis** - 5 ordination methods (NEW)
  - 📈 **Diversity Indices** - Classic diversity metrics (NEW)
  - ℹ️ **Help & Info** - User guide and documentation (NEW)
- **Shared data loading** across all modules
- **Independent results areas** for each analysis type
- **Professional navigation** with icons and clear labels

#### v2.1: Ordination Module Expansion
**5 ordination methods** (added 4 new):
- ✅ **NMDS** - Non-metric Multidimensional Scaling (from v2.0)
- ✅ **PCA** - Principal Components Analysis (NEW)
- ✅ **CA** - Correspondence Analysis (NEW)
- ✅ **DCA** - Detrended Correspondence Analysis (NEW)
- ✅ **PCoA** - Principal Coordinates Analysis (NEW)

**5 distance/dissimilarity methods**:
- Bray-Curtis, Jaccard, Euclidean, Manhattan, Canberra

**Features**:
- 1-5 dimensions support
- Stress value reporting (NMDS)
- Ordination scores table
- Publication-quality plot exports
- Dark theme optimized visualizations

**Noted for future** (requires environmental data):
- CCA - Canonical Correspondence Analysis
- RDA - Redundancy Analysis
- db-RDA - Distance-based RDA

#### v2.2: Diversity Indices Module
**8 diversity and evenness indices**:

**Alpha Diversity**:
- Shannon (H') - Information entropy
- Simpson (1-D) - Dominance index
- Inverse Simpson (1/D) - True diversity
- Fisher's Alpha - Parametric diversity
- Species Richness (S) - Simple count

**Evenness Indices**:
- Pielou's Evenness (J') - Normalized Shannon
- Simpson's Evenness (E_1/D) - Dominance-based
- Evar - Variance-based evenness

**Rarefaction**:
- Rarefy to specified N individuals
- Auto-rarefy to minimum sample size
- Rarefied richness calculation

**Species Accumulation Curves**:
- Permutation-based method (10-1000 permutations)
- Standard deviation ribbons
- Publication-quality plots
- Richness vs. number of sites

### 🔧 Improved

#### Architecture Refactoring
- **Modular design**: Clean separation of analysis modules
- **Scalable structure**: Easy to add new modules (v2.3, v2.4, etc.)
- **Maintainable code**: Independent module development
- **Professional UX**: Enterprise-grade tab navigation

#### Code Organization
- Moved from single-page conditional UI to modular tabs
- Shared reactive data loading
- Independent reactive results for each module
- Cleaner server logic with module-specific observers

### 📊 vegan Integration Progress

**v2.0**: 1 function (NMDS only) - 0.5% coverage  
**v2.2**: 19 functions - 9.5% coverage (**19x increase!**)

| Domain | Functions | Implemented | Coverage |
|--------|-----------|-------------|----------|
| Ordination | 8 methods | 5 methods | **62.5%** |
| Diversity Indices | 30+ | 8 indices | **~27%** |
| Dissimilarity | 40+ | 5 methods | **~12%** |
| Community Analysis | 50+ | 1 (accumulation) | **~2%** |
| Hypothesis Testing | 30+ | 0 | 0% |
| Advanced Tools | 40+ | 0 | 0% |

**Breakdown**:
- 5 ordination methods
- 8 diversity/evenness indices
- 5 distance measures
- 1 accumulation method

### 🛠️ Technical Details

**UI Framework**: Changed from `page_sidebar()` to `page_navbar()` for tab navigation  
**Modules**: Each tab has dedicated `layout_sidebar()` with controls and results  
**Data Sharing**: Single reactive `data()` function accessible across all modules  
**Results**: Module-specific reactiveVal for independent state management  
**Downloads**: Separate download handlers per module  
**File Size**: app.R reduced from 959 lines to 540 lines (43% reduction)  

### 📚 Documentation

#### New Documentation
- `TEST-v2.2-SUMMARY.md` (300 lines) - Comprehensive test summary and feature documentation
- Updated `README.md` - Added v2.2 features
- Updated `CHANGELOG.md` - This file
- Updated `package.json` - Version 2.2.0

### 🚀 What's Next

**v2.3 - Community Analysis** (Q4 2025):
- 15+ dissimilarity indices
- Hierarchical clustering with dendrograms
- Beta diversity partitioning
- Mantel tests
- Environmental data support for constrained ordination (CCA, RDA, db-RDA)

**v2.4 - Hypothesis Testing** (Q1 2026):
- PERMANOVA (adonis2)
- ANOSIM, MRPP
- envfit, bioenv
- Betadisper, permutest

---

## [2.0.0] - 2025-01-25

### 🎉 Major Release: Enterprise-Grade UX & Publication-Quality Exports

Version 2.0.0 represents a significant leap in user experience, professional polish, and publication-ready output capabilities.

### ✨ Added

#### Professional Splash Screen
- **Enterprise-grade loading experience** during app startup
- Frameless, transparent window with animated Ö logo
- Pulsing animation and gradient loading bar
- Rotating status messages ("Initializing...", "Loading R environment...", etc.)
- Smooth transition to main window
- Technical documentation: `docs/SPLASH-SCREEN-IMPLEMENTATION.md`, `docs/SPLASH-SCREEN-QUICK-GUIDE.md`

#### Publication-Quality Plot Exports
- **Multi-format export support**:
  - **PNG** - 300 DPI raster (publication standard)
  - **TIFF** - 300 DPI raster (journal submission)
  - **JPEG** - 300 DPI raster (presentations)
  - **SVG** - Scalable vector graphics (infinite resolution)
  - **PostScript** - Vector format (LaTeX/academic publishing)
- Format selector dropdown above plot
- Consistent 12"×8" dimensions across all formats
- Dark background preservation (#222222) in all formats
- Helvetica font family for PostScript compatibility

#### Enhanced Progress Indicators
- **Early progress feedback** for all data types
- Incremental progress updates during validation:
  - "Validating data..." (10%)
  - "Checking data quality..." (5%)
  - "Validating requirements..." (5%)
  - "Running analysis..." (remaining 80%)
- Fixed progress indicator not showing for incidence_raw data
- Diagnostic output integrated with progress flow

#### Welcome Page Enhancement
- **Professional welcome screen** when no analysis has been run
- Large Ö logo with gradient styling
- Feature highlights with icons:
  - 📊 Diversity Estimation (iNEXT)
  - 🗺️ Ordination Analysis (vegan NMDS)
  - 📈 Multiple Plot Types
  - 💾 Publication Exports
- "Get Started" call-to-action
- Smooth server-side rendering (no JavaScript conditionalPanel)

### 🔧 Improved

#### UI/UX Reorganization
- **Removed redundant download buttons**: CSV download already available in table interface
- **Contextual plot export**: Format selector + download button positioned directly above plot
- **Consolidated parameters**: Moved "Extrapolation Endpoint" under "iNEXT Advanced Options"
- **Better visual hierarchy**: Export controls in flex layout with proper spacing
- **Icon cleanup**: Removed duplicate download icons (Shiny auto-adds icons)
- **Improved spacing**: 10px gap between format selector and download button

#### Logo Rendering
- **Fixed Ö logo cutoff** at 100% zoom level
- Increased top padding from 60px to 80px
- Reduced logo size from 6em to 5em
- Added line-height: 1.2 for proper spacing
- Umlaut dots now fully visible at all zoom levels

#### Architecture Refactoring
- **Single source of truth**: Replaced multiple conditionalPanels with single `output$mainContent`
- **Server-side UI state management**: R reactive logic instead of JavaScript evaluation
- **Eliminated race conditions**: No more duplicate outputs or conflicting render logic
- **Reliable results display**: Results now consistently appear after analysis
- **Simplified maintenance**: One output controls welcome vs. results state

### 🐛 Fixed

#### CRITICAL: Results Not Displaying (Issue #2)
- **Problem**: After UI enhancements, clicking "Run Analysis" showed progress but results never appeared
- **Root Cause**: Conflicting `conditionalPanel` JavaScript evaluation and duplicate `output$resultsUI` definitions
- **Solution**: Complete refactor to single `output$mainContent` with server-side conditional rendering
- **Impact**: 100% reliable results display, no more "welcome page stuck" issues
- Technical documentation: `docs/FIX-SUMMARY-RESULTS-DISPLAY.md`

#### Progress Indicator Not Showing for Incidence Data
- **Problem**: Progress modal didn't appear when analyzing plant-presence.csv (incidence_raw)
- **Root Cause**: Diagnostic `cat()` and `showNotification()` blocked first `incProgress()` call
- **Solution**: Added `incProgress(0.1, detail = "Validating data...")` at start of validation
- **Impact**: Progress feedback now appears immediately for all data types

#### Logo Rendering at 100% Zoom
- **Problem**: Top of Ö logo (umlaut dots) cut off at actual size (100% zoom)
- **Root Cause**: Insufficient top padding and logo too large for container
- **Solution**: Increased padding to 80px top, reduced logo to 5em, added line-height
- **Impact**: Logo fully visible at all standard zoom levels (75%-125%)

#### Duplicate Download Icons
- **Problem**: Download button showed "⬇️ Download Plot" with Shiny's auto-icon, creating duplication
- **Solution**: Removed emoji from button text (Shiny automatically adds icon)
- **Impact**: Clean, professional button appearance

### 📚 Documentation

#### New Documentation Files
- `IMPLEMENTATION-STATUS.md` (441 lines) - Complete v2.0 implementation status and v2.1+ roadmap
- `docs/VEGAN-COMPREHENSIVE-RESEARCH.md` (1,091 lines) - Full vegan package research and integration strategy
- `docs/VEGAN-INTEGRATION-EXECUTIVE-SUMMARY.md` (378 lines) - Executive summary of expansion plans
- `docs/SPLASH-SCREEN-IMPLEMENTATION.md` (625 lines) - Technical implementation guide
- `docs/SPLASH-SCREEN-QUICK-GUIDE.md` (170 lines) - Quick reference
- `docs/FIX-SUMMARY-RESULTS-DISPLAY.md` (429 lines) - Results display fix technical explanation

#### Updated Documentation
- Updated `README.md` with v2.0 features
- Updated `CHANGELOG.md` with comprehensive v2.0 release notes
- Updated `package.json` version and description

### 🔮 Future Roadmap (v2.1+)

Version 2.0.0 establishes the foundation for modular expansion. Planned modules:

1. **Module 1: Diversity Estimation** (Current - v2.0) ✅
   - iNEXT rarefaction/extrapolation
   - 3 plot types, incidence data support
   - Hill numbers (q=0,1,2)

2. **Module 2: Ordination Analysis** (Expand in v2.1)
   - Current: NMDS only
   - Planned: +PCA, +CA, +DCA, +CCA, +RDA, +db-RDA, +PCoA (8 total)

3. **Module 3: Diversity Indices** (v2.2)
   - Shannon, Simpson, Berger-Parker, Fisher's alpha
   - Evenness indices (Pielou, Simpson, Evar)
   - Rarefied richness

4. **Module 4: Community Analysis** (v2.3)
   - Dissimilarity matrices (15+ indices)
   - Hierarchical clustering
   - Beta diversity partitioning
   - Mantel tests

5. **Module 5: Hypothesis Testing** (v2.4)
   - PERMANOVA, ANOSIM, MRPP
   - envfit, bioenv
   - Dispersion tests

6. **Module 6: Advanced Tools** (v2.5+)
   - Null models
   - Nestedness analysis
   - Species-area relationships
   - Multivariate dispersion

See `IMPLEMENTATION-STATUS.md` for complete roadmap.

### 🎯 Technical Achievements

- **Zero JavaScript conditionalPanel dependencies**: Pure R server-side rendering
- **Publication-ready defaults**: 300 DPI, professional dimensions
- **Enterprise UX patterns**: Splash screen, progress indicators, contextual actions
- **Modular architecture foundation**: Ready for tab-based expansion
- **Comprehensive documentation**: 3,500+ lines of technical documentation
- **Cross-platform compatibility**: Windows, macOS, Linux

### 📊 Statistics

- **Files Modified**: 8 core files + 7 new documentation files
- **Lines of Code**: ~1,000 lines in main app.R
- **Documentation**: ~4,500 lines across all docs
- **Supported Formats**: 5 export formats (PNG, TIFF, JPEG, SVG, PS)
- **Progress Steps**: 4 incremental feedback points
- **Vegan Functions Researched**: 200+ functions across 6 domains

### 🙏 Acknowledgments

- User feedback driving iterative improvements
- iNEXT and vegan package developers
- Electron and R Shiny communities

---

## [Unreleased] - Pre-v2.0 Enhancements

### Fixed - CRITICAL: Shaded Confidence Intervals (2025-01-23)

#### The Problem:
- Confidence intervals appearing as **jagged zigzag lines** instead of smooth shaded ribbons
- `ggiNEXT()` function producing inconsistent `geom_ribbon()` rendering
- Did not match official iNEXT documentation visualization style

#### The Solution:
- **Bypassed `ggiNEXT()` entirely**
- Built plots manually using pure ggplot2 with explicit `geom_ribbon()`
- Extracted data from `inext_out$iNextEst` for direct plotting
- Guaranteed shaded confidence interval rendering

#### Technical Changes:
- Added `library(dplyr)` for data manipulation
- Replaced `ggiNEXT()` call with manual ggplot2 construction:
  - `geom_ribbon(aes(ymin = qD.LCL, ymax = qD.UCL), alpha = 0.2, color = NA)`
  - `geom_line(aes(linetype = Method_label), linewidth = 1.2)`
  - `facet_wrap(~ Order.q)` for separate Hill number panels
- Added data transformation logic for three plot types
- Implemented proper linetype (solid for rarefaction, dashed for extrapolation)

#### Visual Improvements:
- ✅ Smooth shaded confidence interval ribbons (no more jagged lines!)
- ✅ Separate faceted panels for each Hill number (q=0, 1, 2)
- ✅ Clear distinction between rarefaction (solid) and extrapolation (dashed)
- ✅ Professional publication-ready appearance
- ✅ Matches industry-standard confidence interval visualization

### Added - Rarefaction Analysis Enhancement (2025-01-23)

#### New Features
- **Three plot type options** for iNEXT diversity analysis:
  - Type 1: Sample-size-based rarefaction/extrapolation (default)
  - Type 2: Sample completeness curves
  - Type 3: Coverage-based rarefaction/extrapolation
- **Incidence data support** with dedicated data type selector
- **Full iNEXT parameter customization**:
  - Hill numbers selection (q=0, 1, 2) via checkboxes
  - Knots adjustment (10-200) for curve smoothness
  - Bootstrap replicates (10-500) for CI accuracy
  - Confidence level (80-99%) for CI width
- **Shaded confidence intervals** (fixed from line-style)
- **Parameter transparency** - all settings displayed in plot subtitle
- **Four sample datasets** from iNEXT package:
  - `spider-abundance.csv` - Spider communities (abundance data)
  - `bird-abundance.csv` - Bird species (abundance data)
  - `ciliates-abundance.csv` - Soil ciliates (abundance data)
  - `ant-incidence.csv` - Ant species (incidence-frequency data)

#### Documentation
- `ESTIMATES-AND-RAREFACTION-TYPES.md` - Comprehensive guide to rarefaction theory
- `docs/RAREFACTION-IMPLEMENTATION.md` - Technical implementation details
- `docs/RAREFACTION-QUICK-GUIDE.md` - User decision tree and quick reference
- `docs/INEXT-PARAMETERS-GUIDE.md` (640 lines) - **Complete iNEXT parameter reference**
- `docs/SHADED-CI-FIX.md` (385 lines) - **Explanation of shaded CI fix**
- `docs/SUMMARY-INEXT-ENHANCEMENT.md` - **Enhancement summary**
- `INCIDENCE-VS-ABUNDANCE.md` - Data format guide with examples
- Updated `sample-data/README.md` with all four datasets
- Enhanced main README with rarefaction feature summary

#### UI Improvements
- Added **iNEXT Advanced Options** section in sidebar:
  - Hill numbers checkbox group (select q=0, 1, or 2)
  - Knots slider for curve smoothness (10-200, default: 40)
  - Bootstrap replicates input (10-500, default: 50)
  - Confidence level input (0.80-0.99, default: 0.95)
- Plot type selector (conditionally shown for iNEXT analysis)
- Enhanced plot subtitle showing:
  - Sites being compared
  - Selected Hill numbers
  - Confidence level percentage
  - Number of bootstrap replicates
- Improved help text explaining data types and parameters

#### Technical Changes
- Fixed **shaded confidence intervals** by explicitly setting `se = TRUE` in `ggiNEXT()`
- Modified `shiny/app.R` to accept all iNEXT parameters:
  - `hillNumbers` input for dynamic q values
  - `knots` input for interpolation smoothness
  - `nboot` input for bootstrap replicates
  - `conf` input for confidence level
- Enhanced `iNEXT()` call with custom parameters:
  ```r
  iNEXT(x, q = selected_q, datatype, knots, nboot, conf)
  ```
- Updated `ggiNEXT()` visualization:
  ```r
  ggiNEXT(x, type, se = TRUE, facet.var = "None", color.var = "Assemblage")
  ```
- Dynamic subtitle generation showing all analysis parameters
- Proper parameter validation and defaults

### Comparison with EstimateS
Ördin now implements all major rarefaction approaches:
- ✅ Individual-based rarefaction (abundance data)
- ✅ Incidence-based rarefaction (presence/absence data)
- ✅ Coverage-based comparison (iNEXT innovation)
- ✅ Multiple Hill numbers (q=0, 1, 2)
- ✅ Analytical confidence intervals
- ✅ Extrapolation support

---

## [1.0.0] - Initial Release

### Added
- Electron-based desktop application for biodiversity analysis
- R Shiny integration with modern Bootstrap 5 darkly theme
- **iNEXT integration** for diversity estimation
  - Rarefaction and extrapolation curves
  - Hill numbers calculation (q=0, 1, 2)
  - Confidence intervals
- **vegan integration** for NMDS ordination
  - Bray-Curtis dissimilarity
  - Customizable dimensions
  - Stress value reporting
- Cross-platform support (Windows, macOS, Linux)
- Portable R bundling for distribution
- CSV data import
- PNG and CSV export capabilities
- Full-screen visualization support
- Example biodiversity dataset

### Technical Stack
- Electron 28.0
- R 4.0+
- R packages: shiny, bslib, vegan, iNEXT, ggplot2, DT, readr
- Node.js 18/20
- Electron Forge for building

### Build Targets
- Windows: EXE installer (Squirrel)
- macOS: ZIP with .app bundle
- Linux: DEB (Debian/Ubuntu), RPM (Fedora/RHEL), ZIP (generic)

---

## Version History Summary

| Version | Date | Key Features |
|---------|------|--------------|
| 1.0.0 | 2025-01 | Initial release with iNEXT and vegan |
| Unreleased | 2025-01-23 | Enhanced rarefaction (3 plot types, incidence data) |
| 2.0.0 | 2025-01-25 | Enterprise UX, splash screen, 5 export formats, critical fixes |

---

## Upcoming Features (Roadmap)

### Short-Term
- [ ] Interactive plots with plotly
- [ ] Multiple dataset comparison mode
- [ ] Asymptotic diversity estimators (Chao1, ACE, etc.)
- [ ] Customizable confidence interval levels
- [ ] Hill numbers in separate panels

### Medium-Term
- [ ] Sample-based rarefaction (explicit mode)
- [ ] Export iNEXT R objects for further analysis
- [ ] Batch processing for multiple files
- [ ] Species accumulation curves
- [ ] Beta diversity analysis

### Long-Term
- [ ] Phylogenetic diversity (if tree provided)
- [ ] Functional diversity (if trait data provided)
- [ ] Beta diversity rarefaction
- [ ] Integration with online biodiversity databases
- [ ] R Markdown report generation

---

## Citation

### For Ördin Software:
```
Moses, J. (2025). Ördin v2.0: Enterprise-grade biodiversity analysis desktop application.
GitHub: https://github.com/jm0535/0rdin
```

### For iNEXT Package (Rarefaction Methods):
```
Hsieh, T.C., Ma, K.H. and Chao, A. (2016). iNEXT: an R package for rarefaction and 
extrapolation of species diversity (Hill numbers). Methods in Ecology and Evolution, 
7(12), pp.1451-1456.
```

### For Rarefaction Theory:
```
Chao, A., Gotelli, N.J., Hsieh, T.C., Sander, E.L., Ma, K.H., Colwell, R.K. and 
Ellison, A.M. (2014). Rarefaction and extrapolation with Hill numbers: a framework 
for sampling and estimation in species diversity studies. Ecological Monographs, 
84(1), pp.45-67.
```

---

## Contributors

- **Jimmy Moses** - Initial work and development
- Community contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md)

## Acknowledgments

- **EstimateS** (Robert K. Colwell) - Pioneering rarefaction software
- **iNEXT** team (Anne Chao, T.C. Hsieh, K.H. Ma) - Modern rarefaction implementation
- **vegan** developers - Community ecology toolkit
- Odin (Norse mythology) - Inspiration for wisdom in data oversight

---

## License

MIT License - See [LICENSE](LICENSE) file for details
