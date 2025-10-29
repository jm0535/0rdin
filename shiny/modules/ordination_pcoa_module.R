# Ördin - PCoA Module
# Principal Coordinates Analysis

library(shiny)
library(vegan)

pcoa_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(class = "config-panel",
      h3("⚙️ PCoA Configuration"),
      selectInput(ns("distance"), "Distance:",
                 choices = c("Bray-Curtis" = "bray", "Jaccard" = "jaccard", 
                            "Euclidean" = "euclidean")),
      actionButton(ns("run_pcoa"), "▶ Run PCoA", class = "btn-success", style = "width: 100%;")
    ),
    div(class = "horizontal-split",
      div(class = "plot-panel",
        # Plot Customization Panel
        div(style = "background: #1a1a1a; padding: 15px; margin: 10px 0; border-radius: 5px;",
          h4("🎨 Plot Customization", style = "color: #2e8b57; margin-bottom: 15px; cursor: pointer;",
             onclick = paste0("$('#", ns("plot_custom"), "').toggle();")),
          
          div(id = ns("plot_custom"), class = "plot-customization-grid",
            # Row 1
            div(selectInput(ns("theme"), "Theme:",
              choices = c("Clean" = "bw", "Minimal" = "minimal", "Dark" = "dark"),
              selected = "bw")),
            div(selectInput(ns("font_family"), "Font:",
              choices = c("Sans" = "sans", "Serif" = "serif", "Mono" = "mono"),
              selected = "sans")),
            div(numericInput(ns("base_size"), "Font Size:", value = 12, min = 8, max = 20, step = 1)),
            div(numericInput(ns("title_size"), "Title Size:", value = 14, min = 10, max = 24, step = 1)),
            div(numericInput(ns("point_size"), "Point Size:", value = 2, min = 0.5, max = 5, step = 0.5)),
            div(selectInput(ns("point_shape"), "Shape:",
              choices = c("Circle" = 21, "Square" = 22, "Diamond" = 23, "Triangle" = 24),
              selected = 21)),
            # Row 2
            div(selectInput(ns("point_color"), "Point Color:",
              choices = c("Ördin Green" = "#2e8b57", "Blue" = "#007acc", "Orange" = "#d4a017", 
                          "Red" = "#e74c3c", "Purple" = "#9b59b6", "Teal" = "#1abc9c"),
              selected = "#2e8b57")),
            div(numericInput(ns("point_lwd"), "Border Width:", value = 1.5, min = 0.5, max = 3, step = 0.5)),
            div(checkboxInput(ns("show_grid"), "Show Grid", value = TRUE)),
            div(checkboxInput(ns("show_labels"), "Site Labels", value = FALSE)),
            div(numericInput(ns("plot_width"), "Width (in):", value = 8, min = 4, max = 20, step = 1)),
            div(numericInput(ns("plot_height"), "Height (in):", value = 6, min = 4, max = 16, step = 1)),
            # Row 3
            div(numericInput(ns("dpi"), "DPI:", value = 300, min = 72, max = 600, step = 50)),
            div(selectInput(ns("export_format"), "Format:",
              choices = c("PNG" = "png", "PDF" = "pdf", "SVG" = "svg"),
              selected = "png")),
            div(numericInput(ns("label_size"), "Label Size:", value = 0.8, min = 0.3, max = 2, step = 0.1)),
            div(selectInput(ns("label_pos"), "Label Pos:",
              choices = c("Auto" = 0, "Below" = 1, "Left" = 2, "Above" = 3, "Right" = 4),
              selected = 0)),
            div(numericInput(ns("axis_lwd"), "Axis Width:", value = 1, min = 0.5, max = 3, step = 0.5)),
            div(checkboxInput(ns("equal_aspect"), "Equal Aspect", value = TRUE))
          )
        ),
        plotOutput(ns("pcoa_plot"), height = "500px"),
        downloadButton(ns("export_plot"), "💾 Export Plot", class = "btn-sm", style = "margin-top: 10px;")
      ),
      div(class = "results-panel",
        h3("📊 EIGENVALUES"),
        tableOutput(ns("eigen_table")),
        downloadButton(ns("export_results"), "📋 Export CSV", class = "btn-sm")
      )
    )
  )
}

pcoa_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    pcoa_result <- reactiveVal(NULL)
    
    observeEvent(input$run_pcoa, {
      req(data())
      result <- tryCatch({
        capscale(data() ~ 1, distance = input$distance)
      }, error = function(e) NULL)
      
      if (!is.null(result)) {
        pcoa_result(result)
        showNotification("✓ PCoA Complete!", type = "message")
      }
    })
    
    output$pcoa_plot <- renderPlot({  
      req(pcoa_result())
      
      # Determine colors based on theme
      is_dark <- input$theme == "dark"
      bg_color <- if(is_dark) "#1a1a1a" else "white"
      fg_color <- if(is_dark) "#cccccc" else "#1e1e1e"
      title_color <- if(is_dark) "#5fd38d" else "#2e8b57"
      grid_color <- if(is_dark) "#404040" else "#cccccc40"
      
      par(family = input$font_family, bg = bg_color, fg = fg_color, col.axis = fg_color,
          col.lab = fg_color, col.main = title_color, cex = input$base_size / 12,
          cex.main = input$title_size / 12, lwd = input$axis_lwd)
      
      if(input$equal_aspect) {
        plot(pcoa_result(), type = "none", main = "PCoA Ordination", font.main = 2)
        usr <- par("usr")
        pin <- par("pin")
        if(pin[1] > pin[2]) {
          par(usr = c(mean(usr[1:2]) - diff(usr[3:4])/2, mean(usr[1:2]) + diff(usr[3:4])/2, usr[3:4]))
        } else {
          par(usr = c(usr[1:2], mean(usr[3:4]) - diff(usr[1:2])/2, mean(usr[3:4]) + diff(usr[1:2])/2))
        }
      } else {
        plot(pcoa_result(), type = "none", main = "PCoA Ordination", font.main = 2)
      }
      
      if(input$show_grid) grid(col = grid_color, lty = 1)
      points(pcoa_result(), display = "sites", pch = as.numeric(input$point_shape),
             bg = input$point_color, cex = input$point_size, col = fg_color, lwd = input$point_lwd)
      if(input$show_labels) {
        text(pcoa_result(), display = "sites", cex = input$label_size,
             pos = as.numeric(input$label_pos), col = fg_color)
      }
    })
    
    output$export_plot <- downloadHandler(
      filename = function() paste0("pcoa_plot_", Sys.Date(), ".", input$export_format),
      content = function(file) {
        is_dark <- input$theme == "dark"
        bg_color <- if(is_dark) "#1a1a1a" else "white"
        fg_color <- if(is_dark) "#cccccc" else "#1e1e1e"
        title_color <- if(is_dark) "#5fd38d" else "#2e8b57"
        grid_color <- if(is_dark) "#404040" else "#cccccc40"
        
        if(input$export_format == "png") {
          png(file, width = input$plot_width * input$dpi, height = input$plot_height * input$dpi, res = input$dpi, bg = bg_color)
        } else if(input$export_format == "pdf") {
          pdf(file, width = input$plot_width, height = input$plot_height, bg = bg_color)
        } else {
          svg(file, width = input$plot_width, height = input$plot_height, bg = bg_color)
        }
        
        par(family = input$font_family, bg = bg_color, fg = fg_color, col.axis = fg_color,
            col.lab = fg_color, col.main = title_color, cex = input$base_size / 12,
            cex.main = input$title_size / 12, lwd = input$axis_lwd)
        
        if(input$equal_aspect) {
          plot(pcoa_result(), type = "none", main = "PCoA Ordination", font.main = 2)
          usr <- par("usr"); pin <- par("pin")
          if(pin[1] > pin[2]) {
            par(usr = c(mean(usr[1:2]) - diff(usr[3:4])/2, mean(usr[1:2]) + diff(usr[3:4])/2, usr[3:4]))
          } else {
            par(usr = c(usr[1:2], mean(usr[3:4]) - diff(usr[1:2])/2, mean(usr[3:4]) + diff(usr[1:2])/2))
          }
        } else {
          plot(pcoa_result(), type = "none", main = "PCoA Ordination", font.main = 2)
        }
        
        if(input$show_grid) grid(col = grid_color, lty = 1)
        points(pcoa_result(), display = "sites", pch = as.numeric(input$point_shape),
               bg = input$point_color, cex = input$point_size, col = fg_color, lwd = input$point_lwd)
        if(input$show_labels) {
          text(pcoa_result(), display = "sites", cex = input$label_size,
               pos = as.numeric(input$label_pos), col = fg_color)
        }
        dev.off()
      }
    )
    
    output$eigen_table <- renderTable({
      req(pcoa_result())
      eig <- eigenvals(pcoa_result())
      data.frame(
        Axis = paste0("PCo", 1:min(6, length(eig))),
        Eigenvalue = sprintf("%.4f", eig[1:min(6, length(eig))]),
        `Variance (%)` = sprintf("%.2f", eig[1:min(6, length(eig))] / sum(eig[eig > 0]) * 100),
        check.names = FALSE
      )
    })
    
    output$export_results <- downloadHandler(
      filename = function() paste0("pcoa_results_", Sys.Date(), ".csv"),
      content = function(file) {
        scores_df <- as.data.frame(scores(pcoa_result(), display = "sites"))
        write.csv(scores_df, file, row.names = TRUE)
      }
    )
  })
}
