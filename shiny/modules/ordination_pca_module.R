# Ördin - PCA Module
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Principal Components Analysis (PCA) ordination workflow

library(shiny)
library(vegan)
library(waiter)
# library(shinyFeedback)  # Disabled - conflicts with custom HTML
library(rmarkdown)

#' PCA Module UI
#'
#' @param id Module namespace ID
#' @return UI elements for PCA workflow
#' @export
pca_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    useShinyFeedback(),
    
    div(class = "pca-workflow",
      # Configuration Panel
      div(class = "config-panel",
        h3("⚙️ PCA Configuration"),
        
        # WHEN TO USE guidance box
        div(style = "background: #4a90e220; border-left: 3px solid #4a90e2; padding: 12px; margin-bottom: 16px;",
          h4(style = "color: #4a90e2; margin: 0 0 8px 0; font-size: 13px; font-weight: 600;", "📘 WHEN TO USE PCA"),
          tags$ul(style = "color: #ccc; font-size: 11px; margin: 0; padding-left: 20px; line-height: 1.6;",
            tags$li("Visualize **linear relationships** in multivariate data"),
            tags$li("Best for **short gradients** and **linear species responses**"),
            tags$li("Maximize **variance explained** in first few axes (typically >70%)"),
            tags$li("Example: What are the main axes of variation in species composition?")
          )
        ),
        
        # Scaling method
        selectInput(
          ns("scaling"),
          "Scaling Method:",
          choices = c(
            "Correlation (standardized)" = "correlation",
            "Covariance (unstandardized)" = "covariance"
          ),
          selected = "correlation",
          selectize = FALSE
        ),
        tags$small("Correlation-based PCA scales variables to equal variance."),
        
        # Center data
        checkboxInput(
          ns("center"),
          "Center data (recommended)",
          value = TRUE
        ),
        
        # Scale data
        checkboxInput(
          ns("scale"),
          "Scale data (recommended for different units)",
          value = TRUE
        ),
        
        # Number of axes to display
        numericInput(
          ns("axes_display"),
          "Axes to display:",
          value = 2,
          min = 2,
          max = 4,
          step = 1
        ),
        
        # Run button
        div(class = "action-buttons", style = "margin-top: 20px;",
          actionButton(
            ns("run_pca"),
            "▶ Run PCA",
            class = "btn-success",
            style = "width: 100%;"
          )
        )
      ),
      
      # Results Area
      div(class = "horizontal-split",
        # Plot Panel (70%)
        div(class = "plot-panel", style = "max-width: 100%; overflow: hidden;",
          # Variance interpretation box
          uiOutput(ns("variance_interpretation")),
          
          # PCA biplot
          plotOutput(ns("pca_plot"), width = "100%", height = "500px"),
          
          # Plot controls
          div(class = "plot-controls", style = "margin-top: 10px;",
            downloadButton(ns("export_plot"), "💾 Export Plot", class = "btn-sm")
          )
        ),
        
        # Results Panel (30%)
        div(class = "results-panel",
          # Eigenvalues
          div(class = "results-section",
            h3("📊 EIGENVALUES & VARIANCE"),
            tableOutput(ns("eigenvalues_table"))
          ),
          
          # Site scores
          div(class = "results-section", style = "margin-top: 20px;",
            h3("📍 SITE SCORES"),
            DT::dataTableOutput(ns("site_scores"))
          ),
          
          # Export Actions
          div(class = "action-buttons", style = "margin-top: 20px;",
            downloadButton(ns("export_results"), "📋 Export Results (CSV)", class = "btn-sm"),
            downloadButton(ns("export_report"), "📄 Generate Report (PDF)", class = "btn-sm", 
                          style = "margin-top: 8px;")
          )
        )
      )
    )
  )
}

#' PCA Module Server
#'
#' @param id Module namespace ID
#' @param data Reactive containing species abundance matrix
#' @param env_data Reactive containing environmental data (optional)
#' @return Server logic for PCA analysis
#' @export
pca_server <- function(id, data, env_data = reactive(NULL)) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Source utilities
    source("utils/validation.R", local = TRUE)
    source("utils/reproducibility.R", local = TRUE)
    source("utils/plotting/ordination_plotting.R", local = TRUE)
    
    # Reactive values
    pca_result <- reactiveVal(NULL)
    
    # Default plot customization values (since controls moved to right sidebar)
    plot_defaults <- reactiveValues(
      theme = "bw",
      font_family = "sans",
      base_size = 12,
      title_size = 14,
      point_size = 2,
      point_shape = "21",
      point_color = "#2e8b57",
      point_lwd = 1.5,
      show_grid = TRUE,
      show_labels = FALSE,
      plot_width = 8,
      plot_height = 6,
      dpi = 300,
      export_format = "png",
      label_size = 0.8,
      label_pos = "0",
      axis_lwd = 1,
      equal_aspect = TRUE,
      # Ellipse controls
      show_ellipses = FALSE, group_var = "", ellipse_type = "norm", ellipse_level = 0.95
    )
    
    # Observers to sync right panel inputs with plot_defaults
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
    
    # Observers for ellipse controls
    observeEvent(input$plot_show_ellipses, { plot_defaults$show_ellipses <- input$plot_show_ellipses }, ignoreNULL = FALSE)
    observeEvent(input$plot_group_var, { plot_defaults$group_var <- input$plot_group_var }, ignoreNULL = FALSE)
    observeEvent(input$plot_ellipse_type, { plot_defaults$ellipse_type <- input$plot_ellipse_type }, ignoreNULL = FALSE)
    observeEvent(input$plot_ellipse_level, { plot_defaults$ellipse_level <- input$plot_ellipse_level }, ignoreNULL = FALSE)
    
    # Run PCA Analysis
    observeEvent(input$run_pca, {
      req(data())
      
      # Show loading spinner
      waiter_show(html = tagList(
        spin_fading_circles(),
        h3("Running PCA Analysis...", style = "color: #2e8b57; margin-top: 20px;")
      ))
      
      # Run PCA
      result <- tryCatch({
        rda(data(), scale = input$scale)
      }, error = function(e) {
        waiter_hide()
        showNotification(
          paste("❌ PCA failed:", e$message), 
          type = "error", 
          duration = 10
        )
        NULL
      })
      
      waiter_hide()
      
      if (!is.null(result)) {
        pca_result(result)
        
        # Calculate variance explained by first 2 axes
        eig <- eigenvals(result)
        var_exp <- sum(eig[1:2]) / sum(eig) * 100
        
        # CRITICAL: Trigger plot customization panel to open
        session$sendCustomMessage(
          type = "showPlotCustomization",
          message = list(
            plotType = "ordination",
            moduleId = "pca"
          )
        )
        
        # CRITICAL: Populate grouping variable dropdown if env_data available
        if (!is.null(env_data()) && nrow(env_data()) > 0) {
          env_df <- env_data()
          factor_cols <- names(env_df)[sapply(env_df, function(x) is.factor(x) || is.character(x))]
          
          if (length(factor_cols) > 0) {
            choices_list <- list()
            choices_list[[""]] <- "None"
            for (col in factor_cols) {
              choices_list[[col]] <- col
            }
            
            shinyjs::delay(1000, {
              session$sendCustomMessage(
                type = "updateGroupingVar",
                message = list(
                  moduleId = "pca",
                  choices = choices_list
                )
              )
            })
          }
        }
        
        showNotification(
          HTML(sprintf(
            "<strong>✓ PCA Complete!</strong><br/>First 2 axes explain %.1f%% of variance",
            var_exp
          )),
          type = "message",
          duration = 8
        )
      }
    })
    
    # Generate variance interpretation HTML
    output$variance_interpretation <- renderUI({
      req(pca_result())
      
      eig <- eigenvals(pca_result())
      var_pc1 <- eig[1] / sum(eig) * 100
      var_pc2 <- eig[2] / sum(eig) * 100
      total_var <- var_pc1 + var_pc2
      
      color <- if(total_var >= 70) "#2e8b57" else if(total_var >= 50) "#d4a017" else "#888"
      quality <- if(total_var >= 70) "Excellent" else if(total_var >= 50) "Good" else "Moderate"
      
      HTML(sprintf('
        <div style="background: %s20; border-left: 3px solid %s; padding: 16px; margin: 20px 0;">
          <h4 style="color: %s; margin: 0 0 8px 0; font-size: 14px;">
            %s variance explained (%.1f%%)
          </h4>
          <p style="color: #ccc; font-size: 12px; margin: 0 0 12px 0; line-height: 1.6;">
            PC1: %.1f%% | PC2: %.1f%% | Together: %.1f%%
          </p>
          <p style="color: %s; font-size: 12px; margin: 0; line-height: 1.6; font-weight: 600;">
            📌 First two axes capture %s of the variation in the data.
          </p>
        </div>
      ', color, color, color, quality, total_var, var_pc1, var_pc2, total_var, 
         color, if(total_var >= 70) "most" else if(total_var >= 50) "a substantial portion" else "some"))
    })
    
    # Render PCA biplot using ggplot2
    output$pca_plot <- renderPlot({  
      req(pca_result())
      
      # Force reactivity by reading plot_defaults
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
      plot_show_ellipses <- plot_defaults$show_ellipses
      plot_group_var <- plot_defaults$group_var
      plot_ellipse_type <- plot_defaults$ellipse_type
      plot_ellipse_level <- plot_defaults$ellipse_level
      
      # Get grouping variable if ellipses are enabled
      grouping_var <- NULL
      if (!is.null(plot_show_ellipses) && plot_show_ellipses && 
          !is.null(plot_group_var) && plot_group_var != "" && 
          !is.null(env_data()) && nrow(env_data()) > 0) {
        grouping_var <- env_data()[[plot_group_var]]
        if (!is.factor(grouping_var)) {
          grouping_var <- as.factor(grouping_var)
        }
      }
      
      # Generate base ggplot2 plot
      p <- generate_ordination_plot(pca_result(), plot_defaults, grouping_var)
      
      # Add confidence ellipses if requested
      if (!is.null(grouping_var) && !is.null(input$plot_ellipse_type)) {
        ellipse_level <- if (!is.null(input$plot_ellipse_level)) input$plot_ellipse_level else 0.95
        
        p <- add_ordination_ellipses(
          p, 
          pca_result(), 
          grouping_var,
          ellipse_type = input$plot_ellipse_type,
          conf_level = ellipse_level
        )
      }
      
      # Add title with variance info
      eig <- eigenvals(pca_result())
      var_pc1 <- eig[1] / sum(eig) * 100
      var_pc2 <- eig[2] / sum(eig) * 100
      
      p <- p + labs(
        title = "PCA Biplot",
        subtitle = sprintf("PC1: %.1f%% | PC2: %.1f%%", var_pc1, var_pc2)
      ) +
      theme(
        plot.title = element_text(size = plot_defaults$title_size, face = "bold", color = "#2e8b57"),
        plot.subtitle = element_text(color = "#2e8b57", face = "bold")
      )
      
      print(p)
    })
    
    # Eigenvalues table
    output$eigenvalues_table <- renderTable({
      req(pca_result())
      
      eig <- eigenvals(pca_result())
      var_exp <- eig / sum(eig) * 100
      cum_var <- cumsum(var_exp)
      
      n_show <- min(6, length(eig))
      
      data.frame(
        Axis = paste0("PC", 1:n_show),
        Eigenvalue = sprintf("%.4f", eig[1:n_show]),
        `Variance (%)` = sprintf("%.2f", var_exp[1:n_show]),
        `Cumulative (%)` = sprintf("%.2f", cum_var[1:n_show]),
        check.names = FALSE
      )
    })
    
    # Site scores table
    output$site_scores <- DT::renderDataTable({
      req(pca_result())
      
      scores_df <- as.data.frame(scores(pca_result(), display = "sites"))
      scores_df$Sample <- rownames(scores_df)
      scores_df <- scores_df[, c("Sample", colnames(scores_df)[1:(ncol(scores_df)-1)])]
      
      DT::datatable(scores_df,
                    options = list(
                      pageLength = 10, 
                      scrollX = TRUE,
                      dom = 'frtip',  # Enable full pagination controls
                      paging = TRUE,
                      searching = TRUE,
                      info = TRUE
                    ),
                    rownames = FALSE,
                    class = 'cell-border stripe hover compact')
    })
    
    # Export plot with custom settings using ggplot2
    output$export_plot <- downloadHandler(
      filename = function() {
        ext <- plot_defaults$export_format
        paste0("pca_plot_", Sys.Date(), ".", ext)
      },
      content = function(file) {
        # Get grouping variable if ellipses are enabled
        grouping_var <- NULL
        if (!is.null(input$plot_show_ellipses) && input$plot_show_ellipses && 
            !is.null(input$plot_group_var) && input$plot_group_var != "" && 
            !is.null(env_data) && is.function(env_data) && !is.null(env_data())) {
          grouping_var <- env_data()[[input$plot_group_var]]
          if (!is.factor(grouping_var)) {
            grouping_var <- as.factor(grouping_var)
          }
        }
        
        # Generate ggplot2 plot
        p <- generate_ordination_plot(pca_result(), plot_defaults, grouping_var)
        
        # Add confidence ellipses if requested
        if (!is.null(grouping_var) && !is.null(input$plot_ellipse_type)) {
          ellipse_level <- if (!is.null(input$plot_ellipse_level)) input$plot_ellipse_level else 0.95
          
          p <- add_ordination_ellipses(
            p, 
            pca_result(), 
            grouping_var,
            ellipse_type = input$plot_ellipse_type,
            conf_level = ellipse_level
          )
        }
        
        # Add title with variance info
        eig <- eigenvals(pca_result())
        var_pc1 <- eig[1] / sum(eig) * 100
        var_pc2 <- eig[2] / sum(eig) * 100
        
        p <- p + labs(
          title = "PCA Biplot",
          subtitle = sprintf("PC1: %.1f%% | PC2: %.1f%%", var_pc1, var_pc2)
        ) +
        theme(
          plot.title = element_text(size = plot_defaults$title_size, face = "bold", color = "#2e8b57"),
          plot.subtitle = element_text(color = "#2e8b57", face = "bold")
        )
        
        # Export using utility function
        export_ordination_plot(
          p, 
          file, 
          width = plot_defaults$plot_width, 
          height = plot_defaults$plot_height,
          dpi = plot_defaults$dpi, 
          format = plot_defaults$export_format
        )
      }
    )
    
    # Export results CSV
    output$export_results <- downloadHandler(
      filename = function() {
        paste0("pca_results_", Sys.Date(), ".csv")
      },
      content = function(file) {
        req(pca_result())
        
        # Combine eigenvalues and site scores
        eig <- eigenvals(pca_result())
        scores_df <- as.data.frame(scores(pca_result(), display = "sites"))
        
        write.csv(scores_df, file, row.names = TRUE)
      }
    )
    
    # Export PDF report
    output$export_report <- downloadHandler(
      filename = function() {
        paste0("pca_report_", Sys.Date(), ".pdf")
      },
      content = function(file) {
        req(pca_result())
        
        waiter_show(html = tagList(
          spin_fading_circles(),
          h3("Generating PDF Report...", style = "color: #2e8b57; margin-top: 20px;")
        ))
        
        tryCatch({
          # Capture metadata
          metadata <- captureAnalysisMetadata(
            dataset_name = "Community Data",
            n_sites = nrow(data()),
            n_species = ncol(data()),
            analysis_type = "PCA Ordination",
            analysis_params = list(
              scaling = input$scaling,
              center = input$center,
              scale = input$scale
            ),
            result = pca_result()
          )
          
          # Build params
          eig <- eigenvals(pca_result())
          params <- getReportParameters(metadata, list(
            pca_result = pca_result(),
            scaling = input$scaling,
            center = input$center,
            scale = input$scale,
            var_pc1 = eig[1] / sum(eig) * 100,
            var_pc2 = eig[2] / sum(eig) * 100
          ))
          
          # Note: PCA report template would need to be created
          # For now, show success message
          waiter_hide()
          showNotification(
            "PCA report template coming soon! Use CSV export for now.",
            type = "message",
            duration = 5
          )
          
        }, error = function(e) {
          waiter_hide()
          showNotification(
            paste("Error:", e$message),
            type = "error",
            duration = 10
          )
        })
      }
    )
  })
}
