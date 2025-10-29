# Ördin - Diversity Estimation Module (iNEXT)
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Rarefaction and extrapolation curves

library(shiny)
library(iNEXT)
library(ggplot2)
library(waiter)
# library(shinyFeedback)  # Disabled - conflicts with custom HTML

#' Diversity Estimation Module UI
diversity_estimation_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    # useShinyFeedback(),  # Disabled - conflicts with custom HTML
    
    div(class = "diversity-estimation-workflow",
      # Header
      h2("📈 Diversity Estimation (iNEXT)", style = "color: #2e8b57; margin-bottom: 20px;"),
      p("Rarefaction and extrapolation curves for Hill numbers", style = "color: #888; margin-bottom: 30px;"),
      
      # Configuration Panel
      div(class = "config-panel",
        
        # TIP BOX: Data Type
        div(style = "background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;",
          p(style = "color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;", "ℹ️ TIP: Choosing Your Data Type"),
          HTML('<p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
            • <strong>Abundance Data:</strong> Use when you have count data (e.g., number of individuals per species)<br>
            • <strong>Incidence Data:</strong> Use for presence/absence across sampling units (e.g., species occurrence in plots)<br>
            • If unsure, abundance data is more common for community ecology datasets
          </p>')
        ),
        
        h3("Step 1: Select Data Type", style = "color: #cccccc; margin-bottom: 16px;"),
        
        # Data type
        selectInput(
          ns("data_type"),
          "Data Type:",
          choices = c(
            "Abundance (individual-based)" = "abundance",
            "Incidence (sampling-unit-based)" = "incidence"
          ),
          selected = "abundance"
        ),
        
        # TIP BOX: Parameters
        div(style = "background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin: 20px 0;",
          p(style = "color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;", "ℹ️ TIP: Parameter Guidelines"),
          HTML('<p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
            • <strong>Confidence Level:</strong> 0.95 (95%) is standard; use 0.99 for more conservative estimates<br>
            • <strong>Bootstrap Replications:</strong> 50 is sufficient for most analyses; increase to 100-200 for publication<br>
            • <strong>Endpoint:</strong> 2× your largest sample size is recommended for extrapolation
          </p>')
        ),
        
        h3("Step 2: Configure Parameters", style = "color: #cccccc; margin-bottom: 16px;"),
        
        # Diversity order
        checkboxGroupInput(
          ns("q_values"),
          "Diversity Orders (q):",
          choices = c(
            "q=0 (Species richness)" = "0",
            "q=1 (Shannon diversity)" = "1",
            "q=2 (Simpson diversity)" = "2"
          ),
          selected = c("0", "1", "2")
        ),
        
        # Endpoint
        numericInput(
          ns("endpoint"),
          "Extrapolation endpoint:",
          value = NULL,
          min = 1,
          step = 1
        ),
        tags$small("Leave empty for 2× reference sample size"),
        
        # Knots (for curve smoothness)
        numericInput(
          ns("knots"),
          "Number of knots (curve smoothness):",
          value = 40,
          min = 20,
          max = 100,
          step = 10
        ),
        tags$small("Higher values = smoother curves (40 is recommended)"),
        
        # Bootstrap replications
        numericInput(
          ns("nboot"),
          "Bootstrap replications:",
          value = 50,
          min = 10,
          max = 200,
          step = 10
        ),
        
        # Confidence level
        numericInput(
          ns("conf"),
          "Confidence level:",
          value = 0.95,
          min = 0.8,
          max = 0.99,
          step = 0.01
        ),
        
        # Run button
        div(class = "action-buttons", style = "margin-top: 20px;",
          actionButton(
            ns("run_inext"),
            "▶ Run iNEXT",
            class = "btn-success",
            style = "width: 100%;"
          )
        )
      ),
      
      # TIP BOX: Plot Types
      div(style = "background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin: 20px 0;",
        p(style = "color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;", "ℹ️ TIP: Understanding Plot Types"),
        HTML('<p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
          • <strong>Sample-Size Based:</strong> Classic rarefaction - shows diversity vs. sample effort<br>
          • <strong>Sample Completeness:</strong> Shows how complete your sampling is (0-1 scale)<br>
          • <strong>Coverage-Based:</strong> Best for comparing assemblages with different sampling intensities
        </p>')
      ),
      
      h3("Step 3: Select Plot Type & View Results", style = "color: #cccccc; margin-bottom: 16px;"),
      
      # Results Area
      div(class = "horizontal-split",
        # Plot Panel (70%)
        div(class = "plot-panel",
          # Plot type selector
          selectInput(
            ns("plot_type"),
            "Plot Type:",
            choices = c(
              "Sample-size based R/E Curve" = 1,
              "Sample Completeness Curve" = 2,
              "Coverage-based R/E Curve" = 3
            ),
            selected = 1
          ),
          
          plotOutput(ns("inext_plot"), height = "500px"),
          
          # Plot controls
          div(class = "plot-controls", style = "margin-top: 10px;",
            downloadButton(ns("export_plot"), "💾 Export Plot", class = "btn-sm")
          )
        ),
        
        # Results Panel (30%)
        div(class = "results-panel",
          # Diversity estimates
          div(class = "results-section",
            h3("📊 DIVERSITY ESTIMATES"),
            DT::dataTableOutput(ns("diversity_table"))
          ),
          
          # Export Actions
          div(class = "action-buttons", style = "margin-top: 20px;",
            downloadButton(ns("export_results"), "📋 Export Results (CSV)", class = "btn-sm")
          )
        )
      )
    )
  )
}

#' Diversity Estimation Module Server
diversity_estimation_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Source utilities
    source("utils/validation.R", local = TRUE)
    source("utils/reproducibility.R", local = TRUE)
    
    # Reactive values
    inext_result <- reactiveVal(NULL)
    
    # Default plot customization values
    plot_defaults <- reactiveValues(
      plot_theme = "bw", font_family = "sans", base_size = 11, title_size = 14,
      axis_title_size = 12, legend_rows = 4, show_ci = TRUE, ci_alpha = 0.3,
      line_size = 1.5, plot_width = 14, plot_height = 6, plot_dpi = 300,
      export_format = "png", strip_size = 11, legend_size = 8,
      axis_lwd = 0.5, show_grid_minor = FALSE, point_size = 2
    )
    
    # Observers
    observeEvent(input$plot_plot_theme, { plot_defaults$plot_theme <- input$plot_plot_theme })
    observeEvent(input$plot_font_family, { plot_defaults$font_family <- input$plot_font_family })
    observeEvent(input$plot_base_size, { plot_defaults$base_size <- input$plot_base_size })
    observeEvent(input$plot_title_size, { plot_defaults$title_size <- input$plot_title_size })
    observeEvent(input$plot_axis_title_size, { plot_defaults$axis_title_size <- input$plot_axis_title_size })
    observeEvent(input$plot_legend_rows, { plot_defaults$legend_rows <- input$plot_legend_rows })
    observeEvent(input$plot_show_ci, { plot_defaults$show_ci <- input$plot_show_ci })
    observeEvent(input$plot_ci_alpha, { plot_defaults$ci_alpha <- input$plot_ci_alpha })
    observeEvent(input$plot_line_size, { plot_defaults$line_size <- input$plot_line_size })
    observeEvent(input$plot_plot_width, { plot_defaults$plot_width <- input$plot_plot_width })
    observeEvent(input$plot_plot_height, { plot_defaults$plot_height <- input$plot_plot_height })
    observeEvent(input$plot_plot_dpi, { plot_defaults$plot_dpi <- input$plot_plot_dpi })
    observeEvent(input$plot_export_format, { plot_defaults$export_format <- input$plot_export_format })
    observeEvent(input$plot_strip_size, { plot_defaults$strip_size <- input$plot_strip_size })
    observeEvent(input$plot_legend_size, { plot_defaults$legend_size <- input$plot_legend_size })
    observeEvent(input$plot_axis_lwd, { plot_defaults$axis_lwd <- input$plot_axis_lwd })
    observeEvent(input$plot_show_grid_minor, { plot_defaults$show_grid_minor <- input$plot_show_grid_minor })
    observeEvent(input$plot_point_size, { plot_defaults$point_size <- input$plot_point_size })
    
    # Validate inputs (shinyFeedback disabled)
    # observeEvent(input$conf, {
    #   validation <- validateConfidenceLevel(input$conf)
    #   
    #   if (validation$type == "error") {
    #     feedbackDanger(ns("conf"), validation$valid, validation$message)
    #   } else {
    #     feedbackSuccess(ns("conf"), validation$valid, validation$message)
    #   }
    # })
    
    # Run iNEXT Analysis
    observeEvent(input$run_inext, {
      req(data())
      req(input$q_values)
      
      # Validate data
      if (nrow(data()) < 1 || ncol(data()) < 1) {
        showNotification(
          "❌ Data is empty. Please load a dataset first.",
          type = "error",
          duration = 5
        )
        return()
      }
      
      # Show loading spinner
      waiter_show(html = tagList(
        spin_fading_circles(),
        h3("Running iNEXT Analysis...", style = "color: #2e8b57; margin-top: 20px;")
      ))
      
      # Prepare data based on type
      q_vals <- as.numeric(input$q_values)
      
      # Prepare data for iNEXT
      # iNEXT expects: list of assemblages OR matrix with rows=species, cols=sites
      inext_data <- tryCatch({
        data_matrix <- as.matrix(data())
        
        if (input$data_type == "abundance") {
          # For abundance data: transpose so rows=species, cols=sites
          # Each column becomes a separate assemblage
          t(data_matrix)
        } else {
          # For incidence data: same structure
          # First row should be number of sampling units, followed by species incidence
          t(data_matrix)
        }
      }, error = function(e) {
        waiter_hide()
        showNotification(
          paste("❌ Data preparation failed:", e$message),
          type = "error",
          duration = 10
        )
        return(NULL)
      })
      
      if (is.null(inext_data)) return()
      
      # Prepare iNEXT arguments
      inext_args <- list(
        x = inext_data,
        q = q_vals,
        datatype = input$data_type,
        nboot = input$nboot,
        conf = input$conf,
        knots = input$knots  # Add knots for curve smoothness
      )
      
      # Only add endpoint if user provided a value
      if (!is.null(input$endpoint) && !is.na(input$endpoint) && input$endpoint > 0) {
        inext_args$endpoint <- input$endpoint
      }
      
      # Run iNEXT
      result <- tryCatch({
        do.call(iNEXT, inext_args)
      }, error = function(e) {
        waiter_hide()
        
        # Provide helpful error message
        error_msg <- e$message
        if (grepl("missing value", error_msg, ignore.case = TRUE)) {
          error_msg <- "Data contains missing values (NA). Please clean your dataset or use complete cases only."
        } else if (grepl("endpoint", error_msg, ignore.case = TRUE)) {
          error_msg <- "Invalid endpoint value. Try leaving it empty or use a value larger than your sample sizes."
        }
        
        showNotification(
          paste("❌ iNEXT failed:", error_msg), 
          type = "error", 
          duration = 10
        )
        NULL
      })
      
      waiter_hide()
      
      if (!is.null(result)) {
        inext_result(result)
        
        showNotification(
          HTML("<strong>✓ iNEXT Complete!</strong><br/>Rarefaction & extrapolation curves generated"),
          type = "message",
          duration = 5
        )
      }
    })
    
    # Render iNEXT plot
    output$inext_plot <- renderPlot({
      req(inext_result())
      
      # Select theme with custom font
      plot_theme <- switch(plot_defaults$plot_theme,
        "bw" = theme_bw(base_size = plot_defaults$base_size, base_family = plot_defaults$font_family),
        "minimal" = theme_minimal(base_size = plot_defaults$base_size, base_family = plot_defaults$font_family),
        "classic" = theme_classic(base_size = plot_defaults$base_size, base_family = plot_defaults$font_family),
        "light" = theme_light(base_size = plot_defaults$base_size, base_family = plot_defaults$font_family),
        "dark" = theme_dark(base_size = plot_defaults$base_size, base_family = plot_defaults$font_family),
        "void" = theme_void(base_size = plot_defaults$base_size, base_family = plot_defaults$font_family),
        theme_bw(base_size = plot_defaults$base_size, base_family = plot_defaults$font_family)  # default
      )
      
      # Determine colors based on theme
      is_dark <- plot_defaults$plot_theme == "dark"
      title_color <- if(is_dark) "#5fd38d" else "#2e8b57"
      bg_color <- if(is_dark) "#1a1a1a" else "white"
      strip_bg <- if(is_dark) "#2a2a2a" else "white"
      strip_border <- if(is_dark) "#404040" else "grey80"
      
      # Create faceted plot with ggiNEXT (se controls CI ribbons)
      p <- ggiNEXT(inext_result(), type = as.numeric(input$plot_type), facet.var = "Order.q", se = plot_defaults$show_ci) +
        plot_theme +
        theme(
          plot.title = element_text(color = title_color, face = "bold", size = plot_defaults$title_size, family = plot_defaults$font_family),
          axis.title = element_text(size = plot_defaults$axis_title_size, family = plot_defaults$font_family),
          axis.text = element_text(size = plot_defaults$base_size - 2, family = plot_defaults$font_family),
          axis.line = element_line(linewidth = plot_defaults$axis_lwd),
          strip.text = element_text(face = "bold", size = plot_defaults$strip_size, family = plot_defaults$font_family),
          strip.background = element_rect(fill = strip_bg, color = strip_border),
          legend.position = "bottom",
          legend.text = element_text(size = plot_defaults$legend_size, family = plot_defaults$font_family),
          legend.title = element_text(face = "bold", size = plot_defaults$base_size - 2, family = plot_defaults$font_family),
          legend.box = "horizontal",
          panel.grid.minor = if(plot_defaults$show_grid_minor) element_line(linewidth = 0.25) else element_blank(),
          panel.background = element_rect(fill = bg_color),
          plot.background = element_rect(fill = bg_color)
        ) +
        guides(
          color = guide_legend(nrow = plot_defaults$legend_rows, order = 1, title = "Site", override.aes = list(size = plot_defaults$point_size)),
          fill = guide_legend(nrow = plot_defaults$legend_rows, order = 1, title = "Site"),
          linetype = guide_legend(order = 2, title = "Method", override.aes = list(linewidth = plot_defaults$line_size))
        )
      
      # Adjust line size globally via geom defaults
      p$layers[[1]]$aes_params$linewidth <- plot_defaults$line_size
      if(length(p$layers) > 1) p$layers[[2]]$aes_params$linewidth <- plot_defaults$line_size
      
      print(p)
    })
    
    # Diversity estimates table
    output$diversity_table <- DT::renderDataTable({
      req(inext_result())
      
      # Extract asymptotic estimates
      asym_data <- inext_result()$AsyEst
      
      # Identify numeric columns dynamically for rounding
      numeric_cols <- names(asym_data)[sapply(asym_data, is.numeric)]
      
      DT::datatable(
        asym_data,
        options = list(
          pageLength = 10,
          scrollX = TRUE,
          dom = 't',
          columnDefs = list(
            list(className = 'dt-center', targets = '_all')
          )
        ),
        rownames = FALSE
      ) %>%
        DT::formatRound(columns = numeric_cols, digits = 3)
    })
    
    # Export plot
    output$export_plot <- downloadHandler(
      filename = function() {
        ext <- plot_defaults$export_format
        paste0("inext_plot_", Sys.Date(), ".", ext)
      },
      content = function(file) {
        # Select theme with custom font
        plot_theme <- switch(plot_defaults$plot_theme,
          "bw" = theme_bw(base_size = plot_defaults$base_size, base_family = plot_defaults$font_family),
          "minimal" = theme_minimal(base_size = plot_defaults$base_size, base_family = plot_defaults$font_family),
          "classic" = theme_classic(base_size = plot_defaults$base_size, base_family = plot_defaults$font_family),
          "light" = theme_light(base_size = plot_defaults$base_size, base_family = plot_defaults$font_family),
          "dark" = theme_dark(base_size = plot_defaults$base_size, base_family = plot_defaults$font_family),
          "void" = theme_void(base_size = plot_defaults$base_size, base_family = plot_defaults$font_family),
          theme_bw(base_size = plot_defaults$base_size, base_family = plot_defaults$font_family)
        )
        
        # Determine colors based on theme
        is_dark <- plot_defaults$plot_theme == "dark"
        title_color <- if(is_dark) "#5fd38d" else "#2e8b57"
        bg_color <- if(is_dark) "#1a1a1a" else "white"
        strip_bg <- if(is_dark) "#2a2a2a" else "white"
        strip_border <- if(is_dark) "#404040" else "grey80"
        
        # Create publication-ready plot
        p <- ggiNEXT(inext_result(), type = as.numeric(input$plot_type), facet.var = "Order.q", se = plot_defaults$show_ci) +
          plot_theme +
          theme(
            plot.title = element_text(color = title_color, face = "bold", size = plot_defaults$title_size, family = plot_defaults$font_family),
            axis.title = element_text(size = plot_defaults$axis_title_size, family = plot_defaults$font_family),
            axis.text = element_text(size = plot_defaults$base_size - 2, family = plot_defaults$font_family),
            axis.line = element_line(linewidth = plot_defaults$axis_lwd),
            strip.text = element_text(face = "bold", size = plot_defaults$strip_size, family = plot_defaults$font_family),
            strip.background = element_rect(fill = strip_bg, color = strip_border),
            legend.position = "bottom",
            legend.text = element_text(size = plot_defaults$legend_size, family = plot_defaults$font_family),
            legend.title = element_text(face = "bold", size = plot_defaults$base_size - 2, family = plot_defaults$font_family),
            legend.box = "horizontal",
            panel.grid.minor = if(plot_defaults$show_grid_minor) element_line(linewidth = 0.25) else element_blank(),
            panel.background = element_rect(fill = bg_color),
            plot.background = element_rect(fill = bg_color)
          ) +
          guides(
            color = guide_legend(nrow = plot_defaults$legend_rows, order = 1, title = "Site", override.aes = list(size = plot_defaults$point_size)),
            fill = guide_legend(nrow = plot_defaults$legend_rows, order = 1, title = "Site"),
            linetype = guide_legend(order = 2, title = "Method", override.aes = list(linewidth = plot_defaults$line_size))
          )
        
        # Adjust line size
        p$layers[[1]]$aes_params$linewidth <- plot_defaults$line_size
        if(length(p$layers) > 1) p$layers[[2]]$aes_params$linewidth <- plot_defaults$line_size
        
        # Save with custom settings
        ggsave(
          file, 
          plot = p, 
          width = plot_defaults$plot_width, 
          height = plot_defaults$plot_height, 
          dpi = plot_defaults$plot_dpi,
          device = plot_defaults$export_format
        )
      }
    )
    
    # Export results CSV
    output$export_results <- downloadHandler(
      filename = function() {
        paste0("inext_results_", Sys.Date(), ".csv")
      },
      content = function(file) {
        req(inext_result())
        
        # Combine all results
        asym <- inext_result()$AsyEst
        write.csv(asym, file, row.names = FALSE)
      }
    )
  })
}
