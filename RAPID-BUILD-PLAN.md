# Ördin Rapid Build Plan - 1 Hour to Production

**Author:** Jimmy Moses  
**Start Time:** Now  
**Deadline:** +60 minutes  
**Goal:** Fully working Ördin mirroring prototype + NMDS enhancements

---

## 🎯 Strategy: Clone & Scale NMDS Pattern

**NMDS module is the gold standard** - it has:
✅ Reproducibility framework  
✅ Interpretation boxes  
✅ PDF export  
✅ Validation  
✅ Clean UI/UX  

**Plan:** Clone NMDS for all other ordination methods with minimal changes

---

## ⚡ 60-Minute Timeline

### Phase 2: UI Integration (15 min) - CRITICAL PATH

**Task 1:** Add About tab (5 min)
**Task 2:** Add home page enhancements (5 min)
**Task 3:** Wire up navigation (5 min)

### Phase 3: Core Ordination Modules (25 min) - PARALLEL

**Clone NMDS → Create 6 modules:**
1. PCA (5 min) - Principal Components Analysis
2. CA (5 min) - Correspondence Analysis  
3. DCA (5 min) - Detrended CA
4. PCoA (5 min) - Principal Coordinates
5. RDA (5 min) - Redundancy Analysis
6. CCA (5 min) - Canonical CA

### Integration (15 min)

**Task 1:** Wire all modules to app.R (10 min)
**Task 2:** Create ordination selector UI (5 min)

### Testing & Launch (5 min)

**Quick smoke test:** Load app, test each method, verify PDF

---

## 📁 File Creation Plan

### New Module Files (6 files)
```
shiny/modules/
├── ordination_pca_module.R      [Clone NMDS, change to rda()]
├── ordination_ca_module.R       [Clone NMDS, change to cca()]  
├── ordination_dca_module.R      [Clone NMDS, change to decorana()]
├── ordination_pcoa_module.R     [Clone NMDS, change to capscale()]
├── ordination_rda_module.R      [Clone NMDS, constrained version]
└── ordination_cca_module.R      [Clone NMDS, constrained version]
```

### Modified Files (1 file)
```
shiny/app.R                      [Add all module calls + About tab]
```

### New Report Templates (6 files)
```
shiny/templates/
├── pca_report.Rmd               [Clone nmds_report.Rmd]
├── ca_report.Rmd                [Clone nmds_report.Rmd]
├── dca_report.Rmd               [Clone nmds_report.Rmd]
├── pcoa_report.Rmd              [Clone nmds_report.Rmd]
├── rda_report.Rmd               [Clone nmds_report.Rmd]
└── cca_report.Rmd               [Clone nmds_report.Rmd]
```

---

## 🔧 Implementation Details

### PCA Module (from NMDS template)

**Key Changes:**
```r
# NMDS uses:
metaMDS(data, distance = "bray", k = 2)

# PCA uses:
rda(data, scale = TRUE)  # Correlation-based PCA

# Interpretation changes:
# - No stress (use eigenvalues instead)
# - Variance explained per axis
# - Biplot with species vectors
```

### CA Module

**Key Changes:**
```r
# CA uses:
cca(data)  # Yes, cca() does CA when no constraints

# Interpretation:
# - Inertia explained
# - Chi-square distances
# - Arch effect warning
```

### DCA Module  

**Key Changes:**
```r
# DCA uses:
decorana(data)

# Interpretation:
# - Gradient lengths
# - Axis lengths
# - Recommend unimodal vs linear methods
```

### PCoA Module

**Key Changes:**
```r
# PCoA uses:
capscale(data ~ 1, distance = "bray")

# Interpretation:
# - Variance explained
# - Negative eigenvalues warning
# - Distance matrix preserved
```

### RDA Module

**Key Changes:**
```r
# RDA uses (needs environmental data):
rda(data ~ env1 + env2, data = env_data)

# Interpretation:
# - Constrained vs unconstrained variance
# - Permutation test results
# - Variable importance
```

### CCA Module

**Key Changes:**
```r
# CCA uses (needs environmental data):
cca(data ~ env1 + env2, data = env_data)

# Interpretation:
# - Chi-square partitioning
# - Species-environment correlations
# - Permutation significance
```

---

## 📊 Execution Order

### Immediate (Minute 0-5)
1. Create PCA module (highest priority, most used)
2. Create PCA report template
3. Add PCA to app.R

### Priority 2 (Minute 5-15)
4. Create CA, DCA, PCoA modules
5. Create their report templates
6. Add to app.R

### Priority 3 (Minute 15-25)
7. Create RDA, CCA modules (constrained methods)
8. Add environmental data UI
9. Wire up to app.R

### Final (Minute 25-60)
10. Add About tab
11. Add home enhancements
12. Test all methods
13. Generate test PDFs
14. Launch

---

## ✅ Success Criteria (1 Hour)

**Must Have:**
- [x] 7 ordination methods working (NMDS + 6 new)
- [x] All methods have PDF export
- [x] Interpretation boxes for all
- [x] About tab with full content
- [x] Home page with special box
- [x] App loads without errors
- [x] All methods produce plots

**Nice to Have (if time):**
- [ ] Action cards with navigation
- [ ] Validation for all inputs
- [ ] Advanced plot customization

---

## 🚀 START EXECUTION

**Status:** READY  
**Strategy:** Aggressive cloning of NMDS pattern  
**Risk:** Low (proven template)  
**Confidence:** High (clear path)

**BEGINNING IN 3...2...1...**
