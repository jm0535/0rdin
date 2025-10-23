# Ördin v2.2 - Modular Biodiversity Analysis Application
# Complete implementation with unified enterprise-grade UI

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
    preset = "shiny",
    bg = "#1e1e1e",
    fg = "#cccccc",
    primary = "#007acc",
    secondary = "#2d2d30",
    success = "#4ec9b0",
    "navbar-bg" = "#2d2d30",
    "navbar-light-brand-color" = "#ffffff",
    "navbar-light-brand-hover-color" = "#007acc",
    "font-size-base" = "0.9rem",
    "enable-rounded" = FALSE,
    "enable-shadows" = FALSE
  ),
  
  # Custom CSS for flat VSCode-style design with theme support
  header = tags$head(
    # Favicon with Ö symbol
    tags$link(rel = "icon", type = "image/svg+xml", href = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'%3E%3Ctext y='75' font-size='80' font-family='Arial, sans-serif' fill='%232e8b57'%3E%C3%96%3C/text%3E%3C/svg%3E"),
    tags$script(HTML('
      // Theme toggle functionality
      function toggleTheme() {
        const body = document.body;
        const currentTheme = body.classList.contains("light-theme") ? "light" : "dark";
        const newTheme = currentTheme === "dark" ? "light" : "dark";
        
        // Toggle CSS class
        if (newTheme === "light") {
          body.classList.add("light-theme");
          body.classList.remove("dark-theme");
        } else {
          body.classList.add("dark-theme");
          body.classList.remove("light-theme");
        }
        
        localStorage.setItem("ordin-theme", newTheme);
        
        // Update toggle button icon
        const btn = document.getElementById("theme-toggle-btn");
        if (btn) {
          btn.innerHTML = newTheme === "dark" ? "☀️" : "🌙";
          btn.title = newTheme === "dark" ? "Switch to Light Theme" : "Switch to Dark Theme";
        }
      }
      
      // Load saved theme on startup
      document.addEventListener("DOMContentLoaded", function() {
        const savedTheme = localStorage.getItem("ordin-theme") || "dark";
        const body = document.body;
        
        if (savedTheme === "light") {
          body.classList.add("light-theme");
          body.classList.remove("dark-theme");
        } else {
          body.classList.add("dark-theme");
          body.classList.remove("light-theme");
        }
        
        const btn = document.getElementById("theme-toggle-btn");
        if (btn) {
          btn.innerHTML = savedTheme === "dark" ? "☀️" : "🌙";
          btn.title = savedTheme === "dark" ? "Switch to Light Theme" : "Switch to Dark Theme";
        }
      });
    ')),
    tags$style(HTML('
      /* Base styles - Default to DARK theme */
      body {
        font-family: -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Helvetica Neue, Arial, sans-serif;
        background: #1e1e1e;
        color: #cccccc;
        transition: background-color 0.2s ease, color 0.2s ease;
      }
      
      /* LIGHT THEME overrides */
      body.light-theme {
        background: #ffffff !important;
        color: #1e1e1e !important;
      }
      
      /* Theme toggle button */
      #theme-toggle-btn {
        background: transparent;
        border: 1px solid transparent;
        color: #cccccc;
        font-size: 1.1rem;
        padding: 4px 10px;
        cursor: pointer;
        transition: all 0.15s ease;
        border-radius: 0;
      }
      
      #theme-toggle-btn:hover {
        background: #37373d;
        border-color: #3e3e42;
      }
      
      body.light-theme #theme-toggle-btn {
        color: #424242;
      }
      
      body.light-theme #theme-toggle-btn:hover {
        background: #e8e8e8;
        border-color: #d0d0d0;
      }
      
      /* Flat navbar - DARK */
      .navbar {
        background: #2d2d30 !important;
        border-bottom: 1px solid #3e3e42 !important;
        box-shadow: none !important;
        padding: 0 !important;
        min-height: 35px !important;
        transition: all 0.2s ease;
      }
      
      body.light-theme .navbar {
        background: #f3f3f3 !important;
        border-bottom: 1px solid #d0d0d0 !important;
      }
      
      .navbar-brand {
        color: #ffffff !important;
        font-weight: 600 !important;
        font-size: 1.3rem !important;
        padding: 6px 16px !important;
        display: flex;
        align-items: center;
        gap: 8px;
      }
      
      body.light-theme .navbar-brand {
        color: #1e1e1e !important;
      }
      
      .navbar-brand:hover {
        color: #007acc !important;
        background: #37373d;
      }
      
      body.light-theme .navbar-brand:hover {
        background: #e8e8e8;
      }
      
      /* Flat nav items */
      .nav-link {
        color: #cccccc !important;
        padding: 8px 16px !important;
        border: none !important;
        border-radius: 0 !important;
        font-size: 0.85rem !important;
        transition: all 0.1s ease;
        border-bottom: 2px solid transparent !important;
      }
      
      body.light-theme .nav-link {
        color: #424242 !important;
      }
      
      .nav-link:hover {
        background: #37373d !important;
        color: #ffffff !important;
      }
      
      body.light-theme .nav-link:hover {
        background: #e8e8e8 !important;
        color: #1e1e1e !important;
      }
      
      .nav-link.active {
        background: #1e1e1e !important;
        color: #007acc !important;
        border-bottom: 2px solid #007acc !important;
      }
      
      body.light-theme .nav-link.active {
        background: #ffffff !important;
      }
      
      /* Flat sidebar */
      .bslib-sidebar-layout > .sidebar {
        background: #252526 !important;
        border-right: 1px solid #3e3e42 !important;
        box-shadow: none !important;
        transition: all 0.2s ease;
      }
      
      body.light-theme .bslib-sidebar-layout > .sidebar {
        background: #f8f8f8 !important;
        border-right: 1px solid #d0d0d0 !important;
      }
      
      /* Flat cards */
      .card {
        background: #252526 !important;
        border: 1px solid #3e3e42 !important;
        border-radius: 0 !important;
        box-shadow: none !important;
        transition: all 0.2s ease;
      }
      
      body.light-theme .card {
        background: #ffffff !important;
        border: 1px solid #d0d0d0 !important;
      }
      
      .card-header {
        background: #2d2d30 !important;
        border-bottom: 1px solid #3e3e42 !important;
        color: #cccccc !important;
        font-weight: 600 !important;
        font-size: 0.85rem !important;
        padding: 8px 12px !important;
        border-radius: 0 !important;
        transition: all 0.2s ease;
      }
      
      body.light-theme .card-header {
        background: #f3f3f3 !important;
        border-bottom: 1px solid #d0d0d0 !important;
        color: #1e1e1e !important;
      }
      
      /* Flat buttons */
      .btn {
        border-radius: 0 !important;
        font-size: 0.85rem !important;
        font-weight: 500 !important;
        padding: 6px 14px !important;
        transition: all 0.1s ease;
        border: 1px solid #3e3e42 !important;
      }
      
      body.light-theme .btn {
        border: 1px solid #d0d0d0 !important;
      }
      
      .btn-success {
        background: #007acc !important;
        border-color: #007acc !important;
        color: #ffffff !important;
      }
      
      .btn-success:hover {
        background: #005a9e !important;
        border-color: #005a9e !important;
      }
      
      .btn-lg {
        padding: 10px 20px !important;
        font-size: 0.9rem !important;
      }
      
      /* Flat inputs */
      .form-control,
      .form-select {
        background: #3c3c3c !important;
        border: 1px solid #3e3e42 !important;
        color: #cccccc !important;
        border-radius: 0 !important;
        font-size: 0.85rem !important;
        transition: all 0.2s ease;
      }
      
      body.light-theme .form-control,
      body.light-theme .form-select {
        background: #ffffff !important;
        border: 1px solid #d0d0d0 !important;
        color: #1e1e1e !important;
      }
      
      .form-control:focus,
      .form-select:focus {
        background: #3c3c3c !important;
        border-color: #007acc !important;
        box-shadow: none !important;
        color: #ffffff !important;
      }
      
      body.light-theme .form-control:focus,
      body.light-theme .form-select:focus {
        background: #ffffff !important;
        color: #1e1e1e !important;
      }
      
      /* Flat accordion */
      .accordion-button {
        background: #2d2d30 !important;
        color: #cccccc !important;
        border: none !important;
        border-radius: 0 !important;
        font-size: 0.85rem !important;
        padding: 8px 12px !important;
        transition: all 0.2s ease;
      }
      
      body.light-theme .accordion-button {
        background: #f3f3f3 !important;
        color: #1e1e1e !important;
      }
      
      .accordion-button:not(.collapsed) {
        background: #37373d !important;
        color: #007acc !important;
      }
      
      body.light-theme .accordion-button:not(.collapsed) {
        background: #e8e8e8 !important;
      }
      
      .accordion-body {
        background: #252526 !important;
        border-top: 1px solid #3e3e42 !important;
        padding: 12px !important;
        transition: all 0.2s ease;
      }
      
      body.light-theme .accordion-body {
        background: #ffffff !important;
        border-top: 1px solid #d0d0d0 !important;
      }
      
      /* Flat nav pills */
      .nav-pills .nav-link {
        background: #2d2d30 !important;
        color: #cccccc !important;
        border-radius: 0 !important;
        margin-right: 2px !important;
        padding: 8px 16px !important;
        font-size: 0.85rem !important;
      }
      
      body.light-theme .nav-pills .nav-link {
        background: #f3f3f3 !important;
        color: #424242 !important;
      }
      
      .nav-pills .nav-link.active {
        background: #007acc !important;
        color: #ffffff !important;
      }
      
      .nav-pills .nav-link:hover:not(.active) {
        background: #37373d !important;
      }
      
      body.light-theme .nav-pills .nav-link:hover:not(.active) {
        background: #e8e8e8 !important;
      }
      
      /* Flat alerts */
      .alert {
        border-radius: 0 !important;
        border: 1px solid #3e3e42 !important;
        font-size: 0.85rem !important;
        transition: all 0.2s ease;
      }
      
      body.light-theme .alert {
        border: 1px solid #d0d0d0 !important;
      }
      
      /* DataTable styling */
      .dataTables_wrapper {
        color: #cccccc !important;
      }
      
      body.light-theme .dataTables_wrapper {
        color: #1e1e1e !important;
      }
      
      .dataTables_wrapper .dataTables_length,
      .dataTables_wrapper .dataTables_filter,
      .dataTables_wrapper .dataTables_info,
      .dataTables_wrapper .dataTables_paginate {
        color: #cccccc !important;
      }
      
      body.light-theme .dataTables_wrapper .dataTables_length,
      body.light-theme .dataTables_wrapper .dataTables_filter,
      body.light-theme .dataTables_wrapper .dataTables_info,
      body.light-theme .dataTables_wrapper .dataTables_paginate {
        color: #1e1e1e !important;
      }
      
      table.dataTable {
        border: 1px solid #3e3e42 !important;
        background: #252526 !important;
        transition: all 0.2s ease;
      }
      
      body.light-theme table.dataTable {
        border: 1px solid #d0d0d0 !important;
        background: #ffffff !important;
      }
      
      table.dataTable thead th {
        background: #2d2d30 !important;
        color: #cccccc !important;
        border-bottom: 1px solid #3e3e42 !important;
        font-weight: 600 !important;
      }
      
      body.light-theme table.dataTable thead th {
        background: #f3f3f3 !important;
        color: #1e1e1e !important;
        border-bottom: 1px solid #d0d0d0 !important;
      }
      
      table.dataTable tbody tr {
        background: #252526 !important;
        color: #cccccc !important;
      }
      
      body.light-theme table.dataTable tbody tr {
        background: #ffffff !important;
        color: #1e1e1e !important;
      }
      
      table.dataTable tbody tr:hover {
        background: #2d2d30 !important;
      }
      
      body.light-theme table.dataTable tbody tr:hover {
        background: #f8f8f8 !important;
      }
      
      /* Remove all shadows */
      * {
        box-shadow: none !important;
      }
      
      /* Scrollbar styling */
      ::-webkit-scrollbar {
        width: 10px;
        height: 10px;
      }
      
      ::-webkit-scrollbar-track {
        background: #1e1e1e;
      }
      
      body.light-theme ::-webkit-scrollbar-track {
        background: #f3f3f3;
      }
      
      ::-webkit-scrollbar-thumb {
        background: #424242;
        border-radius: 0;
      }
      
      body.light-theme ::-webkit-scrollbar-thumb {
        background: #c0c0c0;
      }
      
      ::-webkit-scrollbar-thumb:hover {
        background: #4e4e4e;
      }
      
      body.light-theme ::-webkit-scrollbar-thumb:hover {
        background: #a0a0a0;
      }
    '))
  ),
  
  title = span(
    style = "font-size: 1.3em; font-weight: 700; color: #2e8b57;",
    title = "Ördin - Community Ecology Analysis Platform",
    "Ö"
  ),
  id = "main_nav",
  
  # DIVERSITY ANALYSIS
  nav_panel(
    title = "Diversity Analysis",
    layout_sidebar(
      fillable = TRUE,
      sidebar = sidebar(
        width = 380,
        open = TRUE,
        
        # Data Upload Section
        card(
          class = "mb-3",
          card_header(
            "Data Upload"
          ),
          card_body(
            fileInput("dataFile", NULL, accept = ".csv",
                     buttonLabel = "Browse...",
                     placeholder = "No file selected"),
            tags$small(class = "text-muted", 
                      icon("info-circle"), 
                      " First column: Site names | Other columns: Species data"),
            uiOutput("dataFormatDetected")
          )
        ),
        
        hr(style = "border-color: #444; margin: 20px 0;"),
        
        # Analysis Type Selector
        div(
          class = "mb-3",
          h6("Analysis Type", style = "color: #cccccc; margin-bottom: 10px; font-weight: 600; font-size: 0.85rem;"),
          navset_pill(
            id = "analysisType",
            nav_panel(
              title = "Estimation",
              value = "estimation",
              # iNEXT Controls
              div(
                class = "mt-3",
                selectInput("dataType", "Data Type",
                           choices = c(
                             "Abundance" = "abundance",
                             "Incidence (Binary)" = "incidence_raw",
                             "Incidence (Freq)" = "incidence_freq"
                           ),
                           width = "100%"),
                selectInput("plotType", "Plot Type",
                           choices = c(
                             "Sample-based" = "1",
                             "Completeness" = "2",
                             "Coverage" = "3"
                           ),
                           width = "100%"),
                accordion(
                  accordion_panel(
                    title = "Advanced Options",
                    icon = icon("cog"),
                    checkboxGroupInput("hillNumbers", "Hill Numbers",
                                      choices = c("q=0" = "0", "q=1" = "1", "q=2" = "2"),
                                      selected = c("0", "1", "2")),
                    numericInput("knots", "Knots", value = 40, min = 10, max = 200),
                    numericInput("nboot", "Bootstrap", value = 50, min = 10, max = 500),
                    numericInput("conf", "Confidence", value = 0.95, min = 0.8, max = 0.99, step = 0.01),
                    numericInput("endpoint", "Endpoint", value = NULL)
                  )
                ),
                actionButton("runDiversity", 
                           "Run Estimation",
                           class = "btn-success btn-lg w-100 mt-3")
              )
            ),
            nav_panel(
              title = "Indices",
              value = "indices",
              # Vegan Controls
              div(
                class = "mt-3",
                card(
                  card_header("Alpha Diversity", class = "py-2"),
                  card_body(
                    class = "py-2",
                    checkboxGroupInput("alphaIndices", NULL,
                                      choices = c(
                                        "Shannon" = "shannon",
                                        "Simpson" = "simpson",
                                        "InvSimpson" = "invsimpson",
                                        "Fisher" = "fisher",
                                        "Richness" = "richness"
                                      ),
                                      selected = c("shannon", "simpson", "richness"))
                  )
                ),
                card(
                  class = "mt-2",
                  card_header("Evenness", class = "py-2"),
                  card_body(
                    class = "py-2",
                    checkboxGroupInput("evennessIndices", NULL,
                                      choices = c(
                                        "Pielou" = "pielou",
                                        "SimpsonE" = "simpsone",
                                        "Evar" = "evar"
                                      ),
                                      selected = c("pielou"))
                  )
                ),
                actionButton("runIndices",
                           "Calculate Indices",
                           class = "btn-success btn-lg w-100 mt-3")
              )
            )
          )
        )
      ),
      
      # Main Content Area
      uiOutput("diversityMainContent")
    )
  ),
  
  # ORDINATION
  nav_panel(
    title = "Ordination",
    layout_sidebar(
      sidebar = sidebar(
        width = 350,
        card(
          card_header(
            "Ordination Settings"
          ),
          card_body(
            selectInput("ordinationMethod", "Method",
                       choices = c(
                         "NMDS" = "nmds",
                         "PCA" = "pca",
                         "CA" = "ca",
                         "DCA" = "dca",
                         "PCoA" = "pcoa"
                       )),
            numericInput("ordDimensions", "Dimensions", value = 2, min = 1, max = 5),
            selectInput("distMethod", "Distance",
                       choices = c(
                         "Bray-Curtis" = "bray",
                         "Jaccard" = "jaccard",
                         "Euclidean" = "euclidean",
                         "Manhattan" = "manhattan",
                         "Canberra" = "canberra"
                       )),
            actionButton("runOrdination",
                       "Run Ordination",
                       class = "btn-success btn-lg w-100 mt-3")
          )
        )
      ),
      uiOutput("ordinationContent")
    )
  ),
  
  # HELP
  nav_panel(
    title = "Help",
    card(
      full_screen = TRUE,
      card_header(
        "Ördin User Guide"
      ),
      card_body(
        div(
          class = "container",
          style = "max-width: 900px; padding: 30px;",
          
          # Header
          div(
            class = "text-center mb-5",
            div(style = "font-size: 5em; color: #2e8b57; margin-bottom: 20px;", "Ö"),
            h2(style = "color: #2e8b57; font-weight: 700;", "Ördin v2.3"),
            p(class = "lead", style = "color: #aaa;", "Community Ecology Analysis Platform")
          ),
          
          # Modules
          card(
            class = "mb-4",
            card_header(icon("layer-group"), " Analysis Modules", class = "fw-bold"),
            card_body(
              div(class = "row",
                 div(class = "col-md-6 mb-3",
                    div(class = "d-flex align-items-start",
                       div(class = "me-3", style = "font-size: 2em; color: #2e8b57;", icon("chart-line")),
                       div(
                         h5(class = "fw-bold", "Diversity Estimation (iNEXT)"),
                         p(class = "text-muted small mb-0", "Rarefaction, extrapolation & Hill numbers for community diversity")
                       )
                    )
                 ),
                 div(class = "col-md-6 mb-3",
                    div(class = "d-flex align-items-start",
                       div(class = "me-3", style = "font-size: 2em; color: #2e8b57;", icon("calculator")),
                       div(
                         h5(class = "fw-bold", "Diversity Indices (vegan)"),
                         p(class = "text-muted small mb-0", "Shannon, Simpson, evenness & ecological indices")
                       )
                    )
                 ),
                 div(class = "col-md-6 mb-3",
                    div(class = "d-flex align-items-start",
                       div(class = "me-3", style = "font-size: 2em; color: #4169e1;", icon("project-diagram")),
                       div(
                         h5(class = "fw-bold", "Ordination Analysis (vegan)"),
                         p(class = "text-muted small mb-0", "NMDS, PCA, CA, DCA, PCoA for community composition patterns")
                       )
                    )
                 )
              )
            )
          ),
          
          # Quick Start
          card(
            card_header(icon("rocket"), " Quick Start", class = "fw-bold"),
            card_body(
              tags$ol(
                class = "mb-0",
                tags$li("Upload CSV file (first column = site names, others = species/taxa data)"),
                tags$li("Select analysis type in sidebar (Estimation, Indices, or Ordination)"),
                tags$li("Configure parameters and click Run"),
                tags$li("Download results as CSV or publication-quality images")
              )
            )
          ),
          
          # Footer
          hr(class = "my-4"),
          div(
            class = "text-center text-muted",
            p(tags$small(
              "Built with R Shiny + iNEXT + vegan | ",
              strong("© 2025 Jimmy Moses"),
              " | MIT License"
            ))
          )
        )
      )
    )
  ),
  
  # Theme Toggle Button (far right)
  nav_spacer(),
  nav_item(
    tags$button(
      id = "theme-toggle-btn",
      class = "btn",
      onclick = "toggleTheme()",
      title = "Switch to Light Theme",
      style = "border: none; background: transparent; font-size: 1.1rem; padding: 4px 10px; cursor: pointer;",
      "☀️"  # Sun emoji (will show in dark mode)
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
  
  # Unified Main Content Renderer
  output$diversityMainContent <- renderUI({
    analysis_type <- input$analysisType
    
    if (is.null(analysis_type) || analysis_type == "estimation") {
      # Show Estimation Results
      if (is.null(diversityResults())) {
        # Welcome message for Estimation
        card(
          full_screen = TRUE,
          height = "100%",
          card_body(
            class = "d-flex align-items-center justify-content-center",
            div(
              class = "text-center",
              style = "max-width: 650px;",
              div(style = "font-size: 4.5em; color: #2e8b57; margin-bottom: 25px;", "Ö"),
              h3(class = "fw-bold", style = "color: #2e8b57; margin-bottom: 20px;", "Diversity Estimation (iNEXT)"),
              card(
                class = "text-start",
                style = "background: #252525; border: 1px solid #333;",
                card_body(
                  p(class = "mb-2", icon("check-circle", class = "text-success"), 
                    strong(" Rarefaction & Extrapolation: "), "Estimate community diversity across sampling efforts"),
                  p(class = "mb-2", icon("check-circle", class = "text-success"), 
                    strong(" Hill Numbers: "), "q=0 (richness), q=1 (Shannon), q=2 (Simpson)"),
                  p(class = "mb-2", icon("check-circle", class = "text-success"), 
                    strong(" Coverage-based: "), "Sample completeness curves and asymptotic estimators"),
                  p(class = "mb-0", icon("check-circle", class = "text-success"), 
                    strong(" Bootstrap CI: "), "Robust confidence intervals for statistical inference")
                )
              ),
              div(
                class = "alert alert-info mt-4",
                style = "background: #1a3a52; border: 1px solid #2e5c7a;",
                icon("info-circle"), " Upload community data and configure settings in the sidebar, then click ",
                strong("Run Estimation"), " to begin diversity analysis."
              )
            )
          )
        )
      } else {
        # Show estimation results
        card(
          full_screen = TRUE,
          card_header(
            class = "bg-success text-white",
            icon("chart-line"), " Diversity Estimation Results"
          ),
          card_body(
            navset_card_tab(
              nav_panel(
                title = "Summary Table",
                div(class = "p-3",
                   downloadButton("downloadDiversityTable", "Download CSV", class = "btn-success mb-3"),
                   DTOutput("diversityTable"))
              ),
              nav_panel(
                title = "Visualization",
                div(class = "p-3",
                   div(class = "mb-3",
                      selectInput("diversityPlotFormat", "Export Format:",
                                 choices = c("PNG (300 DPI)" = "png", "TIFF (300 DPI)" = "tiff", "SVG (Vector)" = "svg"),
                                 width = "200px"),
                      downloadButton("downloadDiversityPlot", "Download Plot", class = "btn-success")),
                   plotOutput("diversityPlot", height = "700px"))
              )
            )
          )
        )
      }
    } else {
      # Show Indices Results  
      if (is.null(indicesResults())) {
        # Welcome message for Indices
        card(
          full_screen = TRUE,
          height = "100%",
          card_body(
            class = "d-flex align-items-center justify-content-center",
            div(
              class = "text-center",
              style = "max-width: 650px;",
              div(style = "font-size: 4.5em; color: #2e8b57; margin-bottom: 25px;", "Ö"),
              h3(class = "fw-bold", style = "color: #2e8b57; margin-bottom: 20px;", "Diversity Indices (vegan)"),
              card(
                class = "text-start",
                style = "background: #252525; border: 1px solid #333;",
                card_body(
                  p(class = "mb-2", icon("check-circle", class = "text-success"), 
                    strong(" Alpha Diversity: "), "Shannon, Simpson, Fisher, Richness for community diversity"),
                  p(class = "mb-2", icon("check-circle", class = "text-success"), 
                    strong(" Evenness: "), "Pielou's J, Simpson's E, Evar for community structure"),
                  p(class = "mb-2", icon("check-circle", class = "text-success"), 
                    strong(" Tabular Output: "), "Export-ready tables for Excel, GraphPad, or R"),
                  p(class = "mb-0", icon("check-circle", class = "text-success"), 
                    strong(" CSV Export: "), "Download results for further community analysis")
                )
              ),
              div(
                class = "alert alert-info mt-4",
                style = "background: #1a3a52; border: 1px solid #2e5c7a;",
                icon("info-circle"), " Select indices in the sidebar, then click ",
                strong("Calculate Indices"), " to compute metrics."
              )
            )
          )
        )
      } else {
        # Show indices results
        card(
          full_screen = TRUE,
          card_header(
            class = "bg-success text-white",
            icon("calculator"), " Diversity Indices Results"
          ),
          card_body(
            class = "p-4",
            div(
              class = "alert alert-light mb-4",
              style = "background: #2a2a2a; border: 1px solid #3a3a3a;",
              icon("download"), " Download the table as CSV and create custom visualizations in Excel, GraphPad, or statistical software."
            ),
            downloadButton("downloadIndicesTable", 
                         span(icon("file-csv"), " Download Results (CSV)"),
                         class = "btn-success btn-lg mb-4"),
            DTOutput("indicesTable")
          )
        )
      }
    }
  })
  
  # Diversity Estimation Module
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
  
  output$diversityTable <- renderDT({
    req(diversityResults())
    datatable(diversityResults()$summary, 
             options = list(pageLength = 15, scrollX = TRUE, dom = 'Bfrtip'), 
             rownames = FALSE,
             class = 'display compact stripe hover')
  })
  
  output$diversityPlot <- renderPlot({ 
    req(diversityResults()); 
    diversityResults()$plot 
  })
  
  output$downloadDiversityTable <- downloadHandler(
    filename = function() paste0("diversity_estimation_", Sys.Date(), ".csv"),
    content = function(file) {
      write.csv(diversityResults()$summary, file, row.names = FALSE)
    }
  )
  
  output$downloadDiversityPlot <- downloadHandler(
    filename = function() paste0("diversity_plot_", Sys.Date(), ".", input$diversityPlotFormat),
    content = function(file) {
      format <- input$diversityPlotFormat
      if (format == "png") {
        ggsave(file, plot = diversityResults()$plot, device = "png", width = 12, height = 8, dpi = 300, bg = "white")
      } else if (format == "tiff") {
        ggsave(file, plot = diversityResults()$plot, device = "tiff", width = 12, height = 8, dpi = 300, bg = "white")
      } else {
        ggsave(file, plot = diversityResults()$plot, device = "svg", width = 12, height = 8, bg = "white")
      }
    }
  )
  
  # Diversity Indices Module
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
                  tags$strong("What it does:"), " Multivariate ordination for community ecology analysis"),
            tags$p(style = "color: #aaa; line-height: 1.8; margin-bottom: 15px;",
                  tags$strong("Shows:"), " Community composition patterns in reduced dimensions"),
            tags$p(style = "color: #aaa; line-height: 1.8; margin-bottom: 15px;",
                  tags$strong("Methods:"), " NMDS, PCA, CA, DCA, PCoA - 5 ordination techniques"),
            tags$p(style = "color: #aaa; line-height: 1.8; margin-bottom: 15px;",
                  tags$strong("Features:"), " 5 distance measures, 1-5 dimensions, stress values"),
            tags$hr(style = "border-color: #333;"),
            tags$p(style = "color: #888; font-style: italic;",
                  "💡 Best for visualizing community similarity patterns and ecological gradients")
          ),
          tags$div(
            style = "margin-top: 25px; padding: 15px; background: #1a3a52; border-radius: 8px;",
            tags$strong(style = "color: #2e8b57;", "🚀 Quick Start:"),
            tags$p(style = "color: #aaa; margin: 10px 0 0 0; text-align: left;",
                  "1. Upload community data in 'Diversity Analysis' tab first" , tags$br(),
                  "2. Select ordination method (NMDS recommended for ecology)", tags$br(),
                  "3. Choose distance method (Bray-Curtis for community data)", tags$br(),
                  "4. Click 'Run Ordination' to visualize community patterns")
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
      
      incProgress(0.8, detail = "Finalizing results...")
      
      incProgress(1)
      indicesResults(list(summary = results_df))
    })
  })
  
  output$indicesTable <- renderDT({
    req(indicesResults())
    datatable(indicesResults()$summary, 
             options = list(pageLength = 15, scrollX = TRUE, dom = 'Bfrtip'),
             rownames = FALSE,
             class = 'display compact stripe hover') %>%
      formatRound(columns = 2:ncol(indicesResults()$summary), digits = 4)
  })
  
  output$downloadIndicesTable <- downloadHandler(
    filename = function() paste0("diversity_indices_", Sys.Date(), ".csv"),
    content = function(file) {
      write.csv(indicesResults()$summary, file, row.names = FALSE)
    }
  )
}

shinyApp(ui, server)
