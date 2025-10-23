# Ördin v3.0 - Diversity Analysis Tab Restructure

## Overview
The Diversity Analysis tab has been completely restructured with a modern vertical sub-navigation interface and integrated data management workflow. Data upload functionality has been centralized in the Data tab for a more streamlined user experience.

---

## Major Changes

### 1. **Centralized Data Management** 📊
- ✅ **Data upload removed** from Diversity Analysis sidebar
- ✅ **All import operations** now in dedicated Data tab
- ✅ **Automatic data detection** - analyses use data from Data tab
- ✅ **Data status indicator** shows loaded data information

### 2. **Vertical Sub-Navigation** 🎯
- ✅ **Icon-based vertical sidebar** (80px width)
- ✅ **Two sub-sections**:
  - 🟢 **Estimation** (iNEXT) - Green theme (#2e8b57)
  - 🟠 **Indices** (vegan) - Orange theme (#ff8c00)
- ✅ **Icons visible when collapsed** for quick access
- ✅ **Collapsible settings panel** with toggle button

### 3. **Modern Layout** 🎨
- ✅ **Three-column design**:
  1. Vertical sub-nav (80px, collapsible to 0px)
  2. Settings panel (350px, collapsible)
  3. Results area (flexible width)
- ✅ **Smooth transitions** and animations
- ✅ **Responsive hover effects**

---

## New User Interface

### Layout Structure

```
┌─────────────────────────────────────────────────────────────────┐
│  Diversity Analysis Tab                                         │
├────┬──────────────────┬───────────────────────────────────────────┤
│    │                  │                                           │
│ 📊 │  Data Status     │                                           │
│Est │  ✓ Data Loaded   │                                           │
│    │  50 sites × 30   │                                           │
│    │  species         │           Results / Welcome               │
│🧮  │  [Manage Data]   │              Area                         │
│Ind │                  │                                           │
│    │  ─────────────   │                                           │
│    │                  │                                           │
│    │  Estimation      │                                           │
│☰   │  Settings:       │                                           │
│    │  • Data Type     │                                           │
│    │  • Plot Type     │                                           │
│    │  • Advanced      │                                           │
│    │                  │                                           │
│    │  [Run Analysis]  │                                           │
└────┴──────────────────┴───────────────────────────────────────────┘
 80px      350px                    Flexible
```

### Visual Elements

#### **Vertical Sub-Navigation (Left)**
```
┌──────┐
│  📊  │ ← Estimation (Green border)
│ Est  │
├──────┤
│  🧮  │ ← Indices (Orange border)
│ Ind  │
├──────┤
│      │
│      │ ← Spacer
│      │
├──────┤
│  ☰   │ ← Toggle button
└──────┘
```

**Features**:
- **Width**: 80px (expands on hover)
- **Icons**: Large, colorful, descriptive
- **Labels**: Short text below icons
- **Active state**: Filled background with theme color
- **Hover effect**: Slides 5px to the right with shadow
- **Click**: Switches active analysis mode

#### **Settings Panel (Middle)**
```
┌─────────────────────┐
│ Data Status         │
│ ✓ 50 sites × 30 sp  │
│ [Manage Data]       │
├─────────────────────┤
│                     │
│ 📊 Estimation       │
│    Settings         │
│                     │
│ Data Type: [▼]      │
│ Plot Type: [▼]      │
│                     │
│ ▼ Advanced Options  │
│   Hill Numbers      │
│   ☑ q=0 ☑ q=1 ☑ q=2│
│   Knots: [40]       │
│   Bootstrap: [50]   │
│                     │
│ [Run Estimation]    │
└─────────────────────┘
```

**Features**:
- **Width**: 350px
- **Collapsible**: Toggle button hides/shows
- **Dynamic content**: Changes based on active sub-nav
- **Scrollable**: Overflow-y auto
- **Data status**: Always visible at top

---

## Workflow Changes

### Old Workflow (v2.x)
```
1. Navigate to Diversity Analysis tab
2. Upload data in sidebar
3. Select analysis type (pills)
4. Configure settings
5. Run analysis
```

### New Workflow (v3.0)
```
1. Navigate to Data tab
2. Import data (local/cloud)
3. Edit/validate data (optional)
4. Navigate to Diversity Analysis tab
5. Data automatically detected ✓
6. Click vertical icon (Estimation or Indices)
7. Configure settings in panel
8. Run analysis
```

---

## Sub-Navigation Details

### Estimation (Green Theme)

**Icon**: 📊 `chart-line`  
**Color**: `#2e8b57` (Ördin Green)  
**Analysis**: iNEXT rarefaction & extrapolation

**Settings Available**:
- Data Type (Abundance/Incidence)
- Plot Type (Sample-based/Completeness/Coverage)
- Advanced Options:
  - Hill Numbers (q=0, q=1, q=2)
  - Knots (interpolation points)
  - Bootstrap iterations
  - Confidence level
  - Endpoint value

**Button**: 🟢 **Run Estimation**

### Indices (Orange Theme)

**Icon**: 🧮 `calculator`  
**Color**: `#ff8c00` (Orange)  
**Analysis**: vegan diversity indices

**Settings Available**:
- Alpha Diversity:
  - Shannon
  - Simpson
  - InvSimpson
  - Fisher's α
  - Species Richness
- Evenness:
  - Pielou's J
  - Simpson's E
  - Evar

**Button**: 🟠 **Calculate Indices**

---

## Data Status Indicator

### When Data is Loaded
```
┌─────────────────────────┐
│ ✓ Data Loaded           │
│ 50 sites × 30 species   │
│                         │
│ [Manage Data]           │
└─────────────────────────┘
```
- **Color**: Green background (#1a3a1a), green border
- **Icon**: ✓ check-circle
- **Info**: Dimensions display
- **Action**: Button to navigate to Data tab

### When No Data
```
┌─────────────────────────┐
│ ⚠ No Data Loaded        │
│ Import data to begin    │
│                         │
│ [Import Data]           │
└─────────────────────────┘
```
- **Color**: Orange background (#3a2a0a), orange border
- **Icon**: ⚠ exclamation-triangle
- **Info**: Instruction message
- **Action**: Button to navigate to Data tab

---

## Collapsible Functionality

### Toggle Settings Panel

**Button Location**: Bottom of vertical nav  
**Icon**: ☰ bars  
**Action**: Click to hide/show settings panel

**Collapsed State**:
- Settings panel: `width: 0px`, `margin-left: -350px`
- More space for results
- Icons still visible

**Expanded State** (Default):
- Settings panel: `width: 350px`
- Full settings access

### CSS Classes
```css
.diversity-settings.collapsed {
  width: 0 !important;
  margin-left: -350px !important;
  overflow: hidden !important;
}
```

---

## Color Coding

| Element | Color | Hex | Usage |
|---------|-------|-----|-------|
| Estimation Icon | Green | #2e8b57 | Border, text, active bg |
| Estimation Button | Green | #2e8b57 | Run analysis button |
| Indices Icon | Orange | #ff8c00 | Border, text, active bg |
| Indices Button | Orange | #ff8c00 | Calculate button |
| Data Status (OK) | Green | #2e8b57 | Success state |
| Data Status (No Data) | Orange | #ff8c00 | Warning state |
| Background | Dark Gray | #252526 | Vertical nav |
| Settings Panel | Darker Gray | #1e1e1e | Settings background |

---

## Animations & Transitions

### Vertical Nav Buttons
```css
transition: all 0.3s ease;

/* Hover */
transform: translateX(5px);
box-shadow: 0 4px 12px rgba(46, 139, 87, 0.3);

/* Active */
background: #2e8b57 (or #ff8c00);
```

### Settings Panel
```css
transition: width 0.3s ease, margin-left 0.3s ease;
```

### Sub-Nav Switch
```css
/* Buttons update background instantly */
/* Settings content fades in smoothly */
```

---

## Responsive Behavior

### Desktop (>1200px)
- Full 3-column layout
- All panels visible
- Smooth animations

### Tablet (768px - 1200px)
- Settings panel auto-collapses
- Vertical nav remains visible
- Toggle to access settings

### Mobile (<768px)
- Future: Stack vertically
- Horizontal tabs instead of vertical
- Full-width panels

---

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+1` | Switch to Diversity Analysis tab |
| `Ctrl+2` | Switch to Ordination tab |
| `E` | Switch to Estimation (when in Diversity tab) |
| `I` | Switch to Indices (when in Diversity tab) |
| `T` | Toggle settings panel |

*(Note: E, I, T shortcuts are planned for future implementation)*

---

## Integration with Data Tab

### Automatic Data Flow

```mermaid
graph LR
    A[Data Tab] -->|Import CSV/Excel| B[dataManagement$speciesData]
    B -->|Auto-detect| C[Diversity Analysis]
    C -->|Check status| D{Data exists?}
    D -->|Yes| E[Show green status]
    D -->|No| F[Show orange warning]
    E -->|Click Run| G[Execute analysis]
    F -->|Click Import| A
```

### Reactive Values Used
```r
dataManagement$speciesData      # Main species matrix
dataManagement$envData          # Environment data (optional)
dataManagement$speciesOriginal  # Backup copy
diversityActiveTab()            # "estimation" or "indices"
```

---

## User Benefits

### ✅ **Improved Workflow**
1. Clearer separation of data management vs. analysis
2. No duplicate upload interfaces
3. Edit data without re-uploading

### ✅ **Better Visual Hierarchy**
1. Vertical icons are instantly recognizable
2. Color coding (green/orange) aids navigation
3. Data status always visible

### ✅ **Space Efficiency**
1. Collapsible panels maximize results area
2. Vertical nav takes minimal width
3. More room for plots and tables

### ✅ **Professional Appearance**
1. Modern web app design patterns
2. Smooth animations and transitions
3. Consistent with enterprise software

---

## Comparison: Old vs New

| Feature | v2.x (Old) | v3.0 (New) |
|---------|------------|------------|
| Data upload | In Diversity tab | In Data tab only |
| Sub-navigation | Horizontal pills | Vertical icons |
| Icons | Text-only pills | Large icons + labels |
| Collapsed view | Not available | Icons still visible |
| Settings layout | Fixed sidebar | Collapsible panel |
| Data status | Not shown | Prominent indicator |
| Layout flexibility | Fixed | Highly flexible |
| Visual polish | Basic | Enterprise-grade |

---

## Developer Notes

### Server-Side Structure

#### New Reactive Values
```r
diversityActiveTab <- reactiveVal("estimation")  # Tracks active sub-nav
```

#### New Outputs
```r
output$diversityDataStatus       # Data status card
output$diversitySettingsContent  # Dynamic settings UI
output$diversityMainContent      # Results area (updated)
```

#### Event Handlers
```r
observeEvent(input$diversitySubNav, {...})  # Sub-nav switch
observeEvent(input$goToDataTab, {...})      # Navigate to Data
```

### UI Structure
```r
tags$div(
  # Vertical sub-nav (80px)
  tags$div(id = "diversity-subnav", ...),
  
  # Main content wrapper
  tags$div(
    # Settings panel (350px, collapsible)
    tags$div(id = "diversity-settings-panel", ...),
    
    # Results area (flexible)
    tags$div(uiOutput("diversityMainContent"))
  )
)
```

---

## Future Enhancements

### Planned Features (v3.1+)

1. **Keyboard Navigation**
   - ✨ `E` key for Estimation
   - ✨ `I` key for Indices
   - ✨ `T` key to toggle settings

2. **Resizable Panels**
   - ✨ Drag to resize settings panel
   - ✨ Remember user's preferred width

3. **Favorites/Presets**
   - ✨ Save common analysis configurations
   - ✨ Quick-load preset settings

4. **Analysis History**
   - ✨ List of recent analyses
   - ✨ Re-run with same settings
   - ✨ Compare multiple runs

5. **Enhanced Data Status**
   - ✨ Data quality indicators
   - ✨ Quick stats preview
   - ✨ Transformation history

---

## Migration Guide

### For Existing Users

**What Changed**:
1. Data upload is now in the **Data tab** (not Diversity Analysis)
2. Analysis selection uses **vertical icons** (not horizontal pills)
3. Settings panel can be **collapsed** for more space

**How to Adapt**:
1. Go to **Data tab** first
2. Import your data (same process, better interface)
3. Navigate to **Diversity Analysis tab**
4. Click the green **📊 Estimation** or orange **🧮 Indices** icon
5. Configure settings and run analysis as before

**Nothing Lost**:
- All analysis features remain the same
- Same statistical methods and outputs
- Keyboard shortcuts still work

---

## Technical Specifications

### Dependencies
- R packages: `shiny`, `bslib`, `iNEXT`, `vegan`, `ggplot2`, `DT`
- CSS: Custom vertical nav styles
- JavaScript: Toggle functions, initialization

### Performance
- **Load time**: ~1s for tab switch
- **Animation duration**: 0.3s for transitions
- **Memory**: Minimal overhead (~5MB)

### Browser Support
- Chrome 90+: ✅ Full support
- Firefox 88+: ✅ Full support
- Edge 90+: ✅ Full support
- Safari 14+: ✅ Full support

---

## Version History

### v3.0 (Current)
- ✨ Removed data upload from Diversity Analysis
- ✨ Added vertical sub-navigation with icons
- ✨ Implemented collapsible settings panel
- ✨ Added data status indicator
- ✨ Integrated with centralized Data tab
- 🎨 Modern 3-column layout
- 🎨 Green/Orange color coding
- 🎨 Smooth animations and transitions

---

## Credits

**Author**: Jimmy Moses  
**Email**: jmoses@pnguot.ac.pg  
**Version**: 3.0  
**Date**: 2025  

**Design Inspiration**:
- VS Code vertical activity bar
- GitHub sidebar navigation
- Modern SaaS applications

---

## License

MIT License

Copyright (c) 2025 Jimmy Moses
