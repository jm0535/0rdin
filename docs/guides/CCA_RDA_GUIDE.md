# Constrained Ordination Guide (CCA & RDA)

## Overview
**Canonical Correspondence Analysis (CCA)** and **Redundancy Analysis (RDA)** are constrained ordination methods that relate species composition to environmental variables. These methods are now available in Ördin v3.0!

## What's New
- ✅ **CCA** added to Ordination method dropdown
- ✅ **RDA** added to Ordination method dropdown
- ✅ Automatic environment data integration
- ✅ Clear error messages when environment data is missing

## When to Use Which Method

### CCA (Canonical Correspondence Analysis)
**Best for:**
- **Unimodal species responses** (species have optimal values along gradients)
- Community data with **long environmental gradients**
- Data with many zeros (typical ecological data)

**Example use cases:**
- Plant communities along elevation gradients
- Aquatic communities responding to nutrient levels
- Species distributions along temperature gradients

### RDA (Redundancy Analysis)
**Best for:**
- **Linear species responses** to environmental variables
- Community data with **short environmental gradients**
- Data that is relatively homogeneous

**Example use cases:**
- Short-term experimental manipulations
- Communities in relatively uniform environments
- When environmental effects are expected to be linear

## How to Perform Constrained Ordination in Ördin

### Step 1: Prepare Your Data

You need **TWO datasets**:

#### 1. Species Composition Data (`sample_data_species.csv`)
```
Site,Species1,Species2,Species3,...
Site_1,5,2,0,...
Site_2,3,1,4,...
Site_3,0,8,2,...
```

#### 2. Environment Data (`sample_data_environment.csv`)
```
Site,A1,Moisture,Management,Use,Manure
Site_1,2.8,1,SF,Haypastu,4
Site_2,3.5,1,BF,Haypastu,2
Site_3,4.3,2,SF,Haypastu,4
```

**Important:** Both datasets must have the **same site names** in the first column!

### Step 2: Load Data in Ördin

1. **Open the Data tab** (2nd tab with database icon)

2. **Load Species Data:**
   - Go to "Import" sub-tab
   - Click "Browse" under "Species Data"
   - Select `sample_data_species.csv`
   - You'll see: "✓ Data loaded: 20 rows × 31 columns"

3. **Load Environment Data:**
   - In the same Import section
   - Click "Browse" under "Environment Data" 
   - Select `sample_data_environment.csv`
   - You'll see: "✓ Environment data loaded: 20 rows × 6 columns"

4. **Verify Data:**
   - Switch to "Edit" sub-tab
   - Toggle between "Species Data" and "Environment Data" tabs
   - Check that site names match

### Step 3: Run Constrained Ordination

1. **Navigate to Ordination tab** (4th tab with project-diagram icon)

2. **Configure Settings:**
   - **Method:** Select "CCA" or "RDA"
   - **Dimensions:** Keep at 2 (default)
   - **Distance:** Not used for CCA/RDA (only for NMDS/PCoA)

3. **Run Analysis:**
   - Click the green "Run Ordination" button
   - Wait for the professional loading spinner
   - Results will display automatically

### Step 4: Interpret Results

The ordination plot will show:
- **Site positions** in ordination space
- **Axes** representing environmental gradients
- **Site labels** for identification

## Error Messages

### "CCA requires environment data"
**Problem:** You selected CCA but haven't loaded environment data.

**Solution:**
1. Go to Data tab
2. Import environment data using the file browser
3. Return to Ordination tab and run again

### "RDA requires environment data"
**Problem:** You selected RDA but haven't loaded environment data.

**Solution:** Same as above - load environment data first.

## Sample Data for Testing

Use the provided sample datasets:
- **Species:** `sample_data_species.csv` (20 sites × 30 species)
- **Environment:** `sample_data_environment.csv` (20 sites × 5 variables)

These are real ecological data from dune meadow vegetation studies (vegan package).

## Environmental Variables in Sample Data

1. **A1** - Soil thickness (continuous, numeric)
2. **Moisture** - Moisture level (ordinal, 1-5)
3. **Management** - Farming type (categorical: BF, HF, NM, SF)
4. **Use** - Land use (categorical: Hayfield, Haypastu, Pasture)
5. **Manure** - Manure application (ordinal, 0-4)

## Technical Details

### Implementation
- Uses **vegan** package functions: `cca()` and `rda()`
- Formula: `species ~ .` (all environmental variables as predictors)
- Automatically extracts site scores for plotting
- Supports 2D visualization (can be extended to 3D)

### Data Requirements
- Species and environment datasets must have matching site names
- Sites must be in the same order (Ördin handles this automatically)
- Environment variables can be numeric, ordinal, or categorical
- Missing values should be avoided

## Tips for Best Results

1. **Choose the right method:**
   - Long gradients (> 4 SD units)? Use CCA
   - Short gradients (< 3 SD units)? Use RDA
   - Unsure? Try both and compare

2. **Check your environment data:**
   - Remove highly correlated variables (r > 0.7)
   - Consider standardizing continuous variables
   - Use meaningful variable names

3. **Interpretation:**
   - Sites close together have similar species composition
   - Distance from origin indicates environmental extremes
   - Axis 1 typically explains the most variation

## References

**Canonical Correspondence Analysis:**
- ter Braak, C.J.F. (1986). Canonical Correspondence Analysis: A New Eigenvector Technique for Multivariate Direct Gradient Analysis. *Ecology* 67: 1167-1179.

**Redundancy Analysis:**
- Legendre, P. & Legendre, L. (2012). *Numerical Ecology*, 3rd edition. Elsevier.

**vegan Package:**
- Oksanen, J., et al. (2024). vegan: Community Ecology Package. R package version 2.6-8.

## Next Steps

After running CCA/RDA:
1. Download the ordination plot (PNG/TIFF/SVG)
2. Download site scores as CSV for further analysis
3. Export results to Excel or JSON format
4. Try other ordination methods for comparison (NMDS, DCA)

---

**Note:** For unconstrained ordination (no environmental predictors), use PCA, CA, DCA, NMDS, or PCoA instead.

**Author:** Jimmy Moses  
**Application:** Ördin v3.0  
**Date:** 2025
