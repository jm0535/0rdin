# Ördin - Diversity Plotting Utilities
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Extracted plotting functions for diversity modules

library(ggplot2)
library(iNEXT)

#' Generate iNEXT diversity plot
#'
#' @param inext_result iNEXT object
#' @param plot_type Type of plot (1=sample-size, 2=coverage, 3=completeness)
#' @param plot_defaults List of plot customization parameters
#' @return ggplot2 object
generate_inext_plot <- function(inext_result, plot_type = 1, plot_defaults) {
  # Use iNEXT's built-in plotting
  p <- ggiNEXT(inext_result, type = plot_type)
  
  # Apply custom theme
  p <- apply_diversity_theme(p, plot_defaults)
  
  return(p)
}

#' Apply diversity plot theme
#'
#' @param plot ggplot2 object
#' @param plot_defaults List of plot customization parameters
#' @return ggplot2 object with theme applied
apply_diversity_theme <- function(plot, plot_defaults) {
  # Base theme
  base_theme <- switch(plot_defaults$plot_theme,
    "bw" = theme_bw(),
    "minimal" = theme_minimal(),
    "classic" = theme_classic(),
    "light" = theme_light(),
    "dark" = theme_dark(),
    "void" = theme_void(),
    theme_bw()
  )
  
  # Apply theme with customizations
  plot + base_theme +
    theme(
      text = element_text(
        family = plot_defaults$font_family,
        size = plot_defaults$base_size
      ),
      plot.title = element_text(
        size = plot_defaults$title_size,
        face = "bold"
      ),
      axis.title = element_text(size = plot_defaults$axis_title_size),
      axis.line = element_line(linewidth = plot_defaults$axis_lwd),
      legend.text = element_text(size = plot_defaults$legend_size),
      strip.text = element_text(size = plot_defaults$strip_size),
      panel.grid.minor = if (plot_defaults$show_grid_minor) element_line() else element_blank()
    )
}

#' Customize confidence interval ribbons
#'
#' @param plot ggplot2 object
#' @param show_ci Show confidence intervals
#' @param ci_alpha Transparency of CI ribbons
#' @return ggplot2 object
customize_ci_ribbons <- function(plot, show_ci = TRUE, ci_alpha = 0.2) {
  if (!show_ci) {
    # Remove CI ribbons
    plot$layers <- plot$layers[!sapply(plot$layers, function(x) inherits(x$geom, "GeomRibbon"))]
  } else {
    # Adjust alpha
    for (i in seq_along(plot$layers)) {
      if (inherits(plot$layers[[i]]$geom, "GeomRibbon")) {
        plot$layers[[i]]$aes_params$alpha <- ci_alpha
      }
    }
  }
  return(plot)
}

#' Adjust legend layout
#'
#' @param plot ggplot2 object  
#' @param legend_rows Number of rows in legend
#' @return ggplot2 object
adjust_legend_layout <- function(plot, legend_rows = 1) {
  plot + guides(
    color = guide_legend(nrow = legend_rows),
    fill = guide_legend(nrow = legend_rows),
    shape = guide_legend(nrow = legend_rows)
  )
}
