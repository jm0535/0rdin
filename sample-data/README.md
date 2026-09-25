# Sample Biodiversity Datasets for Ördin

This folder contains example datasets for testing Ördin's biodiversity analysis features.

---

## 🎟️ Datasets Included

### 1. example-biodiversity.csv
**Custom test dataset**  
- 9 sites across 3 habitat types (Forest, Grassland, Wetland)
- 7 species (Species_A through Species_G)
- Perfect for quick testing

### 2. spider-abundance.csv
**Spider communities from iNEXT package**  
- Source: Sackett et al. (2011)
- Girdled vs. logged forest plots in Barro Colorado Island, Panama
- Real-world ecological data
- Excellent for diversity estimation

### 3. bird-abundance.csv
**Bird communities from iNEXT package**  
- Source: Chao et al. (2014)
- Bird species abundance data
- Multiple sampling sites
- Great for rarefaction curves

### 4. plant-presence.csv
**Woody plant presence/absence data**  
- Source: Example incidence_raw dataset
- African woody plant species across habitat types
- 6 sites (Rainforest, Savanna, Desert)
- 57 species
- **Clean incidence_raw format** (binary 0/1)
- Perfect for testing incidence-based diversity
- **Use this for incidence_raw examples** (works immediately!)

### 5. ciliates-incidence-raw.csv
**Soil ciliates (after Chao et al. 2015)**  
- 3 southern-African sites × 300 species
- **incidence_raw** format (binary 0/1)
- Sparse — a good stress test for incidence-based estimation
- Background: [`../docs/TROUBLESHOOTING-CILIATES.md`](../docs/TROUBLESHOOTING-CILIATES.md)

### 6. dune_species.csv + dune_environment.csv
**The classic `vegan` dune-meadow dataset**  
- 20 sites × 30 species, plus 5 environmental variables
- Ideal for ordination (PCA/CA/NMDS), constrained ordination and PERMANOVA
- Also loadable directly from the Data panel ("Load sample → dune")

### 7. sample_data_species.csv + sample_data_environment.csv
**Generic paired species/environment example**  
- Same layout as the dune pair; useful for testing imports

### 8. ant-incidence-freq.csv
**Ant species incidence data from iNEXT package**  
- Source: iNEXT package example data
- **Incidence-frequency format** (presence/absence data)
- First data column: Number of sampling units
- Remaining columns: Species incidence frequencies
- Use with "Incidence (presence/absence)" data type in Ördin

---

## 📊 Data Formats

### Abundance Data (Counts)

Most CSV files use this structure:

```csv
Site,Species_A,Species_B,Species_C,...
Site_1,15,23,8,...
Site_2,18,19,12,...
```

- **First column**: Site/sample names (text)
- **Remaining columns**: Species abundances (integers)
- **Rows**: Different sampling sites or assemblages
- **Columns**: Different species

### Incidence Data (Presence/Absence)

Incidence-frequency data (e.g., ant-incidence-freq.csv):

```csv
Site,SamplingUnits,Species_A,Species_B,Species_C,...
Site_1,50,35,12,48,...
Site_2,30,18,8,22,...
```

- **First column**: Site/sample names (text)
- **Second column**: Number of sampling units (e.g., trap-days, quadrats)
- **Remaining columns**: Species incidence frequencies (how many times detected)
- **Use case**: Presence/absence data, trap studies, occurrence records

---

## 🧪 How to Use in Ördin

### iNEXT Analysis (Diversity Estimation)

#### For Abundance Data:
1. Open Ördin (web app, desktop build, or `npm run dev`)
2. **Data (1)** panel → *Import* → choose e.g. `spider-abundance.csv`
3. Confirm the detected data type is **abundance**
4. **Diversity (2)** panel → set `q = 0, 1, 2` → *Run*

#### For Incidence Data:
1. Import `ant-incidence-freq.csv` (incidence_freq) or
   `plant-presence.csv` / `ciliates-incidence-raw.csv` (incidence_raw)
2. Set the data type accordingly in the Diversity panel
3. *Run* — curves and asymptotic estimates appear with bootstrap CIs

**Results you'll see:**
- Diversity indices table (q=0, 1, 2)
- Rarefaction/extrapolation curves
- Confidence intervals
- Download options (CSV, PNG)

### NMDS Ordination (Community Similarity)

1. Keep the same species table loaded (add `dune_environment.csv` for biplots)
2. **Ordination (4)** panel → method **NMDS**, distance **Bray-Curtis**, `k = 2`
3. *Run* — check the stress value and the `REAL vegan::metaMDS via webR` badge

**Results you'll see:**
- NMDS plot showing site similarity
- Stress value (< 0.1 is excellent)
- Sites closer together = more similar communities

---

## 📖 Dataset Details

### example-biodiversity.csv
```
Sites: 9
Species: 7
Habitats: Forest (3), Grassland (3), Wetland (3)
Purpose: Quick testing, demonstration
```

### spider-abundance.csv
```
Sites: 2 (Girdled, Logged)
Species: Spider species from tropical forest
Study: Girdled vs. logged forest comparison
Purpose: Real ecological research data
```

### bird-abundance.csv
```
Sites: Multiple bird survey sites
Species: Various bird species
Purpose: Standard biodiversity analysis example
```

### ciliates-incidence-raw.csv
```
Sites: Soil sampling locations
Species: Ciliate protist species
Purpose: High diversity, complex communities
```

### ant-incidence-freq.csv
```
Sites: 5
Species: 241 ant species
Format: Incidence-frequency (first column = sampling units)
Study: Ant community occurrence data
Purpose: Demonstrate incidence-based diversity analysis
```

---

## 🧠 Analysis Tips

### iNEXT Analysis
- **Rarefaction curves**: Show observed diversity
- **Extrapolation**: Predict diversity with more sampling
- **q = 0**: Species richness (number of species)
- **q = 1**: Shannon diversity (common species)
- **q = 2**: Simpson diversity (dominant species)

### NMDS Ordination
- **Stress < 0.05**: Excellent representation
- **Stress 0.05-0.1**: Good representation
- **Stress 0.1-0.2**: Acceptable (some distortion)
- **Stress > 0.2**: Poor fit - try fewer dimensions

---

## 📥 Creating Your Own Data

### Abundance Data

1. **Create a CSV file** with:
   - First column: Site names
   - Other columns: Species (one per column)
   - Values: Abundance counts (integers)

2. **Format requirements**:
   - Use commas as separators
   - No blank cells (use 0 for absent species)
   - Column headers for all species
   - At least 2 sites, 2 species

3. **Example structure**:
```csv
Site,Sp1,Sp2,Sp3,Sp4
Plot_A,10,5,0,3
Plot_B,8,12,2,1
Plot_C,15,3,5,7
```

4. **Upload to Ördin** and select "Abundance (counts)" as data type!

### Incidence Data

1. **Create a CSV file** with:
   - First column: Site names
   - Second column: Sampling units (e.g., number of traps, days)
   - Other columns: Species incidence frequencies
   - Values: How many times each species was detected

2. **Example structure**:
```csv
Site,SamplingUnits,Sp1,Sp2,Sp3,Sp4
Site_A,50,35,12,8,45
Site_B,30,18,5,3,22
Site_C,40,28,9,6,35
```

3. **Upload to Ördin** and select "Incidence (presence/absence)" as data type!

---

## 📚 References

- Chao, A. et al. (2014). Rarefaction and extrapolation with Hill numbers.
- Chao, A. et al. (2015). Unveiling the species-rank abundance distribution.
- Sackett, T.E. et al. (2011). Spider community structure in Barro Colorado Island.
- iNEXT R package: https://github.com/JohnsonHsieh/iNEXT

---

## ✨ Tips for Best Results

1. **Use real data**: The iNEXT datasets are actual research data
2. **Compare habitats**: Use the example data to see how forests vs. grasslands differ
3. **Check stress values**: Lower is better for NMDS
4. **Download results**: Save tables and plots for your reports
5. **Try both analyses**: iNEXT + NMDS give complementary insights

---

**Ready to explore!** Upload any dataset and start analyzing biodiversity with Ördin! 🌿📊

## Data Format

The CSV file should have the following structure:
- **First column**: Site names (text)
- **Remaining columns**: Species abundances (numeric values)

Example:

```csv
Site,Species_A,Species_B,Species_C,Species_D,Species_E
Forest_Plot_1,15,23,8,12,5
Forest_Plot_2,18,19,12,9,7
Grassland_1,5,45,2,1,0
Grassland_2,7,38,3,2,1
Wetland_1,22,8,15,18,11
Wetland_2,19,10,14,16,9
```

## Sample Data

You can create a sample CSV file with this data to test Ördin:

| Site | Species_A | Species_B | Species_C | Species_D | Species_E | Species_F | Species_G |
|------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
| Forest_Plot_1 | 15 | 23 | 8 | 12 | 5 | 18 | 9 |
| Forest_Plot_2 | 18 | 19 | 12 | 9 | 7 | 15 | 11 |
| Forest_Plot_3 | 12 | 25 | 10 | 14 | 6 | 20 | 8 |
| Grassland_1 | 5 | 45 | 2 | 1 | 0 | 3 | 1 |
| Grassland_2 | 7 | 38 | 3 | 2 | 1 | 4 | 2 |
| Grassland_3 | 6 | 42 | 1 | 1 | 0 | 2 | 1 |
| Wetland_1 | 22 | 8 | 15 | 18 | 11 | 5 | 14 |
| Wetland_2 | 19 | 10 | 14 | 16 | 9 | 6 | 12 |
| Wetland_3 | 20 | 9 | 16 | 17 | 10 | 7 | 13 |

## Analysis Tips

### iNEXT Analysis (Diversity Estimation)
- Upload the CSV file
- Select "Diversity Estimation (iNEXT)"
- Click "Run Analysis"
- View rarefaction/extrapolation curves
- Download summary tables showing diversity indices (q=0: species richness, q=1: Shannon diversity, q=2: Simpson diversity)

### NMDS Ordination
- Upload the CSV file
- Select "Ordination (NMDS via vegan)"
- Choose number of dimensions (2 is recommended for visualization)
- Click "Run Analysis"
- Examine stress value (< 0.1 is good, < 0.2 is acceptable)
- Sites closer together in the plot have similar species compositions

## Creating Your Own Data

To use your own biodiversity data:

1. Create a CSV file with site names in the first column
2. Add species as columns (one column per species)
3. Enter abundance counts (integers) for each species at each site
4. Save as .csv format
5. Upload to Ördin

**Note**: Missing values should be entered as 0 (zero), not left blank.
