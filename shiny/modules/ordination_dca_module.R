# Ördin - DCA Module
# Detrended Correspondence Analysis

library(shiny)
library(vegan)

dca_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(class = "config-panel",
      h3("⚙️ DCA Configuration"),
      actionButton(ns("run_dca"), "▶ Run DCA", class = "btn-success", style = "width: 100%;")
    ),
    div(class = "horizontal-split",
      div(class = "plot-panel",
        plotOutput(ns("dca_plot"), height = "500px"),
        downloadButton(ns("export_plot"), "💾 Export Plot", class = "btn-sm", style = "margin-top: 10px;")
      ),
      div(class = "results-panel",
        h3("📊 AXIS LENGTHS"),
        tableOutput(ns("lengths_table")),
        downloadButton(ns("export_results"), "📋 Export CSV", class = "btn-sm")
      )
    )
  )
}

dca_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    dca_result <- reactiveVal(NULL)
    
    plot_defaults <- reactiveValues(
      theme = "bw", font_family = "sans", base_size = 12, title_size = 14,
      point_size = 2, point_shape = "21", point_color = "#2e8b57", point_lwd = 1.5,
      show_grid = TRUE, show_labels = FALSE, plot_width = 8, plot_height = 6,
      dpi = 300, export_format = "png", label_size = 0.8, label_pos = "0",
      axis_lwd = 1, equal_aspect = TRUE
    )
    
    observeEvent(input$plot_theme, { plot_defaults$theme <- input$plot_theme })
    observeEvent(input$plot_font_family, { plot_defaults$font_family <- input$plot_font_family })
    observeEvent(input$plot_base_size, { plot_defaults$base_size <- input$plot_base_size })
    observeEvent(input$plot_title_size, { plot_defaults$title_size <- input$plot_title_size })
    observeEvent(input$plot_point_size, { plot_defaults$point_size <- input$plot_point_size })
    observeEvent(input$plot_point_shape, { plot_defaults$point_shape <- input$plot_point_shape })
    observeEvent(input$plot_point_color, { plot_defaults$point_color <- input$plot_point_color })
    observeEvent(input$plot_point_lwd, { plot_defaults$point_lwd <- input$plot_point_lwd })
    observeEvent(input$plot_show_grid, { plot_defaults$show_grid <- input$plot_show_grid })
    observeEvent(input$plot_show_labels, { plot_defaults$show_labels <- input$plot_show_labels })
    observeEvent(input$plot_label_size, { plot_defaults$label_size <- input$plot_label_size })
    observeEvent(input$plot_width, { plot_defaults$plot_width <- input$plot_width })
    observeEvent(input$plot_height, { plot_defaults$plot_height <- input$plot_height })
    observeEvent(input$plot_dpi, { plot_defaults$dpi <- input$plot_dpi })
    observeEvent(input$plot_export_format, { plot_defaults$export_format <- input$plot_export_format })
    
    observeEvent(input$run_dca, {
      req(data())
      result <- tryCatch(decorana(data()), error = function(e) NULL)
      if (!is.null(result)) {
        dca_result(result)
        showNotification("✓ DCA Complete!", type = "message")
      }
    })
    
    output$dca_plot <- renderPlot({  
      req(dca_result())
      is_dark <- plot_defaults$theme == "dark"
      bg_color <- if(is_dark) "#1a1a1a" else "white"
      fg_color <- if(is_dark) "#cccccc" else "#1e1e1e"
      title_color <- if(is_dark) "#5fd38d" else "#2e8b57"
      grid_color <- if(is_dark) "#404040" else "#cccccc40"
      par(family = plot_defaults$font_family, bg = bg_color, fg = fg_color, col.axis = fg_color,
          col.lab = fg_color, col.main = title_color, cex = plot_defaults$base_size / 12,
          cex.main = plot_defaults$title_size / 12, lwd = plot_defaults$axis_lwd)
      if(plot_defaults$equal_aspect) {
        plot(dca_result(), type = "none", main = "DCA Ordination", font.main = 2)
        usr <- par("usr"); pin <- par("pin")
        if(pin[1] > pin[2]) par(usr = c(mean(usr[1:2]) - diff(usr[3:4])/2, mean(usr[1:2]) + diff(usr[3:4])/2, usr[3:4]))
        else par(usr = c(usr[1:2], mean(usr[3:4]) - diff(usr[1:2])/2, mean(usr[3:4]) + diff(usr[1:2])/2))
      } else plot(dca_result(), type = "none", main = "DCA Ordination", font.main = 2)
      if(plot_defaults$show_grid) grid(col = grid_color, lty = 1)
      points(dca_result(), display = "sites", pch = as.numeric(plot_defaults$point_shape),
             bg = plot_defaults$point_color, cex = plot_defaults$point_size, col = fg_color, lwd = plot_defaults$point_lwd)
      if(plot_defaults$show_labels) text(dca_result(), display = "sites", cex = plot_defaults$label_size,
                                 pos = as.numeric(plot_defaults$label_pos), col = fg_color)
    })
    
    output$export_plot <- downloadHandler(
      filename = function() paste0("dca_plot_", Sys.Date(), ".", plot_defaults$export_format),
      content = function(file) {
        is_dark <- plot_defaults$theme == "dark"
        bg_color <- if(is_dark) "#1a1a1a" else "white"
        fg_color <- if(is_dark) "#cccccc" else "#1e1e1e"
        title_color <- if(is_dark) "#5fd38d" else "#2e8b57"
        grid_color <- if(is_dark) "#404040" else "#cccccc40"
        if(plot_defaults$export_format == "png") png(file, width = plot_defaults$plot_width * plot_defaults$dpi, height = plot_defaults$plot_height * plot_defaults$dpi, res = plot_defaults$dpi, bg = bg_color)
        else if(plot_defaults$export_format == "pdf") pdf(file, width = plot_defaults$plot_width, height = plot_defaults$plot_height, bg = bg_color)
        else svg(file, width = plot_defaults$plot_width, height = plot_defaults$plot_height, bg = bg_color)
        par(family = plot_defaults$font_family, bg = bg_color, fg = fg_color, col.axis = fg_color,
            col.lab = fg_color, col.main = title_color, cex = plot_defaults$base_size / 12,
            cex.main = plot_defaults$title_size / 12, lwd = plot_defaults$axis_lwd)
        if(plot_defaults$equal_aspect) {
          plot(dca_result(), type = "none", main = "DCA Ordination", font.main = 2)
          usr <- par("usr"); pin <- par("pin")
          if(pin[1] > pin[2]) par(usr = c(mean(usr[1:2]) - diff(usr[3:4])/2, mean(usr[1:2]) + diff(usr[3:4])/2, usr[3:4]))
          else par(usr = c(usr[1:2], mean(usr[3:4]) - diff(usr[1:2])/2, mean(usr[3:4]) + diff(usr[1:2])/2))
        } else plot(dca_result(), type = "none", main = "DCA Ordination", font.main = 2)
        if(plot_defaults$show_grid) grid(col = grid_color, lty = 1)
        points(dca_result(), display = "sites", pch = as.numeric(plot_defaults$point_shape),
               bg = plot_defaults$point_color, cex = plot_defaults$point_size, col = fg_color, lwd = plot_defaults$point_lwd)
        if(plot_defaults$show_labels) text(dca_result(), display = "sites", cex = plot_defaults$label_size,
                                   pos = as.numeric(plot_defaults$label_pos), col = fg_color)
        dev.off()
      }
    )
    
    output$lengths_table <- renderTable({
      req(dca_result())
      lengths <- dca_result()$evals
      data.frame(
        Axis = paste0("DCA", 1:4),
        Length = sprintf("%.3f", lengths[1:4]),
        Interpretation = c(
          if(lengths[1] > 4) "Long gradient (unimodal)" else "Short gradient (linear)",
          if(lengths[2] > 4) "Long gradient" else "Short gradient",
          "Secondary gradient",
          "Tertiary gradient"
        )
      )
    })
    
    output$export_results <- downloadHandler(
      filename = function() paste0("dca_results_", Sys.Date(), ".csv"),
      content = function(file) {
        scores_df <- as.data.frame(scores(dca_result(), display = "sites"))
        write.csv(scores_df, file, row.names = TRUE)
      }
    )
  })
}
