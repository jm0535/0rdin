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
          
          # Plot Customization Panel
          div(style = "background: #1a1a1a; padding: 15px; margin: 10px 0; border-radius: 5px;",
            h4("🎨 Plot Customization", style = "color: #2e8b57; margin-bottom: 15px; cursor: pointer;",
               onclick = paste0("$('#", ns("plot_custom"), "').toggle();")),
            
            div(id = ns("plot_custom"), class = "plot-customization-grid",
              # Row 1
              div(selectInput(ns("theme"), "Theme:",
                choices = c("Clean" = "bw", "Minimal" = "minimal", "Dark" = "dark"),
                selected = "bw")),
              div(selectInput(ns("font_family"), "Font:",
                choices = c("Sans" = "sans", "Serif" = "serif", "Mono" = "mono"),
                selected = "sans")),
              div(numericInput(ns("base_size"), "Font Size:", value = 12, min = 8, max = 20, step = 1)),
              div(numericInput(ns("title_size"), "Title Size:", value = 14, min = 10, max = 24, step = 1)),
              div(numericInput(ns("point_size"), "Point Size:", value = 2, min = 0.5, max = 5, step = 0.5)),
              div(selectInput(ns("point_shape"), "Shape:",
                choices = c("Circle" = 21, "Square" = 22, "Diamond" = 23, "Triangle" = 24),
                selected = 21)),
              # Row 2
              div(selectInput(ns("point_color"), "Point Color:",
                choices = c("Ördin Green" = "#2e8b57", "Blue" = "#007acc", "Orange" = "#d4a017", 
                            "Red" = "#e74c3c", "Purple" = "#9b59b6", "Teal" = "#1abc9c"),
                selected = "#2e8b57")),
              div(numericInput(ns("point_lwd"), "Border Width:", value = 1.5, min = 0.5, max = 3, step = 0.5)),
              div(checkboxInput(ns("show_grid"), "Show Grid", value = TRUE)),
              div(checkboxInput(ns("show_labels"), "Site Labels", value = FALSE)),
              div(numericInput(ns("plot_width"), "Width (in):", value = 8, min = 4, max = 20, step = 1)),
              div(numericInput(ns("plot_height"), "Height (in):", value = 6, min = 4, max = 16, step = 1)),
              # Row 3
              div(numericInput(ns("dpi"), "DPI:", value = 300, min = 72, max = 600, step = 50)),
              div(selectInput(ns("export_format"), "Format:",
                choices = c("PNG" = "png", "PDF" = "pdf", "SVG" = "svg"),
                selected = "png")),
              div(numericInput(ns("label_size"), "Label Size:", value = 0.8, min = 0.3, max = 2, step = 0.1)),
              div(selectInput(ns("label_pos"), "Label Pos:",
                choices = c("Auto" = 0, "Below" = 1, "Left" = 2, "Above" = 3, "Right" = 4),
                selected = 0)),
              div(numericInput(ns("axis_lwd"), "Axis Width:", value = 1, min = 0.5, max = 3, step = 0.5)),
              div(checkboxInput(ns("equal_aspect"), "Equal Aspect", value = TRUE))
            )
          ),
          
          # PCA biplot
          plotOutput(ns("pca_plot"), height = "500px"),
          
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
      
      # Determine colors based on theme
      is_dark <- input$theme == "dark"
      bg_color <- if(is_dark) "#1a1a1a" else "white"
      fg_color <- if(is_dark) "#cccccc" else "#1e1e1e"
      title_color <- if(is_dark) "#5fd38d" else "#2e8b57"
      grid_color <- if(is_dark) "#404040" else "#cccccc40"
      
      # Set plot parameters
      par(
        family = input$font_family,
        bg = bg_color,
        fg = fg_color,
        col.axis = fg_color,
        col.lab = fg_color,
        col.main = title_color,
        cex = input$base_size / 12,
        cex.main = input$title_size / 12,
        cex.axis = input$base_size / 12,
        cex.lab = input$base_size / 12,
        lwd = input$axis_lwd
      )
      
      # Create base ordination plot
      if(input$equal_aspect) {
        plot(pca_result(), type = "none", main = "PCA Biplot", font.main = 2)
        usr <- par("usr")
        pin <- par("pin")
        if(pin[1] > pin[2]) {
          par(usr = c(mean(usr[1:2]) - diff(usr[3:4])/2, mean(usr[1:2]) + diff(usr[3:4])/2, usr[3:4]))
        } else {
          par(usr = c(usr[1:2], mean(usr[3:4]) - diff(usr[1:2])/2, mean(usr[3:4]) + diff(usr[1:2])/2))
        }
      } else {
        plot(pca_result(), type = "none", main = "PCA Biplot", font.main = 2)
      }
      
      # Add grid if enabled
      if(input$show_grid) {
        grid(col = grid_color, lty = 1)
      }
      
      # Add sample points
      points(pca_result(), 
             display = "sites", 
             pch = as.numeric(input$point_shape),
             bg = input$point_color, 
             cex = input$point_size,
             col = fg_color,
             lwd = input$point_lwd)
      
      # Add labels if enabled
      if(input$show_labels) {
        text(pca_result(), 
             display = "sites",
             cex = input$label_size,
             pos = as.numeric(input$label_pos),
             col = fg_color)
      }
      
      # Add species vectors (if not too many)
      if (ncol(data()) <= 30) {
        text(pca_result(), 
             display = "species",
             col = if(is_dark) "#007acc" else "#007acc",
             cex = input$label_size)
      }
      
      # Add variance annotation
      eig <- eigenvals(pca_result())
      var_pc1 <- eig[1] / sum(eig) * 100
      var_pc2 <- eig[2] / sum(eig) * 100
      
      mtext(sprintf("PC1: %.1f%% | PC2: %.1f%%", var_pc1, var_pc2),
            side = 3, line = 0.5, col = title_color, font = 2, adj = 0, cex = input$base_size / 12)
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
    
    # Export plot with custom settings
    output$export_plot <- downloadHandler(
      filename = function() {
        ext <- input$export_format
        paste0("pca_plot_", Sys.Date(), ".", ext)
      },
      content = function(file) {
        # Determine colors
        is_dark <- input$theme == "dark"
        bg_color <- if(is_dark) "#1a1a1a" else "white"
        fg_color <- if(is_dark) "#cccccc" else "#1e1e1e"
        title_color <- if(is_dark) "#5fd38d" else "#2e8b57"
        grid_color <- if(is_dark) "#404040" else "#cccccc40"
        
        # Open device
        if(input$export_format == "png") {
          png(file, width = input$plot_width * input$dpi, height = input$plot_height * input$dpi, res = input$dpi, bg = bg_color)
        } else if(input$export_format == "pdf") {
          pdf(file, width = input$plot_width, height = input$plot_height, bg = bg_color)
        } else if(input$export_format == "svg") {
          svg(file, width = input$plot_width, height = input$plot_height, bg = bg_color)
        }
        
        par(family = input$font_family, bg = bg_color, fg = fg_color, col.axis = fg_color,
            col.lab = fg_color, col.main = title_color, cex = input$base_size / 12,
            cex.main = input$title_size / 12, lwd = input$axis_lwd)
        
        # Plot without asp parameter
        if(input$equal_aspect) {
          plot(pca_result(), type = "none", main = "PCA Biplot", font.main = 2)
          usr <- par("usr")
          pin <- par("pin")
          if(pin[1] > pin[2]) {
            par(usr = c(mean(usr[1:2]) - diff(usr[3:4])/2, mean(usr[1:2]) + diff(usr[3:4])/2, usr[3:4]))
          } else {
            par(usr = c(usr[1:2], mean(usr[3:4]) - diff(usr[1:2])/2, mean(usr[3:4]) + diff(usr[1:2])/2))
          }
        } else {
          plot(pca_result(), type = "none", main = "PCA Biplot", font.main = 2)
        }
        
        if(input$show_grid) grid(col = grid_color, lty = 1)
        points(pca_result(), display = "sites", pch = as.numeric(input$point_shape),
               bg = input$point_color, cex = input$point_size, col = fg_color, lwd = input$point_lwd)
        if(input$show_labels) {
          text(pca_result(), display = "sites", cex = input$label_size,
               pos = as.numeric(input$label_pos), col = fg_color)
        }
        if (ncol(data()) <= 30) {
          text(pca_result(), display = "species", col = if(is_dark) "#007acc" else "#007acc", cex = input$label_size)
        }
        
        eig <- eigenvals(pca_result())
        var_pc1 <- eig[1] / sum(eig) * 100
        var_pc2 <- eig[2] / sum(eig) * 100
        mtext(sprintf("PC1: %.1f%% | PC2: %.1f%%", var_pc1, var_pc2),
              side = 3, line = 0.5, col = title_color, font = 2, adj = 0, cex = input$base_size / 12)
        
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
