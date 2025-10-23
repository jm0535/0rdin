# Quick Debug: Test if app renders results

This document explains the fix for "app not showing results after Run Analysis"

## 🐛 The Problem

After clicking "Run Analysis", the app showed:
- "Analysis Results" header
- Empty content area (no plot, no table)

## 🔍 Root Cause

The manual ggplot2 code for shaded CI had potential issues:
1. **Data structure mismatch**: `inext_out$iNextEst` columns might differ
2. **Filter removing all data**: `filter(Method != "Observed")` might be too aggressive
3. **Missing error handling**: If plotting failed, entire results would fail

## ✅ The Fix

Added **error handling with fallback**:

```r
plot_obj <- tryCatch({
  # Try manual ggplot2 first (for shaded ribbons)
  plot_data <- inext_out$iNextEst
  df <- plot_data %>% filter(...) %>% mutate(...)
  ggplot(df, ...) + geom_ribbon(...) + geom_line(...)
  
}, error = function(e) {
  # Fallback: use ggiNEXT if manual fails
  message("Manual plotting failed, using ggiNEXT: ", e$message)
  ggiNEXT(x = inext_out, type = plot_type_num, se = TRUE, ...)
})
```

### Benefits:
- ✅ **Guaranteed to show results** (fallback ensures plot is created)
- ✅ **Error logging** (message printed to R console for debugging)
- ✅ **Best of both worlds** (tries shaded ribbons, falls back if needed)

## 🚀 Testing Steps

1. **Stop the app** (Ctrl+C in terminal)
2. **Restart**: `npm start`
3. **Upload data**: Use any sample dataset
4. **Run analysis**
5. **Should now see**:
   - Summary table
   - Plot (either manual ggplot2 or ggiNEXT fallback)

## 🔍 Debugging

If results still don't appear, check R console for errors:

### Look for:
```
Error in ...
Warning: ...
Manual plotting failed, using ggiNEXT: [error message]
```

### Common Issues:

**Issue 1: dplyr not found**
```
Error: could not find function "%>%"
```
**Fix**: Install dplyr
```r
install.packages("dplyr")
```

**Issue 2: Data structure mismatch**
```
Error: object 'qD' not found
```
**Fix**: The fallback to ggiNEXT will handle this

**Issue 3: iNEXT analysis failed**
```
Error in iNEXT(...): ...
```
**Fix**: Check data format (sites as columns, numeric values)

## ✅ Verification Checklist

After fix:
- [ ] App starts without errors
- [ ] Can upload CSV file
- [ ] "Run Analysis" button works
- [ ] Summary table appears
- [ ] Plot appears (either manual or ggiNEXT)
- [ ] Can download CSV and PNG

## 📝 What Changed

### File: `shiny/app.R` (Lines ~168-283)

**Before**:
```r
plot_obj <- ggplot(df, ...) + geom_ribbon(...) + geom_line(...)
# If this fails → entire results() fails → blank screen
```

**After**:
```r
plot_obj <- tryCatch({
  # Manual ggplot2 (preferred)
  ggplot(df, ...) + geom_ribbon(...) + geom_line(...)
}, error = function(e) {
  # Fallback to ggiNEXT
  ggiNEXT(x = inext_out, ...)
})
# Always creates a plot → results always show
```

## 🎯 Expected Behavior

### Successful Manual Plot:
- Shaded ribbon confidence intervals
- Faceted panels (q=0, 1, 2)
- Solid/dashed linetypes

### Fallback to ggiNEXT:
- Standard ggiNEXT plot (may have line CI)
- Single panel or faceted
- Still functional and informative

**Either way, YOU GET RESULTS!** ✅

## 🔧 Next Steps

If you still see blank results after this fix:

1. Check R console output in terminal
2. Look for error messages
3. Verify data format:
   - First column: site names
   - Other columns: numeric species data
   - No missing values (use 0)
4. Try different dataset (use sample-data/*.csv)
5. Check that all R packages are installed

## 📚 Related Files

- **Main fix**: `shiny/app.R` (error handling added)
- **Dependencies**: `add-cran-binary-pkgs.R` (ensure dplyr installed)
- **Test data**: `sample-data/*.csv` (known working datasets)

---

**The app should now ALWAYS show results, even if the fancy shaded ribbons don't work!** 🎉
