# 📊 Publication-Quality Plot Customization Guide

**Ördin v3.0** - Creating Publication-Ready Figures

Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)

---

## 🎯 Quick Start

Every analysis module (Diversity, Ordination) now includes a **"🎨 Plot Customization"** panel with publication-quality controls.

### Where to Find It:
- **Diversity Estimation (iNEXT):** Below parameter settings, above plot output
- **Ordination (NMDS, PCA, etc.):** In the plot configuration section

---

## 🎨 Customization Options

### **1. Plot Themes**

Choose from professional themes optimized for different publication venues:

| Theme | Best For | Description |
|-------|----------|-------------|
| **Classic (bw)** | General publications | Clean black & white with gridlines |
| **Minimal** | Modern journals | Minimal gridlines, clean look |
| **Light** | Presentations | Light gray background |
| **Dark** | Posters | Dark background (great for contrast) |
| **Publication (Nature)** | High-impact journals | Classic style matching Nature/Science |

**How to use:**
```
1. Click "🎨 Plot Customization" to expand
2. Select theme from "Plot Theme" dropdown
3. Plot updates automatically
```

---

### **2. Typography Controls**

Fine-tune text appearance for readability:

- **Font Size:** 8-24pt (default: 12pt)
  - Journals typically require 10-12pt
  - Posters need 16-20pt
  - Presentations: 14-18pt

- **Recommended Settings:**
  ```
  Journal article: 10-12pt
  Poster (A1):     18-20pt
  Presentation:    16pt
  Thesis:          12pt
  ```

---

### **3. Visual Elements**

#### **Line Width**
- Range: 0.5 - 3.0
- Default: 1.0
- **Recommendations:**
  - Screen viewing: 1.0
  - Print (journals): 0.75
  - Posters: 1.5-2.0

#### **Point Size**
- Range: 1 - 8
- Default: 3
- **Recommendations:**
  - Dense plots: 2-3
  - Sparse plots: 3-4
  - Emphasis: 5-6

#### **Legend Position**
- Options: Right, Left, Top, Bottom, None
- **Best practices:**
  - **Right:** Default, works for most plots
  - **Bottom:** Wide plots, presentations
  - **None:** Composite figures (add legend in graphics software)

---

### **4. Custom Labels**

Override default labels for clarity:

#### **Plot Title**
- Leave empty for no title
- Example: `"Rarefaction Curves for Tropical Forest Sites"`

#### **X-axis Label**
- Override default axis names
- Example: `"Number of Individuals"` instead of `"Sample size"`

#### **Y-axis Label**
- Use proper formatting
- Example: `"Species Richness (q=0)"` instead of generic label

**LaTeX-style formatting (for some journals):**
```
Title: "Diversity Estimates ($q$ = 0, 1, 2)"
X-axis: "Sample Size ($m$)"
Y-axis: "$^{q}D$ (Hill Number)"
```

---

### **5. Color Palettes**

Choose colors based on your needs:

| Palette | Colors | Best For |
|---------|--------|----------|
| **Ördin Default** | Green-Blue-Gold | General use, branding |
| **Viridis** | Purple-Green gradient | Sequential data, colorblind-safe |
| **Plasma** | Purple-Orange gradient | High contrast |
| **Colorblind Safe** | Wong's palette | Accessibility (8 distinct colors) |
| **Grayscale** | Black to white | B&W print journals |
| **Publication (Black)** | All black | Line plots for conservative journals |

**Accessibility tip:** Always use **Colorblind Safe** palette for publications to ensure readability for 8% of male readers with color vision deficiency.

---

### **6. Export Settings**

Control output quality for different uses:

#### **Dimensions**

**Width & Height (inches):**
- **Single-column journal:** 3.5" × 3.5"
- **Double-column journal:** 7" × 5"
- **Full page:** 8.5" × 6.5"
- **Poster panel:** 12" × 8"
- **Presentation slide:** 10" × 6"

**Standard sizes:**
```
Nature/Science:  3.5" (single), 7" (double)
PLOS:           3.27" (single), 6.83" (double)
Ecology:        3.5" (single), 7.5" (double)
```

#### **DPI (Resolution):**

| DPI | Use Case | File Size |
|-----|----------|-----------|
| **150** | Screen viewing, web | Small (~500 KB) |
| **300** | Print journals (required) | Medium (~2 MB) |
| **600** | High-resolution print, posters | Large (~8 MB) |

**Journal requirements:**
- Most journals require **300 DPI minimum**
- Nature/Science: 300-600 DPI
- Some journals specify 600 DPI for line art

---

## 📁 Export Formats

### **PNG**
- **Best for:** Quick sharing, presentations, web
- **Pros:** Universal compatibility, small file size
- **Cons:** Raster format (pixelated when zoomed)
- **Use 300 DPI for print quality**

### **PDF**
- **Best for:** Journals, publications, print
- **Pros:** Vector format (infinite zoom), editable text
- **Cons:** Larger file size
- **Journal preferred format**

### **SVG**
- **Best for:** Further editing in Illustrator/Inkscape
- **Pros:** Vector format, fully editable
- **Cons:** Some journals don't accept SVG
- **Use for creating composite figures**

---

## 🎯 Workflow: Journal Submission

### **Step 1: Generate Plot with Custom Settings**

```r
# In Ördin:
1. Run your analysis (iNEXT, NMDS, etc.)
2. Click "🎨 Plot Customization"
3. Configure:
   - Theme: "Publication (Nature)"
   - Font Size: 10
   - Line Width: 0.75
   - Legend: Right
   - Color Palette: "Colorblind Safe"
```

### **Step 2: Add Custom Labels**

```r
4. Add labels:
   - Title: Leave empty (add in manuscript)
   - X-axis: "Sample Size (individuals)"
   - Y-axis: "Species Richness"
```

### **Step 3: Set Export Parameters**

```r
5. Export settings:
   - Width: 3.5" (single column) or 7" (double)
   - Height: 3.5" or 5"
   - DPI: 300
```

### **Step 4: Export**

```r
6. Click "💾 Export PDF" or "Export PNG"
7. File saves to Downloads folder
8. Check file in journal's submission system
```

---

## 📋 Publication Checklist

Before submitting figures to journals:

- [ ] **Resolution:** 300 DPI minimum (check journal requirements)
- [ ] **Size:** Matches journal's column width
- [ ] **Colors:** Colorblind-safe if possible
- [ ] **Font size:** Readable at final print size (10-12pt)
- [ ] **Labels:** Clear, no jargon, units specified
- [ ] **Legend:** Positioned appropriately, not overlapping data
- [ ] **File format:** PDF for vector graphics, high-res PNG for raster
- [ ] **File name:** Descriptive (e.g., `Fig2_NMDS_tropical_sites.pdf`)
- [ ] **Testing:** Print figure at actual size to check readability

---

## 🔬 Advanced Techniques

### **Creating Multi-Panel Figures**

For composite figures (Figure 1A, 1B, 1C):

1. **Export individual panels:**
   - Use **SVG format** for maximum editability
   - Keep consistent sizes (e.g., all 3.5" × 3.5")
   - Use same font size across panels

2. **Combine in graphics software:**
   - Adobe Illustrator (recommended)
   - Inkscape (free alternative)
   - PowerPoint (quick assembly)

3. **Add panel labels:**
   - Add (A), (B), (C) labels in graphics software
   - Use same font as figure (Arial/Helvetica)
   - Bold, 12-14pt

4. **Final export:**
   - Export combined figure as PDF (300 DPI)
   - Check file size < 10 MB

---

### **Nature/Science Style Figures**

Requirements for high-impact journals:

```
Theme: Publication (Nature)
Font: 7-8pt (small for dense info)
Size: 89 mm (3.5") single, 183 mm (7.2") double
DPI: 300-600
Format: PDF or EPS
Colors: Limit to 3-4, colorblind-safe
```

**Example settings:**
```
Width: 3.5" or 7"
Height: Variable (maintain aspect ratio)
Font Size: 8pt
Line Width: 0.5
DPI: 600 (for line art)
Color Palette: Colorblind Safe
```

---

### **Grayscale for Print Journals**

Some journals print in black & white:

1. Use **Grayscale** color palette
2. Differentiate lines with:
   - Different line types (solid, dashed, dotted)
   - Different symbols (circle, square, triangle)
3. Test by printing figure in B&W
4. Ensure patterns are distinguishable

---

## 🎨 Color Palette Reference

### **Ördin Default**
```
Green:  #2e8b57 (primary)
Blue:   #007acc (secondary)
Gold:   #d4a017 (accent)
```

### **Wong's Colorblind-Safe Palette**
```
Orange:      #E69F00
Sky Blue:    #56B4E9
Green:       #009E73
Yellow:      #F0E442
Dark Blue:   #0072B2
Vermillion:  #D55E00
Purple:      #CC79A7
Black:       #000000
```

---

## 💡 Pro Tips

1. **Test early:** Export test figure and check in journal template
2. **Consistency:** Use same settings across all figures in manuscript
3. **Simplicity:** Remove unnecessary gridlines, borders
4. **White space:** Don't cram too much in one figure
5. **Colorblind check:** Use online tools (coblis.com) to simulate
6. **File backup:** Keep high-res originals, can always compress later
7. **Version control:** Save settings, note them in methods section

---

## 📚 Journal-Specific Guidelines

### **Nature**
- Single column: 89 mm (3.5")
- Double column: 183 mm (7.2")  
- DPI: 300-600
- Format: PDF, EPS
- Font: Arial 7-8pt

### **Science**
- Single column: 5.5 cm (2.17")
- Double column: 12 cm (4.72")
- DPI: 300
- Format: PDF, EPS
- Font: Helvetica 6-8pt

### **PLOS ONE**
- Single column: 83 mm (3.27")
- Double column: 173.5 mm (6.83")
- DPI: 300-600
- Format: TIFF, PNG, EPS
- Font: Arial 8-12pt

### **Ecology/Ecological Monographs**
- Single column: 3.5"
- Double column: 7.5"
- DPI: 300
- Format: PDF, TIFF
- Font: Times or Helvetica 8-10pt

---

## 🆘 Troubleshooting

**Problem:** Text too small in exported figure
- **Solution:** Increase font size to 12-14pt before export

**Problem:** Colors look different in PDF vs screen
- **Solution:** Use RGB color mode for screen, CMYK for print (convert in graphics software)

**Problem:** File size too large (> 10 MB)
- **Solution:** Reduce DPI to 300, or use PNG instead of TIFF

**Problem:** Legend overlaps data
- **Solution:** Move legend position, or export without legend and add externally

**Problem:** Lines too thin in print
- **Solution:** Increase line width to 1.0-1.5

---

## 📖 Further Reading

- **ggplot2 documentation:** https://ggplot2.tidyverse.org/
- **Colorblind-safe palettes:** https://personal.sron.nl/~pault/
- **Nature figure guidelines:** https://www.nature.com/nature/for-authors/final-submission
- **PLOS figure guidelines:** https://journals.plos.org/plosone/s/figures

---

**Author:** Jimmy Moses (jimmy.moses@pnguot.ac.pg)  
**Project:** Ördin v3.0 - Community Ecology Analysis  
**License:** MIT (Open Source)  
**Last Updated:** 2025-10-29
