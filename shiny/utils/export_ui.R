# Export UI Helper Functions
# Provides consistent export options across all modules

#' Create export options UI
#' @param id Module namespace ID
#' @return Shiny UI elements for export options
export_options_ui <- function(id) {
  ns <- NS(id)
  
  div(
    style = "background: #2d2d30; padding: 16px; margin-top: 16px; border-radius: 4px; border: 1px solid #3e3e42;",
    h4(style = "color: #2e8b57; margin-top: 0; margin-bottom: 12px; font-size: 14px; font-weight: 600;", "📥 EXPORT OPTIONS"),
    
    div(
      style = "display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 12px;",
      
      # Format selection
      div(
        tags$label(style = "color: #888; font-size: 12px; display: block; margin-bottom: 4px;", "Format"),
        selectInput(
          ns("export_format"),
          NULL,
          choices = c("PNG" = "png", "PDF" = "pdf", "SVG" = "svg", "TIFF" = "tiff"),
          selected = "png",
          width = "100%",
          selectize = FALSE
        )
      ),
      
      # DPI selection
      div(
        tags$label(style = "color: #888; font-size: 12px; display: block; margin-bottom: 4px;", "DPI (PNG/TIFF)"),
        selectInput(
          ns("export_dpi"),
          NULL,
          choices = c("150" = 150, "300" = 300, "600" = 600),
          selected = 300,
          width = "100%",
          selectize = FALSE
        )
      ),
      
      # Width
      div(
        tags$label(style = "color: #888; font-size: 12px; display: block; margin-bottom: 4px;", "Width (inches)"),
        numericInput(
          ns("export_width"),
          NULL,
          value = 8,
          min = 4,
          max = 20,
          step = 1,
          width = "100%"
        )
      ),
      
      # Height
      div(
        tags$label(style = "color: #888; font-size: 12px; display: block; margin-bottom: 4px;", "Height (inches)"),
        numericInput(
          ns("export_height"),
          NULL,
          value = 6,
          min = 4,
          max = 20,
          step = 1,
          width = "100%"
        )
      )
    ),
    
    # Export button
    div(
      style = "margin-top: 12px;",
      downloadButton(
        ns("download_plot"),
        "💾 Download Plot",
        style = "background: #2e8b57; color: white; border: none; padding: 8px 16px; width: 100%; font-weight: 600;"
      )
    )
  )
}

#' Get export settings from UI
#' @param input Shiny input object
#' @param id Module namespace ID  
#' @return List of export settings
get_export_settings <- function(input, id = NULL) {
  if (!is.null(id)) {
    list(
      format = input[[paste0(id, "-export_format")]],
      dpi = as.numeric(input[[paste0(id, "-export_dpi")]]),
      width = input[[paste0(id, "-export_width")]],
      height = input[[paste0(id, "-export_height")]]
    )
  } else {
    list(
      format = input$export_format,
      dpi = as.numeric(input$export_dpi),
      width = input$export_width,
      height = input$export_height
    )
  }
}
