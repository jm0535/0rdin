# Ördin - PCoA Module
# Principal Coordinates Analysis

library(shiny)
library(vegan)

pcoa_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(class = "config-panel",
      h3("⚙️ PCoA Configuration"),
      
      # WHEN TO USE guidance box
      div(style = "background: #4a90e220; border-left: 3px solid #4a90e2; padding: 12px; margin-bottom: 16px;",
        h4(style = "color: #4a90e2; margin: 0 0 8px 0; font-size: 13px; font-weight: 600;", "📘 WHEN TO USE PCoA"),
        tags$ul(style = "color: #ccc; font-size: 11px; margin: 0; padding-left: 20px; line-height: 1.6;",
          tags$li("Visualize **dissimilarity matrices** (e.g., Bray-Curtis, Jaccard)"),
          tags$li("Use when you have a **distance/dissimilarity matrix** rather than raw data"),
          tags$li("Handles **non-Euclidean distances** better than PCA"),
          tags$li("Example: Compare community composition using ecological dissimilarity metrics")
        )
      ),
      
      selectInput(ns("distance"), "Distance:",
                 choices = c("Bray-Curtis" = "bray", "Jaccard" = "jaccard", 
                            "Euclidean" = "euclidean")),
      actionButton(ns("run_pcoa"), "▶ Run PCoA", class = "btn-success", style = "width: 100%;")
    ),
    div(class = "horizontal-split",
      div(class = "plot-panel", style = "max-width: 100%; overflow: hidden;",
        plotOutput(ns("pcoa_plot"), width = "100%", height = "500px"),
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

pcoa_server <- function(id, data, env_data = reactive(NULL)) {
  moduleServer(id, function(input, output, session) {
    pcoa_result <- reactiveVal(NULL)
    source("utils/plotting/ordination_plotting.R", local = TRUE)
    
    plot_defaults <- reactiveValues(
      theme = "bw", font_family = "sans", base_size = 12, title_size = 14,
      point_size = 2, point_shape = "21", point_color = "#2e8b57", point_lwd = 1.5,
      show_grid = TRUE, show_labels = FALSE, plot_width = 8, plot_height = 6,
      dpi = 300, export_format = "png", label_size = 0.8, label_pos = "0",
      axis_lwd = 1, equal_aspect = TRUE,
      show_ellipses = FALSE, group_var = "", ellipse_type = "norm", ellipse_level = 0.95
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
    observeEvent(input$plot_show_ellipses, { plot_defaults$show_ellipses <- input$plot_show_ellipses }, ignoreNULL = FALSE)
    observeEvent(input$plot_group_var, { plot_defaults$group_var <- input$plot_group_var }, ignoreNULL = FALSE)
    observeEvent(input$plot_ellipse_type, { plot_defaults$ellipse_type <- input$plot_ellipse_type }, ignoreNULL = FALSE)
    observeEvent(input$plot_ellipse_level, { plot_defaults$ellipse_level <- input$plot_ellipse_level }, ignoreNULL = FALSE)
    
    observeEvent(input$run_pcoa, {
      req(data())
      result <- tryCatch({
        capscale(data() ~ 1, distance = input$distance)
      }, error = function(e) NULL)
      
      if (!is.null(result)) {
        pcoa_result(result)
        session$sendCustomMessage(type = "showPlotCustomization",
          message = list(plotType = "ordination", moduleId = "pcoa"))
        if (!is.null(env_data()) && nrow(env_data()) > 0) {
          env_df <- env_data()
          factor_cols <- names(env_df)[sapply(env_df, function(x) is.factor(x) || is.character(x))]
          if (length(factor_cols) > 0) {
            choices_list <- list()
            choices_list[[""]] <- "None"
            for (col in factor_cols) choices_list[[col]] <- col
            shinyjs::delay(1000, {
              session$sendCustomMessage(type = "updateGroupingVar",
                message = list(moduleId = "pcoa", choices = choices_list))
            })
          }
        }
        showNotification("✓ PCoA Complete!", type = "message")
      }
    })
    
    output$pcoa_plot <- renderPlot({  
      req(pcoa_result())
      plot_show_ellipses <- plot_defaults$show_ellipses
      plot_group_var <- plot_defaults$group_var
      plot_ellipse_type <- plot_defaults$ellipse_type
      plot_ellipse_level <- plot_defaults$ellipse_level
      grouping_var <- NULL
      if (!is.null(plot_show_ellipses) && plot_show_ellipses && 
          !is.null(plot_group_var) && plot_group_var != "" && 
          !is.null(env_data()) && nrow(env_data()) > 0) {
        grouping_var <- env_data()[[plot_group_var]]
        if (!is.factor(grouping_var)) grouping_var <- as.factor(grouping_var)
      }
      p <- generate_ordination_plot(pcoa_result(), plot_defaults, grouping_var)
      if (!is.null(grouping_var) && !is.null(plot_ellipse_type)) {
        ellipse_level <- if (!is.null(plot_ellipse_level)) plot_ellipse_level else 0.95
        p <- add_ordination_ellipses(p, pcoa_result(), grouping_var, plot_ellipse_type, ellipse_level)
      }
      p <- p + labs(title = "PCoA Ordination") +
        theme(plot.title = element_text(size = plot_defaults$title_size, face = "bold", color = "#2e8b57"))
      print(p)
    })
    
    output$export_plot <- downloadHandler(
      filename = function() paste0("pcoa_plot_", Sys.Date(), ".", plot_defaults$export_format),
      content = function(file) {
        grouping_var <- NULL
        if (!is.null(input$plot_show_ellipses) && input$plot_show_ellipses && 
            !is.null(input$plot_group_var) && input$plot_group_var != "" && 
            !is.null(env_data) && is.function(env_data) && !is.null(env_data())) {
          grouping_var <- env_data()[[input$plot_group_var]]
          if (!is.factor(grouping_var)) grouping_var <- as.factor(grouping_var)
        }
        p <- generate_ordination_plot(pcoa_result(), plot_defaults, grouping_var)
        if (!is.null(grouping_var) && !is.null(input$plot_ellipse_type)) {
          ellipse_level <- if (!is.null(input$plot_ellipse_level)) input$plot_ellipse_level else 0.95
          p <- add_ordination_ellipses(p, pcoa_result(), grouping_var, input$plot_ellipse_type, ellipse_level)
        }
        p <- p + labs(title = "PCoA Ordination") +
          theme(plot.title = element_text(size = plot_defaults$title_size, face = "bold", color = "#2e8b57"))
        export_ordination_plot(p, file, plot_defaults$plot_width, plot_defaults$plot_height,
                              plot_defaults$dpi, plot_defaults$export_format)
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
