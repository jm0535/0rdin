# Ördin v3.0.0 - Enterprise-Grade Community Ecology Platform

## 🎉 Production Release with Flexible Plot Export System

Version 3.0.0 is the first **production-ready** release of Ördin, featuring a revolutionary **flexible plot export system** that puts complete control in your hands. Export any plot in your preferred format (PNG/PDF/SVG/TIFF), resolution (72-600 DPI), and dimensions - all from the convenient right sidebar.

---

## ✨ What's New: Flexible Plot Export

### 🎯 Export Options Right Where You Need Them

No more navigating to settings! All export controls are now in the **right sidebar** under "PLOT CUSTOMIZATION":

- **📊 Format Selection**: PNG, PDF, SVG, or TIFF
- **🔍 DPI Control**: 72, 150, 300, or 600 DPI
- **📐 Custom Dimensions**: Width and height (4-20 inches)
- **⚡ Instant Access**: Change settings → Click export → Done!

### 🌍 Universal Implementation

Export controls are consistently available across **all 15+ analysis modules**:

- ✅ **9 Ordination Methods**: NMDS, PCA, CA, DCA, PCoA, CCA, RDA, db-RDA, CAP
- ✅ **2 Diversity Modules**: iNEXT Estimation, Diversity Indices
- ✅ **1 Beta Diversity**: Partitioning Analysis
- ✅ **4 Statistical Tests**: PERMANOVA, ANOSIM, Mantel, envfit

### 💡 Why This Matters

- **For Presentations**: Quick PNG exports at 150 DPI
- **For Documents**: PDF exports that scale perfectly
- **For Editing**: SVG exports for Adobe Illustrator/Inkscape
- **For Journals**: TIFF exports at 600 DPI for publication
- **For Flexibility**: Change format/size on-the-fly without re-running analyses

---

## 📦 Download Options

### Windows

**Portable Version** (Recommended - No installation required)
- **File**: `Ordin-win32-x64-3.0.0.zip` (770 MB)
- **Benefits**: Extract and run instantly, no admin rights needed, perfect for USB drives
- **How to use**: Extract ZIP → Double-click `ordin.exe` → Start analyzing!
- **Includes**: R 4.5.1 and all required packages - completely self-contained!

**Traditional Installer**
- Coming in a future update
- Portable version works perfectly in the meantime!

### Linux

**Debian/Ubuntu**: `ordin_3.0.0_amd64.deb` (85 MB)
```bash
sudo dpkg -i ordin_3.0.0_amd64.deb
```

**Fedora/RHEL**: `ordin-3.0.0-1.x86_64.rpm` (88 MB)
```bash
sudo dnf install ordin-3.0.0-1.x86_64.rpm
```

*Note: Linux versions require R 4.0+ installed on your system*

### macOS

Coming soon - requires macOS build system

---

## 🚀 Key Features

### Analysis Capabilities

- **9 Ordination Methods**: NMDS, PCA, CA, DCA, PCoA, CCA, RDA, db-RDA, CAP
- **Diversity Analysis**: iNEXT rarefaction/extrapolation, Shannon, Simpson, Hill numbers
- **Statistical Tests**: PERMANOVA, ANOSIM, Mantel, envfit
- **Beta Diversity**: Partitioning and turnover analysis

### User Experience

- **Enterprise-Grade Dark Theme**: Professional VS Code-inspired interface
- **Real-Time Plot Customization**: 20+ controls in right sidebar
- **Flexible Export System**: Format, DPI, and dimensions at your fingertips
- **Interactive Help System**: Comprehensive documentation built-in
- **Keyboard Shortcuts**: Efficient workflow with hotkeys

### Technical Excellence

- **Self-Contained**: Includes R 4.5.1 and all packages (Windows)
- **Cross-Platform**: Windows, Linux (macOS coming soon)
- **Publication Quality**: Up to 600 DPI exports
- **Modern Stack**: Electron + R Shiny + ggplot2

---

## 📊 What's Included

### Sample Datasets
- Spider communities
- Bird assemblages
- Ciliate diversity
- Ant colonies

### Documentation
- Getting Started Guide
- Ordination Methods Guide
- Data Management Guide
- Comprehensive Help System

### Export Formats
- **PNG**: Web and presentations
- **PDF**: Documents and reports
- **SVG**: Vector editing
- **TIFF**: Journal submissions

---

## 🐛 Bug Fixes

- ✅ Fixed installer filename (removed special characters)
- ✅ Fixed Mantel test numeric validation
- ✅ Fixed envfit mixed data type handling
- ✅ Fixed environmental variable selection UI
- ✅ Removed all debug console output
- ✅ Fixed window dragging on Windows

---

## 📚 Documentation

- **Website**: https://jm0535.github.io/0rdin/
- **GitHub**: https://github.com/jm0535/0rdin
- **Getting Started**: See README.md
- **Changelog**: See CHANGELOG.md

---

## 🙏 Acknowledgments

Built with:
- **R** and **Shiny** (statistical computing)
- **vegan** package (community ecology)
- **iNEXT** package (diversity estimation)
- **ggplot2** (data visualization)
- **Electron** (desktop framework)

---

## 📄 License

MIT License - Free and open source

---

## 🎯 Quick Start

### Windows Portable

1. Download `Ordin-win32-x64-3.0.0.zip`
2. Extract to any folder
3. Double-click `ordin.exe`
4. Load sample data or your own CSV files
5. Run analyses and export plots with custom settings!

**Note**: Traditional installer coming in a future update!

---

## 💬 Support

- **Issues**: https://github.com/jm0535/0rdin/issues
- **Discussions**: https://github.com/jm0535/0rdin/discussions
- **Email**: jimmy.moses@pnguot.ac.pg

---

**Version**: 3.0.0  
**Release Date**: January 31, 2025  
**Status**: Production Ready ✅
