# Ördin - CAP Module
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Canonical Analysis of Principal Coordinates (CAP) - Constrained PCoA

library(shiny)
library(vegan)
library(waiter)

#' CAP Module UI
cap_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(class = "cap-workflow",
      div(class = "config-panel",
        h3("⚙️ CAP Configuration"),
        
        helpText("CAP is a constrained form of PCoA. Ideal for analyzing community patterns constrained by environmental factors."),
        
        # Distance metric
        selectInput(ns("distance"), "Distance/Dissimilarity:",
                   choices = c("Bray-Curtis" = "bray", "Jaccard" = "jaccard", 
                              "Euclidean" = "euclidean", "Manhattan" = "manhattan",
                              "Canberra" = "canberra", "Gower" = "gower"),
                   selected = "bray"),
        
        # Environmental variables selection
        uiOutput(ns("env_vars_ui")),
        
        # Permutation tests
        numericInput(ns("permutations"), "Permutations:", value = 999, min = 99, max = 9999, step = 100),
        
        # Run button
        div(class = "action-buttons", style = "margin-top: 20px;",
          actionButton(ns("run_cap"), "▶ Run CAP", class = "btn-success", style = "width: 100%;")
        )
      ),
      
      div(class = "horizontal-split",
        div(class = "plot-panel",
          # Interpretation box
          uiOutput(ns("cap_interpretation")),
          
          # Plot Customization Panel
          div(style = "background: #1a1a1a; padding: 15px; margin: 10px 0; border-radius: 5px;",
            h4("🎨 Plot Customization", style = "color: #2e8b57; margin-bottom: 15px; cursor: pointer;",
               onclick = paste0("$('#", ns("plot_custom"), "').toggle();")),
            
            div(id = ns("plot_custom"), class = "plot-customization-grid",
              div(selectInput(ns("theme"), "Theme:", choices = c("Clean" = "bw", "Minimal" = "minimal", "Dark" = "dark"), selected = "bw")),
              div(selectInput(ns("font_family"), "Font:", choices = c("Sans" = "sans", "Serif" = "serif", "Mono" = "mono"), selected = "sans")),
              div(numericInput(ns("base_size"), "Font Size:", value = 12, min = 8, max = 20, step = 1)),
              div(numericInput(ns("title_size"), "Title Size:", value = 14, min = 10, max = 24, step = 1)),
              div(numericInput(ns("point_size"), "Point Size:", value = 2, min = 0.5, max = 5, step = 0.5)),
              div(selectInput(ns("point_shape"), "Shape:", choices = c("Circle" = 21, "Square" = 22, "Diamond" = 23, "Triangle" = 24), selected = 21)),
              div(selectInput(ns("point_color"), "Point Color:", choices = c("Ördin Green" = "#2e8b57", "Blue" = "#007acc", "Orange" = "#d4a017", "Red" = "#e74c3c", "Purple" = "#9b59b6", "Teal" = "#1abc9c"), selected = "#2e8b57")),
              div(numericInput(ns("point_lwd"), "Border Width:", value = 1.5, min = 0.5, max = 3, step = 0.5)),
              div(checkboxInput(ns("show_grid"), "Show Grid", value = TRUE)),
              div(checkboxInput(ns("show_labels"), "Site Labels", value = FALSE)),
              div(numericInput(ns("plot_width"), "Width (in):", value = 8, min = 4, max = 20, step = 1)),
              div(numericInput(ns("plot_height"), "Height (in):", value = 6, min = 4, max = 16, step = 1)),
              div(numericInput(ns("dpi"), "DPI:", value = 300, min = 72, max = 600, step = 50)),
              div(selectInput(ns("export_format"), "Format:", choices = c("PNG" = "png", "PDF" = "pdf", "SVG" = "svg"), selected = "png")),
              div(numericInput(ns("label_size"), "Label Size:", value = 0.8, min = 0.3, max = 2, step = 0.1)),
              div(selectInput(ns("label_pos"), "Label Pos:", choices = c("Auto" = 0, "Below" = 1, "Left" = 2, "Above" = 3, "Right" = 4), selected = 0)),
              div(numericInput(ns("axis_lwd"), "Axis Width:", value = 1, min = 0.5, max = 3, step = 0.5)),
              div(checkboxInput(ns("equal_aspect"), "Equal Aspect", value = TRUE))
            )
          ),
          
          plotOutput(ns("cap_plot"), height = "500px"),
          downloadButton(ns("export_plot"), "💾 Export Plot", class = "btn-sm", style = "margin-top: 10px;")
        ),
        
        div(class = "results-panel",
          div(class = "results-section",
            h3("📊 ANOVA RESULTS"),
            tableOutput(ns("anova_table"))
          ),
          
          div(class = "results-section", style = "margin-top: 20px;",
            h3("📈 EIGENVALUES"),
            tableOutput(ns("eigen_table"))
          ),
          
          div(class = "action-buttons", style = "margin-top: 20px;",
            downloadButton(ns("export_results"), "📋 Export CSV", class = "btn-sm")
          )
        )
      )
    )
  )
}

#' CAP Module Server
cap_server <- function(id, data, env_data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    cap_result <- reactiveVal(NULL)
    
    # Dynamic UI for environmental variable selection
    output$env_vars_ui <- renderUI({
      req(env_data())
      
      selectInput(ns("env_vars"), 
                 "Environmental Variables:",
                 choices = names(env_data()),
                 selected = names(env_data()),
                 multiple = TRUE)
    })
    
    # Run CAP
    observeEvent(input$run_cap, {
      req(data(), env_data(), input$env_vars)
      
      waiter_show(html = tagList(
        spin_fading_circles(),
        h3("Running CAP...", style = "color: #2e8b57; margin-top: 20px;")
      ))
      
      result <- tryCatch({
        env_subset <- env_data()[, input$env_vars, drop = FALSE]
        capscale(data() ~ ., data = env_subset, distance = input$distance)
      }, error = function(e) {
        waiter_hide()
        showNotification(paste("❌ CAP failed:", e$message), type = "error")
        NULL
      })
      
      waiter_hide()
      
      if (!is.null(result)) {
        cap_result(result)
        
        # Calculate variance explained
        total_var <- result$tot.chi
        constrained_var <- result$CCA$tot.chi
        var_exp <- (constrained_var / total_var) * 100
        
        showNotification(
          HTML(sprintf("<strong>✓ CAP Complete!</strong><br/>Constrained inertia: %.1f%%<br/>Distance: %s", var_exp, input$distance)),
          type = "message"
        )
      }
    })
    
    # Interpretation box
    output$cap_interpretation <- renderUI({
      req(cap_result())
      
      total_var <- cap_result()$tot.chi
      constrained_var <- cap_result()$CCA$tot.chi
      var_exp <- (constrained_var / total_var) * 100
      
      color <- if(var_exp >= 40) "#2e8b57" else if(var_exp >= 20) "#d4a017" else "#888"
      quality <- if(var_exp >= 40) "Strong" else if(var_exp >= 20) "Moderate" else "Weak"
      
      HTML(sprintf('
        <div style="background: %s20; border-left: 3px solid %s; padding: 16px; margin: 20px 0;">
          <h4 style="color: %s; margin: 0 0 8px 0;">%s constraint (%.1f%% explained)</h4>
          <p style="color: #ccc; font-size: 12px;">Environmental variables explain %.1f%% of community variation (CAP using %s distance)</p>
        </div>
      ', color, color, color, quality, var_exp, var_exp, input$distance))
    })
    
    # Plot
    output$cap_plot <- renderPlot({  
      req(cap_result())
      is_dark <- input$theme == "dark"
      bg_color <- if(is_dark) "#1a1a1a" else "white"
      fg_color <- if(is_dark) "#cccccc" else "#1e1e1e"
      title_color <- if(is_dark) "#5fd38d" else "#2e8b57"
      grid_color <- if(is_dark) "#404040" else "#cccccc40"
      
      par(family = input$font_family, bg = bg_color, fg = fg_color, col.axis = fg_color,
          col.lab = fg_color, col.main = title_color, cex = input$base_size / 12,
          cex.main = input$title_size / 12, lwd = input$axis_lwd)
      
      if(input$equal_aspect) {
        plot(cap_result(), type = "none", main = "CAP Ordination", font.main = 2)
        usr <- par("usr"); pin <- par("pin")
        if(pin[1] > pin[2]) par(usr = c(mean(usr[1:2]) - diff(usr[3:4])/2, mean(usr[1:2]) + diff(usr[3:4])/2, usr[3:4]))
        else par(usr = c(usr[1:2], mean(usr[3:4]) - diff(usr[1:2])/2, mean(usr[3:4]) + diff(usr[1:2])/2))
      } else plot(cap_result(), type = "none", main = "CAP Ordination", font.main = 2)
      
      if(input$show_grid) grid(col = grid_color, lty = 1)
      points(cap_result(), display = "sites", pch = as.numeric(input$point_shape),
             bg = input$point_color, cex = input$point_size, col = fg_color, lwd = input$point_lwd)
      if(input$show_labels) text(cap_result(), display = "sites", cex = input$label_size,
                                 pos = as.numeric(input$label_pos), col = fg_color)
      
      # Add environmental vectors
      text(cap_result(), display = "bp", col = if(is_dark) "#9b59b6" else "#8e44ad", cex = input$label_size * 1.1)
    })
    
    # ANOVA table
    output$anova_table <- renderTable({
      req(cap_result())
      anova_result <- anova(cap_result(), permutations = input$permutations)
      data.frame(
        Source = "Model",
        Df = anova_result$Df[1],
        Variance = sprintf("%.4f", anova_result$Variance[1]),
        `F-value` = sprintf("%.4f", anova_result$F[1]),
        `p-value` = sprintf("%.4f", anova_result$`Pr(>F)`[1]),
        check.names = FALSE
      )
    })
    
    # Eigenvalue table
    output$eigen_table <- renderTable({
      req(cap_result())
      eig <- eigenvals(cap_result(), constrained = TRUE)
      data.frame(
        Axis = paste0("CAP", 1:min(4, length(eig))),
        Eigenvalue = sprintf("%.4f", eig[1:min(4, length(eig))]),
        `Explained (%)` = sprintf("%.2f", eig[1:min(4, length(eig))] / cap_result()$tot.chi * 100),
        check.names = FALSE
      )
    })
    
    # Export plot
    output$export_plot <- downloadHandler(
      filename = function() paste0("cap_plot_", Sys.Date(), ".", input$export_format),
      content = function(file) {
        is_dark <- input$theme == "dark"
        bg_color <- if(is_dark) "#1a1a1a" else "white"
        fg_color <- if(is_dark) "#cccccc" else "#1e1e1e"
        title_color <- if(is_dark) "#5fd38d" else "#2e8b57"
        grid_color <- if(is_dark) "#404040" else "#cccccc40"
        
        if(input$export_format == "png") png(file, width = input$plot_width * input$dpi, height = input$plot_height * input$dpi, res = input$dpi, bg = bg_color)
        else if(input$export_format == "pdf") pdf(file, width = input$plot_width, height = input$plot_height, bg = bg_color)
        else svg(file, width = input$plot_width, height = input$plot_height, bg = bg_color)
        
        par(family = input$font_family, bg = bg_color, fg = fg_color, col.axis = fg_color,
            col.lab = fg_color, col.main = title_color, cex = input$base_size / 12,
            cex.main = input$title_size / 12, lwd = input$axis_lwd)
        
        if(input$equal_aspect) {
          plot(cap_result(), type = "none", main = "CAP Ordination", font.main = 2)
          usr <- par("usr"); pin <- par("pin")
          if(pin[1] > pin[2]) par(usr = c(mean(usr[1:2]) - diff(usr[3:4])/2, mean(usr[1:2]) + diff(usr[3:4])/2, usr[3:4]))
          else par(usr = c(usr[1:2], mean(usr[3:4]) - diff(usr[1:2])/2, mean(usr[3:4]) + diff(usr[1:2])/2))
        } else plot(cap_result(), type = "none", main = "CAP Ordination", font.main = 2)
        
        if(input$show_grid) grid(col = grid_color, lty = 1)
        points(cap_result(), display = "sites", pch = as.numeric(input$point_shape),
               bg = input$point_color, cex = input$point_size, col = fg_color, lwd = input$point_lwd)
        if(input$show_labels) text(cap_result(), display = "sites", cex = input$label_size,
                                   pos = as.numeric(input$label_pos), col = fg_color)
        text(cap_result(), display = "bp", col = if(is_dark) "#9b59b6" else "#8e44ad", cex = input$label_size * 1.1)
        dev.off()
      }
    )
    
    # Export results
    output$export_results <- downloadHandler(
      filename = function() paste0("cap_results_", Sys.Date(), ".csv"),
      content = function(file) {
        scores_df <- as.data.frame(scores(cap_result(), display = "sites"))
        write.csv(scores_df, file, row.names = TRUE)
      }
    )
  })
}
