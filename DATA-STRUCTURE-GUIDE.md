# 📊 Ördin v3.0 - Data Structure Guide

**Author:** Jimmy Moses (jmoses@pnguot.ac.pg)  
**Date:** 2025-10-25  
**Version:** 3.0

---

## 🎯 Overview

Ördin v3.0 supports **two separate datasets** for comprehensive ecological analysis:

1. **Species Composition Data** (Required)
2. **Environmental Data** (Optional)

Both datasets use the **same site identifiers** in the first column, allowing Ördin to match and integrate them for advanced analyses.

---

## 📋 Species Composition Data

### **Structure**

**Required Format:**
- **First Column:** Site names (sites/traps/transects/plots)
- **Remaining Columns:** Species abundance or presence/absence data

### **Example CSV**

```csv
Site,Species1,Species2,Species3,Species4,Species5
Plot_A,12,5,0,3,8
Plot_B,8,12,2,0,15
Plot_C,0,3,18,5,2
Trap_1,25,8,3,12,0
Trap_2,15,20,0,8,6
```

### **Example Excel**

| Site   | Betula | Quercus | Pinus | Alnus | Salix |
|--------|--------|---------|-------|-------|-------|
| Site_1 | 15     | 8       | 12    | 3     | 0     |
| Site_2 | 22     | 15      | 8     | 6     | 4     |
| Site_3 | 8      | 25      | 0     | 12    | 9     |

### **Data Types Supported**

1. **Abundance Data**
   - Count data (number of individuals)
   - Biomass data
   - Coverage percentages
   - Example: 12, 5, 18, 0, 3

2. **Presence/Absence Data**
   - Binary (0/1) or (FALSE/TRUE)
   - Example: 1, 0, 1, 1, 0

### **Column Names**

- **Site Column:** Can be named anything (Site, Plot, Trap, Transect, Location, etc.)
- **Species Columns:** Use your actual species names
  - ✅ Scientific names: *Betula_pendula*, *Quercus_robur*
  - ✅ Common names: Oak, Pine, Birch
  - ✅ Codes: Sp1, Sp2, BEPE, QURO

### **Requirements**

✅ **Must have:**
- At least 2 sites (rows)
- At least 2 species (columns)
- Numeric values only (no text in species columns)
- Unique site names in first column

❌ **Avoid:**
- Missing site names
- Duplicate site names
- Text values in species columns (except column headers)
- Completely empty rows or columns

---

## 🌍 Environmental Data

### **Structure**

**Optional Format:**
- **First Column:** Site names (MUST match species data exactly)
- **Remaining Columns:** Environmental variables

### **Example CSV**

```csv
Site,pH,Temperature,Moisture,Elevation,Canopy_Cover
Plot_A,6.5,22.3,45.2,125,65
Plot_B,7.2,21.8,52.1,110,72
Plot_C,5.8,23.1,38.5,145,55
Trap_1,6.8,22.7,48.3,130,68
Trap_2,7.0,21.5,50.2,115,70
```

### **Example Excel**

| Site   | pH  | Temp | Nitrogen | Phosphorus | Soil_Type |
|--------|-----|------|----------|------------|-----------|
| Site_1 | 6.5 | 22.3 | 0.15     | 0.08       | Sandy     |
| Site_2 | 7.2 | 21.8 | 0.22     | 0.12       | Clay      |
| Site_3 | 5.8 | 23.1 | 0.18     | 0.10       | Loam      |

### **Variable Types**

1. **Continuous Variables**
   - pH, temperature, moisture
   - Nutrient concentrations
   - Elevation, slope
   - Example: 6.5, 22.3, 45.2

2. **Categorical Variables**
   - Soil type, land use, vegetation type
   - Should be converted to factors in R
   - Example: "Sandy", "Clay", "Loam"

### **Requirements**

✅ **Must have:**
- Site names matching species data exactly
- At least 1 environmental variable
- Values appropriate for variable type

❌ **Avoid:**
- Sites not in species data (will be ignored with warning)
- Missing values (handle separately)
- Different site name spelling/capitalization

### **Site Name Matching**

**CRITICAL:** Site names must match **exactly** between datasets.

✅ **Correct:**
```
Species Data: Plot_A, Plot_B, Plot_C
Env Data:     Plot_A, Plot_B, Plot_C
```

❌ **Incorrect (won't match):**
```
Species Data: Plot_A,  Plot_B,  Plot_C
Env Data:     plot_a,  Plot B,  PlotC
              ^^^^^    ^^^^^    ^^^^^
              case     space    no underscore
```

---

## 📤 How to Upload Data

### **Method 1: Upload Your Files**

1. Navigate to **Data** tab
2. **Species Composition:**
   - Click "Upload Species Data (CSV or Excel)"
   - Select your file (must have site names in first column)
   - Click "Open"
3. **Environmental Data (Optional):**
   - Click "Upload Environmental Data (CSV or Excel)"
   - Select your file (site names must match species data)
   - Click "Open"

### **Method 2: Use Sample Datasets**

Ördin includes sample datasets from the `vegan` package:

| Dataset | Species Data | Environmental Data | Description |
|---------|--------------|-------------------|-------------|
| **Dune Meadow** | dune (20×30) | dune.env (5 vars) | Dutch dune meadow vegetation |
| **Varespec** | varespec (24×44) | varechem (14 vars) | Understory vegetation in dry heath |
| **BCI** | BCI (50×225) | None | Barro Colorado Island tree counts |

**To load:**
1. Select dataset from dropdown
2. Click "▶ Load Sample Data"
3. Both species and environmental data load automatically (if available)

---

## 🔍 Data Preview Tabs

After loading, review your data using three tabs:

### **1. Species Composition**
- Shows site names + species columns
- Site names highlighted in green
- Scrollable table

### **2. Environmental Variables**
- Shows site names + environmental columns
- Only appears if environmental data loaded
- Site names highlighted in green

### **3. Data Summary**
- Number of sites and species
- Total abundance
- Mean species richness
- Environmental variables (if loaded)
- Note about constrained ordination availability

---

## 🔬 Which Analyses Use Which Data?

### **Species Data Only**

These analyses use **only species composition**:

✅ **Diversity:**
- iNEXT rarefaction/extrapolation
- Diversity indices (Shannon, Simpson, etc.)

✅ **Unconstrained Ordination:**
- NMDS
- PCA
- CA
- DCA
- PCoA

### **Species + Environmental Data**

These analyses can use **both datasets**:

🔄 **Constrained Ordination:** (Future v3.1+)
- RDA (Redundancy Analysis)
- CCA (Canonical Correspondence Analysis)
- db-RDA (Distance-based RDA)

🔄 **Environmental Fitting:** (Future v3.1+)
- envfit (fit environmental vectors/factors)
- Variable importance tests

🔄 **Statistical Tests:** (Future v3.1+)
- PERMANOVA with environmental factors
- Mantel tests (species vs environment)

---

## ⚠️ Common Issues & Solutions

### **Issue: "Some columns are not numeric"**

**Problem:** Species data contains text values

**Solution:**
- Check species columns for text
- Remove or replace with numeric codes
- Ensure only column headers have text

---

### **Issue: "Sites missing in environmental data"**

**Problem:** Environmental data doesn't have all sites from species data

**Solution:**
- Add missing sites to environmental file
- Or remove those sites from species data
- Ensure exact name matching

---

### **Issue: Data not appearing in preview**

**Problem:** File format or structure incorrect

**Solution:**
- Check first column contains site names
- Verify file is CSV or Excel format
- Ensure no empty rows at top
- Save Excel as .xlsx or .xls (not .xlsb)

---

### **Issue: "Error loading file"**

**Problem:** File corrupted or invalid format

**Solution:**
- Re-save file in proper format
- Check file opens in Excel/text editor
- Remove special characters from site names
- Ensure UTF-8 encoding

---

## 📝 Best Practices

### **1. Site Naming**

✅ **Good:**
- Plot_01, Plot_02, Plot_03
- Site_A, Site_B, Site_C
- Trap_1, Trap_2, Trap_3
- Transect_North, Transect_South

❌ **Avoid:**
- Spaces in names (use underscores)
- Special characters: #, @, %, $
- Starting with numbers only: 1, 2, 3
- Very long names (keep under 20 chars)

---

### **2. Species Naming**

✅ **Good:**
- Scientific: Betula_pendula, Quercus_robur
- Codes: BEPE, QURO, PISY
- Common: Oak, Pine, Birch

❌ **Avoid:**
- Spaces (use underscores)
- Special characters in names
- Duplicate species names
- Empty column names

---

### **3. Data Organization**

✅ **Do:**
- Keep raw data backup
- Document variable units (pH, °C, %, m)
- Use consistent decimal separator
- Remove completely empty rows/columns

❌ **Don't:**
- Mix abundance and presence/absence
- Use different units for same variable
- Include summary rows (totals, means)
- Merge multiple datasets without checking

---

### **4. File Naming**

✅ **Good:**
- species_data_2025.csv
- environmental_vars_site1.xlsx
- dune_species.csv / dune_environment.csv

❌ **Avoid:**
- Generic names: data.csv, file.xlsx
- Special characters in filename
- Very long filenames
- Spaces in filenames

---

## 📊 Example Workflow

### **Typical Analysis Workflow:**

1. **Prepare Files**
   ```
   species_data.csv:
   Site,Sp1,Sp2,Sp3,...
   Plot1,12,5,0,...
   Plot2,8,15,2,...
   
   environment_data.csv:
   Site,pH,Temp,Moisture,...
   Plot1,6.5,22.3,45.2,...
   Plot2,7.2,21.8,52.1,...
   ```

2. **Upload to Ördin**
   - Load species data first
   - Verify in preview
   - Load environmental data
   - Check Data Summary tab

3. **Run Analyses**
   - Start with diversity (iNEXT, indices)
   - Then unconstrained ordination (NMDS, PCA)
   - Future: constrained ordination (RDA, CCA)

4. **Export Results**
   - Download plots (PNG)
   - Download tables (CSV)
   - Generate reports (PDF)

---

## 🎓 Learning Resources

### **Sample Data Templates**

Located in: `ordin/data/templates/`

- `species_template.csv` - Empty species data template
- `environment_template.csv` - Empty environmental template
- `example_species.csv` - Filled example
- `example_environment.csv` - Filled example

### **Real Dataset Examples**

Using sample datasets:

**Dune Meadow:**
- 20 sites in Dutch dune meadows
- 30 plant species
- 5 environmental variables (A1, Moisture, Management, Use, Manure)
- Good for beginners

**Varespec:**
- 24 sites in pine forests
- 44 understory species
- 14 soil chemistry variables
- Good for environmental fitting

**BCI:**
- 50 1-hectare plots
- 225 tree species
- No environmental data
- Good for large diversity analyses

---

## 🔧 Technical Details

### **Data Structure in R**

After loading, data is stored as:

```r
# Species composition
community_data()  # data.frame with:
                  # - rownames = site names
                  # - columns = species
                  # - values = abundance

# Environmental variables
environmental_data()  # data.frame with:
                      # - rownames = site names (matching community_data)
                      # - columns = environmental variables
                      # - values = measurements
```

### **Automatic Processing**

Ördin automatically:
1. ✅ Sets first column as row names
2. ✅ Validates numeric data in species columns
3. ✅ Matches environmental sites to species sites
4. ✅ Reorders environmental data to match species data
5. ✅ Warns about missing or mismatched sites

---

## 📚 Citation

When using Ördin for your research, please cite:

```
Moses, J. (2025). Ördin v3.0: An open-source community ecology analysis platform. 
University of Technology, Papua New Guinea. https://github.com/jimmoses/ordin
```

---

**Questions or Issues?**

- 📧 Email: jmoses@pnguot.ac.pg
- 🐛 Report bugs: GitHub Issues
- 📖 Documentation: `/docs` folder
- 💬 Community: GitHub Discussions

---

**Last Updated:** 2025-10-25  
**Ördin Version:** 3.0  
**Author:** Jimmy Moses
