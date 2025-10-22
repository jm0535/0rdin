# Changelog - Ördin

All notable changes to this project will be documented in this file.

## [Unreleased]

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
Moses, J. (2025). Ördin: A cross-platform desktop application for biodiversity analysis. 
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
