# Ördin - db-RDA Module
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Distance-based Redundancy Analysis (db-RDA) - Constrained ordination with any distance metric

library(shiny)
library(vegan)
library(waiter)

#' db-RDA Module UI
dbrda_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(class = "dbrda-workflow",
      div(class = "config-panel",
        h3("⚙️ db-RDA Configuration"),
        
        helpText("Distance-based RDA allows constrained ordination with any distance metric (not limited to Euclidean)."),
        
        # Distance metric
        selectInput(ns("distance"), "Distance/Dissimilarity:",
                   choices = c("Bray-Curtis" = "bray", "Jaccard" = "jaccard", 
                              "Euclidean" = "euclidean", "Manhattan" = "manhattan",
                              "Canberra" = "canberra", "Kulczynski" = "kulczynski"),
                   selected = "bray"),
        
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
          actionButton(ns("run_dbrda"), "▶ Run db-RDA", class = "btn-success", style = "width: 100%;")
        )
      ),
      
      div(class = "horizontal-split",
        div(class = "plot-panel",
          # Interpretation box
          uiOutput(ns("dbrda_interpretation")),
          
          plotOutput(ns("dbrda_plot"), height = "500px"),
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

#' db-RDA Module Server
dbrda_server <- function(id, data, env_data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Source plotting utilities
    source("utils/plotting/ordination_plotting.R", local = TRUE)
    
    dbrda_result <- reactiveVal(NULL)
    
    plot_defaults <- reactiveValues(
      theme = "bw", font_family = "sans", base_size = 12, title_size = 14,
      point_size = 2, point_shape = "21", point_color = "#2e8b57", point_lwd = 1.5,
      show_grid = TRUE, show_labels = FALSE, plot_width = 8, plot_height = 6,
      dpi = 300, export_format = "png", label_size = 0.8, label_pos = "0",
      axis_lwd = 1, equal_aspect = TRUE,
      # Ellipse controls
      show_ellipses = FALSE, group_var = "", ellipse_type = "norm", ellipse_level = 0.95,
      # Constrained ordination controls
      show_vectors = TRUE, show_species = TRUE, plot_type = "triplot"
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
    
    # CRITICAL: Observers for ellipse and ordination controls
    observeEvent(input$plot_show_ellipses, { plot_defaults$show_ellipses <- input$plot_show_ellipses }, ignoreNULL = FALSE)
    observeEvent(input$plot_group_var, { plot_defaults$group_var <- input$plot_group_var }, ignoreNULL = FALSE)
    observeEvent(input$plot_ellipse_type, { plot_defaults$ellipse_type <- input$plot_ellipse_type }, ignoreNULL = FALSE)
    observeEvent(input$plot_ellipse_level, { plot_defaults$ellipse_level <- input$plot_ellipse_level }, ignoreNULL = FALSE)
    observeEvent(input$plot_show_vectors, { plot_defaults$show_vectors <- input$plot_show_vectors }, ignoreNULL = FALSE)
    observeEvent(input$plot_show_species, { plot_defaults$show_species <- input$plot_show_species }, ignoreNULL = FALSE)
    observeEvent(input$plot_plot_type, { plot_defaults$plot_type <- input$plot_plot_type }, ignoreNULL = FALSE)
    
    # Dynamic UI for environmental variable selection
    output$env_vars_ui <- renderUI({
      req(env_data())
      
      checkboxGroupInput(ns("env_vars"), 
                 "Environmental Variables:",
                 choices = names(env_data()),
                 selected = names(env_data()))
    })
    
    # Run db-RDA
    observeEvent(input$run_dbrda, {
      req(data(), env_data(), input$env_vars)
      
      waiter_show(html = tagList(
        spin_fading_circles(),
        h3("Running db-RDA...", style = "color: #2e8b57; margin-top: 20px;")
      ))
      
      result <- tryCatch({
        env_subset <- env_data()[, input$env_vars, drop = FALSE]
        dbrda(data() ~ ., data = env_subset, distance = input$distance)
      }, error = function(e) {
        waiter_hide()
        showNotification(paste("❌ db-RDA failed:", e$message), type = "error")
        NULL
      })
      
      waiter_hide()
      
      if (!is.null(result)) {
        dbrda_result(result)
        
        # Calculate variance explained
        total_var <- result$tot.chi
        constrained_var <- result$CCA$tot.chi
        var_exp <- (constrained_var / total_var) * 100
        
        # CRITICAL: Trigger plot customization panel to open
        session$sendCustomMessage(
          type = "showPlotCustomization",
          message = list(
            plotType = "ordination",
            moduleId = "dbrda"
          )
        )
        
        # CRITICAL: Populate grouping variable dropdown AFTER panel is shown
        if (!is.null(env_data())) {
          env_df <- env_data()
          factor_cols <- names(env_df)[sapply(env_df, function(x) is.factor(x) || is.character(x))]
          
          choices_list <- list()
          choices_list[[""]] <- "None"
          for (col in factor_cols) {
            choices_list[[col]] <- col
          }
          
          # Delay to ensure dropdown exists
          shinyjs::delay(1000, {
            session$sendCustomMessage(
              type = "updateGroupingVar",
              message = list(
                moduleId = "dbrda",
                choices = choices_list
              )
            )
          })
        }
        
        showNotification(
          HTML(sprintf("<strong>✓ db-RDA Complete!</strong><br/>Constrained variance: %.1f%%<br/>Distance: %s", var_exp, input$distance)),
          type = "message"
        )
      }
    })
    
    # Populate grouping variable dropdown
    observe({
      req(env_data())
      env_df <- env_data()
      factor_cols <- names(env_df)[sapply(env_df, function(x) is.factor(x) || is.character(x))]
      choices_list <- list()
      choices_list[[""]] <- "None"
      for (col in factor_cols) choices_list[[col]] <- col
      session$sendCustomMessage(type = "updateGroupingVar", message = list(moduleId = "dbrda-", choices = choices_list))
    })
    
    # Interpretation box
    output$dbrda_interpretation <- renderUI({
      req(dbrda_result())
      
      total_var <- dbrda_result()$tot.chi
      constrained_var <- dbrda_result()$CCA$tot.chi
      var_exp <- (constrained_var / total_var) * 100
      
      color <- if(var_exp >= 50) "#2e8b57" else if(var_exp >= 25) "#d4a017" else "#888"
      quality <- if(var_exp >= 50) "Strong" else if(var_exp >= 25) "Moderate" else "Weak"
      
      HTML(sprintf('
        <div style="background: %s20; border-left: 3px solid %s; padding: 16px; margin: 20px 0;">
          <h4 style="color: %s; margin: 0 0 8px 0;">%s constraint (%.1f%% explained)</h4>
          <p style="color: #ccc; font-size: 12px;">Environmental variables explain %.1f%% of community variation using %s distance</p>
        </div>
      ', color, color, color, quality, var_exp, var_exp, input$distance))
    })
    
    # Plot using ggplot2
    output$dbrda_plot <- renderPlot({  
      req(dbrda_result())
      
      # Force reactivity by reading ALL plot_defaults reactiveValues
      plot_theme <- plot_defaults$theme
      plot_font_family <- plot_defaults$font_family
      plot_base_size <- plot_defaults$base_size
      plot_title_size <- plot_defaults$title_size
      plot_point_size <- plot_defaults$point_size
      plot_point_shape <- plot_defaults$point_shape
      plot_point_color <- plot_defaults$point_color
      plot_point_lwd <- plot_defaults$point_lwd
      plot_show_grid <- plot_defaults$show_grid
      plot_show_labels <- plot_defaults$show_labels
      plot_label_size <- plot_defaults$label_size
      # Ellipse controls from plot_defaults
      plot_show_ellipses <- plot_defaults$show_ellipses
      plot_group_var <- plot_defaults$group_var
      plot_ellipse_type <- plot_defaults$ellipse_type
      plot_ellipse_level <- plot_defaults$ellipse_level
      # Ordination controls from plot_defaults
      plot_show_vectors <- plot_defaults$show_vectors
      
      # Get grouping variable if ellipses are enabled
      grouping_var <- NULL
      if (!is.null(plot_show_ellipses) && plot_show_ellipses && 
          !is.null(plot_group_var) && plot_group_var != "" && 
          !is.null(env_data) && is.function(env_data) && !is.null(env_data())) {
        grouping_var <- env_data()[[plot_group_var]]
        if (!is.factor(grouping_var)) grouping_var <- as.factor(grouping_var)
      }
      
      show_env_vectors <- !is.null(plot_show_vectors) && plot_show_vectors
      
      # Generate constrained ordination plot with environmental vectors
      p <- generate_constrained_plot(dbrda_result(), plot_defaults, grouping_var, show_env_vectors = show_env_vectors)
      
      # Add ellipses if requested
      if (!is.null(grouping_var) && !is.null(plot_ellipse_type)) {
        ellipse_level <- if (!is.null(plot_ellipse_level)) plot_ellipse_level else 0.95
        p <- add_ordination_ellipses(p, dbrda_result(), grouping_var, plot_ellipse_type, ellipse_level)
      }
      
      p <- p + labs(title = "db-RDA Triplot") +
        theme(plot.title = element_text(size = plot_defaults$title_size, face = "bold", color = "#2e8b57"))
      
      print(p)
    })
    
    # ANOVA table
    output$anova_table <- renderTable({
      req(dbrda_result())
      anova_result <- anova(dbrda_result(), permutations = input$permutations)
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
      req(dbrda_result())
      eig <- eigenvals(dbrda_result(), constrained = TRUE)
      data.frame(
        Axis = paste0("dbRDA", 1:min(4, length(eig))),
        Eigenvalue = sprintf("%.4f", eig[1:min(4, length(eig))]),
        `Explained (%)` = sprintf("%.2f", eig[1:min(4, length(eig))] / dbrda_result()$tot.chi * 100),
        check.names = FALSE
      )
    })
    
    # Export plot using ggplot2
    output$export_plot <- downloadHandler(
      filename = function() paste0("dbrda_plot_", Sys.Date(), ".", plot_defaults$export_format),
      content = function(file) {
        grouping_var <- NULL
        if (!is.null(input$plot_show_ellipses) && input$plot_show_ellipses && 
            !is.null(input$plot_group_var) && input$plot_group_var != "" && 
            !is.null(env_data) && is.function(env_data) && !is.null(env_data())) {
          grouping_var <- env_data()[[input$plot_group_var]]
          if (!is.factor(grouping_var)) grouping_var <- as.factor(grouping_var)
        }
        
        p <- generate_constrained_plot(dbrda_result(), plot_defaults, grouping_var, show_env_vectors = TRUE)
        
        if (!is.null(grouping_var) && !is.null(input$plot_ellipse_type)) {
          ellipse_level <- if (!is.null(input$plot_ellipse_level)) input$plot_ellipse_level else 0.95
          p <- add_ordination_ellipses(p, dbrda_result(), grouping_var, input$plot_ellipse_type, ellipse_level)
        }
        
        p <- p + labs(title = "db-RDA Triplot") +
          theme(plot.title = element_text(size = plot_defaults$title_size, face = "bold", color = "#2e8b57"))
        
        export_ordination_plot(p, file, plot_defaults$plot_width, plot_defaults$plot_height,
                              plot_defaults$dpi, plot_defaults$export_format)
      }
    )
    
    # Export results
    output$export_results <- downloadHandler(
      filename = function() paste0("dbrda_results_", Sys.Date(), ".csv"),
      content = function(file) {
        scores_df <- as.data.frame(scores(dbrda_result(), display = "sites"))
        write.csv(scores_df, file, row.names = TRUE)
      }
    )
  })
}
