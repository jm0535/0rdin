# Ördin - Plot Customization Module
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Publication-quality plot controls

library(shiny)
library(ggplot2)

#' Plot Customization UI Component
#' @param id Module namespace ID
#' @param plot_types Character vector of available plot types
plot_customization_ui <- function(id, plot_types = NULL) {
  ns <- NS(id)
  
  tagList(
    div(class = "plot-customization-panel", style = "background: #1e1e1e; border: 1px solid #3e3e42; padding: 16px; margin-bottom: 20px;",
      
      # Collapsible header
      div(onclick = paste0("$('#", ns("custom_options"), "').toggle(); $(this).find('.toggle-icon').text($(this).find('.toggle-icon').text() === '▼' ? '▶' : '▼');"),
          style = "cursor: pointer; display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;",
        h4(style = "color: #2e8b57; margin: 0; font-size: 14px; font-weight: 600;", 
           "🎨 Plot Customization (Publication Quality)"),
        span(class = "toggle-icon", style = "color: #2e8b57; font-weight: bold;", "▼")
      ),
      
      # Customization options (collapsible)
      div(id = ns("custom_options"), style = "display: block;",
        
        # Theme Selection
        div(style = "margin-bottom: 16px;",
          tags$label(style = "color: #cccccc; font-size: 12px; font-weight: 600; display: block; margin-bottom: 6px;", "Plot Theme:"),
          selectInput(
            ns("theme"),
            NULL,
            choices = c(
              "Classic (bw)" = "bw",
              "Minimal" = "minimal",
              "Light" = "light",
              "Dark" = "dark",
              "Publication (Nature)" = "publication"
            ),
            selected = "bw",
            selectize = FALSE
          )
        ),
        
        # Grid layout for compact controls
        div(style = "display: grid; grid-template-columns: 1fr 1fr; gap: 12px;",
          
          # Font size
          div(
            tags$label(style = "color: #cccccc; font-size: 11px; display: block; margin-bottom: 4px;", "Font Size:"),
            numericInput(ns("font_size"), NULL, value = 12, min = 8, max = 24, step = 1)
          ),
          
          # Line width
          div(
            tags$label(style = "color: #cccccc; font-size: 11px; display: block; margin-bottom: 4px;", "Line Width:"),
            numericInput(ns("line_width"), NULL, value = 1, min = 0.5, max = 3, step = 0.25)
          ),
          
          # Point size
          div(
            tags$label(style = "color: #cccccc; font-size: 11px; display: block; margin-bottom: 4px;", "Point Size:"),
            numericInput(ns("point_size"), NULL, value = 3, min = 1, max = 8, step = 0.5)
          ),
          
          # Legend position
          div(
            tags$label(style = "color: #cccccc; font-size: 11px; display: block; margin-bottom: 4px;", "Legend:"),
            selectInput(
              ns("legend_position"),
              NULL,
              choices = c("Right" = "right", "Left" = "left", "Top" = "top", "Bottom" = "bottom", "None" = "none"),
              selected = "right",
              selectize = FALSE
            )
          )
        ),
        
        # Custom labels
        div(style = "margin-top: 12px; padding-top: 12px; border-top: 1px solid #3e3e42;",
          tags$label(style = "color: #cccccc; font-size: 12px; font-weight: 600; display: block; margin-bottom: 8px;", "Custom Labels:"),
          
          textInput(ns("title"), "Plot Title:", placeholder = "Leave empty for default"),
          textInput(ns("x_label"), "X-axis Label:", placeholder = "Leave empty for default"),
          textInput(ns("y_label"), "Y-axis Label:", placeholder = "Leave empty for default")
        ),
        
        # Color palette
        div(style = "margin-top: 12px; padding-top: 12px; border-top: 1px solid #3e3e42;",
          tags$label(style = "color: #cccccc; font-size: 12px; font-weight: 600; display: block; margin-bottom: 6px;", "Color Palette:"),
          selectInput(
            ns("color_palette"),
            NULL,
            choices = c(
              "Ördin Default (Green-Blue-Gold)" = "ordin",
              "Viridis" = "viridis",
              "Plasma" = "plasma",
              "Colorblind Safe" = "colorblind",
              "Grayscale" = "gray",
              "Publication (Black)" = "black"
            ),
            selected = "ordin",
            selectize = FALSE
          )
        ),
        
        # Export settings
        div(style = "margin-top: 12px; padding-top: 12px; border-top: 1px solid #3e3e42;",
          tags$label(style = "color: #2e8b57; font-size: 12px; font-weight: 600; display: block; margin-bottom: 8px;", "💾 Export Settings:"),
          
          div(style = "display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 8px;",
            div(
              tags$label(style = "color: #cccccc; font-size: 11px; display: block; margin-bottom: 4px;", "Width (in):"),
              numericInput(ns("width"), NULL, value = 10, min = 4, max = 20, step = 1)
            ),
            div(
              tags$label(style = "color: #cccccc; font-size: 11px; display: block; margin-bottom: 4px;", "Height (in):"),
              numericInput(ns("height"), NULL, value = 6, min = 4, max = 20, step = 1)
            ),
            div(
              tags$label(style = "color: #cccccc; font-size: 11px; display: block; margin-bottom: 4px;", "DPI:"),
              selectInput(
                ns("dpi"),
                NULL,
                choices = c("300 (Print)" = "300", "600 (High-res)" = "600", "150 (Screen)" = "150"),
                selected = "300",
                selectize = FALSE
              )
            )
          )
        )
      )
    )
  )
}

#' Get Plot Theme
#' @param theme Theme name
#' @param font_size Base font size
get_plot_theme <- function(theme = "bw", font_size = 12) {
  base_theme <- switch(theme,
    "bw" = theme_bw(),
    "minimal" = theme_minimal(),
    "light" = theme_light(),
    "dark" = theme_dark(),
    "publication" = theme_classic(),
    theme_bw()
  )
  
  base_theme + theme(
    text = element_text(size = font_size),
    axis.title = element_text(size = font_size, face = "bold"),
    axis.text = element_text(size = font_size - 2),
    legend.text = element_text(size = font_size - 2),
    legend.title = element_text(size = font_size, face = "bold"),
    plot.title = element_text(size = font_size + 2, face = "bold", hjust = 0.5),
    panel.grid.minor = element_blank()
  )
}

#' Get Color Palette
#' @param palette_name Palette name
#' @param n Number of colors needed
get_color_palette <- function(palette_name = "ordin", n = 3) {
  switch(palette_name,
    "ordin" = {
      if (n <= 3) {
        c("#2e8b57", "#007acc", "#d4a017")
      } else {
        colorRampPalette(c("#2e8b57", "#007acc", "#d4a017", "#e74c3c", "#9b59b6"))(n)
      }
    },
    "viridis" = viridis::viridis(n),
    "plasma" = viridis::plasma(n),
    "colorblind" = {
      # Wong's colorblind-safe palette
      colors <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7", "#000000")
      if (n <= length(colors)) colors[1:n] else colorRampPalette(colors)(n)
    },
    "gray" = gray.colors(n, start = 0.3, end = 0.7),
    "black" = rep("black", n),
    c("#2e8b57", "#007acc", "#d4a017")  # default
  )
}

#' Apply Custom Labels
#' @param plot ggplot object
#' @param title Plot title
#' @param x_label X-axis label
#' @param y_label Y-axis label
apply_custom_labels <- function(plot, title = NULL, x_label = NULL, y_label = NULL) {
  if (!is.null(title) && title != "") {
    plot <- plot + ggtitle(title)
  }
  if (!is.null(x_label) && x_label != "") {
    plot <- plot + xlab(x_label)
  }
  if (!is.null(y_label) && y_label != "") {
    plot <- plot + ylab(y_label)
  }
  plot
}

#' Plot Customization Server
#' @description Returns reactive values with all customization settings
plot_customization_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Return reactive list of all settings
    reactive({
      list(
        theme = input$theme,
        font_size = input$font_size,
        line_width = input$line_width,
        point_size = input$point_size,
        legend_position = input$legend_position,
        title = input$title,
        x_label = input$x_label,
        y_label = input$y_label,
        color_palette = input$color_palette,
        width = input$width,
        height = input$height,
        dpi = as.numeric(input$dpi)
      )
    })
  })
}
