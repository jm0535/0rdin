# Ördin v3.0 - Data Management Module

## Overview
The **Data Management** tab provides a professional, Excel-like interface for importing, editing, and managing community ecology datasets. This module supports dual datasets (species + environment) and cloud integration, following best practices from CANOCO and vegan workflows.

---

## Key Features

### 🗂️ **Excel-Like Spreadsheet Editor**
- Real-time cell editing
- Column renaming
- Row label modification
- Data type configuration (numeric, categorical, logical, text)
- Copy/paste functionality

### ☁️ **Multi-Source Import**
- **Local Files**: CSV, Excel (.xlsx), Tab-delimited (.txt)
- **Google Drive**: Direct import from shareable links
- Automatic file format detection

### 🔬 **Dual Dataset Support**
- **Species Composition Data**: Community abundance/presence matrices
- **Environment Data**: Environmental variables (pH, temperature, nutrients, etc.)
- Synchronized row labels (sites) across datasets
- Essential for constrained ordination (CCA, RDA)

### 🛠️ **Data Operations**
- Export edited data (CSV format)
- Reset to original imported data
- Clear all datasets
- Real-time data validation

---

## User Interface

### Navigation
Access the Data Management tab:
1. Click **"Data"** in the main navigation bar (second tab after Home)
2. Icon: 🗄️ database

### Layout Structure

#### **Sidebar (Left)**
- Data Import controls
- Dataset Configuration
- Data Operations buttons

#### **Main Area (Center/Right)**
- Dataset tabs (Species | Environment)
- Column Configuration panel
- Excel-like spreadsheet view
- Data statistics display

---

## Import Workflows

### 1. Local File Import

#### **Step 1: Select Data Source**
```
☑️ Local File
⬜ Google Drive
```

#### **Step 2: Choose File**
- Click **"Browse..."**
- Supported formats: `.csv`, `.xlsx`, `.txt`
- First column: Site/Sample names
- Other columns: Species or variables

#### **Example Species Data Structure**
```csv
Site,Species_A,Species_B,Species_C,Species_D
Site1,5,12,0,3
Site2,8,0,15,7
Site3,3,9,11,2
```

#### **Step 3: Data Loads Automatically**
- Professional spinner appears
- Validation performed
- Success notification: "✓ Data loaded: X rows × Y columns"

---

### 2. Google Drive Import

#### **Step 1: Prepare Google Drive File**
1. Upload your CSV file to Google Drive
2. Right-click file → **"Get link"**
3. Set sharing to **"Anyone with the link"**
4. Copy the shareable link

#### **Step 2: Import to Ördin**
1. Select **"Google Drive"** as data source
2. Paste the shareable link in text field
3. Click **"Import from Google Drive"**

#### **Supported URL Formats**
```
https://drive.google.com/file/d/FILE_ID/view?usp=sharing
https://drive.google.com/open?id=FILE_ID
```

#### **Troubleshooting**
- ❌ **Error**: "Failed to import from Google Drive"
  - **Solution**: Ensure file sharing is set to "Anyone with the link"
  - **Solution**: Check that the URL is correct
  - **Solution**: File must be in CSV format

---

### 3. Dual Dataset Import (Species + Environment)

For constrained ordination analyses (CCA, RDA, dbRDA), you need both datasets:

#### **Step 1: Select Dataset Type**
```
⬜ Species Data Only
☑️ Species + Environment
```

#### **Step 2: Import Species Data**
- Use Local File or Google Drive
- Matrix format: Sites × Species

#### **Step 3: Import Environment Data**
- New file upload appears: **"Environment Dataset"**
- Click **"Browse..."** under Environment section
- Select environment file

#### **Example Environment Data Structure**
```csv
Site,pH,Temperature,Nitrogen,Phosphorus
Site1,6.5,18.2,12.5,2.3
Site2,7.1,19.5,15.2,3.1
Site3,6.8,17.8,11.1,1.9
```

#### **⚠️ Important Requirements**
- **Same row labels**: Environment data must have identical site names as species data
- **Matching order**: Not required - Ördin will match by site names
- **Data types**: Can mix numeric and categorical variables

---

## Excel-Like Editing

### Column Configuration

#### **Change Column Data Types**
1. Locate **"Column Configuration"** panel
2. Each column shows current data type
3. Click dropdown to change type:
   - **Numeric**: Numbers, measurements (default for species abundance)
   - **Text**: Character strings, site names
   - **Categorical**: Factors, groups (useful for environment variables)
   - **Logical**: TRUE/FALSE values

#### **Example Use Cases**
- Site names → **Text**
- Species abundance → **Numeric**
- Habitat type → **Categorical**
- Presence/Absence → **Logical**

### Editing Cells

#### **Single Cell Edit**
1. Click any cell in the spreadsheet
2. Type new value
3. Press `Enter` or click outside
4. Notification: "Cell updated"

#### **Column Names**
- Click column header (not yet implemented in current version)
- Future: Double-click to edit

#### **Row Labels**
- First column contains row names (sites)
- Editable like any other cell

### Table Features

#### **Built-in Buttons**
- **Copy**: Copy selected data to clipboard
- **Excel**: Export table to Excel format
- **CSV**: Export table to CSV format

#### **Pagination**
- Default: 25 rows per page
- Use page controls at bottom
- Scrollable for large datasets

#### **Scrolling**
- Horizontal scroll: For many columns
- Vertical scroll: For many rows (500px height)

---

## Data Operations

### Export Edited Data

#### **Step 1: Click "Export Edited Data"**
- Button located in sidebar → Data Operations

#### **Step 2: Choose Dataset**
- **Download Species Data**: Exports edited species matrix
- **Download Environment Data**: Exports edited environment variables (if loaded)

#### **File Format**
- Format: CSV
- Filename: `species_data_edited_YYYY-MM-DD.csv`
- Includes all edits and changes

### Reset to Original

#### **Purpose**
Discard all edits and restore original imported data

#### **Steps**
1. Click **"Reset to Original"** button
2. Confirmation: "Species data reset to original"
3. All edits are lost (cannot be undone)

### Clear All Data

#### **Purpose**
Remove all loaded datasets from memory

#### **Steps**
1. Click **"Clear All Data"** button
2. Confirmation dialog appears:
   - **Title**: "Clear All Data?"
   - **Message**: "This will remove all loaded datasets. This action cannot be undone."
3. Click **"Yes, clear it!"** to confirm
4. Both species and environment data are removed

#### **⚠️ Warning**
- This action is permanent
- All edits are lost
- Re-import files to restore data

---

## Use Cases

### Use Case 1: Basic Data Editing

**Scenario**: Fix typos in uploaded dataset

1. Import CSV file
2. Navigate to Data tab
3. Click cell with typo
4. Enter correct value
5. Export edited data

### Use Case 2: Constrained Ordination Workflow

**Scenario**: Prepare data for CCA analysis

1. Import species composition matrix (sites × species)
2. Select "Species + Environment" dataset type
3. Import environmental variables (sites × env factors)
4. Verify matching site names in both datasets
5. Edit data types:
   - Species abundance → **Numeric**
   - pH, temperature → **Numeric**
   - Habitat type → **Categorical**
6. Export both datasets
7. Navigate to Ordination tab
8. Datasets are automatically available for CCA/RDA

### Use Case 3: Google Drive Collaboration

**Scenario**: Work with remote collaborator's data

1. Collaborator uploads data to Google Drive
2. Collaborator shares link (public access)
3. You paste link in Ördin
4. Import and edit data
5. Export edited version
6. Share back with collaborator

### Use Case 4: Data Type Conversion

**Scenario**: Convert numeric codes to categorical

1. Import data with coded values (1, 2, 3 = Habitat types)
2. Column Configuration panel
3. Change column type from **Numeric** to **Categorical**
4. Edit cell values to labels ("Forest", "Grassland", "Wetland")
5. Export for analysis

---

## Dataset Integration

### Automatic Detection

Ördin automatically detects your dataset configuration and applies it to analysis modules:

#### **Species Data Only**
- Available for:
  - ✅ Diversity Estimation (iNEXT)
  - ✅ Diversity Indices (vegan)
  - ✅ Unconstrained Ordination (NMDS, PCA, CA, DCA, PCoA)

#### **Species + Environment**
- Available for:
  - ✅ All above analyses
  - ✅ Constrained Ordination (CCA, RDA, dbRDA)
  - ✅ Environmental fitting
  - ✅ Permutation tests

### Data Flow

```
Data Tab (Import & Edit)
    ↓
Automatic Validation
    ↓
Available in Analysis Tabs
    ├→ Diversity Analysis
    ├→ Ordination Analysis
    └→ Additional Analyses (future)
```

---

## Technical Specifications

### File Format Support

| Format | Extension | Read | Edit | Export |
|--------|-----------|------|------|--------|
| CSV | `.csv` | ✅ | ✅ | ✅ |
| Excel | `.xlsx` | ✅ | ✅ | ✅ |
| Tab-delimited | `.txt` | ✅ | ✅ | ✅ |
| Google Sheets | Web link | ✅ via export | ✅ | ✅ |

### Data Type Support

| Type | Description | Example Values | Suitable For |
|------|-------------|----------------|--------------|
| Numeric | Numbers | 1.5, 42, -3.14 | Abundance, measurements |
| Character | Text strings | "Site_A", "Species" | Labels, names |
| Factor | Categorical | "Forest", "High", "Low" | Grouping variables |
| Logical | Boolean | TRUE, FALSE | Presence/absence |

### Size Limits

- **Maximum rows**: Limited by browser memory (~100,000 rows practical)
- **Maximum columns**: ~1,000 columns (performance may degrade)
- **File size**: Up to 50 MB recommended for smooth performance

### Browser Compatibility

| Browser | Version | Support |
|---------|---------|---------|
| Chrome | 90+ | ✅ Full support |
| Edge | 90+ | ✅ Full support |
| Firefox | 88+ | ✅ Full support |
| Safari | 14+ | ✅ Full support |

---

## Best Practices

### Data Preparation

#### ✅ **Do's**
1. **Consistent naming**: Use same site names across datasets
2. **No special characters**: Avoid `/`, `\`, `*` in column names
3. **Numeric precision**: Keep 2-4 decimal places
4. **Missing values**: Use `0` for absences, `NA` for true missing data
5. **Header row**: Always include column headers in first row

#### ❌ **Don'ts**
1. Don't use spaces in column names (use underscores: `Species_A`)
2. Don't mix data types within columns
3. Don't leave empty columns
4. Don't use formula cells in Excel files
5. Don't include totals or summary rows

### Data Organization

#### **Species Matrix Structure**
```
Rows = Sites/Samples/Plots
Columns = Species/Taxa
Values = Abundance/Count/Biomass
```

#### **Environment Matrix Structure**
```
Rows = Sites (must match species matrix)
Columns = Environmental variables
Values = Measurements or categories
```

### Quality Checks

Before analysis, verify:
- ✅ No duplicate site names
- ✅ No completely empty rows or columns
- ✅ Numeric columns contain only numbers
- ✅ Site names match between species and environment data
- ✅ Reasonable value ranges (no negative abundances)

---

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+C` | Copy selected cells |
| `Ctrl+V` | Paste (browser dependent) |
| `Enter` | Confirm cell edit |
| `Esc` | Cancel cell edit |
| `Tab` | Move to next cell |
| `Shift+Tab` | Move to previous cell |

---

## Troubleshooting

### Problem: Data won't import

**Symptoms**: Error message after file selection

**Solutions**:
1. Check file format (CSV, XLSX, TXT only)
2. Ensure first row contains headers
3. Verify no corrupt cells or formulas
4. Try re-exporting from Excel as CSV
5. Check file encoding (UTF-8 recommended)

### Problem: Google Drive import fails

**Symptoms**: "Failed to import from Google Drive" error

**Solutions**:
1. Verify file sharing is set to "Anyone with the link"
2. Check URL format is correct
3. Ensure file is in CSV format (not Google Sheets native)
4. Try downloading file locally and using Local File import

### Problem: Cell edits not saving

**Symptoms**: Changes disappear after clicking away

**Solutions**:
1. Press `Enter` after editing cell
2. Check browser console for errors
3. Try refreshing page and re-importing data
4. Export data to save changes

### Problem: Environment data not detected

**Symptoms**: Environment table doesn't appear

**Solutions**:
1. Verify "Species + Environment" is selected
2. Check environment file uploaded successfully
3. Ensure site names match species data exactly
4. Look for success notification message

### Problem: Column type won't change

**Symptoms**: Dropdown changes but data stays same type

**Solutions**:
1. Current version: Column type changes are visual only
2. Cell values must be manually edited to match type
3. Future update will include automatic type conversion

---

## Comparison with Other Software

### Ördin vs CANOCO

| Feature | Ördin | CANOCO |
|---------|-------|--------|
| Data editing | ✅ In-browser spreadsheet | ⚠️ External editor required |
| Cloud import | ✅ Google Drive | ❌ Local only |
| Dual datasets | ✅ Built-in support | ✅ Built-in support |
| Real-time edits | ✅ Yes | ❌ Save & reload |
| Export formats | CSV | Multiple formats |

### Ördin vs vegan (R)

| Feature | Ördin | vegan |
|---------|-------|-------|
| Data editing | ✅ GUI spreadsheet | ⚠️ Code-based |
| Learning curve | ✅ Low | ⚠️ Moderate-High |
| Flexibility | ⚠️ GUI-limited | ✅ Full R power |
| Reproducibility | ⚠️ Manual | ✅ Script-based |
| Collaboration | ✅ Easy sharing | ⚠️ Code sharing |

---

## Future Enhancements

### Planned Features (v3.1+)

1. **Advanced Editing**
   - ✨ Multi-cell selection and edit
   - ✨ Find and replace
   - ✨ Sort columns
   - ✨ Filter rows

2. **Data Transformation**
   - ✨ Log transformation
   - ✨ Standardization
   - ✨ Rarefaction
   - ✨ Presence/absence conversion

3. **Import/Export**
   - ✨ Dropbox integration
   - ✨ OneDrive support
   - ✨ Direct Google Sheets API
   - ✨ RData format support

4. **Validation**
   - ✨ Data quality checker
   - ✨ Outlier detection
   - ✨ Missing data report
   - ✨ Matrix symmetry check

5. **Visualization**
   - ✨ Data preview plots
   - ✨ Variable distributions
   - ✨ Correlation heatmaps
   - ✨ Missing data patterns

---

## API Reference (Advanced)

### Reactive Values

```r
dataManagement <- reactiveValues(
  speciesData = NULL,          # Current species matrix
  envData = NULL,              # Current environment matrix
  speciesOriginal = NULL,      # Original species (for reset)
  envOriginal = NULL,          # Original environment (for reset)
  activeDataset = "species",   # Active tab: "species" or "env"
  columnTypes = NULL,          # Species column types
  envColumnTypes = NULL        # Environment column types
)
```

### Server Outputs

```r
output$hasData          # Logical: TRUE if species data loaded
output$hasEnvData       # Logical: TRUE if env data loaded
output$datasetTabs      # UI: Dataset tab buttons
output$dataInfo         # UI: Data dimensions display
output$columnTypeEditor # UI: Column type dropdowns
output$spreadsheetTable # DT: Editable species table
output$envSpreadsheetTable # DT: Editable environment table
```

---

## Version History

### v3.0 (Current)
- ✨ Initial Data Management module
- ✨ Excel-like spreadsheet editor
- ✨ Local file import (CSV, XLSX, TXT)
- ✨ Google Drive import
- ✨ Dual dataset support (species + environment)
- ✨ Real-time cell editing
- ✨ Column data type configuration
- ✨ Export edited data
- ✨ Reset to original functionality
- 🎨 Professional UI with color-coded datasets
- 📝 Comprehensive documentation

---

## Credits

**Author**: Jimmy Moses  
**Email**: jimmy.moses@pnguot.ac.pg  
**Version**: 3.0  
**Date**: 2025  

**Inspired by**:
- CANOCO (ter Braak & Šmilauer)
- vegan R package (Oksanen et al.)
- Excel data management workflows

---

## License

MIT License

Copyright (c) 2025 Jimmy Moses

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED.
