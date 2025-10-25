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
        
        # Scaling method
        selectInput(
          ns("scaling"),
          "Scaling Method:",
          choices = c(
            "Correlation (standardized)" = "correlation",
            "Covariance (unstandardized)" = "covariance"
          ),
          selected = "correlation"
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
        div(class = "plot-panel",
          # Variance interpretation box
          uiOutput(ns("variance_interpretation")),
          
          # PCA biplot
          plotOutput(ns("pca_plot"), height = "500px"),
          
          # Plot controls
          div(class = "plot-controls", style = "margin-top: 10px;",
            downloadButton(ns("export_plot"), "💾 Export PNG", class = "btn-sm")
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
#' @return Server logic for PCA analysis
#' @export
pca_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Source utilities
    source("utils/validation.R", local = TRUE)
    source("utils/reproducibility.R", local = TRUE)
    
    # Reactive values
    pca_result <- reactiveVal(NULL)
    
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
    
    # Render PCA biplot
    output$pca_plot <- renderPlot({
      req(pca_result())
      
      # Create biplot
      plot(pca_result(), 
           type = "n",
           main = "PCA Biplot",
           col.main = "#2e8b57",
           cex.main = 1.4,
           font.main = 2)
      
      # Add sample points
      points(pca_result(), 
             display = "sites", 
             pch = 21,
             bg = "#2e8b57", 
             cex = 2,
             col = "#1e1e1e")
      
      # Add species vectors (if not too many)
      if (ncol(data()) <= 30) {
        text(pca_result(), 
             display = "species",
             col = "#007acc",
             cex = 0.7)
      }
      
      # Add variance annotation
      eig <- eigenvals(pca_result())
      var_pc1 <- eig[1] / sum(eig) * 100
      var_pc2 <- eig[2] / sum(eig) * 100
      
      mtext(sprintf("PC1: %.1f%% | PC2: %.1f%%", var_pc1, var_pc2),
            side = 3, line = 0.5, col = "#2e8b57", font = 2, adj = 0, cex = 0.9)
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
                    options = list(pageLength = 10, scrollX = TRUE),
                    rownames = FALSE)
    })
    
    # Export plot
    output$export_plot <- downloadHandler(
      filename = function() {
        paste0("pca_plot_", Sys.Date(), ".png")
      },
      content = function(file) {
        png(file, width = 1200, height = 800, res = 150)
        plot(pca_result(), main = "PCA Biplot")
        points(pca_result(), display = "sites", pch = 21, bg = "#2e8b57", cex = 2)
        if (ncol(data()) <= 30) {
          text(pca_result(), display = "species", col = "#007acc", cex = 0.7)
        }
        dev.off()
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
