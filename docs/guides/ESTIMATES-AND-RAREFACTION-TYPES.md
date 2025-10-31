# EstimateS Software and Rarefaction Types in Ördin

## 📊 What is EstimateS?

**EstimateS** is a free, widely-used biodiversity analysis software developed by Robert K. Colwell (University of Connecticut). It's considered the gold standard for computing species richness estimators and rarefaction curves.

### Key Features of EstimateS:
- **Sample-based rarefaction** curves
- **Individual-based rarefaction** curves  
- **Incidence-based rarefaction** curves
- Multiple diversity estimators (Chao1, Chao2, ACE, ICE, Jack1, Jack2, Bootstrap)
- Species accumulation curves
- Bootstrap confidence intervals

### Why EstimateS is Important:
EstimateS pioneered standardized methods for comparing biodiversity across studies with different sampling efforts. It's cited in thousands of ecological papers and set the standard for rarefaction analysis.

---

## 🔬 Three Types of Rarefaction

Rarefaction is a statistical technique to **standardize biodiversity comparisons** by accounting for differences in sampling effort. There are three main approaches:

---

## 1️⃣ Individual-Based Rarefaction (IBR)

### What It Is:
- Rarefies (downsamples) to a **standard number of individuals**
- Based on the total count of organisms across all samples
- Asks: *"How many species would we expect if we randomly sampled N individuals?"*

### Data Requirements:
- **Abundance data** (counts of individuals)
- Total individuals summed across all samples

### CSV Format Example:
```csv
Site,Species_A,Species_B,Species_C
Plot_1,15,23,8
Plot_2,18,19,12
Plot_3,12,25,10
```

### How It Works:
1. Count total individuals across all sites: 15+23+8+18+19+12+12+25+10 = 142
2. Randomly resample to smaller sizes (e.g., 10, 20, 30... individuals)
3. Calculate expected species richness at each sample size
4. Plot curve showing richness vs. number of individuals

### When to Use:
- ✅ Comparing sites with different numbers of individuals
- ✅ Population density varies greatly
- ✅ You have true abundance counts
- ✅ Classic community ecology studies

### Formula:
Expected species richness for a subsample of *m* individuals from *N* total:

```
E(S_m) = Σ [1 - ((N - N_i) choose m) / (N choose m)]
```

Where:
- `N` = total individuals in full sample
- `N_i` = number of individuals of species *i*
- `m` = subsample size

### Output Interpretation:
- **X-axis**: Number of individuals sampled
- **Y-axis**: Expected number of species
- **Curve shape**: Steep = high turnover; Flat = approaching asymptote
- **Comparison**: Higher curves = richer communities

### Example Use Case:
Comparing forest plots where Plot A has 500 beetles and Plot B has 1,200 beetles. Rarefy both to 500 individuals to fairly compare species richness.

---

## 2️⃣ Sample-Based Rarefaction (SBR)

### What It Is:
- Rarefies (downsamples) to a **standard number of samples**
- Based on the number of independent sampling units
- Asks: *"How many species would we expect if we had N sampling units?"*

### Data Requirements:
- **Abundance data** OR **presence/absence data**
- Multiple independent samples (plots, quadrats, sites)
- Each row = one sample

### CSV Format Example:
```csv
Sample,Species_A,Species_B,Species_C
Quadrat_1,15,23,8
Quadrat_2,18,19,12
Quadrat_3,12,25,10
Quadrat_4,5,45,2
Quadrat_5,7,38,3
```

### How It Works:
1. Count total samples: 5 quadrats
2. Randomly resample to smaller numbers (e.g., 1, 2, 3, 4 samples)
3. Calculate expected species richness for each sample size
4. Plot curve showing richness vs. number of samples

### When to Use:
- ✅ Comparing studies with different numbers of samples
- ✅ Evaluating sampling completeness
- ✅ Different-sized sampling units (e.g., 1m² vs. 10m² plots)
- ✅ Presence/absence data where counts are unreliable

### Formula:
Expected species richness for a subsample of *m* samples from *M* total:

```
E(S_m) = Σ [1 - ((M - M_i) choose m) / (M choose m)]
```

Where:
- `M` = total number of samples
- `M_i` = number of samples containing species *i*
- `m` = subsample size (number of samples)

### Output Interpretation:
- **X-axis**: Number of samples
- **Y-axis**: Expected number of species
- **Curve shape**: Steep = high beta diversity; Flat = good coverage
- **Asymptote**: If curve flattens, most species have been found

### Example Use Case:
Comparing bird diversity in two forests where Forest A was surveyed with 10 point counts and Forest B with 25 point counts. Rarefy both to 10 samples.

---

## 3️⃣ Incidence-Based Rarefaction (Incidence-Frequency)

### What It Is:
- Rarefies based on **sampling units** (not individuals counted)
- Uses **detection frequency** (how often species found, not how many)
- Asks: *"How many species would we expect in N sampling units?"*
- **Key difference from SBR**: Uses incidence-frequency data format

### Data Requirements:
- **Incidence-frequency data**
- First column: Number of sampling units per site
- Remaining columns: Species detection frequencies

### CSV Format Example:
```csv
Site,SamplingUnits,Species_A,Species_B,Species_C
Forest_1,50,35,12,48
Forest_2,30,18,8,22
```

**Interpretation:**
- Forest_1 had 50 trap-days
- Species_A was detected in 35 of those 50 trap-days (70% incidence)
- Species_B was detected in 12 of 50 trap-days (24% incidence)

### How It Works:
1. Each site has T sampling units (e.g., trap-days)
2. Species have incidence frequencies (0 to T)
3. Rarefy to smaller numbers of sampling units
4. Calculate expected species based on detection probabilities

### When to Use:
- ✅ Trap studies (pitfall traps, camera traps, light traps)
- ✅ Presence/absence over repeated visits
- ✅ Rare or cryptic species
- ✅ Detection probability < 1
- ✅ Cannot count individuals reliably

### Formula:
Expected species richness for *t* sampling units from *T* total:

```
E(S_t) = Σ [1 - (1 - π_i)^t]
```

Where:
- `T` = total sampling units for site
- `Q_i` = number of units where species *i* was detected
- `π_i` = Q_i / T (detection probability)
- `t` = subsample size (number of units)

### Output Interpretation:
- **X-axis**: Number of sampling units
- **Y-axis**: Expected number of species
- **Curve shape**: Reflects detection effort, not abundance
- **Comparison**: Accounts for varying detection probabilities

### Example Use Case:
Comparing ant diversity using pitfall traps where Site A had 100 trap-days and Site B had 250 trap-days. Species recorded as "detected" or "not detected" in each trap-day.

---

## 🆚 Key Differences Summary

| Feature | Individual-Based | Sample-Based | Incidence-Based |
|---------|------------------|--------------|-----------------|
| **Unit of effort** | Number of individuals | Number of samples | Number of sampling units |
| **Data type** | Abundance counts | Abundance or presence/absence | Incidence-frequency |
| **X-axis** | Individuals | Samples | Sampling units |
| **Question** | "How many individuals?" | "How many samples?" | "How often detected?" |
| **Best for** | Population studies | Spatial comparisons | Detection studies |
| **Assumes** | Random individuals | Independent samples | Repeated detection |
| **Example** | "150 beetles caught" | "10 quadrats surveyed" | "Species found in 35 of 50 trap-days" |

---

## 🎯 iNEXT and Rarefaction Types

The **iNEXT** R package (used in Ördin) implements all three rarefaction approaches:

### iNEXT's Implementation:

1. **Individual-Based (Type 1)**:
   - `datatype = "abundance"`
   - Rarefies/extrapolates by **number of individuals**
   - Uses: Spider, bird, ciliates datasets

2. **Sample-Based (Type 2)**:
   - `datatype = "abundance"` with multiple samples
   - Converts to sample-based internally if needed
   - Can pool samples or analyze separately

3. **Incidence-Based (Type 3)**:
   - `datatype = "incidence"` or `"incidence_freq"`
   - Rarefies/extrapolates by **sampling units**
   - Uses: Ant dataset

### iNEXT vs. EstimateS:

| Feature | EstimateS | iNEXT |
|---------|-----------|-------|
| **Rarefaction** | ✓ All three types | ✓ All three types |
| **Extrapolation** | Limited | ✓ Full support |
| **Confidence intervals** | Bootstrap | Analytical + Bootstrap |
| **Hill numbers** | Partial | ✓ Full (q=0,1,2) |
| **Interface** | GUI (Windows/Mac) | R package |
| **Visualization** | Basic plots | ggplot2 integration |
| **Coverage-based** | No | ✓ Yes |

---

## 🔧 Current Implementation in Ördin

### What Ördin Already Does:

✅ **Individual-based rarefaction** (abundance data)
- When you select `"Abundance (counts)"` as data type
- iNEXT automatically rarefies by individuals
- Works with: spider, bird, ciliates datasets

✅ **Incidence-based rarefaction** (incidence-frequency data)
- When you select `"Incidence (presence/absence)"` as data type  
- iNEXT rarefies by sampling units
- Works with: ant dataset

### Current Code in app.R:
```r
# Determine data type for iNEXT
data_type <- input$dataType  # "abundance" or "incidence"

# Run iNEXT analysis
inext_out <- iNEXT(abund_matrix_t, q = c(0, 1, 2), datatype = data_type)
```

---

## 🚀 Proposed Enhancements for Ördin

### Enhancement 1: **Explicit Rarefaction Method Selector**

Add UI option to choose rarefaction type:

```r
# In sidebar:
selectInput("rarefactionMethod", "Rarefaction Method",
            choices = c(
              "Individual-based (standardize by individuals)" = "individual",
              "Sample-based (standardize by samples)" = "sample",
              "Size-based (standardize by coverage)" = "coverage"
            ))
```

### Enhancement 2: **Sample-Based Analysis**

Implement true sample-based rarefaction:

```r
# Convert abundance matrix to sample-based format
# Each row (site) is treated as one sample
# Rarefy by number of samples instead of individuals

if (input$rarefactionMethod == "sample") {
  # Use each row as a sample
  # Pool species across samples for rarefaction
  sample_data <- data()$original  # Sites as rows
  
  # iNEXT can handle this if we restructure the input
  # ...implementation code...
}
```

### Enhancement 3: **Coverage-Based Rarefaction**

iNEXT's unique feature - standardize by sample completeness:

```r
# Coverage-based rarefaction/extrapolation
# Compares communities at equal completeness levels
inext_out <- iNEXT(data, q = c(0, 1, 2), 
                   datatype = data_type,
                   endpoint = NULL,  # Auto-calculate
                   knots = 40)

# Plot by sample coverage instead of sample size
ggiNEXT(inext_out, type = 2)  # type=2 for coverage-based
```

### Enhancement 4: **Multiple Plot Types**

Add selector for different iNEXT plot types:

```r
selectInput("plotType", "Plot Type",
            choices = c(
              "Sample-size-based R/E curve" = 1,
              "Sample completeness curve" = 2,
              "Coverage-based R/E curve" = 3
            ))

# In plotting code:
plot_obj <- ggiNEXT(inext_out, type = as.numeric(input$plotType))
```

### Enhancement 5: **Comparison Mode**

Allow users to upload multiple datasets and compare:

```r
# Upload multiple CSV files
fileInput("dataFiles", "Upload CSV Files", 
          accept = ".csv", 
          multiple = TRUE)

# Combine into iNEXT format
combined_data <- list(
  Site_A = data_A$transposed,
  Site_B = data_B$transposed,
  Site_C = data_C$transposed
)

# iNEXT will automatically compare across sites
inext_out <- iNEXT(combined_data, q = c(0, 1, 2), datatype = data_type)
```

---

## 📋 Implementation Priority

### High Priority (Implement First):
1. ✅ **Individual-based rarefaction** - Already implemented
2. ✅ **Incidence-based rarefaction** - Already implemented  
3. 🔧 **Coverage-based plots** - Easy to add (just change plot type)
4. 🔧 **Multiple Hill numbers display** - Show q=0, 1, 2 separately

### Medium Priority:
5. 🔧 **Sample-based rarefaction** - Requires data restructuring
6. 🔧 **Comparison mode** - Upload multiple datasets
7. 🔧 **Confidence interval customization** - Adjust CI level

### Low Priority (Nice to Have):
8. 🔧 **Asymptotic estimators** - Show Chao1, ACE, etc.
9. 🔧 **Export iNEXT object** - Save for further R analysis
10. 🔧 **Interactive plots** - Plotly integration

---

## 💡 Recommendation for Ördin

**Ördin already implements the two most important rarefaction types!**

### What's Already Working:
✅ Individual-based (abundance data) - for most ecology studies  
✅ Incidence-based (incidence data) - for trap/detection studies

### Quick Win Enhancements:
1. **Add coverage-based plot option** (5 lines of code)
2. **Add explanatory help text** about rarefaction types
3. **Show all three Hill numbers** in separate panels

### Future Enhancement:
- **Sample-based rarefaction** - useful for spatial ecology
- **Multiple dataset comparison** - compare sites side-by-side

---

## 📚 Further Reading

### EstimateS:
- Colwell, R.K. (2013). EstimateS: Statistical estimation of species richness
- Download: http://viceroy.eeb.uconn.edu/EstimateS/

### iNEXT:
- Hsieh, T.C., Ma, K.H., Chao, A. (2016). iNEXT: an R package for rarefaction and extrapolation
- CRAN: https://cran.r-project.org/package=iNEXT
- GitHub: https://github.com/JohnsonHsieh/iNEXT

### Rarefaction Theory:
- Gotelli & Colwell (2001). Quantifying biodiversity: procedures and pitfalls
- Chao et al. (2014). Rarefaction and extrapolation with Hill numbers
- Chao & Jost (2012). Coverage-based rarefaction and extrapolation

---

**Summary**: Ördin already supports the two main rarefaction approaches (individual-based and incidence-based) through iNEXT. EstimateS pioneered these methods, and iNEXT extends them with extrapolation and coverage-based analysis. Easy enhancements can add more plot types and comparison features! 🌿📊
