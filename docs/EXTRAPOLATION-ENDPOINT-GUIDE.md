# Extrapolation Endpoint Control in Ördin

**Feature**: Control where rarefaction curves extrapolate to for fair site comparisons  
**Parameter**: `endpoint` in iNEXT analysis  
**Status**: ✅ Implemented  
**Date**: 2025-10-23

---

## 🎯 What is the Extrapolation Endpoint?

### The Problem

When comparing biodiversity across sites with **different sampling efforts**, rarefaction curves end at different points:

```
Site A: 100 individuals collected → Curve ends at 100
Site B: 500 individuals collected → Curve ends at 500
```

**Challenge**: How do we compare diversity when sites have different sample sizes?

### The Solution: Endpoint Control

The **endpoint** parameter tells iNEXT where to **extrapolate all curves to**, enabling fair comparisons:

```
Set endpoint = 1000 individuals

Site A: Extrapolates from 100 → 1000 (predicted)
Site B: Extrapolates from 500 → 1000 (predicted)
```

Now both curves reach the **same point**, making diversity comparable!

---

## 🔧 How to Use in Ördin

### Location in UI

**Sidebar → iNEXT Advanced Options → Extrapolation Control**

```
Extrapolation Endpoint: [___]
```

### Two Modes

#### **Mode 1: Auto (Default)**
- **Input**: Leave blank (NULL)
- **Behavior**: iNEXT extrapolates to **2× the reference sample size**
- **Reference sample**: The **largest** sample across all sites
- **Use when**: Standard exploratory analysis

**Example**:
```
Site A: 100 individuals
Site B: 500 individuals (largest)

Auto endpoint = 500 × 2 = 1000 individuals
```

#### **Mode 2: Custom Endpoint**
- **Input**: Enter a specific number (e.g., 1500)
- **Behavior**: All curves extrapolate to exactly **1500** individuals/units
- **Use when**: 
  - Comparing across studies
  - Publication figures requiring specific scales
  - Testing diversity at specific sampling levels

**Example**:
```
Set endpoint = 2000

Site A: 100 → 2000 (20× extrapolation)
Site B: 500 → 2000 (4× extrapolation)
```

---

## 📊 Units Depend on Data Type

The endpoint value means **different things** for different data types:

| Data Format | Endpoint Unit | Example |
|-------------|---------------|---------|
| **Abundance** | Individuals | "1000 individuals" |
| **Incidence_raw** | Sampling units | "50 quadrats" |
| **Incidence_freq** | Sampling units | "100 traps" |

### Examples

**Abundance data** (spider counts):
```
Endpoint = 1000
→ "Extrapolate to 1000 individuals"
```

**Incidence_freq data** (ant traps):
```
Endpoint = 500
→ "Extrapolate to 500 sampling units (traps)"
```

**Incidence_raw data** (presence/absence):
```
Endpoint = 80
→ "Extrapolate to 80 sampling units"
```

---

## ⚙️ Technical Implementation

### iNEXT Function Call

```r
# Auto mode (default)
iNEXT(x = data, endpoint = NULL)  # Uses 2× reference sample

# Custom endpoint
iNEXT(x = data, endpoint = 1500)  # All curves → 1500
```

### In Ördin Code

```r
# User input (NULL if blank)
endpoint_value <- if (is.null(input$endpoint) || is.na(input$endpoint)) {
  NULL  # Auto: 2× reference sample
} else {
  input$endpoint  # Custom value
}

# Pass to iNEXT
iNEXT(
  x = inext_data,
  endpoint = endpoint_value,
  ...
)
```

### Display in Plot Subtitle

```r
endpoint_text <- if (is.null(endpoint_value)) {
  "auto (2× reference)"
} else {
  paste0(endpoint_value, " ", unit_type)
}

subtitle <- paste0(..., " | Endpoint: ", endpoint_text)
```

**Result**:
```
Subtitle: "... | Endpoint: auto (2× reference)"
Subtitle: "... | Endpoint: 1500 individuals"
```

---

## 🎓 When to Use Custom Endpoint

### ✅ Use Custom Endpoint When:

1. **Cross-study comparison**
   - You want to compare with published data at specific sample size
   - Example: "Compare our site with Smith et al. (2020) at 1000 individuals"

2. **Standardized reporting**
   - Institution/journal requires specific extrapolation level
   - Example: "All sites must be compared at 500 sampling units"

3. **Testing specific hypotheses**
   - You want to know diversity at particular sampling effort
   - Example: "What would diversity be with 200 more individuals?"

4. **Publication figures**
   - Need consistent scale across multiple studies
   - Makes visual comparison easier

5. **Highly unequal sampling**
   - One site has 10 individuals, another has 1000
   - Auto (2× largest = 2000) might over-extrapolate small sites
   - Set custom endpoint between the extremes (e.g., 500)

### ❌ Don't Use Custom Endpoint When:

1. **Exploratory analysis** → Use auto
2. **Similar sample sizes** → Auto works fine
3. **Don't know what value to use** → Start with auto
4. **First time analyzing data** → Use auto first

---

## 📐 Choosing the Right Endpoint Value

### Guidelines

**Rule 1: Beyond observed data**
```
Endpoint > largest observed sample size
```
✅ Good: Largest site = 500, endpoint = 800  
❌ Bad: Largest site = 500, endpoint = 300 (cuts off data!)

**Rule 2: Not too extreme**
```
Avoid extrapolating > 3-5× beyond observed data
```
✅ Good: Observed = 100, endpoint = 400 (4× extrapolation)  
❌ Risky: Observed = 100, endpoint = 2000 (20× extrapolation)

**Rule 3: Consider smallest site**
```
Check confidence intervals at endpoint
```
If smallest site has huge CI at endpoint → reduce endpoint

### Recommended Workflow

1. **First run**: Use **auto** (blank)
   - See default extrapolation
   - Check where curves end

2. **Check reference sample**:
   - Note the largest sample size
   - Auto endpoint = 2× this value

3. **Decide if custom needed**:
   - Are sites reasonably similar? → Keep auto
   - Need specific comparison point? → Set custom

4. **Set custom value**:
   - Rule of thumb: 1.5-3× median sample size
   - Check all sites have reasonable CI

---

## 🔍 Interpreting Results

### Rarefaction vs Extrapolation

Curves have two parts:

1. **Rarefaction** (solid line):
   - Based on **actual data**
   - Interpolating within observed samples
   - Highly reliable

2. **Extrapolation** (dashed line):
   - Based on **prediction**
   - Beyond observed samples
   - Reliability decreases with distance

**Endpoint** controls where extrapolation stops!

### Confidence Intervals

```
Wide CI at endpoint = Less reliable prediction
Narrow CI at endpoint = More reliable prediction
```

**At endpoint, check**:
- Do CIs still overlap?
- Are CIs reasonable width?
- Which site has highest predicted diversity?

---

## 📖 Example Scenarios

### Scenario 1: Spider Abundance Study

**Data**:
```
Forest A: 45 individuals
Forest B: 89 individuals
Grassland: 123 individuals (largest)
```

**Auto endpoint**: 123 × 2 = **246 individuals**

**Custom option**: Set to **150** for moderate extrapolation

**Comparison**:
```
Auto (246):
- Grassland: 123 → 246 (2× extrapolation)
- Forest B: 89 → 246 (2.8× extrapolation)  
- Forest A: 45 → 246 (5.5× extrapolation) ⚠️ Very wide CI

Custom (150):
- Grassland: 123 → 150 (1.2× extrapolation)
- Forest B: 89 → 150 (1.7× extrapolation)
- Forest A: 45 → 150 (3.3× extrapolation) ✓ Reasonable CI
```

**Decision**: Custom endpoint = 150 gives more reliable comparison

---

### Scenario 2: Ant Incidence Study

**Data** (sampling units):
```
Site h50m: 599 traps
Site h500m: 230 traps
Site h1070m: 150 traps
```

**Auto endpoint**: 599 × 2 = **1198 traps**

**Problem**: Small sites (150) → 1198 is **8× extrapolation**! CI will be huge.

**Custom option**: Set to **400 traps**

**Comparison**:
```
Auto (1198):
- h50m: 599 → 1198 (2× extrapolation) ✓
- h500m: 230 → 1198 (5.2× extrapolation) ⚠️
- h1070m: 150 → 1198 (8× extrapolation) ❌ Unreliable

Custom (400):
- h50m: 599 → 400 (actually rarefies down!)
- h500m: 230 → 400 (1.7× extrapolation) ✓
- h1070m: 150 → 400 (2.7× extrapolation) ✓
```

**Decision**: Custom endpoint = 400 balances all sites

---

## ⚠️ Important Notes

### Extrapolation Limitations

1. **Not magic**: Can't predict species you didn't sample
2. **Model-based**: Assumes community follows certain patterns
3. **Less reliable** than rarefaction
4. **Wide CI = Uncertain**: Pay attention to confidence intervals

### Best Practices

✅ **Do**:
- Start with auto endpoint
- Check CI width at endpoint
- Use moderate extrapolation (2-3×)
- Report endpoint in publications
- Compare sites at same endpoint

❌ **Don't**:
- Extrapolate > 5× observed data
- Ignore wide confidence intervals
- Use arbitrary endpoint values
- Forget to document endpoint choice
- Compare sites at different endpoints

---

## 📚 References

### iNEXT Documentation
- [iNEXT package manual](https://cran.r-project.org/web/packages/iNEXT/iNEXT.pdf)
- See `endpoint` parameter description

### Key Papers
- Chao et al. (2014) "Rarefaction and extrapolation with Hill numbers" - *Ecology*
- Hsieh et al. (2016) "iNEXT: an R package for rarefaction and extrapolation" - *Methods in Ecology and Evolution*

---

## 🎯 Quick Reference

### Default Behavior (Blank Input)
```
endpoint = NULL → Auto (2× reference sample)
```

### Custom Endpoint
```
endpoint = 1500 → All curves extrapolate to 1500
```

### Units
```
Abundance → individuals
Incidence_raw → sampling units
Incidence_freq → sampling units
```

### Recommendations
```
Conservative: 1.5-2× median sample size
Moderate: 2-3× median sample size
Aggressive: 3-5× median sample size (check CI!)
```

---

## ✅ Summary

**Extrapolation endpoint control** allows you to:
- ✅ Compare sites with different sampling efforts
- ✅ Standardize diversity estimates
- ✅ Control extrapolation distance
- ✅ Improve cross-study comparisons
- ✅ Create publication-ready figures

**In Ördin**: Simply enter a number in "Extrapolation Endpoint" or leave blank for auto!
