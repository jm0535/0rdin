# 📊 Publication-Ready Plots in Ördin - Complete Guide

**Quick Access to All Plot Customization Resources**

Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)  
Ördin v3.0 - Community Ecology Analysis Software

---

## 🎯 What You Get

Ördin now includes comprehensive **publication-quality plot customization** for all analyses:

✅ **Advanced customization UI** in every module  
✅ **Professional themes** (Nature, Science, etc.)  
✅ **Colorblind-safe palettes** for accessibility  
✅ **High-resolution export** (PNG, PDF, SVG)  
✅ **Precise dimension control** for journals  
✅ **Custom labels and typography**  

---

## 📚 Documentation Files

### **1. PLOT-CUSTOMIZATION-GUIDE.md** (Complete Reference)
**411 lines** | Comprehensive guide covering all features

**What's inside:**
- Full explanation of all customization options
- Theme descriptions and use cases
- Color palette reference with hex codes
- Journal-specific requirements (Nature, Science, PLOS, etc.)
- Export format comparisons (PNG vs PDF vs SVG)
- Multi-panel figure creation workflow
- Accessibility guidelines (colorblind-safe)
- Troubleshooting section

**Best for:** First-time users, detailed understanding

---

### **2. PLOT-QUICK-REFERENCE.md** (Cheat Sheet)
**242 lines** | Fast lookup for common scenarios

**What's inside:**
- Pre-configured settings for 6 common scenarios:
  - Journal articles (Nature/Science style)
  - Presentations
  - Posters
  - Thesis/dissertation
  - B&W print
  - Web/blog
- Standard journal sizes table
- Color palette decision guide
- Export checklist
- Common mistakes and solutions
- File naming conventions

**Best for:** Quick reference during work

---

### **3. PLOT-CODE-EXAMPLES.md** (R Code Snippets)
**400 lines** | Programmatic plot generation

**What's inside:**
- Complete R code examples for:
  - iNEXT diversity plots
  - NMDS ordination plots
  - Multi-panel figures
  - Grayscale B&W plots
- Advanced customization code
- Batch export functions
- Dimension calculation helpers
- Font embedding fixes

**Best for:** Advanced users, scripting workflows

---

## 🎨 Features Available in Ördin UI

### **In Every Analysis Module:**

You'll find the **"🎨 Plot Customization"** panel with:

#### **1. Visual Themes** (5 options)
- Classic (bw) - General publications
- Minimal - Modern journals
- Light - Presentations  
- Dark - Posters
- Publication (Nature) - High-impact journals

#### **2. Typography Controls**
- Font size: 8-24pt
- Adjustable for different use cases

#### **3. Visual Elements**
- Line width: 0.5-3.0
- Point size: 1-8
- Legend position: 5 options

#### **4. Custom Labels**
- Plot title override
- X-axis label override
- Y-axis label override

#### **5. Color Palettes** (6 options)
- Ördin Default (branded)
- Viridis (sequential)
- Plasma (high contrast)
- **Colorblind Safe** (recommended!)
- Grayscale (B&W print)
- Publication Black (conservative)

#### **6. Export Settings**
- Width & Height (inches)
- DPI: 150, 300, 600
- Auto-calculated pixel dimensions

---

## 🚀 Quick Start

### **For Journal Submission:**

1. **Run your analysis** (iNEXT, NMDS, etc.)

2. **Click "🎨 Plot Customization"** to expand options

3. **Configure these key settings:**
   ```
   Theme: Publication (Nature)
   Font Size: 10pt
   Color Palette: Colorblind Safe
   Width: 3.5" (single) or 7" (double column)
   Height: Match aspect ratio
   DPI: 300
   ```

4. **Add custom labels** if needed

5. **Export as PDF** for journals

6. **Check in journal submission system**

**Total time: < 2 minutes!**

---

## 📋 Pre-Configured Settings

### **Copy These Settings:**

#### **Nature/Science Article**
```
Theme: Publication (Nature)
Font: 10pt | Line: 0.75 | Point: 3
Legend: Right | Colors: Colorblind Safe
Size: 3.5" × 3.5" | DPI: 300 | Format: PDF
```

#### **Presentation Slide**
```
Theme: Minimal
Font: 16pt | Line: 1.5 | Point: 4
Legend: Bottom | Colors: Ördin Default
Size: 10" × 6" | DPI: 150 | Format: PNG
```

#### **A1 Poster**
```
Theme: Light
Font: 20pt | Line: 2.0 | Point: 6
Legend: Right | Colors: Viridis
Size: 12" × 8" | DPI: 300 | Format: PDF
```

---

## 🎯 Common Journal Requirements

| Journal | Single Column | Double Column | DPI | Format |
|---------|---------------|---------------|-----|--------|
| **Nature** | 3.5" (89 mm) | 7.2" (183 mm) | 300-600 | PDF |
| **Science** | 2.17" (55 mm) | 4.72" (120 mm) | 300 | PDF |
| **PLOS ONE** | 3.27" (83 mm) | 6.83" (173 mm) | 300 | PDF/PNG |
| **Ecology** | 3.5" | 7.5" | 300 | PDF/TIFF |

**See PLOT-CUSTOMIZATION-GUIDE.md for more journals**

---

## 🌈 When to Use Each Color Palette

| Scenario | Recommended Palette | Why |
|----------|-------------------|-----|
| **Journal submission** | Colorblind Safe | Accessible to 8% color-blind readers |
| **Presentation** | Ördin Default or Viridis | High contrast, professional |
| **Poster** | Viridis or Plasma | Eye-catching, readable from distance |
| **B&W print** | Grayscale or Black | No color available |
| **Thesis** | Ördin Default | Professional branding |
| **Web/blog** | Viridis | Screen-optimized |

---

## ⚡ Quality Checklist

Before submitting to journal, verify:

- [ ] **DPI ≥ 300** (print quality)
- [ ] **Width matches journal column** (see table above)
- [ ] **Colorblind-safe palette** used
- [ ] **Font size 10-12pt** (readable at print size)
- [ ] **PDF format** (vector graphics)
- [ ] **Custom labels** added if needed
- [ ] **Legend not overlapping** data
- [ ] **Tested in B&W** (print to check)
- [ ] **File size < 10 MB** (journal limit)
- [ ] **Descriptive filename** (e.g., Fig1_NMDS_sites.pdf)

---

## 🆘 Troubleshooting

| Problem | Quick Fix | Full Solution |
|---------|-----------|---------------|
| Text too small | Font size → 12pt | See Guide §3 |
| File too large | DPI → 300 | See Guide §6 |
| Colors not distinct | Palette → Viridis | See Guide §5 |
| Not colorblind-safe | Palette → Colorblind Safe | See Guide §5 |
| Legend overlaps | Position → Bottom | See Guide §3 |
| Lines too thin | Line width → 1.0 | See Guide §3 |

---

## 📖 How to Use These Documents

### **First Time?**
1. Read **PLOT-CUSTOMIZATION-GUIDE.md** (full guide)
2. Bookmark **PLOT-QUICK-REFERENCE.md** (cheat sheet)
3. Try settings in Ördin UI

### **Preparing Manuscript?**
1. Open **PLOT-QUICK-REFERENCE.md**
2. Copy settings for "Journal Article"
3. Adjust for your specific journal
4. Use export checklist

### **Advanced User?**
1. Check **PLOT-CODE-EXAMPLES.md**
2. Adapt R code to your needs
3. Script batch exports

### **Need Help?**
1. Check **PLOT-CUSTOMIZATION-GUIDE.md** § Troubleshooting
2. Verify settings in **PLOT-QUICK-REFERENCE.md**
3. Email: jimmy.moses@pnguot.ac.pg

---

## 🔧 Technical Implementation

### **Files in Codebase:**

```
shiny/modules/plot_customization_module.R
├── plot_customization_ui()      # UI component
├── get_plot_theme()             # Theme generator
├── get_color_palette()          # Color palette generator
├── apply_custom_labels()        # Label applicator
└── plot_customization_server()  # Reactive settings
```

**Integration:**
- Include in diversity modules
- Include in ordination modules
- Reactive updates on setting changes
- Export with user settings

---

## 📊 Statistics

**Documentation totals:**
- 1,053 lines of guidance
- 6 pre-configured scenarios
- 5 plot themes
- 6 color palettes
- 15+ journal specifications
- 20+ code examples

---

## 🎓 Learning Path

**Beginner → Advanced:**

1. **Week 1:** Use pre-configured settings from Quick Reference
2. **Week 2:** Experiment with themes and colors in UI
3. **Week 3:** Customize labels and dimensions
4. **Month 2:** Try R code examples for scripting
5. **Month 3:** Create custom workflows and batch exports

---

## 💡 Best Practices

1. **Start early:** Generate test figures at beginning of analysis
2. **Consistency:** Use same settings across all figures in manuscript
3. **Test early:** Submit test figure to journal's system
4. **Simplicity:** Remove unnecessary elements (gridlines, borders)
5. **Accessibility:** Always use colorblind-safe palettes
6. **Backup:** Keep high-resolution originals
7. **Version control:** Note settings in methods section

---

## 🔗 Quick Links

- **Full Guide:** `PLOT-CUSTOMIZATION-GUIDE.md`
- **Cheat Sheet:** `PLOT-QUICK-REFERENCE.md`
- **Code Examples:** `PLOT-CODE-EXAMPLES.md`
- **This Summary:** `PUBLICATION-READY-PLOTS-SUMMARY.md`

---

## 📧 Support

**Questions or feedback?**
- Email: jimmy.moses@pnguot.ac.pg
- Include: Plot type, journal name, specific issue
- Attach: Screenshot if visual problem

---

## 📜 License

MIT License - Free to use, modify, distribute

**Citation:**
```
Moses, J. (2025). Ördin: Publication-quality plot customization 
for community ecology analysis. Version 3.0. 
https://github.com/[your-repo]
```

---

**Last Updated:** 2025-10-29  
**Ördin Version:** 3.0  
**Author:** Jimmy Moses (jimmy.moses@pnguot.ac.pg)

---

## ✨ Summary

You now have **complete plot customization** for publication-quality figures:

✅ **4 comprehensive guides** (1,053 lines total)  
✅ **6 ready-to-use scenarios** (copy settings)  
✅ **20+ code examples** (for scripting)  
✅ **15+ journal specs** (Nature, Science, PLOS...)  
✅ **6 color palettes** (including colorblind-safe)  
✅ **Complete UI integration** (in all modules)  

**Everything you need for publication-ready figures in Ördin!** 🚀
