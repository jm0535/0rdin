# Ördin 3.0 — Comprehensive Settings Guide (legacy)

> ⚠️ **Legacy document (Ördin 3.x).** This describes the R Shiny + Electron
> application in `shiny/` and `src/`, which is kept for maintenance only.
> For the current release see [Documentation Index](../DOCS-INDEX.md) ·
> [Quick Start](../QUICKSTART.md) · [Architecture](../ARCHITECTURE.md).

## Overview
The enhanced settings sidebar provides enterprise-grade configuration options for the Ördin biodiversity analysis platform. Access settings by clicking the **gear icon (⚙️)** in the top-right corner of the navigation bar.

---

## Settings Categories

### 1. General Settings
**Purpose**: Core application behavior configuration

- **Auto-save** (Toggle)
  - Automatically saves your work every 30 seconds
  - Stores data in browser's localStorage
  - Default: `Enabled`

- **Notifications** (Toggle)
  - Shows toast notifications for actions and events
  - Includes success, error, and info messages
  - Default: `Enabled`

---

### 2. Appearance Settings
**Purpose**: Customize the visual presentation of the application

- **Theme** (Dropdown)
  - Options: Dark, Light, Auto (system preference)
  - Keyboard shortcut: `Ctrl+T` to toggle
  - Default: `Dark`
  - Persists across sessions

- **Font Size** (Dropdown)
  - Options: Small, Medium, Large
  - Affects all text in the application
  - Default: `Medium`

---

### 3. Data & Export Settings
**Purpose**: Configure data export and precision settings

- **Export Format** (Dropdown)
  - Options: CSV, Excel, JSON
  - Sets default format for data exports
  - Default: `CSV`

- **Decimal Precision** (Dropdown)
  - Options: 1-5 decimal places
  - Controls numerical precision in outputs
  - Default: `3`

---

### 4. Plots & Visualization Settings ⭐ NEW
**Purpose**: Control plot theming and export quality

- **ggplot2 Theme** (Dropdown)
  - Options:
    - `Minimal` (Default) - Clean, minimal design
    - `Black & White` - High contrast
    - `Classic` - Traditional R style
    - `Grey` - Standard ggplot2 theme
    - `Light` - Light background variant
    - `Dark` - Dark background variant
    - `Void` - Empty theme for custom styling
  - Applies to all diversity and ordination plots
  - Default: `Minimal`

- **Plot Quality (DPI)** (Dropdown)
  - Options:
    - `150 DPI` - Screen quality
    - `300 DPI` - Publication quality (Default)
    - `600 DPI` - High-resolution printing
  - Affects PNG and TIFF exports
  - Default: `300 DPI`

- **Color Palette** (Dropdown)
  - Options:
    - `Ördin Green` (Default) - Brand color (#2e8b57)
    - `Viridis` - Perceptually uniform, colorblind-safe
    - `Colorblind-Safe` - Optimized for color vision deficiency
    - `Set1 (Bright)` - Bold, saturated colors
    - `Set2 (Pastel)` - Soft, muted colors
  - Applies to plot colors in visualizations
  - Default: `Ördin Green`

**Best Practices**:
- For publications: Use `theme_bw` or `theme_classic` with 300-600 DPI
- For presentations: Use `theme_minimal` with `Viridis` or `Colorblind-Safe` palettes
- For web/screen: 150 DPI is sufficient

---

### 5. Zoom & Display Settings ⭐ NEW
**Purpose**: Control page zoom level for accessibility

- **Zoom Controls** (Buttons)
  - `-` button: Zoom out (minimum 50%)
  - `+` button: Zoom in (maximum 200%)
  - `Reset` button: Return to 100%
  - Live zoom percentage display
  - Steps: 10% increments
  - Default: `100%`

**Use Cases**:
- Accessibility: Increase zoom for better readability
- High-DPI displays: Adjust zoom for optimal viewing
- Presentations: Zoom in for audience visibility

**Keyboard Shortcuts** (Future):
- `Ctrl + Plus`: Zoom in
- `Ctrl + Minus`: Zoom out
- `Ctrl + 0`: Reset zoom

---

### 6. Citations & References ⭐ NEW
**Purpose**: Access complete citation information for academic use

- **View Citations** (Button)
  - Opens modal dialog with formatted citations
  - Includes:
    - ✅ **R Core Team** - R Foundation citation
    - ✅ **iNEXT Package** - Hsieh, Ma & Chao (2016)
    - ✅ **vegan Package** - Oksanen et al. (2024)
    - ✅ **ggplot2 Package** - Wickham (2016)
    - ✅ **Ördin Application** - Moses (2025)
  - Copy all citations to clipboard functionality
  - Formatted for academic publications

**Citation Format**:
```
R Core Team (2025). R: A Language and Environment for Statistical Computing. 
R Foundation for Statistical Computing, Vienna, Austria. 
URL: https://www.R-project.org/

Hsieh, T. C., Ma, K. H., & Chao, A. (2016). iNEXT: An R package for rarefaction 
and extrapolation of species diversity (Hill numbers). 
Methods in Ecology and Evolution, 7(12), 1451-1456. 
DOI: 10.1111/2041-210X.12613

Oksanen, J., Simpson, G. L., Blanchet, F. G., Kindt, R., Legendre, P., 
Minchin, P. R., ... & Wagner, H. (2024). 
vegan: Community Ecology Package. R package version 2.6-6.1. 
URL: https://CRAN.R-project.org/package=vegan

Wickham, H. (2016). ggplot2: Elegant Graphics for Data Analysis. 
Springer-Verlag New York. ISBN: 978-3-319-24277-4. 
URL: https://ggplot2.tidyverse.org

Moses, J. (2025). Ördin: An Interactive Platform for Biodiversity Analysis 
and Ordination. Version 3.0.
```

---

### 7. Actions
**Purpose**: Maintenance and reset operations

- **Clear Cache** (Button)
  - Removes all localStorage data
  - Clears sessionStorage
  - Useful for troubleshooting
  - **Warning**: Cannot be undone

- **Reset to Defaults** (Button)
  - Restores all settings to factory defaults
  - Requires confirmation
  - Resets:
    - Theme → Dark
    - Font Size → Medium
    - Export Format → CSV
    - Decimal Precision → 3
    - ggplot Theme → Minimal
    - Plot DPI → 300
    - Color Palette → Ördin Green
    - Zoom Level → 100%

---

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+O` | Open file dialog |
| `Ctrl+S` | Save/Export results |
| `Ctrl+T` | Toggle theme (Dark/Light) |
| `Ctrl+1` | Switch to Home tab |
| `Ctrl+2` | Switch to Diversity Analysis tab |
| `Ctrl+3` | Switch to Ordination tab |
| `F1` | Open Help |

---

## Data Persistence

All settings are automatically saved to browser's localStorage and persist across sessions:

- ✅ Theme preference
- ✅ Font size
- ✅ Auto-save state
- ✅ Notifications state
- ✅ Export format
- ✅ Decimal precision
- ✅ ggplot2 theme
- ✅ Plot DPI
- ✅ Color palette
- ✅ Zoom level

**Note**: Clearing browser data or using "Clear Cache" will remove saved settings.

---

## Technical Implementation

### Color Palettes
- **Ördin Green**: `#2e8b57` (SeaGreen)
- **Viridis**: Uses `viridis` R package
- **Colorblind-Safe**: Optimized palette from Okabe-Ito color scheme
- **Set1/Set2**: ColorBrewer palettes via `RColorBrewer`

### ggplot2 Themes
All themes use base font size of 14pt for consistency. Themes are applied via reactive helper function `get_plot_theme()`.

### Zoom Implementation
- Uses CSS `zoom` property
- Range: 50% - 200%
- Increments: 10%
- Persists via localStorage

---

## Best Practices Recommendations

### For Academic Publications
1. **Theme**: Use `Black & White` or `Classic`
2. **DPI**: Set to 600 for journal submissions
3. **Colors**: Use `Colorblind-Safe` palette
4. **Export**: Use TIFF or high-quality PNG

### For Presentations
1. **Theme**: Use `Minimal` or `Light`
2. **DPI**: 150 is sufficient for slides
3. **Colors**: Use `Viridis` or `Set1 (Bright)`
4. **Zoom**: Increase to 120-150% for visibility

### For Web/Interactive Reports
1. **Theme**: Use `Minimal` or `Dark`
2. **Format**: Export as SVG for scalability
3. **Colors**: Use `Ördin Green` or `Viridis`

---

## Troubleshooting

### Settings Not Saving
- Ensure browser allows localStorage
- Check for private/incognito mode
- Try "Clear Cache" and reconfigure

### Plots Not Updating
- Change theme/palette and re-run analysis
- Check that data is loaded
- Verify plot generation completed without errors

### Zoom Issues
- Click "Reset" to return to 100%
- Clear browser cache if zoom persists incorrectly
- Some UI elements may not scale perfectly at extreme zoom levels

---

## Version History

### v3.0 (Current)
- ✨ Added ggplot2 theme selector
- ✨ Added plot DPI quality settings
- ✨ Added color palette options
- ✨ Added page zoom controls
- ✨ Added comprehensive citations modal
- 🎨 Enhanced settings sidebar UI
- 📝 Improved localStorage persistence

### v2.3
- Settings sidebar implementation
- Theme and font size controls

### v2.0
- Initial settings dropdown

---

## Contact & Support

**Author**: Jimmy Moses  
**Version**: 3.0  
**License**: MIT  

For issues or feature requests, please refer to the project repository.
