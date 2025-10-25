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

# Source NMDS module
source("shiny/modules/ordination_nmds_module.R")
source("shiny/utils/validation.R")
source("shiny/utils/interpretation.R")

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
      column(3,
        card(
          card_header("Ordination Methods"),
          card_body(
            # Method Selection with icon buttons
            div(class = "method-selector",
              actionButton(ns("select_nmds"), 
                         HTML("<i class='fa fa-map'></i> NMDS"),
                         class = "btn-block mb-2"),
              actionButton(ns("select_pca"), 
                         HTML("<i class='fa fa-chart-scatter'></i> PCA"),
                         class = "btn-block mb-2"),
              actionButton(ns("select_ca"), 
                         HTML("<i class='fa fa-project-diagram'></i> CA"),
                         class = "btn-block mb-2"),
              actionButton(ns("select_dca"), 
                         HTML("<i class='fa fa-bezier-curve'></i> DCA"),
                         class = "btn-block mb-2"),
              actionButton(ns("select_cca"), 
                         HTML("<i class='fa fa-layer-group'></i> CCA"),
                         class = "btn-block mb-2"),
              actionButton(ns("select_rda"), 
                         HTML("<i class='fa fa-arrows-alt'></i> RDA"),
                         class = "btn-block mb-2"),
              actionButton(ns("select_pcoa"), 
                         HTML("<i class='fa fa-circle'></i> PCoA"),
                         class = "btn-block")
            )
          )
        )
      ),
      column(9,
        # Conditional panels for each method
        conditionalPanel(
          condition = sprintf("input['%s'] > 0", ns("select_nmds")),
          nmds_ui(ns("nmds_module"))
        ),
        
        # Placeholder for other methods (existing legacy code)
        conditionalPanel(
          condition = sprintf("input['%s'] > 0 || input['%s'] > 0 || input['%s'] > 0 || input['%s'] > 0 || input['%s'] > 0 || input['%s'] > 0", 
                            ns("select_pca"), ns("select_ca"), ns("select_dca"), 
                            ns("select_cca"), ns("select_rda"), ns("select_pcoa")),
          card(
            card_header("Legacy Ordination Interface"),
            card_body(
              p("Legacy ordination methods (PCA, CA, DCA, CCA, RDA, PCoA) coming soon..."),
              p("Will follow the same modular structure as NMDS.")
            )
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
    # Reactive values for legacy methods
    ordination <- reactiveVal(NULL)
    
    # Call NMDS module (new modular implementation)
    nmds_server("nmds_module", data = data)
    
    # Legacy ordination methods (to be refactored later)
    # Currently keeping old code for PCA, CA, DCA, CCA, RDA, PCoA
    # These will be modularized in Phase 2
    
    # TODO: Refactor remaining methods to follow NMDS module pattern
  })
}
