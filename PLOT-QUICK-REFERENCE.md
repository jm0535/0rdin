# 📊 Publication Plot Quick Reference Card

**Ördin v3.0** - Fast Settings for Common Scenarios

---

## 🎯 JOURNAL ARTICLE (Nature/Science Style)

```
✅ SETTINGS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Theme:          Publication (Nature)
Font Size:      10pt
Line Width:     0.75
Point Size:     3
Legend:         Right
Color Palette:  Colorblind Safe

Width:          3.5" (single) or 7" (double)
Height:         3.5" or 5"
DPI:            300
Format:         PDF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 🎤 PRESENTATION SLIDES

```
✅ SETTINGS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Theme:          Minimal
Font Size:      16pt
Line Width:     1.5
Point Size:     4
Legend:         Bottom
Color Palette:  Ördin Default

Width:          10"
Height:         6"
DPI:            150
Format:         PNG
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 🖼️ POSTER (A1 Size)

```
✅ SETTINGS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Theme:          Light
Font Size:      20pt
Line Width:     2.0
Point Size:     6
Legend:         Right
Color Palette:  Viridis

Width:          12"
Height:         8"
DPI:            300
Format:         PDF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 📖 THESIS/DISSERTATION

```
✅ SETTINGS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Theme:          Classic (bw)
Font Size:      12pt
Line Width:     1.0
Point Size:     3
Legend:         Right
Color Palette:  Ördin Default

Width:          6.5"
Height:         4.5"
DPI:            300
Format:         PDF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 🖨️ BLACK & WHITE PRINT

```
✅ SETTINGS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Theme:          Publication (Nature)
Font Size:      10pt
Line Width:     1.0
Point Size:     3
Legend:         Right
Color Palette:  Grayscale or Black

Width:          3.5" or 7"
Height:         3.5" or 5"
DPI:            300
Format:         PDF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 TIP: Test by printing in B&W!
```

---

## 🌐 WEB/BLOG POST

```
✅ SETTINGS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Theme:          Minimal
Font Size:      14pt
Line Width:     1.25
Point Size:     3.5
Legend:         Right
Color Palette:  Viridis

Width:          8"
Height:         5"
DPI:            150
Format:         PNG
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 📊 STANDARD JOURNAL SIZES

| Journal | Single Column | Double Column |
|---------|---------------|---------------|
| **Nature** | 3.5" (89 mm) | 7.2" (183 mm) |
| **Science** | 2.17" (55 mm) | 4.72" (120 mm) |
| **PLOS ONE** | 3.27" (83 mm) | 6.83" (173 mm) |
| **Ecology** | 3.5" | 7.5" |

---

## 🎨 WHEN TO USE EACH COLOR PALETTE

| Palette | Use When |
|---------|----------|
| **Ördin Default** | General use, branding |
| **Viridis** | Sequential data, heatmaps |
| **Plasma** | Need high contrast |
| **Colorblind Safe** | **ALWAYS for publications!** |
| **Grayscale** | B&W print required |
| **Black** | Conservative journals |

---

## ⚡ QUICK EXPORT CHECKLIST

Before exporting final figure:

- [ ] Theme matches journal style
- [ ] Font size readable at print size
- [ ] DPI = 300 minimum
- [ ] Width matches column size
- [ ] Colorblind-safe palette
- [ ] Custom labels added
- [ ] Legend not overlapping
- [ ] Test print at actual size

---

## 🆘 COMMON MISTAKES

❌ **DON'T:**
- Use default 72 DPI (too low!)
- Make figures wider than journal column
- Use rainbow colors (not colorblind-safe)
- Forget to test in B&W
- Export as JPG (lossy compression)

✅ **DO:**
- Use 300 DPI minimum
- Match journal specifications exactly
- Use colorblind-safe palettes
- Test early and often
- Export as PDF (vector) or high-res PNG

---

## 📐 ASPECT RATIO GUIDE

**Best aspect ratios:**
- **Square:** 1:1 (scatter plots, ordinations)
- **Landscape:** 3:2 or 16:9 (time series, rarefaction)
- **Portrait:** 2:3 (rarely used)

**Maintain consistency:**
- All figures in manuscript should use similar aspect ratio
- Makes for professional, cohesive appearance

---

## 💾 FILE NAMING CONVENTION

Good file names for journal submission:

```
✅ GOOD:
Fig1_NMDS_ordination_sites.pdf
Fig2_rarefaction_curves.pdf
FigS1_species_accumulation.pdf

❌ BAD:
figure1.pdf
plot_2024.png
unnamed.pdf
```

**Pattern:** `Fig[Number]_[Analysis]_[Description].[ext]`

---

## 🔧 TROUBLESHOOTING

| Problem | Solution |
|---------|----------|
| Text too small | Increase font size to 12-14pt |
| Lines too thin | Increase line width to 1.0-1.5 |
| File too large | Reduce DPI to 300, use PDF |
| Legend overlaps | Change position or hide |
| Colors look dull | Use Viridis/Plasma palette |
| Not colorblind-safe | Switch to Colorblind Safe palette |

---

**🔗 Full Guide:** See `PLOT-CUSTOMIZATION-GUIDE.md` for detailed explanations

**Author:** Jimmy Moses (jimmy.moses@pnguot.ac.pg)  
**Ördin v3.0** - Community Ecology Analysis Software
