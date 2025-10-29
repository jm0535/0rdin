# Ördin - CA Module  
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Correspondence Analysis (CA) ordination workflow

library(shiny)
library(vegan)
library(waiter)
# library(shinyFeedback)  # Disabled - conflicts with custom HTML

#' CA Module UI
ca_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    useShinyFeedback(),
    
    div(class = "ca-workflow",
      div(class = "config-panel",
        h3("⚙️ CA Configuration"),
        
        helpText("CA is ideal for unimodal species responses and gradient analysis."),
        
        # Run button
        div(class = "action-buttons", style = "margin-top: 20px;",
          actionButton(ns("run_ca"), "▶ Run CA", class = "btn-success", style = "width: 100%;")
        )
      ),
      
      div(class = "horizontal-split",
        div(class = "plot-panel",
          uiOutput(ns("inertia_interpretation")),
          
          plotOutput(ns("ca_plot"), height = "500px"),
          div(class = "plot-controls", style = "margin-top: 10px;",
            downloadButton(ns("export_plot"), "💾 Export Plot", class = "btn-sm")
          )
        ),
        
        div(class = "results-panel",
          div(class = "results-section",
            h3("📊 INERTIA & VARIANCE"),
            tableOutput(ns("inertia_table"))
          ),
          
          div(class = "action-buttons", style = "margin-top: 20px;",
            downloadButton(ns("export_results"), "📋 Export CSV", class = "btn-sm")
          )
        )
      )
    )
  )
}

#' CA Module Server
ca_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ca_result <- reactiveVal(NULL)
    
    # Default plot customization values
    plot_defaults <- reactiveValues(
      theme = "bw", font_family = "sans", base_size = 12, title_size = 14,
      point_size = 2, point_shape = "21", point_color = "#2e8b57", point_lwd = 1.5,
      show_grid = TRUE, show_labels = FALSE, plot_width = 8, plot_height = 6,
      dpi = 300, export_format = "png", label_size = 0.8, label_pos = "0",
      axis_lwd = 1, equal_aspect = TRUE
    )
    
    # Observers
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
    
    observeEvent(input$run_ca, {
      req(data())
      
      waiter_show(html = tagList(
        spin_fading_circles(),
        h3("Running CA...", style = "color: #2e8b57; margin-top: 20px;")
      ))
      
      result <- tryCatch({
        cca(data())  # cca() without constraints = CA
      }, error = function(e) {
        waiter_hide()
        showNotification(paste("❌ CA failed:", e$message), type = "error")
        NULL
      })
      
      waiter_hide()
      
      if (!is.null(result)) {
        ca_result(result)
        
        eig <- eigenvals(result)
        var_exp <- sum(eig[1:2]) / sum(eig) * 100
        
        showNotification(
          HTML(sprintf("<strong>✓ CA Complete!</strong><br/>First 2 axes: %.1f%% inertia", var_exp)),
          type = "message"
        )
      }
    })
    
    output$inertia_interpretation <- renderUI({
      req(ca_result())
      
      eig <- eigenvals(ca_result())
      var_ca1 <- eig[1] / sum(eig) * 100
      var_ca2 <- eig[2] / sum(eig) * 100
      total <- var_ca1 + var_ca2
      
      color <- if(total >= 50) "#2e8b57" else "#d4a017"
      
      HTML(sprintf('
        <div style="background: %s20; border-left: 3px solid %s; padding: 16px; margin: 20px 0;">
          <h4 style="color: %s; margin: 0 0 8px 0;">Total inertia explained: %.1f%%</h4>
          <p style="color: #ccc; font-size: 12px;">CA1: %.1f%% | CA2: %.1f%%</p>
        </div>
      ', color, color, color, total, var_ca1, var_ca2))
    })
    
    output$ca_plot <- renderPlot({  
      req(ca_result())
      is_dark <- plot_defaults$theme == "dark"
      bg_color <- if(is_dark) "#1a1a1a" else "white"
      fg_color <- if(is_dark) "#cccccc" else "#1e1e1e"
      title_color <- if(is_dark) "#5fd38d" else "#2e8b57"
      grid_color <- if(is_dark) "#404040" else "#cccccc40"
      par(family = plot_defaults$font_family, bg = bg_color, fg = fg_color, col.axis = fg_color,
          col.lab = fg_color, col.main = title_color, cex = plot_defaults$base_size / 12,
          cex.main = plot_defaults$title_size / 12, lwd = plot_defaults$axis_lwd)
      if(plot_defaults$equal_aspect) {
        plot(ca_result(), type = "none", main = "CA Ordination", font.main = 2)
        usr <- par("usr"); pin <- par("pin")
        if(pin[1] > pin[2]) par(usr = c(mean(usr[1:2]) - diff(usr[3:4])/2, mean(usr[1:2]) + diff(usr[3:4])/2, usr[3:4]))
        else par(usr = c(usr[1:2], mean(usr[3:4]) - diff(usr[1:2])/2, mean(usr[3:4]) + diff(usr[1:2])/2))
      } else plot(ca_result(), type = "none", main = "CA Ordination", font.main = 2)
      if(plot_defaults$show_grid) grid(col = grid_color, lty = 1)
      points(ca_result(), display = "sites", pch = as.numeric(plot_defaults$point_shape),
             bg = plot_defaults$point_color, cex = plot_defaults$point_size, col = fg_color, lwd = plot_defaults$point_lwd)
      if(plot_defaults$show_labels) text(ca_result(), display = "sites", cex = plot_defaults$label_size,
                                 pos = as.numeric(plot_defaults$label_pos), col = fg_color)
    })
    
    output$inertia_table <- renderTable({
      req(ca_result())
      eig <- eigenvals(ca_result())
      data.frame(
        Axis = paste0("CA", 1:min(6, length(eig))),
        Eigenvalue = sprintf("%.4f", eig[1:min(6, length(eig))]),
        `Inertia (%)` = sprintf("%.2f", eig[1:min(6, length(eig))] / sum(eig) * 100),
        check.names = FALSE
      )
    })
    
    output$export_plot <- downloadHandler(
      filename = function() paste0("ca_plot_", Sys.Date(), ".", plot_defaults$export_format),
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
          plot(ca_result(), type = "none", main = "CA Ordination", font.main = 2)
          usr <- par("usr"); pin <- par("pin")
          if(pin[1] > pin[2]) par(usr = c(mean(usr[1:2]) - diff(usr[3:4])/2, mean(usr[1:2]) + diff(usr[3:4])/2, usr[3:4]))
          else par(usr = c(usr[1:2], mean(usr[3:4]) - diff(usr[1:2])/2, mean(usr[3:4]) + diff(usr[1:2])/2))
        } else plot(ca_result(), type = "none", main = "CA Ordination", font.main = 2)
        if(plot_defaults$show_grid) grid(col = grid_color, lty = 1)
        points(ca_result(), display = "sites", pch = as.numeric(plot_defaults$point_shape),
               bg = plot_defaults$point_color, cex = plot_defaults$point_size, col = fg_color, lwd = plot_defaults$point_lwd)
        if(plot_defaults$show_labels) text(ca_result(), display = "sites", cex = plot_defaults$label_size,
                                   pos = as.numeric(plot_defaults$label_pos), col = fg_color)
        dev.off()
      }
    )
    
    output$export_results <- downloadHandler(
      filename = function() paste0("ca_results_", Sys.Date(), ".csv"),
      content = function(file) {
        scores_df <- as.data.frame(scores(ca_result(), display = "sites"))
        write.csv(scores_df, file, row.names = TRUE)
      }
    )
  })
}
