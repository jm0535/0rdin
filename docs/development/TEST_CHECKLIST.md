# Ördin Data Loading Test Checklist

> ⚠️ **Legacy document (Ördin 3.x).** This describes the R Shiny + Electron
> application in `shiny/` and `src/`, which is kept for maintenance only.
> For the current release see [Documentation Index](../DOCS-INDEX.md) ·
> [Quick Start](../QUICKSTART.md) · [Architecture](../ARCHITECTURE.md).

## BEFORE TESTING - RESTART APP
1. ✅ Kill all R processes: `Get-Process | Where-Object {$_.ProcessName -eq "Rterm" -or $_.ProcessName -eq "R"} | Stop-Process -Force`
2. ✅ Start app: Run `.\restart_app.ps1` OR manually run `shiny::runApp(port=9054)` in R
3. ✅ Wait for: "Listening on http://127.0.0.1:9054"
4. ✅ Open browser: http://localhost:9054
5. ✅ Hard refresh: `CTRL + SHIFT + R`

## DATA LOADING TEST
### Test 1: Sample Data Loading
1. Click Data icon (📊) OR "Get Started →" button
2. Select "Dune Meadow" from dropdown
3. Click "▶ Load Sample Data"
4. **EXPECTED RESULTS:**
   - ✅ Green notification: "✅ Dune meadow data loaded successfully!"
   - ✅ Data Preview section shows table with 20 rows × 30 columns
   - ✅ R console shows:
     ```
     === LOAD SAMPLE BUTTON CLICKED ===
     sample_dataset value: dune
     Loading dune dataset...
     Dune data stored. Rows: 20
     === SAMPLE DATA LOADING COMPLETE ===
     DataTable rendering triggered
     species_data is null: FALSE
     Showing actual data with 20 rows
     ```

### Test 2: Different Sample Dataset
1. Select "Varespec" from dropdown
2. Click "▶ Load Sample Data"
3. **EXPECTED RESULTS:**
   - ✅ Green notification: "✅ Varespec data loaded successfully!"
   - ✅ Data Preview shows table with 24 rows × 44 columns
   - ✅ R console shows loading messages

### Test 3: File Upload
1. Click "Browse..." button
2. Select a CSV file
3. **EXPECTED RESULTS:**
   - ✅ File name appears next to Browse button
   - ✅ Green notification: "✅ filename.csv loaded successfully! (X rows, Y columns)"
   - ✅ Data Preview updates automatically

## SIDEBAR FUNCTIONALITY TEST
### Test 4: Sidebar Navigation
1. Click each sidebar item:
   - ✅ "📄 species_data.csv" → Goes to Data tab
   - ✅ "📥 Import New File" → Goes to Data tab
   - ✅ "📚 Sample Datasets" → Goes to Data tab
   - ✅ "📊 Current Dataset" → Goes to Data tab
   - ✅ "ℹ️ Metadata" → Shows alert "Metadata view coming soon!"
   - ✅ "✅ Validation" → Shows alert "Validation tools coming soon!"
   - ✅ "📈 iNEXT analysis" → Goes to Diversity tab

### Test 5: Activity Bar Navigation
1. Click each activity bar icon:
   - ✅ 🏠 Home → Shows Dashboard
   - ✅ 📊 Data → Shows Data Management tab
   - ✅ 📈 Diversity → Shows Diversity Analysis tab
   - ✅ 🔵 Ordination → Shows Ordination Analysis tab
   - ✅ 📋 Results → Shows Results tab
   - ✅ ⚙️ Settings → Shows Settings tab
   - ✅ ❓ Help → Shows Help/About tab

## STYLING TEST
### Test 6: UI Appearance
- ✅ Sidebar is VISIBLE (not collapsed)
- ✅ All text is readable (light text on dark background)
- ✅ Buttons are green (#2e8b57)
- ✅ Form inputs have dark background (#3c3c3c)
- ✅ DataTable has dark theme with proper borders
- ✅ Dropdown selects are styled dark
- ✅ File input button is visible and green

## TROUBLESHOOTING

### If Data Preview is EMPTY:
1. Check R console for debug output
2. Look for errors in browser console (F12)
3. Verify `species_data()` is not null in R console
4. Check if DataTable wrapper div exists in HTML (inspect element)

### If Button Does Nothing:
1. Check browser console for JavaScript errors
2. Verify button ID is "load_sample"
3. Check if dropdown has a value selected
4. Look for R console output showing button was clicked

### If Styling is Wrong:
1. Hard refresh: `CTRL + SHIFT + R`
2. Check if CSS file loaded: Browser DevTools → Network tab → look for `prototype-styles.css?v=6`
3. Check if all imports loaded without 404 errors

## DEBUG COMMANDS

### Check if app is running:
```powershell
Get-Process | Where-Object {$_.ProcessName -eq "Rterm" -or $_.ProcessName -eq "R"}
```

### Check port 9054:
```powershell
Get-NetTCPConnection -LocalPort 9054
```

### View R console output:
- If running in terminal: output appears directly
- If running in RStudio: check R Console pane

## EXPECTED R CONSOLE OUTPUT (Successful Load)
```
=== LOAD SAMPLE BUTTON CLICKED ===
sample_dataset value: dune
Loading dune dataset...
Dune data stored. Rows: 20
=== SAMPLE DATA LOADING COMPLETE ===

DataTable rendering triggered
species_data is null: FALSE
Showing actual data with 20 rows
```

## SUCCESS CRITERIA
✅ All 6 tests pass
✅ No JavaScript errors in console
✅ No R errors in console
✅ Data preview shows actual data
✅ All navigation works
✅ UI is properly styled
