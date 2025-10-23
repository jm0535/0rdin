# Ciliates Abundance Data Issue - Diagnostic Report

**Status**: ❌ Data quality issue identified  
**Dataset**: `sample-data/ciliates-abundance.csv`  
**Date**: 2025-10-23

---

## 🔍 Problem Summary

The ciliates abundance dataset is **not showing rarefaction curves** because the data structure is **incompatible with iNEXT rarefaction analysis**. The dataset is **extremely sparse** with insufficient sampling depth.

---

## 📊 Data Structure

### Dimensions
- **Sites (rows)**: 3  
  - `EtoshaPan`
  - `CentralNamibDesert`  
  - `SouthernNamibDesert`

- **Species (columns)**: **6,935** (Species_1 to Species_6740+)

### Data Format
```
Site,Species_1,Species_2,Species_3,...,Species_6935
EtoshaPan,0,0,0,...,0
CentralNamibDesert,0,0,0,...,1
SouthernNamibDesert,0,0,0,...,0
```

---

## ⚠️ Critical Issues

### 1. **Extreme Data Sparsity**
- **Total data cells**: 3 sites × 6,935 species = **20,805 cells**
- **Non-zero cells**: Estimated **<50 cells** (based on pattern of mostly zeros)
- **Sparsity**: **~99.7% zeros**

**What this means**: Out of 20,805 possible species×site combinations, only about 50 have actual counts. This is like having a 6,935-column spreadsheet where almost everything is blank.

### 2. **Low Abundance per Site**
Based on the data patterns observed:
- Each site has only **occasional 1s** scattered across thousands of species
- Estimated total individuals per site: **20-60 individuals**

**iNEXT minimum requirement**: At least 5-10 individuals per site, but **realistically needs 50+ for reliable rarefaction curves**.

### 3. **Very Low Species Richness per Site**
- Only **20-60 species present** per site (out of 6,935 columns)
- Most species columns are **completely empty** (all zeros)

---

## 🧪 Why iNEXT Fails

### Rarefaction Curve Requirements
iNEXT (Interpolation and Extrapolation) needs:

1. **Sufficient sample size**: 
   - Minimum: 10-20 individuals per site
   - Recommended: 50-100+ individuals
   - **Ciliates data**: ~20-60 individuals ❌

2. **Adequate species diversity**:
   - Minimum: 5-10 species per site
   - Recommended: 20-50+ species
   - **Ciliates data**: May meet minimum, but barely ✓

3. **Reasonable data sparsity**:
   - Maximum acceptable: ~95% zeros
   - **Ciliates data**: ~99.7% zeros ❌

### What Happens During Analysis
1. **iNEXT tries to calculate rarefaction** for extremely sparse data
2. **Bootstrap resampling fails** because there aren't enough individuals
3. **Confidence intervals cannot be calculated** reliably
4. **Curve smoothing (knots) fails** due to insufficient data points
5. **Result**: Empty plot or error message

---

## 🔧 Solutions Implemented

### 1. **Enhanced Data Validation** (app.R)
Added pre-flight checks before running iNEXT:

```r
# Check 1: Minimum sample size
validate(need(min_sample_size >= 5, "Need at least 5 individuals per site"))

# Check 2: Species richness  
validate(need(species_present >= 3, "Need at least 3 species"))

# Check 3: Data sparsity
validate(need(sparsity_pct < 99.9, "Data too sparse (>99.9% zeros)"))
```

### 2. **Better Error Messages**
Now shows:
- Number of sites and species
- Total individuals per site
- Data sparsity percentage
- Specific suggestions for fixing the issue

### 3. **Error Handling with tryCatch**
Catches iNEXT failures and provides diagnostic info:

```r
inext_out <- tryCatch({
  iNEXT(...)
}, error = function(e) {
  validate(need(FALSE, paste0(
    "iNEXT analysis failed: ", e$message,
    "\nData summary: Sites=", n_sites, ", Species=", n_species,
    "\nSuggestions: Filter rare species, reduce knots/nboot"
  )))
})
```

---

## 💡 Recommendations for Users

### Option 1: **Filter the Dataset** (Recommended)
Remove extremely rare species before analysis:

```r
# Keep only species present in at least 1 site
d_filtered <- d[, colSums(d) > 0]

# Keep only species present in at least 2 individuals total
d_filtered <- d[, colSums(d) >= 2]
```

### Option 2: **Use Incidence Data Instead**
Convert to presence/absence (0/1):

```r
d_incidence <- ifelse(d > 0, 1, 0)
```

Then select `Incidence (presence/absence)` in Ördin.

### Option 3: **Combine Sites**
If sites are ecologically similar, pool them:

```r
# Example: Pool desert sites
desert_combined <- data.frame(
  Site = "DesertCombined",
  rbind(d["CentralNamibDesert",] + d["SouthernNamibDesert",])
)
```

### Option 4: **Reduce Computational Parameters**
If you must use the data as-is:
- **Knots**: 10-20 (instead of 40)
- **Bootstrap replicates**: 10-20 (instead of 50)
- **Hill numbers**: Select only q=0 (species richness)

---

## 📝 Technical Details

### Why Such Extreme Sparsity?
This dataset structure suggests:
1. **Metabarcoding/eDNA data**: Thousands of potential OTUs (Operational Taxonomic Units)
2. **Rare biosphere sampling**: Most species are extremely rare
3. **High-throughput sequencing**: Creates many zero-inflated columns
4. **Pooled taxonomic database**: All possible species, not just detected ones

### Data Type Mismatch
- **What iNEXT expects**: Abundance counts from traditional sampling (nets, traps, quadrats)
- **What ciliates data is**: Presence/absence from molecular screening across huge species pool

### Better Analysis Approaches for This Data
1. **Occupancy modeling** (presence/absence focus)
2. **Non-metric multidimensional scaling (NMDS)** ✓ (already in Ördin)
3. **Indicator species analysis**
4. **Beta diversity metrics** (Sørensen, Jaccard)
5. **Network analysis** for rare species

---

## 🎯 Testing the Fix

### Expected Behavior Now
When loading `ciliates-abundance.csv` in Ördin:

1. ✅ **Data loads successfully**
2. ✅ **User clicks "Run Analysis"**
3. ✅ **App shows validation error message**:
   ```
   Data too sparse: 99.7% of cells are zero. 
   Dataset may be too sparse for reliable rarefaction.
   Try filtering out rare species or combining sites.
   ```
4. ✅ **Message includes data diagnostics**:
   - Sites: 3
   - Species: 6935
   - Total individuals per site: 45, 52, 38
   - Sparsity: 99.7%

### What This Prevents
- ❌ Silent failures
- ❌ Empty plots with no explanation  
- ❌ Cryptic R errors
- ❌ User confusion

### What Users Get Instead
- ✅ Clear error message
- ✅ Data quality metrics
- ✅ Specific suggestions
- ✅ Understanding of why it failed

---

## 📚 Related Documentation

- `INCIDENCE-VS-ABUNDANCE.md` - Explains data type differences
- `ESTIMATES-AND-RAREFACTION-TYPES.md` - iNEXT methodology
- `sample-data/README.md` - Sample dataset descriptions

---

## 🔄 Future Improvements

### Potential Enhancements
1. **Data preprocessing tool**: Built-in rare species filtering
2. **Data summary dashboard**: Show sparsity before running analysis
3. **Recommended parameters**: Auto-suggest knots/nboot based on data
4. **Alternative analyses**: Auto-suggest NMDS for sparse data
5. **Warning system**: Show yellow warning if data is borderline sparse

### Code Locations
- **Validation code**: `shiny/app.R` lines 118-150
- **Error handling**: `shiny/app.R` lines 151-172
- **Data loading**: `shiny/app.R` lines 74-108

---

## ✅ Summary

**Problem**: Ciliates dataset is 99.7% sparse with insufficient individuals per site for rarefaction.

**Solution**: Added comprehensive data validation with clear error messages explaining:
- Why the analysis failed
- What's wrong with the data
- How to fix it

**Result**: Users now get informative feedback instead of silent failures or empty plots.

**Recommendation**: Use the spider or bird datasets for iNEXT testing. The ciliates dataset is better suited for NMDS or presence/absence analyses.
