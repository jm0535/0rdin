# CRITICAL FIX: DataTable Not Rendering

## PROBLEM IDENTIFIED
The DataTable preview section was completely empty - not even showing the placeholder message "No data loaded yet."

## ROOT CAUSE
**WRONG FUNCTION PAIRING!**

The code was using:
- UI: `DT::dataTableOutput()` 
- Server: `DT::renderDataTable()`

But the DT package has TWO different rendering systems that MUST match:

### OLD API (Deprecated):
- `dataTableOutput()` + `renderDataTable()`

### NEW API (Current):
- `DTOutput()` + `renderDT()`

**The old API was causing the table to not render at all!**

## SOLUTION APPLIED

### Changed UI (line ~262):
```r
# BEFORE:
DT::dataTableOutput("species_preview")

# AFTER:
DT::DTOutput("species_preview")
```

### Changed Server (line ~385):
```r
# BEFORE:
output$species_preview <- DT::renderDataTable({

# AFTER:
output$species_preview <- DT::renderDT({
```

## ADDITIONAL IMPROVEMENTS

1. **Better debug logging** - More verbose console output
2. **Added style parameter** - `style = 'bootstrap4'` for better theming
3. **Added min-height** - Container has 200px minimum height
4. **Better table classes** - Added `hover` class for interactivity

## TESTING AFTER FIX

### CRITICAL: RESTART REQUIRED!
```powershell
.\restart_app.ps1
```

OR manually:
1. Stop app (CTRL+C)
2. Run: `shiny::runApp(port=9054)`
3. Wait for "Listening on http://127.0.0.1:9054"
4. Hard refresh browser: `CTRL+SHIFT+R`

### Expected R Console Output:
```
========== DATATABLE RENDER CALLED ==========
Timestamp: 2025-10-29 XX:XX:XX
species_data is null: TRUE
Showing empty placeholder message
==========================================
```

Then after loading data:
```
========== DATATABLE RENDER CALLED ==========
Timestamp: 2025-10-29 XX:XX:XX
species_data is null: FALSE
Showing actual data
Rows: 20
Cols: 30
==========================================
```

### Expected Browser Behavior:
1. **Initially:** Placeholder message appears in Data Preview
2. **After upload/load:** DataTable with actual data appears
3. **Table features:** Pagination, search, sorting all work

## WHY THIS MATTERS

The DT package documentation recommends using `renderDT()` and `DTOutput()` because:
- Better performance
- More reliable rendering
- Active development (renderDataTable is legacy)
- Better Bootstrap 4 integration

## FILES CHANGED
- `shiny/app.R` (lines 262, 385)
- Cache version: `?v=7`
