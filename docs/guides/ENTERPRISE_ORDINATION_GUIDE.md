# Ordination Settings Guide — Ördin 4

## Overview
Ördin now implements **publication-quality ordination analysis** with enterprise-grade settings following best practices from vegan R package, CANOCO software, and ter Braak & Legendre's methodologies.

## Research-Based Implementation

### Sources & Standards
1. **vegan R Package** (Oksanen et al., 2024)
   - Industry-standard community ecology analysis
   - Rigorous statistical implementations
   - Peer-reviewed algorithms

2. **CANOCO Software** (ter Braak & Šmilauer)
   - Gold standard for constrained ordination
   - Professional biplot visualization
   - Publication-quality output

3. **Numerical Ecology** (Legendre & Legendre, 2012)
   - Theoretical foundations
   - Best practice methodologies
   - Statistical rigor

## Enhanced Ordination Settings

### 1. Method Selection (7 methods)
```
✓ NMDS - Non-metric Multidimensional Scaling
✓ PCA  - Principal Components Analysis
✓ CA   - Correspondence Analysis  
✓ DCA  - Detrended Correspondence Analysis
✓ CCA  - Canonical Correspondence Analysis (constrained)
✓ RDA  - Redundancy Analysis (constrained)
✓ PCoA - Principal Coordinates Analysis
```

### 2. Distance Measures (8 options)
Based on vegan's `vegdist()` function:

**For NMDS and PCoA:**
- **Bray-Curtis** (default, recommended for abundance data)
- **Jaccard** (presence-absence, asymmetric)
- **Euclidean** (geometric distance)
- **Manhattan** (city-block distance)
- **Canberra** (sensitive to rare species)
- **Kulczynski** (robust to sample size)
- **Gower** (handles mixed data types)
- **Morisita-Horn** (probabilistic)

**Selection Guide:**
- Abundance data → Bray-Curtis
- Presence-absence → Jaccard
- Linear gradients → Euclidean
- Rare species important → Canberra

### 3. NMDS Parameters (Enterprise-Grade)

**Dimensions (k)**
- Default: 2 (for visualization)
- Range: 1-6
- Recommendation: Start with 2, increase if stress > 0.2

**Random Starts (try)**
- Default: 20
- Range: 5-100
- Purpose: Find global minimum (avoid local minima)
- Recommendation: 20 for most data, 50+ for complex datasets

**Maximum Tries (trymax)**
- Default: 100
- Range: 20-500
- Purpose: Iteration limit to reach convergence
- Recommendation: 100 standard, 200-500 for difficult data

**Auto-transform**
- Default: TRUE (Wisconsin double standardization)
- Applies: Species standardization + sample standardization
- When to disable: Data already transformed

**Engine**
- monoMDS (default, robust, Kruskal's method)
- isoMDS (classical, fast)

**Expand to Species Scores (wascores)**
- Default: TRUE
- Adds: Weighted averaging species scores
- Use: For species-environment relationships

### 4. Biplot Scaling (CA, CCA, RDA, DCA)

Following **ter Braak (1986)** scaling conventions:

**Type 1 - Distance Biplot**
- Preserves: Chi-square distances among sites (rows)
- Use when: Focus on site relationships
- Interpretation: Distance between sites = dissimilarity

**Type 2 - Correlation Biplot** (DEFAULT)
- Preserves: Correlations among species/variables (columns)
- Use when: Focus on species/variable relationships
- Interpretation: Angle between arrows = correlation

**Type 3 - Symmetric Scaling**
- Balanced: Equal weight to rows and columns
- Use when: Both sites and species equally important
- Interpretation: Compromise between Type 1 and 2

**CANOCO Equivalents:**
- Scaling 1 = Focus on inter-sample distances
- Scaling 2 = Focus on inter-species correlations  
- Scaling 3 = Biplot scaling

### 5. Data Transformations

Pre-analysis transformations (applied before ordination):

**None** - Raw data
- Use: Already appropriate scale
- Caution: Rare species may dominate

**Hellinger** - √(x/row_sum)
- **RECOMMENDED for PCA with abundance data**
- Gives: Appropriate weight to rare species
- Reference: Legendre & Gallagher (2001)

**Chi-square** - (x - expected)/√expected  
- Use: CA-based methods
- Reduces: Double-zero problem

**Log(x+1)** - log transformation
- Reduces: Influence of abundant species
- Use: Skewed abundance distributions

**Square root** - √x
- Moderate: Down-weighting of abundant species
- Use: Less extreme than log

**Presence-Absence** - Convert to 0/1
- Use: When abundance unreliable
- Methods: Jaccard, Sørensen distances

**Wisconsin** - Double standardization
- Species max = 1, then samples sum = 1
- Use: Remove abundance effects

### 6. Biplot Overlays (CANOCO-style)

#### A. Environmental Vectors (Arrows)

**Parameters:**
- **Arrow Scaling**: 0.2 - 2.0 (default: 0.8)
  - Controls: Visual length of arrows
  - 0.8 = 80% of plot range
  
- **Significance Threshold**: p-value cutoff (default: 0.05)
  - Method: Permutation test (999 permutations)
  - Display: Only significant vectors
  
- **Show P-values**: Include significance in labels
  - Format: "Variable (p=0.001)"
  
- **Label Position**:
  - At arrow tip (default, CANOCO-style)
  - Along arrow (alternative)

**Implementation:**
```r
envfit(ordination, env_data, permutations = 999)
```

**Interpretation:**
- Arrow direction → environmental gradient
- Arrow length → strength of relationship
- Angle between arrows → correlation
  - < 90° = positive correlation
  - > 90° = negative correlation
  - 90° = uncorrelated

#### B. Confidence Ellipses

**Parameters:**
- **Confidence Level**: 0.80 - 0.99 (default: 0.95)
  - 0.95 = 95% confidence interval
  
- **Ellipse Type**:
  - t-distribution (default, robust)
  - norm (assumes normality)
  - euclid (Euclidean)
  
- **Fill Ellipses**: TRUE/FALSE
  
- **Fill Transparency**: 0.05 - 0.50 (default: 0.15)
  - Lower = more transparent

**Statistical Method:**
```r
stat_ellipse(level = 0.95, type = "t")
```

**Interpretation:**
- Ellipse size → within-group variability
- Ellipse separation → between-group differences
- Overlap → similarity between groups
- Non-overlap → significantly different communities

#### C. Species Scores

**Display Options:**
- Points only
- Labels only  
- Both points and labels

**Top N Species**: Show most influential species
- 0 = all species
- 20 = top 20 (recommended for clarity)

**Selection Criteria:**
- Distance from origin (influence on ordination)
- Fit to ordination axes

### 7. Publication Quality Settings

When enabled, provides journal-ready output:

**Plot Dimensions:**
- Width: 4-20 inches (default: 8")
- Height: 4-20 inches (default: 6")
- Ratio: Typically 4:3 or 16:10

**Typography:**
- Base Font Size: 8-20 pt (default: 12pt)
- Point Size: 1-8 (default: 3)
- Label Size: 2-8 (default: 3.5)
- Font Family: Arial, Helvetica (sans-serif)

**Color Schemes:**
- Dark background (default, presentation)
- High contrast / Light background (publication)

**Export Formats:**
- **PNG**: 300+ DPI (default 300)
- **TIFF**: 600 DPI (journal quality)
- **SVG**: Vector (infinitely scalable)

## Diagnostic Output

### NMDS
```
✓ NMDS complete! 
Stress: 0.118 | Converged: TRUE | Tries: 12
```

**Stress Interpretation:**
- < 0.05 = Excellent
- < 0.10 = Good
- < 0.20 = Acceptable
- > 0.20 = Poor (increase dimensions or try different method)

### PCA / PCoA
```
✓ PCA complete! 
Axis 1: 45.2%, Axis 2: 28.7%
```

**Variance Explained:**
- Good: > 50% in first 2 axes
- Acceptable: > 30% in first 2 axes
- Poor: < 20% (data may not have clear structure)

### CA / DCA
```
✓ CA complete!
```

**Inertia:** Total variance in species data
- Eigenvalues: Amount explained by each axis
- Cumulative: Progressive explanation

### CCA
```
✓ CCA complete! 
Constrained: 42.5%
```

**Constrained Proportion:**
- High (>40%): Environment strongly structures community
- Medium (20-40%): Moderate environmental control
- Low (<20%): Environment weakly related to composition

### RDA
```
✓ RDA complete! 
R²: 0.685 | Adj. R²: 0.612
```

**R-squared:**
- R² = Variance explained by all environmental variables
- Adj. R² = Adjusted for number of variables (use this!)
- Good: Adj. R² > 0.5
- Moderate: Adj. R² = 0.3-0.5
- Weak: Adj. R² < 0.3

## Best Practices

### Method Selection Decision Tree

```
START
  |
  ├─ Unconstrained (exploratory)?
  │   ├─ Linear response expected?
  │   │   └─ PCA (transform with Hellinger if abundance)
  │   │
  │   ├─ Unimodal response expected?
  │   │   ├─ Gradient length > 4 SD?
  │   │   │   └─ CA or DCA
  │   │   └─ Gradient length < 3 SD?
  │   │       └─ PCA
  │   │
  │   └─ No assumptions about response?
  │       └─ NMDS (robust, recommended)
  │
  └─ Constrained (test hypotheses)?
      ├─ Linear response?
      │   └─ RDA
      │
      └─ Unimodal response?
          └─ CCA
```

### Transformation Guidelines

| Data Type | Recommended Transform | Rationale |
|-----------|----------------------|-----------|
| Abundance (counts) | Hellinger or log(x+1) | Down-weight dominants |
| Presence-Absence | None or PA | Already binary |
| Cover % | Square root | Moderate transformation |
| Biomass | Log(x+1) | Highly skewed |
| Mixed units | Wisconsin | Standardizes |

### Biplot Combinations

**For Exploration (Unconstrained):**
- NMDS + Environmental arrows
- PCA (Hellinger) + Environmental arrows + Species scores

**For Hypothesis Testing (Constrained):**
- CCA + Environmental arrows + Ellipses
- RDA + Environmental arrows + Ellipses

**Publication Quality:**
1. Enable publication mode
2. Set appropriate dimensions (8" x 6")
3. Use high-contrast background
4. Base font size: 12-14pt
5. Export as TIFF (600 DPI) or SVG

## References

### Essential Papers

**Ordination Methods:**
- ter Braak, C.J.F. (1986). Canonical Correspondence Analysis: A new eigenvector technique for multivariate direct gradient analysis. *Ecology* 67:1167-1179.

- Legendre, P. & Legendre, L. (2012). *Numerical Ecology*, 3rd edition. Elsevier.

**Transformations:**
- Legendre, P. & Gallagher, E.D. (2001). Ecologically meaningful transformations for ordination of species data. *Oecologia* 129:271-280.

**NMDS:**
- Kruskal, J.B. (1964). Multidimensional scaling by optimizing goodness of fit to a nonmetric hypothesis. *Psychometrika* 29:1-27.

**Software:**
- Oksanen, J., et al. (2024). vegan: Community Ecology Package. R package version 2.6-8.

- ter Braak, C.J.F. & Šmilauer, P. (2012). CANOCO Reference Manual and User's Guide: Software for Ordination, version 5.0. Microcomputer Power, Ithaca, USA.

### Online Resources

- **vegan Tutorial**: https://cran.r-project.org/web/packages/vegan/vignettes/intro-vegan.pdf
- **CANOCO**: https://www.canoco5.com/
- **Ordination Web Book**: https://ordination.okstate.edu/

## Troubleshooting

### Issue: NMDS high stress (> 0.2)
**Solutions:**
1. Increase dimensions (k = 3 or 4)
2. Try more random starts (try = 50)
3. Use different distance measure
4. Remove outlier samples
5. Consider CA/DCA instead

### Issue: Low variance explained (PCA/RDA)
**Solutions:**
1. Apply Hellinger transformation
2. Check for outliers
3. Consider non-linear methods (CA, NMDS)
4. More axes may be needed

### Issue: CCA/RDA fails
**Solutions:**
1. Check for collinear environmental variables (VIF > 10)
2. Remove highly correlated variables
3. Ensure sample size > variables
4. Check for missing values

### Issue: Arrows not showing
**Solutions:**
1. Ensure environment data is numeric
2. Check significance threshold (try p = 0.1)
3. Increase arrow scaling
4. Verify data is loaded correctly

---

**Author:** Jimmy Moses  
**Email:** jmoses@pnguot.ac.png  
**Application:** Ördin v3.0  
**Date:** 2025  
**License:** MIT

**Citation:**
Moses, J. (2025). Ördin: An Interactive Platform for Community Ecology Analysis with Publication-Quality Ordination. R Shiny Application.
