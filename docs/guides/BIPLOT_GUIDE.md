# Biplot Guide - CANOCO-Style Ordination Overlays

## Overview
Ördin now supports **CANOCO-style biplots** with environmental variable overlays! You can add:
- **Environmental arrows** for continuous variables (gradients)
- **Confidence ellipses** for categorical factors (groups)

These features transform simple ordination plots into informative biplots that show relationships between community composition and environmental drivers.

## New Features

### 1. Environmental Arrows 🎯
**What they show:** Direction and strength of continuous environmental gradients

**How to interpret:**
- **Arrow direction** = gradient orientation in ordination space
- **Arrow length** = strength of correlation with ordination axes
- **Site proximity to arrow** = higher values of that variable
- **Angle between arrows** = correlation between variables (small angle = correlated)

**Example variables:**
- Soil thickness (A1)
- Moisture level
- Temperature
- pH
- Nutrient concentrations

### 2. Factor Ellipses 🔵
**What they show:** 95% confidence ellipses grouping sites by categorical variables

**How to interpret:**
- **Ellipse size** = dispersion within that group
- **Ellipse overlap** = similarity between groups
- **Separated ellipses** = distinct communities
- **Color coding** = different factor levels

**Example factors:**
- Management type (BF, HF, NM, SF)
- Land use (Hayfield, Pasture, Haypastu)
- Site type
- Treatment groups

## How to Use

### Step-by-Step Instructions

#### 1. Load Your Data
```
Data Tab → Import:
- Species composition data (required)
- Environment data (required for biplots)
```

#### 2. Run Ordination
```
Ordination Tab → Settings:
- Select method (any method works)
- Click "Run Ordination"
```

#### 3. Add Environmental Arrows
```
✅ Check "Environmental arrows"
- Automatically shows ALL continuous variables
- Orange arrows with labels
- Scaled to fit plot
```

**What happens:**
- Ördin identifies numeric variables in environment data
- Fits vectors using `envfit()` from vegan
- Calculates significance (999 permutations)
- Scales arrows for visibility
- Adds labels at arrow tips

#### 4. Add Factor Ellipses
```
✅ Check "Factor ellipses"
- Select factor variable from dropdown
- Shows 95% confidence ellipses
- Color-coded by group
- Sites colored to match ellipses
```

**What happens:**
- Ördin identifies categorical variables
- Calculates multivariate normal 95% CI
- Colors sites by group
- Adds colored ellipses with transparency

### Combine Both Features!
✅ Check both options to create publication-quality biplots:
- Sites colored by factor
- Ellipses show groupings
- Arrows show gradients
- Complete story in one plot!

## Technical Details

### Environmental Arrow Fitting

**Method:** `envfit()` function from vegan package

**Process:**
1. Extract continuous variables from environment data
2. Fit environmental vectors to ordination
3. Test significance (999 permutations)
4. Extract vector coordinates (scores)
5. Scale to 80% of plot range
6. Draw arrows and labels

**Code implementation:**
```r
env_fit <- envfit(ordination, env_data[, continuous_vars], 
                 choices = 1:2, permutations = 999)
arrow_coords <- scores(env_fit, display = "vectors")
```

### Ellipse Calculation

**Method:** `stat_ellipse()` from ggplot2

**Parameters:**
- Level: 0.95 (95% confidence)
- Type: "t" (multivariate t-distribution)
- Alpha: 0.15 (transparency for fill)
- Linewidth: 1

**Code implementation:**
```r
stat_ellipse(aes(color = FactorGroup, fill = FactorGroup), 
            geom = "polygon", alpha = 0.15, level = 0.95)
```

## Supported Ordination Methods

Biplots work with **ALL ordination methods**:

### Unconstrained Methods
- ✅ **NMDS** - Arrows show env correlations after ordination
- ✅ **PCA** - Arrows are PC loadings
- ✅ **CA** - Arrows fitted post-hoc
- ✅ **DCA** - Arrows fitted post-hoc
- ✅ **PCoA** - Arrows fitted post-hoc

### Constrained Methods
- ✅ **CCA** - Arrows show constraining variables (built-in)
- ✅ **RDA** - Arrows show constraining variables (built-in)

**Note:** For CCA/RDA, arrows represent the constraining variables used in the analysis. For unconstrained methods, arrows are fitted post-hoc using `envfit()`.

## Example Workflow

### Example: Dune Meadow Data

**Data:**
- 20 sites
- 30 plant species
- 5 environmental variables (A1, Moisture, Management, Use, Manure)

**Analysis:**
1. Load `sample_data_species.csv` and `sample_data_environment.csv`
2. Run NMDS (or CCA for constrained analysis)
3. Check "Environmental arrows"
4. Check "Factor ellipses" → Select "Management"

**Result:**
- Sites grouped by management type (BF, HF, NM, SF)
- Colored ellipses show management groups
- Arrows show soil thickness (A1) and moisture gradients
- Clear visualization of management effects on community composition

## Customization Options

### Current Features
- ✅ Choose which factor variable for ellipses
- ✅ Toggle arrows on/off
- ✅ Toggle ellipses on/off
- ✅ Arrows auto-scale to plot

### Planned Enhancements
- Select specific variables for arrows
- Adjust arrow scaling factor
- Show/hide non-significant arrows
- Customizeellipse confidence level
- Add species scores as points/text

## Color Scheme

**Arrows:**
- Color: Orange (#ff8c00)
- Style: Closed arrowhead, bold font
- Alpha: 0.8

**Ellipses:**
- Fill: Factor level colors (auto-assigned)
- Border: Same as fill
- Alpha: 0.15 (fill), 1.0 (border)

**Sites:**
- Without ellipses: Primary palette color
- With ellipses: Colored by factor level

## Interpretation Tips

### 1. Arrow Length
- **Long arrow** = strong correlation with ordination
- **Short arrow** = weak correlation
- Length scaled relative to plot size

### 2. Arrow Direction
- Points toward sites with **high values**
- Opposite direction = **low values**
- Perpendicular to axis = no correlation with that axis

### 3. Angle Between Arrows
- **Acute angle** (< 90°) = positive correlation
- **Right angle** (90°) = no correlation
- **Obtuse angle** (> 90°) = negative correlation

### 4. Ellipse Overlap
- **Separated** = significantly different communities
- **Overlapping** = similar species composition
- **Nested** = subset relationship

## Publication-Quality Output

### Export Options
```
Download Options:
- PNG (high DPI for presentations)
- SVG (vector for publications)
- TIFF (high-res for journals)
```

**Recommended:**
- Format: SVG or TIFF
- DPI: 300+ for publications
- Size: 12" × 8" (default)

### Figure Legend Example
```
Figure 1. NMDS ordination of dune meadow plant communities 
colored by management type (stress = 0.118). Environmental 
arrows show gradients of continuous variables (soil thickness 
A1 and moisture). Ellipses represent 95% confidence intervals 
for management types: BF (Biological Farming), HF (Hobby 
Farming), NM (Nature Management), SF (Standard Farming).
```

## Troubleshooting

### "Environmental arrows not showing"
**Cause:** No continuous variables in environment data

**Solution:**
- Check your environment data has numeric columns
- Ensure data types are correct (numeric, not character)

### "No categorical variables available"
**Cause:** All environment variables are numeric

**Solution:**
- Convert appropriate variables to factors (Management, Use, etc.)
- Re-upload environment data

### "Arrows too small/large"
**Current:** Auto-scaled to 80% of plot range

**Future:** Manual scaling slider will be added

### "Ellipses not visible"
**Check:**
- Factor variable is selected
- "Factor ellipses" checkbox is enabled
- Selected factor has multiple levels

## References

**Environmental fitting:**
- Oksanen, J. (2024). vegan: Community Ecology Package. R package.
- `?envfit` for environmental vector fitting

**Statistical ellipses:**
- Friendly, M. (2002). Elliptical Insights. Statistical Science.

**CANOCO software:**
- ter Braak, C.J.F. & Šmilauer, P. (2012). CANOCO Reference Manual and User's Guide.

## Keyboard Shortcuts

When viewing ordination plots:
- `Ctrl + S` - Save current plot
- `Ctrl + Z` - Zoom reset
- `Ctrl + +` - Zoom in
- `Ctrl + -` - Zoom out

---

**Author:** Jimmy Moses  
**Application:** Ördin v3.0  
**Email:** jimmy.moses@pnguot.ac.pg  
**Date:** 2025

**Tip:** Start with arrows only, then add ellipses. This helps you understand each component before combining them for complex biplots.
