#' Ordination Module
#' 
#' This module provides comprehensive ordination analysis including:
#' - NMDS (Non-metric Multidimensional Scaling)
#' - PCA (Principal Components Analysis)
#' - CA/DCA (Correspondence Analysis)
#' - CCA/RDA (Constrained Analysis)
#' - PCoA (Principal Coordinates Analysis)
#' 
#' @importFrom shiny NS tagList reactive observeEvent req withProgress
#' @importFrom vegan metaMDS rda cca decorana vegdist decostand
#' @importFrom ggplot2 ggplot aes geom_point theme_minimal labs
#' @importFrom tidyr pivot_longer
#' 
library(shiny)
library(vegan)
library(ggplot2)
library(tidyr)

#' Ordination Module UI
#' 
#' Creates the user interface for ordination analysis
#' 
#' @param id Module identifier
#' @return Shiny UI elements for ordination analysis
#' @export
ordinationUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(4,
        card(
          card_header("Ordination Settings"),
          card_body(
            # Method Selection
            selectInput(ns("method"), "Method",
                      choices = c(
                        "NMDS" = "nmds",
                        "PCA" = "pca",
                        "CA" = "ca",
                        "DCA" = "dca",
                        "CCA" = "cca",
                        "RDA" = "rda",
                        "PCoA" = "pcoa"
                      )),
            
            # Distance measure (for NMDS, PCoA)
            conditionalPanel(
              condition = sprintf("input['%s'] == 'nmds' || input['%s'] == 'pcoa'", 
                                ns("method"), ns("method")),
              selectInput(ns("distance"), "Distance Measure",
                        choices = c(
                          "Bray-Curtis" = "bray",
                          "Jaccard" = "jaccard",
                          "Euclidean" = "euclidean",
                          "Manhattan" = "manhattan",
                          "Gower" = "gower"
                        ))
            ),
            
            # Transformation options
            selectInput(ns("transform"), "Data Transformation",
                      choices = c(
                        "None" = "none",
                        "Hellinger" = "hellinger",
                        "Log(x+1)" = "log",
                        "Square root" = "sqrt",
                        "Wisconsin" = "wisconsin"
                      )),
            
            # Advanced settings accordion
            accordion(
              accordion_panel(
                "Advanced Settings",
                numericInput(ns("dimensions"), "Dimensions",
                           value = 2, min = 2, max = 5),
                checkboxInput(ns("scale"), "Scale variables",
                            value = TRUE),
                checkboxInput(ns("envfit"), "Fit environmental variables",
                            value = FALSE)
              )
            ),
            
            # Visualization settings
            accordion(
              accordion_panel(
                "Visualization Settings",
                checkboxInput(ns("ellipses"), "Draw confidence ellipses",
                            value = FALSE),
                conditionalPanel(
                  condition = sprintf("input['%s']", ns("ellipses")),
                  selectInput(ns("ellipseType"), "Ellipse type",
                            choices = c(
                              "Standard error" = "se",
                              "Standard deviation" = "sd",
                              "Confidence interval" = "conf"
                            ))
                ),
                checkboxInput(ns("speciesScores"), "Show species scores",
                            value = TRUE),
                sliderInput(ns("pointSize"), "Point size",
                           min = 1, max = 5, value = 2, step = 0.5),
                colourInput(ns("pointColor"), "Point color",
                          value = "#2E8B57")
              )
            ),
            
            actionButton(ns("runOrdination"), "Run Ordination",
                       class = "btn-success w-100 mt-3")
          )
        )
      ),
      column(8,
        # Results tabs
        tabsetPanel(
          id = ns("resultsTabs"),
          type = "pills",
          
          tabPanel("Plot",
            plotOutput(ns("ordinationPlot"), height = "600px"),
            downloadButton(ns("downloadPlot"), "Download Plot")
          ),
          
          tabPanel("Summary",
            verbatimTextOutput(ns("ordinationSummary"))
          ),
          
          tabPanel("Scores",
            DTOutput(ns("scoresTable")),
            downloadButton(ns("downloadScores"), "Download Scores")
          )
        )
      )
    )
  )
}

#' Ordination Module Server
#' 
#' Server logic for ordination analysis
#' 
#' @param id Module identifier
#' @param data Reactive data source
#' @return None
#' @export
ordinationServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    # Reactive values
    ordination <- reactiveVal(NULL)
    
    #' Transform community data
#' 
#' Applies various transformations to community data:
#' - Hellinger
#' - Log(x+1)
#' - Square root
#' - Wisconsin double standardization
#' 
#' @param data Numeric matrix or data frame
#' @param method Transformation method
#' @return Transformed data
#' @keywords internal
    transformData <- function(data, method) {
      switch(method,
        "none" = data,
        "hellinger" = decostand(data, "hellinger"),
        "log" = log1p(data),
        "sqrt" = sqrt(data),
        "wisconsin" = wisconsin(data)
      )
    }
    
    # Run ordination
    observeEvent(input$runOrdination, {
      req(data())
      
      withProgress(message = 'Running ordination analysis...', {
        tryCatch({
          # Transform data
          transformed_data <- transformData(data(), input$transform)
          
          # Run ordination based on method
          ord <- switch(input$method,
            "nmds" = metaMDS(transformed_data,
                           distance = input$distance,
                           k = input$dimensions),
            "pca" = rda(transformed_data, scale = input$scale),
            "ca" = cca(transformed_data),
            "dca" = decorana(transformed_data),
            "pcoa" = cmdscale(vegdist(transformed_data, 
                                    method = input$distance),
                            k = input$dimensions, eig = TRUE),
            stop("Invalid ordination method")
          )
          
          ordination(ord)
          
        }, error = function(e) {
          showNotification(
            paste("Error in ordination:", e$message),
            type = "error"
          )
        })
      })
    })
    
    # Plot output
    output$ordinationPlot <- renderPlot({
      req(ordination())
      
      # Extract scores
      if(input$method %in% c("nmds", "pca", "ca", "dca")) {
        scores <- as.data.frame(scores(ordination(), display = "sites"))
        species <- if(input$speciesScores) {
          as.data.frame(scores(ordination(), display = "species"))
        } else NULL
      } else {
        scores <- as.data.frame(ordination()$points)
      }
      
      # Base plot
      p <- ggplot(scores, aes(x = scores[,1], y = scores[,2])) +
        geom_point(size = input$pointSize, color = input$pointColor) +
        theme_minimal() +
        labs(
          title = paste(toupper(input$method), "Ordination"),
          x = colnames(scores)[1],
          y = colnames(scores)[2]
        )
      
      # Add species scores if available
      if(!is.null(species)) {
        p <- p + geom_text(data = species,
                          aes(x = species[,1], y = species[,2],
                              label = rownames(species)),
                          size = 3, alpha = 0.7)
      }
      
      # Add confidence ellipses if requested
      if(input$ellipses && !is.null(ordination()$CCA)) {
        p <- p + stat_ellipse(type = input$ellipseType,
                            level = 0.95)
      }
      
      p
    })
    
    # Summary output
    output$ordinationSummary <- renderPrint({
      req(ordination())
      summary(ordination())
    })
    
    # Scores table
    output$scoresTable <- renderDT({
      req(ordination())
      scores <- as.data.frame(scores(ordination(), display = "sites"))
      datatable(scores,
                options = list(pageLength = 10,
                             scrollX = TRUE))
    })
    
    # Download handlers
    output$downloadPlot <- downloadHandler(
      filename = function() {
        paste0("ordination_plot_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".pdf")
      },
      content = function(file) {
        ggsave(file, plot = last_plot(), device = "pdf",
               width = 10, height = 8)
      }
    )
    
    output$downloadScores <- downloadHandler(
      filename = function() {
        paste0("ordination_scores_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".csv")
      },
      content = function(file) {
        scores <- as.data.frame(scores(ordination(), display = "sites"))
        write.csv(scores, file)
      }
    )
  })
}
