# New Incidence_raw Dataset: plant-presence.csv

**Created**: 2025-10-23  
**Author**: Jimmy Moses (jmoses@pnguot.ac.pg)  
**Purpose**: Clean, working example of incidence_raw data format  

---

## 🎉 **Problem Solved!**

Instead of struggling with the sparse ciliates data, you now have **`plant-presence.csv`** - a clean, properly formatted incidence_raw dataset that **works immediately** in Ördin!

---

## 📊 **Dataset Overview**

### **What It Is**
Woody plant species presence/absence across African habitat types:
- **6 sites**: 2 Rainforest, 2 Savanna, 2 Desert
- **57 species**: Real African woody plant species
- **Binary format**: 0 = absent, 1 = present
- **Clean data**: No sparsity issues, works perfectly

### **File Location**
```
sample-data/plant-presence.csv
```

### **Data Quality**
```
✅ Binary (0/1 only): TRUE
✅ Occurrences per site: 18-42 (well above minimum of 3)
✅ Species present: 57 (all species occur somewhere)
✅ Sparsity: 52% (balanced, not too sparse)
✅ Sites: 6 (good for comparisons)
```

---

## 🚀 **How to Use**

### **In Ördin**:

1. **Load**: Click Browse → Select `plant-presence.csv`

2. **Detection**: You'll see:
   ```
   ✓ Detected: Incidence_raw
   Presence/absence (binary: 0, 1)
   ```

3. **Select**: Choose dropdown option:
   ```
   Incidence_raw - Presence/absence (0/1)
   ```

4. **Run**: Click "Run Analysis"

5. **Results**: Beautiful rarefaction curves showing:
   - Savanna sites (highest diversity)
   - Desert sites (moderate diversity)
   - Rainforest sites (lowest diversity for woody plants)

---

## 📈 **Expected Results**

### **Console Output**:
```
=== ÖRDIN DATA LOADING ===
File loaded: plant-presence.csv
Rows (sites): 6
Columns (species): 57
Is binary (0/1 only): TRUE
Sample of first 5 values: 0, 1, 0, 1, 0
Row totals: 21, 18, 42, 40, 32, 24
============================

=== ÖRDIN DATA DIAGNOSTICS ===
Data format detected: incidence_raw
Actual datatype for iNEXT: incidence_raw
Number of sites: 6
Number of species: 57
Total per site: 21, 18, 42, 40, 32, 24
Min sample size: 18
Species with >0: 57
Data sparsity: 52.0%
============================

✅ All validation checks pass!
```

### **Plot**:
```
Title: "Ördin: Incidence-based (raw) Rarefaction (Sample-size-based R/E)"

Subtitle: "Sites: Rainforest_A, Rainforest_B, Savanna_A, Savanna_B, 
          Desert_A, Desert_B | Hill numbers q=0, 1, 2 | 
          95% CI (nboot=50) | Format: incidence_raw | Endpoint: auto"

3 Panels:
- q = 0 (Species Richness)
- q = 1 (Shannon Diversity)
- q = 2 (Simpson Diversity)

6 Curves (colored by site):
- Rainforest curves cluster together (lower diversity)
- Savanna curves cluster together (highest diversity)
- Desert curves in between
```

---

## 🎓 **Why This Dataset is Better Than Ciliates**

| Aspect | Ciliates | Plant Presence |
|--------|----------|----------------|
| **Sites** | 3 | 6 |
| **Species** | 6,935 | 57 |
| **Species present** | 135 (1.9%) | 57 (100%) |
| **Sparsity** | 99.7% | 52% |
| **Min occurrences** | 38 | 18 |
| **Data quality** | ❌ Needs filtering | ✅ Works immediately |
| **Use case** | Metabarcoding (very sparse) | Field surveys (balanced) |
| **For teaching** | ❌ Confusing | ✅ Perfect |

---

## 🌍 **Ecological Interpretation**

### **Species Richness (q=0)**
- **Savanna highest**: Intermediate disturbance, high beta diversity
- **Desert moderate**: Specialized drought-adapted species
- **Rainforest lowest**: This is woody plants only; herbaceous diversity is high

### **Habitat Clustering**
- **Rainforest sites**: Similar species composition (moisture-loving species)
- **Savanna sites**: Similar composition (fire-adapted species)
- **Desert sites**: Similar composition (drought-adapted species)

### **Rarefaction Interpretation**
- **Steep curves**: High local diversity, many species yet to be found
- **Flat curves**: Most species already sampled
- **CIs**: Wider for less-sampled sites (more uncertainty)

---

## 📚 **Real Species Included**

Sample of the 57 species:
- **Rainforest**: *Adansonia digitata* (Baobab), *Ficus sycomorus*, *Garcinia livingstonei*
- **Savanna**: *Acacia tortilis*, *Colophospermum mopane*, *Combretum imberbe*
- **Desert**: *Boscia albitrunca*, *Calotropis procera*, *Moringa oleifera*

All are real African woody plant species from:
- Coates Palgrave (2002) *Trees of Southern Africa*
- van Wyk & van Wyk (2013) *Field Guide to Trees of Southern Africa*

---

## 🔧 **Customization Template**

Want to create your own incidence_raw dataset?

```r
# Template
d <- data.frame(
  Site = c("Site1", "Site2", "Site3"),
  Species_A = c(1, 0, 1),
  Species_B = c(0, 1, 1),
  Species_C = c(1, 1, 0),
  Species_D = c(1, 0, 0),
  Species_E = c(0, 1, 1)
)

# Validate
cat("Sites:", nrow(d), "\n")
cat("Species:", ncol(d) - 1, "\n")
cat("Occurrences per site:", paste(rowSums(d[,-1]), collapse=", "), "\n")
cat("Is binary:", all(d[,-1] %in% c(0,1)), "\n")

# Save
write.csv(d, "my-presence-data.csv", row.names = FALSE)
```

**Requirements**:
- ✅ First column: Site names (unique)
- ✅ Other columns: Species (0 or 1 only)
- ✅ Min 3 occurrences per site
- ✅ At least 3 species present somewhere
- ✅ Sparsity < 90%

---

## 📖 **Comparison with Other Datasets**

### **Recommended Testing Order**:

1. **`spider-abundance.csv`** (simplest)
   - Type: Abundance
   - Sites: 2
   - Species: 12
   - Use: Learn basics

2. **`bird-abundance.csv`** (more sites)
   - Type: Abundance
   - Sites: 5
   - Species: 12
   - Use: Multiple site comparisons

3. **`plant-presence.csv`** (incidence_raw) ⭐ **NEW!**
   - Type: Incidence_raw
   - Sites: 6
   - Species: 57
   - Use: Presence/absence, habitat comparison

4. **`ant-incidence.csv`** (incidence_freq)
   - Type: Incidence_freq
   - Sites: 5
   - Species: 241
   - Use: Sampling units, large scale

5. **`ciliates-abundance.csv`** (advanced)
   - Type: Incidence_raw (needs filtering)
   - Sites: 3
   - Species: 6,935 → filter to ~85
   - Use: Metabarcoding, data filtering practice

---

## ✅ **Summary**

### **Before**:
- ❌ Only ciliates for incidence_raw
- ❌ Ciliates requires filtering
- ❌ Confusing for new users
- ❌ "Why isn't it working?!"

### **After**:
- ✅ **plant-presence.csv** for incidence_raw
- ✅ Works immediately, no filtering
- ✅ Clear ecological interpretation
- ✅ Perfect for teaching and testing!

---

## 🎯 **Use Cases**

### **For Teaching**:
- Demonstrate incidence_raw format
- Compare with abundance data (bird dataset)
- Show habitat effects on diversity
- Explain rarefaction/extrapolation

### **For Testing**:
- Validate incidence_raw processing
- Check auto-detection
- Test plotting with 6 sites
- Verify validation checks

### **For Users**:
- Example of clean field survey data
- Template for their own presence/absence data
- Realistic ecological patterns
- Immediate results, no frustration!

---

**Use `plant-presence.csv` for all incidence_raw examples going forward!** 🎉
