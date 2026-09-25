# Export Features - NMDS Module

> ⚠️ **Legacy document (Ördin 3.x).** This describes the R Shiny + Electron
> application in `shiny/` and `src/`, which is kept for maintenance only.
> For the current release see [Documentation Index](../DOCS-INDEX.md) ·
> [Quick Start](../QUICKSTART.md) · [Architecture](../ARCHITECTURE.md).

**Author:** Jimmy Moses (jmoses@pnguot.ac.pg)  
**Date:** 2025-10-25  
**Status:** All export features implemented ✅

---

## Available Export Options

### 1. 💾 Export PNG (Plot)

**Location:** Plot panel (below the ordination plot)  
**Status:** ✅ Fully Functional

**What it exports:**
- High-resolution NMDS ordination plot
- Resolution: 2400 × 1800 pixels at 300 DPI (publication quality)
- Includes stress annotation with grade
- Green sample points with black borders

**Filename format:** `nmds_plot_k2_2025-10-25.png`

**Use case:** 
- Insert into publications
- Add to presentations
- Share plots with collaborators

---

### 2. 📋 Export Results (CSV)

**Location:** Results panel (right sidebar)  
**Status:** ✅ Fully Functional

**What it exports:**
- NMDS site scores (coordinates for each sample)
- Dimensions: NMDS1, NMDS2, (NMDS3 if k=3, etc.)
- Sample names as a column

**Filename format:** `nmds_results_2025-10-25.csv`

**CSV Structure:**
```csv
Sample,NMDS1,NMDS2
Site1,-0.2345,0.1234
Site2,0.4567,-0.3456
...
```

**Use case:**
- Further statistical analysis in R/Python
- Import into Excel for custom plots
- Archive numerical results

---

### 3. 📄 Generate Report (PDF)

**Location:** Results panel (right sidebar)  
**Status:** ✅ **NEWLY IMPLEMENTED!**

**What it includes:**

#### Page 1: Analysis Overview & Quality Assessment
- Dataset information (sites, species, distance metric)
- **Stress interpretation box** (colored, same as app)
- Quality grade (A+, A, B, C)
- Convergence status
- Detailed recommendations

#### Page 2: NMDS Ordination Plot
- High-resolution plot (same as PNG export)
- Stress annotation with grade
- Grid for reference
- Publication-ready quality

#### Page 3: Statistics Table
- Complete ordination statistics
- Stress, grade, convergence, dimensions, distance, iterations

#### Page 4+: Site Scores Table
- Full table of NMDS coordinates
- Sample names and all dimensions
- Formatted for readability

#### Final Pages: Methods & References
- **Methods section** explaining NMDS
- Distance metric description
- Stress interpretation guidelines (Clarke 1993)
- **Full citations** (Clarke 1993, vegan package)
- Report metadata (date, author, institution)

**Filename format:** `nmds_report_2025-10-25.pdf`

**Features:**
- Professional formatting with headers/footers
- Page numbers
- Table of contents (optional)
- Publication-ready
- Includes full methodological details

**Use case:**
- Submit with manuscripts
- Share complete analysis with supervisors
- Archive full analysis records
- Teaching/training materials

---

## Technical Implementation

### Dependencies Required

```r
library(rmarkdown)  # PDF generation
library(knitr)      # Table formatting
library(tinytex)    # LaTeX backend (for PDF)
```

### Template File

**Location:** `shiny/templates/nmds_report.Rmd`

**Format:** R Markdown with YAML header

**Customizable parameters:**
- `nmds_result` - The vegan NMDS object
- `distance` - Distance metric used
- `k` - Number of dimensions
- `stress_interp` - Interpretation object
- `dataset_name` - Name of the dataset

### PDF Generation Process

1. User clicks "📄 Generate Report (PDF)"
2. App shows loading spinner: "Generating PDF Report..."
3. Interpretation object created using `interpretNMDSStress()`
4. Parameters passed to R Markdown template
5. `rmarkdown::render()` creates PDF
6. Success notification shown
7. PDF downloads automatically

**Generation time:** ~5-10 seconds (depending on dataset size)

---

## File Locations

```
ordin/
├── shiny/
│   ├── modules/
│   │   └── ordination_module.R    [Export handlers implemented]
│   ├── templates/
│   │   └── nmds_report.Rmd             [PDF template - NEW!]
│   └── utils/
│       └── interpretation.R             [Stress interpretation logic]
```

---

## Usage Instructions

### For Users

**Export PNG:**
1. Run NMDS analysis
2. Scroll to plot area
3. Click "💾 Export PNG" button
4. Save file to desired location

**Export CSV:**
1. Run NMDS analysis
2. Check statistics table on right
3. Click "📋 Export Results (CSV)" button
4. Open in Excel/R for further analysis

**Generate PDF Report:**
1. Run NMDS analysis
2. Wait for results to display
3. Click "📄 Generate Report (PDF)" button
4. Wait 5-10 seconds for generation
5. PDF downloads automatically
6. Share or archive the complete report

---

## Example Output Files

### PNG Export
- File size: ~100-500 KB
- Resolution: 2400×1800 px (300 DPI)
- Format: Portable Network Graphics
- Color: Full color with transparency support

### CSV Export
- File size: ~1-10 KB (depends on # of sites)
- Format: Comma-separated values
- Encoding: UTF-8
- Compatible with: Excel, R, Python, SPSS

### PDF Report
- File size: ~50-200 KB
- Pages: 4-10 (depends on # of sites)
- Format: Adobe PDF
- Fonts: Embedded (portable)
- Compatible with: Any PDF reader

---

## Quality Assurance

All export functions have been tested with:
- ✅ Small datasets (dune: 20 sites)
- ✅ Medium datasets (varespec: 24 sites)
- ✅ Large datasets (BCI: 50 sites)
- ✅ Different k values (2, 3, 4 dimensions)
- ✅ Different distance metrics (Bray-Curtis, Jaccard, Euclidean)

**Error handling:**
- Missing data checks
- File permission validation
- PDF generation error catching
- User-friendly error messages

---

## Future Enhancements

**Planned for Phase 2:**

1. **Interactive PDF** (with bookmarks)
2. **Custom branding** (logo, institution name)
3. **Multiple language support** (English, Spanish, etc.)
4. **Batch export** (multiple analyses → one PDF)
5. **Word document export** (.docx format)
6. **Species scores plot** (optional in report)
7. **Environmental fitting** (if env data loaded)

---

## Troubleshooting

### "PDF generation failed"

**Cause:** tinytex not installed  
**Solution:** Install tinytex in R:
```r
install.packages("tinytex")
tinytex::install_tinytex()
```

### "File download blocked"

**Cause:** Browser security settings  
**Solution:** Allow downloads from localhost in browser settings

### "Report is blank"

**Cause:** No NMDS results available  
**Solution:** Run NMDS analysis first, then generate report

---

## Citation

When using exported results in publications, please cite:

**Ördin:**
> Moses, J. (2025). Ördin v3.0: An open-source cross-platform community ecology analysis software. Papua New Guinea University of Technology.

**NMDS Method:**
> Clarke, K.R. (1993). Non-parametric multivariate analyses of changes in community structure. *Australian Journal of Ecology*, 18(1), 117-143.

**Vegan Package:**
> Oksanen, J., et al. (2024). vegan: Community Ecology Package. R package version 2.6-8.

---

**Status:** All export features complete and production-ready! ✅

**Last Updated:** 2025-10-25  
**Maintained By:** Jimmy Moses (jmoses@pnguot.ac.pg)
