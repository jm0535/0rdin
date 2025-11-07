# Ördin - ANOSIM Module
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Analysis of Similarities - Tests differences between groups using ranks

library(shiny)
library(vegan)
library(waiter)

#' ANOSIM Module UI
anosim_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(class = "anosim-workflow",
      div(class = "config-panel",
        h3("⚙️ ANOSIM Configuration"),
        
        # When to use ANOSIM
        div(style = "background: #4a90e220; border-left: 3px solid #4a90e2; padding: 12px; margin-bottom: 16px;",
          h4(style = "color: #4a90e2; margin: 0 0 8px 0; font-size: 13px; font-weight: 600;", "📘 WHEN TO USE ANOSIM"),
          tags$ul(style = "color: #ccc; font-size: 11px; margin: 0; padding-left: 20px; line-height: 1.6;",
            tags$li("Test if **groups are well separated** using **rank-based** approach"),
            tags$li("Compare **2 or more groups** (simpler than PERMANOVA)"),
            tags$li("R statistic: **0 = no separation**, **1 = complete separation**"),
            tags$li("Example: Are forest vs grassland communities different?")
          )
        ),
        
        helpText("Tests if group centroids differ (rank-based approach, similar to PERMANOVA)."),
        
        selectInput(ns("distance"), "Distance/Dissimilarity:",
                   choices = c("Bray-Curtis" = "bray", "Jaccard" = "jaccard"),
                   selected = "bray",
                   selectize = FALSE),
        
        uiOutput(ns("group_var_ui")),
        
        numericInput(ns("permutations"), "Permutations:", value = 999, min = 99, max = 9999, step = 100),
        
        div(class = "action-buttons", style = "margin-top: 20px;",
          actionButton(ns("run_anosim"), "▶ Run ANOSIM", class = "btn-success", style = "width: 100%;")
        )
      ),
      
      div(class = "horizontal-split",
        div(class = "plot-panel", style = "max-width: 100%; overflow: hidden;",
          uiOutput(ns("anosim_interpretation")),
          plotOutput(ns("anosim_plot"), width = "100%", height = "400px"),
          div(class = "action-buttons", style = "margin-top: 10px;",
            downloadButton(ns("download_plot"), "📋 Export Plot", class = "btn-sm")
          )
        ),
        
        div(class = "results-panel",
          div(class = "results-section",
            h3("📊 ANOSIM RESULTS"),
            tableOutput(ns("anosim_table"))
          ),
          
          div(class = "action-buttons", style = "margin-top: 20px;",
            downloadButton(ns("export_results"), "📋 Export CSV", class = "btn-sm")
          )
        )
      )
    )
  )
}

#' ANOSIM Module Server
anosim_server <- function(id, data, env_data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    anosim_result <- reactiveVal(NULL)
    
    output$group_var_ui <- renderUI({
      req(env_data())
      categorical_vars <- names(env_data())[sapply(env_data(), function(x) is.factor(x) || is.character(x))]
      
      if (length(categorical_vars) == 0) {
        div(style = "background: #d4a01720; border-left: 3px solid #d4a017; padding: 12px;",
          p(style = "color: #d4a017; font-size: 12px; margin: 0;", "⚠️ No grouping variables found"))
      } else {
        selectInput(ns("group_var"), "Grouping Variable:", choices = categorical_vars, selected = categorical_vars[1])
      }
    })
    
    observeEvent(input$run_anosim, {
      req(data())
      
      # Check if environmental data exists
      if (is.null(env_data()) || nrow(env_data()) == 0) {
        showNotification(
          "❌ ANOSIM requires environmental data. Please upload environmental variables first.",
          type = "error",
          duration = 8
        )
        return()
      }
      
      # Check if grouping variable is selected
      if (is.null(input$group_var) || input$group_var == "") {
        showNotification(
          "❌ Please select a grouping variable.",
          type = "error",
          duration = 8
        )
        return()
      }
      
      waiter_show(html = tagList(spin_fading_circles(), h3("Running ANOSIM...", style = "color: #2e8b57; margin-top: 20px;")))
      
      result <- tryCatch({
        dist_matrix <- vegdist(data(), method = input$distance)
        grouping <- env_data()[[input$group_var]]
        anosim(dist_matrix, grouping, permutations = input$permutations)
      }, error = function(e) {
        waiter_hide()
        showNotification(paste("❌ ANOSIM failed:", e$message), type = "error")
        NULL
      })
      
      waiter_hide()
      
      if (!is.null(result)) {
        anosim_result(result)
        showNotification(HTML(sprintf("<strong>✓ ANOSIM Complete!</strong><br/>R = %.4f, p = %.4f", result$statistic, result$signif)), type = "message")
      }
    })
    
    output$anosim_interpretation <- renderUI({
      req(anosim_result())
      r_stat <- anosim_result()$statistic
      p_value <- anosim_result()$signif
      
      color <- if(p_value < 0.05 && r_stat > 0.5) "#2e8b57" else if(p_value < 0.05) "#d4a017" else "#888"
      quality <- if(r_stat > 0.75) "Strong" else if(r_stat > 0.5) "Moderate" else "Weak"
      
      HTML(sprintf('<div style="background: %s20; border-left: 3px solid %s; padding: 16px; margin: 20px 0;">
        <h4 style="color: %s; margin: 0 0 8px 0;">%s separation (R = %.4f, p = %.4f)</h4>
        <p style="color: #ccc; font-size: 12px;">R close to 1 = groups well separated, R close to 0 = no separation</p>
      </div>', color, color, color, quality, r_stat, p_value))
    })
    
    output$anosim_table <- renderTable({
      req(anosim_result())
      data.frame(
        Statistic = "R statistic",
        Value = sprintf("%.4f", anosim_result()$statistic),
        `p-value` = sprintf("%.4f", anosim_result()$signif),
        Permutations = anosim_result()$permutations,
        check.names = FALSE
      )
    })
    
    output$anosim_plot <- renderPlot({
      req(anosim_result())
      par(family = "sans", bg = "#252526", fg = "#cccccc", 
          col.axis = "#cccccc", col.lab = "#cccccc", col.main = "#2e8b57",
          mar = c(5, 4, 4, 2))  # Standard margins
      plot(anosim_result(), main = "ANOSIM Rank Dissimilarities", 
           col = c("#2e8b57", "#d4a017"))
      grid(col = "#404040", lty = 1)
    }, res = 96)
    
    output$download_plot <- downloadHandler(
      filename = function() paste0("anosim_plot_", Sys.Date(), ".", plot_defaults$export_format),
      content = function(file) {
        if(plot_defaults$export_format == "png") {
          png(file, width = plot_defaults$plot_width * plot_defaults$dpi, height = plot_defaults$plot_height * plot_defaults$dpi, res = plot_defaults$dpi)
        } else if(plot_defaults$export_format == "pdf") {
          pdf(file, width = plot_defaults$plot_width, height = plot_defaults$plot_height)
        } else if(plot_defaults$export_format == "svg") {
          svg(file, width = plot_defaults$plot_width, height = plot_defaults$plot_height)
        } else if(plot_defaults$export_format == "tiff") {
          tiff(file, width = plot_defaults$plot_width * plot_defaults$dpi, height = plot_defaults$plot_height * plot_defaults$dpi, res = plot_defaults$dpi, compression = "lzw")
        }
        par(family = "sans", bg = "#252526", fg = "#cccccc", 
            col.axis = "#cccccc", col.lab = "#cccccc", col.main = "#2e8b57",
            mar = c(5, 4, 4, 2))
        plot(anosim_result(), main = "ANOSIM Rank Dissimilarities", 
             col = c("#2e8b57", "#d4a017"))
        grid(col = "#404040", lty = 1)
        dev.off()
      }
    )
    
    output$export_results <- downloadHandler(
      filename = function() paste0("anosim_results_", Sys.Date(), ".csv"),
      content = function(file) {
        write.csv(data.frame(R = anosim_result()$statistic, p_value = anosim_result()$signif), file, row.names = FALSE)
      }
    )
  })
}
