# Troubleshooting: Ciliates Data Not Processing

**Issue**: Ciliates data (even with 300 species) not being analyzed  
**Status**: Debugging  
**Date**: 2025-10-23

---

## 🔍 **Diagnostic Steps**

### **Step 1: Check What Ördin Sees**

When you load your ciliates data, Ördin now prints diagnostics to the **R console**:

```
=== ÖRDIN DATA LOADING ===
File loaded: ciliates-300species.csv
Rows (sites): 3
Columns (species): 300
Is binary (0/1 only): TRUE
Sample of first 5 values: 0, 0, 0, 0, 0
Row totals: 45, 52, 38
============================
```

**What to check**:
- ✅ **Is binary: TRUE** - Good! Detected as incidence_raw
- ✅ **Row totals** - How many occurrences per site?
- ❌ If row totals are < 3, **this is the problem**!

---

### **Step 2: Check Validation Diagnostics**

After clicking "Run Analysis", you'll see:

```
=== ÖRDIN DATA DIAGNOSTICS ===
Data format detected: incidence_raw
Actual datatype for iNEXT: incidence_raw
Number of sites: 3
Number of species: 300
Total per site: 45, 52, 38
Min sample size: 38
Species with >0: 135
Data sparsity: 85.0%
============================
```

**What to check**:
- ✅ **Min sample size ≥ 3** - Required for incidence_raw
- ✅ **Species with >0 ≥ 3** - Need at least 3 species
- ⚠️ **Data sparsity** - If > 95%, might be too sparse

**You'll also see a notification**:
```
Data loaded: 3 sites, 300 species
Format: incidence_raw | Min occurrences: 38 | Species present: 135
```

---

## ❌ **Common Failure Reasons**

### **Reason 1: Insufficient Occurrences Per Site**

**Error Message**:
```
Insufficient data: At least one site has only 2 occurrences. 
Need at least 3 occurrences per site.

Your data: 3 sites, 300 species
Totals per site: 2, 5, 8
```

**What happened**: One site only has 2 species present (0, 0, 1, 0, 1, 0, ...)

**Solution**:
```r
# Check your data - count 1s per row
Site1: sum of 1s = 2  ← TOO FEW!
Site2: sum of 1s = 5  ✓
Site3: sum of 1s = 8  ✓
```

**Fix**: 
- Combine sites
- Remove site with too few occurrences
- Add more sampling to that site

---

### **Reason 2: Too Few Species Detected**

**Error Message**:
```
Insufficient diversity: Only 2 species detected. 
Need at least 3 species.

Your data has 300 species columns, but only 2 have at least one occurrence.
```

**What happened**: 298 out of 300 species are **all zeros** (never occurred)

**Solution**:
```r
# Remove species columns that are all zeros
# Keep only species that occur at least once
```

**How to fix in R**:
```r
# Load data
d <- read.csv("ciliates-300.csv", row.names = 1)

# Check how many species have at least one occurrence
species_present <- colSums(d) > 0
cat("Species with occurrences:", sum(species_present), "\n")

# Keep only species that occur
d_filtered <- d[, species_present]
cat("Species after filtering:", ncol(d_filtered), "\n")

# Save
write.csv(d_filtered, "ciliates-filtered.csv", row.names = TRUE)
```

---

### **Reason 3: Data Still Too Sparse**

Even with 300 species, if 95%+ are zeros:

**What happens**:
- iNEXT tries to fit rarefaction curves
- Not enough data points
- Curves fail to generate

**Check sparsity**:
```r
d <- read.csv("ciliates-300.csv", row.names = 1)
total_cells <- nrow(d) * ncol(d)
zero_cells <- sum(d == 0)
sparsity <- (zero_cells / total_cells) * 100
cat("Sparsity:", round(sparsity, 1), "%\n")
```

**Guidelines**:
- < 85% sparse: ✅ Good
- 85-95% sparse: ⚠️ May work, might have issues
- > 95% sparse: ❌ Likely to fail

**Solution**:
```r
# Filter to keep only species in at least 2 sites
d_filtered <- d[, colSums(d > 0) >= 2]
```

---

## 🔧 **Quick Fixes**

### **Fix 1: Filter Empty Species**

```r
# Remove species columns with all zeros
d <- read.csv("ciliates-300.csv", row.names = 1)
d_clean <- d[, colSums(d) > 0]
write.csv(d_clean, "ciliates-clean.csv", row.names = TRUE)
```

---

### **Fix 2: Filter Rare Species**

```r
# Keep only species in at least 2 sites
d <- read.csv("ciliates-300.csv", row.names = 1)
d_common <- d[, colSums(d > 0) >= 2]
write.csv(d_common, "ciliates-common.csv", row.names = TRUE)
```

---

### **Fix 3: Combine Sites**

If you have 3 desert sites that are similar:

```r
d <- read.csv("ciliates-300.csv", row.names = 1)

# Combine CentralNamibDesert and SouthernNamibDesert
combined <- data.frame(
  EtoshaPan = d["EtoshaPan", ],
  DesertCombined = pmax(d["CentralNamibDesert", ], d["SouthernNamibDesert", ])
)

# pmax() takes maximum (so if either site has 1, result is 1)
d_combined <- as.data.frame(t(combined))
write.csv(d_combined, "ciliates-combined.csv", row.names = TRUE)
```

---

### **Fix 4: Use Lower Parameters**

If data is borderline sparse, reduce computational load:

**In Ördin UI**:
```
Knots: 20 (instead of 40)
Bootstrap: 20 (instead of 50)
Hill numbers: Select only q=0
```

This makes iNEXT more forgiving of sparse data.

---

## 📊 **Interpreting Diagnostics**

### **Good Data Example**:
```
=== ÖRDIN DATA DIAGNOSTICS ===
Data format detected: incidence_raw
Number of sites: 3
Number of species: 120
Total per site: 45, 52, 38
Min sample size: 38  ✓
Species with >0: 95  ✓
Data sparsity: 73.6%  ✓
============================
```
✅ All checks pass → Should work!

---

### **Problem Data Example**:
```
=== ÖRDIN DATA DIAGNOSTICS ===
Data format detected: incidence_raw
Number of sites: 3
Number of species: 300
Total per site: 2, 3, 1  ← PROBLEM!
Min sample size: 1  ❌
Species with >0: 6  ← Only 6 out of 300!
Data sparsity: 99.3%  ❌ Too sparse!
============================
```
❌ Multiple problems → Won't work without filtering

---

## 🎯 **Recommended Workflow**

### **Step 1: Upload and Check**
1. Load your ciliates-300.csv
2. Look at R console output
3. Check row totals and species present

### **Step 2: If Issues, Filter in R**
```r
d <- read.csv("ciliates-300.csv", row.names = 1)

# Filter 1: Remove all-zero species
d <- d[, colSums(d) > 0]

# Filter 2: Keep species in ≥2 sites
d <- d[, colSums(d > 0) >= 2]

# Filter 3: Check sparsity
cat("Sparsity:", round(sum(d==0)/length(d)*100, 1), "%\n")

# Save
write.csv(d, "ciliates-filtered.csv", row.names = TRUE)
```

### **Step 3: Reload in Ördin**
1. Upload ciliates-filtered.csv
2. Check diagnostics again
3. Should work now!

---

## 💡 **Why This Happens**

### **Original Ciliates Data**:
- 6,935 species columns
- 99.7% sparse
- Metabarcoding/eDNA output
- Huge species pool, few actual detections

### **After Filtering to 300**:
- Still mostly zeros if wrong 300 species kept
- Need to keep **species that actually occur**
- Not just first 300 columns!

### **Correct Filtering**:
```r
# WRONG: Just take first 300 columns
d_wrong <- d[, 1:300]  # Might all be zeros!

# RIGHT: Take 300 most common species
species_counts <- colSums(d > 0)  # Count occurrences
top_species <- order(species_counts, decreasing = TRUE)[1:300]
d_right <- d[, top_species]  # Species that actually occur
```

---

## 🧪 **Testing Your Filtered Data**

### **Quick R Test**:
```r
d <- read.csv("your-file.csv", row.names = 1)

cat("\n=== DATA CHECK ===\n")
cat("Sites:", nrow(d), "\n")
cat("Species:", ncol(d), "\n")
cat("Occurrences per site:", paste(rowSums(d), collapse=", "), "\n")
cat("Species with ≥1 occurrence:", sum(colSums(d) > 0), "\n")
cat("Sparsity:", round(sum(d==0)/length(d)*100, 1), "%\n")

# Should see:
# Sites: 3
# Species: 50-150 (after filtering)
# Occurrences per site: 30, 45, 38 (all ≥3)
# Species with ≥1: 50-150 (all species occur)
# Sparsity: 70-85% (acceptable)
```

---

## ✅ **Expected Diagnostic Output (Working)**

```
=== ÖRDIN DATA LOADING ===
File loaded: ciliates-filtered.csv
Rows (sites): 3
Columns (species): 85
Is binary (0/1 only): TRUE
Sample of first 5 values: 0, 1, 1, 0, 1
Row totals: 42, 48, 35
============================

=== ÖRDIN DATA DIAGNOSTICS ===
Data format detected: incidence_raw
Actual datatype for iNEXT: incidence_raw
Number of sites: 3
Number of species: 85
Total per site: 42, 48, 35
Min sample size: 35
Species with >0: 85
Data sparsity: 72.5%
============================

🟢 Notification: Data loaded: 3 sites, 85 species
Format: incidence_raw | Min occurrences: 35 | Species present: 85

✅ Analysis proceeds!
```

---

## 📞 **Still Not Working?**

Share the diagnostic output:
1. Copy the console output (=== ÖRDIN DATA LOADING ===)
2. Copy the validation error message
3. Check: How many 1s per row in your CSV?

**Most likely issue**: Not enough occurrences (1s) per site after filtering to 300 species.

**Solution**: Filter to keep **common** species, not just any 300 species!
