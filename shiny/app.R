# Ördin v3.0 - Production Shiny App
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# EXACT PROTOTYPE REPLICATION - No Shiny tabsetPanel, pure HTML/JS structure

library(shiny)
library(vegan)
library(iNEXT)
library(ggplot2)
library(DT)
library(shinyjs)
library(waiter)
library(shinyFeedback)
library(readr)
library(readxl)
library(dplyr)
library(tidyr)

# Source all modules
source("modules/ordination_nmds_module.R")
source("modules/ordination_pca_module.R")
source("modules/ordination_ca_module.R")
source("modules/ordination_dca_module.R")
source("modules/ordination_pcoa_module.R")
source("modules/diversity_estimation_module.R")
source("modules/diversity_indices_module.R")

# UI - EXACT PROTOTYPE HTML STRUCTURE
ui <- function(req) {
  tagList(
    tags$head(
      tags$meta(charset = "UTF-8"),
      tags$meta(name = "viewport", content = "width=device-width, initial-scale=1.0"),
      tags$title("Ördin v3.0"),
      tags$link(rel = "stylesheet", href = "prototype-styles.css"),
      tags$link(rel = "stylesheet", href = "window-controls.css")
    ),
    
    useShinyjs(),
    useShinyFeedback(),
    use_waiter(),
    
    # Load JavaScript files (with cache-busting version)
    tags$script(src = "validation.js?v=2"),
    tags$script(src = "statistical-interpretation.js?v=2"),
    tags$script(src = "about-ordin-content.js?v=2"),
    tags$script(src = "shiny-ui.js?v=2"),
    
    # Loading screen
    waiter_show_on_load(
      html = tagList(
        spin_loaders(42, color = "#2e8b57"),
        h2("Ördin", style = "color: #2e8b57; margin-top: 30px;"),
        p("Loading application...", style = "color: #999;")
      ),
      color = "#1a1a1a"
    ),
    
    # Skip link for accessibility
    tags$a(href = "#main-content", class = "skip-link", "Skip to main content"),
    
    # ============== TITLE BAR ==============
    div(class = "titlebar",
      div(class = "titlebar-left",
        span(class = "app-icon", "Ö"),
        span(class = "app-title", "Ördin v3.0"),
        span(class = "divider", "|"),
        span(class = "dataset-name", "📄 species_data.csv")
      ),
      div(class = "titlebar-center",
        span(class = "status-badge", "● Ready")
      ),
      div(class = "titlebar-right",
        span(class = "user-info", "👤 Jimmy Moses"),
        tags$button(class = "window-btn", onclick = "location.reload()", title = "Reload", "🔄"),
        tags$button(class = "window-btn", onclick = "if(window.electronAPI) window.electronAPI.minimizeWindow()", title = "Minimize", "—"),
        tags$button(class = "window-btn", onclick = "if(window.electronAPI) window.electronAPI.maximizeWindow()", title = "Maximize", "□"),
        tags$button(class = "window-btn close", onclick = "if(window.electronAPI) window.electronAPI.closeWindow()", title = "Close", "×")
      )
    ),
    
    # ============== MAIN CONTAINER ==============
    div(class = "main-container",
      
      # ACTIVITY BAR
      div(class = "activity-bar",
        div(class = "activity-item active", onclick = "switchView('home')", title = "Home", "🏠"),
        div(class = "activity-item", onclick = "switchView('data')", title = "Data", "📊"),
        div(class = "activity-item", onclick = "switchView('diversity')", title = "Diversity", "📈"),
        div(class = "activity-item", onclick = "switchView('ordination')", title = "Ordination", "🔵"),
        div(class = "activity-item", onclick = "switchView('results')", title = "Results", "📋"),
        div(class = "activity-item", onclick = "switchRightPanel('properties')", title = "Properties", "🔧"),
        div(class = "spacer"),
        div(class = "activity-item", onclick = "switchView('settings')", title = "Settings", "⚙️"),
        div(class = "activity-item", onclick = "switchView('help')", title = "Help", "❓")
      ),
      
      # PRIMARY SIDEBAR (starts collapsed like prototype)
      div(class = "primary-sidebar collapsed", id = "sidebar",
        div(class = "sidebar-header",
          span(class = "sidebar-title", "EXPLORER"),
          tags$button(onclick = "toggleSidebar()", "◀")
        ),
        div(class = "sidebar-content", id = "sidebar-content",
          # Default HOME content
          div(class = "section",
            div(class = "section-header", "▼ DATA SOURCES"),
            div(class = "section-content",
              div(class = "item active", "📄 species_data.csv"),
              div(class = "item", "📥 Import New File"),
              div(class = "item", "📚 Sample Datasets")
            )
          ),
          div(class = "section",
            div(class = "section-header", "▼ WORKSPACE"),
            div(class = "section-content",
              div(class = "item", "📊 Current Dataset ", span(class = "badge", "45×12")),
              div(class = "item", "ℹ️ Metadata"),
              div(class = "item", "✅ Validation ", span(class = "badge success", "OK"))
            )
          ),
          div(class = "section",
            div(class = "section-header", "▼ RECENT"),
            div(class = "section-content",
              div(class = "item", "📈 iNEXT analysis ", span(class = "badge", "2m"))
            )
          )
        )
      ),
      
      # MAIN CANVAS
      div(class = "main-canvas",
        
        # Breadcrumb
        div(class = "breadcrumb", "Home → Dashboard"),
        
        # Tab Bar
        div(class = "tab-bar", id = "tabBar",
          div(class = "tab active", `data-tab-id` = "dashboard", onclick = "switchToTab('dashboard')",
            "🏠 Dashboard ",
            span(class = "tab-close", onclick = "closeTab(event, 'dashboard')", "×")
          )
        ),
        
        # Content Area
        div(class = "content-area", id = "contentArea",
          
          # Dashboard Tab Content
          div(id = "tab-dashboard", class = "tab-content active",
            div(class = "welcome",
              h1("Ö"),
              h2("Ördin"),
              p("An open-source cross-platform community ecology analysis software")
            ),
            
            div(style = "max-width: 700px; margin: 30px auto; background: #252526; border-left: 3px solid #2e8b57; padding: 24px;",
              h3(style = "color: #2e8b57; margin-top: 0; margin-bottom: 16px; font-size: 16px;", "✨ What Makes Ördin Special"),
              p(style = "color: #888; font-size: 13px; line-height: 1.8; margin-bottom: 12px;", "Most software either:"),
              tags$ul(style = "color: #888; font-size: 13px; line-height: 1.8; margin-left: 20px; margin-bottom: 16px;",
                tags$li(tags$strong(style = "color: #ccc;", "Prioritizes ease-of-use"), " → sacrifices rigor"),
                tags$li(tags$strong(style = "color: #ccc;", "Prioritizes rigor"), " → sacrifices usability")
              ),
              p(style = "color: #2e8b57; font-size: 14px; font-weight: 600; margin: 0 0 20px 0;",
                HTML("<span style='font-size: 18px;'>Ö</span>rdin does both - that's why it scores 96%!")),
              div(style = "text-align: center;",
                tags$button(
                  onclick = "showAboutOrdin()",
                  style = "background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;",
                  "📚 Learn More →"
                )
              )
            ),
            
            div(class = "action-cards",
              div(class = "card",
                h3("📥 Import Data"),
                p("Load CSV, Excel, or sample datasets"),
                tags$button(onclick = "switchView('data')", "Get Started →")
              ),
              div(class = "card",
                h3("📈 Diversity"),
                p("iNEXT rarefaction & Hill numbers"),
                tags$button(onclick = "createNewTab('diversity', '📈 Diversity Analysis', 'diversity')", "Analyze →")
              ),
              div(class = "card",
                h3("🔵 Ordination"),
                p("NMDS, PCA, CA, DCA analysis"),
                tags$button(onclick = "createNewTab('nmds', '🗺️ NMDS Results', 'results')", "Explore →")
              )
            )
          ),
          
          # DATA TAB (hidden by default, shown by JS)
          div(id = "tab-data", class = "tab-content", style = "display: none;",
            h2(style = "color: #2e8b57; margin-bottom: 20px;", "📊 Data Management"),
            
            div(style = "background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;",
              h3(style = "color: #cccccc; margin-bottom: 16px;", "1️⃣ Species Composition Data"),
              fileInput("species_file", "Upload Species Data (CSV or Excel):",
                       accept = c(".csv", ".xlsx", ".xls")),
              tags$small(style = "color: #888;", "First column = Site names | Other columns = Species abundance"),
              
              div(style = "border-top: 1px solid #3e3e42; padding-top: 20px; margin-top: 20px;",
                h4(style = "color: #ccc;", "Or Load Sample Dataset"),
                selectInput("sample_dataset", "Choose sample:",
                           choices = c("None" = "", "Dune Meadow" = "dune", "Varespec" = "varespec", "BCI" = "BCI")),
                actionButton("load_sample", "▶ Load Sample Data", class = "btn-success")
              )
            ),
            
            div(style = "background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;",
              h3(style = "color: #cccccc; margin-bottom: 16px;", "2️⃣ Environmental Data (Optional)"),
              fileInput("env_file", "Upload Environmental Data:", accept = c(".csv", ".xlsx", ".xls"))
            ),
            
            div(style = "margin-top: 30px;",
              h3(style = "color: #2e8b57;", "🔍 Data Preview"),
              DT::dataTableOutput("species_preview")
            )
          ),
          
          # DIVERSITY TAB (hidden by default)
          div(id = "tab-diversity", class = "tab-content", style = "display: none;",
            h2(style = "color: #2e8b57; margin-bottom: 20px;", "🔬 Diversity Analysis"),
            selectInput("diversity_method", "Select Method:",
                       choices = c("Diversity Estimation (iNEXT)" = "estimation",
                                  "Diversity Indices (Shannon, Simpson)" = "indices")),
            conditionalPanel("input.diversity_method == 'estimation'",
              diversity_estimation_ui("diversity_est")),
            conditionalPanel("input.diversity_method == 'indices'",
              diversity_indices_ui("diversity_idx"))
          ),
          
          # ORDINATION TAB (hidden by default)
          div(id = "tab-ordination", class = "tab-content", style = "display: none;",
            h2(style = "color: #2e8b57; margin-bottom: 20px;", "🗺️ Ordination Analysis"),
            selectInput("ordination_method", "Select Method:",
                       choices = c("NMDS" = "nmds", "PCA" = "pca", "CA" = "ca", "DCA" = "dca", "PCoA" = "pcoa")),
            conditionalPanel("input.ordination_method == 'nmds'", nmds_ui("nmds")),
            conditionalPanel("input.ordination_method == 'pca'", pca_ui("pca")),
            conditionalPanel("input.ordination_method == 'ca'", ca_ui("ca")),
            conditionalPanel("input.ordination_method == 'dca'", dca_ui("dca")),
            conditionalPanel("input.ordination_method == 'pcoa'", pcoa_ui("pcoa"))
          ),
          
          # RESULTS TAB
          div(id = "tab-results", class = "tab-content", style = "display: none;",
            h2(style = "color: #2e8b57; margin-bottom: 20px;", "📋 Analysis Results"),
            div(style = "background: #252526; padding: 30px; text-align: center;",
              div(style = "font-size: 64px; margin-bottom: 20px;", "📋"),
              h3(style = "color: #888;", "No results yet"),
              p(style = "color: #666;", "Run an analysis to see results here")
            )
          ),
          
          # SETTINGS TAB
          div(id = "tab-settings", class = "tab-content", style = "display: none;",
            h2(style = "color: #2e8b57; margin-bottom: 20px;", "⚙️ Settings"),
            div(style = "background: #252526; padding: 20px;",
              h3(style = "color: #ccc;", "Application Preferences"),
              p(style = "color: #888;", "Configure Ördin settings")
            )
          ),
          
          # HELP TAB
          div(id = "tab-help", class = "tab-content", style = "display: none;",
            tags$div(id = "about-content-container"),
            tags$script("
              $(document).ready(function() {
                if (typeof getAboutOrdinContent === 'function') {
                  $('#about-content-container').html(getAboutOrdinContent());
                }
              });
            ")
          )
        ),
        
        # STATUS BAR
        div(class = "status-bar",
          span("Ln 1, Col 1"),
          span("UTF-8"),
          span("R 4.5.1")
        )
      ),
      
      # RIGHT PANEL (Properties - starts collapsed)
      div(class = "right-panel collapsed", id = "rightPanel",
        div(class = "panel-header",
          span("PROPERTIES"),
          tags$button(onclick = "toggleRightPanel()", "▶")
        ),
        div(class = "panel-content",
          div(class = "prop-section",
            h4("Dataset Info"),
            div(class = "prop-item",
              tags$label("Rows:"),
              span("45")
            ),
            div(class = "prop-item",
              tags$label("Columns:"),
              span("12")
            ),
            div(class = "prop-item",
              tags$label("Type:"),
              span("Abundance")
            )
          ),
          div(class = "prop-section",
            h4("Quick Actions"),
            tags$button(class = "action-btn", "Export CSV"),
            tags$button(class = "action-btn", "Export Excel"),
            tags$button(class = "action-btn", "View Metadata")
          )
        )
      )
    )
  )
}

# SERVER
server <- function(input, output, session) {
  
  # Hide loading screen after 2 seconds
  waiter_hide()
  
  # Call module servers
  diversity_estimation_server("diversity_est")
  diversity_indices_server("diversity_idx")
  nmds_server("nmds")
  pca_server("pca")
  ca_server("ca")
  dca_server("dca")
  pcoa_server("pcoa")
  
  # Sample data loading
  observeEvent(input$load_sample, {
    req(input$sample_dataset)
    
    if (input$sample_dataset == "dune") {
      data(dune, package = "vegan")
      output$species_preview <- DT::renderDataTable({
        DT::datatable(dune, options = list(pageLength = 10, scrollX = TRUE))
      })
    } else if (input$sample_dataset == "varespec") {
      data(varespec, package = "vegan")
      output$species_preview <- DT::renderDataTable({
        DT::datatable(varespec, options = list(pageLength = 10, scrollX = TRUE))
      })
    } else if (input$sample_dataset == "BCI") {
      data(BCI, package = "vegan")
      output$species_preview <- DT::renderDataTable({
        DT::datatable(BCI, options = list(pageLength = 10, scrollX = TRUE))
      })
    }
  })
  
  # File upload handling
  observeEvent(input$species_file, {
    req(input$species_file)
    
    ext <- tools::file_ext(input$species_file$name)
    
    species_data <- tryCatch({
      if (ext == "csv") {
        read_csv(input$species_file$datapath)
      } else if (ext %in% c("xlsx", "xls")) {
        read_excel(input$species_file$datapath)
      }
    }, error = function(e) {
      showNotification(paste("Error loading file:", e$message), type = "error")
      NULL
    })
    
    if (!is.null(species_data)) {
      output$species_preview <- DT::renderDataTable({
        DT::datatable(species_data, options = list(pageLength = 10, scrollX = TRUE))
      })
    }
  })
}

# Run app
shinyApp(ui, server)
