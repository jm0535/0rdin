# 📊 Plot Customization Code Examples

**Ördin v3.0** - R Code for Publication-Quality Plots

Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)

---

## 🎯 Overview

While Ördin provides a UI for plot customization, advanced users can use these R code snippets to programmatically create publication-quality figures.

---

## 📈 iNEXT Diversity Plots

### **Basic iNEXT Plot with Custom Theme**

```r
library(iNEXT)
library(ggplot2)

# Run iNEXT
data(dune, package = "vegan")
inext_result <- iNEXT(t(dune), q = c(0, 1, 2), datatype = "abundance")

# Create publication-quality plot
p <- ggiNEXT(inext_result, type = 1) +
  theme_bw() +
  theme(
    text = element_text(size = 12),
    axis.title = element_text(size = 12, face = "bold"),
    axis.text = element_text(size = 10),
    legend.text = element_text(size = 10),
    legend.title = element_text(size = 11, face = "bold"),
    panel.grid.minor = element_blank(),
    legend.position = "right"
  ) +
  labs(
    title = "Rarefaction & Extrapolation Curves",
    x = "Sample Size (individuals)",
    y = "Species Diversity"
  )

# Export
ggsave("Figure1_rarefaction.pdf", p, width = 7, height = 5, dpi = 300)
```

### **Colorblind-Safe iNEXT Plot**

```r
# Wong's colorblind-safe palette
colorblind_colors <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", 
                       "#0072B2", "#D55E00", "#CC79A7", "#000000")

p <- ggiNEXT(inext_result, type = 1) +
  theme_classic() +
  scale_color_manual(values = colorblind_colors) +
  scale_fill_manual(values = paste0(colorblind_colors, "40")) +
  theme(
    legend.position = c(0.95, 0.05),  # Bottom-right inside plot
    legend.justification = c(1, 0)
  ) +
  labs(x = "Number of Individuals", y = "Hill Number")

ggsave("Figure1_colorblind.pdf", p, width = 3.5, height = 3.5, dpi = 300)
```

### **Nature/Science Style iNEXT**

```r
# Nature journal specifications
p <- ggiNEXT(inext_result, type = 1) +
  theme_classic() +
  theme(
    text = element_text(family = "Arial", size = 8),
    axis.title = element_text(size = 8, face = "bold"),
    axis.text = element_text(size = 7),
    legend.text = element_text(size = 7),
    legend.title = element_text(size = 8, face = "bold"),
    legend.key.size = unit(0.4, "cm"),
    panel.border = element_rect(color = "black", fill = NA, size = 0.5),
    axis.ticks = element_line(size = 0.3)
  ) +
  labs(x = "Sample size", y = "Species richness")

# Export at Nature specifications
ggsave("Figure1_nature_style.pdf", p, 
       width = 89, height = 89, units = "mm", dpi = 600)
```

---

## 🔵 NMDS Ordination Plots

### **Basic NMDS with Custom Colors**

```r
library(vegan)

# Run NMDS
data(dune)
nmds_result <- metaMDS(dune, distance = "bray", k = 2)

# Extract scores
scores_df <- as.data.frame(scores(nmds_result, display = "sites"))

# Create plot
p <- ggplot(scores_df, aes(x = NMDS1, y = NMDS2)) +
  geom_point(size = 4, color = "#2e8b57", alpha = 0.7) +
  stat_ellipse(level = 0.95, color = "#2e8b57", size = 1) +
  theme_bw() +
  theme(
    panel.grid.major = element_line(color = "gray90"),
    panel.grid.minor = element_blank()
  ) +
  labs(
    title = "NMDS Ordination of Dune Meadow Communities",
    x = "NMDS1",
    y = "NMDS2"
  ) +
  coord_fixed()  # Equal aspect ratio

ggsave("NMDS_ordination.pdf", p, width = 6, height = 6, dpi = 300)
```

### **NMDS with Environmental Vectors**

```r
# Add environmental data
data(dune.env)

# Fit environmental vectors
env_fit <- envfit(nmds_result, dune.env[, c("A1", "Moisture")], 
                  perm = 999)

# Extract vector coordinates
vec_coords <- as.data.frame(scores(env_fit, display = "vectors"))

# Plot
p <- ggplot(scores_df, aes(x = NMDS1, y = NMDS2)) +
  geom_point(size = 3, color = "#2e8b57") +
  geom_segment(data = vec_coords, 
               aes(x = 0, y = 0, xend = NMDS1, yend = NMDS2),
               arrow = arrow(length = unit(0.3, "cm")),
               color = "#007acc", size = 1) +
  geom_text(data = vec_coords,
            aes(x = NMDS1*1.1, y = NMDS2*1.1, label = rownames(vec_coords)),
            color = "#007acc", size = 4, fontface = "bold") +
  theme_minimal() +
  coord_fixed()

ggsave("NMDS_with_vectors.pdf", p, width = 7, height = 6, dpi = 300)
```

---

## 🎨 Advanced Customization

### **Multi-Panel Figure (Grid)**

```r
library(patchwork)

# Create three plots
p1 <- ggiNEXT(inext_result, type = 1) + 
  ggtitle("A) Sample-size based") + theme_bw()

p2 <- ggiNEXT(inext_result, type = 2) + 
  ggtitle("B) Sample completeness") + theme_bw()

p3 <- ggiNEXT(inext_result, type = 3) + 
  ggtitle("C) Coverage-based") + theme_bw()

# Combine with patchwork
combined <- p1 + p2 + p3 + 
  plot_layout(ncol = 3) +
  plot_annotation(
    title = "Diversity Estimation Using iNEXT",
    theme = theme(plot.title = element_text(size = 14, face = "bold"))
  )

ggsave("Figure1_combined.pdf", combined, width = 12, height = 4, dpi = 300)
```

### **Faceted Plot by Diversity Order**

```r
# Prepare iNEXT data for manual plotting
inext_df <- fortify(inext_result, type = 1)

# Create faceted plot
p <- ggplot(inext_df, aes(x = x, y = y, color = Assemblage, fill = Assemblage)) +
  geom_line(size = 1) +
  geom_ribbon(aes(ymin = y.lwr, ymax = y.upr), alpha = 0.2) +
  facet_wrap(~ Order, scales = "free_y", labeller = label_parsed) +
  theme_bw() +
  theme(
    strip.background = element_rect(fill = "#2e8b57", color = "black"),
    strip.text = element_text(color = "white", face = "bold")
  ) +
  labs(x = "Sample Size", y = "Diversity", color = "Site", fill = "Site")

ggsave("Figure_faceted.pdf", p, width = 10, height = 4, dpi = 300)
```

---

## 📊 Grayscale for B&W Print

### **Grayscale with Different Line Types**

```r
# Grayscale palette
gray_colors <- gray.colors(20, start = 0.3, end = 0.7)

p <- ggiNEXT(inext_result, type = 1) +
  theme_classic() +
  scale_color_manual(values = gray_colors) +
  scale_fill_manual(values = paste0(gray_colors, "40")) +
  scale_linetype_manual(values = rep(c("solid", "dashed", "dotted"), length.out = 20)) +
  theme(
    legend.key.width = unit(1.5, "cm"),  # Wider legend keys for line types
    panel.border = element_rect(color = "black", fill = NA)
  )

ggsave("Figure_grayscale.pdf", p, width = 7, height = 5, dpi = 300)
```

---

## 🎯 Export Options

### **High-Resolution PNG for Presentations**

```r
ggsave("presentation_plot.png", p, 
       width = 10, height = 6, dpi = 150, bg = "white")
```

### **Vector PDF for Journals**

```r
ggsave("journal_figure.pdf", p, 
       width = 7, height = 5, dpi = 300, 
       device = cairo_pdf)  # Better font embedding
```

### **SVG for Editing in Illustrator**

```r
ggsave("editable_plot.svg", p, 
       width = 10, height = 6)
```

### **TIFF for Some Journals**

```r
ggsave("figure.tiff", p, 
       width = 7, height = 5, dpi = 300, 
       compression = "lzw")
```

---

## 🎨 Custom Color Palettes

### **Define Your Own Palette**

```r
# Custom Ördin palette
ordin_palette <- c(
  "#2e8b57",  # Green
  "#007acc",  # Blue
  "#d4a017",  # Gold
  "#e74c3c",  # Red
  "#9b59b6"   # Purple
)

# Apply to plot
p + scale_color_manual(values = ordin_palette)
```

### **Viridis Palette**

```r
library(viridis)

p + scale_color_viridis_d(option = "viridis")  # Discrete
p + scale_color_viridis_c(option = "plasma")   # Continuous
```

---

## 📏 Precise Dimension Control

### **Match Exact Journal Specifications**

```r
# Nature single-column figure
ggsave("figure_nature.pdf", p,
       width = 89,   # mm
       height = 89,  # mm
       units = "mm",
       dpi = 600)

# Science double-column figure
ggsave("figure_science.pdf", p,
       width = 12,   # cm
       height = 8,   # cm
       units = "cm",
       dpi = 300)

# PLOS ONE single-column
ggsave("figure_plos.pdf", p,
       width = 83,   # mm
       height = 83,  # mm
       units = "mm",
       dpi = 300)
```

---

## 🔧 Troubleshooting Code

### **Check Plot Dimensions Before Export**

```r
# Print current plot size
dev.size("in")  # inches

# Calculate final resolution
width_in <- 7
dpi <- 300
width_px <- width_in * dpi
cat(sprintf("Output will be %d × %d pixels\n", width_px, width_px))
```

### **Fix Font Rendering Issues**

```r
# Use Cairo for better font handling
ggsave("plot.pdf", p, device = cairo_pdf, 
       width = 7, height = 5)

# Embed fonts properly
library(extrafont)
embed_fonts("plot.pdf")
```

---

## 💡 Pro Tips

### **Save Plot Object for Later**

```r
# Save plot object
saveRDS(p, "my_plot.rds")

# Load later
p_loaded <- readRDS("my_plot.rds")
print(p_loaded)
```

### **Batch Export Multiple Formats**

```r
# Function to export in multiple formats
export_multi <- function(plot, filename, ...) {
  ggsave(paste0(filename, ".pdf"), plot, ...)
  ggsave(paste0(filename, ".png"), plot, ...)
  ggsave(paste0(filename, ".svg"), plot, ...)
}

export_multi(p, "Figure1", width = 7, height = 5, dpi = 300)
```

---

## 📚 Additional Resources

**ggplot2 Extensions:**
- `patchwork` - Combine multiple plots
- `cowplot` - Publication-ready themes
- `ggpubr` - Publication-ready formatting
- `ggsci` - Journal-specific color palettes

**Installation:**
```r
install.packages(c("patchwork", "cowplot", "ggpubr", "ggsci"))
```

---

**Author:** Jimmy Moses (jimmy.moses@pnguot.ac.pg)  
**Ördin v3.0** - Community Ecology Analysis  
**License:** MIT  
**Last Updated:** 2025-10-29
