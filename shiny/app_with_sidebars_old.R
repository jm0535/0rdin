# Ördin v3.0 - Complete Production App with Prototype Sidebars
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# EXACT PROTOTYPE REPLICATION with VS Code-style sidebars

library(shiny)
library(bslib)
library(vegan)
library(iNEXT)
library(ggplot2)
library(DT)
library(shinyjs)
library(waiter)
library(shinyFeedback)

# Source all modules
source("modules/ordination_nmds_module.R")
source("modules/ordination_pca_module.R")
source("modules/ordination_ca_module.R")
source("modules/ordination_dca_module.R")
source("modules/ordination_pcoa_module.R")
source("modules/diversity_estimation_module.R")
source("modules/diversity_indices_module.R")

# UI
ui <- tagList(
  useShinyjs(),
  use_waiter(),
  useShinyFeedback(),
  
  # Include CSS
  tags$head(
    tags$link(rel = "stylesheet", href = "custom.css"),
    tags$link(rel = "stylesheet", href = "styles.css"),
    tags$style(HTML("
      body { margin: 0; padding: 0; overflow: hidden; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; }
      .navbar { display: none !important; } /* Hide Shiny navbar */
    "))
  ),
  
  # Include JS
  tags$script(src = "validation.js"),
  tags$script(src = "statistical-interpretation.js"),
  tags$script(src = "about-ordin-content.js"),
  
  # Custom JS for sidebar sync
  tags$script(HTML("
    $(document).ready(function() {
      // Sync activity bar with Shiny tabs
      $(document).on('shiny:inputchanged', function(event) {
        if (event.name === 'main_tabs') {
          $('.activity-item').removeClass('active');
          $('#activity-' + event.value).addClass('active');
        }
      });
      
      // Handle activity bar clicks
      window.switchToTab = function(tab) {
        Shiny.setInputValue('main_tabs', tab);
        
        // Toggle sidebar if clicking same tab
        var wasActive = $('#activity-' + tab).hasClass('active');
        if (wasActive) {
          $('#sidebar').toggleClass('collapsed');
        } else {
          $('#sidebar').removeClass('collapsed');
        }
      };
      
      // Set initial active state
      $('#activity-home').addClass('active');
    });
  ")),
  
  # Loading screen
  waiter_show_on_load(
    html = tagList(
      spin_loaders(42, color = "#2e8b57"),
      h2("Ördin v3.0", style = "color: #2e8b57; margin-top: 30px;"),
      p("Loading...", style = "color: #999;")
    ),
    color = "#1a1a1a"
  ),
  
  # ============================================
  # PROTOTYPE STRUCTURE: Title Bar
  # ============================================
  div(class = "titlebar",
    div(class = "titlebar-left",
      span(class = "app-icon", "Ö"),
      span(class = "app-title", "Ördin"),
      span(class = "divider", "|"),
      span(class = "dataset-name", id = "dataset-display", "📄 No data loaded")
    ),
    div(class = "titlebar-center",
      span(class = "status-badge", "● Ready")
    ),
    div(class = "titlebar-right",
      span(class = "user-info", "👤 Jimmy Moses")
    )
  ),
  
  # ============================================
  # PROTOTYPE STRUCTURE: Main Container
  # ============================================
  div(class = "main-container",
    
    # ============================================
    # Activity Bar (VS Code style - 48px)
    # ============================================
    div(class = "activity-bar",
      div(class = "activity-item", id = "activity-home", 
          title = "Home",
          onclick = "switchToTab('home')", "🏠"),
      div(class = "activity-item", id = "activity-data",
          title = "Data", 
          onclick = "switchToTab('data')", "📊"),
      div(class = "activity-item", id = "activity-diversity",
          title = "Diversity",
          onclick = "switchToTab('diversity')", "📈"),
      div(class = "activity-item", id = "activity-ordination",
          title = "Ordination",
          onclick = "switchToTab('ordination')", "🔵"),
      div(class = "spacer"),
      div(class = "activity-item", id = "activity-about",
          title = "About",
          onclick = "switchToTab('about')", "❓")
    ),
    
    # ============================================
    # Primary Sidebar (250px collapsible)
    # ============================================
    div(class = "primary-sidebar collapsed", id = "sidebar",
      div(class = "sidebar-header",
        span(class = "sidebar-title", "EXPLORER"),
        tags$button(onclick = "$('#sidebar').toggleClass('collapsed')", "◀")
      ),
      div(class = "sidebar-content",
        uiOutput("sidebar_content_ui")
      )
    ),
    
    # ============================================
    # Main Canvas
    # ============================================
    div(class = "main-canvas",
      
      # Breadcrumb
      div(class = "breadcrumb", 
        uiOutput("breadcrumb_ui")
      ),
      
      # Content area with Shiny tabs
      div(class = "content-area", style = "flex: 1; overflow-y: auto; padding: 20px;",
        tabsetPanel(
          id = "main_tabs",
          type = "hidden", # Hide default Shiny tabs, use activity bar instead
          
          # ============================================
          # HOME TAB
          # ============================================
          tabPanel("home",
            div(class = "home-page", style = "max-width: 1200px; margin: 0 auto; padding: 40px 20px;",
              div(style = "text-align: center; margin-bottom: 50px;",
                h1(style = "color: #2e8b57; font-size: 48px; margin: 0;", "Ö"),
                h2(style = "color: #ccc; font-size: 32px; margin: 10px 0;", "Ördin"),
                p(style = "color: #888; font-size: 16px;",
                  "An open-source cross-platform community ecology analysis software")
              ),
              
              div(style = "background: #252526; border-left: 4px solid #2e8b57; padding: 30px; margin: 40px 0;",
                h2(style = "color: #2e8b57; margin-top: 0;", "✨ What Makes Ördin Special"),
                tags$ul(style = "color: #ccc; font-size: 15px; line-height: 1.8;",
                  tags$li(strong("Open Source & Free"), " - No subscriptions, no paywalls"),
                  tags$li(strong("Desktop-First"), " - Works offline, your data stays local"),
                  tags$li(strong("Publication-Quality"), " - Export-ready figures and reports"),
                  tags$li(strong("Reproducible"), " - Complete methodology documentation")
                )
              ),
              
              div(class = "action-cards", style = "display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin: 40px 0;",
                div(class = "card", style = "background: #252526; border: 1px solid #3e3e42; padding: 30px; text-align: center; cursor: pointer;",
                    onclick = "switchToTab('data')",
                    div(style = "font-size: 48px; margin-bottom: 20px;", "📊"),
                    h3(style = "color: #2e8b57; margin: 0 0 10px 0;", "Import Data"),
                    p(style = "color: #888; font-size: 13px;", "Load CSV, Excel, or sample datasets"),
                    div(style = "color: #2e8b57; margin-top: 20px;", "Get Started →")
                ),
                div(class = "card", style = "background: #252526; border: 1px solid #3e3e42; padding: 30px; text-align: center; cursor: pointer;",
                    onclick = "switchToTab('diversity')",
                    div(style = "font-size: 48px; margin-bottom: 20px;", "📈"),
                    h3(style = "color: #2e8b57; margin: 0 0 10px 0;", "Diversity"),
                    p(style = "color: #888; font-size: 13px;", "iNEXT rarefaction & Hill numbers"),
                    div(style = "color: #2e8b57; margin-top: 20px;", "Analyze →")
                ),
                div(class = "card", style = "background: #252526; border: 1px solid #3e3e42; padding: 30px; text-align: center; cursor: pointer;",
                    onclick = "switchToTab('ordination')",
                    div(style = "font-size: 48px; margin-bottom: 20px;", "🔵"),
                    h3(style = "color: #2e8b57; margin: 0 0 10px 0;", "Ordination"),
                    p(style = "color: #888; font-size: 13px;", "NMDS, PCA, CA, DCA, PCoA"),
                    div(style = "color: #2e8b57; margin-top: 20px;", "Explore →")
                )
              )
            )
          ),
          
          # ============================================
          # DATA TAB
          # ============================================
          tabPanel("data",
            h2("📊 Data Management", style = "color: #2e8b57; margin-bottom: 20px;"),
            
            # Species composition data
            div(style = "background: #252526; padding: 20px; margin: 20px 0;",
              h3("1️⃣ Species Composition Data", style = "color: #2e8b57;"),
              fileInput("species_file", "Upload Species Data (CSV or Excel):",
                       accept = c(".csv", ".xlsx", ".xls")),
              tags$small(style = "color: #888;", 
                        "First column = Site names | Other columns = Species abundance"),
              hr(style = "border-color: #3e3e42;"),
              h4("Or Load Sample Dataset", style = "color: #ccc;"),
              selectInput("sample_dataset", NULL,
                         choices = c("None" = "", 
                                   "Dune Meadow (20×30)" = "dune",
                                   "Varespec (24×44)" = "varespec",
                                   "BCI (50×225)" = "BCI")),
              actionButton("load_sample", "▶ Load Sample Data", class = "btn-success")
            ),
            
            # Environmental data
            div(style = "background: #252526; padding: 20px; margin: 20px 0;",
              h3("2️⃣ Environmental Data (Optional)", style = "color: #2e8b57;"),
              fileInput("env_file", "Upload Environmental Data:",
                       accept = c(".csv", ".xlsx", ".xls")),
              conditionalPanel("output.env_data_loaded",
                div(style = "margin-top: 15px; padding: 10px; background: #1a3a2e; border-left: 3px solid #2e8b57;",
                  uiOutput("env_data_status")
                )
              )
            ),
            
            # Transformations
            div(style = "background: #252526; padding: 20px; margin: 20px 0;",
              h3("3️⃣ Data Transformations (Optional)", style = "color: #2e8b57;"),
              checkboxGroupInput("transformations", NULL,
                choices = c("Hellinger" = "hellinger",
                          "Wisconsin" = "wisconsin",
                          "Log (log1p)" = "log",
                          "Square root" = "sqrt")),
              actionButton("apply_transform", "▶ Apply", class = "btn-success"),
              actionButton("reset_data", "🔄 Reset", class = "btn-secondary", 
                          style = "margin-left: 10px;")
            ),
            
            # Data preview
            div(style = "margin-top: 30px;",
              h3("🔍 Data Preview", style = "color: #2e8b57;"),
              tabsetPanel(
                tabPanel("Species", DT::dataTableOutput("species_preview")),
                tabPanel("Environment", DT::dataTableOutput("env_preview")),
                tabPanel("Summary", uiOutput("data_summary"))
              )
            )
          ),
          
          # ============================================
          # DIVERSITY TAB
          # ============================================
          tabPanel("diversity",
            h2("🔬 Diversity Analysis", style = "color: #2e8b57; margin-bottom: 20px;"),
            selectInput("diversity_method", "Select Method:",
                       choices = c("Diversity Estimation (iNEXT)" = "estimation",
                                 "Diversity Indices" = "indices")),
            conditionalPanel("input.diversity_method == 'estimation'",
              diversity_estimation_ui("diversity_est")),
            conditionalPanel("input.diversity_method == 'indices'",
              diversity_indices_ui("diversity_idx"))
          ),
          
          # ============================================
          # ORDINATION TAB
          # ============================================
          tabPanel("ordination",
            h2("🗺️ Ordination Analysis", style = "color: #2e8b57; margin-bottom: 20px;"),
            selectInput("ordination_method", "Select Method:",
                       choices = c("NMDS" = "nmds", "PCA" = "pca",
                                 "CA" = "ca", "DCA" = "dca", "PCoA" = "pcoa")),
            conditionalPanel("input.ordination_method == 'nmds'", nmds_ui("nmds")),
            conditionalPanel("input.ordination_method == 'pca'", pca_ui("pca")),
            conditionalPanel("input.ordination_method == 'ca'", ca_ui("ca")),
            conditionalPanel("input.ordination_method == 'dca'", dca_ui("dca")),
            conditionalPanel("input.ordination_method == 'pcoa'", pcoa_ui("pcoa"))
          ),
          
          # ============================================
          # ABOUT TAB
          # ============================================
          tabPanel("about",
            tags$div(id = "about-content-container"),
            tags$script("
              $(document).ready(function() {
                if (typeof getAboutOrdinContent === 'function') {
                  $('#about-content-container').html(getAboutOrdinContent());
                }
              });
            ")
          )
        )
      ),
      
      # Status bar
      div(class = "status-bar",
        span("Ördin v3.0"),
        span("R 4.5.1"),
        span(id = "data-status", "No data loaded")
      )
    ),
    
    # ============================================
    # Right Panel (Properties - collapsed by default)
    # ============================================
    div(class = "right-panel collapsed", id = "rightPanel",
      div(class = "panel-header",
        span("PROPERTIES"),
        tags$button(onclick = "$('#rightPanel').toggleClass('collapsed')", "▶")
      ),
      div(class = "panel-content",
        uiOutput("right_panel_content")
      )
    )
  )
)

# ============================================
# SERVER
# ============================================
server <- function(input, output, session) {
  
  # Hide loading screen
  Sys.sleep(1)
  waiter_hide()
  
  # Reactive values
  community_data <- reactiveVal(NULL)
  environmental_data <- reactiveVal(NULL)
  original_data <- reactiveVal(NULL)
  applied_transformations <- reactiveVal(NULL)
  
  # ============================================
  # BREADCRUMB UI
  # ============================================
  output$breadcrumb_ui <- renderUI({
    current_tab <- input$main_tabs %||% "home"
    breadcrumbs <- list(
      home = "Home → Dashboard",
      data = "Data → Management",
      diversity = "Analysis → Diversity",
      ordination = "Analysis → Ordination",
      about = "Help → About Ördin"
    )
    HTML(breadcrumbs[[current_tab]] %||% "Home")
  })
  
  # ============================================
  # SIDEBAR CONTENT (Dynamic per tab)
  # ============================================
  output$sidebar_content_ui <- renderUI({
    current_tab <- input$main_tabs %||% "home"
    
    switch(current_tab,
      "home" = div(
        div(class = "section",
          div(class = "section-header", "▼ QUICK START"),
          div(class = "section-content",
            div(class = "item", onclick = "switchToTab('data')", "📊 Import Data"),
            div(class = "item", onclick = "switchToTab('diversity')", "📈 Run Analysis"),
            div(class = "item", onclick = "switchToTab('about')", "📖 Learn More")
          )
        )
      ),
      
      "data" = div(
        div(class = "section",
          div(class = "section-header", "▼ DATA SOURCES"),
          div(class = "section-content",
            div(class = "item", 
                if (!is.null(community_data())) 
                  span(class = "badge success", "✓ Loaded") 
                else 
                  span(class = "badge", "Not loaded"),
                " Species Data"),
            div(class = "item",
                if (!is.null(environmental_data())) 
                  span(class = "badge success", "✓ Loaded")
                else
                  span(class = "badge", "Optional"),
                " Environment Data")
          )
        ),
        div(class = "section",
          div(class = "section-header", "▼ TRANSFORMATIONS"),
          div(class = "section-content",
            if (!is.null(applied_transformations())) {
              div(class = "item", 
                  span(class = "badge success", "Active"),
                  " ", paste(applied_transformations(), collapse = ", "))
            } else {
              div(class = "item", span(class = "badge", "None"), " No transformations")
            }
          )
        )
      ),
      
      "diversity" = div(
        div(class = "section",
          div(class = "section-header", "▼ ANALYSIS TYPE"),
          div(class = "section-content",
            div(class = "item", "📈 iNEXT Estimation"),
            div(class = "item", "📊 Diversity Indices")
          )
        )
      ),
      
      "ordination" = div(
        div(class = "section",
          div(class = "section-header", "▼ METHODS"),
          div(class = "section-content",
            div(class = "item", "🔵 NMDS"),
            div(class = "item", "🔷 PCA"),
            div(class = "item", "🔶 CA"),
            div(class = "item", "🟦 DCA"),
            div(class = "item", "⬡ PCoA")
          )
        )
      ),
      
      "about" = div(
        div(class = "section",
          div(class = "section-header", "▼ INFORMATION"),
          div(class = "section-content",
            div(class = "item", "ℹ️ Version 3.0"),
            div(class = "item", "👤 Jimmy Moses"),
            div(class = "item", "🎓 PNG UoT")
          )
        )
      ),
      
      # Default
      div(class = "section",
        div(class = "section-header", "▼ EXPLORER"),
        div(class = "section-content",
          div(class = "item", "Welcome to Ördin")
        )
      )
    )
  })
  
  # ============================================
  # RIGHT PANEL CONTENT
  # ============================================
  output$right_panel_content <- renderUI({
    if (!is.null(community_data())) {
      div(
        div(class = "prop-section",
          h4("Dataset Info"),
          div(class = "prop-item",
            tags$label("Sites:"),
            span(nrow(community_data()))
          ),
          div(class = "prop-item",
            tags$label("Species:"),
            span(ncol(community_data()))
          ),
          div(class = "prop-item",
            tags$label("Total:"),
            span(sum(community_data()))
          )
        )
      )
    } else {
      div(class = "prop-section",
        p(style = "color: #888; font-size: 12px;", "No data loaded")
      )
    }
  })
  
  # ============================================
  # DATA LOADING
  # ============================================
  observeEvent(input$load_sample, {
    req(input$sample_dataset)
    data(list = input$sample_dataset, package = "vegan")
    dataset <- get(input$sample_dataset)
    community_data(dataset)
    original_data(dataset)
    
    # Load env data if available
    if (input$sample_dataset == "dune") {
      data("dune.env", package = "vegan")
      environmental_data(dune.env)
    } else if (input$sample_dataset == "varespec") {
      data("varechem", package = "vegan")
      environmental_data(varechem)
    }
    
    showNotification("✓ Data loaded successfully", type = "message")
  })
  
  observeEvent(input$species_file, {
    req(input$species_file)
    ext <- tools::file_ext(input$species_file$name)
    data <- if (ext == "csv") {
      read.csv(input$species_file$datapath, row.names = 1)
    } else {
      df <- readxl::read_excel(input$species_file$datapath)
      rownames(df) <- df[[1]]
      as.data.frame(df[,-1])
    }
    community_data(data)
    original_data(data)
    showNotification("✓ Species data loaded", type = "message")
  })
  
  observeEvent(input$env_file, {
    req(input$env_file, community_data())
    ext <- tools::file_ext(input$env_file$name)
    data <- if (ext == "csv") {
      read.csv(input$env_file$datapath, row.names = 1)
    } else {
      df <- readxl::read_excel(input$env_file$datapath)
      rownames(df) <- df[[1]]
      as.data.frame(df[,-1])
    }
    environmental_data(data)
    showNotification("✓ Environmental data loaded", type = "message")
  })
  
  # Data transformations
  observeEvent(input$apply_transform, {
    req(community_data(), input$transformations)
    data <- original_data()
    for (trans in input$transformations) {
      data <- switch(trans,
        hellinger = decostand(data, "hellinger"),
        wisconsin = wisconsin(data),
        log = log1p(data),
        sqrt = sqrt(data),
        data)
    }
    community_data(data)
    applied_transformations(input$transformations)
    showNotification("✓ Transformations applied", type = "message")
  })
  
  observeEvent(input$reset_data, {
    req(original_data())
    community_data(original_data())
    applied_transformations(NULL)
    showNotification("✓ Data reset", type = "message")
  })
  
  # Data previews
  output$species_preview <- DT::renderDataTable({
    req(community_data())
    DT::datatable(community_data(), options = list(pageLength = 10, scrollX = TRUE))
  })
  
  output$env_preview <- DT::renderDataTable({
    req(environmental_data())
    DT::datatable(environmental_data(), options = list(pageLength = 10, scrollX = TRUE))
  })
  
  output$env_data_loaded <- reactive(!is.null(environmental_data()))
  outputOptions(output, "env_data_loaded", suspendWhenHidden = FALSE)
  
  output$env_data_status <- renderUI({
    HTML(sprintf('<p style="color: #2e8b57; margin: 0;">✓ %d variables loaded</p>', 
                ncol(environmental_data())))
  })
  
  output$data_summary <- renderUI({
    req(community_data())
    HTML(sprintf('<div style="padding: 20px;"><h4 style="color: #2e8b57;">Summary</h4>
                  <p style="color: #ccc;">Sites: %d<br>Species: %d<br>Total abundance: %.0f</p></div>',
                 nrow(community_data()), ncol(community_data()), sum(community_data())))
  })
  
  # Call module servers
  diversity_estimation_server("diversity_est", data = community_data)
  diversity_indices_server("diversity_idx", data = community_data)
  nmds_server("nmds", data = community_data)
  pca_server("pca", data = community_data)
  ca_server("ca", data = community_data)
  dca_server("dca", data = community_data)
  pcoa_server("pcoa", data = community_data)
}

# Run app
shinyApp(ui, server)
