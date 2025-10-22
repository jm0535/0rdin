# Changelog

All notable changes to Ördin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-10-22

### Added
- Initial release of Ördin desktop application
- Biodiversity diversity estimation using iNEXT package
  - Rarefaction and extrapolation curves
  - Shannon, Simpson, and species richness calculations
  - Support for multiple diversity orders (q = 0, 1, 2)
- NMDS ordination analysis using vegan package
  - Bray-Curtis dissimilarity matrices
  - Customizable dimensions (1-5)
  - Stress value reporting and interpretation
- Modern dark-themed UI using Bootstrap 5 (bslib)
  - Forest green primary color (#2e8b57)
  - Full-screen capable visualizations
  - Responsive layout
- Interactive data tables with DT package
  - Copy and CSV export capabilities
  - Pagination and search
- High-quality plot exports (PNG, 300 DPI)
- CSV summary table downloads
- Cross-platform support (Windows and macOS)
- Portable R installation (no system R required)
- Sample biodiversity dataset included
- Comprehensive documentation
  - README with installation instructions
  - Quick start guide
  - Development guide
  - Sample data documentation

### Technical Details
- Electron 28.0.0
- R Shiny with bslib theming
- vegan 2.6+ for ordination
- iNEXT 3.0+ for diversity estimation
- ggplot2 for visualizations
- Automated R package installation script
- Shell scripts for portable R setup (Windows/macOS)

## [Unreleased]

### Planned Features
- Additional ordination methods (PCA, PCoA, CCA)
- More diversity indices (Chao1, ACE, etc.)
- Batch processing for multiple datasets
- Export to multiple formats (PDF, SVG)
- Custom theme builder
- Data validation and quality checks
- Session history and result caching
- R Markdown report generation
- Auto-update functionality

### Ideas for Future Versions
- Integration with biodiversity databases
- Machine learning-based species prediction
- Spatial analysis capabilities
- Time series analysis for long-term monitoring
- Mobile companion app
- Cloud sync for results
- Collaborative analysis features
- Plugin system for custom analyses

---

## Version History

- **1.0.0** - Initial release (2025-10-22)
