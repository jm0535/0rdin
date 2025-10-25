# Ördin v3.0 - EXACT PROTOTYPE REPLICATION
# Author: Jimmy Moses (jmoses@pnguot.ac.pg)
# Complete rebuild to match prototype HTML structure EXACTLY

library(shiny)
library(bslib)
library(vegan)
library(iNEXT)
library(ggplot2)
library(DT)
library(shinyjs)
library(waiter)
# library(shinyFeedback)  # Temporarily disabled - conflicts with custom HTML structure

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
      tags$link(rel = "stylesheet", href = "shiny-layout-fix.css"),
      tags$link(rel = "stylesheet", href = "custom.css"),
      tags$link(rel = "stylesheet", href = "styles.css")
    ),
    
    useShinyjs(),
    use_waiter(),
    # useShinyFeedback(),  # Temporarily disabled - conflicts with custom HTML structure
    
    # Suppress shinyFeedback JavaScript errors
    tags$script(HTML("
      window.addEventListener('error', function(e) {
        if (e.message && e.message.includes('shinyfeedback')) {
          e.preventDefault();
          return true;
        }
      });
    ")),
    
    # Include JS
    tags$script(src = "validation.js"),
    tags$script(src = "statistical-interpretation.js"),
    tags$script(src = "about-ordin-content.js"),
    tags$script(src = "prototype.js"),
    
    # Custom Shiny-prototype integration JS
    tags$script(HTML("
      $(document).ready(function() {
        // Toggle sidebar
        window.toggleSidebar = function() {
          $('#sidebar').toggleClass('collapsed');
        };
        
        // Toggle right panel
        window.toggleRightPanel = function() {
          $('#rightPanel').toggleClass('collapsed');
        };
        
        // Switch view with Shiny integration
        window.switchView = function(view) {
          Shiny.setInputValue('current_view', view, {priority: 'event'});
          Shiny.setInputValue('main_tabs', view, {priority: 'event'});
          
          // Update activity bar
          $('.activity-item').removeClass('active');
          $('#activity-' + view).addClass('active');
          
          // Open sidebar if collapsed
          $('#sidebar').removeClass('collapsed');
          
          // Update sidebar title
          var titles = {
            'home': 'EXPLORER',
            'data': 'DATA MANAGER',
            'diversity': 'DIVERSITY',
            'ordination': 'ORDINATION',
            'results': 'RESULTS',
            'settings': 'SETTINGS',
            'about': 'HELP'
          };
          $('.sidebar-title').text(titles[view] || 'EXPLORER');
        };
        
        // Set initial state
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
    
    # Skip link for accessibility
    tags$a(href = "#main-content", class = "skip-link", "Skip to main content"),
    
    # ============== TITLE BAR ==============
    div(class = "titlebar",
      div(class = "titlebar-left",
        span(class = "app-icon", "Ö"),
        span(class = "app-title", "Ördin v3.0"),
        span(class = "divider", "|"),
        uiOutput("dataset_display_name", inline = TRUE)
      ),
      div(class = "titlebar-center",
        span(class = "status-badge", "● Ready")
      ),
      div(class = "titlebar-right",
        span(class = "user-info", "👤 Jimmy Moses"),
        div(class = "window-controls",
          tags$button(class = "window-btn", onclick = "if(window.electronAPI) window.electronAPI.minimizeWindow()", title = "Minimize", "—"),
          tags$button(class = "window-btn", onclick = "if(window.electronAPI) window.electronAPI.maximizeWindow()", title = "Maximize", "□"),
          tags$button(class = "window-btn close", onclick = "if(window.electronAPI) window.electronAPI.closeWindow()", title = "Close", "×")
        )
      )
    ),
    
    # ============== MAIN CONTAINER ==============
    div(class = "main-container",
      
      # ACTIVITY BAR
      div(class = "activity-bar",
        div(class = "activity-item", id = "activity-home", 
            title = "Home", onclick = "switchView('home')", "🏠"),
        div(class = "activity-item", id = "activity-data",
            title = "Data", onclick = "switchView('data')", "📊"),
        div(class = "activity-item", id = "activity-diversity",
            title = "Diversity", onclick = "switchView('diversity')", "📈"),
        div(class = "activity-item", id = "activity-ordination",
            title = "Ordination", onclick = "switchView('ordination')", "🔵"),
        div(class = "activity-item", id = "activity-results",
            title = "Results", onclick = "switchView('results')", "📋"),
        div(class = "activity-item", id = "activity-properties",
            title = "Properties", onclick = "toggleRightPanel()", "🔧"),
        div(class = "spacer"),
        div(class = "activity-item", id = "activity-settings",
            title = "Settings", onclick = "switchView('settings')", "⚙️"),
        div(class = "activity-item", id = "activity-about",
            title = "Help", onclick = "switchView('about')", "❓")
      ),
      
      # PRIMARY SIDEBAR
      div(class = "primary-sidebar collapsed", id = "sidebar",
        div(class = "sidebar-header",
          span(class = "sidebar-title", "EXPLORER"),
          tags$button(onclick = "toggleSidebar()", "◀")
        ),
        div(class = "sidebar-content",
          uiOutput("sidebar_content_dynamic")
        )
      ),
      
      # MAIN CANVAS
      div(class = "main-canvas",
        
        # Breadcrumb
        div(class = "breadcrumb",
          uiOutput("breadcrumb_display", inline = TRUE)
        ),
        
        # Tab Bar
        div(class = "tab-bar", id = "tabBar",
          div(class = "tab active", "🏠 Dashboard")
        ),
        
        # Content Area
        div(class = "content-area", id = "main-content",
          tabsetPanel(
            id = "main_tabs",
            type = "hidden",
            
            # HOME TAB
            tabPanel("home",
              div(class = "tab-content active", id = "tab-dashboard",
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
                    HTML("<span style='font-size: 18px;'>Ö</span>rdin does both - that's why it scores 96%!"))
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
                    tags$button(onclick = "switchView('diversity')", "Analyze →")
                  ),
                  div(class = "card",
                    h3("🔵 Ordination"),
                    p("NMDS, PCA, CA, DCA analysis"),
                    tags$button(onclick = "switchView('ordination')", "Explore →")
                  )
                )
              )
            ),
            
            # DATA TAB
            tabPanel("data",
              div(class = "tab-content",
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
              )
            ),
            
            # DIVERSITY TAB
            tabPanel("diversity",
              div(class = "tab-content",
                h2(style = "color: #2e8b57; margin-bottom: 20px;", "🔬 Diversity Analysis"),
                selectInput("diversity_method", "Select Method:",
                           choices = c("Diversity Estimation (iNEXT)" = "estimation",
                                      "Diversity Indices (Shannon, Simpson)" = "indices")),
                conditionalPanel("input.diversity_method == 'estimation'",
                  diversity_estimation_ui("diversity_est")),
                conditionalPanel("input.diversity_method == 'indices'",
                  diversity_indices_ui("diversity_idx"))
              )
            ),
            
            # ORDINATION TAB
            tabPanel("ordination",
              div(class = "tab-content",
                h2(style = "color: #2e8b57; margin-bottom: 20px;", "🗺️ Ordination Analysis"),
                selectInput("ordination_method", "Select Method:",
                           choices = c("NMDS" = "nmds", "PCA" = "pca", "CA" = "ca", "DCA" = "dca", "PCoA" = "pcoa")),
                conditionalPanel("input.ordination_method == 'nmds'", nmds_ui("nmds")),
                conditionalPanel("input.ordination_method == 'pca'", pca_ui("pca")),
                conditionalPanel("input.ordination_method == 'ca'", ca_ui("ca")),
                conditionalPanel("input.ordination_method == 'dca'", dca_ui("dca")),
                conditionalPanel("input.ordination_method == 'pcoa'", pcoa_ui("pcoa"))
              )
            ),
            
            # RESULTS TAB
            tabPanel("results",
              div(class = "tab-content",
                h2(style = "color: #2e8b57; margin-bottom: 20px;", "📋 Analysis Results"),
                div(style = "background: #252526; padding: 30px; text-align: center;",
                  div(style = "font-size: 64px; margin-bottom: 20px;", "📋"),
                  h3(style = "color: #888;", "No results yet"),
                  p(style = "color: #666;", "Run an analysis to see results here")
                )
              )
            ),
            
            # SETTINGS TAB
            tabPanel("settings",
              div(class = "tab-content",
                h2(style = "color: #2e8b57; margin-bottom: 20px;", "⚙️ Settings"),
                div(style = "background: #252526; padding: 20px;",
                  h3(style = "color: #ccc;", "Application Preferences"),
                  p(style = "color: #888;", "Configure Ördin settings")
                )
              )
            ),
            
            # ABOUT TAB
            tabPanel("about",
              div(class = "tab-content",
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
          )
        ),
        
        # STATUS BAR
        div(class = "status-bar",
          span("Ln 1, Col 1"),
          span("UTF-8"),
          span("R 4.5.1"),
          uiOutput("status_info_right", inline = TRUE)
        )
      ),
      
      # RIGHT PANEL (Properties)
      div(class = "right-panel collapsed", id = "rightPanel",
        div(class = "panel-header",
          span("PROPERTIES"),
          tags$button(onclick = "toggleRightPanel()", "▶")
        ),
        div(class = "panel-content",
          uiOutput("right_panel_properties")
        )
      )
    )
  )
}

# SERVER
server <- function(input, output, session) {
  
  # Hide loading screen
  Sys.sleep(1)
  waiter_hide()
  
  # Reactive data
  community_data <- reactiveVal(NULL)
  environmental_data <- reactiveVal(NULL)
  
  # Dataset display name
  output$dataset_display_name <- renderUI({
    if (is.null(community_data())) {
      span(class = "dataset-name", "📄 No data loaded")
    } else {
      span(class = "dataset-name", "📄 species_data.csv")
    }
  })
  
  # Breadcrumb
  output$breadcrumb_display <- renderUI({
    current_view <- input$current_view %||% "home"
    breadcrumbs <- list(
      "home" = "Home → Dashboard",
      "data" = "Data → Import & Manage",
      "diversity" = "Analysis → Diversity Estimation",
      "ordination" = "Analysis → Ordination",
      "results" = "Results → Export History",
      "settings" = "Settings → Application",
      "about" = "Help → Documentation"
    )
    HTML(breadcrumbs[[current_view]] %||% "Home → Dashboard")
  })
  
  # Dynamic sidebar content
  output$sidebar_content_dynamic <- renderUI({
    current_view <- input$current_view %||% "home"
    
    switch(current_view,
      "home" = tagList(
        div(class = "section",
          div(class = "section-header", "▼ DATA SOURCES"),
          div(class = "section-content",
            div(class = "item", if (!is.null(community_data())) span(class = "badge success", "✓") else "", " species_data.csv"),
            div(class = "item", "📥 Import New File"),
            div(class = "item", "📚 Sample Datasets")
          )
        ),
        div(class = "section",
          div(class = "section-header", "▼ WORKSPACE"),
          div(class = "section-content",
            div(class = "item", "📊 Current Dataset ", 
                if (!is.null(community_data())) span(class = "badge", paste0(nrow(community_data()), "×", ncol(community_data()))) else ""),
            div(class = "item", "ℹ️ Metadata"),
            div(class = "item", "✅ Validation ", if (!is.null(community_data())) span(class = "badge success", "OK") else "")
          )
        ),
        div(class = "section",
          div(class = "section-header", "▼ RECENT"),
          div(class = "section-content",
            div(class = "item", "📈 iNEXT analysis ", span(class = "badge", "2m")),
            div(class = "item", "🔵 NMDS analysis ", span(class = "badge", "1h"))
          )
        )
      ),
      "data" = tagList(
        div(class = "section",
          div(class = "section-header", "▼ IMPORT OPTIONS"),
          div(class = "section-content",
            div(class = "item", "💻 Local File (CSV)"),
            div(class = "item", "💻 Local File (Excel)"),
            div(class = "item", "📚 Sample Datasets")
          )
        )
      ),
      "diversity" = tagList(
        div(class = "section",
          div(class = "section-header", "▼ ANALYSIS TYPE"),
          div(class = "section-content",
            div(class = "item active", "📈 Diversity Estimation (iNEXT)"),
            div(class = "item", "📊 Diversity Indices (vegan)")
          )
        )
      ),
      "ordination" = tagList(
        div(class = "section",
          div(class = "section-header", "▼ METHODS"),
          div(class = "section-content",
            div(class = "item active", "🔵 NMDS"),
            div(class = "item", "🔷 PCA"),
            div(class = "item", "🔶 CA"),
            div(class = "item", "🟦 DCA"),
            div(class = "item", "⬡ PCoA")
          )
        )
      ),
      tagList(
        div(class = "section",
          div(class = "section-header", "▼ OPTIONS"),
          div(class = "section-content",
            div(class = "item", "⚙️ Configure")
          )
        )
      )
    )
  })
  
  # Right panel properties
  output$right_panel_properties <- renderUI({
    if (is.null(community_data())) {
      div(class = "prop-section",
        h4("No Dataset Loaded"),
        p(style = "color: #888; font-size: 12px;", "Load data to see properties")
      )
    } else {
      tagList(
        div(class = "prop-section",
          h4("Dataset Info"),
          div(class = "prop-item", tags$label("Rows:"), span(nrow(community_data()))),
          div(class = "prop-item", tags$label("Columns:"), span(ncol(community_data()))),
          div(class = "prop-item", tags$label("Type:"), span("Abundance"))
        ),
        div(class = "prop-section",
          h4("Quick Actions"),
          tags$button(class = "action-btn", "Export CSV"),
          tags$button(class = "action-btn", "Export Excel"),
          tags$button(class = "action-btn", "View Metadata")
        )
      )
    }
  })
  
  # Status bar info
  output$status_info_right <- renderUI({
    if (!is.null(community_data())) {
      span(style = "margin-left: auto;", paste0("Dataset: ", nrow(community_data()), " sites × ", ncol(community_data()), " species"))
    }
  })
  
  # Load sample data
  observeEvent(input$load_sample, {
    req(input$sample_dataset)
    tryCatch({
      data(list = input$sample_dataset, package = "vegan")
      dataset <- get(input$sample_dataset)
      community_data(dataset)
      showNotification(sprintf("✓ Loaded %s: %d sites × %d species", 
                input$sample_dataset, nrow(dataset), ncol(dataset)), type = "message")
    }, error = function(e) {
      showNotification(paste("❌ Error:", e$message), type = "error")
    })
  })
  
  # Upload species data
  observeEvent(input$species_file, {
    req(input$species_file)
    tryCatch({
      ext <- tools::file_ext(input$species_file$name)
      data <- if (ext == "csv") {
        read.csv(input$species_file$datapath, row.names = 1, check.names = FALSE)
      } else if (ext %in% c("xlsx", "xls")) {
        df <- readxl::read_excel(input$species_file$datapath)
        rownames_col <- df[[1]]
        df <- df[, -1]
        rownames(df) <- rownames_col
        as.data.frame(df)
      }
      community_data(data)
      showNotification(sprintf("✓ Loaded: %d sites × %d species", nrow(data), ncol(data)), type = "message")
    }, error = function(e) {
      showNotification(paste("❌ Error:", e$message), type = "error")
    })
  })
  
  # Species preview
  output$species_preview <- DT::renderDataTable({
    req(community_data())
    df <- community_data()
    df <- cbind(Site = rownames(df), df)
    DT::datatable(df, options = list(pageLength = 10, scrollX = TRUE), rownames = FALSE)
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
