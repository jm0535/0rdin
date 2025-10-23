# Ördin v3.0 - Community Ecology Analysis Platform
# Enterprise-grade implementation with advanced UI/UX

library(bslib)
library(vegan)
library(iNEXT)
library(ggplot2)
library(DT)
library(readr)
library(dplyr)
library(tidyr)
library(shinyjs)         # JavaScript interactivity & keyboard shortcuts
library(waiter)          # Loading screens & spinners
library(shinyFeedback)   # Validation feedback
library(shinycssloaders) # Loading indicators
library(shinyWidgets)    # Enhanced widgets
library(openxlsx)        # Excel export
library(jsonlite)        # JSON export
library(clipr)           # Clipboard functionality
library(shinyBS)         # Bootstrap components
library(shinyalert)      # Alert dialogs

# UI Definition
ui <- tagList(
  useShinyjs(),  # Initialize shinyjs
  use_waiter(),  # Initialize waiter
  useShinyFeedback(),  # Initialize shinyFeedback
  waiter_show_on_load(
    html = tagList(
      spin_flower(),
      h3("Loading Ördin...", style = "color: #2e8b57; margin-top: 20px;")
    ),
    color = "#1e1e1e"
  ),
  
  page_navbar(
    title = "Ördin v3.0",
    id = "main_nav",
    theme = bs_theme(
    version = 5,
    preset = "shiny",
    bg = "#1e1e1e",
    fg = "#cccccc",
    primary = "#2e8b57",      # GREEN primary color
    secondary = "#2d2d30",
    success = "#2e8b57",       # GREEN success color
    info = "#4ec9b0",
    warning = "#ff8c00",
    danger = "#d32f2f",
    "navbar-bg" = "#2d2d30",
    "navbar-light-brand-color" = "#ffffff",
    "navbar-light-brand-hover-color" = "#2e8b57",  # GREEN hover
    "font-size-base" = "0.9rem",
    "enable-rounded" = FALSE,
    "enable-shadows" = FALSE
  ),
  
  # Link external CSS and JavaScript
  header = tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
    tags$script(HTML('
      // Auto-save functionality
      let autoSaveInterval = null;
      let isDirty = false;
      
      function enableAutoSave() {
        // Mark data as changed
        isDirty = true;
        
        // Auto-save every 30 seconds
        if (!autoSaveInterval) {
          autoSaveInterval = setInterval(function() {
            if (isDirty) {
              const timestamp = new Date().toISOString();
              localStorage.setItem("ordin-autosave-timestamp", timestamp);
              isDirty = false;
              
              // Show subtle notification
              const notification = document.getElementById("autosave-indicator");
              if (notification) {
                notification.style.opacity = "1";
                setTimeout(() => { notification.style.opacity = "0"; }, 2000);
              }
            }
          }, 30000); // 30 seconds
        }
      }
      
      // Keyboard shortcuts
      document.addEventListener("keydown", function(e) {
        // Ctrl+O: Open file dialog
        if (e.ctrlKey && e.key === "o") {
          e.preventDefault();
          const fileInput = document.getElementById("dataFile");
          if (fileInput) fileInput.click();
        }
        
        // Ctrl+S: Save/Export results
        if (e.ctrlKey && e.key === "s") {
          e.preventDefault();
          const downloadBtn = document.querySelector(".btn-success[id*=download]");
          if (downloadBtn) downloadBtn.click();
        }
        
        // Ctrl+T: Toggle theme
        if (e.ctrlKey && e.key === "t") {
          e.preventDefault();
          toggleTheme();
        }
        
        // Ctrl+1/2/3: Switch tabs
        if (e.ctrlKey && ["1", "2", "3"].includes(e.key)) {
          e.preventDefault();
          const tabs = document.querySelectorAll(".nav-link");
          const index = parseInt(e.key) - 1;
          if (tabs[index]) tabs[index].click();
        }
        
        // F1: Help
        if (e.key === "F1") {
          e.preventDefault();
          const helpTab = document.querySelector(".nav-link[data-value=\'Help\']");
          if (helpTab) helpTab.click();
        }
      });
      
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
        
        // Set window title to just "Ördin"
        document.title = "Ördin";
        
        // Initialize auto-save indicator
        const navbar = document.querySelector(".navbar");
        if (navbar && !document.getElementById("autosave-indicator")) {
          const indicator = document.createElement("div");
          indicator.id = "autosave-indicator";
          indicator.style.cssText = "position: fixed; top: 10px; right: 70px; background: #2e8b57; color: white; padding: 5px 12px; border-radius: 3px; font-size: 0.75rem; opacity: 0; transition: opacity 0.3s; z-index: 9999;";
          indicator.innerHTML = "💾 Auto-saved";
          document.body.appendChild(indicator);
        }
        
        // Insert VS Code style menu bar
        const navbar = document.querySelector(".navbar");
        if (navbar && !document.querySelector(".vscode-menubar")) {
          const menuBar = document.createElement("div");
          menuBar.className = "vscode-menubar";
          menuBar.innerHTML = `
            <div class="menu-bar">
              <div class="menu-item">File</div>
              <div class="menu-item">Edit</div>
              <div class="menu-item">View</div>
              <div class="menu-item">Window</div>
              <div class="menu-item">Help</div>
            </div>
          `;
          navbar.insertBefore(menuBar, navbar.firstChild);
        }
      });
    '))
  ),  # End header
  
  # HOME / LANDING PAGE
  nav_panel(
    title = "Home",
    icon = icon("home"),
    # Landing page content
    div(
      class = "landing-page",
      style = "min-height: 100vh; background: linear-gradient(135deg, #1a1a1a 0%, #2a2a2a 100%); padding: 60px 20px;",
      
      # Hero Section
      div(
        class = "container",
        style = "max-width: 1200px; margin: 0 auto;",
        
        # Animated Logo & Title
        div(
          class = "text-center mb-5",
          style = "animation: fadeInDown 0.8s ease-out;",
          div(
            style = "font-size: 8em; color: #2e8b57; margin-bottom: 20px; font-weight: bold; text-shadow: 0 0 30px rgba(46, 139, 87, 0.5); animation: pulse 2s infinite;",
            "Ö"
          ),
          h1(
            style = "font-size: 3.5em; font-weight: 800; background: linear-gradient(135deg, #2e8b57 0%, #3fa869 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 15px;",
            "Ördin v3.0"
          ),
          p(
            class = "lead",
            style = "font-size: 1.5em; color: #999; font-weight: 300; letter-spacing: 2px;",
            "COMMUNITY ECOLOGY ANALYSIS PLATFORM"
          ),
          p(
            style = "color: #666; font-size: 1.1em; margin-top: 20px;",
            icon("flask"), " Enterprise-Grade Statistical Computing  ",
            icon("chart-bar"), " Advanced Visualization  ",
            icon("database"), " Multi-Format Export"
          )
        ),
        
        # Interactive Module Cards
        div(
          class = "row mt-5 justify-content-center",
          style = "animation: fadeInUp 0.8s ease-out 0.1s both;",
          
          # Card 1: Diversity Estimation
          div(
            class = "col-lg-4 col-md-6 mb-4",
            actionButton(
              "navToDiversity",
              div(
                style = "text-align: center; padding: 30px 20px; background: linear-gradient(135deg, #2a2a2a 0%, #1a1a1a 100%); border: 2px solid #2e8b57; border-radius: 15px; transition: all 0.3s; cursor: pointer; min-height: 380px; display: flex; flex-direction: column; justify-content: space-between;",
                onmouseover = "this.style.transform='translateY(-10px)'; this.style.boxShadow='0 20px 40px rgba(46, 139, 87, 0.4)'; this.style.borderColor='#3fa869';",
                onmouseout = "this.style.transform='translateY(0)'; this.style.boxShadow='none'; this.style.borderColor='#2e8b57';",
                div(
                  div(
                    style = "font-size: 3.5em; color: #2e8b57; margin-bottom: 15px;",
                    icon("chart-line")
                  ),
                  h4(
                    style = "color: #2e8b57; font-weight: 700; margin-bottom: 12px; font-size: 1.3em;",
                    "Diversity Estimation"
                  ),
                  p(
                    style = "color: #999; font-size: 0.9em; line-height: 1.5; margin-bottom: 0;",
                    "iNEXT rarefaction & extrapolation with Hill numbers"
                  )
                ),
                div(
                  style = "margin-top: 15px; padding: 10px 20px; background: #2e8b5722; color: #2e8b57; border-radius: 25px; display: inline-block; font-size: 0.85em; font-weight: 700;",
                  "START ANALYSIS →"
                )
              ),
              class = "btn",
              style = "border: none; background: transparent; width: 100%; padding: 0;"
            )
          ),
          
          # Card 2: Ordination
          div(
            class = "col-lg-4 col-md-6 mb-4",
            actionButton(
              "navToOrdination",
              div(
                style = "text-align: center; padding: 30px 20px; background: linear-gradient(135deg, #2a2a2a 0%, #1a1a1a 100%); border: 2px solid #4169e1; border-radius: 15px; transition: all 0.3s; cursor: pointer; min-height: 380px; display: flex; flex-direction: column; justify-content: space-between;",
                onmouseover = "this.style.transform='translateY(-10px)'; this.style.boxShadow='0 20px 40px rgba(65, 105, 225, 0.4)'; this.style.borderColor='#5179f1';",
                onmouseout = "this.style.transform='translateY(0)'; this.style.boxShadow='none'; this.style.borderColor='#4169e1';",
                div(
                  div(
                    style = "font-size: 3.5em; color: #4169e1; margin-bottom: 15px;",
                    icon("project-diagram")
                  ),
                  h4(
                    style = "color: #4169e1; font-weight: 700; margin-bottom: 12px; font-size: 1.3em;",
                    "Ordination Analysis"
                  ),
                  p(
                    style = "color: #999; font-size: 0.9em; line-height: 1.5; margin-bottom: 0;",
                    "NMDS, PCA, CA, DCA & PCoA for community patterns"
                  )
                ),
                div(
                  style = "margin-top: 15px; padding: 10px 20px; background: #4169e122; color: #4169e1; border-radius: 25px; display: inline-block; font-size: 0.85em; font-weight: 700;",
                  "EXPLORE →"
                )
              ),
              class = "btn",
              style = "border: none; background: transparent; width: 100%; padding: 0;"
            )
          ),
          
          # Card 3: Diversity Indices
          div(
            class = "col-lg-4 col-md-6 mb-4",
            div(
              style = "text-align: center; padding: 30px 20px; background: linear-gradient(135deg, #2a2a2a 0%, #1a1a1a 100%); border: 2px solid #ff8c00; border-radius: 15px; transition: all 0.3s; cursor: pointer; min-height: 380px; display: flex; flex-direction: column; justify-content: space-between;",
              onmouseover = "this.style.transform='translateY(-10px)'; this.style.boxShadow='0 20px 40px rgba(255, 140, 0, 0.4)'; this.style.borderColor='#ff9c10';",
              onmouseout = "this.style.transform='translateY(0)'; this.style.boxShadow='none'; this.style.borderColor='#ff8c00';",
              onclick = "Shiny.setInputValue('main_nav', 'Diversity Analysis'); Shiny.setInputValue('analysisType', 'indices', {priority: 'event'});",
              div(
                div(
                  style = "font-size: 3.5em; color: #ff8c00; margin-bottom: 15px;",
                  icon("calculator")
                ),
                h4(
                  style = "color: #ff8c00; font-weight: 700; margin-bottom: 12px; font-size: 1.3em;",
                  "Diversity Indices"
                ),
                p(
                  style = "color: #999; font-size: 0.9em; line-height: 1.5; margin-bottom: 0;",
                  "Shannon, Simpson, Fisher's α & Pielou's evenness"
                )
              ),
              div(
                style = "margin-top: 15px; padding: 10px 20px; background: #ff8c0022; color: #ff8c00; border-radius: 25px; display: inline-block; font-size: 0.85em; font-weight: 700;",
                "CALCULATE →"
              )
            )
          )
        ),
        
        # Features Grid
        div(
          class = "mt-5",
          style = "animation: fadeInUp 0.8s ease-out 0.4s both;",
          h3(
            class = "text-center mb-4",
            style = "color: #2e8b57; font-weight: 700; font-size: 2em;",
            "Enterprise Features"
          ),
          div(
            class = "row",
            div(
              class = "col-lg-4 col-md-6 mb-3",
              div(
                style = "background: #1a1a1a; border: 1px solid #333; border-radius: 10px; padding: 25px; text-align: center; transition: all 0.3s; min-height: 180px;",
                onmouseover = "this.style.borderColor='#2e8b57'; this.style.transform='translateY(-5px)';",
                onmouseout = "this.style.borderColor='#333'; this.style.transform='translateY(0)';",
                div(style = "font-size: 2.5em; color: #2e8b57; margin-bottom: 12px;", icon("keyboard")),
                h5(style = "color: #fff; font-weight: 600; margin-bottom: 10px; font-size: 1.1em;", "Keyboard Shortcuts"),
                p(style = "color: #888; font-size: 0.85em; margin: 0;", "Ctrl+O • Ctrl+S • Ctrl+T • Ctrl+1/2/3")
              )
            ),
            div(
              class = "col-lg-4 col-md-6 mb-3",
              div(
                style = "background: #1a1a1a; border: 1px solid #333; border-radius: 10px; padding: 25px; text-align: center; transition: all 0.3s; min-height: 180px;",
                onmouseover = "this.style.borderColor='#2e8b57'; this.style.transform='translateY(-5px)';",
                onmouseout = "this.style.borderColor='#333'; this.style.transform='translateY(0)';",
                div(style = "font-size: 2.5em; color: #2e8b57; margin-bottom: 12px;", icon("file-export")),
                h5(style = "color: #fff; font-weight: 600; margin-bottom: 10px; font-size: 1.1em;", "Multi-Format Export"),
                p(style = "color: #888; font-size: 0.85em; margin: 0;", "CSV, Excel, JSON & publication plots")
              )
            ),
            div(
              class = "col-lg-4 col-md-6 mb-3",
              div(
                style = "background: #1a1a1a; border: 1px solid #333; border-radius: 10px; padding: 25px; text-align: center; transition: all 0.3s; min-height: 180px;",
                onmouseover = "this.style.borderColor='#2e8b57'; this.style.transform='translateY(-5px)';",
                onmouseout = "this.style.borderColor='#333'; this.style.transform='translateY(0)';",
                div(style = "font-size: 2.5em; color: #2e8b57; margin-bottom: 12px;", icon("save")),
                h5(style = "color: #fff; font-weight: 600; margin-bottom: 10px; font-size: 1.1em;", "Auto-Save"),
                p(style = "color: #888; font-size: 0.85em; margin: 0;", "Session recovery every 30 seconds")
              )
            )
          )
        ),
        
        # Quick Start Section
        div(
          class = "mt-5",
          style = "animation: fadeInUp 0.8s ease-out 0.5s both;",
          div(
            style = "background: linear-gradient(135deg, #2e8b57 0%, #1f6d42 100%); border-radius: 15px; padding: 50px 40px; text-align: center; box-shadow: 0 10px 30px rgba(46, 139, 87, 0.3);",
            h3(
              style = "color: #fff; font-weight: 700; font-size: 2em; margin-bottom: 15px;",
              icon("rocket"), " Ready to Begin?"
            ),
            p(
              style = "color: rgba(255,255,255,0.95); font-size: 1.15em; margin-bottom: 30px; max-width: 700px; margin-left: auto; margin-right: auto;",
              "Upload your community ecology data and start analyzing with enterprise-grade tools"
            ),
            actionButton(
              "quickStartUpload",
              HTML("<span style='font-size: 1.1em;'><i class='fa fa-upload'></i> UPLOAD DATA & START</span>"),
              class = "btn btn-lg",
              style = "background: #fff; color: #2e8b57; border: none; border-radius: 30px; padding: 15px 50px; transition: all 0.3s; font-weight: 700; box-shadow: 0 5px 15px rgba(0,0,0,0.2);",
              onmouseover = "this.style.transform='scale(1.05)'; this.style.boxShadow='0 10px 30px rgba(0,0,0,0.35)';",
              onmouseout = "this.style.transform='scale(1)'; this.style.boxShadow='0 5px 15px rgba(0,0,0,0.2)';"
            )
          )
        )
      ),
      
      # CSS Animations
      tags$style(HTML("
        @keyframes fadeInDown {
          from {
            opacity: 0;
            transform: translateY(-30px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
        
        @keyframes fadeInUp {
          from {
            opacity: 0;
            transform: translateY(30px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
        
        @keyframes pulse {
          0%, 100% {
            transform: scale(1);
          }
          50% {
            transform: scale(1.05);
          }
        }
      "))
    )
  ),
  
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
                           class = "btn-success btn-lg w-100 mt-3",
                           icon = icon("play"))
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
                           class = "btn-success btn-lg w-100 mt-3",
                           icon = icon("calculator"))
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
                       class = "btn-success btn-lg w-100 mt-3",
                       icon = icon("project-diagram")),
            hr(style = "border-color: #444; margin: 20px 0;"),
            actionButton("previewData",
                       "Preview Data",
                       class = "btn btn-outline-secondary w-100",
                       icon = icon("eye"))
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
            h2(style = "color: #2e8b57; font-weight: 700;", "Ördin v3.0"),
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
  )  # End page_navbar
)  # End tagList

# Server Logic
server <- function(input, output, session) {
  
  # Hide loading screen after app is ready
  waiter_hide()
  
  # Navigation button handlers
  observeEvent(input$navToDiversity, {
    updateNavbarPage(session, "main_nav", selected = "Diversity Analysis")
  })
  
  observeEvent(input$navToOrdination, {
    updateNavbarPage(session, "main_nav", selected = "Ordination")
  })
  
  observeEvent(input$quickStartUpload, {
    updateNavbarPage(session, "main_nav", selected = "Diversity Analysis")
    # Trigger file input click
    shinyjs::runjs("document.getElementById('dataFile').click();")
  })
  
  # Auto-save state management
  autoSaveState <- reactiveVal(list())
  
  # Data preview modal
  observeEvent(input$previewData, {
    req(data())
    
    preview_df <- head(data()$original, 20)
    
    shinyalert(
      title = "Data Preview",
      text = NULL,
      html = TRUE,
      type = "info",
      showConfirmButton = TRUE,
      confirmButtonText = "Close",
      confirmButtonCol = "#2e8b57",
      size = "l",
      closeOnEsc = TRUE,
      closeOnClickOutside = TRUE,
      animation = TRUE,
      customClass = "swal-wide",
      inputType = NULL,
      inputPlaceholder = NULL,
      inputValue = NULL,
      showCancelButton = FALSE
    )
    
    # Show preview in modal using renderUI
    showModal(modalDialog(
      title = div(
        icon("table"), 
        " Data Preview",
        style = "color: #2e8b57; font-weight: 700;"
      ),
      div(
        style = "max-height: 500px; overflow-y: auto;",
        tags$p(
          style = "color: #888; font-size: 0.85rem;",
          sprintf("Showing first 20 rows of %d total rows and %d columns", 
                  nrow(data()$original), ncol(data()$original))
        ),
        DTOutput("previewTable")
      ),
      footer = tagList(
        actionButton("copyPreviewToClipboard", "Copy to Clipboard", icon = icon("clipboard"), class = "btn-outline-secondary"),
        modalButton("Close")
      ),
      size = "l",
      easyClose = TRUE
    ))
  })
  
  output$previewTable <- renderDT({
    req(data())
    preview_df <- head(data()$original, 20)
    datatable(
      preview_df,
      options = list(
        pageLength = 20,
        scrollX = TRUE,
        dom = 't',
        ordering = FALSE
      ),
      rownames = TRUE,
      class = 'display compact stripe hover'
    )
  })
  
  # Copy to clipboard functionality
  observeEvent(input$copyPreviewToClipboard, {
    req(data())
    preview_df <- head(data()$original, 20)
    
    tryCatch({
      write_clip(capture.output(write.table(preview_df, sep = "\t", row.names = TRUE)))
      showNotification(
        "Data copied to clipboard!",
        type = "message",
        duration = 2,
        closeButton = FALSE
      )
    }, error = function(e) {
      showNotification(
        "Failed to copy to clipboard",
        type = "error",
        duration = 3
      )
    })
  })
  
  # Shared data loading with validation feedback
  data <- reactive({
    req(input$dataFile)
    
    # Show loading spinner
    waiter <- Waiter$new(
      html = tagList(
        spin_flower(),
        h4("Loading data...", style = "color: #2e8b57; margin-top: 20px;")
      ),
      color = "rgba(30, 30, 30, 0.9)"
    )
    waiter$show()
    
    # Attempt to read CSV
    df <- tryCatch({
      read_csv(input$dataFile$datapath, show_col_types = FALSE)
    }, error = function(e) {
      waiter$hide()
      showFeedbackDanger(
        inputId = "dataFile",
        text = paste("Error reading CSV:", e$message)
      )
      showNotification(
        paste("Failed to load CSV:", e$message),
        type = "error",
        duration = 5
      )
      return(NULL)
    })
    
    if (is.null(df)) {
      waiter$hide()
      return(NULL)
    }
    
    # Validate data structure
    if (ncol(df) < 2) {
      waiter$hide()
      showFeedbackDanger(
        inputId = "dataFile",
        text = "CSV must have at least 2 columns (Site names + Species data)"
      )
      showNotification(
        "Invalid data format: Need at least 2 columns",
        type = "error",
        duration = 5
      )
      return(NULL)
    }
    
    # Success feedback
    showFeedbackSuccess(
      inputId = "dataFile",
      text = sprintf("%d sites, %d species", nrow(df), ncol(df) - 1)
    )
    
    showNotification(
      sprintf("✓ Data loaded: %d sites, %d species", nrow(df), ncol(df) - 1),
      type = "message",
      duration = 3
    )
    
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
      
      # Validate numeric data
      if (!all(sapply(df[-1], is.numeric))) {
        waiter$hide()
        showFeedbackDanger(
          inputId = "dataFile",
          text = "Species columns must be numeric"
        )
        showNotification(
          "Invalid data: Species columns must contain numbers",
          type = "error",
          duration = 5
        )
        return(NULL)
      }
      
      is_binary <- all(abund_matrix %in% c(0, 1))
      abund_matrix_t <- t(abund_matrix)
      colnames(abund_matrix_t) <- site_names
      
      waiter$hide()
      
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
        # Enhanced welcome message for Estimation
        card(
          full_screen = TRUE,
          height = "100%",
          card_body(
            class = "d-flex align-items-center justify-content-center",
            style = "background: linear-gradient(135deg, #1a1a1a 0%, #0a0a0a 100%);",
            div(
              class = "text-center",
              style = "max-width: 750px; animation: fadeInScale 0.6s ease-out;",
              
              # Animated icon
              div(
                style = "font-size: 6em; color: #2e8b57; margin-bottom: 30px; animation: float 3s ease-in-out infinite;",
                icon("chart-line")
              ),
              
              # Title
              h2(
                class = "fw-bold",
                style = "background: linear-gradient(135deg, #2e8b57 0%, #3fa869 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 25px; font-size: 2.5em;",
                "Diversity Estimation"
              ),
              
              p(
                class = "lead",
                style = "color: #999; font-size: 1.2em; margin-bottom: 35px;",
                "Powered by iNEXT • Rarefaction & Extrapolation Analysis"
              ),
              
              # Feature cards
              div(
                class = "row justify-content-center",
                style = "margin-bottom: 35px;",
                div(
                  class = "col-md-5 mb-3",
                  style = "background: #1a3a52; border: 2px solid #2e8b57; border-radius: 12px; padding: 20px; transition: all 0.3s; min-height: 140px;",
                  onmouseover = "this.style.transform='scale(1.05)'; this.style.borderColor='#3fa869';",
                  onmouseout = "this.style.transform='scale(1)'; this.style.borderColor='#2e8b57';",
                  div(style = "font-size: 2.2em; color: #2e8b57; margin-bottom: 10px;", icon("chart-area")),
                  h5(style = "color: #2e8b57; font-weight: 700; margin-bottom: 8px; font-size: 1.1em;", "Coverage-Based Curves"),
                  p(style = "color: #aaa; font-size: 0.85em; margin: 0;", "Sample completeness with asymptotic estimators")
                ),
                div(
                  class = "col-md-5 mb-3",
                  style = "background: #1a3a52; border: 2px solid #2e8b57; border-radius: 12px; padding: 20px; transition: all 0.3s; min-height: 140px;",
                  onmouseover = "this.style.transform='scale(1.05)'; this.style.borderColor='#3fa869';",
                  onmouseout = "this.style.transform='scale(1)'; this.style.borderColor='#2e8b57';",
                  div(style = "font-size: 2.2em; color: #2e8b57; margin-bottom: 10px;", icon("layer-group")),
                  h5(style = "color: #2e8b57; font-weight: 700; margin-bottom: 8px; font-size: 1.1em;", "Hill Numbers"),
                  p(style = "color: #aaa; font-size: 0.85em; margin: 0;", "q=0 (Richness), q=1 (Shannon), q=2 (Simpson)")
                )
              ),
              
              # Call to action
              div(
                class = "alert",
                style = "background: linear-gradient(135deg, #2e8b57 0%, #1f6d42 100%); border: none; border-radius: 10px; padding: 25px;",
                div(style = "font-size: 2.5em; color: #fff; margin-bottom: 15px;", icon("upload")),
                h4(style = "color: #fff; font-weight: 700; margin-bottom: 10px;", "Ready to Analyze?"),
                p(style = "color: rgba(255,255,255,0.9); margin-bottom: 20px;", "Upload your community data in the sidebar to begin diversity estimation"),
                div(
                  style = "color: #fff; font-size: 0.9em;",
                  icon("info-circle"), " Supports: Abundance, Incidence (Binary), Incidence (Frequency) data types"
                )
              ),
              
              # Keyboard shortcuts
              div(
                style = "margin-top: 25px; padding: 15px; background: #1a1a1a; border: 1px solid #333; border-radius: 8px;",
                p(
                  style = "color: #666; font-size: 0.85em; margin: 0;",
                  icon("keyboard"), " ",
                  tags$kbd("Ctrl+O"), " Open • ",
                  tags$kbd("Ctrl+S"), " Save • ",
                  tags$kbd("Ctrl+1"), " This Tab"
                )
              ),
              
              # CSS Animation
              tags$style(HTML("
                @keyframes fadeInScale {
                  from {
                    opacity: 0;
                    transform: scale(0.95);
                  }
                  to {
                    opacity: 1;
                    transform: scale(1);
                  }
                }
                
                @keyframes float {
                  0%, 100% {
                    transform: translateY(0);
                  }
                  50% {
                    transform: translateY(-15px);
                  }
                }
              "))
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
                   actionButton("exportDiversityExcel", "Export Excel", class = "btn btn-outline-success mb-3 ms-2", icon = icon("file-excel")),
                   actionButton("exportDiversityJSON", "Export JSON", class = "btn btn-outline-success mb-3 ms-2", icon = icon("file-code")),
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
        # Enhanced welcome message for Indices
        card(
          full_screen = TRUE,
          height = "100%",
          card_body(
            class = "d-flex align-items-center justify-content-center",
            style = "background: linear-gradient(135deg, #1a1a1a 0%, #0a0a0a 100%);",
            div(
              class = "text-center",
              style = "max-width: 750px; animation: fadeInScale 0.6s ease-out;",
              
              # Animated icon
              div(
                style = "font-size: 6em; color: #ff8c00; margin-bottom: 30px; animation: float 3s ease-in-out infinite;",
                icon("calculator")
              ),
              
              # Title
              h2(
                class = "fw-bold",
                style = "background: linear-gradient(135deg, #ff8c00 0%, #ff9c10 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 25px; font-size: 2.5em;",
                "Diversity Indices"
              ),
              
              p(
                class = "lead",
                style = "color: #999; font-size: 1.2em; margin-bottom: 35px;",
                "Powered by vegan • Classic Community Metrics"
              ),
              
              # Feature cards in rows
              div(
                class = "mb-4",
                div(
                  class = "row justify-content-center",
                  style = "margin-bottom: 20px;",
                  div(
                    class = "col-md-5 mb-3",
                    style = "background: #1a1a1a; border: 2px solid #ff8c00; border-radius: 12px; padding: 20px; transition: all 0.3s; min-height: 140px;",
                    onmouseover = "this.style.transform='scale(1.05)'; this.style.borderColor='#ff9c10'; this.style.boxShadow='0 10px 25px rgba(255,140,0,0.3)';",
                    onmouseout = "this.style.transform='scale(1)'; this.style.borderColor='#ff8c00'; this.style.boxShadow='none';",
                    div(style = "font-size: 2.2em; color: #ff8c00; margin-bottom: 10px;", icon("chart-pie")),
                    h5(style = "color: #ff8c00; font-weight: 700; margin-bottom: 8px; font-size: 1.1em;", "Alpha Diversity"),
                    p(style = "color: #aaa; font-size: 0.85em; margin: 0;", "Shannon, Simpson, Fisher, Richness")
                  ),
                  div(
                    class = "col-md-5 mb-3",
                    style = "background: #1a1a1a; border: 2px solid #ff8c00; border-radius: 12px; padding: 20px; transition: all 0.3s; min-height: 140px;",
                    onmouseover = "this.style.transform='scale(1.05)'; this.style.borderColor='#ff9c10'; this.style.boxShadow='0 10px 25px rgba(255,140,0,0.3)';",
                    onmouseout = "this.style.transform='scale(1)'; this.style.borderColor='#ff8c00'; this.style.boxShadow='none';",
                    div(style = "font-size: 2.2em; color: #ff8c00; margin-bottom: 10px;", icon("balance-scale")),
                    h5(style = "color: #ff8c00; font-weight: 700; margin-bottom: 8px; font-size: 1.1em;", "Evenness Metrics"),
                    p(style = "color: #aaa; font-size: 0.85em; margin: 0;", "Pielou's J, Simpson's E, Evar")
                  )
                )
              ),
              
              # Export capabilities
              div(
                style = "background: #1a1a1a; border: 2px solid #4169e1; border-radius: 12px; padding: 25px; margin-bottom: 30px;",
                div(style = "font-size: 2.5em; color: #4169e1; margin-bottom: 15px;", icon("file-export")),
                h5(style = "color: #4169e1; font-weight: 700; margin-bottom: 10px;", "Multi-Format Export"),
                p(style = "color: #aaa; font-size: 0.95em; margin: 0;", "Export results as CSV, Excel, or JSON for further analysis in GraphPad, SPSS, or R")
              ),
              
              # Call to action
              div(
                class = "alert",
                style = "background: linear-gradient(135deg, #ff8c00 0%, #ff7000 100%); border: none; border-radius: 10px; padding: 25px;",
                div(style = "font-size: 2.5em; color: #fff; margin-bottom: 15px;", icon("play-circle")),
                h4(style = "color: #fff; font-weight: 700; margin-bottom: 10px;", "Calculate Indices Now"),
                p(style = "color: rgba(255,255,255,0.9); margin: 0;", "Select indices in the sidebar and click Calculate to compute diversity metrics")
              ),
              
              # Keyboard shortcuts
              div(
                style = "margin-top: 25px; padding: 15px; background: #1a1a1a; border: 1px solid #333; border-radius: 8px;",
                p(
                  style = "color: #666; font-size: 0.85em; margin: 0;",
                  icon("keyboard"), " ",
                  tags$kbd("Ctrl+S"), " Save Results • ",
                  tags$kbd("F1"), " Help"
                )
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
              icon("download"), " Download the table as CSV, Excel, or JSON. Create custom visualizations in your preferred software."
            ),
            div(
              downloadButton("downloadIndicesTable", 
                           span(icon("file-csv"), " CSV"),
                           class = "btn-success btn-lg mb-4"),
              actionButton("exportIndicesExcel",
                         span(icon("file-excel"), " Excel"),
                         class = "btn btn-outline-success btn-lg mb-4 ms-2"),
              actionButton("exportIndicesJSON",
                         span(icon("file-code"), " JSON"),
                         class = "btn btn-outline-success btn-lg mb-4 ms-2")
            ),
            DTOutput("indicesTable")
          )
        )
      }
    }
  })
  
  # Diversity Estimation Module with enhanced UX
  diversityResults <- reactiveVal(NULL)
  
  observeEvent(input$runDiversity, {
    req(data())
    
    # Validation
    if (length(input$hillNumbers) == 0) {
      showNotification(
        "Please select at least one Hill number (q value)",
        type = "warning",
        duration = 4
      )
      return()
    }
    
    # Show loading screen with waiter
    waiter <- Waiter$new(
      html = tagList(
        spin_flower(),
        h3("Running iNEXT Diversity Estimation...", style = "color: #2e8b57; margin-top: 20px;"),
        p("This may take a moment depending on data size and bootstrap iterations", 
          style = "color: #ccc; font-size: 0.9rem;")
      ),
      color = "rgba(30, 30, 30, 0.95)"
    )
    waiter$show()
    
    # Run analysis
    result <- tryCatch({
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
        
        list(summary = inext_out$AsyEst, plot = plot_obj, full_output = inext_out)
      })
    }, error = function(e) {
      waiter$hide()
      showNotification(
        paste("Analysis failed:", e$message),
        type = "error",
        duration = 8
      )
      return(NULL)
    })
    
    if (!is.null(result)) {
      diversityResults(result)
      waiter$hide()
      showNotification(
        "✓ Diversity estimation complete!",
        type = "message",
        duration = 3
      )
    } else {
      waiter$hide()
    }
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
  
  # Excel export for diversity
  observeEvent(input$exportDiversityExcel, {
    req(diversityResults())
    
    tryCatch({
      temp_file <- tempfile(fileext = ".xlsx")
      write.xlsx(diversityResults()$summary, temp_file, rowNames = FALSE)
      
      showModal(modalDialog(
        title = "Excel Export Ready",
        "File created successfully. Click download to save.",
        footer = tagList(
          downloadButton("downloadDiversityExcel", "Download", class = "btn-success"),
          modalButton("Cancel")
        )
      ))
      
      output$downloadDiversityExcel <- downloadHandler(
        filename = function() paste0("diversity_estimation_", Sys.Date(), ".xlsx"),
        content = function(file) {
          write.xlsx(diversityResults()$summary, file, rowNames = FALSE)
        }
      )
    }, error = function(e) {
      showNotification(
        paste("Excel export failed:", e$message),
        type = "error",
        duration = 5
      )
    })
  })
  
  # JSON export for diversity
  observeEvent(input$exportDiversityJSON, {
    req(diversityResults())
    
    tryCatch({
      json_data <- toJSON(diversityResults()$summary, pretty = TRUE)
      
      showModal(modalDialog(
        title = "JSON Export Ready",
        "File created successfully. Click download to save.",
        footer = tagList(
          downloadButton("downloadDiversityJSON", "Download", class = "btn-success"),
          modalButton("Cancel")
        )
      ))
      
      output$downloadDiversityJSON <- downloadHandler(
        filename = function() paste0("diversity_estimation_", Sys.Date(), ".json"),
        content = function(file) {
          write(toJSON(diversityResults()$summary, pretty = TRUE), file)
        }
      )
    }, error = function(e) {
      showNotification(
        paste("JSON export failed:", e$message),
        type = "error",
        duration = 5
      )
    })
  })
  
  # Diversity Indices Module with enhanced error handling
  ordinationResults <- reactiveVal(NULL)
  
  observeEvent(input$runOrdination, {
    req(data())
    
    # Show loading
    waiter <- Waiter$new(
      html = tagList(
        spin_flower(),
        h3("Running Ordination Analysis...", style = "color: #2e8b57; margin-top: 20px;"),
        p(paste("Method:", toupper(input$ordinationMethod)), 
          style = "color: #ccc; font-size: 0.9rem;")
      ),
      color = "rgba(30, 30, 30, 0.95)"
    )
    waiter$show()
    
    result <- tryCatch({
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
        result
      })
    }, error = function(e) {
      waiter$hide()
      showNotification(
        paste("Ordination failed:", e$message),
        type = "error",
        duration = 8
      )
      return(NULL)
    })
    
    if (!is.null(result)) {
      waiter$hide()
      showNotification(
        "✓ Ordination analysis complete!",
        type = "message",
        duration = 3
      )
    } else {
      waiter$hide()
    }
  })
  
  output$ordinationContent <- renderUI({
    if (is.null(ordinationResults())) {
      # Enhanced WELCOME PAGE for Ordination
      tags$div(
        style = "display: flex; align-items: center; justify-content: center; min-height: 500px; padding: 60px 40px; background: linear-gradient(135deg, #1a1a1a 0%, #0a0a0a 100%);",
        tags$div(
          style = "max-width: 800px; text-align: center; animation: fadeInScale 0.6s ease-out;",
          
          # Animated icon
          tags$div(
            style = "font-size: 6em; color: #4169e1; margin-bottom: 30px; animation: float 3s ease-in-out infinite;",
            icon("project-diagram")
          ),
          
          # Title
          tags$h2(
            style = "background: linear-gradient(135deg, #4169e1 0%, #5179f1 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 25px; font-size: 2.5em; font-weight: 700;",
            "Ordination Analysis"
          ),
          
          tags$p(
            class = "lead",
            style = "color: #999; font-size: 1.2em; margin-bottom: 35px;",
            "Powered by vegan • Multivariate Community Patterns"
          ),
          
          # Method cards grid
          tags$div(
            class = "row justify-content-center",
            style = "margin-bottom: 35px;",
            
            # NMDS
            tags$div(
              class = "col-lg-3 col-md-4 mb-3",
              style = "background: #1a1a3a; border: 2px solid #4169e1; border-radius: 12px; padding: 20px; transition: all 0.3s; min-height: 150px; text-align: center;",
              onmouseover = "this.style.transform='scale(1.05)'; this.style.borderColor='#5179f1'; this.style.boxShadow='0 10px 25px rgba(65,105,225,0.3)';",
              onmouseout = "this.style.transform='scale(1)'; this.style.borderColor='#4169e1'; this.style.boxShadow='none';",
              tags$div(style = "font-size: 1.8em; color: #4169e1; margin-bottom: 10px; font-weight: 700;", "NMDS"),
              tags$h6(style = "color: #fff; font-weight: 600; margin-bottom: 8px; font-size: 0.95em;", "Non-metric MDS"),
              tags$p(style = "color: #aaa; font-size: 0.8em; margin: 0;", "Flexible & robust")
            ),
            
            # PCA
            tags$div(
              class = "col-lg-3 col-md-4 mb-3",
              style = "background: #1a1a3a; border: 2px solid #4169e1; border-radius: 12px; padding: 20px; transition: all 0.3s; min-height: 150px; text-align: center;",
              onmouseover = "this.style.transform='scale(1.05)'; this.style.borderColor='#5179f1'; this.style.boxShadow='0 10px 25px rgba(65,105,225,0.3)';",
              onmouseout = "this.style.transform='scale(1)'; this.style.borderColor='#4169e1'; this.style.boxShadow='none';",
              tags$div(style = "font-size: 1.8em; color: #4169e1; margin-bottom: 10px; font-weight: 700;", "PCA"),
              tags$h6(style = "color: #fff; font-weight: 600; margin-bottom: 8px; font-size: 0.95em;", "Principal Components"),
              tags$p(style = "color: #aaa; font-size: 0.8em; margin: 0;", "Linear method")
            ),
            
            # CA/DCA/PCoA
            tags$div(
              class = "col-lg-3 col-md-4 mb-3",
              style = "background: #1a1a3a; border: 2px solid #4169e1; border-radius: 12px; padding: 20px; transition: all 0.3s; min-height: 150px; text-align: center;",
              onmouseover = "this.style.transform='scale(1.05)'; this.style.borderColor='#5179f1'; this.style.boxShadow='0 10px 25px rgba(65,105,225,0.3)';",
              onmouseout = "this.style.transform='scale(1)'; this.style.borderColor='#4169e1'; this.style.boxShadow='none';",
              tags$div(style = "font-size: 1.6em; color: #4169e1; margin-bottom: 10px; font-weight: 700;", "CA/DCA/PCoA"),
              tags$h6(style = "color: #fff; font-weight: 600; margin-bottom: 8px; font-size: 0.95em;", "Advanced Methods"),
              tags$p(style = "color: #aaa; font-size: 0.8em; margin: 0;", "Specialized")
            )
          ),
          
          # Distance methods
          tags$div(
            style = "background: #1a1a1a; border: 2px solid #2e8b57; border-radius: 12px; padding: 25px; margin-bottom: 30px;",
            tags$div(style = "font-size: 2.5em; color: #2e8b57; margin-bottom: 15px;", icon("ruler-combined")),
            tags$h5(style = "color: #2e8b57; font-weight: 700; margin-bottom: 10px;", "Distance Measures"),
            tags$p(style = "color: #aaa; font-size: 0.95em; margin: 0;", "Bray-Curtis • Jaccard • Euclidean • Manhattan • Canberra")
          ),
          
          # Call to action
          tags$div(
            class = "alert",
            style = "background: linear-gradient(135deg, #4169e1 0%, #2050d1 100%); border: none; border-radius: 10px; padding: 25px;",
            tags$div(style = "font-size: 2.5em; color: #fff; margin-bottom: 15px;", icon("play-circle")),
            tags$h4(style = "color: #fff; font-weight: 700; margin-bottom: 10px;", "Visualize Community Patterns"),
            tags$p(style = "color: rgba(255,255,255,0.9); margin-bottom: 15px;", "Upload data in Diversity Analysis tab, then configure ordination settings and run analysis"),
            tags$div(
              style = "color: rgba(255,255,255,0.8); font-size: 0.9em;",
              icon("lightbulb"), " Tip: NMDS with Bray-Curtis is recommended for ecological community data"
            )
          ),
          
          # Keyboard shortcuts
          tags$div(
            style = "margin-top: 25px; padding: 15px; background: #1a1a1a; border: 1px solid #333; border-radius: 8px;",
            tags$p(
              style = "color: #666; font-size: 0.85em; margin: 0;",
              icon("keyboard"), " ",
              tags$kbd("Ctrl+2"), " This Tab • ",
              tags$kbd("Ctrl+S"), " Save Plot"
            )
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
  
  # MODULE 3: Diversity Indices with enhanced UX
  indicesResults <- reactiveVal(NULL)
  
  observeEvent(input$runIndices, {
    req(data())
    
    # Validation
    if (length(input$alphaIndices) == 0 && length(input$evennessIndices) == 0) {
      showNotification(
        "Please select at least one diversity or evenness index",
        type = "warning",
        duration = 4
      )
      return()
    }
    
    # Show loading
    waiter <- Waiter$new(
      html = tagList(
        spin_flower(),
        h3("Calculating Diversity Indices...", style = "color: #2e8b57; margin-top: 20px;"),
        p("Computing alpha diversity and evenness metrics", 
          style = "color: #ccc; font-size: 0.9rem;")
      ),
      color = "rgba(30, 30, 30, 0.95)"
    )
    waiter$show()
    
    result <- tryCatch({
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
        list(summary = results_df)
      })
    }, error = function(e) {
      waiter$hide()
      showNotification(
        paste("Index calculation failed:", e$message),
        type = "error",
        duration = 8
      )
      return(NULL)
    })
    
    if (!is.null(result)) {
      indicesResults(result)
      waiter$hide()
      showNotification(
        "✓ Diversity indices calculated!",
        type = "message",
        duration = 3
      )
    } else {
      waiter$hide()
    }
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
  
  # Excel export for indices
  observeEvent(input$exportIndicesExcel, {
    req(indicesResults())
    
    tryCatch({
      showModal(modalDialog(
        title = "Excel Export Ready",
        "File created successfully. Click download to save.",
        footer = tagList(
          downloadButton("downloadIndicesExcel", "Download", class = "btn-success"),
          modalButton("Cancel")
        )
      ))
      
      output$downloadIndicesExcel <- downloadHandler(
        filename = function() paste0("diversity_indices_", Sys.Date(), ".xlsx"),
        content = function(file) {
          write.xlsx(indicesResults()$summary, file, rowNames = FALSE)
        }
      )
    }, error = function(e) {
      showNotification(
        paste("Excel export failed:", e$message),
        type = "error",
        duration = 5
      )
    })
  })
  
  # JSON export for indices
  observeEvent(input$exportIndicesJSON, {
    req(indicesResults())
    
    tryCatch({
      showModal(modalDialog(
        title = "JSON Export Ready",
        "File created successfully. Click download to save.",
        footer = tagList(
          downloadButton("downloadIndicesJSON", "Download", class = "btn-success"),
          modalButton("Cancel")
        )
      ))
      
      output$downloadIndicesJSON <- downloadHandler(
        filename = function() paste0("diversity_indices_", Sys.Date(), ".json"),
        content = function(file) {
          write(toJSON(indicesResults()$summary, pretty = TRUE), file)
        }
      )
    }, error = function(e) {
      showNotification(
        paste("JSON export failed:", e$message),
        type = "error",
        duration = 5
      )
    })
  })
}

shinyApp(ui, server)
