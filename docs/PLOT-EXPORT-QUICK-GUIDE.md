# Ördin Plot Export - Quick Reference

## How to Export Plots

### Step 1: Run Analysis
Upload data and click **"Run Analysis"**

### Step 2: Select Format
Above the plot, choose from dropdown:
- **PNG** - Default, general use (300 DPI)
- **TIFF** - Journal submissions (300 DPI)
- **JPEG** - Compressed, email (300 DPI)
- **SVG** - Scalable vector, web
- **PostScript** - LaTeX, academic publishing

### Step 3: Download
Click **"Download Plot"** button

---

## Format Recommendations

| Use Case | Recommended Format | Reason |
|----------|-------------------|--------|
| 📄 **Journal submission** | TIFF | Industry standard, 300 DPI |
| 🎤 **Presentation** | PNG | Good quality, smaller size |
| 📧 **Email/sharing** | JPEG | Smallest file size |
| 🌐 **Web publishing** | SVG | Scalable, crisp at any size |
| 📊 **LaTeX document** | PostScript | Perfect integration |
| 🖼️ **Poster (large)** | SVG or PostScript | Vector, scales to any size |
| ✏️ **Further editing** | SVG | Editable in Illustrator |

---

## Format Specifications

### Raster Formats (Fixed Resolution)
- **PNG, TIFF, JPEG**: 300 DPI, 12" × 8" (3600 × 2400 pixels)
- Publication quality, suitable for print and digital

### Vector Formats (Infinite Scaling)
- **SVG, PostScript**: 12" × 8" logical dimensions
- Scale to any size without quality loss

---

## File Naming

All exported files follow this pattern:
```
ordin_[analysis-type]_plot_[date].[extension]

Examples:
ordin_inext_plot_2025-10-23.png
ordin_inext_plot_2025-10-23.tiff
ordin_nmds_plot_2025-10-23.svg
ordin_inext_plot_2025-10-23.ps
```

---

## Common Journals

| Journal | Recommended | Specs |
|---------|-------------|-------|
| Nature, Science | TIFF or PostScript | 300-600 DPI |
| PLOS | TIFF | 300-600 DPI |
| Ecology | TIFF | 300 DPI |
| Any LaTeX journal | PostScript or SVG | Vector preferred |

---

## Troubleshooting

**Q: File too large?**  
A: Use PNG instead of TIFF, or JPEG for smallest size

**Q: Journal rejects my format?**  
A: Use TIFF at 300 DPI - universally accepted

**Q: Need to edit plot?**  
A: Use SVG, open in Inkscape or Illustrator

**Q: For LaTeX document?**  
A: Use PostScript (.ps) with `\includegraphics{}`

---

**All formats are publication-quality with optimal settings!**

For detailed information, see [`PUBLICATION-QUALITY-PLOTS.md`](PUBLICATION-QUALITY-PLOTS.md)
