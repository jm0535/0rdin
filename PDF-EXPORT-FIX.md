# PDF Export Fix - Ördin v3.0

**Status:** ✅ COMPLETE  
**Date:** 2025-10-25  
**Author:** Jimmy Moses (jmoses@pnguot.ac.pg)

## Overview

Fixed PDF report generation in Ördin by properly configuring all dependencies required for R Markdown to PDF conversion.

## Problem

PDF export was failing with error:
```
Error generating PDF: pandoc version 1.12.3 or higher is required and was not found
```

## Root Cause

The PDF generation pipeline requires three main components:
1. **R packages** (`rmarkdown`, `knitr`, `tinytex`)
2. **Pandoc** (document converter) - was missing
3. **LaTeX** (PDF rendering engine) - was partially configured

## Solution Implemented

### 1. Added Core Report Generation Packages

Updated [`install-v3-packages.R`](install-v3-packages.R) to include:

```r
# Report generation (PDF/HTML/Word)
"rmarkdown",        # R Markdown document generation
"tinytex",          # LaTeX backend for PDF reports
"knitr",            # Dynamic report generation
"quarto",           # Next-generation scientific publishing
"flextable",        # Professional tables for reports
"officer"           # Word/PowerPoint document generation
```

These packages are now part of the core Ördin installation and will be installed automatically.

### 2. Installed Pandoc

Pandoc was installed using Windows Package Manager (winget):

```powershell
winget install --id=JohnMacFarlane.Pandoc -e --silent
```

**Installed version:** 3.8.2.1  
**Location:** `C:\Users\[USER]\AppData\Local\Pandoc`

### 3. Configured TinyTeX

TinyTeX (minimal LaTeX distribution) was already installed but needed verification:

```r
# In R console
tinytex::is_tinytex()  # Verify installation
```

**Location:** `C:\Users\[USER]\AppData\Roaming\TinyTeX`

### 4. Enhanced Error Handling in NMDS Module

Updated [`shiny/modules/ordination_nmds_module.R`](shiny/modules/ordination_nmds_module.R) with comprehensive error checking:

```r
# Check if pandoc is available
pandoc_available <- rmarkdown::pandoc_available()

if (!pandoc_available) {
  showNotification(
    HTML("<strong>❌ Pandoc not found</strong><br/>Please install..."),
    type = "error"
  )
  return()
}

# Verify pandoc version
pandoc_version <- rmarkdown::pandoc_version()
if (pandoc_version < "1.12.3") {
  showNotification(
    HTML("Pandoc version too old..."),
    type = "error"
  )
  return()
}

# Check if tinytex is installed
if (!tinytex::is_tinytex()) {
  showNotification(
    HTML("LaTeX not installed..."),
    type = "error"
  )
  return()
}
```

The error handling now provides:
- Clear error messages with HTML formatting
- Specific solutions for each failure type
- Detection of Pandoc, LaTeX, and package issues
- Non-dismissible notifications for critical errors

### 5. Created Verification Script

Created [`verify-pdf-setup.R`](verify-pdf-setup.R) to check PDF export dependencies:

```bash
# Run verification
"C:\Program Files\R\R-4.5.1\bin\Rscript.exe" verify-pdf-setup.R
```

Output shows:
- ✅ All R packages installed
- ✅ Pandoc version and location
- ✅ TinyTeX/LaTeX availability
- ✅ Overall PDF export readiness

## Installation Commands

### For New Users

1. **Install R packages:**
   ```bash
   "C:\Program Files\R\R-4.5.1\bin\Rscript.exe" install-v3-packages.R
   ```

2. **Install Pandoc (Windows):**
   ```powershell
   winget install --id=JohnMacFarlane.Pandoc -e --silent
   ```

3. **Install TinyTeX (if not already installed):**
   ```r
   # In R console
   tinytex::install_tinytex()
   ```

4. **Verify setup:**
   ```bash
   "C:\Program Files\R\R-4.5.1\bin\Rscript.exe" verify-pdf-setup.R
   ```

### Alternative: Manual Pandoc Installation

If winget is not available:
1. Download from: https://pandoc.org/installing.html
2. Run the installer
3. Restart PowerShell/R session

## Verification

After installation, running `verify-pdf-setup.R` should show:

```
═══════════════════════════════════════════════════════════════
  ✅ SUCCESS! PDF export is fully configured
═══════════════════════════════════════════════════════════════

📦 Checking R Packages:
  ✅ rmarkdown (v2.30)
  ✅ knitr (v1.50)
  ✅ tinytex (v0.57)
  ✅ flextable (v0.9.10)
  ✅ officer (v0.7.0)

🔧 Checking Pandoc:
  ✅ Pandoc is installed
     Version: 3.8.2.1
     ✅ Version is sufficient (≥ 1.12.3)

📝 Checking LaTeX (TinyTeX):
  ✅ TinyTeX is installed
  ✅ pdflatex is available
```

## Testing

1. Start the Shiny app
2. Navigate to NMDS analysis
3. Load sample data and run NMDS
4. Click "📄 Generate Report (PDF)"
5. PDF should download successfully

## Files Modified

- [`install-v3-packages.R`](install-v3-packages.R) - Added report generation packages
- [`shiny/modules/ordination_nmds_module.R`](shiny/modules/ordination_nmds_module.R) - Enhanced error handling
- [`verify-pdf-setup.R`](verify-pdf-setup.R) - New verification script

## Dependencies

### R Packages
- `rmarkdown` (v2.30) - Document rendering
- `knitr` (v1.50) - Dynamic reports
- `tinytex` (v0.57) - LaTeX management
- `quarto` (v1.5.1) - Scientific publishing
- `flextable` (v0.9.10) - Professional tables
- `officer` (v0.7.0) - Office document generation

### System Dependencies
- **Pandoc** v3.8.2.1 (≥ 1.12.3 required)
- **TinyTeX** (minimal LaTeX distribution)

## Future Improvements

1. **Auto-installation**: Consider automatic Pandoc installation via R
2. **Alternative formats**: Add HTML and Word report options
3. **Enhanced templates**: Improve PDF report styling
4. **Batch export**: Allow exporting multiple analyses at once
5. **Custom templates**: Let users customize report templates

## Troubleshooting

### "Pandoc not found"
```powershell
# Install via winget
winget install --id=JohnMacFarlane.Pandoc -e

# Refresh PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + 
            [System.Environment]::GetEnvironmentVariable("Path","User")
```

### "LaTeX not installed"
```r
# Install TinyTeX
tinytex::install_tinytex()
```

### "Package not found"
```r
# Reinstall all packages
source("install-v3-packages.R")
```

## References

- [Pandoc Installation Guide](https://pandoc.org/installing.html)
- [TinyTeX Documentation](https://yihui.org/tinytex/)
- [R Markdown Guide](https://rmarkdown.rstudio.com/)
- [Quarto Documentation](https://quarto.org/)

---

**Note:** After installing Pandoc or updating PATH, you may need to restart R session for changes to take effect.
