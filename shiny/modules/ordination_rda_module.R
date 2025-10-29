# Ördin - RDA Module
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Redundancy Analysis (RDA) - Constrained ordination

library(shiny)
library(vegan)
library(waiter)

#' RDA Module UI
rda_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(class = "rda-workflow",
      div(class = "config-panel",
        h3("⚙️ RDA Configuration"),
        
        helpText("RDA constrains ordination by environmental variables. Ideal for linear species responses."),
        
        # Environmental variables selection
        uiOutput(ns("env_vars_ui")),
        
        # Scaling
        selectInput(ns("scaling"), "Scaling:",
                   choices = c("Type 1 (sites)" = 1, "Type 2 (species)" = 2),
                   selected = 2),
        
        # Permutation tests
        numericInput(ns("permutations"), "Permutations:", value = 999, min = 99, max = 9999, step = 100),
        
        # Run button
        div(class = "action-buttons", style = "margin-top: 20px;",
          actionButton(ns("run_rda"), "▶ Run RDA", class = "btn-success", style = "width: 100%;")
        )
      ),
      
      div(class = "horizontal-split",
        div(class = "plot-panel",
          # Interpretation box
          uiOutput(ns("rda_interpretation")),
          
          plotOutput(ns("rda_plot"), height = "500px"),
          downloadButton(ns("export_plot"), "💾 Export Plot", class = "btn-sm", style = "margin-top: 10px;")
        ),
        
        div(class = "results-panel",
          div(class = "results-section",
            h3("📊 ANOVA RESULTS"),
            tableOutput(ns("anova_table"))
          ),
          
          div(class = "results-section", style = "margin-top: 20px;",
            h3("📈 VARIANCE"),
            tableOutput(ns("variance_table"))
          ),
          
          div(class = "action-buttons", style = "margin-top: 20px;",
            downloadButton(ns("export_results"), "📋 Export CSV", class = "btn-sm")
          )
        )
      )
    )
  )
}

#' RDA Module Server
rda_server <- function(id, data, env_data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    rda_result <- reactiveVal(NULL)
    
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
    
    # Dynamic UI for environmental variable selection
    output$env_vars_ui <- renderUI({
      req(env_data())
      
      selectInput(ns("env_vars"), 
                 "Environmental Variables:",
                 choices = names(env_data()),
                 selected = names(env_data()),
                 multiple = TRUE)
    })
    
    # Run RDA
    observeEvent(input$run_rda, {
      req(data(), env_data(), input$env_vars)
      
      waiter_show(html = tagList(
        spin_fading_circles(),
        h3("Running RDA...", style = "color: #2e8b57; margin-top: 20px;")
      ))
      
      result <- tryCatch({
        env_subset <- env_data()[, input$env_vars, drop = FALSE]
        rda(data() ~ ., data = env_subset)
      }, error = function(e) {
        waiter_hide()
        showNotification(paste("❌ RDA failed:", e$message), type = "error")
        NULL
      })
      
      waiter_hide()
      
      if (!is.null(result)) {
        rda_result(result)
        
        # Calculate variance explained
        total_var <- result$tot.chi
        constrained_var <- result$CCA$tot.chi
        var_exp <- (constrained_var / total_var) * 100
        
        showNotification(
          HTML(sprintf("<strong>✓ RDA Complete!</strong><br/>Constrained variance: %.1f%%", var_exp)),
          type = "message"
        )
      }
    })
    
    # Interpretation box
    output$rda_interpretation <- renderUI({
      req(rda_result())
      
      total_var <- rda_result()$tot.chi
      constrained_var <- rda_result()$CCA$tot.chi
      var_exp <- (constrained_var / total_var) * 100
      
      color <- if(var_exp >= 50) "#2e8b57" else if(var_exp >= 25) "#d4a017" else "#888"
      quality <- if(var_exp >= 50) "Strong" else if(var_exp >= 25) "Moderate" else "Weak"
      
      HTML(sprintf('
        <div style="background: %s20; border-left: 3px solid %s; padding: 16px; margin: 20px 0;">
          <h4 style="color: %s; margin: 0 0 8px 0;">%s constraint (%.1f%% explained)</h4>
          <p style="color: #ccc; font-size: 12px;">Environmental variables explain %.1f%% of species variance</p>
        </div>
      ', color, color, color, quality, var_exp, var_exp))
    })
    
    # Plot
    output$rda_plot <- renderPlot({  
      req(rda_result())
      is_dark <- plot_defaults$theme == "dark"
      bg_color <- if(is_dark) "#1a1a1a" else "white"
      fg_color <- if(is_dark) "#cccccc" else "#1e1e1e"
      title_color <- if(is_dark) "#5fd38d" else "#2e8b57"
      grid_color <- if(is_dark) "#404040" else "#cccccc40"
      
      par(family = plot_defaults$font_family, bg = bg_color, fg = fg_color, col.axis = fg_color,
          col.lab = fg_color, col.main = title_color, cex = plot_defaults$base_size / 12,
          cex.main = plot_defaults$title_size / 12, lwd = plot_defaults$axis_lwd)
      
      if(plot_defaults$equal_aspect) {
        plot(rda_result(), type = "none", main = "RDA Triplot", font.main = 2, scaling = as.numeric(input$scaling))
        usr <- par("usr"); pin <- par("pin")
        if(pin[1] > pin[2]) par(usr = c(mean(usr[1:2]) - diff(usr[3:4])/2, mean(usr[1:2]) + diff(usr[3:4])/2, usr[3:4]))
        else par(usr = c(usr[1:2], mean(usr[3:4]) - diff(usr[1:2])/2, mean(usr[3:4]) + diff(usr[1:2])/2))
      } else plot(rda_result(), type = "none", main = "RDA Triplot", font.main = 2, scaling = as.numeric(input$scaling))
      
      if(plot_defaults$show_grid) grid(col = grid_color, lty = 1)
      points(rda_result(), display = "sites", pch = as.numeric(plot_defaults$point_shape),
             bg = plot_defaults$point_color, cex = plot_defaults$point_size, col = fg_color, lwd = plot_defaults$point_lwd)
      if(plot_defaults$show_labels) text(rda_result(), display = "sites", cex = plot_defaults$label_size,
                                 pos = as.numeric(plot_defaults$label_pos), col = fg_color)
      
      # Add environmental vectors
      text(rda_result(), display = "bp", col = if(is_dark) "#3498db" else "#2980b9", cex = plot_defaults$label_size * 1.1)
    })
    
    # ANOVA table
    output$anova_table <- renderTable({
      req(rda_result())
      anova_result <- anova(rda_result(), permutations = input$permutations)
      data.frame(
        Source = "Model",
        Df = anova_result$Df[1],
        Variance = sprintf("%.4f", anova_result$Variance[1]),
        `F-value` = sprintf("%.4f", anova_result$F[1]),
        `p-value` = sprintf("%.4f", anova_result$`Pr(>F)`[1]),
        check.names = FALSE
      )
    })
    
    # Variance table
    output$variance_table <- renderTable({
      req(rda_result())
      eig <- eigenvals(rda_result(), constrained = TRUE)
      data.frame(
        Axis = paste0("RDA", 1:min(4, length(eig))),
        Eigenvalue = sprintf("%.4f", eig[1:min(4, length(eig))]),
        `Explained (%)` = sprintf("%.2f", eig[1:min(4, length(eig))] / rda_result()$tot.chi * 100),
        check.names = FALSE
      )
    })
    
    # Export plot
    output$export_plot <- downloadHandler(
      filename = function() paste0("rda_plot_", Sys.Date(), ".", plot_defaults$export_format),
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
          plot(rda_result(), type = "none", main = "RDA Triplot", font.main = 2, scaling = as.numeric(input$scaling))
          usr <- par("usr"); pin <- par("pin")
          if(pin[1] > pin[2]) par(usr = c(mean(usr[1:2]) - diff(usr[3:4])/2, mean(usr[1:2]) + diff(usr[3:4])/2, usr[3:4]))
          else par(usr = c(usr[1:2], mean(usr[3:4]) - diff(usr[1:2])/2, mean(usr[3:4]) + diff(usr[1:2])/2))
        } else plot(rda_result(), type = "none", main = "RDA Triplot", font.main = 2, scaling = as.numeric(input$scaling))
        
        if(plot_defaults$show_grid) grid(col = grid_color, lty = 1)
        points(rda_result(), display = "sites", pch = as.numeric(plot_defaults$point_shape),
               bg = plot_defaults$point_color, cex = plot_defaults$point_size, col = fg_color, lwd = plot_defaults$point_lwd)
        if(plot_defaults$show_labels) text(rda_result(), display = "sites", cex = plot_defaults$label_size,
                                   pos = as.numeric(plot_defaults$label_pos), col = fg_color)
        text(rda_result(), display = "bp", col = if(is_dark) "#3498db" else "#2980b9", cex = plot_defaults$label_size * 1.1)
        dev.off()
      }
    )
    
    # Export results
    output$export_results <- downloadHandler(
      filename = function() paste0("rda_results_", Sys.Date(), ".csv"),
      content = function(file) {
        scores_df <- as.data.frame(scores(rda_result(), display = "sites"))
        write.csv(scores_df, file, row.names = TRUE)
      }
    )
  })
}
