# Ördin v2.2 - Modular Biodiversity Analysis Application
# Complete implementation with all modules

library(bslib)
library(vegan)
library(iNEXT)
library(ggplot2)
library(DT)
library(readr)
library(dplyr)
library(tidyr)

# UI Definition
ui <- page_navbar(
  theme = bs_theme(
    version = 5, 
    bootswatch = "darkly",
    primary = "#2e8b57",
    "font-scale" = 1.1
  ),
  title = "Ördin v2.2",
  id = "main_nav",
  
  # TAB 1: DIVERSITY ESTIMATION (iNEXT)
  nav_panel(
    title = "📊 Diversity Estimation",
    icon = icon("chart-line"),
    layout_sidebar(
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
        selectInput("plotType", "Rarefaction Plot Type",
                    choices = c(
                      "Sample-size-based (Type 1)" = "1",
                      "Sample completeness (Type 2)" = "2",
                      "Coverage-based (Type 3)" = "3"
                    )),
        hr(),
        h5("iNEXT Advanced Options"),
        checkboxGroupInput("hillNumbers", "Hill Numbers",
                           choices = c("q=0 (Richness)" = "0",
                                     "q=1 (Shannon)" = "1",
                                     "q=2 (Simpson)" = "2"),
                           selected = c("0", "1", "2")),
        numericInput("knots", "Knots", value = 40, min = 10, max = 200, step = 10),
        numericInput("nboot", "Bootstrap Reps", value = 50, min = 10, max = 500, step = 10),
        numericInput("conf", "Confidence Level", value = 0.95, min = 0.80, max = 0.99, step = 0.01),
        numericInput("endpoint", "Extrapolation Endpoint", value = NULL, min = 1, step = 1),
        actionButton("runDiversity", "Run Analysis", class = "btn-primary btn-lg", style = "width: 100%;")
      ),
      card(full_screen = TRUE, card_header("Diversity Estimation Results"), uiOutput("diversityContent"))
    )
  ),
  
  # TAB 2: ORDINATION ANALYSIS
  nav_panel(
    title = "🗺️ Ordination",
    icon = icon("project-diagram"),
    layout_sidebar(
      sidebar = sidebar(
        width = 350,
        h4("Ordination Analysis"),
        helpText("Upload data in Diversity tab first"),
        hr(),
        selectInput("ordinationMethod", "Method",
                    choices = c(
                      "NMDS - Non-metric MDS" = "nmds",
                      "PCA - Principal Components" = "pca",
                      "CA - Correspondence Analysis" = "ca",
                      "DCA - Detrended CA" = "dca",
                      "PCoA - Principal Coordinates" = "pcoa"
                    )),
        numericInput("ordDimensions", "Dimensions", value = 2, min = 1, max = 5),
        selectInput("distMethod", "Distance Method",
                    choices = c(
                      "Bray-Curtis" = "bray",
                      "Jaccard" = "jaccard",
                      "Euclidean" = "euclidean",
                      "Manhattan" = "manhattan",
                      "Canberra" = "canberra"
                    )),
        actionButton("runOrdination", "Run Ordination", class = "btn-primary btn-lg", style = "width: 100%;")
      ),
      card(full_screen = TRUE, card_header("Ordination Results"), uiOutput("ordinationContent"))
    )
  ),
  
  # TAB 3: DIVERSITY INDICES
  nav_panel(
    title = "📈 Diversity Indices",
    icon = icon("calculator"),
    layout_sidebar(
      sidebar = sidebar(
        width = 350,
        h4("Diversity Indices"),
        helpText("Upload data in Diversity tab first"),
        hr(),
        h5("Alpha Diversity"),
        checkboxGroupInput("alphaIndices", "Calculate:",
                           choices = c(
                             "Shannon (H')" = "shannon",
                             "Simpson (1-D)" = "simpson",
                             "Inv. Simpson (1/D)" = "invsimpson",
                             "Fisher's Alpha" = "fisher",
                             "Richness (S)" = "richness"
                           ),
                           selected = c("shannon", "simpson", "richness")),
        hr(),
        h5("Evenness"),
        checkboxGroupInput("evennessIndices", "Calculate:",
                           choices = c(
                             "Pielou's J'" = "pielou",
                             "Simpson's E" = "simpsone",
                             "Evar" = "evar"
                           ),
                           selected = c("pielou")),
        hr(),
        h5("Rarefaction"),
        numericInput("rarefyN", "Rarefy to N individuals", value = NULL, min = 1, step = 1),
        helpText("Leave blank for minimum sample size"),
        hr(),
        h5("Species Accumulation"),
        checkboxInput("calcAccum", "Calculate Accumulation Curve", value = FALSE),
        numericInput("accumPerms", "Permutations", value = 100, min = 10, max = 1000, step = 10),
        actionButton("runIndices", "Calculate Indices", class = "btn-primary btn-lg", style = "width: 100%;")
      ),
      card(full_screen = TRUE, card_header("Diversity Indices Results"), uiOutput("indicesContent"))
    )
  ),
  
  # TAB 4: HELP
  nav_panel(
    title = "ℹ️ Help",
    icon = icon("info-circle"),
    card(
      card_header("Ördin v2.2 - User Guide"),
      tags$div(
        style = "padding: 30px;",
        tags$div(style = "text-align: center; margin-bottom: 40px;",
                tags$div(style = "font-size: 4em; color: #2e8b57; margin-bottom: 15px;", "Ö"),
                tags$h2("Ördin v2.2"),
                tags$p(style = "font-size: 1.2em; color: #aaa;", "Comprehensive biodiversity analysis")),
        tags$h3("Modules", style = "color: #2e8b57;"),
        tags$ul(
          tags$li(tags$strong("📊 Diversity Estimation:"), " iNEXT rarefaction/extrapolation"),
          tags$li(tags$strong("🗺️ Ordination:"), " 5 ordination methods (NMDS, PCA, CA, DCA, PCoA)"),
          tags$li(tags$strong("📈 Diversity Indices:"), " Shannon, Simpson, evenness, accumulation curves")
        ),
        tags$hr(),
        tags$p("Built with R Shiny + iNEXT + vegan | v2.2.0 | © 2025 Jimmy Moses")
      )
    )
  )
)

# Server Logic
server <- function(input, output, session) {
  
  # Shared data loading
  data <- reactive({
    req(input$dataFile)
    df <- read_csv(input$dataFile$datapath, show_col_types = FALSE)
    validate(need(ncol(df) > 1, "CSV must have at least 2 columns"))
    
    has_sampling_units <- ncol(df) >= 2 && tolower(names(df)[2]) == "samplingunits"
    
    if (has_sampling_units) {
      site_names <- df[[1]]
      sampling_units <- df[[2]]
      species_data <- df[, -c(1, 2)]
      validate(need(all(sapply(species_data, is.numeric)), "Species columns must be numeric"))
      
      inext_list <- lapply(1:nrow(df), function(i) c(sampling_units[i], as.numeric(species_data[i, ])))
      names(inext_list) <- site_names
      abund_matrix <- as.matrix(species_data)
      rownames(abund_matrix) <- site_names
      
      list(original = abund_matrix, inext_data = inext_list, data_format = "incidence_freq", 
           sampling_units = sampling_units)
    } else {
      site_names <- df[[1]]
      abund_matrix <- as.matrix(df[-1])
      rownames(abund_matrix) <- site_names
      validate(need(all(sapply(df[-1], is.numeric)), "Species columns must be numeric"))
      
      is_binary <- all(abund_matrix %in% c(0, 1))
      abund_matrix_t <- t(abund_matrix)
      colnames(abund_matrix_t) <- site_names
      
      list(original = abund_matrix, transposed = abund_matrix_t, inext_data = abund_matrix_t,
           data_format = if(is_binary) "incidence_raw" else "abundance", is_binary = is_binary)
    }
  })
  
  output$dataFormatDetected <- renderUI({
    req(data())
    data_format <- data()$data_format
    format_info <- list(
      abundance = list(icon = "📊", name = "Abundance", desc = "Individual counts", color = "#2e8b57"),
      incidence_raw = list(icon = "✓", name = "Incidence_raw", desc = "Presence/absence", color = "#ff8c00"),
      incidence_freq = list(icon = "🔢", name = "Incidence_freq", desc = "Sampling units", color = "#4169e1")
    )[[data_format]]
    
    div(style = paste0("background-color: ", format_info$color, "22; border-left: 4px solid ", format_info$color, 
                      "; padding: 10px; margin-top: 10px; border-radius: 3px;"),
        tags$strong(format_info$icon, " ", format_info$name), tags$br(), tags$small(format_info$desc))
  })
  
  observeEvent(data(), {
    req(data())
    updateSelectInput(session, "dataType", selected = data()$data_format)
  })
  
  # MODULE 1: Diversity Estimation
  diversityResults <- reactiveVal(NULL)
  
  observeEvent(input$runDiversity, {
    req(data())
    withProgress(message = 'Running iNEXT...', value = 0, {
      incProgress(0.2, detail = "Validating...")
      
      inext_data <- data()$inext_data
      actual_datatype <- input$dataType
      
      selected_q <- as.numeric(input$hillNumbers)
      if (length(selected_q) == 0) selected_q <- c(0, 1, 2)
      endpoint_value <- if (is.null(input$endpoint) || is.na(input$endpoint)) NULL else input$endpoint
      
      incProgress(0.4, detail = "Calculating diversity...")
      
      inext_out <- iNEXT(x = inext_data, q = selected_q, datatype = actual_datatype,
                        knots = input$knots, nboot = input$nboot, conf = input$conf, endpoint = endpoint_value)
      
      incProgress(0.8, detail = "Generating plot...")
      
      plot_obj <- ggiNEXT(inext_out, type = as.numeric(input$plotType), se = TRUE, 
                         facet.var = "Order.q", color.var = "Assemblage") + 
        labs(title = "Diversity Estimation (iNEXT)",
             subtitle = paste0("Hill numbers q=", paste(selected_q, collapse = ", "), " | ", 
                             input$conf * 100, "% CI")) +
        theme_bw(base_size = 14) +
        theme(plot.title = element_text(size = 16, face = "bold"), legend.position = "bottom")
      
      incProgress(1)
      diversityResults(list(summary = inext_out$AsyEst, plot = plot_obj))
    })
  })
  
  output$diversityContent <- renderUI({
    if (is.null(diversityResults())) {
      # WELCOME PAGE
      tags$div(
        style = "display: flex; align-items: center; justify-content: center; min-height: 500px; padding: 60px 40px;",
        tags$div(
          style = "max-width: 700px; text-align: center;",
          tags$div(style = "font-size: 5em; color: #2e8b57; margin-bottom: 20px; font-weight: bold;", "Ö"),
          tags$h2(style = "color: #2e8b57; margin-bottom: 20px;", "Diversity Estimation (iNEXT)"),
          tags$div(
            style = "background: #1a1a1a; padding: 25px; border-radius: 10px; border: 1px solid #333; text-align: left;",
            tags$p(style = "color: #aaa; line-height: 1.8; margin-bottom: 15px;",
                  tags$strong("What it does:"), " Rarefaction and extrapolation analysis using iNEXT package"),
            tags$p(style = "color: #aaa; line-height: 1.8; margin-bottom: 15px;",
                  tags$strong("Shows:"), " How diversity changes with sample size (rarefaction CURVES)"),
            tags$p(style = "color: #aaa; line-height: 1.8; margin-bottom: 15px;",
                  tags$strong("Features:"), " Coverage-based comparison, Hill numbers (q=0,1,2), Bootstrap confidence intervals"),
            tags$hr(style = "border-color: #333;"),
            tags$p(style = "color: #888; font-style: italic;",
                  "⚠️ Different from 'Diversity Indices' tab: This creates CURVES showing diversity trends, while 'Diversity Indices' calculates single METRICS (Shannon, Simpson, etc.)")
          ),
          tags$div(
            style = "margin-top: 25px; padding: 15px; background: #1a3a52; border-radius: 8px;",
            tags$strong(style = "color: #2e8b57;", "🚀 Quick Start:"),
            tags$p(style = "color: #aaa; margin: 10px 0 0 0; text-align: left;",
                  "1. Upload CSV file (first column = site names)" , tags$br(),
                  "2. Select data type and plot type", tags$br(),
                  "3. Click 'Run Analysis' to generate curves")
          )
        )
      )
    } else {
      tagList(
        tags$div(style = "padding: 20px;",
                h4("Summary Table", style = "color: #2e8b57;"),
                DTOutput("diversityTable"),
                h4("Visualization", style = "color: #2e8b57; margin-top: 30px;"),
                div(style = "margin-bottom: 15px;",
                   selectInput("diversityPlotFormat", "Export Format:", 
                              choices = c("PNG" = "png", "TIFF" = "tiff", "SVG" = "svg"), width = "150px"),
                   downloadButton("downloadDiversityPlot", "Download", class = "btn-success")),
                plotOutput("diversityPlot", height = "650px"))
      )
    }
  })
  
  output$diversityTable <- renderDT({
    req(diversityResults())
    datatable(diversityResults()$summary, options = list(pageLength = 15, scrollX = TRUE), rownames = FALSE)
  })
  
  output$diversityPlot <- renderPlot({ req(diversityResults()); diversityResults()$plot })
  
  output$downloadDiversityPlot <- downloadHandler(
    filename = function() paste0("diversity_", Sys.Date(), ".", input$diversityPlotFormat),
    content = function(file) {
      format <- input$diversityPlotFormat
      if (format %in% c("png", "tiff")) {
        ggsave(file, plot = diversityResults()$plot, device = format, width = 12, height = 8, dpi = 300, bg = "#222222")
      } else {
        ggsave(file, plot = diversityResults()$plot, device = "svg", width = 12, height = 8, bg = "#222222")
      }
    }
  )
  
  # MODULE 2: Ordination
  ordinationResults <- reactiveVal(NULL)
  
  observeEvent(input$runOrdination, {
    req(data())
    withProgress(message = 'Running ordination...', value = 0, {
      abund_matrix <- data()$original
      method <- input$ordinationMethod
      
      incProgress(0.3, detail = paste("Calculating", toupper(method), "..."))
      
      result <- if (method == "nmds") {
        dist_mat <- vegdist(abund_matrix, method = input$distMethod)
        ord <- metaMDS(dist_mat, k = input$ordDimensions, try = 50, trymax = 100, trace = 0)
        scores_df <- data.frame(Site = rownames(ord$points), ord$points)
        list(scores = scores_df, stress = ord$stress, method = "NMDS")
      } else if (method == "pca") {
        ord <- rda(abund_matrix)
        scores_df <- data.frame(Site = rownames(abund_matrix), scores(ord, display = "sites", choices = 1:min(input$ordDimensions, 2)))
        list(scores = scores_df, stress = NULL, method = "PCA")
      } else if (method == "ca") {
        ord <- cca(abund_matrix)
        scores_df <- data.frame(Site = rownames(abund_matrix), scores(ord, display = "sites", choices = 1:min(input$ordDimensions, 2)))
        list(scores = scores_df, stress = NULL, method = "CA")
      } else if (method == "dca") {
        ord <- decorana(abund_matrix)
        scores_df <- data.frame(Site = rownames(abund_matrix), scores(ord, display = "sites", choices = 1:min(input$ordDimensions, 2)))
        list(scores = scores_df, stress = NULL, method = "DCA")
      } else if (method == "pcoa") {
        dist_mat <- vegdist(abund_matrix, method = input$distMethod)
        ord <- cmdscale(dist_mat, k = input$ordDimensions, eig = TRUE)
        scores_df <- data.frame(Site = rownames(abund_matrix), ord$points[, 1:min(input$ordDimensions, 2)])
        names(scores_df)[-1] <- paste0("Axis", 1:(ncol(scores_df)-1))
        list(scores = scores_df, stress = NULL, method = "PCoA")
      }
      
      incProgress(0.7, detail = "Creating plot...")
      
      if (ncol(result$scores) >= 3) {
        axis_names <- names(result$scores)[-1]
        plot_obj <- ggplot(result$scores, aes(x = .data[[axis_names[1]]], y = .data[[axis_names[2]]])) +
          geom_point(size = 4, color = "#2e8b57", alpha = 0.7) +
          geom_text(aes(label = Site), vjust = -1, color = "white", size = 4) +
          theme_minimal(base_size = 14) +
          theme(panel.background = element_rect(fill = "#222222", color = NA),
                plot.background = element_rect(fill = "#222222", color = NA),
                panel.grid = element_line(color = "#444444"),
                text = element_text(color = "white"),
                axis.text = element_text(color = "white")) +
          labs(title = paste("Ordination:", result$method),
               subtitle = if(!is.null(result$stress)) paste("Stress:", round(result$stress, 3)) else paste("Distance:", input$distMethod))
        
        result$plot <- plot_obj
      }
      
      incProgress(1)
      ordinationResults(result)
    })
  })
  
  output$ordinationContent <- renderUI({
    if (is.null(ordinationResults())) {
      # WELCOME PAGE
      tags$div(
        style = "display: flex; align-items: center; justify-content: center; min-height: 500px; padding: 60px 40px;",
        tags$div(
          style = "max-width: 700px; text-align: center;",
          tags$div(style = "font-size: 5em; color: #2e8b57; margin-bottom: 20px; font-weight: bold;", "Ö"),
          tags$h2(style = "color: #2e8b57; margin-bottom: 20px;", "Ordination Analysis (vegan)"),
          tags$div(
            style = "background: #1a1a1a; padding: 25px; border-radius: 10px; border: 1px solid #333; text-align: left;",
            tags$p(style = "color: #aaa; line-height: 1.8; margin-bottom: 15px;",
                  tags$strong("What it does:"), " Multivariate ordination using vegan package"),
            tags$p(style = "color: #aaa; line-height: 1.8; margin-bottom: 15px;",
                  tags$strong("Shows:"), " Community composition patterns in reduced dimensions (ordination PLOTS)"),
            tags$p(style = "color: #aaa; line-height: 1.8; margin-bottom: 15px;",
                  tags$strong("Methods:"), " NMDS, PCA, CA, DCA, PCoA - 5 ordination techniques"),
            tags$p(style = "color: #aaa; line-height: 1.8; margin-bottom: 15px;",
                  tags$strong("Features:"), " 5 distance measures, 1-5 dimensions, stress values"),
            tags$hr(style = "border-color: #333;"),
            tags$p(style = "color: #888; font-style: italic;",
                  "💡 Best for visualizing how similar/different your sites are based on species composition")
          ),
          tags$div(
            style = "margin-top: 25px; padding: 15px; background: #1a3a52; border-radius: 8px;",
            tags$strong(style = "color: #2e8b57;", "🚀 Quick Start:"),
            tags$p(style = "color: #aaa; margin: 10px 0 0 0; text-align: left;",
                  "1. Upload data in 'Diversity Estimation' tab first" , tags$br(),
                  "2. Select ordination method (NMDS recommended)", tags$br(),
                  "3. Choose distance method (Bray-Curtis for ecology)", tags$br(),
                  "4. Click 'Run Ordination' to visualize patterns")
          )
        )
      )
    } else {
      res <- ordinationResults()
      tagList(
        tags$div(style = "padding: 20px;",
                if (!is.null(res$stress)) {
                  div(class = "alert alert-info", style = "background-color: #1a3a52; color: #fff;",
                     h5(paste("🎯 Stress:", round(res$stress, 3))),
                     p(ifelse(res$stress < 0.05, "✅ Excellent", ifelse(res$stress < 0.1, "✅ Good", 
                            ifelse(res$stress < 0.2, "⚠️ Acceptable", "❌ Poor")))))
                },
                h4("Ordination Scores", style = "color: #2e8b57;"),
                DTOutput("ordinationTable"),
                h4("Visualization", style = "color: #2e8b57; margin-top: 30px;"),
                div(style = "margin-bottom: 15px;",
                   selectInput("ordinationPlotFormat", "Export Format:", 
                              choices = c("PNG" = "png", "SVG" = "svg"), width = "150px"),
                   downloadButton("downloadOrdinationPlot", "Download", class = "btn-success")),
                plotOutput("ordinationPlot", height = "650px"))
      )
    }
  })
  
  output$ordinationTable <- renderDT({
    req(ordinationResults())
    datatable(ordinationResults()$scores, options = list(pageLength = 15, scrollX = TRUE), rownames = FALSE)
  })
  
  output$ordinationPlot <- renderPlot({ req(ordinationResults()); ordinationResults()$plot })
  
  output$downloadOrdinationPlot <- downloadHandler(
    filename = function() paste0("ordination_", Sys.Date(), ".", input$ordinationPlotFormat),
    content = function(file) {
      format <- input$ordinationPlotFormat
      if (format == "png") {
        ggsave(file, plot = ordinationResults()$plot, device = "png", width = 12, height = 8, dpi = 300, bg = "#222222")
      } else {
        ggsave(file, plot = ordinationResults()$plot, device = "svg", width = 12, height = 8, bg = "#222222")
      }
    }
  )
  
  # MODULE 3: Diversity Indices
  indicesResults <- reactiveVal(NULL)
  
  observeEvent(input$runIndices, {
    req(data())
    withProgress(message = 'Calculating indices...', value = 0, {
      abund_matrix <- data()$original
      
      incProgress(0.2, detail = "Calculating diversity indices...")
      
      results_df <- data.frame(Site = rownames(abund_matrix))
      
      # Alpha diversity
      if ("richness" %in% input$alphaIndices) results_df$Richness <- specnumber(abund_matrix)
      if ("shannon" %in% input$alphaIndices) results_df$Shannon <- diversity(abund_matrix, index = "shannon")
      if ("simpson" %in% input$alphaIndices) results_df$Simpson <- diversity(abund_matrix, index = "simpson")
      if ("invsimpson" %in% input$alphaIndices) results_df$InvSimpson <- diversity(abund_matrix, index = "invsimpson")
      if ("fisher" %in% input$alphaIndices) {
        results_df$Fisher <- sapply(1:nrow(abund_matrix), function(i) {
          tryCatch(fisher.alpha(abund_matrix[i,]), error = function(e) NA)
        })
      }
      
      incProgress(0.4, detail = "Calculating evenness...")
      
      # Evenness
      if ("pielou" %in% input$evennessIndices) {
        H <- diversity(abund_matrix, index = "shannon")
        S <- specnumber(abund_matrix)
        results_df$Pielou <- H / log(S)
      }
      if ("simpsone" %in% input$evennessIndices) {
        D <- diversity(abund_matrix, index = "simpson")
        S <- specnumber(abund_matrix)
        results_df$SimpsonE <- (1/D) / S
      }
      if ("evar" %in% input$evennessIndices) {
        evar_vals <- apply(abund_matrix, 1, function(x) {
          x <- x[x > 0]
          if (length(x) < 2) return(NA)
          p <- x / sum(x)
          1 - (2/pi) * atan(var(log(p)))
        })
        results_df$Evar <- evar_vals
      }
      
      incProgress(0.6, detail = "Rarefaction...")
      
      # Rarefaction
      if (!is.null(input$rarefyN) && !is.na(input$rarefyN)) {
        rarefy_n <- input$rarefyN
      } else {
        rarefy_n <- min(rowSums(abund_matrix))
      }
      
      if (rarefy_n > 0) {
        results_df$Rarefied <- rarefy(abund_matrix, sample = rarefy_n)
      }
      
      incProgress(0.8, detail = "Species accumulation...")
      
      # Species accumulation curve
      accum_plot <- NULL
      if (input$calcAccum && nrow(abund_matrix) > 1) {
        sp_accum <- specaccum(abund_matrix, method = "random", permutations = input$accumPerms)
        
        accum_df <- data.frame(
          Sites = sp_accum$sites,
          Richness = sp_accum$richness,
          SD = sp_accum$sd
        )
        
        accum_plot <- ggplot(accum_df, aes(x = Sites, y = Richness)) +
          geom_line(color = "#2e8b57", linewidth = 1.5) +
          geom_point(color = "#2e8b57", size = 3) +
          geom_ribbon(aes(ymin = Richness - SD, ymax = Richness + SD), 
                     fill = "#2e8b57", alpha = 0.3) +
          theme_minimal(base_size = 14) +
          theme(panel.background = element_rect(fill = "#222222", color = NA),
                plot.background = element_rect(fill = "#222222", color = NA),
                panel.grid = element_line(color = "#444444"),
                text = element_text(color = "white"),
                axis.text = element_text(color = "white")) +
          labs(title = "Species Accumulation Curve",
               subtitle = paste("Method: Random | Permutations:", input$accumPerms),
               x = "Number of Sites", y = "Species Richness") +
          scale_x_continuous(breaks = sp_accum$sites)
      }
      
      incProgress(1)
      indicesResults(list(summary = results_df, accum_plot = accum_plot))
    })
  })
  
  output$indicesContent <- renderUI({
    if (is.null(indicesResults())) {
      # WELCOME PAGE
      tags$div(
        style = "display: flex; align-items: center; justify-content: center; min-height: 500px; padding: 60px 40px;",
        tags$div(
          style = "max-width: 700px; text-align: center;",
          tags$div(style = "font-size: 5em; color: #2e8b57; margin-bottom: 20px; font-weight: bold;", "Ö"),
          tags$h2(style = "color: #2e8b57; margin-bottom: 20px;", "Diversity Indices (vegan)"),
          tags$div(
            style = "background: #1a1a1a; padding: 25px; border-radius: 10px; border: 1px solid #333; text-align: left;",
            tags$p(style = "color: #aaa; line-height: 1.8; margin-bottom: 15px;",
                  tags$strong("What it does:"), " Classic diversity metrics using vegan package"),
            tags$p(style = "color: #aaa; line-height: 1.8; margin-bottom: 15px;",
                  tags$strong("Shows:"), " Single-value diversity METRICS for each site (not curves)"),
            tags$p(style = "color: #aaa; line-height: 1.8; margin-bottom: 15px;",
                  tags$strong("Indices:"), " Shannon, Simpson, Fisher's α, Pielou's evenness, rarefied richness"),
            tags$p(style = "color: #aaa; line-height: 1.8; margin-bottom: 15px;",
                  tags$strong("Features:"), " Accumulation curves, rarefaction, evenness metrics"),
            tags$hr(style = "border-color: #333;"),
            tags$p(style = "color: #888; font-style: italic;",
                  "⚠️ Different from 'Diversity Estimation': This calculates single METRICS (Shannon=2.8), while Diversity Estimation creates CURVES showing trends")
          ),
          tags$div(
            style = "margin-top: 25px; padding: 15px; background: #1a3a52; border-radius: 8px;",
            tags$strong(style = "color: #2e8b57;", "🚀 Quick Start:"),
            tags$p(style = "color: #aaa; margin: 10px 0 0 0; text-align: left;",
                  "1. Upload data in 'Diversity Estimation' tab first" , tags$br(),
                  "2. Select which indices to calculate", tags$br(),
                  "3. Optionally enable species accumulation curve", tags$br(),
                  "4. Click 'Calculate Indices' to compute metrics")
          )
        )
      )
    } else {
      res <- indicesResults()
      tagList(
        tags$div(style = "padding: 20px;",
                h4("Diversity Indices", style = "color: #2e8b57;"),
                DTOutput("indicesTable"),
                if (!is.null(res$accum_plot)) {
                  tagList(
                    h4("Species Accumulation", style = "color: #2e8b57; margin-top: 30px;"),
                    div(style = "margin-bottom: 15px;",
                       downloadButton("downloadAccumPlot", "Download", class = "btn-success")),
                    plotOutput("accumPlot", height = "500px")
                  )
                })
      )
    }
  })
  
  output$indicesTable <- renderDT({
    req(indicesResults())
    datatable(indicesResults()$summary, options = list(pageLength = 15, scrollX = TRUE), rownames = FALSE) %>%
      formatRound(columns = 2:ncol(indicesResults()$summary), digits = 4)
  })
  
  output$accumPlot <- renderPlot({ req(indicesResults()); indicesResults()$accum_plot })
  
  output$downloadAccumPlot <- downloadHandler(
    filename = function() paste0("accum_curve_", Sys.Date(), ".png"),
    content = function(file) {
      ggsave(file, plot = indicesResults()$accum_plot, device = "png", width = 10, height = 6, dpi = 300, bg = "#222222")
    }
  )
}

shinyApp(ui, server)
