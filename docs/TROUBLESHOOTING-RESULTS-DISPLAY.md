# Troubleshooting: Results Not Displaying

**Issue**: Progress bar shows during analysis, but results don't appear after completion.

**Date**: 2025-10-23  
**Author**: Jimmy Moses

---

## Diagnostic Steps Added

I've added comprehensive debug output to track exactly where the issue occurs:

### 1. Results UI Rendering
```r
output$resultsUI <- renderUI({
  req(results())
  res <- results()
  
  cat("\n=== RENDERING RESULTS UI ===")
  cat("\nResults type:", res$type)
  cat("\nSummary rows:", nrow(res$summary))
  cat("\n===========================\n")
  ...
})
```

### 2. Summary Table Rendering
```r
output$summaryTable <- renderDT({
  cat("\n=== RENDERING SUMMARY TABLE ===")
  cat("\nRows:", nrow(results()$summary))
  cat("\nColumns:", ncol(results()$summary))
  cat("\n==============================\n")
  ...
})
```

### 3. Plot Rendering
```r
output$analysisPlot <- renderPlot({
  cat("\n=== RENDERING PLOT ===")
  cat("\nPlot type:", class(results()$plot)[1])
  cat("\n===================\n")
  ...
})
```

---

## How to Test

### Step 1: Open R Console
When you run Ördin, keep the R console window visible (not just the app window).

### Step 2: Upload Data
Upload one of the sample datasets:
- `bird-abundance.csv`
- `plant-presence.csv`
- `ant-incidence.csv`

### Step 3: Run Analysis
Click "Run Analysis" and watch BOTH:
1. **App window**: Progress bar
2. **R console**: Diagnostic messages

### Step 4: Check Console Output

You should see this sequence in the R console:

```
=== ÖRDIN DATA LOADING ===
File loaded: bird-abundance.csv
Rows (sites): 10
Columns (species): 15
Is binary (0/1 only): FALSE
Sample of first 5 values: 5, 3, 7, 2, 0
Row totals: 42, 38, 45, 51, ...
============================

✓ Auto-selected: Abundance - Individual counts

=== ÖRDIN DATA DIAGNOSTICS ===
Data format detected: abundance
Actual datatype for iNEXT: abundance
Number of sites: 10
Number of species: 15
Total per site: 42, 38, 45, 51, ...
Min sample size: 35
Species with >0: 15
Data sparsity: 12.5 %
============================

Data loaded: 10 sites, 15 species
Format: abundance | Min occurrences: 35 | Species present: 15

=== RENDERING RESULTS UI ===
Results type: iNEXT
Summary rows: 30
===========================

=== RENDERING SUMMARY TABLE ===
Rows: 30
Columns: 8
==============================

=== RENDERING PLOT ===
Plot type: gg
===================
```

---

## Possible Issues and Solutions

### Issue 1: No "RENDERING RESULTS UI" Message
**Problem**: `results()` reactive never gets set  
**Cause**: Analysis failed silently  
**Solution**: Check for error messages between "Data loaded" and rendering

### Issue 2: "RENDERING RESULTS UI" Appears But Nothing Shows
**Problem**: UI rendering succeeds but display fails  
**Possible causes**:
- Browser JavaScript error
- CSS hiding elements
- Card container issue

**Solution**: 
1. Open browser DevTools (F12)
2. Check Console tab for JavaScript errors
3. Check Elements tab to see if `<div id="resultsUI">` exists

### Issue 3: "RENDERING SUMMARY TABLE" Never Appears
**Problem**: `DTOutput("summaryTable")` not triggering  
**Cause**: Results UI created but table output not requested  
**Solution**: Scroll down in app window - table might be below fold

### Issue 4: "RENDERING PLOT" Never Appears
**Problem**: Plot output not requested  
**Cause**: Same as Issue 3  
**Solution**: Check if plot appears after scrolling

---

## Enhanced Results Display

I've also improved the results display styling:

### Summary Table
- ✅ Increased rows per page: 15 (was 10)
- ✅ Added Excel export button
- ✅ Centered columns
- ✅ Formatted numbers to 4 decimal places
- ✅ Better visual styling

### Visualization Section
- ✅ Clear section headers with icons
- ✅ Better export format selector layout
- ✅ Improved download button styling
- ✅ Increased plot height: 650px (was 600px)

### NMDS Stress Display
- ✅ Enhanced with emoji indicators:
  - ✅ Excellent/Good
  - ⚠️ Acceptable
  - ❌ Poor
- ✅ Better color contrast

---

## Quick Fixes to Try

### Fix 1: Restart Ördin
Sometimes Shiny's reactive system gets stuck:
1. Close Ördin completely
2. Reopen from Electron app
3. Try analysis again

### Fix 2: Clear Browser Cache
If using browser version:
1. Press Ctrl+Shift+Delete
2. Clear cached files
3. Reload page

### Fix 3: Check Sample Data
Try different datasets:
- If `bird-abundance.csv` fails, try `plant-presence.csv`
- Different data types test different code paths

### Fix 4: Simplify Analysis
Reduce computational load:
- Uncheck some Hill numbers (keep only q=0)
- Reduce Bootstrap replicates to 20
- Reduce Knots to 20

---

## Expected Behavior

### Correct Flow:
1. **Upload data** → Green progress bar "Upload complete"
2. **Auto-detect format** → Notification "✓ Auto-selected: [format]"
3. **Click Run Analysis** → Progress modal appears
4. **Progress steps**:
   - "Validating data..." (10%)
   - "Checking data quality..." (15%)
   - "Validating requirements..." (20%)
   - "Calculating diversity indices..." (30%)
   - "Generating plots..." (60%)
   - "Done!" (100%)
5. **Results appear** → Card with:
   - 📊 Summary Table (with Copy/CSV/Excel buttons)
   - 📊 Visualization (with format selector and download button)
   - Plot renders below

### If ANY step fails:
- Error message should appear (red notification or validation error)
- Analysis stops
- No "RENDERING" messages in console

---

## Console Output Reference

### Normal Successful Run:
```
=== ÖRDIN DATA LOADING ===
[data info]
============================

=== ÖRDIN DATA DIAGNOSTICS ===
[validation info]
============================

=== RENDERING RESULTS UI ===
Results type: iNEXT
Summary rows: [number]
===========================

=== RENDERING SUMMARY TABLE ===
Rows: [number]
Columns: [number]
==============================

=== RENDERING PLOT ===
Plot type: gg
===================
```

### Failed Analysis:
```
=== ÖRDIN DATA LOADING ===
[data info]
============================

=== ÖRDIN DATA DIAGNOSTICS ===
[validation info]
============================

[ERROR MESSAGE or VALIDATION FAILURE]
[NO RENDERING MESSAGES]
```

---

## Next Steps

1. **Run analysis with console visible**
2. **Copy ALL console output**
3. **Check which "RENDERING" messages appear**
4. **Share console output for further diagnosis**

If you see:
- ✅ All three "RENDERING" messages → Results are rendering, check browser DevTools
- ✅ "RENDERING RESULTS UI" only → Table/Plot not requesting, scroll issue
- ❌ No "RENDERING" messages → Analysis failing, check for errors before rendering

---

## Additional Enhancements Made

### Better Error Handling
- Wrapped results rendering with `req(results())`
- Added type checking for plot object
- Enhanced validation messages

### Improved Styling
- Professional card headers with icons
- Better color contrast for dark theme
- Responsive layout for export controls
- Enhanced spacing and padding

### Debug Information
- Complete rendering pipeline tracking
- Data dimension validation
- Object type verification

---

## Contact

If issues persist after trying these steps, please provide:
1. **Console output** (all diagnostic messages)
2. **Dataset name** (which CSV file)
3. **Analysis settings** (which parameters selected)
4. **Browser version** (if using browser, not Electron)

**Author**: Jimmy Moses (jmoses@pnguot.ac.pg)  
**Application**: Ördin v1.0  
**Framework**: R Shiny + Electron
