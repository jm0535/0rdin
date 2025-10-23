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
    uiOutput("dataFormatDetected"),
    hr(),
    selectInput("dataType", "Data Type",
                choices = c(
                  "Abundance - Individual counts" = "abundance",
                  "Incidence_raw - Presence/absence (0/1)" = "incidence_raw",
                  "Incidence_freq - Sampling units (SamplingUnits column)" = "incidence_freq"
                )),
    div(style = "background-color: #1a1a1a; padding: 12px; border-radius: 5px; margin-bottom: 15px; border: 1px solid #333;",
      tags$div(
        style = "margin-bottom: 8px;",
        tags$strong(style = "color: #2e8b57;", "📊 Abundance:"),
        tags$span(style = "margin-left: 5px;", "Individual counts (0, 1, 2, 3, ...)")
      ),
      tags$div(
        style = "margin-bottom: 8px;",
        tags$strong(style = "color: #ff8c00;", "✓ Incidence_raw:"),
        tags$span(style = "margin-left: 5px;", "Binary presence/absence (0 or 1 only)")
      ),
      tags$div(
        style = "margin-bottom: 10px;",
        tags$strong(style = "color: #4169e1;", "🔢 Incidence_freq:"),
        tags$span(style = "margin-left: 5px;", "Sampling units (needs SamplingUnits column)")
      ),
      tags$hr(style = "margin: 8px 0; border-color: #444;"),
      tags$div(
        style = "font-style: italic; color: #aaa; font-size: 0.9em;",
        "→ Format auto-detected from your data structure"
      )
    ),
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
      helpText("Default: 0.95 (95% CI)"),
      numericInput("endpoint", "Extrapolation Endpoint",
                   value = NULL, min = 1, step = 1),
      helpText("Leave blank for auto (2× reference sample). Set to a specific number of individuals/sampling units to compare sites at same extrapolation level.")
    ),
    conditionalPanel(
      condition = "input.analysisType == 'Ordination (NMDS via vegan)'",
      numericInput("nmdsDimensions", "NMDS Dimensions", value = 2, min = 1, max = 5)
    ),
    actionButton("runAnalysis", "Run Analysis", class = "btn-primary btn-lg")
  ),
  card(
    full_screen = TRUE,
    fill = TRUE,
    card_header("Analysis Results"),
    uiOutput("mainContent")
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
      
      # DETECT DATA FORMAT
      # Check if second column is named "SamplingUnits" (incidence_freq format)
      has_sampling_units <- ncol(df) >= 2 && tolower(names(df)[2]) == "samplingunits"
      
      if (has_sampling_units) {
        # INCIDENCE_FREQ FORMAT (like ant data)
        # Format: Site, SamplingUnits, Species_1, Species_2, ...
        # iNEXT needs: list of vectors, first element = # sampling units
        
        site_names <- df[[1]]
        sampling_units <- df[[2]]
        species_data <- df[, -c(1, 2)]
        
        # Check all numeric
        validate(
          need(all(sapply(species_data, is.numeric)), "All species columns must be numeric.")
        )
        
        # Create list format for iNEXT incidence_freq
        # Each site is a vector: c(sampling_units, species_counts...)
        inext_list <- lapply(1:nrow(df), function(i) {
          c(sampling_units[i], as.numeric(species_data[i, ]))
        })
        names(inext_list) <- site_names
        
        # For NMDS, use species matrix only (sites as rows)
        abund_matrix <- as.matrix(species_data)
        rownames(abund_matrix) <- site_names
        
        list(
          original = abund_matrix,           # For NMDS (sites as rows)
          inext_data = inext_list,           # For iNEXT incidence_freq
          data_format = "incidence_freq",
          sampling_units = sampling_units
        )
        
      } else {
        # STANDARD FORMAT (abundance or incidence_raw)
        # Format: Site, Species_1, Species_2, ...
        
        site_names <- df[[1]]
        abund_matrix <- as.matrix(df[-1])
        rownames(abund_matrix) <- site_names
        
        # Check if data is numeric
        validate(
          need(all(sapply(df[-1], is.numeric)), "All abundance columns (except first) must be numeric.")
        )
        
        # Auto-detect if incidence_raw (all 0s and 1s)
        is_binary <- all(abund_matrix %in% c(0, 1))
        
        # DIAGNOSTIC: Show data structure info
        cat("\n=== ÖRDIN DATA LOADING ===")
        cat("\nFile loaded:", input$dataFile$name)
        cat("\nRows (sites):", nrow(abund_matrix))
        cat("\nColumns (species):", ncol(abund_matrix))
        cat("\nIs binary (0/1 only):", is_binary)
        cat("\nSample of first 5 values:", paste(head(as.vector(abund_matrix), 5), collapse=", "))
        cat("\nRow totals:", paste(rowSums(abund_matrix), collapse=", "))
        cat("\n============================\n")
        
        # For iNEXT, transpose the matrix so each column is a site (assemblage)
        # iNEXT expects: columns = assemblages, rows = species
        abund_matrix_t <- t(abund_matrix)
        colnames(abund_matrix_t) <- site_names
        
        list(
          original = abund_matrix,        # For NMDS (sites as rows)
          transposed = abund_matrix_t,    # For iNEXT (sites as columns)
          inext_data = abund_matrix_t,    # For iNEXT (abundance or incidence_raw)
          data_format = if(is_binary) "incidence_raw" else "abundance",
          is_binary = is_binary
        )
      }
    }, error = function(e) {
      validate(need(FALSE, paste("Error reading CSV:", e$message)))
    })
  })
  
  # Store analysis results
  results <- reactiveVal(NULL)
  
  # Main content switcher - Welcome page OR Results
  output$mainContent <- renderUI({
    if (is.null(results())) {
      # WELCOME PAGE - No results yet
      tags$div(
        class = "welcome-container",
        style = "display: flex; align-items: center; justify-content: center; min-height: 500px; padding: 80px 40px 60px 40px;",
        tags$div(
          style = "max-width: 800px; text-align: center;",
          # Ö Logo
          tags$div(
            style = "font-size: 5em; color: #2e8b57; margin-bottom: 20px; font-weight: bold; text-shadow: 0 4px 8px rgba(46, 139, 87, 0.3); line-height: 1.2;",
            "Ö"
          ),
          # Welcome Title
          tags$h2(
            style = "color: #2e8b57; margin-bottom: 20px; font-size: 2.2em; font-weight: 600;",
            "Welcome to Ördin"
          ),
          # Subtitle
          tags$p(
            style = "color: #aaa; font-size: 1.2em; margin-bottom: 40px; line-height: 1.6;",
            "Professional biodiversity analysis platform powered by ",
            tags$strong(style = "color: #2e8b57;", "iNEXT"),
            " and ",
            tags$strong(style = "color: #2e8b57;", "vegan"),
            " packages."
          ),
          # Workflow Steps
          tags$div(
            style = "display: flex; justify-content: center; gap: 40px; margin: 50px 0;",
            # Step 1
            tags$div(
              style = "flex: 1; max-width: 200px;",
              tags$div(
                style = "width: 80px; height: 80px; margin: 0 auto 15px; background: linear-gradient(135deg, #2e8b57 0%, #236b42 100%); border-radius: 50%; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 12px rgba(46, 139, 87, 0.4);",
                tags$span(style = "font-size: 2.5em; color: white;", "📁")
              ),
              tags$div(
                style = "font-weight: 600; color: #2e8b57; margin-bottom: 8px; font-size: 1.1em;",
                "1. Upload Data"
              ),
              tags$div(
                style = "color: #888; font-size: 0.9em; line-height: 1.4;",
                "Select your CSV file with species data"
              )
            ),
            # Arrow
            tags$div(
              style = "display: flex; align-items: center; color: #444; font-size: 2em; margin-top: 30px;",
              "→"
            ),
            # Step 2
            tags$div(
              style = "flex: 1; max-width: 200px;",
              tags$div(
                style = "width: 80px; height: 80px; margin: 0 auto 15px; background: linear-gradient(135deg, #2e8b57 0%, #236b42 100%); border-radius: 50%; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 12px rgba(46, 139, 87, 0.4);",
                tags$span(style = "font-size: 2.5em; color: white;", "⚙️")
              ),
              tags$div(
                style = "font-weight: 600; color: #2e8b57; margin-bottom: 8px; font-size: 1.1em;",
                "2. Configure"
              ),
              tags$div(
                style = "color: #888; font-size: 0.9em; line-height: 1.4;",
                "Choose analysis type and parameters"
              )
            ),
            # Arrow
            tags$div(
              style = "display: flex; align-items: center; color: #444; font-size: 2em; margin-top: 30px;",
              "→"
            ),
            # Step 3
            tags$div(
              style = "flex: 1; max-width: 200px;",
              tags$div(
                style = "width: 80px; height: 80px; margin: 0 auto 15px; background: linear-gradient(135deg, #2e8b57 0%, #236b42 100%); border-radius: 50%; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 12px rgba(46, 139, 87, 0.4);",
                tags$span(style = "font-size: 2.5em; color: white;", "📊")
              ),
              tags$div(
                style = "font-weight: 600; color: #2e8b57; margin-bottom: 8px; font-size: 1.1em;",
                "3. Analyze"
              ),
              tags$div(
                style = "color: #888; font-size: 0.9em; line-height: 1.4;",
                "View results and export publication-quality plots"
              )
            )
          ),
          # Divider
          tags$hr(style = "border: none; border-top: 1px solid #333; margin: 50px 0;"),
          # Features
          tags$div(
            style = "display: grid; grid-template-columns: repeat(2, 1fr); gap: 25px; text-align: left; margin-top: 40px;",
            # Feature 1
            tags$div(
              style = "padding: 20px; background: linear-gradient(135deg, #1a1a1a 0%, #252525 100%); border-radius: 8px; border: 1px solid #333;",
              tags$div(
                style = "color: #2e8b57; font-size: 1.3em; margin-bottom: 8px;",
                "✨ Auto-Detection"
              ),
              tags$div(
                style = "color: #aaa; font-size: 0.95em;",
                "Automatically detects data format (abundance, incidence_raw, incidence_freq)"
              )
            ),
            # Feature 2
            tags$div(
              style = "padding: 20px; background: linear-gradient(135deg, #1a1a1a 0%, #252525 100%); border-radius: 8px; border: 1px solid #333;",
              tags$div(
                style = "color: #2e8b57; font-size: 1.3em; margin-bottom: 8px;",
                "📈 Advanced Analysis"
              ),
              tags$div(
                style = "color: #aaa; font-size: 0.95em;",
                "iNEXT rarefaction/extrapolation and vegan NMDS ordination"
              )
            ),
            # Feature 3
            tags$div(
              style = "padding: 20px; background: linear-gradient(135deg, #1a1a1a 0%, #252525 100%); border-radius: 8px; border: 1px solid #333;",
              tags$div(
                style = "color: #2e8b57; font-size: 1.3em; margin-bottom: 8px;",
                "🎨 Publication Quality"
              ),
              tags$div(
                style = "color: #aaa; font-size: 0.95em;",
                "Export plots in PNG, TIFF, JPEG, SVG, or PostScript at 300 DPI"
              )
            ),
            # Feature 4
            tags$div(
              style = "padding: 20px; background: linear-gradient(135deg, #1a1a1a 0%, #252525 100%); border-radius: 8px; border: 1px solid #333;",
              tags$div(
                style = "color: #2e8b57; font-size: 1.3em; margin-bottom: 8px;",
                "⚡ Professional UI"
              ),
              tags$div(
                style = "color: #aaa; font-size: 0.95em;",
                "Modern, enterprise-grade interface with dark theme"
              )
            )
          ),
          # Footer
          tags$div(
            style = "margin-top: 50px; padding-top: 30px; border-top: 1px solid #333; color: #666; font-size: 0.9em;",
            tags$div(
              "Built with ",
              tags$span(style = "color: #2e8b57;", "R Shiny"),
              " • Powered by ",
              tags$span(style = "color: #2e8b57;", "iNEXT & vegan")
            ),
            tags$div(
              style = "margin-top: 8px;",
              "Version 1.0 • ",
              tags$span(style = "color: #888;", "Inspired by Odin's wisdom")
            )
          )
        )
      )
    } else {
      # RESULTS PAGE - Analysis complete
      res <- results()
      
      cat("\n=== RENDERING RESULTS UI ===")
      cat("\nResults type:", res$type)
      cat("\nSummary rows:", nrow(res$summary))
      cat("\n===========================\n")
      
      tagList(
        tags$div(
          style = "padding: 20px;",
          tags$h4(
            style = "color: #2e8b57; border-bottom: 2px solid #2e8b57; padding-bottom: 10px; margin-bottom: 20px;",
            "📊 Summary Table"
          ),
          DTOutput("summaryTable"),
          if (!is.null(res$stress)) {
            div(
              class = "alert alert-info mt-3",
              style = "background-color: #1a3a52; border-color: #2e8b57; color: #fff;",
              h5(paste("🎯 NMDS Stress:", round(res$stress, 3))),
              p(ifelse(res$stress < 0.05, "✅ Excellent representation",
                      ifelse(res$stress < 0.1, "✅ Good representation",
                            ifelse(res$stress < 0.2, "⚠️ Acceptable representation",
                                  "❌ Poor representation - consider fewer dimensions"))))
            )
          },
          tags$h4(
            style = "color: #2e8b57; border-bottom: 2px solid #2e8b57; padding-bottom: 10px; margin: 30px 0 15px 0;",
            "📊 Visualization"
          ),
          div(
            style = "display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; padding: 15px; background-color: #1a1a1a; border-radius: 8px; border: 1px solid #333;",
            tags$div(
              style = "display: flex; align-items: center; gap: 10px; color: #aaa; font-weight: 500;",
              tags$span(style = "font-size: 1.1em;", "💾"),
              "Export Format:"
            ),
            div(
              style = "display: flex; gap: 12px; align-items: center;",
              selectInput(
                "plotFormat", 
                NULL,
                choices = c("PNG" = "png", 
                            "TIFF" = "tiff", 
                            "JPEG" = "jpeg", 
                            "SVG" = "svg", 
                            "PostScript" = "ps"),
                selected = "png",
                width = "150px"
              ),
              downloadButton("downloadPlot", "Download Plot", class = "btn-success", style = "height: 38px; padding: 6px 20px; font-weight: 500;")
            )
          ),
          plotOutput("analysisPlot", height = "650px")
        )
      )
    }
  })
  
  # Display detected data format
  output$dataFormatDetected <- renderUI({
    req(data())
    
    data_format <- data()$data_format
    
    # Format-specific icons and descriptions
    format_info <- if (data_format == "abundance") {
      list(
        icon = "📊",
        name = "Abundance",
        desc = "Individual counts (0, 1, 2, 3, ...)",
        color = "#2e8b57"
      )
    } else if (data_format == "incidence_raw") {
      list(
        icon = "✓",
        name = "Incidence_raw",
        desc = "Presence/absence (binary: 0, 1)",
        color = "#ff8c00"
      )
    } else {
      list(
        icon = "🔢",
        name = "Incidence_freq",
        desc = paste0("Sampling units: ", paste(data()$sampling_units, collapse=", ")),
        color = "#4169e1"
      )
    }
    
    div(
      style = paste0("background-color: ", format_info$color, "22; border-left: 4px solid ", format_info$color, "; padding: 10px; margin-top: 10px; border-radius: 3px;"),
      tags$strong(format_info$icon, " Detected: ", format_info$name),
      tags$br(),
      tags$small(format_info$desc)
    )
  })
  
  # Auto-update data type selection based on detection
  observeEvent(data(), {
    req(data())
    
    detected_format <- data()$data_format
    
    # Update the selectInput to match detected format
    updateSelectInput(session, "dataType", selected = detected_format)
    
    # Show notification about auto-selection
    showNotification(
      paste0("✓ Auto-selected: ", 
             if(detected_format == "abundance") "Abundance - Individual counts"
             else if(detected_format == "incidence_raw") "Incidence_raw - Presence/absence (0/1)"
             else "Incidence_freq - Sampling units (SamplingUnits column)"),
      type = "message",
      duration = 4
    )
  })
  
  # Run analysis when button is clicked
  observeEvent(input$runAnalysis, {
    req(data())
    
    withProgress(message = 'Running analysis...', value = 0, {
      if (input$analysisType == "Diversity Estimation (iNEXT)") {
        incProgress(0.1, detail = "Validating data...")
        
        # Get data format info
        data_format <- data()$data_format
        inext_data <- data()$inext_data
        
        # Determine iNEXT datatype based on user selection and auto-detection
        user_datatype <- input$dataType
        
        # Priority: Auto-detected format > User selection
        # But warn if mismatch
        if (data_format == "incidence_freq") {
          actual_datatype <- "incidence_freq"
          
          # Warn if user selected something else
          if (user_datatype != "incidence_freq") {
            showNotification(
              "Auto-detected incidence_freq format (SamplingUnits column found). Overriding user selection.",
              type = "warning",
              duration = 5
            )
          }
          
          # Show info about sampling units
          sampling_units <- data()$sampling_units
          message("Detected incidence_freq data with sampling units: ", 
                  paste(sampling_units, collapse=", "))
          
        } else if (data_format == "incidence_raw") {
          actual_datatype <- "incidence_raw"
          
          # Warn if user selected abundance or incidence_freq
          if (user_datatype == "abundance") {
            showNotification(
              "Auto-detected binary data (0/1). Using incidence_raw format instead of abundance.",
              type = "warning",
              duration = 5
            )
          } else if (user_datatype == "incidence_freq") {
            showNotification(
              "No SamplingUnits column found. Using incidence_raw (binary 0/1) instead of incidence_freq.",
              type = "warning",
              duration = 5
            )
          }
          
        } else {
          # Abundance data detected
          actual_datatype <- "abundance"
          
          # Warn if user selected incidence format
          if (user_datatype %in% c("incidence_raw", "incidence_freq")) {
            showNotification(
              paste0("Data is not binary (has counts >1). Using abundance format instead of ", user_datatype, "."),
              type = "warning",
              duration = 5
            )
          }
        }
        
        # DATA VALIDATION
        if (data_format == "incidence_freq") {
          # Start progress indicator for validation
          incProgress(0.1, detail = "Validating data...")
          
          # For incidence_freq, validate differently
          num_sites <- length(inext_data)
          min_sampling_units <- min(sapply(inext_data, function(x) x[1]))
          
          validate(
            need(num_sites >= 2, "Need at least 2 sites for analysis."),
            need(min_sampling_units >= 3, 
                 paste0("Insufficient sampling units: minimum = ", min_sampling_units, 
                       ". Need at least 3 sampling units per site."))
          )
          
        } else {
          # Start progress indicator for validation
          incProgress(0.1, detail = "Validating data...")
          
          # For abundance/incidence_raw, validate as before
          site_totals <- colSums(inext_data)
          min_sample_size <- min(site_totals)
          species_present <- sum(rowSums(inext_data) > 0)
          
          # DIAGNOSTIC OUTPUT - Show what we detected
          cat("\n=== ÖRDIN DATA DIAGNOSTICS ===")
          cat("\nData format detected:", data_format)
          cat("\nActual datatype for iNEXT:", actual_datatype)
          cat("\nNumber of sites:", ncol(inext_data))
          cat("\nNumber of species:", nrow(inext_data))
          cat("\nTotal per site:", paste(site_totals, collapse=", "))
          cat("\nMin sample size:", min_sample_size)
          cat("\nSpecies with >0:", species_present)
          cat("\nData sparsity:", round(sum(inext_data == 0) / length(inext_data) * 100, 1), "%")
          cat("\n============================\n")
          
          # Update progress after diagnostics
          incProgress(0.05, detail = "Checking data quality...")
          
          # Show user-friendly notification with diagnostics
          showNotification(
            paste0(
              "Data loaded: ", ncol(inext_data), " sites, ", nrow(inext_data), " species\n",
              "Format: ", data_format, " | Min occurrences: ", min_sample_size, " | Species present: ", species_present
            ),
            type = "message",
            duration = 8
          )
          
          # Update progress before validation
          incProgress(0.05, detail = "Validating requirements...")
          
          # Adjust validation for incidence_raw (binary data)
          min_required <- if (actual_datatype == "incidence_raw") 3 else 5
          
          validate(
            need(min_sample_size >= min_required, 
                 paste0("Insufficient data: At least one site has only ", min_sample_size, 
                       " ", if(actual_datatype == "incidence_raw") "occurrences" else "individuals", 
                       ". Need at least ", min_required, " per site.\n\n",
                       "Your data: ", ncol(inext_data), " sites, ", nrow(inext_data), " species\n",
                       "Totals per site: ", paste(site_totals, collapse=", "))),
            need(species_present >= 3,
                 paste0("Insufficient diversity: Only ", species_present, 
                       " species detected. Need at least 3 species.\n\n",
                       "Your data has ", nrow(inext_data), " species columns, but only ", 
                       species_present, " have at least one occurrence."))
          )
        }
        
        incProgress(0.3, detail = "Calculating diversity indices...")
        
        # Get selected Hill numbers
        selected_q <- as.numeric(input$hillNumbers)
        if (length(selected_q) == 0) selected_q <- c(0, 1, 2)
        
        # Get endpoint parameter (extrapolation cutoff)
        # If NULL, iNEXT uses default (double reference sample)
        # If set, all curves extrapolate to this common endpoint
        endpoint_value <- if (is.null(input$endpoint) || is.na(input$endpoint)) {
          NULL  # Auto: 2x reference sample
        } else {
          input$endpoint
        }
        
        # Run iNEXT analysis with correct datatype
        inext_out <- tryCatch({
          iNEXT(
            x = inext_data, 
            q = selected_q, 
            datatype = actual_datatype,
            knots = input$knots,
            nboot = input$nboot,
            conf = input$conf,
            endpoint = endpoint_value  # NULL = auto, or specific value
          )
        }, error = function(e) {
          # Provide helpful error message
          validate(need(FALSE, paste0(
            "iNEXT analysis failed: ", e$message, 
            "\n\nData format: ", data_format,
            "\nDatatype used: ", actual_datatype,
            "\n\nTry: (1) Check data format, (2) Reduce knots/nboot, (3) Select correct data type"
          )))
        })
        
        incProgress(0.6, detail = "Generating plots...")
        
        # Extract summary
        summary_df <- inext_out$AsyEst
        
        # Determine plot type from input
        plot_type_num <- as.numeric(input$plotType)
        
        # Create plot title based on actual datatype and plot type
        rarefaction_type <- if (actual_datatype == "abundance") {
          "Individual-based"
        } else if (actual_datatype == "incidence_freq") {
          "Incidence-based (frequency)"
        } else {
          "Incidence-based (raw)"
        }
        
        plot_type_label <- c(
          "1" = "Sample-size-based R/E",
          "2" = "Sample Completeness",
          "3" = "Coverage-based R/E"
        )[input$plotType]
        
        plot_title <- paste0("Ördin: ", rarefaction_type, " Rarefaction (", plot_type_label, ")")
        
        # Get site names for subtitle
        if (data_format == "incidence_freq") {
          site_list <- paste(names(inext_data), collapse = ", ")
        } else {
          site_list <- paste(colnames(inext_data), collapse = ", ")
        }
        
        # Build subtitle with endpoint info
        endpoint_text <- if (is.null(endpoint_value)) {
          "auto (2× reference)"
        } else {
          paste0(endpoint_value, " ", if(actual_datatype == "abundance") "individuals" else "sampling units")
        }
        
        # Create plot with shaded confidence intervals
        # Use ggiNEXT directly - it's designed to work properly
        plot_obj <- ggiNEXT(
          x = inext_out, 
          type = plot_type_num,
          se = TRUE,                  # Shaded confidence intervals
          facet.var = "Order.q",      # Separate panels for q=0, 1, 2
          color.var = "Assemblage"    # Color by site
        ) + 
          labs(
            title = plot_title,
            subtitle = paste0(
              "Sites: ", site_list,
              " | Hill numbers q=", paste(selected_q, collapse = ", "),
              " | ", input$conf * 100, "% CI (nboot=", input$nboot, ")",
              " | Format: ", data_format,
              " | Endpoint: ", endpoint_text
            )
          ) +
          theme_bw(base_size = 14) +
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
    
    cat("\n=== RENDERING RESULTS UI ===")
    cat("\nResults type:", res$type)
    cat("\nSummary rows:", nrow(res$summary))
    cat("\n===========================\n")
    
    tagList(
      tags$div(
        style = "padding: 20px;",
        tags$h4(
          style = "color: #2e8b57; border-bottom: 2px solid #2e8b57; padding-bottom: 10px; margin-bottom: 20px;",
          "📊 Summary Table"
        ),
        DTOutput("summaryTable"),
        if (!is.null(res$stress)) {
          div(
            class = "alert alert-info mt-3",
            style = "background-color: #1a3a52; border-color: #2e8b57; color: #fff;",
            h5(paste("🎯 NMDS Stress:", round(res$stress, 3))),
            p(ifelse(res$stress < 0.05, "✅ Excellent representation",
                    ifelse(res$stress < 0.1, "✅ Good representation",
                          ifelse(res$stress < 0.2, "⚠️ Acceptable representation",
                                "❌ Poor representation - consider fewer dimensions"))))
          )
        },
        tags$h4(
          style = "color: #2e8b57; border-bottom: 2px solid #2e8b57; padding-bottom: 10px; margin: 30px 0 15px 0;",
          "📊 Visualization"
        ),
        div(
          style = "display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; padding: 10px; background-color: #1a1a1a; border-radius: 5px;",
          tags$div(
            style = "color: #aaa;",
            "💾 Export Format:"
          ),
          div(
            style = "display: flex; gap: 10px; align-items: center;",
            selectInput(
              "plotFormat", 
              NULL,
              choices = c("PNG" = "png", 
                          "TIFF" = "tiff", 
                          "JPEG" = "jpeg", 
                          "SVG" = "svg", 
                          "PostScript" = "ps"),
              selected = "png",
              width = "140px"
            ),
            downloadButton("downloadPlot", "⬇️ Download Plot", class = "btn-success btn-sm")
          )
        ),
        plotOutput("analysisPlot", height = "650px")
      )
    )
  })
  
  # Render summary table
  output$summaryTable <- renderDT({
    req(results())
    
    cat("\n=== RENDERING SUMMARY TABLE ===")
    cat("\nRows:", nrow(results()$summary))
    cat("\nColumns:", ncol(results()$summary))
    cat("\n==============================\n")
    
    datatable(
      results()$summary, 
      options = list(
        pageLength = 15,
        scrollX = TRUE,
        dom = 'Bfrtip',
        buttons = c('copy', 'csv', 'excel'),
        class = 'cell-border stripe',
        columnDefs = list(
          list(className = 'dt-center', targets = '_all')
        )
      ), 
      extensions = 'Buttons',
      rownames = FALSE,
      class = 'display'
    ) %>%
      formatRound(columns = 2:ncol(results()$summary), digits = 4)
  })
  
  # Render plot
  output$analysisPlot <- renderPlot({
    req(results())
    
    cat("\n=== RENDERING PLOT ===")
    cat("\nPlot type:", class(results()$plot)[1])
    cat("\n===================\n")
    
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
      req(results())
      format <- input$plotFormat
      paste0("ordin_", tolower(results()$type), "_plot_", Sys.Date(), ".", format)
    },
    content = function(file) {
      req(results())
      format <- input$plotFormat
      
      # Publication-quality settings for each format
      if (format %in% c("png", "tiff", "jpeg")) {
        # Raster formats: 300 DPI for publication quality
        ggsave(
          file, 
          plot = results()$plot, 
          device = format,
          width = 12, 
          height = 8, 
          dpi = 300,
          bg = "#222222",
          units = "in"
        )
      } else if (format == "svg") {
        # Vector format: SVG (scalable, no DPI needed)
        ggsave(
          file, 
          plot = results()$plot, 
          device = "svg",
          width = 12, 
          height = 8,
          bg = "#222222",
          units = "in"
        )
      } else if (format == "ps") {
        # Vector format: PostScript (publication standard)
        ggsave(
          file, 
          plot = results()$plot, 
          device = "ps",
          width = 12, 
          height = 8,
          bg = "#222222",
          units = "in",
          # PostScript-specific options
          family = "Helvetica",
          paper = "special"
        )
      }
    }
  )
}

shinyApp(ui, server)
