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
    useShinyFeedback(),
    
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
            downloadButton(ns("export_plot"), "💾 Export PNG", class = "btn-sm")
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
    
    # Validate inputs
    observeEvent(input$conf, {
      validation <- validateConfidenceLevel(input$conf)
      
      if (validation$type == "error") {
        feedbackDanger(ns("conf"), validation$valid, validation$message)
      } else {
        feedbackSuccess(ns("conf"), validation$valid, validation$message)
      }
    })
    
    # Run iNEXT Analysis
    observeEvent(input$run_inext, {
      req(data())
      req(input$q_values)
      
      # Show loading spinner
      waiter_show(html = tagList(
        spin_fading_circles(),
        h3("Running iNEXT Analysis...", style = "color: #2e8b57; margin-top: 20px;")
      ))
      
      # Prepare data based on type
      q_vals <- as.numeric(input$q_values)
      
      # Run iNEXT
      result <- tryCatch({
        iNEXT(
          data(), 
          q = q_vals,
          datatype = input$data_type,
          endpoint = input$endpoint,
          nboot = input$nboot,
          conf = input$conf
        )
      }, error = function(e) {
        waiter_hide()
        showNotification(
          paste("❌ iNEXT failed:", e$message), 
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
      
      # Create plot
      p <- ggiNEXT(inext_result(), type = as.numeric(input$plot_type)) +
        theme_bw() +
        theme(
          plot.title = element_text(color = "#2e8b57", size = 16, face = "bold"),
          axis.title = element_text(size = 12),
          legend.position = "right",
          panel.grid.minor = element_blank()
        ) +
        scale_color_manual(values = c("#2e8b57", "#007acc", "#d4a017")) +
        scale_fill_manual(values = c("#2e8b5740", "#007acc40", "#d4a01740"))
      
      print(p)
    })
    
    # Diversity estimates table
    output$diversity_table <- DT::renderDataTable({
      req(inext_result())
      
      # Extract asymptotic estimates
      asym_data <- inext_result()$AsyEst
      
      DT::datatable(
        asym_data,
        options = list(
          pageLength = 10,
          scrollX = TRUE,
          dom = 't'
        ),
        rownames = FALSE
      ) %>%
        DT::formatRound(columns = c('Observed', 'Estimator', 's.e.', 'LCL', 'UCL'), digits = 3)
    })
    
    # Export plot
    output$export_plot <- downloadHandler(
      filename = function() {
        paste0("inext_plot_", Sys.Date(), ".png")
      },
      content = function(file) {
        p <- ggiNEXT(inext_result(), type = as.numeric(input$plot_type)) +
          theme_bw() +
          scale_color_manual(values = c("#2e8b57", "#007acc", "#d4a017"))
        
        ggsave(file, plot = p, width = 12, height = 8, dpi = 300)
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
