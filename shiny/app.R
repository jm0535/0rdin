library(shiny)
library(bslib)
library(vegan)
library(iNEXT)
library(ggplot2)
library(DT)
library(readr)
library(dplyr)

# UI with modern Bootstrap 5 theme
ui <- page_sidebar(
  theme = bs_theme(
    version = 5, 
    bootswatch = "darkly",
    primary = "#2e8b57",  # Forest green, evoking Odin's wisdom
    "font-scale" = 1.1
  ),
  title = "Ördin: Biodiversity Analysis",
  sidebar = sidebar(
    width = 350,
    fileInput("dataFile", "Upload Species Data CSV", accept = ".csv"),
    helpText("CSV format: First column = Site names, Other columns = Species data"),
    hr(),
    selectInput("dataType", "Data Type",
                choices = c("Abundance (counts)" = "abundance",
                           "Incidence (presence/absence)" = "incidence")),
    helpText("Abundance: Individual-based rarefaction. Incidence: Incidence-based rarefaction."),
    hr(),
    selectInput("analysisType", "Select Analysis",
                choices = c("Diversity Estimation (iNEXT)", "Ordination (NMDS via vegan)")),
    conditionalPanel(
      condition = "input.analysisType == 'Diversity Estimation (iNEXT)'",
      selectInput("plotType", "Rarefaction Plot Type",
                  choices = c(
                    "Sample-size-based (Type 1)" = "1",
                    "Sample completeness (Type 2)" = "2",
                    "Coverage-based (Type 3)" = "3"
                  )),
      helpText("Type 1: Standard rarefaction by sample size. Type 2: Sample coverage. Type 3: Coverage-based comparison."),
      hr(),
      h5("iNEXT Advanced Options"),
      checkboxGroupInput("hillNumbers", "Hill Numbers (Diversity Orders)",
                         choices = c("q=0 (Species Richness)" = "0",
                                   "q=1 (Shannon Diversity)" = "1",
                                   "q=2 (Simpson Diversity)" = "2"),
                         selected = c("0", "1", "2")),
      numericInput("knots", "Number of Knots (smoothness)",
                   value = 40, min = 10, max = 200, step = 10),
      helpText("More knots = smoother curves (default: 40)"),
      numericInput("nboot", "Bootstrap Replicates (CI)",
                   value = 50, min = 10, max = 500, step = 10),
      helpText("More replicates = more accurate CI (default: 50, increase for publication)"),
      numericInput("conf", "Confidence Level",
                   value = 0.95, min = 0.80, max = 0.99, step = 0.01),
      helpText("Default: 0.95 (95% CI)")
    ),
    conditionalPanel(
      condition = "input.analysisType == 'Ordination (NMDS via vegan)'",
      numericInput("nmdsDimensions", "NMDS Dimensions", value = 2, min = 1, max = 5)
    ),
    actionButton("runAnalysis", "Run Analysis", class = "btn-primary btn-lg"),
    hr(),
    downloadButton("downloadSummary", "Download Summary CSV"),
    downloadButton("downloadPlot", "Download Plot PNG")
  ),
  card(
    full_screen = TRUE,
    fill = TRUE,
    card_header("Analysis Results"),
    uiOutput("resultsUI")
  )
)

server <- function(input, output, session) {
  # Reactive data loading
  data <- reactive({
    req(input$dataFile)
    
    tryCatch({
      df <- read_csv(input$dataFile$datapath, show_col_types = FALSE)
      
      # Validation
      validate(
        need(ncol(df) > 1, "CSV must have at least one site column and one species column.")
      )
      
      # Extract site names and abundance matrix
      site_names <- df[[1]]
      abund_matrix <- as.matrix(df[-1])
      rownames(abund_matrix) <- site_names
      
      # Check if data is numeric
      validate(
        need(all(sapply(df[-1], is.numeric)), "All abundance columns (except first) must be numeric.")
      )
      
      # For iNEXT, transpose the matrix so each column is a site (assemblage)
      # iNEXT expects: columns = assemblages, rows = species
      abund_matrix_t <- t(abund_matrix)
      colnames(abund_matrix_t) <- site_names
      
      list(
        original = abund_matrix,        # For NMDS (sites as rows)
        transposed = abund_matrix_t     # For iNEXT (sites as columns)
      )
    }, error = function(e) {
      validate(need(FALSE, paste("Error reading CSV:", e$message)))
    })
  })
  
  # Store analysis results
  results <- reactiveVal(NULL)
  
  # Run analysis when button is clicked
  observeEvent(input$runAnalysis, {
    req(data())
    
    withProgress(message = 'Running analysis...', value = 0, {
      if (input$analysisType == "Diversity Estimation (iNEXT)") {
        incProgress(0.3, detail = "Calculating diversity indices...")
        
        # Use transposed matrix for iNEXT (sites as columns)
        abund_matrix_t <- data()$transposed
        
        # Determine data type for iNEXT
        data_type <- input$dataType
        
        # Get selected Hill numbers
        selected_q <- as.numeric(input$hillNumbers)
        if (length(selected_q) == 0) selected_q <- c(0, 1, 2)  # Default if none selected
        
        # Run iNEXT analysis with custom parameters
        # Parameters:
        # - q: Hill numbers (diversity orders)
        # - datatype: "abundance" (individual-based) or "incidence" (incidence-based)
        # - knots: number of points for smooth curves (default: 40)
        # - nboot: bootstrap replicates for confidence intervals (default: 50)
        # - conf: confidence level (default: 0.95)
        inext_out <- iNEXT(
          x = abund_matrix_t, 
          q = selected_q, 
          datatype = data_type,
          knots = input$knots,
          nboot = input$nboot,
          conf = input$conf
        )
        
        incProgress(0.6, detail = "Generating plots...")
        
        # Extract summary
        summary_df <- inext_out$AsyEst
        
        # Determine plot type from input
        plot_type_num <- as.numeric(input$plotType)
        
        # Create plot title based on data type and plot type
        rarefaction_type <- if (data_type == "abundance") "Individual-based" else "Incidence-based"
        plot_type_label <- c(
          "1" = "Sample-size-based R/E",
          "2" = "Sample Completeness",
          "3" = "Coverage-based R/E"
        )[input$plotType]
        
        plot_title <- paste0("Ördin: ", rarefaction_type, " Rarefaction (", plot_type_label, ")")
        
        # Create plot with shaded confidence intervals
        # BYPASS ggiNEXT() and use manual ggplot2 to ensure proper geom_ribbon()
        # This guarantees shaded CI regions instead of jagged lines
        
        # Extract plotting data from iNEXT object
        plot_data <- inext_out$iNextEst
        
        # Determine plot type from input
        plot_type_num <- as.numeric(input$plotType)
        
        # Prepare data based on plot type
        if (plot_type_num == 1) {
          # Type 1: Sample-size-based
          df <- plot_data %>%
            filter(Method != "Observed") %>%
            mutate(
              x = ifelse(Method == "Rarefaction", m, m),
              Method_label = Method
            )
          x_lab <- ifelse(data_type == "abundance", "Number of individuals", "Number of sampling units")
          y_lab <- "Species diversity"
          
        } else if (plot_type_num == 2) {
          # Type 2: Sample completeness
          df <- plot_data %>%
            filter(Method != "Observed") %>%
            mutate(
              x = m,
              qD = SC,
              qD.LCL = SC.LCL,
              qD.UCL = SC.UCL,
              Method_label = Method
            )
          x_lab <- ifelse(data_type == "abundance", "Number of individuals", "Number of sampling units")
          y_lab <- "Sample coverage"
          
        } else {
          # Type 3: Coverage-based
          df <- plot_data %>%
            filter(Method != "Observed") %>%
            mutate(
              x = SC,
              Method_label = Method
            )
          x_lab <- "Sample coverage"
          y_lab <- "Species diversity"
        }
        
        # Create the plot manually with proper geom_ribbon for SHADED CI
        plot_obj <- ggplot(df, aes(x = x, y = qD, color = Assemblage, fill = Assemblage)) +
          # SHADED confidence intervals as ribbons
          geom_ribbon(
            aes(ymin = qD.LCL, ymax = qD.UCL),
            alpha = 0.2,           # Semi-transparent shading
            color = NA,            # No border on ribbon
            show.legend = FALSE
          ) +
          # Point estimate lines
          geom_line(
            aes(linetype = Method_label),
            linewidth = 1.2
          ) +
          # Styling
          scale_linetype_manual(
            values = c("Rarefaction" = "solid", "Extrapolation" = "dashed"),
            name = "Method"
          ) +
          facet_wrap(~ Order.q, scales = "free_y", 
                     labeller = labeller(Order.q = c(
                       "0" = "q=0 (Species Richness)",
                       "1" = "q=1 (Shannon Diversity)",
                       "2" = "q=2 (Simpson Diversity)"
                     ))) +
          labs(
            title = plot_title,
            subtitle = paste0(
              "Sites: ", paste(colnames(abund_matrix_t), collapse = ", "),
              " | Hill numbers q=", paste(selected_q, collapse = ", "),
              " | ", input$conf * 100, "% CI (nboot=", input$nboot, ")"
            ),
            x = x_lab,
            y = y_lab,
            color = "Site",
            fill = "Site"
          ) +
          theme_minimal(base_size = 14) +
          theme(
            plot.title = element_text(size = 16, face = "bold"),
            legend.position = "bottom",
            legend.box = "vertical",
            strip.text = element_text(size = 12, face = "bold")
          )
        
        incProgress(1, detail = "Done!")
        
        results(list(
          summary = summary_df, 
          plot = plot_obj,
          type = "iNEXT"
        ))
        
      } else {
        incProgress(0.3, detail = "Calculating dissimilarity matrix...")
        
        # Use original matrix for NMDS (sites as rows)
        abund_matrix <- data()$original
        
        # Run NMDS ordination
        dist_matrix <- vegdist(abund_matrix, method = "bray")
        
        incProgress(0.5, detail = "Running NMDS...")
        
        nmds_out <- metaMDS(dist_matrix, k = input$nmdsDimensions, 
                           try = 50, trymax = 100, trace = 0)
        
        incProgress(0.8, detail = "Generating plots...")
        
        # Extract scores
        scores_df <- data.frame(
          Site = rownames(nmds_out$points), 
          nmds_out$points
        )
        
        # Create plot
        if (input$nmdsDimensions >= 2) {
          plot_obj <- ggplot(scores_df, aes(x = MDS1, y = MDS2)) +
            geom_point(size = 4, color = "#2e8b57", alpha = 0.7) +
            geom_text(aes(label = Site), vjust = -1, color = "white", size = 4) +
            theme_minimal(base_size = 14) +
            theme(
              panel.background = element_rect(fill = "#222222", color = NA),
              plot.background = element_rect(fill = "#222222", color = NA),
              panel.grid = element_line(color = "#444444"),
              text = element_text(color = "white"),
              axis.text = element_text(color = "white")
            ) +
            labs(
              title = "Ördin: NMDS Ordination", 
              subtitle = paste("Stress:", round(nmds_out$stress, 3)),
              x = "MDS1", 
              y = "MDS2"
            )
        } else {
          plot_obj <- ggplot(scores_df, aes(x = MDS1, y = 0)) +
            geom_point(size = 4, color = "#2e8b57", alpha = 0.7) +
            geom_text(aes(label = Site), vjust = -1, color = "white", size = 4) +
            theme_minimal(base_size = 14) +
            theme(
              panel.background = element_rect(fill = "#222222", color = NA),
              plot.background = element_rect(fill = "#222222", color = NA),
              panel.grid = element_line(color = "#444444"),
              text = element_text(color = "white"),
              axis.text = element_text(color = "white")
            ) +
            labs(
              title = "Ördin: NMDS Ordination (1D)", 
              subtitle = paste("Stress:", round(nmds_out$stress, 3)),
              x = "MDS1", 
              y = ""
            )
        }
        
        incProgress(1, detail = "Done!")
        
        results(list(
          summary = scores_df, 
          plot = plot_obj, 
          stress = nmds_out$stress,
          type = "NMDS"
        ))
      }
    })
  })
  
  # Render results UI
  output$resultsUI <- renderUI({
    req(results())
    res <- results()
    
    tagList(
      h4("Summary Table"),
      DTOutput("summaryTable"),
      if (!is.null(res$stress)) {
        div(
          class = "alert alert-info mt-3",
          h5(paste("NMDS Stress:", round(res$stress, 3))),
          p(ifelse(res$stress < 0.05, "Excellent representation",
                  ifelse(res$stress < 0.1, "Good representation",
                        ifelse(res$stress < 0.2, "Acceptable representation",
                              "Poor representation - consider fewer dimensions"))))
        )
      },
      h4("Visualization", class = "mt-4"),
      plotOutput("analysisPlot", height = "600px")
    )
  })
  
  # Render summary table
  output$summaryTable <- renderDT({
    req(results())
    datatable(
      results()$summary, 
      options = list(
        pageLength = 10,
        scrollX = TRUE,
        dom = 'Bfrtip',
        buttons = c('copy', 'csv')
      ), 
      extensions = 'Buttons',
      rownames = FALSE
    )
  })
  
  # Render plot
  output$analysisPlot <- renderPlot({
    req(results())
    results()$plot
  })
  
  # Download handlers
  output$downloadSummary <- downloadHandler(
    filename = function() { 
      paste0("ordin_", tolower(results()$type), "_summary_", Sys.Date(), ".csv") 
    },
    content = function(file) {
      req(results())
      write_csv(results()$summary, file)
    }
  )
  
  output$downloadPlot <- downloadHandler(
    filename = function() { 
      paste0("ordin_", tolower(results()$type), "_plot_", Sys.Date(), ".png") 
    },
    content = function(file) {
      req(results())
      ggsave(file, plot = results()$plot, device = "png", 
             width = 12, height = 8, dpi = 300, bg = "#222222")
    }
  )
}

shinyApp(ui, server)
