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

# Source configuration and utilities
source("config/constants.R")
source("config/defaults.R")
source("R/error_handler.R")
source("R/performance.R")

# Source all modules
source("modules/ordination_nmds_module.R")
source("modules/ordination_pca_module.R")
source("modules/ordination_ca_module.R")
source("modules/ordination_dca_module.R")
source("modules/ordination_pcoa_module.R")
source("modules/ordination_cca_module.R")
source("modules/ordination_rda_module.R")
source("modules/ordination_dbrda_module.R")
source("modules/ordination_cap_module.R")
source("modules/diversity_estimation_module.R")
source("modules/diversity_indices_module.R")
source("modules/tests_permanova_module.R")
source("modules/tests_anosim_module.R")
source("modules/tests_mantel_envfit_module.R")

# UI - EXACT PROTOTYPE HTML STRUCTURE
ui <- function(req) {
  tagList(
    tags$head(
      tags$meta(charset = "UTF-8"),
      tags$meta(name = "viewport", content = "width=device-width, initial-scale=1.0"),
      tags$title("Ördin v3.0"),
      # Font Awesome 6.5 CDN
      tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"),
      tags$link(rel = "stylesheet", href = "prototype-styles.css?v=22"),
      tags$link(rel = "stylesheet", href = "window-controls.css?v=2"),
      # Hide Shiny busy indicator (grey overlay)
      tags$style(HTML("
        .shiny-busy-panel {
          display: none !important;
        }
        html.shiny-busy {
          cursor: default !important;
        }
        html.shiny-busy::before {
          display: none !important;
        }
      "))
    ),
    
    useShinyjs(),
    useShinyFeedback(),
    use_waiter(),
    
    # Load JavaScript files (with cache-busting version)
    tags$script(src = "validation.js?v=3"),
    tags$script(src = "statistical-interpretation.js?v=3"),
    tags$script(src = "about-ordin-content.js?v=3"),
    tags$script(src = "help-content.js?v=3"),
    tags$script(src = "shiny-ui.js?v=10"),
    tags$script(src = "sidebar-content.js?v=101"),
    tags$script(src = "fontawesome-icons.js?v=2"),
    tags$script(src = "plot-customization-panel.js?v=4"),
    
    # Load CSS files
    tags$link(rel = "stylesheet", href = "help-styles.css?v=1"),
    
    # Remove waiter overlay after page loads using JavaScript
    tags$script(HTML('
      // Remove overlays immediately on page load
      $(document).ready(function() {
        function removeOverlays() {
          $(".waiter-overlay").remove();
          $(".waiter").remove();
          $("[class*=waiter]").remove();
          $("#shiny-notification-panel").remove();
          $(".shiny-busy-panel").remove();
          
          // Remove any grey overlay divs
          $("body > div").each(function() {
            var elem = $(this);
            var bg = elem.css("background-color");
            var pos = elem.css("position");
            var zIndex = parseInt(elem.css("z-index"));
            
            // Check for grey fixed/absolute overlays with high z-index
            if ((pos === "fixed" || pos === "absolute") && zIndex > 9000) {
              if (bg && (bg.includes("153") || bg === "rgb(153, 153, 153)")) {
                elem.remove();
              }
            }
          });
          
          // Force remove shiny-busy class
          $("html").removeClass("shiny-busy");
        }
        
        // Run immediately
        removeOverlays();
        
        // Run every 100ms for the first 5 seconds to catch late-loading overlays
        var counter = 0;
        var interval = setInterval(function() {
          removeOverlays();
          counter++;
          if (counter > 50) clearInterval(interval);
        }, 100);
      });
    ')),
    
    # Skip link for accessibility
    tags$a(href = "#main-content", class = "skip-link", "Skip to main content"),
    
    # ============== TITLE BAR ==============
    div(class = "titlebar",
      div(class = "titlebar-left",
        span(class = "app-icon", "Ö"),
        span(class = "app-title", "Ördin v3.0"),
        span(class = "divider", "|"),
        span(class = "dataset-name", 
          tags$i(class = "fas fa-file-csv", style = "margin-right: 6px;"),
          "species_data.csv"
        )
      ),
      div(class = "titlebar-center",
        span(class = "status-badge", 
          tags$i(class = "fas fa-circle", style = "font-size: 8px; margin-right: 6px;"),
          "Ready"
        )
      ),
      div(class = "titlebar-right",
        span(class = "user-info", 
          tags$i(class = "fas fa-user", style = "margin-right: 6px;"),
          "Jimmy Moses"
        ),
        tags$button(class = "window-btn", onclick = "location.reload()", title = "Reload", 
          tags$i(class = "fas fa-sync-alt")
        ),
        tags$button(class = "window-btn", onclick = "if(window.electronAPI) window.electronAPI.minimizeWindow()", title = "Minimize", "—"),
        tags$button(class = "window-btn", onclick = "if(window.electronAPI) window.electronAPI.maximizeWindow()", title = "Maximize", "□"),
        tags$button(class = "window-btn close", onclick = "if(window.electronAPI) window.electronAPI.closeWindow()", title = "Close", "×")
      )
    ),
    
    # ============== MAIN CONTAINER ==============
    div(class = "main-container",
      
      # ACTIVITY BAR
      div(class = "activity-bar",
        div(class = "activity-item active", onclick = "switchView('home')", title = "Home", 
          tags$i(class = "fas fa-home")
        ),
        div(class = "activity-item", onclick = "switchView('data')", title = "Data", 
          tags$i(class = "fas fa-database")
        ),
        div(class = "activity-item", onclick = "switchView('diversity')", title = "Diversity", 
          tags$i(class = "fas fa-chart-line")
        ),
        div(class = "activity-item", onclick = "switchView('ordination')", title = "Ordination", 
          tags$i(class = "fas fa-project-diagram")
        ),
        div(class = "activity-item", onclick = "switchView('tests')", title = "Statistical Tests", 
          tags$i(class = "fas fa-flask")
        ),
        div(class = "activity-item", onclick = "switchView('beta')", title = "Beta Partitioning", 
          tags$i(class = "fas fa-dna")
        ),
        div(class = "spacer"),
        div(class = "activity-item", onclick = "switchView('settings')", title = "Settings", 
          tags$i(class = "fas fa-cog")
        ),
        div(class = "activity-item", onclick = "switchView('help')", title = "Help", 
          tags$i(class = "fas fa-question-circle")
        )
      ),
      
      # PRIMARY SIDEBAR (starts expanded for easier access)
      div(class = "primary-sidebar", id = "sidebar",
        div(class = "sidebar-header",
          span(class = "sidebar-title", "EXPLORER"),
          tags$button(onclick = "toggleSidebar()", "◀")
        ),
        div(class = "sidebar-content", id = "sidebar-content",
          # Default HOME content
          div(class = "section",
            div(class = "section-header", "▼ DATA SOURCES"),
            div(class = "section-content",
              div(class = "item active", onclick = "switchView('data')", style = "cursor: pointer;", "📄 species_data.csv"),
              div(class = "item", onclick = "switchView('data')", style = "cursor: pointer;", "📥 Import New File"),
              div(class = "item", onclick = "switchView('data')", style = "cursor: pointer;", "📚 Sample Datasets")
            )
          ),
          div(class = "section",
            div(class = "section-header", "▼ WORKSPACE"),
            div(class = "section-content",
              div(class = "item", onclick = "switchView('data')", style = "cursor: pointer;", "📊 Current Dataset ", span(class = "badge", "45×12")),
              div(class = "item", onclick = "alert('Metadata view coming soon!')", style = "cursor: pointer;", "ℹ️ Metadata"),
              div(class = "item", onclick = "alert('Validation tools coming soon!')", style = "cursor: pointer;", "✅ Validation ", span(class = "badge success", "OK"))
            )
          ),
          div(class = "section",
            div(class = "section-header", "▼ RECENT"),
            div(class = "section-content",
              div(class = "item", onclick = "switchView('diversity')", style = "cursor: pointer;", "📈 iNEXT analysis ", span(class = "badge", "2m"))
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
            
            # PAGE HEADER
            div(style = "margin-bottom: 30px;",
              h2(style = "color: #2e8b57; margin: 0 0 8px 0; font-size: 24px; font-weight: 600;", "📊 Data Management"),
              p(style = "color: #888; font-size: 14px; margin: 0;", "Import your species data and preview before analysis")
            ),
            
            # TWO-COLUMN LAYOUT - Responsive to prevent overflow
            div(style = "display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px; max-width: 100%;",
              
              # LEFT COLUMN - Species Data
              div(style = "background: #252526; border: 1px solid #3e3e42; padding: 24px;",
                div(style = "display: flex; align-items: center; margin-bottom: 20px;",
                  div(style = "width: 40px; height: 40px; background: #2e8b5720; border-radius: 8px; display: flex; align-items: center; justify-content: center; margin-right: 12px;",
                    span(style = "font-size: 20px;", "1️⃣")
                  ),
                  div(
                    h3(style = "color: #cccccc; margin: 0; font-size: 16px; font-weight: 600;", "Species Composition Data"),
                    p(style = "color: #888; font-size: 12px; margin: 4px 0 0 0;", "Required for all analyses")
                  )
                ),
                
                # File Upload Section
                div(style = "margin-bottom: 24px;",
                  h4(style = "color: #aaa; font-size: 13px; margin-bottom: 12px; font-weight: 600;", "📤 UPLOAD FILE"),
                  fileInput("species_file", "",
                           accept = c(".csv", ".xlsx", ".xls"),
                           placeholder = "Choose CSV or Excel file"),
                  div(style = "background: #1e1e1e; border-left: 3px solid #2e8b57; padding: 12px; margin-top: 8px;",
                    p(style = "color: #888; font-size: 11px; margin: 0; line-height: 1.6;",
                      "💡 ", tags$strong("Format:"), " First column = Site names, Other columns = Species abundance")
                  )
                ),
                
                # Sample Dataset Section
                div(style = "border-top: 1px solid #3e3e42; padding-top: 20px;",
                  h4(style = "color: #aaa; font-size: 13px; margin-bottom: 12px; font-weight: 600;", "📚 LOAD SAMPLE"),
                  selectInput("sample_dataset", "",
                             choices = c("Choose a sample dataset..." = "", 
                                        "Dune Meadow (20 sites × 30 species)" = "dune", 
                                        "Varespec (24 sites × 44 species)" = "varespec", 
                                        "BCI (50 sites × 225 species)" = "BCI")),
                  actionButton("load_sample", "▶ Load Sample Data", 
                              class = "btn-success", 
                              style = "width: 100%; margin-top: 8px;")
                )
              ),
              
              # RIGHT COLUMN - Environmental Data
              div(style = "background: #252526; border: 1px solid #3e3e42; padding: 24px;",
                div(style = "display: flex; align-items: center; margin-bottom: 20px;",
                  div(style = "width: 40px; height: 40px; background: #4a90e220; border-radius: 8px; display: flex; align-items: center; justify-content: center; margin-right: 12px;",
                    span(style = "font-size: 20px;", "2️⃣")
                  ),
                  div(
                    h3(style = "color: #cccccc; margin: 0; font-size: 16px; font-weight: 600;", "Environmental Data"),
                    p(style = "color: #888; font-size: 12px; margin: 4px 0 0 0;", "Optional - for constrained ordination")
                  )
                ),
                
                h4(style = "color: #aaa; font-size: 13px; margin-bottom: 12px; font-weight: 600;", "📤 UPLOAD FILE"),
                fileInput("env_file", "",
                         accept = c(".csv", ".xlsx", ".xls"),
                         placeholder = "Choose environmental data file"),
                
                div(style = "background: #1e1e1e; border-left: 3px solid #4a90e2; padding: 12px; margin-top: 8px;",
                  p(style = "color: #888; font-size: 11px; margin: 0 0 8px 0; line-height: 1.6;",
                    "💡 ", tags$strong("Examples:"), " pH, temperature, soil moisture, etc."),
                  p(style = "color: #888; font-size: 11px; margin: 0; line-height: 1.6;",
                    "⚠️ Must have same sites as species data")
                )
              )
            ),
            
            # DATA PREVIEW SECTION - Full Width with proper overflow handling
            div(style = "background: #252526; border: 1px solid #3e3e42; padding: 24px;",
              # Preview Header
              div(style = "display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;",
                div(
                  h3(style = "color: #2e8b57; margin: 0; font-size: 18px; font-weight: 600;", "🔍 Data Preview"),
                  p(style = "color: #888; font-size: 12px; margin: 4px 0 0 0;", "Preview loaded dataset before analysis")
                ),
                uiOutput("data_info_badge")
              ),
              
              # Species Data Preview
              div(style = "margin-bottom: 30px;",
                h4(style = "color: #2e8b57; font-size: 14px; margin-bottom: 12px; font-weight: 600;", "🌿 Species Composition"),
                div(style = "width: 100%; overflow-x: auto; overflow-y: auto; max-height: 500px; border: 1px solid #3e3e42;",
                  DT::DTOutput("species_preview")
                )
              ),
              
              # Environmental Data Preview
              uiOutput("env_preview_section")
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
                       choices = c(
                         "NMDS" = "nmds", 
                         "PCA" = "pca", 
                         "CA" = "ca", 
                         "DCA" = "dca", 
                         "PCoA" = "pcoa", 
                         "CCA (constrained)" = "cca", 
                         "RDA (constrained)" = "rda",
                         "db-RDA (constrained)" = "dbrda",
                         "CAP (constrained)" = "cap"
                       )),
            conditionalPanel("input.ordination_method == 'nmds'", nmds_ui("nmds")),
            conditionalPanel("input.ordination_method == 'pca'", pca_ui("pca")),
            conditionalPanel("input.ordination_method == 'ca'", ca_ui("ca")),
            conditionalPanel("input.ordination_method == 'dca'", dca_ui("dca")),
            conditionalPanel("input.ordination_method == 'pcoa'", pcoa_ui("pcoa")),
            conditionalPanel("input.ordination_method == 'cca'", cca_ui("cca")),
            conditionalPanel("input.ordination_method == 'rda'", rda_ui("rda")),
            conditionalPanel("input.ordination_method == 'dbrda'", dbrda_ui("dbrda")),
            conditionalPanel("input.ordination_method == 'cap'", cap_ui("cap"))
          ),
          
          # STATISTICAL TESTS TAB (hidden by default)
          div(id = "tab-tests", class = "tab-content", style = "display: none;",
            h2(style = "color: #2e8b57; margin-bottom: 20px;", "🧪 Statistical Tests"),
            selectInput("test_method", "Select Test:",
                       choices = c(
                         "PERMANOVA" = "permanova",
                         "ANOSIM" = "anosim",
                         "Mantel Test & envfit" = "mantel_envfit"
                       )),
            conditionalPanel("input.test_method == 'permanova'", permanova_ui("permanova")),
            conditionalPanel("input.test_method == 'anosim'", anosim_ui("anosim")),
            conditionalPanel("input.test_method == 'mantel_envfit'", mantel_envfit_ui("mantel_envfit"))
          ),
          
          # BETA PARTITIONING TAB (hidden by default)
          div(id = "tab-beta", class = "tab-content", style = "display: none;",
            h2(style = "color: #2e8b57; margin-bottom: 20px;", "🦠 Beta Diversity Partitioning"),
            div(style = "background: #252526; padding: 30px; text-align: center;",
              div(style = "font-size: 64px; margin-bottom: 20px;", "🦠"),
              h3(style = "color: #2e8b57;", "Beta Partitioning Module"),
              p(style = "color: #888; margin-bottom: 30px;", "Partition beta diversity into turnover and nestedness components"),
              div(style = "max-width: 600px; margin: 0 auto; text-align: left;",
                div(style = "background: #1e1e1e; border-left: 3px solid #2e8b57; padding: 20px; margin-bottom: 20px;",
                  h4(style = "color: #2e8b57; margin-top: 0;", "🧬 Available Analyses:"),
                  tags$ul(style = "color: #888; line-height: 2;",
                    tags$li("🦠 Taxonomic Beta Partitioning"),
                    tags$li("🧬 Functional Beta Diversity"),
                    tags$li("🌳 Phylogenetic Beta Diversity"),
                    tags$li("⏱️ Temporal Beta Diversity"),
                    tags$li("📍 Distance-Decay Modeling")
                  )
                ),
                p(style = "color: #666; font-size: 13px; text-align: center;", "🛠️ Module coming soon...")
              )
            )
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
            
            # APPEARANCE SETTINGS
            div(id = "settings-appearance", class = "settings-section",
              div(style = "background: #252526; padding: 20px; margin-bottom: 20px; border-radius: 4px;",
                h3(style = "color: #ccc; margin-bottom: 16px;", "🌨️ Appearance"),
                
                div(style = "display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 16px;",
                  div(class = "setting-item",
                    tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "Theme"),
                    selectInput("settings_theme", NULL, 
                      choices = c("Dark" = "dark", "Light" = "light"),
                      selected = "dark",
                      width = "100%"
                    )
                  ),
                  div(class = "setting-item",
                    tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "Font Family"),
                    selectInput("settings_font", NULL,
                      choices = c("System" = "system", "Sans" = "sans", "Serif" = "serif", "Mono" = "mono"),
                      selected = "system",
                      width = "100%"
                    )
                  ),
                  div(class = "setting-item",
                    tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "UI Zoom (%)"),
                    sliderInput("settings_zoom", NULL, min = 75, max = 150, value = 100, step = 5, width = "100%")
                  )
                ),
                
                # Save button for this section
                div(style = "margin-top: 20px;",
                  actionButton("settings_save_appearance", "Apply Appearance Settings",
                    style = "background: #2e8b57; color: white; border: none; padding: 10px 24px; border-radius: 4px; cursor: pointer;")
                )
              )
            ),
            
            # PLOT DEFAULTS
            div(id = "settings-plot-defaults", class = "settings-section", style = "display: none;",
              div(style = "background: #252526; padding: 20px; margin-bottom: 20px; border-radius: 4px;",
                h3(style = "color: #ccc; margin-bottom: 16px;", "🎨 Plot Defaults"),
                
                div(style = "display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 16px;",
                  div(class = "setting-item",
                    tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "Default Theme"),
                    selectInput("settings_plot_theme", NULL,
                      choices = c("Clean (bw)" = "bw", "Minimal" = "minimal", "Dark" = "dark", 
                                  "Classic" = "classic", "Light" = "light", "Void" = "void"),
                      selected = "bw",
                      width = "100%"
                    )
                  ),
                  div(class = "setting-item",
                    tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "Default DPI"),
                    numericInput("settings_plot_dpi", NULL, value = 300, min = 72, max = 600, step = 50, width = "100%")
                  ),
                  div(class = "setting-item",
                    tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "Default Format"),
                    selectInput("settings_plot_format", NULL,
                      choices = c("PDF" = "pdf", "PNG" = "png", "SVG" = "svg", "TIFF" = "tiff"),
                      selected = "pdf",
                      width = "100%"
                    )
                  ),
                  div(class = "setting-item",
                    tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "Width (inches)"),
                    numericInput("settings_plot_width", NULL, value = 8, min = 3, max = 20, step = 1, width = "100%")
                  ),
                  div(class = "setting-item",
                    tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "Height (inches)"),
                    numericInput("settings_plot_height", NULL, value = 6, min = 3, max = 20, step = 1, width = "100%")
                  )
                ),
                
                div(style = "margin-top: 20px;",
                  actionButton("settings_save_plot", "Apply Plot Defaults",
                    style = "background: #2e8b57; color: white; border: none; padding: 10px 24px; border-radius: 4px; cursor: pointer;")
                )
              )
            ),
            
            # ANALYSIS DEFAULTS
            div(id = "settings-analysis-defaults", class = "settings-section", style = "display: none;",
              div(style = "background: #252526; padding: 20px; margin-bottom: 20px; border-radius: 4px;",
                h3(style = "color: #ccc; margin-bottom: 16px;", "🧪 Analysis Defaults"),
              
              div(style = "display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 16px;",
                div(class = "setting-item",
                  tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "NMDS Distance"),
                  selectInput("settings_nmds_distance", NULL,
                    choices = c("Bray-Curtis" = "bray", "Jaccard" = "jaccard", "Euclidean" = "euclidean",
                                "Manhattan" = "manhattan", "Canberra" = "canberra"),
                    selected = "bray",
                    width = "100%"
                  )
                ),
                div(class = "setting-item",
                  tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "NMDS Dimensions (k)"),
                  numericInput("settings_nmds_k", NULL, value = 2, min = 2, max = 5, step = 1, width = "100%")
                ),
                div(class = "setting-item",
                  tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "iNEXT Bootstrap"),
                  numericInput("settings_inext_nboot", NULL, value = 50, min = 20, max = 200, step = 10, width = "100%")
                ),
                div(class = "setting-item",
                  tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "Permutations"),
                  numericInput("settings_permutations", NULL, value = 999, min = 99, max = 9999, step = 100, width = "100%")
                ),
                
                div(style = "margin-top: 20px;",
                  actionButton("settings_save_analysis", "Apply Analysis Defaults",
                    style = "background: #2e8b57; color: white; border: none; padding: 10px 24px; border-radius: 4px; cursor: pointer;")
                )
              )
            ),
            
            # DATA MANAGEMENT
            div(id = "settings-data-management", class = "settings-section", style = "display: none;",
              div(style = "background: #252526; padding: 20px; margin-bottom: 20px; border-radius: 4px;",
                h3(style = "color: #ccc; margin-bottom: 16px;", "📊 Data Management"),
                
                div(style = "display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 16px;",
                  div(class = "setting-item",
                    checkboxInput("settings_auto_save", "Auto-save results", value = FALSE)
                  ),
                  div(class = "setting-item",
                    checkboxInput("settings_validation", "Enable data validation", value = TRUE)
                  ),
                  div(class = "setting-item",
                    actionButton("settings_clear_data", "Clear All Data", 
                      style = "background: #d32f2f; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer;")
                  )
                )
              )
            ),
            
            # PERFORMANCE
            div(id = "settings-performance", class = "settings-section", style = "display: none;",
              div(style = "background: #252526; padding: 20px; margin-bottom: 20px; border-radius: 4px;",
                h3(style = "color: #ccc; margin-bottom: 16px;", "⚡ Performance"),
                
                div(style = "display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 16px;",
                  div(class = "setting-item",
                    tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "Performance Mode"),
                    selectInput("settings_performance", NULL,
                      choices = c("Standard" = "standard", "High Performance" = "high", "Eco" = "eco"),
                      selected = "standard",
                      width = "100%"
                    )
                  ),
                  div(class = "setting-item",
                    checkboxInput("settings_cache", "Enable result caching", value = TRUE)
                  ),
                  div(class = "setting-item",
                    actionButton("settings_clear_cache", "Clear Browser Cache",
                      style = "background: #424242; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer;")
                  )
                )
              )
            ),
            
            # ADVANCED SETTINGS
            div(id = "settings-advanced", class = "settings-section", style = "display: none;",
              div(style = "background: #252526; padding: 20px; margin-bottom: 20px; border-radius: 4px;",
                h3(style = "color: #ccc; margin-bottom: 16px;", "🔧 Advanced Settings"),
                
                div(style = "display: grid; grid-template-columns: 1fr; gap: 16px;",
                  div(class = "setting-item",
                    tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "R Configuration"),
                    tags$pre(style = "background: #1e1e1e; color: #ccc; padding: 12px; border-radius: 4px; font-size: 12px;",
                      "Version: 4.5.1\nPlatform: x86_64-w64-mingw32\nLibrary: C:/Program Files/R/R-4.5.1/library"
                    )
                  ),
                  div(class = "setting-item",
                    tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "Package Versions"),
                    tags$pre(style = "background: #1e1e1e; color: #ccc; padding: 12px; border-radius: 4px; font-size: 12px;",
                      "vegan: 2.6-8\niNEXT: 3.0.1\nggplot2: 3.5.1\nshiny: 1.9.1"
                    )
                  )
                )
              )
            ),
            
            # ACTION BUTTONS
            div(style = "display: flex; gap: 12px; justify-content: flex-end; margin-top: 24px;",
              actionButton("settings_reset", "Reset to Defaults",
                style = "background: #757575; color: white; border: none; padding: 10px 24px; border-radius: 4px; cursor: pointer;"),
              actionButton("settings_export", "Export Settings",
                style = "background: #424242; color: white; border: none; padding: 10px 24px; border-radius: 4px; cursor: pointer;"),
              actionButton("settings_save", "Save Settings",
                style = "background: #2e8b57; color: white; border: none; padding: 10px 24px; border-radius: 4px; cursor: pointer;")
            )
          ),
          
          # HELP TAB
          div(id = "tab-help", class = "tab-content", style = "display: none;",
            tags$div(id = "help-content-container"),
            tags$script("
              $(document).ready(function() {
                if (typeof getAboutOrdinContent === 'function') {
                  $('#help-content-container').html(getAboutOrdinContent());
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
          # Dataset Info (reactive)
          uiOutput("right_panel_dataset_info"),
          
          # Quick Actions
          div(class = "prop-section",
            h4("Quick Actions"),
            tags$button(class = "action-btn", onclick = "alert('CSV export - Coming soon!')", "Export CSV"),
            tags$button(class = "action-btn", onclick = "alert('Excel export - Coming soon!')", "Export Excel"),
            tags$button(class = "action-btn", onclick = "alert('Metadata - Coming soon!')", "View Metadata")
          )
        )
      )
    )
  )
}

# SERVER
server <- function(input, output, session) {
  
  # ============== REACTIVE DATA STORAGE ==============
  # Store loaded data reactively so modules can access it
  species_data <- reactiveVal(NULL)
  env_data <- reactiveVal(NULL)
  
  # ============== MODULE SERVERS (WITH DATA) ==============
  # Call module servers and pass reactive data
  # NOTE: NMDS, CCA, RDA, db-RDA, and CAP modules accept env_data parameter for constrained ordination
  
  # Diversity modules
  diversity_estimation_server("diversity_est", data = species_data)
  diversity_indices_server("diversity_idx", data = species_data)
  
  # Ordination modules
  nmds_server("nmds", data = species_data, env_data = env_data)  # NMDS supports environmental data
  pca_server("pca", data = species_data)  # PCA does not use env_data
  ca_server("ca", data = species_data)  # CA does not use env_data
  dca_server("dca", data = species_data)  # DCA does not use env_data
  pcoa_server("pcoa", data = species_data)  # PCoA does not use env_data
  cca_server("cca", data = species_data, env_data = env_data)  # CCA is constrained ordination
  rda_server("rda", data = species_data, env_data = env_data)  # RDA is constrained ordination
  dbrda_server("dbrda", data = species_data, env_data = env_data)  # db-RDA is constrained ordination
  cap_server("cap", data = species_data, env_data = env_data)  # CAP is constrained ordination
  
  # Statistical test modules
  permanova_server("permanova", data = species_data, env_data = env_data)
  anosim_server("anosim", data = species_data, env_data = env_data)
  mantel_envfit_server("mantel_envfit", data = species_data, env_data = env_data)
  
  # ============== INITIALIZE DATA PREVIEW ==============
  # Initialize empty data table - REACTIVE to species_data changes
  # CRITICAL: Must use renderDT from DT package, not renderDataTable
  
  # Data info badge
  output$data_info_badge <- renderUI({
    species_count <- if (!is.null(species_data())) paste0(nrow(species_data()), " sites × ", ncol(species_data()), " species") else ""
    env_count <- if (!is.null(env_data())) paste0(ncol(env_data()), " variables") else ""
    
    if (!is.null(species_data()) || !is.null(env_data())) {
      div(style = "display: flex; gap: 12px;",
        if (!is.null(species_data())) {
          div(style = "background: #2e8b5720; border: 1px solid #2e8b57; border-radius: 4px; padding: 8px 16px; display: flex; align-items: center; gap: 8px;",
            span(style = "color: #2e8b57; font-size: 14px; font-weight: 600;", "✓"),
            span(style = "color: #2e8b57; font-size: 13px; font-weight: 600;", species_count)
          )
        },
        if (!is.null(env_data())) {
          div(style = "background: #4a90e220; border: 1px solid #4a90e2; border-radius: 4px; padding: 8px 16px; display: flex; align-items: center; gap: 8px;",
            span(style = "color: #4a90e2; font-size: 14px; font-weight: 600;", "✓"),
            span(style = "color: #4a90e2; font-size: 13px; font-weight: 600;", env_count)
          )
        }
      )
    }
  })
  
  # Environmental data preview section (conditional)
  output$env_preview_section <- renderUI({
    if (!is.null(env_data())) {
      div(
        h4(style = "color: #4a90e2; font-size: 14px; margin-bottom: 12px; font-weight: 600;", "🌍 Environmental Data"),
        div(style = "width: 100%; overflow-x: auto; overflow-y: auto; max-height: 400px; border: 1px solid #3e3e42;",
          DT::DTOutput("env_preview")
        )
      )
    }
  })
  
  # Right Panel - Dataset Info (reactive to loaded data)
  output$right_panel_dataset_info <- renderUI({
    if (is.null(species_data())) {
      # No data loaded
      div(class = "prop-section",
        h4("Dataset Info"),
        div(style = "color: #888; font-size: 12px; padding: 12px; text-align: center;",
          "⚠️ No dataset loaded"
        )
      )
    } else {
      # Show actual data info
      div(class = "prop-section",
        h4("Dataset Info"),
        div(class = "prop-item",
          tags$label("Rows (Sites):"),
          span(style = "color: #2e8b57; font-weight: 600;", nrow(species_data()))
        ),
        div(class = "prop-item",
          tags$label("Columns (Species):"),
          span(style = "color: #2e8b57; font-weight: 600;", ncol(species_data()))
        ),
        div(class = "prop-item",
          tags$label("Type:"),
          span(style = "color: #cccccc;", "Abundance")
        ),
        if (!is.null(env_data())) {
          div(class = "prop-item",
            tags$label("Env Variables:"),
            span(style = "color: #4a90e2; font-weight: 600;", ncol(env_data()))
          )
        }
      )
    }
  })
  
  output$species_preview <- DT::renderDT({
    cat("\n========== DATATABLE RENDER CALLED ==========", "\n")
    cat("Timestamp:", Sys.time(), "\n")
    cat("species_data is null:", is.null(species_data()), "\n")
    
    if (is.null(species_data())) {
      # Show empty placeholder
      cat("Showing empty placeholder message\n")
      cat("==========================================\n\n")
      DT::datatable(
        data.frame(
          Status = "⚠️ No Data Loaded",
          Instructions = "Upload a CSV/Excel file or load a sample dataset to get started"
        ),
        options = list(
          pageLength = 5,
          scrollX = FALSE,
          dom = 't',
          ordering = FALSE,
          searching = FALSE,
          columnDefs = list(
            list(width = '30%', targets = 0),
            list(width = '70%', targets = 1)
          )
        ),
        rownames = FALSE,
        style = 'bootstrap4',
        class = 'cell-border'
      )
    } else {
      # Show actual data
      cat("Showing actual data\n")
      cat("Rows:", nrow(species_data()), "\n")
      cat("Cols:", ncol(species_data()), "\n")
      cat("==========================================\n\n")
      DT::datatable(
        species_data(),
        options = list(
          pageLength = 10,
          scrollX = FALSE,
          scrollY = FALSE,
          paging = TRUE,
          searching = TRUE,
          info = TRUE,
          autoWidth = TRUE,
          dom = 'frtip',
          columnDefs = list(
            list(width = '70px', targets = '_all')
          )
        ),
        style = 'bootstrap4',
        class = 'cell-border stripe hover compact',
        rownames = TRUE
      )
    }
  })
  
  # Environmental data preview table
  output$env_preview <- DT::renderDT({
    cat("\n========== ENV DATATABLE RENDER ==========\n")
    cat("env_data is null:", is.null(env_data()), "\n")
    
    if (!is.null(env_data())) {
      cat("Showing environmental data\n")
      cat("Rows:", nrow(env_data()), "\n")
      cat("Cols:", ncol(env_data()), "\n")
      DT::datatable(
        env_data(),
        options = list(
          pageLength = 10,
          scrollX = FALSE,
          scrollY = FALSE,
          paging = TRUE,
          searching = TRUE,
          info = TRUE,
          autoWidth = TRUE,
          dom = 'frtip',
          columnDefs = list(
            list(width = '100px', targets = '_all')
          )
        ),
        style = 'bootstrap4',
        class = 'cell-border stripe hover compact',
        rownames = TRUE
      )
    }
  })
  
  # ============== SAMPLE DATA LOADING ==============
  observeEvent(input$load_sample, {
    cat("\n=== LOAD SAMPLE BUTTON CLICKED ===", "\n")
    cat("sample_dataset value:", input$sample_dataset, "\n")
    
    req(input$sample_dataset)
    
    if (input$sample_dataset == "dune") {
      cat("Loading dune dataset...\n")
      data(dune, package = "vegan")
      species_data(as.data.frame(dune))  # Store reactively
      cat("Dune data stored. Rows:", nrow(dune), "\n")
      
      # Also load dune.env environmental data
      data(dune.env, package = "vegan")
      env_data(as.data.frame(dune.env))
      cat("Dune.env data stored. Rows:", nrow(dune.env), "\n")
      
      showNotification("✅ Dune meadow data + environmental data loaded successfully!", type = "message", duration = 3)
      
    } else if (input$sample_dataset == "varespec") {
      cat("Loading varespec dataset...\n")
      data(varespec, package = "vegan")
      species_data(as.data.frame(varespec))  # Store reactively
      cat("Varespec data stored. Rows:", nrow(varespec), "\n")
      
      showNotification("✅ Varespec data loaded successfully!", type = "message", duration = 3)
      
    } else if (input$sample_dataset == "BCI") {
      cat("Loading BCI dataset...\n")
      data(BCI, package = "vegan")
      species_data(as.data.frame(BCI))  # Store reactively
      cat("BCI data stored. Rows:", nrow(BCI), "\n")
      
      showNotification("✅ BCI data loaded successfully!", type = "message", duration = 3)
    }
    
    cat("=== SAMPLE DATA LOADING COMPLETE ===", "\n\n")
  })
  
  # ============== FILE UPLOAD HANDLING ==============
  # ============== SETTINGS HANDLERS ==============
  
  # UI Zoom slider
  observeEvent(input$settings_zoom, {
    session$sendCustomMessage("setZoom", input$settings_zoom / 100)
  })
  
  # Save Settings Button
  observeEvent(input$settings_save, {
    # Save to browser localStorage via JavaScript
    settings <- list(
      theme = input$settings_theme,
      font = input$settings_font,
      zoom = input$settings_zoom,
      plot_theme = input$settings_plot_theme,
      plot_dpi = input$settings_plot_dpi,
      plot_format = input$settings_plot_format,
      plot_width = input$settings_plot_width,
      plot_height = input$settings_plot_height,
      nmds_distance = input$settings_nmds_distance,
      nmds_k = input$settings_nmds_k,
      inext_nboot = input$settings_inext_nboot,
      permutations = input$settings_permutations,
      auto_save = input$settings_auto_save,
      validation = input$settings_validation,
      performance = input$settings_performance,
      cache = input$settings_cache
    )
    
    session$sendCustomMessage("saveSettings", settings)
    showNotification("✅ Settings saved successfully!", type = "message", duration = 2)
  })
  
  # Export Settings Button
  observeEvent(input$settings_export, {
    settings <- list(
      theme = input$settings_theme,
      plot_defaults = list(
        theme = input$settings_plot_theme,
        dpi = input$settings_plot_dpi,
        format = input$settings_plot_format,
        width = input$settings_plot_width,
        height = input$settings_plot_height
      ),
      analysis_defaults = list(
        nmds_distance = input$settings_nmds_distance,
        nmds_k = input$settings_nmds_k,
        inext_nboot = input$settings_inext_nboot,
        permutations = input$settings_permutations
      )
    )
    
    settings_json <- jsonlite::toJSON(settings, pretty = TRUE, auto_unbox = TRUE)
    showNotification(
      HTML(paste0("<pre style='font-size: 11px; max-height: 300px; overflow: auto;'>", settings_json, "</pre>")),
      type = "message",
      duration = NULL  # User must dismiss
    )
  })
  
  # Reset to Defaults Button
  observeEvent(input$settings_reset, {
    updateSelectInput(session, "settings_theme", selected = "dark")
    updateSelectInput(session, "settings_font", selected = "system")
    updateSliderInput(session, "settings_zoom", value = 100)
    updateSelectInput(session, "settings_plot_theme", selected = "bw")
    updateNumericInput(session, "settings_plot_dpi", value = 300)
    updateSelectInput(session, "settings_plot_format", selected = "pdf")
    updateNumericInput(session, "settings_plot_width", value = 8)
    updateNumericInput(session, "settings_plot_height", value = 6)
    updateSelectInput(session, "settings_nmds_distance", selected = "bray")
    updateNumericInput(session, "settings_nmds_k", value = 2)
    updateNumericInput(session, "settings_inext_nboot", value = 50)
    updateNumericInput(session, "settings_permutations", value = 999)
    updateCheckboxInput(session, "settings_auto_save", value = FALSE)
    updateCheckboxInput(session, "settings_validation", value = TRUE)
    updateSelectInput(session, "settings_performance", selected = "standard")
    updateCheckboxInput(session, "settings_cache", value = TRUE)
    
    showNotification("✅ Settings reset to defaults!", type = "message", duration = 2)
  })
  
  # Clear All Data Button
  observeEvent(input$settings_clear_data, {
    species_data(NULL)
    env_data(NULL)
    showNotification("✅ All data cleared!", type = "message", duration = 2)
  })
  
  # Clear Browser Cache Button
  observeEvent(input$settings_clear_cache, {
    session$sendCustomMessage("clearCache", list())
  })
  
  # ============== FILE UPLOAD HANDLERS ==============
  
  # Species data file upload
  observeEvent(input$species_file, {
    req(input$species_file)
    
    ext <- tools::file_ext(input$species_file$name)
    
    loaded_data <- tryCatch({
      if (ext == "csv") {
        read_csv(input$species_file$datapath, show_col_types = FALSE)
      } else if (ext %in% c("xlsx", "xls")) {
        read_excel(input$species_file$datapath)
      }
    }, error = function(e) {
      showNotification(paste("❌ Error loading file:", e$message), type = "error", duration = 5)
      NULL
    })
    
    if (!is.null(loaded_data)) {
      # Store as data frame
      species_data(as.data.frame(loaded_data))  # Store reactively
      
      showNotification(
        paste0("✅ ", input$species_file$name, " loaded successfully! (", 
               nrow(loaded_data), " rows, ", ncol(loaded_data), " columns)"),
        type = "message",
        duration = 3
      )
    }
  })
  
  # Environmental data file upload
  observeEvent(input$env_file, {
    req(input$env_file)
    
    ext <- tools::file_ext(input$env_file$name)
    
    loaded_env <- tryCatch({
      if (ext == "csv") {
        read_csv(input$env_file$datapath, show_col_types = FALSE)
      } else if (ext %in% c("xlsx", "xls")) {
        read_excel(input$env_file$datapath)
      }
    }, error = function(e) {
      showNotification(paste("❌ Error loading environmental data:", e$message), type = "error")
      NULL
    })
    
    if (!is.null(loaded_env)) {
      # Store as data frame
      env_data(as.data.frame(loaded_env))  # Store reactively
      
      showNotification(
        paste0("✅ Environmental data loaded! (", 
               nrow(loaded_env), " rows, ", ncol(loaded_env), " variables)"),
        type = "message"
      )
    }
  })
}

# Run app
shinyApp(ui, server)
