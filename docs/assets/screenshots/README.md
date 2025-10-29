# Screenshots Guide

This folder contains screenshots for the Ördin GitHub Pages landing page.

## Required Screenshots

To complete the landing page, add the following screenshot images:

### 1. **main-interface.png** (Hero Section)
- **Recommended size**: 1200x800px
- **Description**: Main Ördin interface showing the activity bar, sidebar, and a sample analysis
- **Suggested content**: Dashboard view or an NMDS ordination plot

### 2. **ordination.png** (Screenshots Section)
- **Recommended size**: 800x600px
- **Description**: Ordination analysis with confidence ellipses
- **Suggested content**: NMDS or PCA plot with colored site groups and ellipses

### 3. **diversity.png** (Screenshots Section)
- **Recommended size**: 800x600px
- **Description**: Diversity estimation with iNEXT
- **Suggested content**: Rarefaction/extrapolation curves with confidence intervals

### 4. **customization.png** (Screenshots Section)
- **Recommended size**: 800x600px
- **Description**: Right panel showing plot customization controls
- **Suggested content**: Screenshot showing the properties panel with theme, font, and styling options

### 5. **settings.png** (Screenshots Section)
- **Recommended size**: 800x600px
- **Description**: Settings page with multiple sections
- **Suggested content**: Settings interface showing one of the 6 sections (Appearance, Plot Defaults, etc.)

## How to Add Screenshots

1. **Take screenshots** of Ördin running on your system
2. **Resize** images to recommended dimensions using:
   - Windows: Paint, GIMP, or online tools
   - macOS: Preview or online tools
   - Linux: GIMP or ImageMagick
3. **Optimize** images for web:
   ```bash
   # Using ImageMagick (optional)
   convert input.png -quality 85 -resize 1200x800 output.png
   ```
4. **Save** with exact filenames listed above
5. **Place** in this directory: `docs/assets/screenshots/`

## Creating Placeholder Images (Temporary)

If you don't have screenshots yet, create placeholders:

### Using online tools:
- [Placeholder.com](https://placeholder.com/)
- [Lorem Picsum](https://picsum.photos/)
- [Placehold.co](https://placehold.co/)

### Example placeholders:
```
main-interface.png: 1200x800 with text "Ördin Main Interface"
ordination.png: 800x600 with text "Ordination Analysis"
diversity.png: 800x600 with text "Diversity Estimation"
customization.png: 800x600 with text "Plot Customization"
settings.png: 800x600 with text "Settings System"
```

## Image Optimization Tips

- **Format**: Use PNG for screenshots (lossless)
- **Size**: Keep under 500KB per image
- **Resolution**: 72-96 DPI for web
- **Color**: RGB color space
- **Compression**: Use TinyPNG or similar for final optimization

## Screenshot Best Practices

1. **Clean interface**: Close unnecessary windows
2. **Sample data**: Use interesting/colorful example datasets
3. **Theme**: Use dark theme for consistency
4. **Zoom**: Set UI zoom to 100% before capturing
5. **Annotations**: Add arrows or highlights if needed (use tools like Greenshot, Snagit)

## After Adding Screenshots

1. Verify all 5 images are in place
2. Check file sizes (should be reasonable for web)
3. Test the landing page locally by opening `docs/index.html` in a browser
4. Commit and push to GitHub
5. Enable GitHub Pages in repository settings → Pages → Source: main branch, /docs folder

---

**Note**: Until real screenshots are added, the landing page will show broken image icons. This is expected and will be resolved once screenshots are captured from the running Ördin application.
