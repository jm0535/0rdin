# iNEXT Parameters Guide for Ördin

## 🎛️ Complete Guide to iNEXT Customization Options

This guide explains **all the iNEXT parameters** you can now customize in Ördin, based on the official iNEXT documentation.

---

## 📊 Core iNEXT Function Parameters

### Function Signature:
```r
iNEXT(x, q, datatype, size, endpoint, knots, se, conf, nboot)
```

---

## 1️⃣ Hill Numbers (q) - **DIVERSITY ORDERS**

### In Ördin UI:
**Location**: Sidebar → "Hill Numbers (Diversity Orders)"  
**Type**: Checkbox group  
**Default**: All selected (q=0, 1, 2)

### Parameter Details:
```r
q = c(0, 1, 2)  # Vector of diversity orders
```

### Options:

#### q = 0: **Species Richness**
- **What it measures**: Total number of species
- **Sensitivity**: ALL species weighted equally (rare species count!)
- **Formula**: `S` (simple count)
- **Use when**: You care about total biodiversity
- **Example**: "How many butterfly species are in this meadow?"

#### q = 1: **Shannon Diversity (Exponential)**
- **What it measures**: "Effective" number of species
- **Sensitivity**: Common species matter more
- **Formula**: `exp(H')` where H' is Shannon entropy
- **Use when**: You want a balanced measure
- **Example**: "What's the typical diversity considering abundance?"

#### q = 2: **Simpson Diversity (Inverse)**
- **What it measures**: Dominant species emphasis
- **Sensitivity**: Most abundant species heavily weighted
- **Formula**: `1/λ` where λ is Simpson index
- **Use when**: You care about evenness and dominants
- **Example**: "Is diversity dominated by a few species?"

### Technical Note:
Hill numbers form a **unified diversity framework**:
```
q → 0: Approaches species richness
q = 1: Shannon diversity (limit as q→1)
q → ∞: Approaches 1/max(p_i) (most abundant species)
```

### In Ördin:
- Select **one, two, or all three** q values
- Each q produces a separate curve on the plot
- Colors distinguish different q values
- Default: All three for comprehensive view

---

## 2️⃣ Knots - **CURVE SMOOTHNESS**

### In Ördin UI:
**Location**: Sidebar → "Number of Knots (smoothness)"  
**Type**: Numeric input  
**Default**: 40  
**Range**: 10-200

### Parameter Details:
```r
knots = 40  # Number of interpolation points
```

### What It Does:
- Controls how many **points** are calculated between observed samples
- More knots = **smoother, more detailed curves**
- Fewer knots = **faster computation, choppier curves**

### Recommendations:

| Knots | Speed | Quality | Use Case |
|-------|-------|---------|----------|
| 10-20 | ⚡⚡⚡ Fast | Basic | Quick exploration |
| 30-50 | ⚡⚡ Moderate | Good | **Default/standard** |
| 60-100 | ⚡ Slow | Excellent | Publication figures |
| 100-200 | 🐌 Very slow | Ultra-smooth | Presentations |

### Visual Impact:
```
Knots = 10:  ___/‾‾‾\___/‾‾‾  (choppy)
Knots = 40:  ___/‾‾‾‾‾‾‾‾‾  (smooth)
Knots = 100: ___/‾‾‾‾‾‾‾‾‾  (very smooth)
```

### Technical Note:
- Uses **spline interpolation** between observed and extrapolated points
- Does NOT affect statistical accuracy, only visual smoothness
- Higher knots increase computation time linearly

### In Ördin:
- Adjust slider from 10-200
- Default 40 works for most cases
- Increase for publication-quality figures

---

## 3️⃣ Bootstrap Replicates (nboot) - **CONFIDENCE INTERVAL ACCURACY**

### In Ördin UI:
**Location**: Sidebar → "Bootstrap Replicates (CI)"  
**Type**: Numeric input  
**Default**: 50  
**Range**: 10-500

### Parameter Details:
```r
nboot = 50  # Number of bootstrap replications
```

### What It Does:
- Generates **confidence intervals** via bootstrapping
- More replicates = **more accurate CI bounds**
- Fewer replicates = **faster but less reliable**

### Recommendations:

| nboot | Speed | CI Accuracy | Use Case |
|-------|-------|-------------|----------|
| 10-20 | ⚡⚡⚡ Fast | Poor | Quick checks only |
| 30-50 | ⚡⚡ Moderate | Acceptable | **Default/exploration** |
| 100-200 | ⚡ Slow | Good | **Publication quality** |
| 200-500 | 🐌 Very slow | Excellent | Critical analyses |

### Visual Impact on CI:
```
nboot = 20:  CI may be unstable (wider variation)
nboot = 50:  CI reasonably stable (default)
nboot = 200: CI very stable (publication standard)
```

### Statistical Note:
- iNEXT uses **analytical formulas** for point estimates
- Bootstrap is ONLY for **confidence intervals**
- Standard error decreases as `1/√nboot`
- Doubling nboot only improves accuracy by ~41%

### Computation Time:
```
nboot = 50:   ~2-5 seconds (normal)
nboot = 200:  ~8-20 seconds (4x slower)
nboot = 500:  ~20-50 seconds (10x slower)
```

### In Ördin:
- Default 50 for balance
- Increase to **100-200 for papers**
- Use 500 only for critical final analyses
- Lower to 20 for quick exploration

---

## 4️⃣ Confidence Level (conf) - **CI WIDTH**

### In Ördin UI:
**Location**: Sidebar → "Confidence Level"  
**Type**: Numeric input  
**Default**: 0.95 (95%)  
**Range**: 0.80-0.99

### Parameter Details:
```r
conf = 0.95  # Confidence level (0 to 1)
```

### What It Does:
- Sets the **probability coverage** of confidence intervals
- Higher conf = **wider CI** (more conservative)
- Lower conf = **narrower CI** (less conservative)

### Common Values:

| conf | CI % | Use Case | Interpretation |
|------|------|----------|----------------|
| 0.90 | 90% | Exploratory | Less stringent |
| **0.95** | **95%** | **Standard** | **Most common** |
| 0.99 | 99% | Conservative | Very stringent |

### Visual Impact:
```
conf = 0.90:  ___■■■___  (narrow CI - 90% coverage)
conf = 0.95:  __■■■■■__  (medium CI - 95% coverage)
conf = 0.99:  _■■■■■■■_  (wide CI - 99% coverage)
```

### Statistical Interpretation:
- **95% CI**: If we repeated study 100 times, ~95 would contain true value
- **90% CI**: More likely to reject null (more power, less conservative)
- **99% CI**: Less likely to reject null (less power, more conservative)

### When to Change:

**Use 0.90 when**:
- Exploratory analysis
- Want narrower bands for clarity
- Less critical decisions

**Use 0.95 when**: ⭐ **MOST COMMON**
- Standard scientific reporting
- Publication requirements
- Balanced approach

**Use 0.99 when**:
- Critical management decisions
- Need very high certainty
- Regulatory requirements

### In Ördin:
- Default 0.95 (95%) matches publication standard
- Adjust in 0.01 increments
- Shown in plot subtitle

---

## 5️⃣ Data Type (datatype) - **RAREFACTION METHOD**

### In Ördin UI:
**Location**: Sidebar → "Data Type"  
**Type**: Select dropdown  
**Options**: "Abundance (counts)" or "Incidence (presence/absence)"

### Parameter Details:
```r
datatype = "abundance"   # Individual-based rarefaction
datatype = "incidence"   # Incidence-based rarefaction
```

### Options Explained:

#### datatype = "abundance"
- **Rarefaction unit**: Number of individuals
- **X-axis**: Sample size (individuals)
- **Formula**: Individual-based Coleman rarefaction
- **Data format**: Counts of organisms
- **Example**: "15 beetles, 23 ants, 8 spiders"

#### datatype = "incidence" (or "incidence_freq")
- **Rarefaction unit**: Number of sampling units
- **X-axis**: Sample size (sampling units)
- **Formula**: Incidence-based rarefaction
- **Data format**: Detection frequencies
- **Example**: "Species A found in 35 of 50 trap-days"

### See Also:
- [`INCIDENCE-VS-ABUNDANCE.md`](../INCIDENCE-VS-ABUNDANCE.md) for detailed comparison
- [`ESTIMATES-AND-RAREFACTION-TYPES.md`](../ESTIMATES-AND-RAREFACTION-TYPES.md) for theory

---

## 6️⃣ Standard Error Display (se) - **SHADED vs LINE CI**

### In Ördin Code (Fixed):
```r
se = TRUE  # Show confidence intervals as SHADED areas
```

### What It Does:
- `se = TRUE`: Confidence intervals shown as **shaded ribbons** ✅ (DEFAULT)
- `se = FALSE`: No confidence intervals displayed

### Visual Difference:

#### se = TRUE (Shaded - CORRECT):
```
      ┌────────────────┐
Species│    ▓▓▓▓▓▓▓     │  ← Shaded area = 95% CI
      │   ▓▓▓▓▓▓▓▓▓    │
      │  ▓▓▓▓▓▓▓▓▓▓▓   │
      └────────────────┘
         Sample Size
```

#### se = FALSE (No CI):
```
      ┌────────────────┐
Species│    ───────     │  ← Only point estimates
      │                │
      └────────────────┘
         Sample Size
```

### Why Shaded is Better:
✅ Easier to see overlap between sites  
✅ Standard in ecological literature  
✅ Visually clearer uncertainty  
✅ Matches iNEXT documentation examples  

### In Ördin:
- **Fixed to `se = TRUE`** for shaded confidence intervals
- Matches official iNEXT visualization style
- Cannot be turned off (always show CI for scientific rigor)

---

## 📈 ggiNEXT Plotting Parameters

### Function Signature:
```r
ggiNEXT(x, type, se, facet.var, color.var, grey)
```

---

## 7️⃣ Plot Type (type) - **VISUALIZATION MODE**

### In Ördin UI:
**Location**: Sidebar → "Rarefaction Plot Type"  
**Type**: Select dropdown

### Parameter Details:
```r
type = 1  # Sample-size-based rarefaction/extrapolation
type = 2  # Sample completeness curve  
type = 3  # Coverage-based rarefaction/extrapolation
```

### Type 1: Sample-Size-Based ⭐ **MOST COMMON**
```r
ggiNEXT(x, type = 1)
```
- **X-axis**: Sample size (individuals or sampling units)
- **Y-axis**: Diversity (Hill numbers)
- **Shows**: Classic rarefaction/extrapolation curves
- **Use for**: Standard diversity comparison

**Plot appearance**:
```
Diversity
    ↑
 40 │     ╱────── Site A (extrapolation)
    │    ╱▓▓▓▓
 30 │   ╱▓▓▓▓
    │  ╱▓▓
 20 │ ╱▓ (rarefaction)
    │╱
  0 └──────────────────→ Sample Size
    0   100   200   300
```

### Type 2: Sample Completeness
```r
ggiNEXT(x, type = 2)
```
- **X-axis**: Sample size
- **Y-axis**: Sample coverage (0 to 1)
- **Shows**: How complete your inventory is
- **Use for**: Quality control, planning

**Plot appearance**:
```
Coverage
    ↑
1.0 │        ────────── Asymptote
    │      ╱▓▓▓▓
0.8 │    ╱▓▓▓▓
    │   ╱▓▓
0.6 │ ╱▓▓
    │╱
0.0 └──────────────────→ Sample Size
    0   100   200   300
```

**Interpretation**:
- Coverage = 1.0: Perfect (100% of species found)
- Coverage = 0.9: Excellent (90% of species found)
- Coverage = 0.7: Good (70% of species found)
- Coverage < 0.5: Poor (need more sampling)

### Type 3: Coverage-Based ⭐ **BEST FOR COMPARISON**
```r
ggiNEXT(x, type = 3)
```
- **X-axis**: Sample coverage (standardized completeness)
- **Y-axis**: Diversity (Hill numbers)
- **Shows**: Diversity at equal sampling completeness
- **Use for**: Fair comparison across very different sample sizes

**Plot appearance**:
```
Diversity
    ↑
 40 │         Site A ────
    │        ╱▓▓▓▓
 30 │       ╱▓▓▓▓
    │  Site B ▓▓
 20 │     ╱▓▓
    │    ╱
  0 └──────────────────→ Coverage
   0.5  0.6  0.7  0.8  0.9  1.0
```

**Why it's better**:
✅ Compares at **equal effort** (not sample size)  
✅ Fair even with 100 vs 1000 individuals  
✅ Recommended for publication  

---

## 8️⃣ Faceting (facet.var) - **PANEL LAYOUT**

### In Ördin Code (Currently Fixed):
```r
facet.var = "None"  # Single combined panel
```

### Available Options:

#### facet.var = "None"
- **Layout**: All curves in one panel
- **Best for**: Comparing sites directly
- **Current Ördin default**: ✅

```
┌─────────────────────────────┐
│  Site A ▓▓▓▓                │
│  Site B ▒▒▒▒                │
│  Site C ░░░░                │
│  (q=0, 1, 2 all together)   │
└─────────────────────────────┘
```

#### facet.var = "Order.q"
- **Layout**: Separate panel for each q value
- **Best for**: Focusing on one diversity order at a time

```
┌───── q=0 ─────┬───── q=1 ─────┬───── q=2 ─────┐
│ Site A ▓▓▓▓   │ Site A ▓▓▓▓   │ Site A ▓▓▓▓   │
│ Site B ▒▒▒▒   │ Site B ▒▒▒▒   │ Site B ▒▒▒▒   │
└───────────────┴───────────────┴───────────────┘
```

#### facet.var = "Assemblage"
- **Layout**: Separate panel for each site
- **Best for**: Examining individual sites

```
┌─── Site A ────┬─── Site B ────┬─── Site C ────┐
│ q=0 ▓▓▓▓      │ q=0 ▒▒▒▒      │ q=0 ░░░░      │
│ q=1 ▓▓▓       │ q=1 ▒▒▒       │ q=1 ░░░░      │
│ q=2 ▓▓        │ q=2 ▒▒        │ q=2 ░░        │
└───────────────┴───────────────┴───────────────┘
```

#### facet.var = "Both"
- **Layout**: Grid of q × sites
- **Best for**: Detailed comparison (many panels!)

```
┌─ Site A, q=0 ─┬─ Site B, q=0 ─┬─ Site C, q=0 ─┐
│ ▓▓▓▓          │ ▒▒▒▒          │ ░░░░          │
├─ Site A, q=1 ─┼─ Site B, q=1 ─┼─ Site C, q=1 ─┤
│ ▓▓▓           │ ▒▒▒           │ ░░░           │
├─ Site A, q=2 ─┼─ Site B, q=2 ─┼─ Site C, q=2 ─┤
│ ▓▓            │ ▒▒            │ ░░            │
└───────────────┴───────────────┴───────────────┘
```

### Future Enhancement:
Could add UI option to select `facet.var` for customizable layouts.

---

## 9️⃣ Color Variable (color.var) - **CURVE COLORS**

### In Ördin Code (Currently Fixed):
```r
color.var = "Assemblage"  # Color by site
```

### Available Options:

#### color.var = "Assemblage"
- **Colors represent**: Different sites/assemblages
- **Best for**: Comparing sites
- **Current Ördin default**: ✅

```
Legend:
█ Site A
█ Site B  
█ Site C
```

#### color.var = "Order.q"
- **Colors represent**: Different Hill numbers (q values)
- **Best for**: Comparing diversity orders

```
Legend:
█ q=0 (Richness)
█ q=1 (Shannon)
█ q=2 (Simpson)
```

### Visual Impact:

**color.var = "Assemblage"**:
- Each site gets unique color
- Easy to track one site across all q values
- Best when comparing: "Is Forest richer than Grassland?"

**color.var = "Order.q"**:
- Each q value gets unique color  
- Easy to compare richness vs diversity  
- Best when comparing: "Does richness differ more than evenness?"

---

## 🎨 Complete Example: All Parameters

### Full iNEXT Call with All Options:
```r
inext_result <- iNEXT(
  x = data,                  # Your data (sites as columns)
  q = c(0, 1, 2),           # Hill numbers: richness, Shannon, Simpson
  datatype = "abundance",    # Individual-based rarefaction
  size = NULL,              # Auto-determine sample sizes (default)
  endpoint = NULL,          # Auto-determine extrapolation endpoint
  knots = 40,               # 40 interpolation points (smooth curves)
  se = TRUE,                # Calculate standard errors (for CI)
  conf = 0.95,              # 95% confidence intervals
  nboot = 50                # 50 bootstrap replicates
)

# Plot with all options
plot <- ggiNEXT(
  x = inext_result,         # iNEXT object
  type = 1,                 # Sample-size-based plot
  se = TRUE,                # Show shaded confidence intervals ✅
  facet.var = "None",       # Single panel
  color.var = "Assemblage", # Color by site
  grey = FALSE              # Use colors (not greyscale)
)
```

---

## 📊 Parameter Recommendations by Use Case

### 🔬 Quick Exploration
```r
q = c(0)              # Just richness
knots = 20            # Fast
nboot = 30            # Quick CI
conf = 0.95           # Standard
```

### 📄 Publication Quality
```r
q = c(0, 1, 2)        # All diversity orders
knots = 60            # Smooth curves
nboot = 200           # Accurate CI
conf = 0.95           # Standard
type = 3              # Coverage-based for fairness
```

### 🎯 Management/Conservation
```r
q = c(0, 2)           # Richness + evenness
knots = 40            # Standard
nboot = 100           # Good CI
conf = 0.99           # Conservative (99%)
```

### 📊 Teaching/Presentation
```r
q = c(0, 1, 2)        # Show all three
knots = 80            # Very smooth
nboot = 50            # Reasonable
facet.var = "Order.q" # Separate panels for clarity
```

---

## 🚀 Quick Reference Table

| Parameter | Default | Range | Impact | When to Change |
|-----------|---------|-------|--------|----------------|
| **q** | 0,1,2 | Any ≥0 | Diversity measure | Always show all three |
| **knots** | 40 | 10-200 | Curve smoothness | Increase for publication |
| **nboot** | 50 | 10-500 | CI accuracy | 200+ for papers |
| **conf** | 0.95 | 0.8-0.99 | CI width | 0.99 for conservation |
| **type** | 1 | 1-3 | Plot type | Type 3 for fairness |
| **datatype** | abundance | - | Rarefaction method | Match your data |
| **se** | TRUE | T/F | Show CI | Always TRUE |

---

## 📚 Further Reading

### Official iNEXT Documentation:
- **CRAN**: https://cran.r-project.org/package=iNEXT
- **Vignette**: https://cran.r-project.org/web/packages/iNEXT/vignettes/Introduction.html
- **GitHub**: https://github.com/JohnsonHsieh/iNEXT

### Key Papers:
1. **Hsieh et al. (2016)**: iNEXT package methodology
2. **Chao et al. (2014)**: Rarefaction with Hill numbers
3. **Chao & Jost (2012)**: Coverage-based rarefaction

### In This Repository:
- [`ESTIMATES-AND-RAREFACTION-TYPES.md`](../ESTIMATES-AND-RAREFACTION-TYPES.md)
- [`docs/RAREFACTION-QUICK-GUIDE.md`](RAREFACTION-QUICK-GUIDE.md)
- [`INCIDENCE-VS-ABUNDANCE.md`](../INCIDENCE-VS-ABUNDANCE.md)

---

## 💡 Pro Tips

1. **Always use se = TRUE** - Shaded CI are standard in ecology
2. **Start with knots = 40** - Good balance of speed/smoothness
3. **Use nboot ≥ 200 for papers** - Reviewers expect accurate CI
4. **Type 3 for unequal sampling** - Coverage-based is fairest
5. **Show all q values** - Reveals different diversity patterns
6. **Check Type 2 first** - Ensure coverage > 70% before interpreting
7. **conf = 0.95 is standard** - Don't change unless required
8. **Color by Assemblage** - Easier to compare sites

---

**Now you have complete control over iNEXT in Ördin!** 🎛️📊✨
