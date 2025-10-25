# NMDS PDF Report - Visual Guide

**Quick Reference** | **Ördin v3.0**

---

## 📄 Report Structure (12 Sections)

```
┌─────────────────────────────────────────┐
│  NMDS ORDINATION ANALYSIS REPORT       │
│  Ördin v3.0                            │
│  October 25, 2025                      │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│  TABLE OF CONTENTS                      │
├─────────────────────────────────────────┤
│  1. Executive Summary..................1│
│  2. Analysis Overview..................2│
│  3. Ordination Quality Assessment......2│
│  4. NMDS Ordination Plot...............3│
│  5. Diagnostic Plots...................4│
│     5.1 Shepard Plot...................4│
│     5.2 Goodness of Fit................5│
│  6. Ordination Statistics..............6│
│  7. Site Scores........................7│
│  8. Species Scores.....................8│
│  9. Interpretation.....................9│
│ 10. Methods...........................10│
│ 11. References........................11│
│ 12. Software..........................12│
└─────────────────────────────────────────┘
```

---

## 📊 Page-by-Page Preview

### Page 1: Executive Summary
```
┌─────────────────────────────────────────┐
│ # EXECUTIVE SUMMARY                     │
│                                         │
│ This report presents NMDS analysis on   │
│ Plant Community Data.                   │
│                                         │
│ KEY FINDINGS:                           │
│ • Stress: 0.0876 (Good quality)        │
│ • Convergence: Successful              │
│ • Distance: BRAY-CURTIS                │
│ • Interpretation: Good ordination      │
│                                         │
│ RECOMMENDATION:                         │
│ This ordination provides reliable      │
│ representation of community structure.  │
│                                         │
│ ────────────────────────────────────   │
│                                         │
│ # ANALYSIS OVERVIEW                     │
│                                         │
│ Analysis Type: NMDS                    │
│ Dataset: Plant Community Data          │
│ Sites: 48                              │
│ Species: 156                           │
│ Distance: BRAY-CURTIS                  │
│ Dimensions: 2                          │
└─────────────────────────────────────────┘
```

### Page 2: Quality Assessment
```
┌─────────────────────────────────────────┐
│ # ORDINATION QUALITY ASSESSMENT         │
│                                         │
│ ┌───────────────────────────────────┐  │
│ │ Stress: 0.0876  [Grade: B]       │  │
│ │                                   │  │
│ │ Good ordination with no real risk │  │
│ │ of drawing false inferences       │  │
│ │                                   │  │
│ │ Recommendation: This ordination   │  │
│ │ provides reliable representation  │  │
│ └───────────────────────────────────┘  │
│                                         │
│ Convergence: ✓ Solution converged      │
│ Iterations: 20                          │
│ Non-metric R²: 0.9923                  │
└─────────────────────────────────────────┘
```

### Page 3: Main Ordination Plot
```
┌─────────────────────────────────────────┐
│ # NMDS ORDINATION PLOT                  │
│                                         │
│        NMDS Ordination                  │
│                                         │
│  1.0┤           •                       │
│     │      •  • •  •                    │
│  0.5┤    •  •   •   •                   │
│     │  •  •  •    •  •                  │
│NMDS2│────•───•──•──•────•               │
│ -0.5│  •  •  •    •  •                  │
│     │    •  •   •   •                   │
│ -1.0┤      •  • •  •                    │
│     │           •                       │
│     └──┬───┬───┬───┬───┬──             │
│      -1.0  -0.5  0  0.5  1.0            │
│             NMDS1                       │
│                                         │
│ Stress = 0.088 [B]                     │
│                                         │
│ Figure: NMDS showing sample positions   │
└─────────────────────────────────────────┘
```

### Page 4: Shepard Plot
```
┌─────────────────────────────────────────┐
│ ## SHEPARD PLOT                         │
│                                         │
│     Shepard Diagram                     │
│                                         │
│ Ord│  ┌─────────────────┐              │
│ Dis│  │      ....       │              │
│ tan│  │    ......       │              │
│ ces│  │  ........       │              │
│    │  │........         │              │
│    │ ┌┘.......          │              │
│    │┌┘......            │              │
│    └┴─────────────────  │              │
│     Observed            │              │
│     Dissimilarities     │              │
│                                         │
│ Non-metric R² = 0.992                  │
│                                         │
│ Figure: Relationship between observed   │
│ and ordination distances                │
└─────────────────────────────────────────┘
```

### Page 5: Goodness of Fit
```
┌─────────────────────────────────────────┐
│ ## GOODNESS OF FIT BY SITE              │
│                                         │
│  Goodness of Fit by Site                │
│                                         │
│ 1.0┤███████████████                     │
│    │█████████████ Mean = 0.756         │
│ 0.8┤███████████─────────────           │
│    │███████                             │
│ 0.6┤█████                               │
│    │███                                 │
│ 0.4┤█                                   │
│    │                                    │
│ 0.2┤                                    │
│    └──────────────────────             │
│     Sites (ranked)                      │
│                                         │
│ Figure: Goodness of fit for each site   │
│ Higher values = better representation   │
└─────────────────────────────────────────┘
```

### Page 6: Statistics Table
```
┌─────────────────────────────────────────┐
│ # ORDINATION STATISTICS                 │
│                                         │
│ ┌────────────────┬──────────────────┐  │
│ │ Statistic      │            Value │  │
│ ├────────────────┼──────────────────┤  │
│ │ Stress         │           0.0876 │  │
│ │ Quality Grade  │                B │  │
│ │ Convergence    │      ✓ Converged │  │
│ │ Dimensions     │                2 │  │
│ │ Distance       │     BRAY-CURTIS  │  │
│ │ Iterations     │               20 │  │
│ │ Try Max        │               20 │  │
│ │ Non-metric R²  │           0.9923 │  │
│ └────────────────┴──────────────────┘  │
│                                         │
│ Table: NMDS Analysis Statistics         │
└─────────────────────────────────────────┘
```

### Page 7: Site Scores
```
┌─────────────────────────────────────────┐
│ # SITE SCORES                           │
│                                         │
│ ┌────────┬─────────┬─────────┐         │
│ │ Sample │   NMDS1 │   NMDS2 │         │
│ ├────────┼─────────┼─────────┤         │
│ │ Site_1 │  0.4523 │  0.1234 │         │
│ │ Site_2 │ -0.2341 │  0.5678 │         │
│ │ Site_3 │  0.1234 │ -0.3456 │         │
│ │ Site_4 │  0.6789 │  0.2345 │         │
│ │   ...  │   ...   │   ...   │         │
│ └────────┴─────────┴─────────┘         │
│                                         │
│ Table: NMDS Site Scores                 │
│ (coordinates in ordination space)       │
└─────────────────────────────────────────┘
```

### Page 8: Species Scores
```
┌─────────────────────────────────────────┐
│ # SPECIES SCORES                        │
│                                         │
│ ┌───────────┬────────┬────────┬──────┐ │
│ │ Species   │  NMDS1 │  NMDS2 │ Imp. │ │
│ ├───────────┼────────┼────────┼──────┤ │
│ │ Sp_142    │ 0.5234 │ 0.6123 │ 0.81 │ │
│ │ Sp_089    │-0.4567 │ 0.5891 │ 0.73 │ │
│ │ Sp_213    │ 0.3421 │-0.6234 │ 0.71 │ │
│ │ Sp_045    │ 0.6789 │ 0.1234 │ 0.69 │ │
│ │   ...     │  ...   │  ...   │ ...  │ │
│ └───────────┴────────┴────────┴──────┘ │
│                                         │
│ Table: Top 50 species by importance     │
│ (distance from origin)                  │
└─────────────────────────────────────────┘
```

### Page 9: Interpretation
```
┌─────────────────────────────────────────┐
│ # INTERPRETATION                        │
│                                         │
│ ## Ordination Quality                   │
│ The NMDS achieved stress = 0.0876      │
│ (Good quality - Clarke 1993).          │
│                                         │
│ Non-metric R² = 0.9923 indicates       │
│ 99.2% of variance explained.           │
│                                         │
│ ## Convergence                          │
│ Successfully converged after 20         │
│ iterations. Stable solution found.      │
│                                         │
│ ## Distance Metric                      │
│ BRAY-CURTIS is appropriate for         │
│ abundance data, robust to sampling.     │
│                                         │
│ ## Biological Interpretation            │
│ • Proximity = similar composition       │
│ • Distance = dissimilarity              │
│ • Clusters = community types            │
│ • Gradients = environmental trends      │
└─────────────────────────────────────────┘
```

### Page 10: Methods
```
┌─────────────────────────────────────────┐
│ # METHODS                               │
│                                         │
│ ## NMDS                                 │
│ Non-metric Multidimensional Scaling     │
│ (Kruskal 1964):                        │
│                                         │
│ 1. Preserves rank-order                │
│ 2. No linear assumptions               │
│ 3. Robust to zeros                     │
│ 4. Any dissimilarity metric            │
│                                         │
│ ### Analysis Parameters                 │
│ • Distance: BRAY-CURTIS                │
│ • Dimensions: 2                        │
│ • Sites: 48                            │
│ • Species: 156                         │
│ • Random starts: 20                    │
│                                         │
│ ### Algorithm                           │
│ Iteratively adjusts positions to        │
│ minimize stress (monotonicity)...       │
└─────────────────────────────────────────┘
```

### Page 11: References
```
┌─────────────────────────────────────────┐
│ # REFERENCES                            │
│                                         │
│ Clarke, K.R. (1993). Non-parametric     │
│ multivariate analyses... Australian     │
│ Journal of Ecology, 18(1), 117-143.     │
│ doi:10.1111/j.1442-9993.1993.tb00438.x │
│                                         │
│ Kruskal, J.B. (1964). Multidimensional  │
│ scaling... Psychometrika, 29(1), 1-27.  │
│ doi:10.1007/BF02289565                  │
│                                         │
│ Minchin, P.R. (1987). Evaluation of     │
│ ordination techniques... Vegetatio,     │
│ 69(1-3), 89-107.                       │
│ doi:10.1007/BF00038690                  │
│                                         │
│ Oksanen, J., et al. (2024). vegan:      │
│ Community Ecology Package. v2.7-2       │
│ CRAN.R-project.org/package=vegan        │
└─────────────────────────────────────────┘
```

### Page 12: Software
```
┌─────────────────────────────────────────┐
│ # SOFTWARE                              │
│                                         │
│ Analysis performed using:               │
│                                         │
│ • Ördin v3.0                           │
│   Community Ecology Analysis Platform   │
│                                         │
│ • R version 4.5.1                      │
│                                         │
│ • vegan package v2.7-2                 │
│                                         │
│ • Generated: 2025-10-25 14:32:15 PST   │
│                                         │
│ ──────────────────────────────────────  │
│                                         │
│ Report generated by Ördin v3.0          │
│ Developed by: Jimmy Moses              │
│ Email: jmoses@pnguot.ac.pg             │
│ Institution: PNG Uni of Technology      │
│                                         │
│ CITATION: Moses, J. (2025). Ördin:     │
│ A cross-platform desktop app for        │
│ community ecology. Version 3.0.         │
└─────────────────────────────────────────┘
```

---

## 🎨 Visual Elements

### Color-Coded Quality Box
```
┌─────────────────────────────────────┐
│ Stress: 0.0876  [Grade: B]         │ ← Yellow box
│                                     │
│ Good ordination with no real risk   │
│ of drawing false inferences         │
│                                     │
│ Recommendation: Reliable            │
└─────────────────────────────────────┘
```

### Ordination Plot Features
```
• Sample points: Green filled circles (●)
• Sample labels: Small text above points
• Stress: Color-coded text (green/yellow/red)
• Grid: Light gray for reference
• Axes: Centered at origin (0,0)
• Title: Professional styling
```

### Shepard Plot Features
```
• Points: Semi-transparent green dots
• Line: Monotonic step function (black)
• R²: Annotated in corner
• Professional axes labels
```

### Goodness of Fit Plot
```
• Bars: Color gradient (red → yellow → blue → green)
• Mean line: Red dashed horizontal
• Sorted: Best to worst representation
```

---

## 📏 Specifications

| Feature | Specification |
|---------|--------------|
| **Page Size** | US Letter (8.5" × 11") |
| **Margins** | 1 inch all sides |
| **Font** | LaTeX default (Computer Modern) |
| **Figure DPI** | 300 (publication quality) |
| **Table Style** | Booktabs (professional) |
| **Header** | "NMDS Analysis Report" + page # |
| **Footer** | "Generated by Ördin v3.0" |
| **TOC** | Automatic, 2-level depth |
| **Sections** | Numbered (1, 1.1, 1.2, etc.) |

---

## 🎯 Key Features Highlighted

### 1. Executive Summary (Page 1)
✨ Quick overview for busy readers

### 2. Quality Box (Page 2)
✨ Color-coded stress interpretation

### 3. Main Plot (Page 3)
✨ Professional ordination visualization

### 4. Shepard Plot (Page 4)
✨ Diagnostic for fit quality

### 5. Goodness Plot (Page 5)
✨ Identify poorly represented sites

### 6. Statistics Table (Page 6)
✨ All metrics in one place

### 7. Site Scores (Page 7)
✨ Coordinates for all samples

### 8. Species Scores (Page 8)
✨ Top 50 indicator species

### 9. Interpretation (Page 9)
✨ Comprehensive guidance

### 10. Methods (Page 10)
✨ Publication-ready description

### 11. References (Page 11)
✨ Proper citations with DOIs

### 12. Software (Page 12)
✨ Reproducibility information

---

## ✅ Quality Checklist

- [x] **Professional appearance**
- [x] **Clear structure** with TOC
- [x] **High-quality plots** (300 DPI)
- [x] **Diagnostic information**
- [x] **Interpretation guidance**
- [x] **Complete methods**
- [x] **Proper references**
- [x] **Citation information**
- [x] **Version tracking**
- [x] **Timestamp**

---

## 🎓 Use Cases

### For Thesis/Dissertation
- Complete methods section ✓
- Professional figures ✓
- Proper citations ✓
- Reproducible ✓

### For Scientific Paper
- Publication-quality plots ✓
- Proper references ✓
- Methods description ✓
- Supplementary material ✓

### For Reports
- Executive summary ✓
- Clear interpretation ✓
- Professional appearance ✓
- Stakeholder-friendly ✓

### For Teaching
- Learning resource ✓
- Examples of good practice ✓
- Interpretation guidance ✓
- Methods explanation ✓

---

**This enhanced PDF report turns raw NMDS results into a comprehensive, publication-ready scientific document!** 📊✨

---

**Guide Created:** 2025-10-25  
**For:** Ördin v3.0 Users
