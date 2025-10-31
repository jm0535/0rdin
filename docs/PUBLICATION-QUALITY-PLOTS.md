# Ördin: Publication-Quality Plot Export

**Feature**: Multi-format plot export with publication-quality settings  
**Date**: 2025-10-23  
**Author**: Jimmy Moses

---

## Overview

Ördin now supports exporting plots in **5 publication-quality formats**, all optimized for academic publishing, print, and digital media.

### Supported Formats

| Format | Type | DPI | Best For | File Size |
|--------|------|-----|----------|-----------|
| **PNG** | Raster | 300 | Web, presentations, manuscripts | Medium |
| **TIFF** | Raster | 300 | Journal submissions, print | Large |
| **JPEG** | Raster | 300 | Quick sharing, compressed | Small |
| **SVG** | Vector | N/A | Web, scaling, editing | Small-Medium |
| **PostScript** | Vector | N/A | LaTeX, high-end publishing | Medium |

---

## How to Use

### Step 1: Run Your Analysis
1. Upload your biodiversity data
2. Configure analysis parameters
3. Click **"Run Analysis"**

### Step 2: Select Export Format
Above the generated plot, you'll see:
```
[Format Dropdown ▼]  [Download Plot]
```

Choose your desired format from the dropdown:
- PNG (default)
- TIFF
- JPEG
- SVG
- PostScript

### Step 3: Download
Click **"Download Plot"** and the file will save with the selected format.

**Filename Format**:
```
ordin_[analysis-type]_plot_[date].[extension]

Examples:
- ordin_inext_plot_2025-10-23.png
- ordin_inext_plot_2025-10-23.tiff
- ordin_nmds_plot_2025-10-23.svg
```

---

## Format Details

### 📊 PNG (Portable Network Graphics)

**Specifications**:
- **Resolution**: 300 DPI
- **Dimensions**: 12" × 8" (3600 × 2400 pixels)
- **Color Space**: RGB
- **Transparency**: Supported
- **Compression**: Lossless

**Best For**:
- ✅ Online manuscripts (preprints, blog posts)
- ✅ PowerPoint/Keynote presentations
- ✅ Quick sharing via email
- ✅ General-purpose use

**Advantages**:
- Lossless compression (perfect quality)
- Widely supported
- Good balance of quality and file size
- Supports transparency

**Disadvantages**:
- Cannot be scaled without quality loss
- Larger file size than JPEG

---

### 📸 TIFF (Tagged Image File Format)

**Specifications**:
- **Resolution**: 300 DPI
- **Dimensions**: 12" × 8" (3600 × 2400 pixels)
- **Color Space**: RGB
- **Compression**: None (uncompressed)
- **Bit Depth**: 24-bit color

**Best For**:
- ✅ Journal manuscript submissions
- ✅ Print publications
- ✅ Archival storage
- ✅ Professional publishing

**Advantages**:
- Highest raster quality (uncompressed)
- Industry standard for print
- Accepted by all major journals
- Preserves maximum detail

**Disadvantages**:
- Very large file sizes
- Overkill for web use
- Slower to upload/download

**Journal Requirements**:
Most journals (Nature, Science, PLOS, etc.) accept TIFF at 300-600 DPI for figures.

---

### 🖼️ JPEG (Joint Photographic Experts Group)

**Specifications**:
- **Resolution**: 300 DPI
- **Dimensions**: 12" × 8" (3600 × 2400 pixels)
- **Color Space**: RGB
- **Compression**: Lossy (high quality)
- **Quality**: 95%

**Best For**:
- ✅ Email attachments (smaller size)
- ✅ Quick previews
- ✅ Social media sharing
- ✅ Compressed archiving

**Advantages**:
- Smallest file size
- Fast to share and upload
- Universally supported
- Good enough for most uses

**Disadvantages**:
- Lossy compression (slight quality loss)
- No transparency support
- Not ideal for text-heavy plots
- Quality degrades with re-saving

**Note**: While 300 DPI is maintained, JPEG's lossy compression may introduce artifacts. Use PNG or TIFF for final publications.

---

### 🎨 SVG (Scalable Vector Graphics)

**Specifications**:
- **Type**: Vector (resolution-independent)
- **Dimensions**: 12" × 8" (logical units)
- **Format**: XML-based
- **Scalability**: Infinite (no quality loss)

**Best For**:
- ✅ Web publishing (interactive journals)
- ✅ Scaling to any size (posters, banners)
- ✅ Editing in Illustrator/Inkscape
- ✅ Responsive web designs

**Advantages**:
- Perfect quality at any size
- Small file size
- Editable (text, colors, elements)
- Future-proof format
- Supported by modern browsers

**Disadvantages**:
- Not all journals accept SVG
- May render differently in different viewers
- Complex plots can have large file sizes
- Limited support in older software

**Use Cases**:
- Converting to PDF for LaTeX documents
- Creating poster-size figures
- Web-based interactive publications
- Modifying plots in vector editors

---

### 📄 PostScript (PS/EPS)

**Specifications**:
- **Type**: Vector (resolution-independent)
- **Dimensions**: 12" × 8"
- **Font**: Helvetica (embedded)
- **Paper**: Special (exact dimensions)
- **Color Space**: RGB

**Best For**:
- ✅ LaTeX documents
- ✅ High-end academic publishing
- ✅ Print production workflows
- ✅ Professional typography

**Advantages**:
- Industry standard for academic publishing
- Perfect for LaTeX (`\includegraphics`)
- High-quality print output
- Font embedding ensures consistency
- Device-independent

**Disadvantages**:
- Not widely supported in modern software
- Larger file size than SVG
- Requires specialized viewers (Ghostscript)
- Being replaced by PDF in many workflows

**LaTeX Integration**:
```latex
\begin{figure}[h]
  \centering
  \includegraphics[width=0.8\textwidth]{ordin_inext_plot_2025-10-23.ps}
  \caption{Species rarefaction curves generated with Ördin.}
  \label{fig:rarefaction}
\end{figure}
```

---

## Technical Implementation

### File Specifications

All formats use consistent dimensions:
- **Width**: 12 inches
- **Height**: 8 inches
- **Aspect Ratio**: 3:2 (standard for scientific figures)
- **Background**: Dark (#222222, matching Ördin's theme)

### Resolution Standards

**Raster Formats (PNG, TIFF, JPEG)**:
- **DPI**: 300 (publication quality)
- **Pixel Dimensions**: 3600 × 2400 pixels
- **Print Size**: 12" × 8" at 300 DPI

**Vector Formats (SVG, PostScript)**:
- Resolution-independent (scales infinitely)
- Logical dimensions: 12" × 8"
- Perfect for any output size

### Quality Settings

```r
# Raster formats (PNG, TIFF, JPEG)
ggsave(
  file, 
  plot = plot_object, 
  device = format,
  width = 12,       # inches
  height = 8,       # inches
  dpi = 300,        # publication quality
  bg = "#222222",   # dark background
  units = "in"      # specify inches
)

# Vector formats (SVG)
ggsave(
  file, 
  plot = plot_object, 
  device = "svg",
  width = 12,
  height = 8,
  bg = "#222222",
  units = "in"
)

# PostScript
ggsave(
  file, 
  plot = plot_object, 
  device = "ps",
  width = 12,
  height = 8,
  bg = "#222222",
  units = "in",
  family = "Helvetica",  # professional font
  paper = "special"      # exact dimensions
)
```

---

## Journal Requirements Guide

### Nature, Science, Cell
- **Format**: TIFF or EPS preferred
- **Resolution**: 300-600 DPI
- **Color**: RGB or CMYK
- **✅ Recommended**: TIFF (300 DPI) or PostScript

### PLOS (PLOS ONE, PLOS Biology)
- **Format**: TIFF, EPS, or PDF
- **Resolution**: 300-600 DPI minimum
- **Dimensions**: 5-7 inches width
- **✅ Recommended**: TIFF (300 DPI)

### Springer, Elsevier
- **Format**: TIFF, EPS, or high-quality PDF
- **Resolution**: 300-600 DPI
- **Color**: RGB acceptable
- **✅ Recommended**: TIFF (300 DPI) or SVG→PDF

### Wiley, Taylor & Francis
- **Format**: TIFF, EPS, or PNG
- **Resolution**: 300 DPI minimum
- **File Size**: < 10 MB preferred
- **✅ Recommended**: PNG (300 DPI) or TIFF

### Ecological Journals (Ecology, Oikos, etc.)
- **Format**: TIFF or EPS preferred
- **Resolution**: 300-600 DPI
- **Dimensions**: 3.5" (1 column) or 7" (2 column)
- **✅ Recommended**: TIFF (300 DPI)

---

## Best Practices

### ✅ For Manuscripts
1. **Generate plot** in Ördin with optimal parameters
2. **Select TIFF** format (highest quality, journal standard)
3. **Download** and verify in image viewer
4. **Submit** directly to journal (no conversion needed)

### ✅ For Presentations
1. **Select PNG** format (good quality, smaller size)
2. **Insert** directly into PowerPoint/Keynote
3. **Advantage**: Transparency supported, looks great on slides

### ✅ For Posters
1. **Select SVG** or **PostScript** (vector formats)
2. **Scale** to poster size without quality loss
3. **Edit** in Illustrator/Inkscape if needed
4. **Export** to final format (PDF, PNG at high DPI)

### ✅ For LaTeX Documents
1. **Select PostScript** (.ps) or **SVG**
2. **Include** in LaTeX with `\includegraphics{}`
3. **Compile** with `pdflatex` or `xelatex`
4. **Result**: Crisp, publication-ready figure

### ✅ For Web Publishing
1. **Select SVG** (best) or **PNG** (good)
2. **Embed** in HTML/Markdown
3. **SVG advantage**: Scales perfectly on all devices
4. **PNG advantage**: Universal compatibility

---

## File Size Comparison

Example plot (12" × 8", typical rarefaction curve):

| Format | File Size | Quality | Scalability |
|--------|-----------|---------|-------------|
| PNG | 150-300 KB | ★★★★★ | No |
| TIFF | 25-50 MB | ★★★★★ | No |
| JPEG | 50-100 KB | ★★★★☆ | No |
| SVG | 100-500 KB | ★★★★★ | Yes |
| PostScript | 200-800 KB | ★★★★★ | Yes |

**Recommendations**:
- **Email/sharing**: JPEG or PNG
- **Journal submission**: TIFF
- **Web publishing**: SVG or PNG
- **LaTeX documents**: PostScript or SVG
- **Editing/scaling**: SVG or PostScript

---

## Troubleshooting

### Issue: TIFF files are too large
- **Solution**: Use PNG instead (lossless but smaller)
- **Or**: Compress TIFF after export (use LZW compression)

### Issue: SVG not rendering correctly
- **Solution**: Convert to PDF using Inkscape or Illustrator
- **Or**: Use PostScript for LaTeX workflows

### Issue: JPEG looks blurry
- **Solution**: Use PNG or TIFF for text-heavy plots
- **Reason**: JPEG lossy compression affects sharp edges

### Issue: Journal rejects my format
- **Solution**: Check journal's author guidelines
- **Common fix**: TIFF at 300-600 DPI is universally accepted

### Issue: PostScript won't open
- **Solution**: Install Ghostscript or use Evince (Linux) / Preview (Mac)
- **Or**: Convert to PDF using `ps2pdf` command

---

## Advanced Usage

### Converting Formats

**SVG → PDF** (for LaTeX):
```bash
inkscape ordin_plot.svg --export-pdf=ordin_plot.pdf
```

**PostScript → PDF**:
```bash
ps2pdf ordin_plot.ps ordin_plot.pdf
```

**PNG → TIFF** (if needed):
```bash
convert ordin_plot.png -compress lzw ordin_plot.tif
```

### Adjusting Resolution

If you need higher DPI (e.g., 600 DPI for print):
1. Download as TIFF or PNG at 300 DPI
2. Use ImageMagick to resample:
```bash
convert ordin_plot.png -density 600 -units PixelsPerInch ordin_plot_600dpi.png
```

### Batch Export

To export multiple formats at once, download each format:
1. Select PNG → Download
2. Select TIFF → Download
3. Select SVG → Download

This gives you options for different use cases.

---

## Technical Notes

### Why 300 DPI?

**300 DPI** is the **industry standard** for publication-quality images:
- Sufficient for most print applications (magazines, journals)
- Balances quality and file size
- Exceeds human visual acuity at normal viewing distance
- Required by 90% of scientific journals

**Higher DPI** (600+) is only needed for:
- Large-format printing (posters > 24")
- High-end art reproduction
- Extreme magnification

### Why 12" × 8"?

- **Standard figure size** for journals (often 1-column or 2-column width)
- **3:2 aspect ratio** is visually pleasing and widely compatible
- **Large enough** to preserve detail when shrunk for publication
- **Small enough** to keep file sizes reasonable

### Vector vs. Raster

**Raster** (PNG, TIFF, JPEG):
- Fixed resolution (pixels)
- Quality degrades when scaled up
- Better for photographs and complex gradients
- Faster to render

**Vector** (SVG, PostScript):
- Resolution-independent (mathematical paths)
- Perfect quality at any scale
- Better for plots, diagrams, text
- Editable in vector software

**Ördin plots** work well in both formats, but **vector is preferred** for:
- LaTeX documents
- Posters
- Future-proofing

---

## References

### Image Format Standards
- **PNG**: ISO/IEC 15948:2003
- **TIFF**: Adobe TIFF Specification 6.0
- **JPEG**: ISO/IEC 10918
- **SVG**: W3C Recommendation
- **PostScript**: Adobe PostScript Language Reference

### Journal Guidelines
- Nature: https://www.nature.com/nature/for-authors/final-submission
- PLOS: https://journals.plos.org/plosone/s/figures
- Science: https://www.science.org/content/page/instructions-preparing-initial-manuscript

### Tools
- **ggplot2**: R graphics package (used by Ördin)
- **ggsave()**: Export function with format support
- **Ghostscript**: PostScript/PDF viewer
- **Inkscape**: SVG editor
- **ImageMagick**: Format conversion

---

## Summary

Ördin now exports plots in **5 publication-quality formats**:

| Format | Quick Use Case |
|--------|----------------|
| PNG | General use, web, presentations |
| TIFF | Journal submissions, print |
| JPEG | Email, quick sharing |
| SVG | Web, posters, editing |
| PostScript | LaTeX, academic publishing |

**All formats** are optimized for publication:
- Raster: 300 DPI
- Vector: Infinite scalability
- Dimensions: 12" × 8"
- Background: Dark theme (#222222)

**Best Practice**: Start with **SVG or TIFF**, convert as needed for specific requirements.

---

**Happy publishing!** 📊📈🔬

**Ördin** - *Inspired by Odin's wisdom, powered by R*
