library(shiny)
library(bslib)
library(vegan)
library(iNEXT)
library(ggplot2)
library(DT)
library(readr)

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
    fileInput("dataFile", "Upload Species Abundance CSV", accept = ".csv"),
    helpText("CSV format: First column = Site names, Other columns = Species abundances (numeric)"),
    hr(),
    selectInput("analysisType", "Select Analysis",
                choices = c("Diversity Estimation (iNEXT)", "Ordination (NMDS via vegan)")),
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
        need(ncol(df) > 1, "CSV must have at least one site column and one species column."),
        need(all(sapply(df[-1], is.numeric)), "All abundance columns (except first) must be numeric.")
      )
      
      # Extract site names and abundance matrix
      site_names <- df[[1]]
      abund_matrix <- as.matrix(df[-1])
      rownames(abund_matrix) <- site_names
      
      abund_matrix
    }, error = function(e) {
      validate(need(FALSE, paste("Error reading CSV:", e$message)))
    })
  })
  
  # Store analysis results
  results <- reactiveVal(NULL)
  
  # Run analysis when button is clicked
  observeEvent(input$runAnalysis, {
    req(data())
    abund_matrix <- data()
    
    withProgress(message = 'Running analysis...', value = 0, {
      if (input$analysisType == "Diversity Estimation (iNEXT)") {
        incProgress(0.3, detail = "Calculating diversity indices...")
        
        # Run iNEXT analysis
        inext_out <- iNEXT(abund_matrix, q = c(0, 1, 2), datatype = "abundance")
        
        incProgress(0.6, detail = "Generating plots...")
        
        # Extract summary
        summary_df <- inext_out$AsyEst
        
        # Create plot
        plot_obj <- ggiNEXT(inext_out, type = 1) + 
          theme_minimal(base_size = 14) + 
          labs(title = "Ördin: Rarefaction/Extrapolation Curve",
               subtitle = paste("Sites:", paste(rownames(abund_matrix), collapse = ", "))) +
          theme(
            plot.title = element_text(size = 16, face = "bold"),
            legend.position = "bottom"
          )
        
        incProgress(1, detail = "Done!")
        
        results(list(
          summary = summary_df, 
          plot = plot_obj,
          type = "iNEXT"
        ))
        
      } else {
        incProgress(0.3, detail = "Calculating dissimilarity matrix...")
        
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
