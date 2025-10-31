# Ördin - NMDS Plotting Utilities
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Extracted plotting functions for NMDS module

library(ggplot2)
library(vegan)

#' Generate NMDS base plot
#'
#' @param nmds_result vegan metaMDS object
#' @param plot_defaults List of plot customization parameters
#' @param grouping_var Optional factor variable for coloring points
#' @return ggplot2 object
generate_nmds_plot <- function(nmds_result, plot_defaults, grouping_var = NULL) {
  # Extract scores
  site_scores <- as.data.frame(scores(nmds_result, display = "sites"))
  site_scores$Site <- rownames(site_scores)
  
  # Add grouping if provided
  if (!is.null(grouping_var)) {
    site_scores$Group <- grouping_var
  }
  
  # Map point shapes (21 = filled circle)
  shape_map <- c("21" = 21, "22" = 22, "23" = 23, "24" = 24, "25" = 25,
                 "1" = 1, "2" = 2, "3" = 3, "4" = 4, "5" = 5)
  point_shape_num <- as.numeric(plot_defaults$point_shape)
  
  # Create base plot with or without grouping
  if (!is.null(grouping_var)) {
    p <- ggplot(site_scores, aes(x = NMDS1, y = NMDS2, color = Group, fill = Group)) +
      geom_point(
        size = plot_defaults$point_size,
        shape = point_shape_num,
        stroke = plot_defaults$point_lwd
      ) +
      scale_color_viridis_d(option = "D") +
      scale_fill_viridis_d(option = "D")
  } else {
    p <- ggplot(site_scores, aes(x = NMDS1, y = NMDS2)) +
      geom_point(
        size = plot_defaults$point_size,
        shape = point_shape_num,
        fill = plot_defaults$point_color,
        color = if(point_shape_num >= 21) "black" else plot_defaults$point_color,
        stroke = plot_defaults$point_lwd
      )
  }
  
  # Apply theme
  p <- apply_plot_theme(p, plot_defaults)
  
  # Add labels if requested
  if (plot_defaults$show_labels) {
    p <- p + geom_text(
      aes(label = Site),
      size = plot_defaults$label_size * 3,
      vjust = -1.5,
      family = plot_defaults$font_family,
      show.legend = FALSE
    )
  }
  
  # Add axis labels
  p <- p + labs(
    x = "NMDS1",
    y = "NMDS2",
    title = "NMDS Ordination"
  )
  
  # Equal aspect ratio if requested
  if (plot_defaults$equal_aspect) {
    p <- p + coord_fixed()
  }
  
  return(p)
}

#' Add confidence ellipses to NMDS plot
#'
#' @param plot ggplot2 object
#' @param nmds_result vegan metaMDS object
#' @param grouping_var Factor variable for grouping
#' @param ellipse_type Type of ellipse ("norm", "t", "euclid")
#' @param conf_level Confidence level (default 0.95)
#' @return ggplot2 object with ellipses
add_confidence_ellipses <- function(plot, nmds_result, grouping_var, 
                                   ellipse_type = "norm", conf_level = 0.95) {
  # Get site scores
  site_scores <- as.data.frame(scores(nmds_result, display = "sites"))
  site_scores$Group <- grouping_var
  
  # Add ellipses with color mapping
  plot + 
    stat_ellipse(
      data = site_scores,
      aes(x = NMDS1, y = NMDS2, color = Group, fill = Group),
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

#' Add species scores overlay to NMDS plot
#'
#' @param plot ggplot2 object
#' @param nmds_result vegan metaMDS object
#' @param arrow_color Color for species arrows
#' @param label_size Size for species labels
#' @return ggplot2 object with species scores
add_species_scores <- function(plot, nmds_result, arrow_color = "blue", label_size = 3) {
  species_scores <- as.data.frame(scores(nmds_result, display = "species"))
  species_scores$Species <- rownames(species_scores)
  
  plot +
    geom_segment(
      data = species_scores,
      aes(x = 0, y = 0, xend = NMDS1, yend = NMDS2),
      arrow = arrow(length = unit(0.2, "cm")),
      color = arrow_color,
      alpha = 0.6
    ) +
    geom_text(
      data = species_scores,
      aes(x = NMDS1, y = NMDS2, label = Species),
      size = label_size,
      color = arrow_color
    )
}

#' Add environmental vectors to NMDS plot
#'
#' @param plot ggplot2 object
#' @param nmds_result vegan metaMDS object
#' @param env_data Environmental data frame
#' @param vector_color Color for environmental vectors
#' @return ggplot2 object with environmental vectors
add_env_vectors <- function(plot, nmds_result, env_data, vector_color = "red") {
  # Fit environmental vectors
  ef <- envfit(nmds_result, env_data, permutations = 999)
  
  # Extract significant vectors
  vec_coords <- as.data.frame(scores(ef, "vectors"))
  vec_coords$Variable <- rownames(vec_coords)
  
  plot +
    geom_segment(
      data = vec_coords,
      aes(x = 0, y = 0, xend = NMDS1, yend = NMDS2),
      arrow = arrow(length = unit(0.3, "cm")),
      color = vector_color,
      size = 1.2
    ) +
    geom_text(
      data = vec_coords,
      aes(x = NMDS1 * 1.1, y = NMDS2 * 1.1, label = Variable),
      color = vector_color,
      fontface = "bold",
      size = 4
    )
}

#' Apply plot theme based on user selection
#'
#' @param plot ggplot2 object
#' @param plot_defaults List of plot customization parameters
#' @return ggplot2 object with theme applied
apply_plot_theme <- function(plot, plot_defaults) {
  # Base theme
  base_theme <- switch(plot_defaults$theme,
    "bw" = theme_bw(),
    "minimal" = theme_minimal(),
    "classic" = theme_classic(),
    "light" = theme_light(),
    "dark" = theme_dark(),
    "void" = theme_void(),
    theme_bw()  # default
  )
  
  # Apply base theme
  plot <- plot + base_theme
  
  # Customize text sizes and family
  plot <- plot + theme(
    text = element_text(
      family = plot_defaults$font_family,
      size = plot_defaults$base_size
    ),
    plot.title = element_text(size = plot_defaults$title_size, face = "bold"),
    axis.title = element_text(size = plot_defaults$base_size),
    axis.text = element_text(size = plot_defaults$base_size * 0.9),
    axis.line = element_line(linewidth = plot_defaults$axis_lwd)
  )
  
  # Grid customization
  if (!plot_defaults$show_grid) {
    plot <- plot + theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank()
    )
  }
  
  return(plot)
}

#' Export NMDS plot with publication quality
#'
#' @param plot ggplot2 object
#' @param filename Output filename
#' @param width Width in inches
#' @param height Height in inches
#' @param dpi Resolution
#' @param format File format ("png", "pdf", "svg", "tiff")
export_nmds_plot <- function(plot, filename, width = 8, height = 6, 
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
