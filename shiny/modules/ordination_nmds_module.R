# Ördin - NMDS Module
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Non-metric Multidimensional Scaling (NMDS) ordination workflow

library(shiny)
library(vegan)
library(waiter)
library(shinyFeedback)
library(rmarkdown)

#' NMDS Module UI
#'
#' @param id Module namespace ID
#' @return UI elements for NMDS workflow
#' @export
nmds_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Use shinyFeedback
    useShinyFeedback(),
    
    div(class = "nmds-workflow",
      # Configuration Panel
      div(class = "config-panel",
        h3("⚙️ NMDS Configuration"),
        
        # Distance Metric
        selectInput(
          ns("distance"),
          "Distance/Dissimilarity:",
          choices = c(
            "Bray-Curtis" = "bray",
            "Jaccard" = "jaccard",
            "Euclidean" = "euclidean",
            "Manhattan" = "manhattan",
            "Canberra" = "canberra",
            "Horn" = "horn"
          ),
          selected = "bray"
        ),
        
        # Dimensions (k)
        numericInput(
          ns("k"),
          "Dimensions (k):",
          value = 2,
          min = 1,
          max = 10,
          step = 1
        ),
        tags$small("Typically 2-3 for visualization. Higher k reduces stress but complicates interpretation."),
        
        # Permutations
        numericInput(
          ns("permutations"),
          "Permutations (for stress test):",
          value = 999,
          min = 99,
          max = 9999,
          step = 100
        ),
        
        # Run button
        div(class = "action-buttons", style = "margin-top: 20px;",
          actionButton(
            ns("run_nmds"),
            "▶ Run NMDS",
            class = "btn-success",
            style = "width: 100%;"
          )
        )
      ),
      
      # Results Area (70% plot + 30% stats - horizontal split)
      div(class = "horizontal-split",
        # Plot Panel (70%)
        div(class = "plot-panel",
          # Stress interpretation box (auto-generated)
          uiOutput(ns("stress_interpretation")),
          
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
          
          # NMDS plot
          plotOutput(ns("nmds_plot"), height = "500px"),
          
          # Plot controls
          div(class = "plot-controls", style = "margin-top: 10px;",
            downloadButton(ns("export_plot"), "💾 Export Plot", class = "btn-sm")
          )
        ),
        
        # Results Panel (30%)
        div(class = "results-panel",
          # Ordination Statistics
          div(class = "results-section",
            h3("📊 ORDINATION STATISTICS"),
            tableOutput(ns("nmds_stats"))
          ),
          
          # PERMANOVA Results (if env data loaded)
          conditionalPanel(
            condition = sprintf("output['%s']", ns("has_env_data")),
            div(class = "results-section", style = "margin-top: 20px;",
              # PERMANOVA interpretation box
              uiOutput(ns("permanova_interpretation")),
              
              h3("🧪 PERMANOVA RESULTS"),
              tableOutput(ns("permanova_stats"))
            )
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

#' NMDS Module Server
#'
#' @param id Module namespace ID
#' @param data Reactive containing species abundance matrix
#' @param env_data Reactive containing environmental data (optional)
#' @return Server logic for NMDS analysis
#' @export
nmds_server <- function(id, data, env_data = reactive(NULL)) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Source utilities
    source("utils/validation.R", local = TRUE)
    source("utils/interpretation.R", local = TRUE)
    source("utils/reproducibility.R", local = TRUE)
    
    # Reactive values
    nmds_result <- reactiveVal(NULL)
    permanova_result <- reactiveVal(NULL)
    
    # Validate dimensions (k)
    observeEvent(input$k, {
      validation <- validateDimensions(input$k)
      
      if (validation$type == "error") {
        feedbackDanger("k", show = !validation$valid, text = validation$message)
      } else if (validation$type == "warning") {
        feedbackWarning("k", show = TRUE, text = validation$message)
      } else {
        feedbackSuccess("k", show = validation$valid, text = validation$message)
      }
    })
    
    # Validate permutations
    observeEvent(input$permutations, {
      validation <- validatePermutations(input$permutations)
      
      if (validation$type == "error") {
        feedbackDanger("permutations", show = !validation$valid, text = validation$message)
      } else if (validation$type == "warning") {
        feedbackWarning("permutations", show = TRUE, text = validation$message)
      } else {
        feedbackSuccess("permutations", show = validation$valid, text = validation$message)
      }
    })
    
    # Run NMDS Analysis
    observeEvent(input$run_nmds, {
      req(data())
      
      # Validate sample size
      sample_validation <- validateSampleSize(nrow(data()))
      if (!sample_validation$valid) {
        showNotification(sample_validation$message, type = "error", duration = 5)
        return()
      }
      
      # Show loading spinner
      waiter_show(html = tagList(
        spin_fading_circles(),
        h3("Running NMDS Analysis...", style = "color: #2e8b57; margin-top: 20px;")
      ))
      
      # Run NMDS
      result <- tryCatch({
        metaMDS(
          data(), 
          distance = input$distance,
          k = input$k,
          trymax = 20,
          autotransform = FALSE,
          trace = FALSE
        )
      }, error = function(e) {
        waiter_hide()
        showNotification(
          paste("❌ NMDS failed:", e$message), 
          type = "error", 
          duration = 10
        )
        NULL
      })
      
      waiter_hide()
      
      if (!is.null(result)) {
        nmds_result(result)
        
        # Interpret stress
        stress_interp <- interpretNMDSStress(result$stress)
        
        # Show success notification with stress interpretation
        showNotification(
          HTML(sprintf(
            "<strong>✓ NMDS Complete!</strong><br/>Stress = %.3f [%s]",
            result$stress,
            stress_interp$grade
          )),
          type = if(result$stress < 0.20) "message" else "warning",
          duration = 8
        )
        
        # Run PERMANOVA if env data available
        if (!is.null(env_data())) {
          permanova_res <- tryCatch({
            adonis2(data() ~ ., data = env_data(), permutations = input$permutations)
          }, error = function(e) {
            showNotification(paste("PERMANOVA failed:", e$message), type = "warning")
            NULL
          })
          
          if (!is.null(permanova_res)) {
            permanova_result(permanova_res)
          }
        }
      }
    })
    
    # Generate stress interpretation HTML
    output$stress_interpretation <- renderUI({
      req(nmds_result())
      generateStressInterpretationHTML(nmds_result()$stress)
    })
    
    # Render NMDS plot
    output$nmds_plot <- renderPlot({  
      req(nmds_result())
      
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
        # Force equal aspect ratio
        plot(nmds_result(), type = "none", main = "NMDS Ordination", font.main = 2)
        # Adjust plot region to be square
        usr <- par("usr")
        pin <- par("pin")
        if(pin[1] > pin[2]) {
          par(usr = c(mean(usr[1:2]) - diff(usr[3:4])/2, mean(usr[1:2]) + diff(usr[3:4])/2, usr[3:4]))
        } else {
          par(usr = c(usr[1:2], mean(usr[3:4]) - diff(usr[1:2])/2, mean(usr[3:4]) + diff(usr[1:2])/2))
        }
      } else {
        # Normal plot without forcing aspect ratio
        plot(nmds_result(), type = "none", main = "NMDS Ordination", font.main = 2)
      }
      
      # Add grid if enabled
      if(input$show_grid) {
        grid(col = grid_color, lty = 1)
      }
      
      # Add sample points with custom settings
      points(nmds_result(), 
             display = "sites", 
             pch = as.numeric(input$point_shape),
             bg = input$point_color, 
             cex = input$point_size,
             col = fg_color,
             lwd = input$point_lwd)
      
      # Add labels if enabled
      if(input$show_labels) {
        text(nmds_result(), 
             display = "sites",
             cex = input$label_size,
             pos = as.numeric(input$label_pos),
             col = fg_color)
      }
      
      # Add stress annotation
      stress_text <- sprintf("Stress = %.3f", nmds_result()$stress)
      stress_interp <- interpretNMDSStress(nmds_result()$stress)
      
      mtext(
        paste(stress_text, sprintf("[%s]", stress_interp$grade)),
        side = 3, 
        line = 0.5, 
        col = stress_interp$color,
        font = 2, 
        adj = 0,
        cex = input$base_size / 12
      )
    })
    
    # NMDS Statistics Table
    output$nmds_stats <- renderTable({
      req(nmds_result())
      
      stress_interp <- interpretNMDSStress(nmds_result()$stress)
      
      data.frame(
        Statistic = c(
          "Stress", 
          "Quality Grade",
          "Convergence", 
          "Dimensions", 
          "Distance",
          "Iterations"
        ),
        Value = c(
          sprintf("%.4f", nmds_result()$stress),
          stress_interp$grade,
          if(nmds_result()$converged) "✓ Converged" else "✗ Not converged",
          input$k,
          input$distance,
          nmds_result()$iters
        ),
        stringsAsFactors = FALSE
      )
    }, 
    striped = TRUE, 
    hover = TRUE,
    spacing = "s",
    width = "100%")
    
    # Check if env data exists
    output$has_env_data <- reactive({
      !is.null(env_data())
    })
    outputOptions(output, "has_env_data", suspendWhenHidden = FALSE)
    
    # PERMANOVA interpretation
    output$permanova_interpretation <- renderUI({
      req(permanova_result())
      
      perm_df <- as.data.frame(permanova_result())
      pValue <- perm_df$`Pr(>F)`[1]
      rSquared <- perm_df$R2[1]
      
      generatePERMANOVAInterpretationHTML(pValue, rSquared)
    })
    
    # PERMANOVA Statistics Table
    output$permanova_stats <- renderTable({
      req(permanova_result())
      
      perm_df <- as.data.frame(permanova_result())
      
      data.frame(
        Source = rownames(perm_df),
        Df = perm_df$Df,
        SumSqs = sprintf("%.3f", perm_df$SumOfSqs),
        R2 = sprintf("%.3f", perm_df$R2),
        F = sprintf("%.3f", perm_df$F),
        `Pr(>F)` = sprintf("%.4f", perm_df$`Pr(>F)`),
        check.names = FALSE,
        stringsAsFactors = FALSE
      )
    },
    striped = TRUE,
    hover = TRUE,
    spacing = "s",
    width = "100%")
    
    # Export plot with custom settings
    output$export_plot <- downloadHandler(
      filename = function() {
        ext <- input$export_format
        paste0("nmds_plot_k", input$k, "_", Sys.Date(), ".", ext)
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
          plot(nmds_result(), type = "none", main = "NMDS Ordination", font.main = 2)
          usr <- par("usr")
          pin <- par("pin")
          if(pin[1] > pin[2]) {
            par(usr = c(mean(usr[1:2]) - diff(usr[3:4])/2, mean(usr[1:2]) + diff(usr[3:4])/2, usr[3:4]))
          } else {
            par(usr = c(usr[1:2], mean(usr[3:4]) - diff(usr[1:2])/2, mean(usr[3:4]) + diff(usr[1:2])/2))
          }
        } else {
          plot(nmds_result(), type = "none", main = "NMDS Ordination", font.main = 2)
        }
        
        if(input$show_grid) grid(col = grid_color, lty = 1)
        points(nmds_result(), display = "sites", pch = as.numeric(input$point_shape),
               bg = input$point_color, cex = input$point_size, col = fg_color, lwd = input$point_lwd)
        if(input$show_labels) {
          text(nmds_result(), display = "sites", cex = input$label_size,
               pos = as.numeric(input$label_pos), col = fg_color)
        }
        
        stress_text <- sprintf("Stress = %.3f", nmds_result()$stress)
        stress_interp <- interpretNMDSStress(nmds_result()$stress)
        mtext(paste(stress_text, sprintf("[%s]", stress_interp$grade)), 
              side = 3, line = 0.5, col = stress_interp$color, font = 2, adj = 0,
              cex = input$base_size / 12)
        
        dev.off()
      }
    )
    
    # Export results as CSV
    output$export_results <- downloadHandler(
      filename = function() {
        paste0("nmds_results_", Sys.Date(), ".csv")
      },
      content = function(file) {
        req(nmds_result())
        
        # Extract site scores
        site_scores <- as.data.frame(scores(nmds_result(), display = "sites"))
        site_scores$Sample <- rownames(site_scores)
        
        write.csv(site_scores, file, row.names = FALSE)
      }
    )
    
    # Export report as PDF
    output$export_report <- downloadHandler(
      filename = function() {
        paste0("nmds_report_", Sys.Date(), ".pdf")
      },
      content = function(file) {
        req(nmds_result())
        
        # Show progress
        waiter_show(html = tagList(
          spin_fading_circles(),
          h3("Generating PDF Report...", style = "color: #2e8b57; margin-top: 20px;")
        ))
        
        tryCatch({
          # Check if pandoc is available
          pandoc_available <- rmarkdown::pandoc_available()
          
          if (!pandoc_available) {
            waiter_hide()
            showNotification(
              HTML("<strong>❌ Pandoc not found</strong><br/>Please install Pandoc from: <a href='https://pandoc.org/installing.html' target='_blank'>https://pandoc.org/installing.html</a><br/>See the help page for detailed instructions."),
              type = "error",
              duration = NULL
            )
            return()
          }
          
          # Verify pandoc version
          pandoc_version <- rmarkdown::pandoc_version()
          if (pandoc_version < "1.12.3") {
            waiter_hide()
            showNotification(
              HTML(paste0("<strong>⚠️ Pandoc version too old</strong><br/>Current: ", pandoc_version, "<br/>Required: ≥ 1.12.3<br/>Please update Pandoc.")),
              type = "error",
              duration = NULL
            )
            return()
          }
          
          # Check if tinytex is installed
          if (!tinytex::is_tinytex()) {
            waiter_hide()
            showNotification(
              HTML("<strong>⚠️ LaTeX not installed</strong><br/>TinyTeX is required for PDF generation.<br/>Run <code>tinytex::install_tinytex()</code> in R console."),
              type = "error",
              duration = NULL
            )
            return()
          }
          
          # Get stress interpretation
          stress_interp <- interpretNMDSStress(nmds_result()$stress)
          
          # Capture metadata using standardized utility
          metadata <- captureAnalysisMetadata(
            dataset_name = "Community Data",
            n_sites = nrow(data()),
            n_species = ncol(data()),
            analysis_type = "NMDS Ordination",
            analysis_params = list(
              distance = input$distance,
              k = input$k,
              permutations = input$permutations,
              trymax = 20,
              autotransform = FALSE
            ),
            result = nmds_result()
          )
          
          # Build analysis-specific parameters
          analysis_specific <- list(
            nmds_result = nmds_result(),
            stress_interp = stress_interp,
            distance = input$distance,
            k = input$k,
            permutations = input$permutations,
            trymax = 20,
            autotransform = FALSE
          )
          
          # Get complete report parameters
          params <- getReportParameters(metadata, analysis_specific)
          
          # Create temporary output file with .pdf extension
          temp_pdf <- tempfile(fileext = ".pdf")
          
          # Render the report to temp file
          rmarkdown::render(
            input = "templates/nmds_report.Rmd",
            output_format = "pdf_document",
            output_file = temp_pdf,
            params = params,
            envir = new.env(),
            quiet = FALSE
          )
          
          # Copy to download file
          file.copy(temp_pdf, file, overwrite = TRUE)
          
          # Clean up temp file
          if (file.exists(temp_pdf)) {
            unlink(temp_pdf)
          }
          
          waiter_hide()
          
          showNotification(
            HTML("<strong>✓ PDF report generated successfully!</strong><br/>The file is ready for download."),
            type = "message",
            duration = 5
          )
          
        }, error = function(e) {
          waiter_hide()
          
          # Provide detailed error information
          error_msg <- conditionMessage(e)
          
          if (grepl("pandoc", error_msg, ignore.case = TRUE)) {
            showNotification(
              HTML(paste0(
                "<strong>❌ Pandoc Error</strong><br/>",
                "Error: ", error_msg, "<br/><br/>",
                "<strong>Solution:</strong><br/>",
                "1. Install Pandoc: <a href='https://pandoc.org/installing.html' target='_blank'>Download here</a><br/>",
                "2. Restart R session after installation<br/>",
                "3. Try generating the report again"
              )),
              type = "error",
              duration = NULL
            )
          } else if (grepl("latex|tlmgr|xelatex|pdflatex", error_msg, ignore.case = TRUE)) {
            showNotification(
              HTML(paste0(
                "<strong>❌ LaTeX Error</strong><br/>",
                "Error: ", error_msg, "<br/><br/>",
                "<strong>Solution:</strong><br/>",
                "Run in R console: <code>tinytex::install_tinytex()</code><br/>",
                "This installs a minimal LaTeX distribution."
              )),
              type = "error",
              duration = NULL
            )
          } else {
            showNotification(
              HTML(paste0(
                "<strong>❌ Error generating PDF</strong><br/>",
                "Error: ", error_msg, "<br/><br/>",
                "Check the R console for detailed error messages."
              )),
              type = "error",
              duration = 10
            )
          }
        })
      },
      contentType = "application/pdf"
    )
  })
}
