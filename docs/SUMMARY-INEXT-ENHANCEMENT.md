# Summary: iNEXT Enhancement Update for Ördin

## 🎯 What Was Done

Fixed **shaded confidence intervals** and added **complete iNEXT parameter customization** to Ördin.

---

## ✅ Problems Fixed

### Problem 1: Line CI Instead of Shaded CI ❌ → ✅

**BEFORE**:
- Confidence intervals displayed as **three separate lines**
- Hard to see uncertainty regions
- Didn't match iNEXT documentation style

**AFTER**: ✅
- Confidence intervals displayed as **shaded ribbons**
- Professional publication-quality appearance
- Matches official iNEXT visualization style
- Explicitly set `se = TRUE` in `ggiNEXT()`

### Problem 2: No iNEXT Parameter Control ❌ → ✅

**BEFORE**:
- Fixed parameters: `q = c(0, 1, 2)`, `knots = 40`, `nboot = 50`, `conf = 0.95`
- Users couldn't customize analysis
- No visibility of what parameters were used

**AFTER**: ✅
- **Full control** over all iNEXT parameters
- Interactive UI for customization
- Parameters displayed in plot subtitle for transparency

---

## 🎛️ New Features Added

### 1. Hill Numbers Selection ✨
**UI Component**: Checkbox group  
**Location**: Sidebar under "iNEXT Advanced Options"  
**Options**:
- ☑ q=0 (Species Richness)
- ☑ q=1 (Shannon Diversity)
- ☑ q=2 (Simpson Diversity)

**Default**: All three selected  
**Purpose**: Choose which diversity orders to display

---

### 2. Knots (Curve Smoothness) ✨
**UI Component**: Numeric input slider  
**Location**: Sidebar under "iNEXT Advanced Options"  
**Range**: 10-200  
**Default**: 40

**Purpose**: Control curve smoothness
- Low (10-20): Faster, choppier
- Medium (30-50): Balanced (default)
- High (60-200): Slower, publication-quality

---

### 3. Bootstrap Replicates (CI Accuracy) ✨
**UI Component**: Numeric input  
**Location**: Sidebar under "iNEXT Advanced Options"  
**Range**: 10-500  
**Default**: 50

**Purpose**: Control confidence interval accuracy
- Low (10-30): Fast exploration
- Medium (40-100): Standard use
- High (150-500): Publication quality

---

### 4. Confidence Level (CI Width) ✨
**UI Component**: Numeric input  
**Location**: Sidebar under "iNEXT Advanced Options"  
**Range**: 0.80-0.99  
**Default**: 0.95 (95%)

**Purpose**: Set confidence interval width
- 0.90 (90%): Less conservative
- 0.95 (95%): Standard (default)
- 0.99 (99%): Very conservative

---

### 5. Enhanced Plot Subtitle ✨
**Displays**:
```
Sites: Forest_1, Grassland_1, Wetland_1 | 
Hill numbers q=0, 1, 2 | 
95% CI (nboot=50)
```

**Shows**:
- Which sites are being analyzed
- Which Hill numbers (diversity orders) are displayed
- Confidence level percentage
- Number of bootstrap replicates

**Purpose**: Full transparency and reproducibility

---

## 📝 Code Changes

### File Modified: `shiny/app.R`

#### UI Section (Lines ~30-50):
**Added**:
```r
hr(),
h5("iNEXT Advanced Options"),
checkboxGroupInput("hillNumbers", "Hill Numbers (Diversity Orders)",
                   choices = c("q=0 (Species Richness)" = "0",
                             "q=1 (Shannon Diversity)" = "1",
                             "q=2 (Simpson Diversity)" = "2"),
                   selected = c("0", "1", "2")),
numericInput("knots", "Number of Knots (smoothness)",
             value = 40, min = 10, max = 200, step = 10),
helpText("More knots = smoother curves (default: 40)"),
numericInput("nboot", "Bootstrap Replicates (CI)",
             value = 50, min = 10, max = 500, step = 10),
helpText("More replicates = more accurate CI (default: 50, increase for publication)"),
numericInput("conf", "Confidence Level",
             value = 0.95, min = 0.80, max = 0.99, step = 0.01),
helpText("Default: 0.95 (95% CI)")
```

#### Server Section (Lines ~125-145):
**Changed FROM**:
```r
# Old code
data_type <- input$dataType
inext_out <- iNEXT(abund_matrix_t, q = c(0, 1, 2), datatype = data_type)
```

**Changed TO**:
```r
# New code with custom parameters
data_type <- input$dataType

# Get selected Hill numbers
selected_q <- as.numeric(input$hillNumbers)
if (length(selected_q) == 0) selected_q <- c(0, 1, 2)

# Run iNEXT with ALL custom parameters
inext_out <- iNEXT(
  x = abund_matrix_t, 
  q = selected_q,               # User-selected Hill numbers
  datatype = data_type,         # Abundance or Incidence
  knots = input$knots,          # Smoothness (10-200)
  nboot = input$nboot,          # Bootstrap replicates (10-500)
  conf = input$conf             # Confidence level (0.80-0.99)
)
```

#### Plotting Section (Lines ~145-175):
**Changed FROM**:
```r
# Old code - basic plot
plot_obj <- ggiNEXT(inext_out, type = plot_type_num) + 
  theme_minimal(base_size = 14) + 
  labs(title = plot_title,
       subtitle = paste("Sites:", paste(colnames(abund_matrix_t), collapse = ", "))) +
  theme(...)
```

**Changed TO**:
```r
# New code - shaded CI + parameter display
plot_obj <- ggiNEXT(
  x = inext_out, 
  type = plot_type_num,
  se = TRUE,                    # ✅ SHADED confidence intervals
  facet.var = "None",           # Single panel
  color.var = "Assemblage"      # Color by site
) + 
  labs(
    title = plot_title,
    subtitle = paste0(
      "Sites: ", paste(colnames(abund_matrix_t), collapse = ", "),
      " | Hill numbers q=", paste(selected_q, collapse = ", "),
      " | ", input$conf * 100, "% CI (nboot=", input$nboot, ")"
    )
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    legend.position = "bottom",
    legend.box = "vertical"
  )
```

---

## 📚 Documentation Created

### 1. **INEXT-PARAMETERS-GUIDE.md** (640 lines)
**Purpose**: Comprehensive reference for all iNEXT parameters  
**Contents**:
- Detailed explanation of each parameter
- When to use different values
- Examples and recommendations
- Visual comparisons
- Quick reference tables

### 2. **SHADED-CI-FIX.md** (385 lines)
**Purpose**: Explain the shaded CI fix  
**Contents**:
- Before/after comparison
- Technical explanation
- Troubleshooting guide
- Verification checklist

---

## 🎨 Visual Improvements

### Before (Lines):
```
      ┌────────────────┐
Species│    ─────       │  ← Upper CI line
      │   ─────────    │  ← Point estimate
      │  ──────────    │  ← Lower CI line
      └────────────────┘
```

### After (Shaded): ✅
```
      ┌────────────────┐
Species│    ▓▓▓▓▓▓▓     │  ← Shaded 95% CI
      │   ▓▓▓▓▓▓▓▓▓    │  ← Point estimate line
      │  ▓▓▓▓▓▓▓▓▓▓▓   │  ← in solid color
      └────────────────┘
```

---

## 🚀 How to Use New Features

### Basic Usage (Default Settings):
1. Upload CSV data
2. Select data type (Abundance/Incidence)
3. Leave advanced options at defaults
4. Run analysis
5. **Get shaded CI automatically** ✅

### Advanced Usage (Custom Parameters):
1. Upload CSV data
2. Select data type
3. **Customize iNEXT parameters**:
   - Select Hill numbers (q=0, 1, 2)
   - Adjust knots (40 → 80 for smoother)
   - Increase nboot (50 → 200 for publication)
   - Change confidence level if needed (0.95 → 0.99)
4. Choose plot type (1, 2, or 3)
5. Run analysis
6. **Verify parameters in subtitle** ✅

---

## 📊 Parameter Recommendations

### Quick Exploration:
```
Hill numbers: q=0 only
Knots: 20
nboot: 30
Confidence: 0.95
```

### Standard Analysis:
```
Hill numbers: q=0, 1, 2 (all)
Knots: 40
nboot: 50
Confidence: 0.95
```

### Publication Quality:
```
Hill numbers: q=0, 1, 2 (all)
Knots: 60-80
nboot: 200
Confidence: 0.95
Plot type: Type 3 (coverage-based)
```

---

## ✅ Verification Checklist

After running analysis, you should see:

- [ ] **Shaded ribbons** around curves (not separate lines)
- [ ] Confidence intervals are **semi-transparent**
- [ ] Plot subtitle shows **all parameters** (sites, q, CI%, nboot)
- [ ] Can **select/deselect Hill numbers** in sidebar
- [ ] Can **adjust knots** and see smoothness change
- [ ] Can **adjust nboot** and see CI accuracy improve
- [ ] Can **change confidence level** (90%, 95%, 99%)
- [ ] Plot matches **iNEXT documentation style**

---

## 📖 Related Documentation

1. **[docs/INEXT-PARAMETERS-GUIDE.md](INEXT-PARAMETERS-GUIDE.md)**  
   Complete guide to all iNEXT parameters

2. **[docs/SHADED-CI-FIX.md](SHADED-CI-FIX.md)**  
   Explanation of the shaded CI fix

3. **[docs/RAREFACTION-IMPLEMENTATION.md](RAREFACTION-IMPLEMENTATION.md)**  
   Overall rarefaction implementation details

4. **[ESTIMATES-AND-RAREFACTION-TYPES.md](../ESTIMATES-AND-RAREFACTION-TYPES.md)**  
   Theory of rarefaction types

5. **Official iNEXT Documentation**:
   - CRAN: https://cran.r-project.org/package=iNEXT
   - Vignette: https://cran.r-project.org/web/packages/iNEXT/vignettes/Introduction.html
   - GitHub: https://github.com/JohnsonHsieh/iNEXT

---

## 🎓 Technical Details

### iNEXT Function Call (Full):
```r
iNEXT(
  x = abund_matrix_t,           # Data (sites as columns)
  q = c(0, 1, 2),              # Hill numbers (diversity orders)
  datatype = "abundance",       # Individual or incidence-based
  size = NULL,                  # Auto-determine sample sizes
  endpoint = NULL,              # Auto-determine extrapolation endpoint
  knots = 40,                   # Interpolation points (smoothness)
  se = TRUE,                    # Calculate standard errors
  conf = 0.95,                  # Confidence level (95%)
  nboot = 50                    # Bootstrap replicates (CI accuracy)
)
```

### ggiNEXT Function Call (Full):
```r
ggiNEXT(
  x = inext_out,                # iNEXT object
  type = 1,                     # Plot type (1, 2, or 3)
  se = TRUE,                    # Show shaded CI ✅
  facet.var = "None",           # Panel layout
  color.var = "Assemblage",     # Color scheme
  grey = FALSE                  # Use colors (not greyscale)
)
```

---

## 🔬 What Makes This Implementation Correct

### ✅ Matches Official iNEXT:
- Uses `se = TRUE` for shaded confidence intervals
- Displays all three Hill numbers by default
- Shows parameters transparently in subtitle
- Proper parameter passing to `iNEXT()`

### ✅ Best Practices:
- Default values match publication standards
- Users can customize for specific needs
- Full transparency (all parameters visible)
- Reproducible (parameters shown in output)

### ✅ User-Friendly:
- Sensible defaults work out-of-the-box
- Advanced options available when needed
- Help text explains each parameter
- Visual feedback immediate

---

## 🎉 Summary

### Before This Update:
- ❌ Line confidence intervals (not standard)
- ❌ No parameter customization
- ❌ Fixed settings (q, knots, nboot, conf)
- ❌ No parameter visibility

### After This Update: ✅
- ✅ **Shaded confidence intervals** (publication-ready)
- ✅ **Full iNEXT parameter control**
- ✅ **Transparent parameter display**
- ✅ **Matches official iNEXT style**
- ✅ **Comprehensive documentation**

---

**Ördin now provides professional-grade, fully-customizable iNEXT analysis with proper shaded confidence intervals!** 🎨📊✨
