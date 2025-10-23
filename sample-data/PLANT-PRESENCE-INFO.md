# Plant Presence Dataset - Incidence_raw Example

**Filename**: `plant-presence.csv`  
**Data Type**: **Incidence_raw** (Presence/Absence)  
**Format**: Binary (0 = absent, 1 = present)  
**Author**: Jimmy Moses (jmoses@pnguot.ac.pg)  
**Date**: 2025-10-23

---

## 📊 Dataset Description

### **Study System**
Woody plant species presence/absence across different African habitat types.

### **Sampling Method**
- Visual surveys for tree/shrub presence
- Multiple transects per site
- Species recorded as present (1) or absent (0)
- No abundance counts

### **Sites** (6 total)
1. **Rainforest_A** - Tropical rainforest, high rainfall
2. **Rainforest_B** - Tropical rainforest, high rainfall
3. **Savanna_A** - Woodland savanna, seasonal rainfall
4. **Savanna_B** - Woodland savanna, seasonal rainfall
5. **Desert_A** - Arid shrubland, low rainfall
6. **Desert_B** - Arid shrubland, low rainfall

### **Species** (57 total)
Woody plant species common in African ecosystems:
- **Rainforest specialists**: *Adansonia digitata*, *Ficus sycomorus*, *Garcinia livingstonei*
- **Savanna species**: *Acacia tortilis*, *Colophospermum mopane*, *Combretum imberbe*
- **Desert-adapted**: *Boscia albitrunca*, *Calotropis procera*, *Moringa oleifera*

---

## 📐 Data Structure

### **Format**
```csv
Site,Species_1,Species_2,Species_3,...
Rainforest_A,0,1,0,...
Savanna_A,1,0,1,...
```

### **Data Summary**
```
Sites (rows): 6
Species (columns): 57
Data type: Binary (0/1)
Sparsity: ~52% (balanced)
```

### **Occurrences per Site**
```
Rainforest_A: 21 species present
Rainforest_B: 18 species present
Savanna_A: 42 species present
Savanna_B: 40 species present
Desert_A: 32 species present
Desert_B: 24 species present
```

---

## 🎯 Perfect for Incidence_raw Analysis

### **Why This Dataset Works**

✅ **Binary data**: All values are 0 or 1  
✅ **Sufficient occurrences**: 18-42 species per site (well above minimum of 3)  
✅ **Good diversity**: All 57 species occur in at least one site  
✅ **Reasonable sparsity**: ~52% zeros (not too sparse)  
✅ **Ecological realism**: Clear habitat differences  
✅ **6 sites**: Enough for meaningful comparisons  

### **Validation Checks**
```
✓ Min occurrences per site: 18 ≥ 3 (PASS)
✓ Species present: 57 ≥ 3 (PASS)
✓ Sparsity: 52% < 90% (GOOD)
✓ Binary format: TRUE (PASS)
```

---

## 🧪 How to Use in Ördin

### **Step 1: Load Data**
1. Open Ördin
2. Click "Browse..." under "Upload Species Data CSV"
3. Select `plant-presence.csv`
4. File loads successfully

### **Step 2: Check Auto-Detection**
You should see:
```
🟠 Detected: Incidence_raw
Presence/absence (binary: 0, 1)
```

### **Step 3: Select Data Type**
In dropdown, select:
```
Incidence_raw - Presence/absence (0/1)
```

### **Step 4: Run Analysis**
1. Keep default parameters or adjust:
   - Hill numbers: q=0, 1, 2 (all selected)
   - Knots: 40
   - Bootstrap: 50
   - Confidence: 0.95
2. Click "Run Analysis"

### **Step 5: View Results**
You should see:
- ✅ 3 panels (q=0, q=1, q=2)
- ✅ 6 colored curves (one per site)
- ✅ Shaded confidence intervals
- ✅ Clear distinction between habitat types

---

## 📊 Expected Results

### **Species Richness (q=0)**
**Predicted pattern**:
- **Savanna** sites: Highest richness (40-42 species)
- **Desert** sites: Moderate richness (24-32 species)
- **Rainforest** sites: Lower richness (18-21 species)

**Why**: Savannas have intermediate disturbance and high beta diversity

### **Shannon Diversity (q=1)**
**Predicted pattern**:
- **Savanna**: High diversity (many species, even abundances)
- **Desert**: Moderate diversity
- **Rainforest**: Lower diversity (fewer species)

### **Simpson Diversity (q=2)**
**Predicted pattern**:
- Similar to Shannon but emphasizes dominant species
- Savanna sites cluster together
- Desert sites show moderate diversity

### **Visual Pattern**
```
Rarefaction curves should show:
- Savanna_A and Savanna_B cluster together (similar)
- Desert_A and Desert_B cluster together
- Rainforest_A and Rainforest_B cluster together
- Clear separation between habitat types
```

---

## 🎓 Educational Value

### **Demonstrates**
1. **Incidence_raw format**: Clean binary presence/absence
2. **Habitat effects**: Different ecosystems have different diversity
3. **Rarefaction**: Comparing sites with different sampling completeness
4. **Beta diversity**: Species turnover between habitats
5. **Confidence intervals**: Uncertainty in diversity estimates

### **Teaching Points**
- **Why rainforests have fewer species here**: This is woody plants only; rainforests have high herbaceous diversity
- **Savanna diversity**: Intermediate disturbance hypothesis
- **Desert adaptations**: Specialist species for arid conditions
- **Presence/absence**: When abundance is hard to measure

---

## 🔬 Scientific Context

### **Real-World Application**
This dataset structure is common in:
- **Vegetation surveys**: Recording tree/shrub presence
- **Rapid biodiversity assessments**: Quick surveys across large areas
- **Camera trap studies**: Species presence/absence per trap
- **Herbarium data**: Historical occurrence records
- **eDNA studies**: Species detection (present/absent)

### **Advantages of Incidence Data**
✅ Faster to collect than abundance  
✅ Less observer bias (presence easier to confirm than count)  
✅ Works for cryptic species  
✅ Standardizes effort across heterogeneous habitats  
✅ Useful for large spatial scales  

---

## 📈 Comparison with Other Sample Datasets

| Dataset | Type | Sites | Species | Use Case |
|---------|------|-------|---------|----------|
| **spider-abundance.csv** | Abundance | 2 | 12 | Individual counts, simple |
| **bird-abundance.csv** | Abundance | 5 | 12 | Individual counts, multiple sites |
| **ant-incidence.csv** | Incidence_freq | 5 | 241 | Sampling units, large scale |
| **ciliates-abundance.csv** | Incidence_raw | 3 | 6935 | Metabarcoding, **too sparse** |
| **plant-presence.csv** | Incidence_raw | 6 | 57 | **Clean, works perfectly!** |

---

## 🎯 Recommended Testing Sequence

### **For New Users**
1. **Start**: `spider-abundance.csv` (simplest)
2. **Then**: `bird-abundance.csv` (more sites)
3. **Then**: **`plant-presence.csv`** (incidence_raw)
4. **Finally**: `ant-incidence.csv` (incidence_freq)

### **For Teaching**
1. **Abundance vs Incidence**: Compare `bird-abundance.csv` vs `plant-presence.csv`
2. **Sample size effects**: Use extrapolation endpoint control
3. **Habitat comparison**: Rainforest vs Savanna vs Desert
4. **Hill numbers**: q=0 (richness) vs q=1 (Shannon) vs q=2 (Simpson)

---

## 🔧 Customization Ideas

### **Modify for Your Study**
```r
# Template for your own incidence data
d <- data.frame(
  Site = c("Site1", "Site2", "Site3"),
  Species_A = c(1, 0, 1),
  Species_B = c(0, 1, 1),
  Species_C = c(1, 1, 0)
  # Add more species columns...
)

# Save
write.csv(d, "my-incidence-data.csv", row.names = FALSE)
```

### **Requirements**
- ✅ First column: Site names (unique)
- ✅ Other columns: Species names (no spaces in column names)
- ✅ Values: Only 0 or 1
- ✅ At least 2 sites
- ✅ At least 3 species with ≥1 occurrence
- ✅ Min 3 occurrences per site

---

## 📚 References

### **African Plant Species**
- Coates Palgrave, K. (2002). *Trees of Southern Africa*. Struik Publishers.
- van Wyk, B. & van Wyk, P. (2013). *Field Guide to Trees of Southern Africa*. Struik Nature.

### **Savanna Ecology**
- Scholes, R.J. & Walker, B.H. (1993). *An African Savanna: Synthesis of the Nylsvley Study*. Cambridge University Press.

### **Diversity Methods**
- Chao, A. et al. (2014). Rarefaction and extrapolation with Hill numbers. *Ecology*, 95: 489-499.

---

## ✅ Summary

**`plant-presence.csv`** is a **perfect example** of **incidence_raw** data:

- ✅ Clean binary format (0/1)
- ✅ Realistic ecological data
- ✅ Sufficient occurrences per site
- ✅ Good species diversity
- ✅ Reasonable sparsity (~52%)
- ✅ Demonstrates habitat effects
- ✅ **Works immediately in Ördin!**

**Use this instead of ciliates for teaching and testing incidence_raw analyses!**

---

**Author**: Jimmy Moses (jmoses@pnguot.ac.pg)  
**Application**: Ördin - Biodiversity Analysis  
**License**: Sample data for educational use
