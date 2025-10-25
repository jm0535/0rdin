# PDF Export Fix - NMDS Module

**Author:** Jimmy Moses (jmoses@pnguot.ac.pg)  
**Date:** 2025-10-25  
**Issue:** Report was exporting as HTML instead of PDF  
**Status:** ✅ FIXED

---

## Problem

User reported that clicking "Generate Report (PDF)" was downloading an HTML file instead of a PDF file. The browser's save dialog showed "HTML Document" as the file type.

---

## Root Causes

1. **Missing `contentType` parameter** in downloadHandler
   - Browser didn't know it was receiving a PDF
   - Defaulted to HTML interpretation

2. **Direct file path in `rmarkdown::render()`**
   - May have caused extension conflicts
   - Not explicitly forcing PDF output

3. **tinytex not in core package list**
   - Users would need to manually install LaTeX
   - No guarantee of PDF generation capability

---

## Solutions Implemented

### 1. Added `contentType =