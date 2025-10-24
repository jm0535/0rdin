#' Diversity Analysis Module
#' 
#' This module provides comprehensive diversity analysis tools including:
#' - iNEXT-based rarefaction and extrapolation
#' - Hill numbers (q = 0, 1, 2)
#' - Classic diversity indices
#' 
#' @importFrom shiny NS tagList reactive observeEvent req withProgress
#' @importFrom iNEXT iNEXT ggiNEXT
#' @importFrom vegan diversity specnumber fisher.alpha
#' @importFrom ggplot2 ggplot aes geom_point theme_minimal labs
#' 
library(shiny)
library(iNEXT)
library(vegan)
library(ggplot2)

#' Diversity Analysis Module UI
#' 
#' Creates the user interface for diversity analysis operations
#' 
#' @param id Module identifier
#' @return Shiny UI elements for diversity analysis
#' @export
diversityAnalysisUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(4,
        card(
          card_header("Analysis Settings"),
          card_body(
            selectInput(ns("analysisType"), "Analysis Type",
                      choices = c("Rarefaction & Extrapolation" = "inext",
                                "Diversity Indices" = "indices")),
            
            # iNEXT settings
            conditionalPanel(
              condition = sprintf("input['%s'] == 'inext'", ns("analysisType")),
              selectInput(ns("dataType"), "Data Type",
                        choices = c("Abundance" = "abundance",
                                  "Incidence" = "incidence_raw")),
              numericInput(ns("knots"), "Knots", value = 40, min = 10, max = 100),
              numericInput(ns("bootstraps"), "Bootstrap Replicates", 
                         value = 50, min = 10, max = 200),
              actionButton(ns("runInext"), "Run Analysis", 
                         class = "btn-success w-100")
            ),
            
            # Diversity indices settings
            conditionalPanel(
              condition = sprintf("input['%s'] == 'indices'", ns("analysisType")),
              checkboxGroupInput(ns("indices"), "Select Indices",
                               choices = c("Shannon" = "shannon",
                                         "Simpson" = "simpson",
                                         "Fisher's Alpha" = "fisher",
                                         "Pielou's Evenness" = "pielou")),
              actionButton(ns("runIndices"), "Calculate Indices",
                         class = "btn-success w-100")
            )
          )
        )
      ),
      column(8,
        # Results panel
        uiOutput(ns("resultsPanel"))
      )
    )
  )
}

#' Diversity Analysis Module Server
#' 
#' Server logic for diversity analysis operations
#' 
#' @param id Module identifier
#' @param data Reactive data source
#' @return None
#' @export
diversityAnalysisServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    # Reactive values for results storage
    results <- reactiveVal(NULL)
    
    #' Safe execution wrapper for analysis functions
#' 
#' Provides error handling and user feedback for analysis operations
#' 
#' @param expr Expression to evaluate
#' @return Result of expression or NULL on error
#' @keywords internal
    safeExecute <- function(expr) {
      tryCatch(
        expr,
        error = function(e) {
          showNotification(
            paste("Error in analysis:", e$message),
            type = "error"
          )
          NULL
        }
      )
    }
    
    # iNEXT analysis handler
    observeEvent(input$runInext, {
      req(data())
      withProgress(message = 'Running iNEXT analysis...', {
        results(safeExecute({
          # Convert data to iNEXT format
          idata <- if(input$dataType == "abundance") {
            t(as.matrix(data()))
          } else {
            list(data())
          }
          
          # Run iNEXT
          out <- iNEXT(idata,
                      q = c(0, 1, 2),
                      datatype = input$dataType,
                      knots = input$knots,
                      nboot = input$bootstraps)
          
          # Return results list
          list(
            type = "inext",
            data = out,
            plots = list(
              diversity = ggiNEXT(out),
              coverage = ggiNEXT(out, type = 2)
            )
          )
        }))
      })
    })
    
    # Diversity indices handler
    observeEvent(input$runIndices, {
      req(data())
      withProgress(message = 'Calculating diversity indices...', {
        results(safeExecute({
          indices <- list()
          
          if("shannon" %in% input$indices)
            indices$shannon <- diversity(data(), index = "shannon")
          
          if("simpson" %in% input$indices)
            indices$simpson <- diversity(data(), index = "simpson")
          
          if("fisher" %in% input$indices)
            indices$fisher <- fisher.alpha(data())
          
          if("pielou" %in% input$indices)
            indices$pielou <- diversity(data(), index = "shannon") / log(specnumber(data()))
          
          list(
            type = "indices",
            data = indices
          )
        }))
      })
    })
    
    # Results panel renderer
    output$resultsPanel <- renderUI({
      req(results())
      
      if(results()$type == "inext") {
        tagList(
          plotOutput(session$ns("inextPlot")),
          plotOutput(session$ns("coveragePlot")),
          downloadButton(session$ns("downloadResults"), "Download Results")
        )
      } else {
        tagList(
          tableOutput(session$ns("indicesTable")),
          downloadButton(session$ns("downloadResults"), "Download Results")
        )
      }
    })
    
    # Plot renderers
    output$inextPlot <- renderPlot({
      req(results()$type == "inext")
      results()$plots$diversity
    })
    
    output$coveragePlot <- renderPlot({
      req(results()$type == "inext")
      results()$plots$coverage
    })
    
    # Table renderer
    output$indicesTable <- renderTable({
      req(results()$type == "indices")
      data.frame(
        Index = names(results()$data),
        Value = unlist(results()$data)
      )
    })
    
    # Download handler
    output$downloadResults <- downloadHandler(
      filename = function() {
        paste0("diversity_analysis_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".csv")
      },
      content = function(file) {
        if(results()$type == "inext") {
          write.csv(results()$data$AsyEst, file)
        } else {
          write.csv(data.frame(
            Index = names(results()$data),
            Value = unlist(results()$data)
          ), file)
        }
      }
    )
  })
}
