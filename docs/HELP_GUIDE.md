# Ördin Help Guide

## Table of Contents
1. [About Ördin](#about-ördin)
2. [Frequently Asked Questions](#frequently-asked-questions)
3. [User Guides](#user-guides)
4. [Changelog](#changelog)
5. [Technical Specifications](#technical-specifications)
6. [Author & Credits](#author--credits)
7. [References](#references)

## About Ördin

Ördin is an enterprise-grade community ecology analysis platform that combines the analytical power of R with modern desktop application design. It provides ecologists, researchers, and students with professional tools for analyzing community composition, diversity patterns, ordination, and ecological indices through an intuitive, cross-platform interface.

### Platform Overview

Ördin provides a comprehensive suite of tools for community ecology analysis:
- **Diversity Estimation**: iNEXT-based rarefaction and extrapolation analysis
- **Ordination Analysis**: 7 methods (NMDS, PCA, CA, DCA, CCA, RDA, PCoA)
- **Diversity Indices**: Classic diversity and evenness metrics
- **Advanced Visualization**: Confidence ellipses, species scores, environmental vectors

### Core Modules

#### Diversity Estimation (iNEXT)
- Individual-based and incidence-based data support
- Three visualization types: sample-size, coverage, completeness
- Hill numbers (q=0, 1, 2): Species richness, Shannon, Simpson diversity
- Bootstrap confidence intervals (95% default)

#### Diversity Indices (vegan)
- Alpha diversity: Shannon, Simpson, Inverse Simpson, Fisher's Alpha, Richness
- Evenness indices: Pielou's J', Simpson's E, Evar
- Rarefaction to specified sample sizes
- Species accumulation curves with permutation-based CI

#### Ordination Analysis (vegan)
- 7 ordination methods with comprehensive implementation
- 5 distance measures: Bray-Curtis, Jaccard, Euclidean, Manhattan, Canberra
- Advanced visualization features:
  - Confidence ellipses for site groups
  - Species scores overlay
  - Environmental vectors (biplot arrows)
  - 5 plot themes with dynamic switching

### Enterprise Features

1. **Professional dark/light theme** with persistent preferences
2. **Publication-quality exports** in multiple formats (PNG, TIFF, SVG)
3. **Modular architecture** with independent analysis modules
4. **Cross-platform support** (Windows, macOS, Linux)
5. **Self-contained portable R installation**
6. **Advanced data management and validation**
7. **Comprehensive documentation and user guides**

## Frequently Asked Questions

### What data format does Ördin require?

Ördin requires CSV files with the first column containing site names and subsequent columns containing species/taxa abundance or presence/absence data. The platform supports three data types:

- **Abundance**: Numeric counts of individuals per species
- **Incidence (Binary)**: Presence/absence data (1/0)
- **Incidence (Freq)**: Frequency of occurrence data

For ordination methods that support environmental variables (CCA, RDA), a separate environmental data file can be uploaded with site names in the first column and environmental variables in subsequent columns.

### What ordination methods are supported?

Ördin supports 7 ordination methods with comprehensive visualization features:

1. **NMDS** - Non-metric Multidimensional Scaling
2. **PCA** - Principal Components Analysis
3. **CA** - Correspondence Analysis
4. **DCA** - Detrended Correspondence Analysis
5. **CCA** - Canonical Correspondence Analysis (constrained)
6. **RDA** - Redundancy Analysis (constrained)
7. **PCoA** - Principal Coordinates Analysis

Each method supports customizable dimensions, distance measures, and advanced visualization options including confidence ellipses, species scores, and environmental vectors.

### What diversity indices are available?

Ördin provides comprehensive diversity analysis through two main modules:

- **Diversity Estimation**: iNEXT-based rarefaction and extrapolation with Hill numbers (q=0, 1, 2)
- **Diversity Indices**: 8 classic diversity and evenness metrics including Shannon, Simpson, Pielou's evenness, and species accumulation curves

### How do I export results?

Ördin offers multiple export options for professional use:

- **Tables**: Download summary results as CSV, Excel, or JSON
- **Plots**: Export visualizations in 5 formats (PNG, TIFF, SVG) at publication quality (300 DPI)
- **Themes**: Choose from 5 plot themes (Dark, Light, Classic, Minimal, Publication) for consistent styling
- **Data Components**: Download ordination scores, eigenvalues, and other analysis outputs

### Is Ördin free to use?

Yes, Ördin is completely free and open-source software released under the MIT License. The platform is self-contained with a portable R installation, so users don't need to install R separately.

### What platforms does Ördin support?

Ördin is cross-platform and supports:

- Windows 10/11 (64-bit)
- macOS 10.15+ (Intel and Apple Silicon)
- Linux (Debian/Ubuntu, Fedora/RHEL, Arch)
- Portable installation - no system dependencies required

### How do I change plot themes?

Ördin features a professional theme system with 5 plot themes:
1. **Dark**: High-contrast dark background with bright colors
2. **Light**: Clean white background with strong colors
3. **Classic**: Traditional academic styling
4. **Minimal**: Subtle grids and clean presentation
5. **Publication**: Black-and-white for journal submissions

Themes can be changed dynamically in the sidebar settings without re-running analyses. The theme selector is available in both Diversity and Ordination modules for consistent styling.

## User Guides

### Diversity Estimation Guide

The Diversity Estimation module uses the iNEXT package to perform rarefaction and extrapolation analysis. It supports three data types (abundance, incidence binary, incidence frequency) and three visualization types (sample-size, completeness, coverage). The module calculates Hill numbers (q=0, 1, 2) with confidence intervals and provides publication-quality plots.

Key features:
- Automatic data type detection
- Customizable Hill numbers (q=0, 1, 2)
- Advanced parameters (knots, bootstrap iterations, confidence level)
- Three plot types for different analysis perspectives
- Publication-quality exports with consistent theming

### Ordination Analysis Guide

The Ordination Analysis module implements 7 ordination methods from the vegan package. Features include customizable dimensions, 5 distance measures, confidence ellipses, species scores overlay, environmental vectors, and multiple scaling options. Advanced visualization options include 5 plot themes and publication-quality exports.

Key features:
- 7 ordination methods with comprehensive implementation
- 5 distance measures for dissimilarity calculation
- Confidence ellipses for site group visualization
- Species scores overlay with customizable display
- Environmental vectors for biplot interpretation
- 5 plot themes with dynamic switching
- Downloadable scores and eigenvalues

### Diversity Indices Guide

The Diversity Indices module calculates 8 classic diversity and evenness metrics using the vegan package. Includes alpha diversity indices (Shannon, Simpson, richness) and evenness measures (Pielou, Simpson E, Evar). Also features rarefaction and species accumulation curves with permutation-based confidence intervals.

Key features:
- Alpha diversity indices (Shannon, Simpson, Inverse Simpson, Fisher's Alpha, Richness)
- Evenness measures (Pielou's J', Simpson's E, Evar)
- Rarefaction to specified sample sizes
- Species accumulation curves with confidence intervals
- Multiple export formats (CSV, Excel, JSON)

### Theme and Visualization Guide

Ördin features a professional theme system with 5 plot themes (Dark, Light, Classic, Minimal, Publication) and dynamic theme switching. All plots support publication-quality exports with consistent styling across modules. The interface includes dark/light mode toggle with persistent preferences.

Key features:
- 5 plot themes for different contexts
- Dynamic theme switching without re-running analyses
- Publication-quality exports (300 DPI)
- Consistent styling across all modules
- Theme persistence via localStorage

## Changelog

### Version 3.0 Highlights

- Enhanced ordination analysis with 7 methods (NMDS, PCA, CA, DCA, CCA, RDA, PCoA)
- Advanced visualization features: confidence ellipses, species scores, environmental vectors
- 5 plot themes with dynamic switching
- Publication-quality exports with consistent styling
- Improved data management and validation
- Enhanced UI/UX with professional design patterns

### Version 2.3 Features

- Professional dark/light theme toggle with persistent preferences
- Complete CSS architecture refactor for reliability
- Smooth transitions and theme-responsive UI elements
- localStorage persistence for theme settings

### Version 2.2 Features

- Complete modular architecture with tab-based navigation
- 5 ordination methods (NMDS, PCA, CA, DCA, PCoA)
- 8 diversity indices with rarefaction and accumulation curves
- Professional UI with dedicated modules
- Enhanced vegan package integration (9.5% coverage)
- Publication-quality plot exports

For complete history, see the [full changelog](../CHANGELOG.md).

## Technical Specifications

### System Requirements

**Minimum Requirements:**
- Operating System: Windows 10+, macOS 10.15+, Linux
- Processor: Intel/AMD x64 or Apple Silicon
- Memory: 4 GB RAM
- Storage: 500 MB available space
- Display: 1280×720 minimum resolution
- Internet: Not required (offline capable)
- Dependencies: None (self-contained)

**Recommended Requirements:**
- Operating System: Windows 11, macOS 12+, Ubuntu 22.04+
- Processor: Multi-core Intel/AMD or Apple M1/M2
- Memory: 8 GB RAM
- Storage: 1 GB available space
- Display: 1920×1080 or higher

### Technology Stack

#### Frontend
- Electron: Desktop application framework
- Shiny: Web application framework
- Bootstrap 5: UI components
- bslib: Bootstrap theming
- Custom CSS: VS Code flat design + dual themes
- Vanilla JS: Theme toggle & localStorage
- DT: Interactive tables

#### Backend
- R 4.4+: Statistical computing
- vegan 2.6+: Community ecology (ordination)
- iNEXT 3.0+: Diversity estimation
- ggplot2: Data visualization
- readr: CSV file handling
- Additional packages: readxl, dplyr, tidyr, shinyjs, waiter, etc.

### Project Structure

```
ordin/
├── src/                 # Electron main process
│   ├── index.js         # Application entry point
│   └── start-shiny.R    # R Shiny server starter
├── shiny/              # Shiny application
│   └── app.R           # Main application logic
├── build/              # Build assets and icons
├── docs/               # Documentation guides
├── sample-data/        # Example datasets
├── package.json        # Node.js configuration
└── README.md           # Project documentation
```

### Architecture Overview

Ördin follows a three-layer architecture:

1. **Electron Layer**: Desktop application framework that manages the R process and UI
2. **R Shiny Layer**: Statistical computing engine with community ecology packages
3. **Web Interface Layer**: Modern Bootstrap 5 UI with responsive design

The application is self-contained with a portable R installation, eliminating the need for users to install R separately.

## Author & Credits

### Lead Developer

**Jimmy Moses**
- Email: jmoses@pnguot.ac.pg
- Role: Lead Developer & Ecologist
- Bio: Jimmy is a computational ecologist with expertise in community ecology analysis and statistical computing. He developed Ördin to bridge the gap between powerful ecological analysis tools and accessible, user-friendly interfaces.

### Acknowledgments

- Inspired by Odin's wisdom from Norse mythology
- Built with Electron, R Shiny, Bootstrap 5
- Powered by vegan and iNEXT R packages
- Community ecology research and open science advocates
- Users and contributors who provided feedback

### Contact

For support, feedback, or collaboration opportunities:
- Email: jmoses@pnguot.ac.pg
- GitHub: [github.com/jm0535/0rdin](https://github.com/jm0535/0rdin)

## References

### Core R Packages

1. **vegan**: Oksanen, J., et al. (2023). vegan: Community Ecology Package. R package version 2.6-4. https://CRAN.R-project.org/package=vegan

2. **iNEXT**: Hsieh, T. C., Ma, K. H., & Chao, A. (2016). iNEXT: Interpolation and Extrapolation for Species Diversity. R package version 2.0.20. https://CRAN.R-project.org/package=iNEXT

3. **ggplot2**: Wickham, H. (2016). ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York.

### Foundational Research

1. Chao, A., Gotelli, N. J., Hsieh, T. C., Sander, E. L., Ma, K. H., Colwell, R. K., & Ellison, A. M. (2014). Rarefaction and extrapolation with Hill numbers: a framework for sampling and estimation in species diversity studies. Ecological Monographs, 84(1), 45-67.

2. Chao, A., & Jost, L. (2012). Coverage-based rarefaction and extrapolation: standardizing samples by completeness rather than size. Ecology, 93(12), 2533-2547.

3. Oksanen, J. (2022). Multivariate Analysis of Ecological Communities in R: vegan Tutorial. Comprehensive R Archive Network.

### Platform Technologies

1. **Electron**: Electron Team. (2023). Electron: Build cross-platform desktop apps with JavaScript, HTML, and CSS. https://electronjs.org

2. **Shiny**: Chang, W., Cheng, J., Allaire, J. J., Xie, Y., & McPherson, J. (2023). shiny: Web Application Framework for R. R package version 1.7.4. https://shiny.rstudio.com/

3. **Bootstrap**: Bootstrap Team. (2023). Bootstrap: The most popular HTML, CSS, and JavaScript framework. https://getbootstrap.com

### Citing Ördin

If you use Ördin in your research, please cite:

```
Moses, J. (2025). Ördin: A cross-platform desktop application for community ecology analysis. 
GitHub repository: https://github.com/jm0535/0rdin
```

---

*Last Updated: 2025-10-24*  
*Version: 3.0.0*