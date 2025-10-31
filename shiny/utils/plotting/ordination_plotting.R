# Ördin - General Ordination Plotting Utilities
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Shared plotting functions for all ordination methods

library(ggplot2)
library(vegan)

#' Apply standard ordination theme
#'
#' @param plot ggplot2 object
#' @param theme_name Theme name
#' @param base_size Base font size
#' @param font_family Font family
#' @return ggplot2 object with theme
apply_ordination_theme <- function(plot, theme_name = "bw", base_size = 12, font_family = "sans") {
  base_theme <- switch(theme_name,
    "bw" = theme_bw(base_size = base_size, base_family = font_family),
    "minimal" = theme_minimal(base_size = base_size, base_family = font_family),
    "classic" = theme_classic(base_size = base_size, base_family = font_family),
    "light" = theme_light(base_size = base_size, base_family = font_family),
    "dark" = theme_dark(base_size = base_size, base_family = font_family),
    theme_bw(base_size = base_size, base_family = font_family)
  )
  
  plot + base_theme
}

#' Add variance explained to axis labels
#'
#' @param plot ggplot2 object
#' @param ord_result Ordination result object
#' @param axis1 First axis number
#' @param axis2 Second axis number
#' @return ggplot2 object with updated labels
add_variance_labels <- function(plot, ord_result, axis1 = 1, axis2 = 2) {
  # Get eigenvalues
  eig <- eigenvals(ord_result)
  
  if (!is.null(eig)) {
    var_exp <- round(100 * eig / sum(eig), 1)
    
    plot + labs(
      x = sprintf("Axis %d (%.1f%%)", axis1, var_exp[axis1]),
      y = sprintf("Axis %d (%.1f%%)", axis2, var_exp[axis2])
    )
  } else {
    plot
  }
}

#' Create biplot arrows for variables
#'
#' @param ord_result Ordination result
#' @param scaling Scaling type
#' @param arrow_color Color for arrows
#' @return Data frame with arrow coordinates
create_biplot_arrows <- function(ord_result, scaling = 2, arrow_color = "red") {
  # Get species scores
  spp <- scores(ord_result, display = "species", choices = c(1, 2), scaling = scaling)
  
  if (is.null(spp)) {
    return(NULL)
  }
  
  df <- as.data.frame(spp)
  df$label <- rownames(df)
  colnames(df)[1:2] <- c("x", "y")
  
  return(df)
}

#' Add biplot to ordination plot
#'
#' @param plot ggplot2 object
#' @param arrow_data Data frame from create_biplot_arrows
#' @param arrow_color Arrow color
#' @param label_size Label text size
#' @return ggplot2 object with biplot
add_biplot <- function(plot, arrow_data, arrow_color = "red", label_size = 3) {
  if (is.null(arrow_data)) {
    return(plot)
  }
  
  plot +
    geom_segment(
      data = arrow_data,
      aes(x = 0, y = 0, xend = x, yend = y),
      arrow = arrow(length = unit(0.3, "cm")),
      color = arrow_color,
      alpha = 0.7
    ) +
    geom_text(
      data = arrow_data,
      aes(x = x * 1.1, y = y * 1.1, label = label),
      size = label_size,
      color = arrow_color
    )
}

#' Create base ordination plot (PCA, CA, DCA, PCoA, etc.)
#'
#' @param ord_result Ordination result object
#' @param plot_defaults List of plot customization parameters
#' @param grouping_var Optional factor variable for coloring points
#' @param axes Axes to plot (default c(1, 2))
#' @return ggplot2 object
generate_ordination_plot <- function(ord_result, plot_defaults, grouping_var = NULL, axes = c(1, 2)) {
  # Extract site scores
  site_scores <- as.data.frame(scores(ord_result, display = "sites", choices = axes))
  colnames(site_scores) <- c("Axis1", "Axis2")
  site_scores$Site <- rownames(site_scores)
  
  # Add grouping if provided
  if (!is.null(grouping_var)) {
    site_scores$Group <- grouping_var
  }
  
  # Map point shapes
  point_shape_num <- as.numeric(plot_defaults$point_shape)
  
  # Create base plot
  if (!is.null(grouping_var)) {
    p <- ggplot(site_scores, aes(x = Axis1, y = Axis2, color = Group, fill = Group)) +
      geom_point(
        size = plot_defaults$point_size,
        shape = point_shape_num,
        stroke = plot_defaults$point_lwd
      ) +
      scale_color_viridis_d(option = "D") +
      scale_fill_viridis_d(option = "D")
  } else {
    p <- ggplot(site_scores, aes(x = Axis1, y = Axis2)) +
      geom_point(
        size = plot_defaults$point_size,
        shape = point_shape_num,
        fill = plot_defaults$point_color,
        color = if(point_shape_num >= 21) "black" else plot_defaults$point_color,
        stroke = plot_defaults$point_lwd
      )
  }
  
  # Apply theme
  p <- apply_ordination_theme(p, plot_defaults$theme, plot_defaults$base_size, plot_defaults$font_family)
  
  # Add grid
  if (!plot_defaults$show_grid) {
    p <- p + theme(panel.grid = element_blank())
  }
  
  # Add labels
  if (plot_defaults$show_labels) {
    p <- p + geom_text(
      aes(label = Site),
      size = plot_defaults$label_size * 3,
      vjust = -1.5,
      family = plot_defaults$font_family,
      show.legend = FALSE
    )
  }
  
  # Add variance explained to axis labels
  p <- add_variance_labels(p, ord_result, axes[1], axes[2])
  
  # Equal aspect ratio
  if (plot_defaults$equal_aspect) {
    p <- p + coord_fixed()
  }
  
  return(p)
}

#' Add confidence ellipses to ordination plot
#'
#' @param plot ggplot2 object
#' @param ord_result Ordination result object
#' @param grouping_var Factor variable for grouping
#' @param ellipse_type Type of ellipse ("norm", "t", "euclid")
#' @param conf_level Confidence level (default 0.95)
#' @param axes Axes used in plot
#' @return ggplot2 object with ellipses
add_ordination_ellipses <- function(plot, ord_result, grouping_var, 
                                    ellipse_type = "norm", conf_level = 0.95,
                                    axes = c(1, 2)) {
  # Get site scores
  site_scores <- as.data.frame(scores(ord_result, display = "sites", choices = axes))
  colnames(site_scores) <- c("Axis1", "Axis2")
  site_scores$Group <- grouping_var
  
  # Add ellipses
  plot + 
    stat_ellipse(
      data = site_scores,
      aes(x = Axis1, y = Axis2, color = Group, fill = Group),
      type = ellipse_type,
      level = conf_level,
      geom = "polygon",
      alpha = 0.15,
      size = 1.2
    ) +
    scale_color_viridis_d(option = "D") +
    scale_fill_viridis_d(option = "D") +
    labs(color = "Group", fill = "Group")
}

#' Create constrained ordination biplot (CCA, RDA)
#'
#' @param ord_result CCA/RDA result object
#' @param plot_defaults List of plot customization parameters
#' @param grouping_var Optional factor variable for coloring points
#' @param show_env_vectors Show environmental vectors (default TRUE)
#' @return ggplot2 object
generate_constrained_plot <- function(ord_result, plot_defaults, grouping_var = NULL, show_env_vectors = TRUE) {
  # Base plot with sites
  p <- generate_ordination_plot(ord_result, plot_defaults, grouping_var, axes = c(1, 2))
  
  # Add environmental vectors if requested
  if (show_env_vectors) {
    bp_scores <- scores(ord_result, display = "bp", choices = c(1, 2))
    
    if (!is.null(bp_scores) && nrow(bp_scores) > 0) {
      bp_df <- as.data.frame(bp_scores)
      colnames(bp_df) <- c("Axis1", "Axis2")
      bp_df$Label <- rownames(bp_df)
      
      p <- p +
        geom_segment(
          data = bp_df,
          aes(x = 0, y = 0, xend = Axis1, yend = Axis2),
          arrow = arrow(length = unit(0.3, "cm")),
          color = "#e74c3c",
          alpha = 0.7,
          inherit.aes = FALSE
        ) +
        geom_text(
          data = bp_df,
          aes(x = Axis1 * 1.1, y = Axis2 * 1.1, label = Label),
          size = plot_defaults$label_size * 3.5,
          color = "#c0392b",
          inherit.aes = FALSE
        )
    }
  }
  
  return(p)
}

#' Export ordination plot
#'
#' @param plot ggplot2 object
#' @param filename Output filename
#' @param width Width in inches
#' @param height Height in inches
#' @param dpi Resolution
#' @param format Format (png, pdf, svg, tiff)
export_ordination_plot <- function(plot, filename, width = 8, height = 6, 
                                   dpi = 300, format = "png") {
  ggsave(
    filename = filename,
    plot = plot,
    width = width,
    height = height,
    dpi = dpi,
    device = format
  )
}
