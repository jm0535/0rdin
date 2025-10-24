# Ördin v3.0 - Community Ecology Analysis Platform
# Enterprise-grade implementation with advanced UI/UX

library(bslib)
library(vegan)
library(iNEXT)
library(ggplot2)
library(DT)
library(readr)
library(readxl)          # Excel file support
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
library(viridis)         # Viridis color palettes
library(RColorBrewer)    # ColorBrewer palettes

# UI Definition
ui <- tagList(
  useShinyjs(),  # Initialize shinyjs
  use_waiter(),  # Initialize waiter
  useShinyFeedback(),  # Initialize shinyFeedback
  waiter_show_on_load(
    html = tagList(
      spin_loaders(42, color = "#2e8b57"),  # Professional spinner with Ördin green
      h2("Ördin v3.0", style = "color: #2e8b57; margin-top: 30px; font-weight: 800; font-size: 3em; letter-spacing: 2px;"),
      p("Community Ecology Analysis Platform", style = "color: #999; font-size: 1.1rem; margin-top: 10px; letter-spacing: 1px;"),
      tags$div(
        style = "margin-top: 30px; color: #666; font-size: 0.9rem;",
        icon("flask"), " Loading modules and initializing environment..."
      ),
      tags$div(
        style = "margin-top: 20px; color: #2e8b57; font-size: 1rem; font-weight: bold;",
        "Version 3.0 - Enterprise Edition"
      ),
      tags$div(
        style = "position: absolute; bottom: 20px; width: 100%; text-align: center; color: #666; font-size: 0.8rem;",
        "Developed by Jimmy Moses (jimmy.moses@pnguot.ac.pg)",
        br(),
        "PNGUOT Community Ecology Research Group"
      )
    ),
    color = "#1a1a1a"
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
      
      // Theme toggle functionality (for Ctrl+T shortcut)
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
        
        // Update theme selector in settings
        const themeSelector = document.getElementById("themeSelector");
        if (themeSelector) {
          themeSelector.value = newTheme;
        }
      }
      
      // Handle theme change from settings dropdown
      function handleThemeChange(theme) {
        const body = document.body;
        
        if (theme === "auto") {
          // Use system preference
          const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
          theme = prefersDark ? "dark" : "light";
        }
        
        if (theme === "light") {
          body.classList.add("light-theme");
          body.classList.remove("dark-theme");
        } else {
          body.classList.add("dark-theme");
          body.classList.remove("light-theme");
        }
        
        localStorage.setItem("ordin-theme", theme);
        
        // Send to Shiny
        Shiny.setInputValue("settingsTheme", theme);
      }
      
      // Handle font size change
      function handleFontSizeChange(size) {
        const body = document.body;
        body.classList.remove("font-small", "font-medium", "font-large");
        body.classList.add("font-" + size);
        localStorage.setItem("ordin-font-size", size);
        Shiny.setInputValue("settingsFontSize", size);
      }
      
      // Save settings to localStorage when changed
      function saveSettingToLocalStorage(key, value) {
        localStorage.setItem("ordin-" + key, value);
      }
      
      // Toggle settings sidebar
      function toggleSettingsSidebar() {
        const sidebar = document.getElementById("settings-sidebar");
        const overlay = document.getElementById("settings-overlay");
        const isOpen = sidebar.style.right === "0px";
        
        if (isOpen) {
          // Close sidebar
          sidebar.style.right = "-400px";
          overlay.style.display = "none";
          overlay.style.opacity = "0";
          document.body.style.overflow = "auto";
        } else {
          // Open sidebar
          sidebar.style.right = "0px";
          overlay.style.display = "block";
          setTimeout(() => { overlay.style.opacity = "1"; }, 10);
          document.body.style.overflow = "hidden";
        }
      }
      
      // Zoom functionality
      let currentZoom = 100;
      
      function zoomIn() {
        if (currentZoom < 200) {
          currentZoom += 10;
          applyZoom();
        }
      }
      
      function zoomOut() {
        if (currentZoom > 50) {
          currentZoom -= 10;
          applyZoom();
        }
      }
      
      function zoomReset() {
        currentZoom = 100;
        applyZoom();
      }
      
      function applyZoom() {
        document.body.style.zoom = currentZoom + "%";
        document.getElementById("zoom-level").textContent = currentZoom + "%";
        localStorage.setItem("ordin-zoom-level", currentZoom);
        Shiny.setInputValue("settingsZoomLevel", currentZoom);
      }
      
      // Reset all settings to defaults
      function resetAllSettings() {
        // Clear localStorage
        localStorage.removeItem("ordin-theme");
        localStorage.removeItem("ordin-font-size");
        localStorage.removeItem("ordin-autosave-timestamp");
        localStorage.removeItem("ordin-zoom-level");
        localStorage.removeItem("ordin-ggplot-theme");
        localStorage.removeItem("ordin-plot-dpi");
        localStorage.removeItem("ordin-color-palette");
        
        // Reset theme to dark
        handleThemeChange("dark");
        
        // Reset font size to medium
        handleFontSizeChange("medium");
        
        // Reset zoom to 100%
        currentZoom = 100;
        applyZoom();
        
        // Reset toggles
        document.getElementById("autoSaveToggle").checked = true;
        document.getElementById("notificationsToggle").checked = true;
        
        // Reset selects
        document.getElementById("themeSelector").value = "dark";
        document.getElementById("fontSizeSelector").value = "medium";
        document.getElementById("exportFormatSelector").value = "csv";
        document.getElementById("decimalPrecisionSelector").value = "3";
        document.getElementById("ggplotThemeSelector").value = "minimal";
        document.getElementById("plotDpiSelector").value = "300";
        document.getElementById("colorPaletteSelector").value = "ordin";
        
        // Notify user
        alert("Settings reset to defaults!");
        
        // Notify Shiny
        Shiny.setInputValue("settingsReset", Date.now());
      }
      
      // Load saved theme on startup
      document.addEventListener("DOMContentLoaded", function() {
        // Load saved theme
        const savedTheme = localStorage.getItem("ordin-theme") || "dark";
        const body = document.body;
        
        if (savedTheme === "light") {
          body.classList.add("light-theme");
          body.classList.remove("dark-theme");
        } else {
          body.classList.add("dark-theme");
          body.classList.remove("light-theme");
        }
        
        // Load saved font size
        const savedFontSize = localStorage.getItem("ordin-font-size") || "medium";
        body.classList.add("font-" + savedFontSize);
        
        // Load saved zoom level
        const savedZoom = localStorage.getItem("ordin-zoom-level");
        if (savedZoom) {
          currentZoom = parseInt(savedZoom);
          document.body.style.zoom = currentZoom + "%";
          const zoomElement = document.getElementById("zoom-level");
          if (zoomElement) {
            zoomElement.textContent = currentZoom + "%";
          }
        }
        
        // Load settings into dropdown (with delay to ensure elements exist)
        setTimeout(function() {
          const themeSelector = document.getElementById("themeSelector");
          if (themeSelector) themeSelector.value = savedTheme;
          
          const fontSizeSelector = document.getElementById("fontSizeSelector");
          if (fontSizeSelector) fontSizeSelector.value = savedFontSize;
          
          // Load other settings from localStorage
          const autoSaveEnabled = localStorage.getItem("ordin-autosave-enabled");
          if (autoSaveEnabled !== null) {
            const toggle = document.getElementById("autoSaveToggle");
            if (toggle) toggle.checked = autoSaveEnabled === "true";
          }
          
          const notificationsEnabled = localStorage.getItem("ordin-notifications-enabled");
          if (notificationsEnabled !== null) {
            const toggle = document.getElementById("notificationsToggle");
            if (toggle) toggle.checked = notificationsEnabled === "true";
          }
          
          const exportFormat = localStorage.getItem("ordin-export-format");
          if (exportFormat) {
            const selector = document.getElementById("exportFormatSelector");
            if (selector) selector.value = exportFormat;
          }
          
          const decimalPrecision = localStorage.getItem("ordin-decimal-precision");
          if (decimalPrecision) {
            const selector = document.getElementById("decimalPrecisionSelector");
            if (selector) selector.value = decimalPrecision;
          }
          
          // Load plot settings
          const ggplotTheme = localStorage.getItem("ordin-ggplot-theme");
          if (ggplotTheme) {
            const selector = document.getElementById("ggplotThemeSelector");
            if (selector) selector.value = ggplotTheme;
          }
          
          const plotDpi = localStorage.getItem("ordin-plot-dpi");
          if (plotDpi) {
            const selector = document.getElementById("plotDpiSelector");
            if (selector) selector.value = plotDpi;
          }
          
          const colorPalette = localStorage.getItem("ordin-color-palette");
          if (colorPalette) {
            const selector = document.getElementById("colorPaletteSelector");
            if (selector) selector.value = colorPalette;
          }
        }, 500);
        
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
  
  # DATA MANAGEMENT TAB
  nav_panel(
    title = "Data",
    icon = icon("database"),
    
    # Custom layout with vertical sidebar navigation
    tags$div(
      class = "data-management-container",
      style = "display: flex; height: 100vh; overflow: hidden;",
      
      # Vertical Sub-Navigation Sidebar
      tags$div(
        id = "data-subnav",
        class = "data-vertical-nav",
        style = "width: 80px; background: #252526; border-right: 2px solid #3e3e42; display: flex; flex-direction: column; align-items: center; padding: 20px 0; transition: width 0.3s ease;",
        
        # Toggle sidebar button (at top)
        tags$button(
          class = "vertical-nav-btn",
          style = "width: 60px; height: 50px; background: transparent; border: 2px solid #666; border-radius: 8px; margin-bottom: 20px; cursor: pointer; transition: all 0.3s ease; display: flex; align-items: center; justify-content: center;",
          onclick = "toggleDataSidebar();",
          title = "Toggle Settings Panel",
          tags$div(style = "font-size: 1.2em; color: #999;", icon("bars"))
        ),
        
        tags$hr(style = "width: 60%; border-color: #444; margin: 0 0 20px 0;"),
        
        # Import Button
        tags$button(
          class = "vertical-nav-btn",
          id = "navImport",
          style = "width: 60px; height: 70px; background: transparent; border: 2px solid #4169e1; border-radius: 8px; margin-bottom: 15px; cursor: pointer; transition: all 0.3s ease; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 8px;",
          onclick = "Shiny.setInputValue('dataSubNav', 'import', {priority: 'event'}); document.querySelectorAll('#data-subnav .vertical-nav-btn[id^=nav]').forEach(b => b.style.background='transparent'); this.style.background='#4169e1';",
          title = "Import Data",
          tags$div(style = "font-size: 1.8em; color: #4169e1; margin-bottom: 4px;", icon("upload")),
          tags$div(style = "font-size: 0.65rem; color: #4169e1; text-align: center; line-height: 1.1;", "Import")
        ),
        
        # View/Edit Button
        tags$button(
          class = "vertical-nav-btn",
          id = "navEdit",
          style = "width: 60px; height: 70px; background: transparent; border: 2px solid #2e8b57; border-radius: 8px; margin-bottom: 15px; cursor: pointer; transition: all 0.3s ease; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 8px;",
          onclick = "Shiny.setInputValue('dataSubNav', 'edit', {priority: 'event'}); document.querySelectorAll('#data-subnav .vertical-nav-btn[id^=nav]').forEach(b => b.style.background='transparent'); this.style.background='#2e8b57';",
          title = "View & Edit",
          tags$div(style = "font-size: 1.8em; color: #2e8b57; margin-bottom: 4px;", icon("table")),
          tags$div(style = "font-size: 0.65rem; color: #2e8b57; text-align: center; line-height: 1.1;", "Edit")
        ),
        
        # Export Button
        tags$button(
          class = "vertical-nav-btn",
          id = "navExport",
          style = "width: 60px; height: 70px; background: transparent; border: 2px solid #ff8c00; border-radius: 8px; margin-bottom: 15px; cursor: pointer; transition: all 0.3s ease; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 8px;",
          onclick = "Shiny.setInputValue('dataSubNav', 'export', {priority: 'event'}); document.querySelectorAll('#data-subnav .vertical-nav-btn[id^=nav]').forEach(b => b.style.background='transparent'); this.style.background='#ff8c00';",
          title = "Export Data",
          tags$div(style = "font-size: 1.8em; color: #ff8c00; margin-bottom: 4px;", icon("download")),
          tags$div(style = "font-size: 0.65rem; color: #ff8c00; text-align: center; line-height: 1.1;", "Export")
        )
      ),
      
      # Main Content with Collapsible Settings Panel
      tags$div(
        style = "flex: 1; display: flex; overflow: hidden;",
        
        # Settings Panel (Collapsible)
        tags$div(
          id = "data-settings-panel",
          class = "data-settings",
          style = "width: 400px; background: #1e1e1e; border-right: 1px solid #3e3e42; overflow-y: auto; transition: width 0.3s ease, margin-left 0.3s ease;",
          
          # Settings content
          tags$div(
            style = "padding: 20px;",
            uiOutput("dataSettingsContent")
          )
        ),
        
        # Results Area
        tags$div(
          style = "flex: 1; overflow-y: auto; background: #1a1a1a;",
          uiOutput("dataMainContent")
        )
      )
    ),
    
    # CSS and JavaScript
    tags$style(HTML("
      .data-settings.collapsed {
        width: 0 !important;
        margin-left: -400px !important;
        overflow: hidden !important;
      }
    ")),
    
    tags$script(HTML("
      // Initialize first tab as active
      document.addEventListener('DOMContentLoaded', function() {
        setTimeout(function() {
          const importBtn = document.getElementById('navImport');
          if (importBtn) {
            importBtn.style.background = '#4169e1';
            Shiny.setInputValue('dataSubNav', 'import', {priority: 'event'});
          }
        }, 500);
      });
      
      // Toggle sidebar function
      function toggleDataSidebar() {
        const panel = document.getElementById('data-settings-panel');
        if (panel.classList.contains('collapsed')) {
          panel.classList.remove('collapsed');
        } else {
          panel.classList.add('collapsed');
        }
      }
    "))
  ),
  
  # DIVERSITY ANALYSIS
  nav_panel(
    title = "Diversity Analysis",
    icon = icon("chart-line"),
    
    # Custom layout with vertical sidebar navigation
    tags$div(
      class = "diversity-analysis-container",
      style = "display: flex; height: 100vh; overflow: hidden;",
      
      # Vertical Sub-Navigation Sidebar
      tags$div(
        id = "diversity-subnav",
        class = "diversity-vertical-nav",
        style = "width: 80px; background: #252526; border-right: 2px solid #3e3e42; display: flex; flex-direction: column; align-items: center; padding: 20px 0; transition: width 0.3s ease;",
        
        # Toggle sidebar button (at top)
        tags$button(
          class = "vertical-nav-btn",
          style = "width: 60px; height: 50px; background: transparent; border: 2px solid #666; border-radius: 8px; margin-bottom: 20px; cursor: pointer; transition: all 0.3s ease; display: flex; align-items: center; justify-content: center;",
          onclick = "toggleDiversitySidebar();",
          title = "Toggle Settings Panel",
          tags$div(style = "font-size: 1.2em; color: #999;", icon("bars"))
        ),
        
        tags$hr(style = "width: 60%; border-color: #444; margin: 0 0 20px 0;"),
        
        # Estimation Button
        tags$button(
          class = "vertical-nav-btn",
          id = "navEstimation",
          style = "width: 60px; height: 70px; background: transparent; border: 2px solid #2e8b57; border-radius: 8px; margin-bottom: 15px; cursor: pointer; transition: all 0.3s ease; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 8px;",
          onclick = "Shiny.setInputValue('diversitySubNav', 'estimation', {priority: 'event'}); document.querySelectorAll('#diversity-subnav .vertical-nav-btn[id^=nav]').forEach(b => b.style.background='transparent'); this.style.background='#2e8b57';",
          title = "Diversity Estimation (iNEXT)",
          tags$div(style = "font-size: 1.8em; color: #2e8b57; margin-bottom: 4px;", icon("chart-area")),
          tags$div(style = "font-size: 0.65rem; color: #2e8b57; text-align: center; line-height: 1.1;", "Estimation")
        ),
        
        # Indices Button
        tags$button(
          class = "vertical-nav-btn",
          id = "navIndices",
          style = "width: 60px; height: 70px; background: transparent; border: 2px solid #ff8c00; border-radius: 8px; margin-bottom: 15px; cursor: pointer; transition: all 0.3s ease; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 8px;",
          onclick = "Shiny.setInputValue('diversitySubNav', 'indices', {priority: 'event'}); document.querySelectorAll('#diversity-subnav .vertical-nav-btn[id^=nav]').forEach(b => b.style.background='transparent'); this.style.background='#ff8c00';",
          title = "Diversity Indices (vegan)",
          tags$div(style = "font-size: 1.8em; color: #ff8c00; margin-bottom: 4px;", icon("calculator")),
          tags$div(style = "font-size: 0.65rem; color: #ff8c00; text-align: center; line-height: 1.1;", "Indices")
        )
      ),
      
      # Main Content with Collapsible Settings Panel
      tags$div(
        style = "flex: 1; display: flex; overflow: hidden;",
        
        # Settings Panel (Collapsible)
        tags$div(
          id = "diversity-settings-panel",
          class = "diversity-settings",
          style = "width: 350px; background: #1e1e1e; border-right: 1px solid #3e3e42; overflow-y: auto; transition: width 0.3s ease, margin-left 0.3s ease;",
          
          # Settings content
          tags$div(
            style = "padding: 20px;",
            
            # Data Status
            tags$div(
              class = "mb-3",
              uiOutput("diversityDataStatus")
            ),
            
            tags$hr(style = "border-color: #444; margin: 20px 0;"),
            
            # Dynamic settings based on sub-nav
            uiOutput("diversitySettingsContent")
          )
        ),
        
        # Results Area
        tags$div(
          style = "flex: 1; overflow-y: auto; background: #1a1a1a;",
          uiOutput("diversityMainContent")
        )
      )
    ),
    
    # CSS and JavaScript for vertical nav
    tags$style(HTML("
      .vertical-nav-btn:hover {
        transform: translateX(5px);
        box-shadow: 0 4px 12px rgba(46, 139, 87, 0.3);
      }
      
      .diversity-vertical-nav.collapsed {
        width: 0 !important;
        padding: 0 !important;
        overflow: hidden;
      }
      
      .diversity-settings.collapsed {
        width: 0 !important;
        margin-left: -350px !important;
        overflow: hidden !important;
      }
    ")),
    
    tags$script(HTML("
      // Initialize first tab as active
      document.addEventListener('DOMContentLoaded', function() {
        setTimeout(function() {
          const estimationBtn = document.getElementById('navEstimation');
          if (estimationBtn) {
            estimationBtn.style.background = '#2e8b57';
            Shiny.setInputValue('diversitySubNav', 'estimation', {priority: 'event'});
          }
        }, 500);
      });
      
      // Toggle sidebar function
      function toggleDiversitySidebar() {
        const panel = document.getElementById('diversity-settings-panel');
        if (panel.classList.contains('collapsed')) {
          panel.classList.remove('collapsed');
        } else {
          panel.classList.add('collapsed');
        }
      }
    "))
  ),
  
  # ORDINATION
  nav_panel(
    title = "Ordination",
    icon = icon("project-diagram"),
    layout_sidebar(
      sidebar = sidebar(
        width = 350,
        card(
          card_header(
            "Ordination Settings"
          ),
          card_body(
            # Method Selection
            selectInput("ordinationMethod", "Method",
                       choices = c(
                         "NMDS" = "nmds",
                         "PCA" = "pca",
                         "CA" = "ca",
                         "DCA" = "dca",
                         "CCA" = "cca",
                         "RDA" = "rda",
                         "PCoA" = "pcoa"
                       )),
            
            # Ordination Dimensions
            numericInput("ordDimensions", "Dimensions", value = 2, min = 2, max = 5),
            
            # Distance Method (for NMDS, PCoA)
            conditionalPanel(
              condition = "input.ordinationMethod == 'nmds' || input.ordinationMethod == 'pcoa'",
              selectInput("distMethod", "Distance Measure",
                         choices = c(
                           "Bray-Curtis" = "bray",
                           "Jaccard" = "jaccard",
                           "Euclidean" = "euclidean",
                           "Manhattan" = "manhattan",
                           "Canberra" = "canberra",
                           "Kulczynski" = "kulczynski",
                           "Gower" = "gower",
                           "Morisita-Horn" = "horn"
                         ))
            ),
            
            # NMDS-specific parameters
            conditionalPanel(
              condition = "input.ordinationMethod == 'nmds'",
              accordion(
                accordion_panel(
                  title = "NMDS Parameters",
                  icon = icon("cog"),
                  numericInput("nmdsK", "Dimensions (k)", value = 2, min = 1, max = 6),
                  numericInput("nmdsTry", "Random Starts (try)", value = 20, min = 5, max = 100),
                  numericInput("nmdsTrymax", "Maximum Tries (trymax)", value = 100, min = 20, max = 500),
                  checkboxInput("nmdsAutotransform", "Auto-transform (Wisconsin double std)", value = TRUE),
                  selectInput("nmdsEngine", "Engine",
                             choices = c("monoMDS" = "monoMDS", "isoMDS" = "isoMDS")),
                  checkboxInput("nmdsWascores", "Expand to species scores", value = TRUE)
                )
              )
            ),
            
            # Scaling Options (for CA, CCA, RDA, DCA)
            conditionalPanel(
              condition = "input.ordinationMethod == 'ca' || input.ordinationMethod == 'cca' || input.ordinationMethod == 'rda' || input.ordinationMethod == 'dca'",
              selectInput("scalingType", "Biplot Scaling",
                         choices = c(
                           "Type 1 (Distance biplot)" = "1",
                           "Type 2 (Correlation biplot)" = "2",
                           "Type 3 (Symmetric)" = "3"
                         ),
                         selected = "2"),
              tags$div(
                style = "color: #888; font-size: 0.75rem; margin-top: -10px; margin-bottom: 15px; padding-left: 5px;",
                uiOutput("scalingExplanation")
              )
            ),
            
            # Transformation Options
            hr(style = "border-color: #444; margin: 15px 0;"),
            tags$div(
              style = "color: #4169e1; font-weight: 600; font-size: 0.9rem; margin-bottom: 10px;",
              icon("magic"), " Data Transformation"
            ),
            selectInput("dataTransform", "Pre-transformation",
                       choices = c(
                         "None" = "none",
                         "Hellinger" = "hellinger",
                         "Chi-square" = "chi.square",
                         "Log(x+1)" = "log",
                         "Square root" = "sqrt",
                         "Presence-Absence" = "pa",
                         "Wisconsin" = "wisconsin"
                       )),
            tags$div(
              style = "color: #888; font-size: 0.75rem; margin-top: -10px; margin-bottom: 10px; margin-left: 5px;",
              "Hellinger recommended for PCA with abundance data"
            ),
            
            # Biplot Options (CANOCO-style)
            hr(style = "border-color: #444; margin: 15px 0;"),
            tags$div(
              style = "color: #4169e1; font-weight: 600; font-size: 0.9rem; margin-bottom: 10px;",
              icon("layer-group"), " Biplot Overlays"
            ),
            
            # Environmental Arrows
            checkboxInput(
              "showEnvArrows",
              HTML("<span style='color: #ccc;'><b>Environmental vectors</b></span>"),
              value = FALSE
            ),
            
            conditionalPanel(
              condition = "input.showEnvArrows == true",
              tags$div(
                style = "margin-left: 24px; margin-top: -10px; margin-bottom: 10px;",
                sliderInput("arrowScaling", "Arrow scaling",
                           min = 0.2, max = 2.0, value = 0.8, step = 0.1),
                numericInput("arrowPvalue", "Significance threshold (p-value)",
                            value = 0.05, min = 0.001, max = 1, step = 0.01),
                checkboxInput("arrowShowPvalue", "Show p-values in labels", value = TRUE),
                selectInput("arrowLabelPos", "Label position",
                           choices = c("At arrow tip" = "tip", "Along arrow" = "along"))
              )
            ),
            
            # Factor Ellipses
            checkboxInput(
              "showEnvEllipses",
              HTML("<span style='color: #ccc;'><b>Confidence ellipses</b></span>"),
              value = FALSE
            ),
            
            conditionalPanel(
              condition = "input.showEnvEllipses == true",
              tags$div(
                style = "margin-left: 24px; margin-top: -10px; margin-bottom: 10px;",
                selectInput(
                  "ellipseFactor",
                  "Factor variable",
                  choices = NULL
                ),
                sliderInput("ellipseConfidence", "Confidence level",
                           min = 0.8, max = 0.99, value = 0.95, step = 0.01),
                selectInput("ellipseType", "Ellipse type",
                           choices = c(
                             "Normal (t-distribution)" = "t",
                             "Norm" = "norm",
                             "Euclidean" = "euclid"
                           )),
                checkboxInput("ellipseFill", "Fill ellipses", value = TRUE),
                conditionalPanel(
                  condition = "input.ellipseFill == true",
                  sliderInput("ellipseAlpha", "Fill transparency",
                             min = 0.05, max = 0.5, value = 0.15, step = 0.05)
                )
              )
            ),
            
            # Species Scores
            hr(style = "border-color: #444; margin: 10px 0;"),
            checkboxInput("showSpecies", HTML("<span style='color: #ccc;'><b>Species scores</b></span>"),
                         value = FALSE),
            
            conditionalPanel(
              condition = "input.showSpecies == true",
              tags$div(
                style = "margin-left: 24px; margin-top: -10px; margin-bottom: 10px;",
                radioButtons("speciesDisplay", "Display as",
                            choices = c("Points" = "points", "Labels" = "text", "Both" = "both"),
                            selected = "points", inline = TRUE),
                numericInput("speciesTopN", "Show top N species (0 = all)",
                            value = 20, min = 0, max = 100)
              )
            ),
            
            # Publication Settings
            hr(style = "border-color: #444; margin: 15px 0;"),
            tags$div(
              style = "color: #2e8b57; font-weight: 600; font-size = 0.9rem; margin-bottom: 10px;",
              icon("file-export"), " Publication Quality"
            ),
            
            checkboxInput("pubQuality", "Enable publication mode", value = FALSE),
            
            conditionalPanel(
              condition = "input.pubQuality == true",
              tags$div(
                style = "margin-left: 24px; margin-top: -10px; margin-bottom: 10px;",
                selectInput("plotTheme", "Plot theme",
                           choices = c("Dark (default)" = "dark",
                                      "Light" = "light",
                                      "Classic" = "classic",
                                      "Minimal" = "minimal",
                                      "Publication" = "publication"),
                           selected = "dark"),
                numericInput("plotWidth", "Width (inches)", value = 8, min = 4, max = 20),
                numericInput("plotHeight", "Height (inches)", value = 6, min = 4, max = 20),
                numericInput("baseFontSize", "Base font size (pt)", value = 12, min = 8, max = 20),
                numericInput("pointSize", "Point size", value = 3, min = 1, max = 8),
                numericInput("labelSize", "Label size", value = 3.5, min = 2, max = 8)
              )
            ),
            
            hr(style = "border-color: #444; margin: 15px 0;"),
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
    icon = icon("question-circle"),
    
    # Custom layout with sidebar navigation for help
    tags$div(
      class = "help-container",
      style = "display: flex; height: 100vh; overflow: hidden;",
      
      # Sidebar Navigation
      tags$div(
        id = "help-sidebar",
        class = "help-sidebar",
        style = "width: 250px; background: #252526; border-right: 2px solid #3e3e42; display: flex; flex-direction: column; padding: 20px 0; overflow-y: auto;",
        
        # Header
        tags$div(
          class = "text-center mb-4",
          div(style = "font-size: 3em; color: #2e8b57; margin-bottom: 10px;", "Ö"),
          h4(style = "color: #2e8b57; font-weight: 700;", "Ördin v3.0"),
          p(class = "small text-muted", "Help & Documentation")
        ),
        
        # Navigation Links
        tags$div(
          class = "help-nav",
          style = "display: flex; flex-direction: column; gap: 5px;",
          
          # About Ördin
          tags$button(
            id = "nav-about",
            class = "help-nav-btn active",
            style = "text-align: left; padding: 12px 20px; background: #2e8b57; border: none; color: white; cursor: pointer; border-radius: 0; display: flex; align-items: center; gap: 10px;",
            onclick = "switchHelpSection('about'); setActiveHelpNav(this); return false;",
            tags$div(style = "font-size: 1.2em;", icon("info-circle")),
            tags$div("About Ördin")
          ),
          
          # FAQ
          tags$button(
            id = "nav-faq",
            class = "help-nav-btn",
            style = "text-align: left; padding: 12px 20px; background: transparent; border: none; color: #cccccc; cursor: pointer; border-radius: 0; display: flex; align-items: center; gap: 10px;",
            onclick = "switchHelpSection('faq'); setActiveHelpNav(this); return false;",
            tags$div(style = "font-size: 1.2em;", icon("question-circle")),
            tags$div("Frequently Asked Questions")
          ),
          
          # User Guides
          tags$button(
            id = "nav-guides",
            class = "help-nav-btn",
            style = "text-align: left; padding: 12px 20px; background: transparent; border: none; color: #cccccc; cursor: pointer; border-radius: 0; display: flex; align-items: center; gap: 10px;",
            onclick = "switchHelpSection('guides'); setActiveHelpNav(this); return false;",
            tags$div(style = "font-size: 1.2em;", icon("book")),
            tags$div("User Guides")
          ),
          
          # Changelog
          tags$button(
            id = "nav-changelog",
            class = "help-nav-btn",
            style = "text-align: left; padding: 12px 20px; background: transparent; border: none; color: #cccccc; cursor: pointer; border-radius: 0; display: flex; align-items: center; gap: 10px;",
            onclick = "switchHelpSection('changelog'); setActiveHelpNav(this); return false;",
            tags$div(style = "font-size: 1.2em;", icon("history")),
            tags$div("Changelog")
          ),
          
          # Technical Specifications
          tags$button(
            id = "nav-specs",
            class = "help-nav-btn",
            style = "text-align: left; padding: 12px 20px; background: transparent; border: none; color: #cccccc; cursor: pointer; border-radius: 0; display: flex; align-items: center; gap: 10px;",
            onclick = "switchHelpSection('specs'); setActiveHelpNav(this); return false;",
            tags$div(style = "font-size: 1.2em;", icon("cogs")),
            tags$div("Technical Specifications")
          ),
          
          # Author & Credits
          tags$button(
            id = "nav-author",
            class = "help-nav-btn",
            style = "text-align: left; padding: 12px 20px; background: transparent; border: none; color: #cccccc; cursor: pointer; border-radius: 0; display: flex; align-items: center; gap: 10px;",
            onclick = "switchHelpSection('author'); setActiveHelpNav(this); return false;",
            tags$div(style = "font-size: 1.2em;", icon("user")),
            tags$div("Author & Credits")
          ),
          
          # References
          tags$button(
            id = "nav-references",
            class = "help-nav-btn",
            style = "text-align: left; padding: 12px 20px; background: transparent; border: none; color: #cccccc; cursor: pointer; border-radius: 0; display: flex; align-items: center; gap: 10px;",
            onclick = "switchHelpSection('references'); setActiveHelpNav(this); return false;",
            tags$div(style = "font-size: 1.2em;", icon("book-open")),
            tags$div("References")
          )
        )
      ),
      
      # Content Area
      tags$div(
        id = "help-content",
        class = "help-content",
        style = "flex: 1; padding: 30px; overflow-y: auto;",
        
        # About Section (Default Visible)
        tags$div(
          id = "section-about",
          class = "help-section active",
          
          tags$h2(class = "mb-4", style = "color: #2e8b57; font-weight: 700;", "About Ördin"),
          
          tags$p(class = "lead", "Ördin is an enterprise-grade community ecology analysis platform that combines the analytical power of R with modern desktop application design. It provides ecologists, researchers, and students with professional tools for analyzing community composition, diversity patterns, ordination, and ecological indices through an intuitive, cross-platform interface."),
          
          tags$h4(class = "mt-4 mb-3", style = "color: #2e8b57;", "Platform Overview"),
          
          tags$p("Ördin provides a comprehensive suite of tools for community ecology analysis:"),
          tags$ul(
            tags$li(tags$strong("Diversity Estimation"), ": iNEXT-based rarefaction and extrapolation analysis"),
            tags$li(tags$strong("Ordination Analysis"), ": 7 methods (NMDS, PCA, CA, DCA, CCA, RDA, PCoA)"),
            tags$li(tags$strong("Diversity Indices"), ": Classic diversity and evenness metrics"),
            tags$li(tags$strong("Advanced Visualization"), ": Confidence ellipses, species scores, environmental vectors")
          ),
          
          tags$h4(class = "mt-4 mb-3", style = "color: #2e8b57;", "Core Modules"),
          
          # Core Modules Cards
          tags$div(
            class = "row",
            
            # Diversity Estimation
            tags$div(
              class = "col-md-4 mb-4",
              card(
                card_header(
                  tags$div(class = "d-flex align-items-center",
                    tags$div(class = "me-2", style = "font-size: 1.2em; color: #2e8b57;", icon("chart-line")),
                    tags$div("Diversity Estimation")
                  )
                ),
                card_body(
                  tags$ul(class = "mb-0 ps-3",
                    tags$li("Individual-based and incidence-based data"),
                    tags$li("Three visualization types"),
                    tags$li("Hill numbers (q=0, 1, 2)"),
                    tags$li("Bootstrap confidence intervals")
                  )
                )
              )
            ),
            
            # Diversity Indices
            tags$div(
              class = "col-md-4 mb-4",
              card(
                card_header(
                  tags$div(class = "d-flex align-items-center",
                    tags$div(class = "me-2", style = "font-size: 1.2em; color: #2e8b57;", icon("calculator")),
                    tags$div("Diversity Indices")
                  )
                ),
                card_body(
                  tags$ul(class = "mb-0 ps-3",
                    tags$li("Alpha diversity metrics"),
                    tags$li("Evenness indices"),
                    tags$li("Rarefaction analysis"),
                    tags$li("Species accumulation curves")
                  )
                )
              )
            ),
            
            # Ordination
            tags$div(
              class = "col-md-4 mb-4",
              card(
                card_header(
                  tags$div(class = "d-flex align-items-center",
                    tags$div(class = "me-2", style = "font-size: 1.2em; color: #4169e1;", icon("project-diagram")),
                    tags$div("Ordination Analysis")
                  )
                ),
                card_body(
                  tags$ul(class = "mb-0 ps-3",
                    tags$li("7 ordination methods"),
                    tags$li("5 distance measures"),
                    tags$li("Confidence ellipses"),
                    tags$li("Environmental vectors")
                  )
                )
              )
            )
          ),
          
          tags$h4(class = "mt-4 mb-3", style = "color: #2e8b57;", "Enterprise Features"),
          
          tags$div(
            class = "row",
            tags$div(class = "col-md-6",
              tags$ul(
                tags$li(tags$strong("Professional dark/light theme"), " with persistent preferences"),
                tags$li(tags$strong("Publication-quality exports"), " in multiple formats"),
                tags$li(tags$strong("Modular architecture"), " with independent analysis modules"),
                tags$li(tags$strong("Cross-platform support"), " (Windows, macOS, Linux)")
              )
            ),
            tags$div(class = "col-md-6",
              tags$ul(
                tags$li(tags$strong("Self-contained portable R installation")),
                tags$li(tags$strong("Advanced data management and validation")),
                tags$li(tags$strong("Comprehensive documentation and user guides"))
              )
            )
          )
        ),
        
        # FAQ Section
        tags$div(
          id = "section-faq",
          class = "help-section",
          style = "display: none;",
          
          tags$h2(class = "mb-4", style = "color: #2e8b57; font-weight: 700;", "Frequently Asked Questions"),
          
          # FAQ Accordion
          tags$div(
            class = "accordion",
            id = "faqAccordion",
            
            # FAQ 1
            tags$div(
              class = "accordion-item",
              style = "background: #2d2d30; border: 1px solid #3e3e42; margin-bottom: 10px;",
              
              tags$h2(
                class = "accordion-header",
                id = "faqHeading1",
                tags$button(
                  class = "accordion-button collapsed",
                  style = "background: #252526; color: #cccccc; font-weight: 600;",
                  `type` = "button",
                  `data-bs-toggle` = "collapse",
                  `data-bs-target` = "#faqCollapse1",
                  `aria-expanded` = "false",
                  `aria-controls` = "faqCollapse1",
                  "What data format does Ördin require?"
                )
              ),
              tags$div(
                id = "faqCollapse1",
                class = "accordion-collapse collapse",
                `aria-labelledby` = "faqHeading1",
                `data-bs-parent` = "#faqAccordion",
                tags$div(
                  class = "accordion-body",
                  tags$p("Ördin requires CSV files with the first column containing site names and subsequent columns containing species/taxa abundance or presence/absence data. The platform supports three data types:"),
                  tags$ul(
                    tags$li(tags$strong("Abundance"), ": Numeric counts of individuals per species"),
                    tags$li(tags$strong("Incidence (Binary)"), ": Presence/absence data (1/0)"),
                    tags$li(tags$strong("Incidence (Freq)"), ": Frequency of occurrence data")
                  ),
                  tags$p("For ordination methods that support environmental variables (CCA, RDA), a separate environmental data file can be uploaded with site names in the first column and environmental variables in subsequent columns.")
                )
              )
            ),
            
            # FAQ 2
            tags$div(
              class = "accordion-item",
              style = "background: #2d2d30; border: 1px solid #3e3e42; margin-bottom: 10px;",
              
              tags$h2(
                class = "accordion-header",
                id = "faqHeading2",
                tags$button(
                  class = "accordion-button collapsed",
                  style = "background: #252526; color: #cccccc; font-weight: 600;",
                  `type` = "button",
                  `data-bs-toggle` = "collapse",
                  `data-bs-target` = "#faqCollapse2",
                  `aria-expanded` = "false",
                  `aria-controls` = "faqCollapse2",
                  "What ordination methods are supported?"
                )
              ),
              tags$div(
                id = "faqCollapse2",
                class = "accordion-collapse collapse",
                `aria-labelledby` = "faqHeading2",
                `data-bs-parent` = "#faqAccordion",
                tags$div(
                  class = "accordion-body",
                  tags$p("Ördin supports 7 ordination methods with comprehensive visualization features:"),
                  tags$ol(
                    tags$li(tags$strong("NMDS"), " - Non-metric Multidimensional Scaling"),
                    tags$li(tags$strong("PCA"), " - Principal Components Analysis"),
                    tags$li(tags$strong("CA"), " - Correspondence Analysis"),
                    tags$li(tags$strong("DCA"), " - Detrended Correspondence Analysis"),
                    tags$li(tags$strong("CCA"), " - Canonical Correspondence Analysis (constrained)"),
                    tags$li(tags$strong("RDA"), " - Redundancy Analysis (constrained)"),
                    tags$li(tags$strong("PCoA"), " - Principal Coordinates Analysis")
                  ),
                  tags$p("Each method supports customizable dimensions, distance measures, and advanced visualization options including confidence ellipses, species scores, and environmental vectors.")
                )
              )
            ),
            
            # Additional FAQs would be added here
            # FAQ 3-7 would follow the same pattern
            
            # FAQ 3
            tags$div(
              class = "accordion-item",
              style = "background: #2d2d30; border: 1px solid #3e3e42; margin-bottom: 10px;",
              
              tags$h2(
                class = "accordion-header",
                id = "faqHeading3",
                tags$button(
                  class = "accordion-button collapsed",
                  style = "background: #252526; color: #cccccc; font-weight: 600;",
                  `type` = "button",
                  `data-bs-toggle` = "collapse",
                  `data-bs-target` = "#faqCollapse3",
                  `aria-expanded` = "false",
                  `aria-controls` = "faqCollapse3",
                  "What diversity indices are available?"
                )
              ),
              tags$div(
                id = "faqCollapse3",
                class = "accordion-collapse collapse",
                `aria-labelledby` = "faqHeading3",
                `data-bs-parent` = "#faqAccordion",
                tags$div(
                  class = "accordion-body",
                  tags$p("Ördin provides comprehensive diversity analysis through two main modules:"),
                  tags$ul(
                    tags$li(tags$strong("Diversity Estimation"), ": iNEXT-based rarefaction and extrapolation with Hill numbers (q=0, 1, 2)"),
                    tags$li(tags$strong("Diversity Indices"), ": 8 classic diversity and evenness metrics including Shannon, Simpson, Pielou's evenness, and species accumulation curves")
                  )
                )
              )
            )
          )
        ),
        
        # User Guides Section
        tags$div(
          id = "section-guides",
          class = "help-section",
          style = "display: none;",
          
          tags$h2(class = "mb-4", style = "color: #2e8b57; font-weight: 700;", "User Guides"),
          
          # Module Guides
          tags$div(
            class = "row",
            
            # Data Management Guide
            tags$div(
              class = "col-md-6 mb-4",
              card(
                card_header(
                  tags$div(class = "d-flex align-items-center",
                    tags$div(class = "me-2", style = "font-size: 1.2em; color: #4169e1;", icon("database")),
                    tags$div("Data Management")
                  )
                ),
                card_body(
                  tags$h5("Getting Started with Data"),
                  tags$p("Learn how to import, validate, and manage your ecological datasets."),
                  tags$ul(
                    tags$li("Supported file formats: CSV, Excel, Tab-delimited"),
                    tags$li("Data validation and preprocessing"),
                    tags$li("Handling missing values and outliers")
                  ),
                  tags$a(href = "#", class = "btn btn-sm btn-outline-primary mt-2", "View Full Guide")
                )
              )
            ),
            
            # Diversity Analysis Guide
            tags$div(
              class = "col-md-6 mb-4",
              card(
                card_header(
                  tags$div(class = "d-flex align-items-center",
                    tags$div(class = "me-2", style = "font-size: 1.2em; color: #2e8b57;", icon("chart-line")),
                    tags$div("Diversity Analysis")
                  )
                ),
                card_body(
                  tags$h5("Diversity Estimation & Indices"),
                  tags$p("Master the diversity analysis tools in Ördin."),
                  tags$ul(
                    tags$li("iNEXT rarefaction and extrapolation"),
                    tags$li("Hill numbers and diversity profiles"),
                    tags$li("Classic diversity indices and evenness metrics")
                  ),
                  tags$a(href = "#", class = "btn btn-sm btn-outline-success mt-2", "View Full Guide")
                )
              )
            ),
            
            # Ordination Guide
            tags$div(
              class = "col-md-6 mb-4",
              card(
                card_header(
                  tags$div(class = "d-flex align-items-center",
                    tags$div(class = "me-2", style = "font-size: 1.2em; color: #4169e1;", icon("project-diagram")),
                    tags$div("Ordination Analysis")
                  )
                ),
                card_body(
                  tags$h5("Multivariate Analysis"),
                  tags$p("Explore community patterns with ordination methods."),
                  tags$ul(
                    tags$li("Choosing the right ordination method"),
                    tags$li("Distance measures and transformations"),
                    tags$li("Interpreting ordination plots and statistics")
                  ),
                  tags$a(href = "#", class = "btn btn-sm btn-outline-primary mt-2", "View Full Guide")
                )
              )
            ),
            
            # Visualization Guide
            tags$div(
              class = "col-md-6 mb-4",
              card(
                card_header(
                  tags$div(class = "d-flex align-items-center",
                    tags$div(class = "me-2", style = "font-size: 1.2em; color: #ff8c00;", icon("chart-bar")),
                    tags$div("Visualization")
                  )
                ),
                card_body(
                  tags$h5("Creating Publication-Quality Plots"),
                  tags$p("Learn to create and customize professional visualizations."),
                  tags$ul(
                    tags$li("Plot customization and theming"),
                    tags$li("Export formats and resolution settings"),
                    tags$li("Advanced visualization features")
                  ),
                  tags$a(href = "#", class = "btn btn-sm btn-outline-warning mt-2", "View Full Guide")
                )
              )
            )
          )
        ),
        
        # Changelog Section
        tags$div(
          id = "section-changelog",
          class = "help-section",
          style = "display: none;",
          
          tags$h2(class = "mb-4", style = "color: #2e8b57; font-weight: 700;", "Changelog"),
          
          # Version 3.0
          tags$div(
            class = "mb-5",
            tags$h3(
              class = "d-flex align-items-center gap-2 mb-3",
              tags$span("Version 3.0"),
              tags$span(class = "badge bg-success", style = "font-size: 0.5em;", "Latest")
            ),
            tags$p(class = "text-muted", "Released: October 2025"),
            
            tags$h5(class = "mt-4", style = "color: #2e8b57;", "Major Features"),
            tags$ul(
              tags$li(tags$strong("Enhanced Help System"), ": Professional sidebar navigation with 7 sections"),
              tags$li(tags$strong("Enterprise Documentation"), ": Comprehensive user guides and technical specifications"),
              tags$li(tags$strong("Advanced Data Management"), ": Improved validation, preprocessing, and export options"),
              tags$li(tags$strong("UI/UX Enhancements"), ": Refined interface with professional design patterns")
            ),
            
            tags$h5(class = "mt-4", style = "color: #2e8b57;", "Improvements"),
            tags$ul(
              tags$li("Expanded ordination capabilities with 7 methods"),
              tags$li("Enhanced visualization options for all analysis types"),
              tags$li("Improved performance for large datasets"),
              tags$li("Comprehensive documentation updates")
            )
          ),
          
          # Version 2.3
          tags$div(
            class = "mb-5",
            tags$h3(class = "mb-3", "Version 2.3"),
            tags$p(class = "text-muted", "Released: July 2025"),
            
            tags$ul(
              tags$li("Professional dark/light theme toggle with persistent preferences"),
              tags$li("Complete CSS architecture refactor for reliability"),
              tags$li("Smooth transitions and theme-responsive UI elements"),
              tags$li("localStorage persistence for theme settings")
            )
          ),
          
          # Version 2.2
          tags$div(
            class = "mb-5",
            tags$h3(class = "mb-3", "Version 2.2"),
            tags$p(class = "text-muted", "Released: April 2025"),
            
            tags$ul(
              tags$li("Complete modular architecture with tab-based navigation"),
              tags$li("5 ordination methods (NMDS, PCA, CA, DCA, PCoA)"),
              tags$li("8 diversity indices with rarefaction and accumulation curves"),
              tags$li("Professional UI with dedicated modules"),
              tags$li("Enhanced vegan package integration (9.5% coverage)"),
              tags$li("Publication-quality plot exports")
            )
          )
        ),
        
        # Technical Specifications Section
        tags$div(
          id = "section-specs",
          class = "help-section",
          style = "display: none;",
          
          tags$h2(class = "mb-4", style = "color: #2e8b57; font-weight: 700;", "Technical Specifications"),
          
          # System Requirements
          tags$div(
            class = "mb-5",
            tags$h4(class = "mb-3", style = "color: #2e8b57;", "System Requirements"),
            
            tags$div(
              class = "row",
              tags$div(
                class = "col-md-6",
                tags$h5("Minimum Requirements:"),
                tags$ul(
                  tags$li(tags$strong("Operating System"), ": Windows 10+, macOS 10.15+, Linux"),
                  tags$li(tags$strong("Processor"), ": Intel/AMD x64 or Apple Silicon"),
                  tags$li(tags$strong("Memory"), ": 4 GB RAM"),
                  tags$li(tags$strong("Storage"), ": 500 MB available space"),
                  tags$li(tags$strong("Display"), ": 1280×720 minimum resolution"),
                  tags$li(tags$strong("Internet"), ": Not required (offline capable)"),
                  tags$li(tags$strong("Dependencies"), ": None (self-contained)")
                )
              ),
              tags$div(
                class = "col-md-6",
                tags$h5("Recommended Requirements:"),
                tags$ul(
                  tags$li(tags$strong("Operating System"), ": Windows 11, macOS 12+, Ubuntu 22.04+"),
                  tags$li(tags$strong("Processor"), ": Multi-core Intel/AMD or Apple M1/M2"),
                  tags$li(tags$strong("Memory"), ": 8 GB RAM"),
                  tags$li(tags$strong("Storage"), ": 1 GB available space"),
                  tags$li(tags$strong("Display"), ": 1920×1080 or higher")
                )
              )
            )
          ),
          
          # Technology Stack
          tags$div(
            class = "mb-5",
            tags$h4(class = "mb-3", style = "color: #2e8b57;", "Technology Stack"),
            
            tags$div(
              class = "row",
              tags$div(
                class = "col-md-6",
                tags$h5("Frontend:"),
                tags$ul(
                  tags$li("Electron: Desktop application framework"),
                  tags$li("Shiny: Web application framework"),
                  tags$li("Bootstrap 5: UI components"),
                  tags$li("Custom CSS: Professional theming")
                )
              ),
              tags$div(
                class = "col-md-6",
                tags$h5("Backend:"),
                tags$ul(
                  tags$li("R 4.2+: Statistical computing"),
                  tags$li("iNEXT: Interpolation/extrapolation"),
                  tags$li("vegan: Community ecology package"),
                  tags$li("ggplot2: Visualization engine")
                )
              )
            )
          )
        ),
        
        # Author & Credits Section
        tags$div(
          id = "section-author",
          class = "help-section",
          style = "display: none;",
          
          tags$h2(class = "mb-4", style = "color: #2e8b57; font-weight: 700;", "Author & Credits"),
          
          tags$div(
            class = "d-flex align-items-center mb-4",
            tags$div(
              class = "me-4",
              style = "width: 100px; height: 100px; border-radius: 50%; background: #2e8b57; display: flex; align-items: center; justify-content: center; font-size: 3em; color: white;",
              "JM"
            ),
            tags$div(
              tags$h3("Jimmy Moses"),
              tags$p(class = "mb-1", "Lead Developer & Maintainer"),
              tags$p(class = "text-muted", "jimmy.moses@pnguot.ac.pg")
            )
          ),
          
          tags$h4(class = "mt-5 mb-3", style = "color: #2e8b57;", "Acknowledgements"),
          
          tags$p("Ördin builds upon the work of many open-source projects and academic resources:"),
          
          tags$ul(
            tags$li(tags$strong("R Core Team"), " for the R statistical computing environment"),
            tags$li(tags$strong("Chao Lab"), " for the iNEXT package and interpolation/extrapolation methodology"),
            tags$li(tags$strong("Jari Oksanen et al."), " for the vegan package and community ecology methods"),
            tags$li(tags$strong("RStudio Team"), " for the Shiny web application framework"),
            tags$li(tags$strong("Electron Team"), " for the desktop application framework")
          ),
          
          tags$h4(class = "mt-5 mb-3", style = "color: #2e8b57;", "License"),
          
          tags$p("Ördin is released under the MIT License:"),
          
          tags$pre(
            style = "background: #1e1e1e; padding: 15px; border-radius: 5px; color: #cccccc;",
            "Copyright (c) 2025 Jimmy Moses\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software."
          )
        ),
        
        # References Section
        tags$div(
          id = "section-references",
          class = "help-section",
          style = "display: none;",
          
          tags$h2(class = "mb-4", style = "color: #2e8b57; font-weight: 700;", "References"),
          
          tags$h4(class = "mb-3", style = "color: #2e8b57;", "Methodology References"),
          
          tags$ol(
            class = "references",
            style = "padding-left: 20px;",
            
            tags$li(
              tags$p(
                "Chao, A., Gotelli, N. J., Hsieh, T. C., Sander, E. L., Ma, K. H., Colwell, R. K., & Ellison, A. M. (2014). Rarefaction and extrapolation with Hill numbers: a framework for sampling and estimation in species diversity studies. ",
                tags$em("Ecological Monographs"),
                ", 84(1), 45-67."
              )
            ),
            
            tags$li(
              tags$p(
                "Chao, A., & Jost, L. (2012). Coverage-based rarefaction and extrapolation: standardizing samples by completeness rather than size. ",
                tags$em("Ecology"),
                ", 93(12), 2533-2547."
              )
            ),
            
            tags$li(
              tags$p(
                "Oksanen, J. (2022). Multivariate Analysis of Ecological Communities in R: vegan Tutorial. ",
                tags$em("Comprehensive R Archive Network"),
                "."
              )
            )
          ),
          
          tags$h4(class = "mt-5 mb-3", style = "color: #2e8b57;", "Platform Technologies"),
          
          tags$ol(
            class = "references",
            style = "padding-left: 20px;",
            
            tags$li(
              tags$p(
                "Electron Team. (2023). Electron: Build cross-platform desktop apps with JavaScript, HTML, and CSS. ",
                tags$a(href = "https://electronjs.org", "https://electronjs.org")
              )
            ),
            
            tags$li(
              tags$p(
                "Chang, W., Cheng, J., Allaire, J. J., Xie, Y., & McPherson, J. (2023). shiny: Web Application Framework for R. R package version 1.7.4. ",
                tags$a(href = "https://shiny.rstudio.com/", "https://shiny.rstudio.com/")
              )
            ),
            
            tags$li(
              tags$p(
                "Bootstrap Team. (2023). Bootstrap: The most popular HTML, CSS, and JavaScript framework. ",
                tags$a(href = "https://getbootstrap.com", "https://getbootstrap.com")
              )
            )
          ),
          
          tags$h4(class = "mt-5 mb-3", style = "color: #2e8b57;", "Citing Ördin"),
          
          tags$p("If you use Ördin in your research, please cite:"),
          
          tags$pre(
            style = "background: #1e1e1e; padding: 15px; border-radius: 5px; color: #cccccc;",
            "Moses, J. (2025). Ördin: A cross-platform desktop application for community ecology analysis.\nGitHub repository: https://github.com/jm0535/0rdin"
          )
        )
      )
    ),
    
    # JavaScript for Help Page Navigation
    tags$script(HTML("
      // Function to switch between help sections
      function switchHelpSection(sectionId) {
        // Hide all sections
        document.querySelectorAll('.help-section').forEach(section => {
          section.style.display = 'none';
        });
        
        // Show the selected section
        const targetSection = document.getElementById('section-' + sectionId);
        if (targetSection) {
          targetSection.style.display = 'block';
          
          // Animate the content appearance
          targetSection.style.opacity = '0';
          targetSection.style.transform = 'translateY(20px)';
          
          setTimeout(() => {
            targetSection.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
            targetSection.style.opacity = '1';
            targetSection.style.transform = 'translateY(0)';
          }, 50);
        }
      }
      
      // Function to set active navigation button
      function setActiveHelpNav(button) {
        // Remove active class from all buttons
        document.querySelectorAll('.help-nav-btn').forEach(btn => {
          btn.classList.remove('active');
          btn.style.background = 'transparent';
          btn.style.color = '#cccccc';
        });
        
        // Add active class to clicked button
        if (button) {
          button.classList.add('active');
          button.style.background = '#2e8b57';
          button.style.color = 'white';
        }
      }
      
      // Add hover effects to nav buttons
      document.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('.help-nav-btn').forEach(btn => {
          btn.addEventListener('mouseover', function() {
            if (!this.classList.contains('active')) {
              this.style.background = '#3e3e42';
            }
          });
          
          btn.addEventListener('mouseout', function() {
            if (!this.classList.contains('active')) {
              this.style.background = 'transparent';
            }
          });
          
          // Add click event listeners
          btn.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Get section ID from button ID
            const buttonId = this.id;
            const sectionId = buttonId.replace('nav-', '');
            
            // Switch to the section
            switchHelpSection(sectionId);
            
            // Set active button
            setActiveHelpNav(this);
          });
        });
      });
    "))
  ),
  
  # Settings Button (far right)
  nav_spacer(),
  
  # Settings Button to open sidebar
  nav_item(
    tags$button(
      id = "settings-btn",
      class = "btn",
      onclick = "toggleSettingsSidebar()",
      title = "Settings",
      style = "border: none; background: transparent; font-size: 1.1rem; padding: 4px 10px; cursor: pointer; color: #cccccc;",
      icon("cog")
    )
  )
  ),  # End page_navbar
  
  # Settings Sidebar (overlay)
  tags$div(
    id = "settings-sidebar",
    class = "settings-sidebar",
    style = "position: fixed; top: 0; right: -400px; width: 400px; height: 100vh; background: #252526; border-left: 1px solid #3e3e42; z-index: 10000; transition: right 0.3s cubic-bezier(0.4, 0, 0.2, 1); overflow-y: auto; box-shadow: -4px 0 24px rgba(0, 0, 0, 0.3);",
    
    # Header
    tags$div(
      style = "position: sticky; top: 0; background: #2d2d30; color: #2e8b57; font-weight: 700; font-size: 1.1rem; padding: 20px; border-bottom: 1px solid #3e3e42; display: flex; justify-content: space-between; align-items: center; z-index: 1;",
      tags$div(
        icon("sliders-h"), " Application Settings"
      ),
      tags$button(
        onclick = "toggleSettingsSidebar()",
        style = "background: transparent; border: none; color: #cccccc; font-size: 1.2rem; cursor: pointer; padding: 4px 8px; transition: color 0.2s;",
        onmouseover = "this.style.color='#ffffff'",
        onmouseout = "this.style.color='#cccccc'",
        "×"
      )
    ),
    
    # Content container
    tags$div(
      style = "padding: 20px;",
      
      # General Settings Section
      tags$div(
        class = "settings-section",
        style = "margin-bottom: 24px;",
        tags$div(
          class = "settings-section-title",
          style = "color: #888; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 12px; font-weight: 600;",
          "General"
        ),
        
        # Auto-save toggle
        tags$div(
          class = "form-check form-switch mb-3",
          style = "display: flex; align-items: center; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid #3e3e42;",
          tags$div(
            tags$label(
              class = "form-check-label",
              `for` = "autoSaveToggle",
              style = "color: #cccccc; font-size: 0.9rem; cursor: pointer;",
              icon("save", style = "margin-right: 8px; color: #2e8b57;"),
              "Auto-save"
            ),
            tags$div(
              style = "color: #666; font-size: 0.75rem; margin-top: 2px;",
              "Save every 30s"
            )
          ),
          tags$input(
            class = "form-check-input",
            type = "checkbox",
            id = "autoSaveToggle",
            checked = "checked",
            style = "cursor: pointer; width: 40px; height: 20px;",
            onchange = "Shiny.setInputValue('settingsAutoSave', this.checked);"
          )
        ),
        
        # Notifications toggle
        tags$div(
          class = "form-check form-switch mb-3",
          style = "display: flex; align-items: center; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid #3e3e42;",
          tags$div(
            tags$label(
              class = "form-check-label",
              `for` = "notificationsToggle",
              style = "color: #cccccc; font-size: 0.9rem; cursor: pointer;",
              icon("bell", style = "margin-right: 8px; color: #2e8b57;"),
              "Notifications"
            ),
            tags$div(
              style = "color: #666; font-size: 0.75rem; margin-top: 2px;",
              "Show alerts"
            )
          ),
          tags$input(
            class = "form-check-input",
            type = "checkbox",
            id = "notificationsToggle",
            checked = "checked",
            style = "cursor: pointer; width: 40px; height: 20px;",
            onchange = "Shiny.setInputValue('settingsNotifications', this.checked);"
          )
        )
      ),
      
      # Appearance Settings Section
      tags$div(
        class = "settings-section",
        style = "margin-bottom: 24px;",
        tags$div(
          class = "settings-section-title",
          style = "color: #888; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 12px; font-weight: 600;",
          "Appearance"
        ),
        
        # Theme selector
        tags$div(
          class = "mb-3",
          style = "padding: 12px 0; border-bottom: 1px solid #3e3e42;",
          tags$label(
            style = "color: #cccccc; font-size: 0.9rem; display: block; margin-bottom: 8px;",
            icon("palette", style = "margin-right: 8px; color: #2e8b57;"),
            "Theme"
          ),
          tags$select(
            id = "themeSelector",
            class = "form-select form-select-sm",
            style = "background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; font-size: 0.85rem; padding: 8px 12px; border-radius: 4px; cursor: pointer; width: 100%;",
            onchange = "handleThemeChange(this.value);",
            tags$option(value = "dark", selected = "selected", "Dark"),
            tags$option(value = "light", "Light"),
            tags$option(value = "auto", "Auto (System)")
          )
        ),
        
        # Font size
        tags$div(
          class = "mb-3",
          style = "padding: 12px 0; border-bottom: 1px solid #3e3e42;",
          tags$label(
            style = "color: #cccccc; font-size: 0.9rem; display: block; margin-bottom: 8px;",
            icon("text-height", style = "margin-right: 8px; color: #2e8b57;"),
            "Font Size"
          ),
          tags$select(
            id = "fontSizeSelector",
            class = "form-select form-select-sm",
            style = "background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; font-size: 0.85rem; padding: 8px 12px; border-radius: 4px; cursor: pointer; width: 100%;",
            onchange = "handleFontSizeChange(this.value);",
            tags$option(value = "small", "Small"),
            tags$option(value = "medium", selected = "selected", "Medium"),
            tags$option(value = "large", "Large")
          )
        )
      ),
      
      # Data Settings Section
      tags$div(
        class = "settings-section",
        style = "margin-bottom: 24px;",
        tags$div(
          class = "settings-section-title",
          style = "color: #888; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 12px; font-weight: 600;",
          "Data & Export"
        ),
        
        # Default export format
        tags$div(
          class = "mb-3",
          style = "padding: 12px 0; border-bottom: 1px solid #3e3e42;",
          tags$label(
            style = "color: #cccccc; font-size: 0.9rem; display: block; margin-bottom: 8px;",
            icon("file-export", style = "margin-right: 8px; color: #2e8b57;"),
            "Default Export Format"
          ),
          tags$select(
            id = "exportFormatSelector",
            class = "form-select form-select-sm",
            style = "background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; font-size: 0.85rem; padding: 8px 12px; border-radius: 4px; cursor: pointer; width: 100%;",
            onchange = "Shiny.setInputValue('settingsExportFormat', this.value);",
            tags$option(value = "csv", selected = "selected", "CSV"),
            tags$option(value = "xlsx", "Excel (.xlsx)"),
            tags$option(value = "json", "JSON")
          )
        ),
        
        # Decimal precision
        tags$div(
          class = "mb-3",
          style = "padding: 12px 0; border-bottom: 1px solid #3e3e42;",
          tags$label(
            style = "color: #cccccc; font-size: 0.9rem; display: block; margin-bottom: 8px;",
            icon("hashtag", style = "margin-right: 8px; color: #2e8b57;"),
            "Decimal Precision"
          ),
          tags$select(
            id = "decimalPrecisionSelector",
            class = "form-select form-select-sm",
            style = "background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; font-size: 0.85rem; padding: 8px 12px; border-radius: 4px; cursor: pointer; width: 100%;",
            onchange = "Shiny.setInputValue('settingsDecimalPrecision', this.value);",
            tags$option(value = "2", "2 digits"),
            tags$option(value = "3", selected = "selected", "3 digits"),
            tags$option(value = "4", "4 digits"),
            tags$option(value = "5", "5 digits")
          )
        )
      ),
      
      # Plot & Visualization Settings Section
      tags$div(
        class = "settings-section",
        style = "margin-bottom: 24px;",
        tags$div(
          class = "settings-section-title",
          style = "color: #888; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 12px; font-weight: 600;",
          "Plots & Visualization"
        ),
        
        # ggplot2 theme
        tags$div(
          class = "mb-3",
          style = "padding: 12px 0; border-bottom: 1px solid #3e3e42;",
          tags$label(
            style = "color: #cccccc; font-size: 0.9rem; display: block; margin-bottom: 8px;",
            icon("chart-bar", style = "margin-right: 8px; color: #2e8b57;"),
            "ggplot2 Theme"
          ),
          tags$select(
            id = "ggplotThemeSelector",
            class = "form-select form-select-sm",
            style = "background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; font-size: 0.85rem; padding: 8px 12px; border-radius: 4px; cursor: pointer; width: 100%;",
            onchange = "Shiny.setInputValue('settingsGgplotTheme', this.value);",
            tags$option(value = "minimal", selected = "selected", "Minimal (Default)"),
            tags$option(value = "bw", "Black & White"),
            tags$option(value = "classic", "Classic"),
            tags$option(value = "grey", "Grey"),
            tags$option(value = "light", "Light"),
            tags$option(value = "dark", "Dark"),
            tags$option(value = "void", "Void")
          )
        ),
        
        # Plot DPI
        tags$div(
          class = "mb-3",
          style = "padding: 12px 0; border-bottom: 1px solid #3e3e42;",
          tags$label(
            style = "color: #cccccc; font-size: 0.9rem; display: block; margin-bottom: 8px;",
            icon("image", style = "margin-right: 8px; color: #2e8b57;"),
            "Plot DPI (Export Quality)"
          ),
          tags$select(
            id = "plotDpiSelector",
            class = "form-select form-select-sm",
            style = "background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; font-size: 0.85rem; padding: 8px 12px; border-radius: 4px; cursor: pointer; width: 100%;",
            onchange = "Shiny.setInputValue('settingsPlotDpi', this.value);",
            tags$option(value = "150", "150 DPI (Screen)"),
            tags$option(value = "300", selected = "selected", "300 DPI (Publication)"),
            tags$option(value = "600", "600 DPI (High Quality)")
          )
        ),
        
        # Color palette
        tags$div(
          class = "mb-3",
          style = "padding: 12px 0; border-bottom: 1px solid #3e3e42;",
          tags$label(
            style = "color: #cccccc; font-size: 0.9rem; display: block; margin-bottom: 8px;",
            icon("swatchbook", style = "margin-right: 8px; color: #2e8b57;"),
            "Color Palette"
          ),
          tags$select(
            id = "colorPaletteSelector",
            class = "form-select form-select-sm",
            style = "background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; font-size: 0.85rem; padding: 8px 12px; border-radius: 4px; cursor: pointer; width: 100%;",
            onchange = "Shiny.setInputValue('settingsColorPalette', this.value);",
            tags$option(value = "ordin", selected = "selected", "Ördin Green"),
            tags$option(value = "viridis", "Viridis"),
            tags$option(value = "colorblind", "Colorblind-Safe"),
            tags$option(value = "set1", "Set1 (Bright)"),
            tags$option(value = "set2", "Set2 (Pastel)")
          )
        )
      ),
      
      # Zoom & Display Settings Section
      tags$div(
        class = "settings-section",
        style = "margin-bottom: 24px;",
        tags$div(
          class = "settings-section-title",
          style = "color: #888; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 12px; font-weight: 600;",
          "Zoom & Display"
        ),
        
        # Page zoom
        tags$div(
          class = "mb-3",
          style = "padding: 12px 0; border-bottom: 1px solid #3e3e42;",
          tags$label(
            style = "color: #cccccc; font-size: 0.9rem; display: block; margin-bottom: 8px;",
            icon("search-plus", style = "margin-right: 8px; color: #2e8b57;"),
            "Page Zoom"
          ),
          tags$div(
            style = "display: flex; align-items: center; gap: 10px;",
            tags$button(
              onclick = "zoomOut()",
              class = "btn btn-sm btn-outline-secondary",
              style = "font-size: 0.8rem; padding: 4px 12px;",
              "-"
            ),
            tags$span(
              id = "zoom-level",
              style = "color: #cccccc; min-width: 60px; text-align: center;",
              "100%"
            ),
            tags$button(
              onclick = "zoomIn()",
              class = "btn btn-sm btn-outline-secondary",
              style = "font-size: 0.8rem; padding: 4px 12px;",
              "+"
            ),
            tags$button(
              onclick = "zoomReset()",
              class = "btn btn-sm btn-outline-secondary",
              style = "font-size: 0.8rem; padding: 4px 12px;",
              "Reset"
            )
          )
        )
      ),
      
      # Citations & References Section
      tags$div(
        class = "settings-section",
        style = "margin-bottom: 24px;",
        tags$div(
          class = "settings-section-title",
          style = "color: #888; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 12px; font-weight: 600;",
          "Citations & References"
        ),
        
        # Citations button
        tags$div(
          class = "mb-3",
          style = "padding: 12px 0;",
          actionButton(
            "showCitationsBtn",
            label = tagList(icon("quote-right"), " View Citations"),
            class = "btn btn-sm btn-outline-info w-100",
            style = "font-size: 0.85rem; border-color: #4ec9b0; color: #4ec9b0; padding: 10px;",
            onclick = "Shiny.setInputValue('showCitations', Math.random());"
          ),
          tags$div(
            style = "margin-top: 8px; color: #666; font-size: 0.75rem; text-align: center;",
            "R Core Team, iNEXT, vegan, ggplot2, Ördin"
          )
        )
      ),
      
      # Actions Section
      tags$div(
        class = "settings-section",
        style = "margin-bottom: 24px;",
        
        # Clear cache button
        actionButton(
          "clearCacheBtn",
          label = tagList(icon("trash-alt"), " Clear Cache"),
          class = "btn btn-sm btn-outline-secondary w-100 mb-3",
          style = "font-size: 0.85rem; border-color: #3e3e42; color: #cccccc; padding: 10px;",
          onclick = "localStorage.clear(); sessionStorage.clear(); alert('Cache cleared successfully!');"
        ),
        
        # Reset settings button
        actionButton(
          "resetSettingsBtn",
          label = tagList(icon("undo"), " Reset to Defaults"),
          class = "btn btn-sm btn-outline-warning w-100",
          style = "font-size: 0.85rem; border-color: #ff8c00; color: #ff8c00; padding: 10px;",
          onclick = "if(confirm('Reset all settings to default?')) { resetAllSettings(); }"
        )
      ),
      
      # Footer
      tags$div(
        style = "text-align: center; padding: 16px; border-top: 1px solid #3e3e42; color: #666; font-size: 0.75rem; margin-top: 20px;",
        "Ördin v3.0 • Enterprise Edition"
      )
    )
  ),
  
  # Sidebar overlay backdrop
  tags$div(
    id = "settings-overlay",
    style = "position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0, 0, 0, 0.5); z-index: 9999; display: none; opacity: 0; transition: opacity 0.3s ease;",
    onclick = "toggleSettingsSidebar()"
  )
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
  
  # ========================================
  # DATA MANAGEMENT MODULE
  # ========================================
  
  # Reactive values for data management
  dataManagement <- reactiveValues(
    speciesData = NULL,
    envData = NULL,
    speciesOriginal = NULL,
    envOriginal = NULL,
    activeDataset = "species",
    columnTypes = NULL,
    envColumnTypes = NULL
  )
  
  # Track active sub-navigation for Data tab
  dataActiveTab <- reactiveVal("import")
  
  observeEvent(input$dataSubNav, {
    dataActiveTab(input$dataSubNav)
  })
  
  # Dynamic Settings Content for Data Tab
  output$dataSettingsContent <- renderUI({
    active_tab <- dataActiveTab()
    
    if (active_tab == "import") {
      # Import Settings
      tagList(
        card(
          class = "mb-3",
          card_header(
            icon("upload"), " Data Import"
          ),
          card_body(
            h6("Import Source", style = "color: #4169e1; margin-bottom: 15px; font-weight: 600;"),
            
            radioButtons(
              "dataSource",
              NULL,
              choices = c(
                "Local File" = "local",
                "Google Drive" = "gdrive"
              ),
              selected = "local",
              inline = FALSE
            ),
            
            conditionalPanel(
              condition = "input.dataSource == 'local'",
              fileInput(
                "localDataFile",
                NULL,
                accept = c(".csv", ".xlsx", ".txt"),
                buttonLabel = "Browse...",
                placeholder = "No file selected"
              ),
              tags$small(
                class = "text-muted",
                icon("info-circle"),
                " Supports: CSV, Excel, Tab-delimited"
              )
            ),
            
            conditionalPanel(
              condition = "input.dataSource == 'gdrive'",
              tags$div(
                class = "alert alert-info",
                style = "background: #1a3a52; border-color: #4169e1; margin-top: 10px;",
                icon("cloud"), " Google Drive Integration"
              ),
              textInput(
                "gdriveUrl",
                "Google Drive Share Link",
                placeholder = "https://drive.google.com/file/d/..."
              ),
              tags$small(
                class = "text-muted",
                icon("info-circle"),
                " File must be publicly accessible"
              ),
              actionButton(
                "importFromGDrive",
                "Import from Google Drive",
                class = "btn-primary w-100 mt-2",
                icon = icon("cloud-download-alt")
              )
            )
          )
        ),
        
        hr(style = "border-color: #444; margin: 20px 0;"),
        
        card(
          class = "mb-3",
          card_header(
            icon("layer-group"), " Dataset Configuration"
          ),
          card_body(
            radioButtons(
              "datasetType",
              "Analysis Type",
              choices = c(
                "Species Data Only" = "species_only",
                "Species + Environment" = "species_env"
              ),
              selected = "species_only"
            ),
            
            tags$div(
              class = "alert alert-secondary",
              style = "background: #2a2a2a; border-color: #3e3e42; font-size: 0.85rem; padding: 10px;",
              icon("lightbulb"),
              " ",
              tags$strong("Tip: "),
              "For CCA/RDA, select 'Species + Environment'"
            ),
            
            conditionalPanel(
              condition = "input.datasetType == 'species_env'",
              tags$hr(style = "border-color: #444; margin: 15px 0;"),
              h6("Environment Dataset", style = "color: #ff8c00; margin-bottom: 10px; font-weight: 600;"),
              fileInput(
                "envDataFile",
                NULL,
                accept = c(".csv", ".xlsx", ".txt"),
                buttonLabel = "Browse...",
                placeholder = "No environment file"
              ),
              tags$small(
                class = "text-muted",
                icon("leaf"),
                " Environmental variables (pH, temp, etc.)"
              )
            )
          )
        )
      )
    } else if (active_tab == "edit") {
      # Edit/View Settings
      tagList(
        tags$div(
          class = "alert alert-info",
          style = "background: #1a3a1a; border: 2px solid #2e8b57;",
          icon("table"), " ",
          tags$strong("View & Edit Mode")
        ),
        
        if (!is.null(dataManagement$speciesData)) {
          tagList(
            tags$p(style = "color: #999; font-size: 0.9rem;", "Click any cell in the table to edit."),
            tags$hr(style = "border-color: #444;"),
            tags$h6("Active Dataset:", style = "color: #2e8b57;"),
            uiOutput("datasetTabs"),
            tags$hr(style = "border-color: #444;"),
            uiOutput("dataInfo")
          )
        } else {
          tags$p(
            style = "color: #aaa; font-size: 0.9rem;",
            "No data loaded. Go to Import tab to load data."
          )
        }
      )
    } else {
      # Export Settings
      tagList(
        card(
          card_header(
            icon("download"), " Export Operations"
          ),
          card_body(
            if (!is.null(dataManagement$speciesData)) {
              tagList(
                actionButton(
                  "exportEditedData",
                  "Export Edited Data",
                  class = "btn btn-success w-100 mb-2",
                  icon = icon("download")
                ),
                actionButton(
                  "resetToOriginal",
                  "Reset to Original",
                  class = "btn btn-outline-warning w-100 mb-2",
                  icon = icon("undo")
                ),
                actionButton(
                  "clearData",
                  "Clear All Data",
                  class = "btn btn-outline-danger w-100",
                  icon = icon("trash-alt")
                )
              )
            } else {
              tags$p(
                style = "color: #aaa; font-size: 0.9rem;",
                "No data to export. Import data first."
              )
            }
          )
        )
      )
    }
  })
  
  # Data Main Content
  output$dataMainContent <- renderUI({
    if (!is.null(dataManagement$speciesData)) {
      # Show data tables
      tags$div(
        style = "padding: 20px;",
        tags$div(
          class = "mb-3",
          style = "background: #1a1a1a; border: 1px solid #3e3e42; border-radius: 4px; padding: 15px;",
          h5(
            icon("columns"), " Column Configuration",
            style = "color: #2e8b57; margin-bottom: 15px; font-weight: 600; font-size: 1rem;"
          ),
          uiOutput("columnTypeEditor")
        ),
        
        tags$div(
          class = "mt-3",
          h5(
            icon("table"), " Data Spreadsheet",
            style = "color: #4169e1; margin-bottom: 15px; font-weight: 600; font-size: 1rem;"
          ),
          tags$div(
            class = "alert alert-info",
            style = "background: #1a3a52; border-color: #4169e1; font-size: 0.85rem; padding: 10px;",
            icon("edit"), " Click any cell to edit. Changes are applied in real-time."
          ),
          DTOutput("spreadsheetTable")
        ),
        
        conditionalPanel(
          condition = "input.datasetType == 'species_env' && output.hasEnvData",
          tags$div(
            class = "mt-4",
            tags$hr(style = "border-color: #444; margin: 30px 0;"),
            h5(
              icon("leaf"), " Environment Data",
              style = "color: #ff8c00; margin-bottom: 15px; font-weight: 600; font-size: 1rem;"
            ),
            DTOutput("envSpreadsheetTable")
          )
        )
      )
    } else {
      # Empty state
      tags$div(
        class = "text-center",
        style = "padding: 80px 40px; min-height: 500px; display: flex; align-items: center; justify-content: center;",
        tags$div(
          style = "max-width: 600px;",
          tags$div(
            style = "font-size: 6em; color: #4169e1; margin-bottom: 30px;",
            icon("database")
          ),
          h2(
            style = "color: #4169e1; margin-bottom: 25px; font-size: 2.5em; font-weight: 700;",
            "Data Management"
          ),
          p(
            class = "lead",
            style = "color: #999; font-size: 1.2em; margin-bottom: 35px;",
            "Import, edit, and manage your community ecology datasets"
          ),
          tags$div(
            class = "alert",
            style = "background: linear-gradient(135deg, #4169e1 0%, #2050d1 100%); border: none; border-radius: 10px; padding: 25px;",
            tags$div(style = "font-size: 2em; color: #fff; margin-bottom: 10px;", icon("arrow-left")),
            tags$h5(style = "color: #fff; font-weight: 700; margin: 0;", "Click Import in the sidebar to get started")
          )
        )
      )
    }
  })
  
  # Check if data exists
  output$hasData <- reactive({
    !is.null(dataManagement$speciesData)
  })
  outputOptions(output, "hasData", suspendWhenHidden = FALSE)
  
  # Check if environment data exists
  output$hasEnvData <- reactive({
    !is.null(dataManagement$envData)
  })
  outputOptions(output, "hasEnvData", suspendWhenHidden = FALSE)
  
  # Local file upload handler
  observeEvent(input$localDataFile, {
    req(input$localDataFile)
    
    waiter <- Waiter$new(
      html = tagList(
        spin_loaders(42, color = "#4169e1"),
        h3("Loading Data File", style = "color: #4169e1; margin-top: 30px; font-weight: 700;"),
        p("Reading and validating data structure", 
          style = "color: #999; font-size: 1rem; margin-top: 10px;")
      ),
      color = "rgba(20, 20, 20, 0.95)"
    )
    waiter$show()
    
    tryCatch({
      # Detect file type and read
      file_ext <- tools::file_ext(input$localDataFile$name)
      
      df <- if (file_ext == "xlsx") {
        readxl::read_excel(input$localDataFile$datapath)
      } else if (file_ext == "csv") {
        read_csv(input$localDataFile$datapath, show_col_types = FALSE)
      } else if (file_ext == "txt") {
        read_tsv(input$localDataFile$datapath, show_col_types = FALSE)
      } else {
        stop("Unsupported file format")
      }
      
      # Store data
      dataManagement$speciesData <- as.data.frame(df)
      dataManagement$speciesOriginal <- as.data.frame(df)
      
      # Initialize column types
      dataManagement$columnTypes <- sapply(df, class)
      
      waiter$hide()
      
      showNotification(
        sprintf("✓ Data loaded: %d rows × %d columns", nrow(df), ncol(df)),
        type = "message",
        duration = 3
      )
    }, error = function(e) {
      waiter$hide()
      showNotification(
        paste("Failed to load data:", e$message),
        type = "error",
        duration = 5
      )
    })
  })
  
  # Environment data upload handler
  observeEvent(input$envDataFile, {
    req(input$envDataFile)
    
    waiter <- Waiter$new(
      html = tagList(
        spin_loaders(42, color = "#ff8c00"),
        h3("Loading Environment Data", style = "color: #ff8c00; margin-top: 30px; font-weight: 700;"),
        p("Reading environmental variables", 
          style = "color: #999; font-size: 1rem; margin-top: 10px;")
      ),
      color = "rgba(20, 20, 20, 0.95)"
    )
    waiter$show()
    
    tryCatch({
      file_ext <- tools::file_ext(input$envDataFile$name)
      
      df <- if (file_ext == "xlsx") {
        readxl::read_excel(input$envDataFile$datapath)
      } else if (file_ext == "csv") {
        read_csv(input$envDataFile$datapath, show_col_types = FALSE)
      } else if (file_ext == "txt") {
        read_tsv(input$envDataFile$datapath, show_col_types = FALSE)
      } else {
        stop("Unsupported file format")
      }
      
      dataManagement$envData <- as.data.frame(df)
      dataManagement$envOriginal <- as.data.frame(df)
      dataManagement$envColumnTypes <- sapply(df, class)
      
      waiter$hide()
      
      showNotification(
        sprintf("✓ Environment data loaded: %d rows × %d columns", nrow(df), ncol(df)),
        type = "message",
        duration = 3
      )
    }, error = function(e) {
      waiter$hide()
      showNotification(
        paste("Failed to load environment data:", e$message),
        type = "error",
        duration = 5
      )
    })
  })
  
  # Google Drive import handler
  observeEvent(input$importFromGDrive, {
    req(input$gdriveUrl)
    
    waiter <- Waiter$new(
      html = tagList(
        spin_loaders(42, color = "#4169e1"),
        h3("Importing from Google Drive", style = "color: #4169e1; margin-top: 30px; font-weight: 700;"),
        p("Downloading file from cloud", 
          style = "color: #999; font-size: 1rem; margin-top: 10px;")
      ),
      color = "rgba(20, 20, 20, 0.95)"
    )
    waiter$show()
    
    tryCatch({
      # Extract file ID from Google Drive URL
      url <- input$gdriveUrl
      file_id <- if (grepl("/d/([^/]+)", url)) {
        sub(".*/d/([^/]+).*", "\\1", url)
      } else if (grepl("id=([^&]+)", url)) {
        sub(".*id=([^&]+).*", "\\1", url)
      } else {
        stop("Invalid Google Drive URL format")
      }
      
      # Construct download URL
      download_url <- sprintf("https://drive.google.com/uc?export=download&id=%s", file_id)
      
      # Download to temp file
      temp_file <- tempfile(fileext = ".csv")
      download.file(download_url, temp_file, mode = "wb", quiet = TRUE)
      
      # Read the downloaded file
      df <- read_csv(temp_file, show_col_types = FALSE)
      
      dataManagement$speciesData <- as.data.frame(df)
      dataManagement$speciesOriginal <- as.data.frame(df)
      dataManagement$columnTypes <- sapply(df, class)
      
      waiter$hide()
      
      showNotification(
        sprintf("✓ Data imported from Google Drive: %d rows × %d columns", nrow(df), ncol(df)),
        type = "message",
        duration = 3
      )
    }, error = function(e) {
      waiter$hide()
      showNotification(
        paste("Failed to import from Google Drive:", e$message, 
              "\nEnsure the file is publicly accessible."),
        type = "error",
        duration = 7
      )
    })
  })
  
  # Dataset tabs UI
  output$datasetTabs <- renderUI({
    if (is.null(dataManagement$speciesData)) return(NULL)
    
    tabs <- tagList(
      tags$button(
        class = if (dataManagement$activeDataset == "species") "btn btn-sm btn-primary" else "btn btn-sm btn-outline-secondary",
        style = "border-radius: 0; font-size: 0.85rem;",
        onclick = "Shiny.setInputValue('activeDatasetTab', 'species', {priority: 'event'});",
        icon("dna"), " Species Data"
      )
    )
    
    if (!is.null(dataManagement$envData)) {
      tabs <- tagList(
        tabs,
        tags$button(
          class = if (dataManagement$activeDataset == "env") "btn btn-sm btn-warning" else "btn btn-sm btn-outline-warning",
          style = "border-radius: 0; font-size: 0.85rem; margin-left: 5px;",
          onclick = "Shiny.setInputValue('activeDatasetTab', 'env', {priority: 'event'});",
          icon("leaf"), " Environment Data"
        )
      )
    }
    
    tags$div(style = "display: flex; gap: 5px;", tabs)
  })
  
  # Data info display
  output$dataInfo <- renderUI({
    if (is.null(dataManagement$speciesData)) return(NULL)
    
    df <- if (dataManagement$activeDataset == "species") {
      dataManagement$speciesData
    } else {
      dataManagement$envData
    }
    
    tags$div(
      style = "color: #999; font-size: 0.85rem;",
      icon("table"), sprintf(" %d rows × %d columns", nrow(df), ncol(df))
    )
  })
  
  # Active dataset tab handler
  observeEvent(input$activeDatasetTab, {
    dataManagement$activeDataset <- input$activeDatasetTab
  })
  
  # Column type editor UI
  output$columnTypeEditor <- renderUI({
    df <- if (dataManagement$activeDataset == "species") {
      dataManagement$speciesData
    } else {
      dataManagement$envData
    }
    
    if (is.null(df)) return(NULL)
    
    # Create UI for each column
    col_editors <- lapply(names(df), function(col_name) {
      current_type <- class(df[[col_name]])[1]
      
      tags$div(
        class = "col-md-4 mb-2",
        tags$div(
          style = "background: #2a2a2a; border: 1px solid #3e3e42; border-radius: 4px; padding: 10px;",
          tags$strong(col_name, style = "color: #cccccc; font-size: 0.85rem; display: block; margin-bottom: 5px;"),
          tags$select(
            class = "form-select form-select-sm",
            style = "font-size: 0.75rem;",
            onchange = sprintf("Shiny.setInputValue('colType_%s', this.value, {priority: 'event'});", col_name),
            tags$option(value = "numeric", selected = if (current_type %in% c("numeric", "integer", "double")) "selected" else NULL, "Numeric"),
            tags$option(value = "character", selected = if (current_type == "character") "selected" else NULL, "Text"),
            tags$option(value = "factor", selected = if (current_type == "factor") "selected" else NULL, "Categorical"),
            tags$option(value = "logical", selected = if (current_type == "logical") "selected" else NULL, "Logical")
          )
        )
      )
    })
    
    tags$div(
      class = "row",
      col_editors
    )
  })
  
  # Spreadsheet table with editable cells
  output$spreadsheetTable <- renderDT({
    df <- if (dataManagement$activeDataset == "species") {
      dataManagement$speciesData
    } else {
      dataManagement$envData
    }
    
    if (is.null(df)) return(NULL)
    
    datatable(
      df,
      editable = list(target = "cell", disable = list(columns = NULL)),
      options = list(
        pageLength = 25,
        scrollX = TRUE,
        scrollY = "500px",
        dom = 'Bfrtip',
        buttons = c('copy', 'excel', 'csv'),
        columnDefs = list(
          list(className = 'dt-center', targets = '_all')
        )
      ),
      rownames = TRUE,
      class = 'display compact stripe hover cell-border',
      extensions = 'Buttons'
    )
  })
  
  # Environment spreadsheet table
  output$envSpreadsheetTable <- renderDT({
    if (is.null(dataManagement$envData)) return(NULL)
    
    datatable(
      dataManagement$envData,
      editable = list(target = "cell", disable = list(columns = NULL)),
      options = list(
        pageLength = 25,
        scrollX = TRUE,
        scrollY = "400px",
        dom = 'Bfrtip',
        buttons = c('copy', 'excel', 'csv')
      ),
      rownames = TRUE,
      class = 'display compact stripe hover cell-border',
      extensions = 'Buttons'
    )
  })
  
  # Handle cell edits for species data
  observeEvent(input$spreadsheetTable_cell_edit, {
    info <- input$spreadsheetTable_cell_edit
    str(info)  # For debugging
    
    i <- info$row
    j <- info$col + 1  # DT uses 0-indexed columns
    v <- info$value
    
    # Update the data
    dataManagement$speciesData[i, j] <- v
    
    showNotification(
      "Cell updated",
      type = "message",
      duration = 1
    )
  })
  
  # Handle cell edits for environment data
  observeEvent(input$envSpreadsheetTable_cell_edit, {
    info <- input$envSpreadsheetTable_cell_edit
    
    i <- info$row
    j <- info$col + 1
    v <- info$value
    
    dataManagement$envData[i, j] <- v
    
    showNotification(
      "Cell updated",
      type = "message",
      duration = 1
    )
  })
  
  # Clear data handler
  observeEvent(input$clearData, {
    shinyalert(
      title = "Clear All Data?",
      text = "This will remove all loaded datasets. This action cannot be undone.",
      type = "warning",
      showCancelButton = TRUE,
      confirmButtonText = "Yes, clear it!",
      confirmButtonCol = "#d32f2f",
      callbackR = function(value) {
        if (value) {
          dataManagement$speciesData <- NULL
          dataManagement$envData <- NULL
          dataManagement$speciesOriginal <- NULL
          dataManagement$envOriginal <- NULL
          dataManagement$columnTypes <- NULL
          dataManagement$envColumnTypes <- NULL
          
          showNotification(
            "All data cleared",
            type = "warning",
            duration = 3
          )
        }
      }
    )
  })
  
  # Reset to original data
  observeEvent(input$resetToOriginal, {
    if (!is.null(dataManagement$speciesOriginal)) {
      dataManagement$speciesData <- dataManagement$speciesOriginal
      showNotification(
        "Species data reset to original",
        type = "message",
        duration = 2
      )
    }
    
    if (!is.null(dataManagement$envOriginal)) {
      dataManagement$envData <- dataManagement$envOriginal
      showNotification(
        "Environment data reset to original",
        type = "message",
        duration = 2
      )
    }
  })
  
  # Export edited data
  observeEvent(input$exportEditedData, {
    req(dataManagement$speciesData)
    
    showModal(modalDialog(
      title = HTML('<span style="color: #2e8b57;"><i class="fas fa-download"></i> Export Edited Data</span>'),
      tags$div(
        tags$p("Choose export format and download your edited datasets:"),
        downloadButton("downloadSpeciesData", "Download Species Data", class = "btn-success w-100 mb-2"),
        if (!is.null(dataManagement$envData)) {
          downloadButton("downloadEnvData", "Download Environment Data", class = "btn-warning w-100")
        } else {
          NULL
        }
      ),
      footer = modalButton("Close"),
      size = "m"
    ))
  })
  
  # Download handlers
  output$downloadSpeciesData <- downloadHandler(
    filename = function() {
      paste0("species_data_edited_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write_csv(dataManagement$speciesData, file)
    }
  )
  
  output$downloadEnvData <- downloadHandler(
    filename = function() {
      paste0("environment_data_edited_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write_csv(dataManagement$envData, file)
    }
  )
  
  # ========================================
  # HELPER FUNCTIONS FOR SETTINGS
  # ========================================
  
  # Get ggplot2 theme based on settings
  get_plot_theme <- function() {
    theme_name <- settings$ggplotTheme
    base_size <- 14
    
    theme_obj <- switch(theme_name,
      "minimal" = theme_minimal(base_size = base_size),
      "bw" = theme_bw(base_size = base_size),
      "classic" = theme_classic(base_size = base_size),
      "grey" = theme_grey(base_size = base_size),
      "gray" = theme_gray(base_size = base_size),
      "light" = theme_light(base_size = base_size),
      "dark" = theme_dark(base_size = base_size),
      "void" = theme_void(base_size = base_size),
      theme_minimal(base_size = base_size)  # default
    )
    
    return(theme_obj)
  }
  
  # Get color palette based on settings
  get_color_palette <- function(n = 8) {
    palette_name <- settings$colorPalette
    
    colors <- switch(palette_name,
      "ordin" = rep("#2e8b57", n),  # Ördin green
      "viridis" = viridis::viridis(n),
      "colorblind" = c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7", "#999999")[1:n],
      "set1" = RColorBrewer::brewer.pal(min(n, 9), "Set1"),
      "set2" = RColorBrewer::brewer.pal(min(n, 8), "Set2"),
      rep("#2e8b57", n)  # default
    )
    
    return(colors)
  }
  
  # Get plot DPI for exports
  get_plot_dpi <- function() {
    return(settings$plotDpi)
  }
  
  # ========================================
  # SETTINGS HANDLERS - Enterprise Grade
  # ========================================
  
  # Reactive values for settings
  settings <- reactiveValues(
    autoSave = TRUE,
    notifications = TRUE,
    theme = "dark",
    fontSize = "medium",
    exportFormat = "csv",
    decimalPrecision = 3,
    ggplotTheme = "minimal",
    plotDpi = 300,
    colorPalette = "ordin",
    zoomLevel = 100
  )
  
  # Auto-save toggle
  observeEvent(input$settingsAutoSave, {
    settings$autoSave <- input$settingsAutoSave
    shinyjs::runjs(sprintf(
      "localStorage.setItem('ordin-autosave-enabled', '%s');",
      tolower(as.character(input$settingsAutoSave))
    ))
    
    if (settings$notifications) {
      showNotification(
        paste("Auto-save", ifelse(input$settingsAutoSave, "enabled", "disabled")),
        type = "message",
        duration = 2
      )
    }
  })
  
  # Notifications toggle
  observeEvent(input$settingsNotifications, {
    settings$notifications <- input$settingsNotifications
    shinyjs::runjs(sprintf(
      "localStorage.setItem('ordin-notifications-enabled', '%s');",
      tolower(as.character(input$settingsNotifications))
    ))
  })
  
  # Theme change
  observeEvent(input$settingsTheme, {
    settings$theme <- input$settingsTheme
    
    if (settings$notifications) {
      showNotification(
        paste("Theme changed to", input$settingsTheme),
        type = "message",
        duration = 2
      )
    }
  })
  
  # Font size change
  observeEvent(input$settingsFontSize, {
    settings$fontSize <- input$settingsFontSize
    
    if (settings$notifications) {
      showNotification(
        paste("Font size changed to", input$settingsFontSize),
        type = "message",
        duration = 2
      )
    }
  })
  
  # Export format change
  observeEvent(input$settingsExportFormat, {
    settings$exportFormat <- input$settingsExportFormat
    shinyjs::runjs(sprintf(
      "localStorage.setItem('ordin-export-format', '%s');",
      input$settingsExportFormat
    ))
    
    if (settings$notifications) {
      showNotification(
        paste("Default export format:", toupper(input$settingsExportFormat)),
        type = "message",
        duration = 2
      )
    }
  })
  
  # Decimal precision change
  observeEvent(input$settingsDecimalPrecision, {
    settings$decimalPrecision <- as.numeric(input$settingsDecimalPrecision)
    shinyjs::runjs(sprintf(
      "localStorage.setItem('ordin-decimal-precision', '%s');",
      input$settingsDecimalPrecision
    ))
    
    if (settings$notifications) {
      showNotification(
        paste("Decimal precision set to", input$settingsDecimalPrecision, "digits"),
        type = "message",
        duration = 2
      )
    }
  })
  
  # ggplot2 theme change
  observeEvent(input$settingsGgplotTheme, {
    settings$ggplotTheme <- input$settingsGgplotTheme
    shinyjs::runjs(sprintf(
      "localStorage.setItem('ordin-ggplot-theme', '%s');",
      input$settingsGgplotTheme
    ))
    
    if (settings$notifications) {
      showNotification(
        paste("ggplot2 theme changed to:", input$settingsGgplotTheme),
        type = "message",
        duration = 2
      )
    }
  })
  
  # Plot DPI change
  observeEvent(input$settingsPlotDpi, {
    settings$plotDpi <- as.numeric(input$settingsPlotDpi)
    shinyjs::runjs(sprintf(
      "localStorage.setItem('ordin-plot-dpi', '%s');",
      input$settingsPlotDpi
    ))
    
    if (settings$notifications) {
      showNotification(
        paste("Plot quality set to", input$settingsPlotDpi, "DPI"),
        type = "message",
        duration = 2
      )
    }
  })
  
  # Color palette change
  observeEvent(input$settingsColorPalette, {
    settings$colorPalette <- input$settingsColorPalette
    shinyjs::runjs(sprintf(
      "localStorage.setItem('ordin-color-palette', '%s');",
      input$settingsColorPalette
    ))
    
    if (settings$notifications) {
      showNotification(
        paste("Color palette changed to:", input$settingsColorPalette),
        type = "message",
        duration = 2
      )
    }
  })
  
  # Zoom level change
  observeEvent(input$settingsZoomLevel, {
    settings$zoomLevel <- as.numeric(input$settingsZoomLevel)
    
    if (settings$notifications) {
      showNotification(
        paste("Page zoom:", input$settingsZoomLevel, "%"),
        type = "message",
        duration = 1
      )
    }
  })
  
  # Show citations modal
  observeEvent(input$showCitations, {
    citation_html <- HTML(
      '<div style="text-align: left; font-family: monospace; font-size: 0.85rem; line-height: 1.6;">
      
      <h4 style="color: #2e8b57; margin-bottom: 15px;"><i class="fas fa-quote-left"></i> R Core Team</h4>
      <p style="background: #f5f5f5; padding: 12px; border-left: 3px solid #2e8b57; margin-bottom: 20px;">
      R Core Team (2025). <i>R: A Language and Environment for Statistical Computing</i>. 
      R Foundation for Statistical Computing, Vienna, Austria.
      <br><strong>URL:</strong> <a href="https://www.R-project.org/" target="_blank">https://www.R-project.org/</a>
      </p>
      
      <h4 style="color: #2e8b57; margin-bottom: 15px;"><i class="fas fa-cube"></i> iNEXT Package</h4>
      <p style="background: #f5f5f5; padding: 12px; border-left: 3px solid #2e8b57; margin-bottom: 20px;">
      Hsieh, T. C., Ma, K. H., & Chao, A. (2016). iNEXT: An R package for rarefaction and extrapolation 
      of species diversity (Hill numbers). <i>Methods in Ecology and Evolution</i>, 7(12), 1451-1456.
      <br><strong>DOI:</strong> <a href="https://doi.org/10.1111/2041-210X.12613" target="_blank">10.1111/2041-210X.12613</a>
      </p>
      
      <h4 style="color: #2e8b57; margin-bottom: 15px;"><i class="fas fa-cube"></i> vegan Package</h4>
      <p style="background: #f5f5f5; padding: 12px; border-left: 3px solid #2e8b57; margin-bottom: 20px;">
      Oksanen, J., Simpson, G. L., Blanchet, F. G., Kindt, R., Legendre, P., Minchin, P. R., ... & Wagner, H. (2024). 
      <i>vegan: Community Ecology Package</i>. R package version 2.6-6.1.
      <br><strong>URL:</strong> <a href="https://CRAN.R-project.org/package=vegan" target="_blank">https://CRAN.R-project.org/package=vegan</a>
      </p>
      
      <h4 style="color: #2e8b57; margin-bottom: 15px;"><i class="fas fa-cube"></i> ggplot2 Package</h4>
      <p style="background: #f5f5f5; padding: 12px; border-left: 3px solid #2e8b57; margin-bottom: 20px;">
      Wickham, H. (2016). <i>ggplot2: Elegant Graphics for Data Analysis</i>. Springer-Verlag New York.
      <br><strong>ISBN:</strong> 978-3-319-24277-4
      <br><strong>URL:</strong> <a href="https://ggplot2.tidyverse.org" target="_blank">https://ggplot2.tidyverse.org</a>
      </p>
      
      <h4 style="color: #2e8b57; margin-bottom: 15px;"><i class="fas fa-leaf"></i> Ördin Application</h4>
      <p style="background: #f5f5f5; padding: 12px; border-left: 3px solid #2e8b57; margin-bottom: 20px;">
      Moses, J. (2025). <i>Ördin: An Interactive Platform for Biodiversity Analysis and Ordination</i>. Version 3.0.
      <br><strong>Author:</strong> Jimmy Moses
      <br><strong>License:</strong> MIT
      </p>
      
      <hr style="border: 0; border-top: 1px solid #ddd; margin: 20px 0;">
      
      <p style="text-align: center; color: #666; font-size: 0.8rem;">
      <i class="fas fa-info-circle"></i> Click outside this box or press ESC to close
      </p>
      
      </div>'
    )
    
    shinyalert(
      title = HTML('<span style="color: #2e8b57;"><i class="fas fa-book"></i> Citations & References</span>'),
      text = citation_html,
      html = TRUE,
      type = "",
      showConfirmButton = TRUE,
      confirmButtonText = "Copy All Citations",
      confirmButtonCol = "#2e8b57",
      showCancelButton = TRUE,
      cancelButtonText = "Close",
      size = "l",
      closeOnEsc = TRUE,
      closeOnClickOutside = TRUE,
      animation = TRUE,
      callbackR = function(value) {
        if (value) {
          # Copy citations to clipboard
          citations_text <- paste(
            "R Core Team (2025). R: A Language and Environment for Statistical Computing. R Foundation for Statistical Computing, Vienna, Austria. URL: https://www.R-project.org/",
            "",
            "Hsieh, T. C., Ma, K. H., & Chao, A. (2016). iNEXT: An R package for rarefaction and extrapolation of species diversity (Hill numbers). Methods in Ecology and Evolution, 7(12), 1451-1456. DOI: 10.1111/2041-210X.12613",
            "",
            "Oksanen, J., Simpson, G. L., Blanchet, F. G., Kindt, R., Legendre, P., Minchin, P. R., ... & Wagner, H. (2024). vegan: Community Ecology Package. R package version 2.6-6.1. URL: https://CRAN.R-project.org/package=vegan",
            "",
            "Wickham, H. (2016). ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York. ISBN: 978-3-319-24277-4. URL: https://ggplot2.tidyverse.org",
            "",
            "Moses, J. (2025). Ördin: An Interactive Platform for Biodiversity Analysis and Ordination. Version 3.0.",
            sep = "\n"
          )
          
          shinyjs::runjs(sprintf(
            "navigator.clipboard.writeText(%s);",
            jsonlite::toJSON(citations_text, auto_unbox = TRUE)
          ))
          
          showNotification(
            "All citations copied to clipboard!",
            type = "message",
            duration = 3
          )
        }
      }
    )
  })
  
  # Settings reset handler
  observeEvent(input$settingsReset, {
    settings$autoSave <- TRUE
    settings$notifications <- TRUE
    settings$theme <- "dark"
    settings$fontSize <- "medium"
    settings$exportFormat <- "csv"
    settings$decimalPrecision <- 3
    settings$ggplotTheme <- "minimal"
    settings$plotDpi <- 300
    settings$colorPalette <- "ordin"
    settings$zoomLevel <- 100
    
    showNotification(
      "All settings reset to defaults",
      type = "message",
      duration = 3
    )
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
  # This reactive now uses data from Data Management tab
  data <- reactive({
    # Check if data exists in Data Management
    if (!is.null(dataManagement$speciesData)) {
      cat("\n=== DATA REACTIVE: Using dataManagement$speciesData ===")
      df <- dataManagement$speciesData
      cat("\nData dimensions:", nrow(df), "x", ncol(df))
      cat("\nColumn names:", paste(names(df), collapse=", "))
      cat("\nColumn types:", paste(sapply(df, class), collapse=", "))
      
      # Prepare data in the expected format
      has_sampling_units <- ncol(df) >= 2 && tolower(names(df)[2]) == "samplingunits"
      
      if (has_sampling_units) {
        cat("\nDetected incidence_freq format with sampling units\n")
        site_names <- df[[1]]
        sampling_units <- df[[2]]
        species_data <- df[, -c(1, 2)]
        
        inext_list <- lapply(1:nrow(df), function(i) c(sampling_units[i], as.numeric(species_data[i, ])))
        names(inext_list) <- site_names
        abund_matrix <- as.matrix(species_data)
        rownames(abund_matrix) <- site_names
        
        cat("\nReturning data: original matrix (", nrow(abund_matrix), "x", ncol(abund_matrix), "), format: incidence_freq\n")
        return(list(
          original = abund_matrix, 
          inext_data = inext_list, 
          data_format = "incidence_freq",
          sampling_units = sampling_units
        ))
      } else {
        cat("\nProcessing as abundance or incidence_raw format\n")
        # Assume first column is site names
        if (ncol(df) < 2) {
          cat("\nERROR: Insufficient columns (<2)\n")
          return(NULL)
        }
        
        site_names <- df[[1]]
        abund_matrix <- as.matrix(df[-1])
        rownames(abund_matrix) <- site_names
        
        # Check if numeric
        if (!all(sapply(df[-1], is.numeric))) {
          cat("\nERROR: Non-numeric columns detected!\n")
          cat("Column types:", paste(sapply(df[-1], class), collapse=", "), "\n")
          return(NULL)
        }
        
        is_binary <- all(abund_matrix %in% c(0, 1))
        abund_matrix_t <- t(abund_matrix)
        colnames(abund_matrix_t) <- site_names
        
        cat("\nReturning data: original matrix (", nrow(abund_matrix), "x", ncol(abund_matrix), "), format:", if(is_binary) "incidence_raw" else "abundance", "\n")
        return(list(
          original = abund_matrix, 
          transposed = abund_matrix_t, 
          inext_data = abund_matrix_t,
          data_format = if(is_binary) "incidence_raw" else "abundance", 
          is_binary = is_binary
        ))
      }
    }
    
    # Fallback to old file input (if still used)
    req(input$dataFile)
    
    # Show professional loading spinner
    waiter <- Waiter$new(
      html = tagList(
        spin_loaders(42, color = "#2e8b57"),
        h3("Loading Your Data...", style = "color: #2e8b57; margin-top: 30px; font-weight: 700;"),
        p("Validating structure and preparing for analysis", 
          style = "color: #999; font-size: 1rem; margin-top: 10px;")
      ),
      color = "rgba(20, 20, 20, 0.95)"
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
  
  # ========================================
  # DIVERSITY ANALYSIS - Sub-Navigation & Settings
  # ========================================
  
  # Track active sub-navigation
  diversityActiveTab <- reactiveVal("estimation")
  
  observeEvent(input$diversitySubNav, {
    diversityActiveTab(input$diversitySubNav)
  })
  
  # Data Status Display
  output$diversityDataStatus <- renderUI({
    if (!is.null(dataManagement$speciesData)) {
      tags$div(
        class = "alert alert-success",
        style = "background: #1a3a1a; border: 2px solid #2e8b57; border-radius: 8px; padding: 15px;",
        tags$div(
          style = "display: flex; align-items: center; gap: 10px;",
          tags$div(style = "font-size: 2em; color: #2e8b57;", icon("check-circle")),
          tags$div(
            tags$strong(style = "color: #2e8b57; font-size: 1rem;", "Data Loaded"),
            tags$br(),
            tags$small(
              style = "color: #aaa; font-size: 0.85rem;",
              sprintf("%d sites × %d species", 
                     nrow(dataManagement$speciesData), 
                     ncol(dataManagement$speciesData) - 1)
            )
          )
        ),
        tags$hr(style = "border-color: #3e3e42; margin: 10px 0;"),
        actionButton(
          "goToDataTab",
          "Manage Data",
          icon = icon("database"),
          class = "btn btn-sm btn-outline-success w-100",
          onclick = "Shiny.setInputValue('main_nav', 'Data', {priority: 'event'});"
        )
      )
    } else {
      tags$div(
        class = "alert alert-warning",
        style = "background: #3a2a0a; border: 2px solid #ff8c00; border-radius: 8px; padding: 15px;",
        tags$div(
          style = "display: flex; align-items: center; gap: 10px;",
          tags$div(style = "font-size: 2em; color: #ff8c00;", icon("exclamation-triangle")),
          tags$div(
            tags$strong(style = "color: #ff8c00; font-size: 1rem;", "No Data Loaded"),
            tags$br(),
            tags$small(style = "color: #aaa; font-size: 0.85rem;", "Import data to begin analysis")
          )
        ),
        tags$hr(style = "border-color: #3e3e42; margin: 10px 0;"),
        actionButton(
          "goToDataTabUpload",
          "Import Data",
          icon = icon("upload"),
          class = "btn btn-sm btn-warning w-100",
          onclick = "Shiny.setInputValue('main_nav', 'Data', {priority: 'event'});"
        )
      )
    }
  })
  
  # Dynamic Settings Content Based on Sub-Navigation
  output$diversitySettingsContent <- renderUI({
    active_tab <- diversityActiveTab()
    
    if (active_tab == "estimation") {
      # iNEXT Estimation Settings
      tagList(
        tags$h5(
          icon("chart-line"), " Estimation Settings",
          style = "color: #2e8b57; margin-bottom: 20px; font-weight: 600;"
        ),
        
        selectInput(
          "dataType",
          "Data Type",
          choices = c(
            "Abundance" = "abundance",
            "Incidence (Binary)" = "incidence_raw",
            "Incidence (Freq)" = "incidence_freq"
          ),
          width = "100%"
        ),
        
        selectInput(
          "plotType",
          "Plot Type",
          choices = c(
            "Sample-based" = "1",
            "Completeness" = "2",
            "Coverage" = "3"
          ),
          width = "100%"
        ),
        
        accordion(
          accordion_panel(
            title = "Advanced Options",
            icon = icon("cog"),
            checkboxGroupInput(
              "hillNumbers",
              "Hill Numbers",
              choices = c("q=0" = "0", "q=1" = "1", "q=2" = "2"),
              selected = c("0", "1", "2")
            ),
            numericInput("knots", "Knots", value = 40, min = 10, max = 200),
            numericInput("nboot", "Bootstrap", value = 50, min = 10, max = 500),
            numericInput("conf", "Confidence", value = 0.95, min = 0.8, max = 0.99, step = 0.01),
            numericInput("endpoint", "Endpoint", value = NULL)
          )
        ),
        
        actionButton(
          "runDiversity",
          "Run Estimation",
          class = "btn-success btn-lg w-100 mt-3",
          icon = icon("play")
        )
      )
    } else {
      # Diversity Indices Settings
      tagList(
        tags$h5(
          icon("calculator"), " Indices Settings",
          style = "color: #ff8c00; margin-bottom: 20px; font-weight: 600;"
        ),
        
        card(
          card_header("Alpha Diversity", class = "py-2"),
          card_body(
            class = "py-2",
            checkboxGroupInput(
              "alphaIndices",
              NULL,
              choices = c(
                "Shannon" = "shannon",
                "Simpson" = "simpson",
                "InvSimpson" = "invsimpson",
                "Fisher" = "fisher",
                "Richness" = "richness"
              ),
              selected = c("shannon", "simpson", "richness")
            )
          )
        ),
        
        card(
          class = "mt-2",
          card_header("Evenness", class = "py-2"),
          card_body(
            class = "py-2",
            checkboxGroupInput(
              "evennessIndices",
              NULL,
              choices = c(
                "Pielou" = "pielou",
                "SimpsonE" = "simpsone",
                "Evar" = "evar"
              ),
              selected = c("pielou")
            )
          )
        ),
        
        actionButton(
          "runIndices",
          "Calculate Indices",
          class = "btn-warning btn-lg w-100 mt-3",
          icon = icon("calculator")
        )
      )
    }
  })
  
  # Update main content based on sub-navigation
  output$diversityMainContent <- renderUI({
    active_tab <- diversityActiveTab()
    
    if (is.null(active_tab) || active_tab == "estimation") {
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
    cat("\n=== RUN DIVERSITY BUTTON CLICKED ===")
    req(data())
    cat("\nData available for analysis")
    
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
        spin_loaders(42, color = "#2e8b57"),  # Professional circular loader
        h3("Running iNEXT Analysis", style = "color: #2e8b57; margin-top: 30px; font-weight: 700;"),
        p("Estimating species diversity with bootstrap confidence intervals", 
          style = "color: #999; font-size: 1rem; margin-top: 10px;"),
        tags$div(
          style = "margin-top: 20px; padding: 15px; background: rgba(46, 139, 87, 0.1); border-radius: 8px; border-left: 4px solid #2e8b57;",
          tags$p(style = "color: #aaa; font-size: 0.9rem; margin: 0;",
            icon("info-circle"), " This may take a moment depending on data size and bootstrap iterations")
        )
      ),
      color = "rgba(20, 20, 20, 0.95)"
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
        get_plot_theme() +
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
      plot_dpi <- get_plot_dpi()
      
      if (format == "png") {
        ggsave(file, plot = diversityResults()$plot, device = "png", width = 12, height = 8, dpi = plot_dpi, bg = "white")
      } else if (format == "tiff") {
        ggsave(file, plot = diversityResults()$plot, device = "tiff", width = 12, height = 8, dpi = plot_dpi, bg = "white")
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
  
  # Update factor variable choices when environment data is loaded
  observe({
    if (!is.null(dataManagement$envData)) {
      env_data <- dataManagement$envData[, -1]  # Remove Site column
      # Find categorical/factor variables
      factor_vars <- names(env_data)[sapply(env_data, function(x) is.character(x) || is.factor(x))]
      
      if (length(factor_vars) > 0) {
        updateSelectInput(session, "ellipseFactor", choices = factor_vars, selected = factor_vars[1])
      } else {
        updateSelectInput(session, "ellipseFactor", choices = "No categorical variables", selected = NULL)
      }
    }
  })
  
  # Dynamic scaling explanation
  output$scalingExplanation <- renderUI({
    scaling <- input$scalingType
    
    explanation <- switch(scaling,
      "1" = "Preserves distance among sites (rows)",
      "2" = "Preserves correlation among species/vars (columns)",
      "3" = "Symmetric scaling (balanced)",
      "Scaling information"
    )
    
    HTML(explanation)
  })
  
  observeEvent(input$runOrdination, {
    req(data())
    
    # Show loading
    waiter <- Waiter$new(
      html = tagList(
        spin_loaders(42, color = "#4169e1"),
        h3("Running Ordination Analysis", style = "color: #4169e1; margin-top: 30px; font-weight: 700;"),
        p(paste("Method:", toupper(input$ordinationMethod)), 
          style = "color: #999; font-size: 1.1rem; margin-top: 10px; font-weight: 600;"),
        tags$div(
          style = "margin-top: 20px; padding: 15px; background: rgba(65, 105, 225, 0.1); border-radius: 8px; border-left: 4px solid #4169e1;",
          tags$p(style = "color: #aaa; font-size: 0.9rem; margin: 0;",
            icon("project-diagram"), " Computing multivariate ordination with publication-quality settings")
        )
      ),
      color = "rgba(20, 20, 20, 0.95)"
    )
    waiter$show()
    
    result <- tryCatch({
      withProgress(message = 'Running ordination...', value = 0, {
      abund_matrix <- data()$original
      method <- input$ordinationMethod
      
      # Apply data transformation
      incProgress(0.1, detail = "Applying transformation...")
      if (!is.null(input$dataTransform) && input$dataTransform != "none") {
        abund_matrix <- switch(input$dataTransform,
          "hellinger" = decostand(abund_matrix, "hellinger"),
          "chi.square" = decostand(abund_matrix, "chi.square"),
          "log" = log1p(abund_matrix),
          "sqrt" = sqrt(abund_matrix),
          "pa" = decostand(abund_matrix, "pa"),
          "wisconsin" = wisconsin(abund_matrix),
          abund_matrix
        )
      }
      
      incProgress(0.3, detail = paste("Calculating", toupper(method), "..."))
      
      # Get scaling parameter
      scaling_val <- if (!is.null(input$scalingType)) as.numeric(input$scalingType) else 2
      
      result <- if (method == "nmds") {
        # Enhanced NMDS with all parameters
        k_val <- if (!is.null(input$nmdsK)) input$nmdsK else input$ordDimensions
        try_val <- if (!is.null(input$nmdsTry)) input$nmdsTry else 20
        trymax_val <- if (!is.null(input$nmdsTrymax)) input$nmdsTrymax else 100
        autotransform <- if (!is.null(input$nmdsAutotransform)) input$nmdsAutotransform else TRUE
        engine_val <- if (!is.null(input$nmdsEngine)) input$nmdsEngine else "monoMDS"
        wascores_val <- if (!is.null(input$nmdsWascores)) input$nmdsWascores else TRUE
        
        dist_mat <- vegdist(abund_matrix, method = input$distMethod)
        ord <- metaMDS(dist_mat, k = k_val, try = try_val, trymax = trymax_val, 
                      autotransform = autotransform, engine = engine_val, 
                      wascores = wascores_val, trace = 0)
        
        scores_df <- data.frame(Site = rownames(scores(ord, display = "sites")), 
                               scores(ord, display = "sites"))
        
        list(scores = scores_df, stress = ord$stress, method = "NMDS", ord_object = ord,
             convergence = ord$converged, tries = ord$tries)
             
      } else if (method == "pca") {
        ord <- rda(abund_matrix, scale = FALSE)  # PCA via RDA
        scores_df <- data.frame(Site = rownames(abund_matrix), 
                               scores(ord, display = "sites", scaling = scaling_val, 
                                     choices = 1:min(input$ordDimensions, 2)))
        
        # Calculate explained variance
        eig_vals <- eigenvals(ord)
        var_explained <- eig_vals / sum(eig_vals) * 100
        
        list(scores = scores_df, stress = NULL, method = "PCA", ord_object = ord,
             variance = var_explained, scaling = scaling_val, eigenvalues = eig_vals)
             
      } else if (method == "ca") {
        ord <- cca(abund_matrix)
        scores_df <- data.frame(Site = rownames(abund_matrix), 
                               scores(ord, display = "sites", scaling = scaling_val,
                                     choices = 1:min(input$ordDimensions, 2)))
        
        # Calculate inertia
        total_inertia <- ord$tot.chi
        eig_vals <- eigenvals(ord)
        inertia_explained <- eig_vals / total_inertia * 100
        
        list(scores = scores_df, stress = NULL, method = "CA", ord_object = ord,
             inertia = inertia_explained, scaling = scaling_val, eigenvalues = eig_vals)
             
      } else if (method == "dca") {
        ord <- decorana(abund_matrix)
        scores_df <- data.frame(Site = rownames(abund_matrix), 
                               scores(ord, display = "sites", choices = 1:min(input$ordDimensions, 2)))
        
        # Get axis lengths
        axis_lengths <- ord$evals
        
        list(scores = scores_df, stress = NULL, method = "DCA", ord_object = ord,
             axis_lengths = axis_lengths, eigenvalues = axis_lengths)
             
      } else if (method == "cca") {
        # Constrained Correspondence Analysis
        if (is.null(dataManagement$envData)) {
          stop("CCA requires environment data. Please load environment data in the Data tab.")
        }
        env_matrix <- dataManagement$envData[, -1]
        ord <- cca(abund_matrix ~ ., data = env_matrix)
        scores_df <- data.frame(Site = rownames(abund_matrix), 
                               scores(ord, display = "sites", scaling = scaling_val,
                                     choices = 1:min(input$ordDimensions, 2)))
        
        # Get constrained and unconstrained inertia
        const_inertia <- ord$CCA$tot.chi
        unconst_inertia <- ord$CA$tot.chi
        total_inertia <- ord$tot.chi
        eig_vals <- eigenvals(ord)
        
        # Calculate percentage for CONSTRAINED axes only
        cca_eigs <- eig_vals[grepl("^CCA", names(eig_vals))]
        cca_var_explained <- (cca_eigs / const_inertia) * 100
        
        list(scores = scores_df, stress = NULL, method = "CCA", constrained = TRUE, 
             ord_object = ord, env_data = env_matrix, scaling = scaling_val,
             constrained_prop = const_inertia / total_inertia * 100,
             eigenvalues = eig_vals,
             variance = cca_var_explained)  # Add constrained variance percentages
             
      } else if (method == "rda") {
        # Redundancy Analysis
        if (is.null(dataManagement$envData)) {
          stop("RDA requires environment data. Please load environment data in the Data tab.")
        }
        env_matrix <- dataManagement$envData[, -1]
        ord <- rda(abund_matrix ~ ., data = env_matrix)
        scores_df <- data.frame(Site = rownames(abund_matrix), 
                               scores(ord, display = "sites", scaling = scaling_val,
                                     choices = 1:min(input$ordDimensions, 2)))
        
        # Calculate R-squared and adjusted R-squared
        r_squared <- RsquareAdj(ord)$r.squared
        adj_r_squared <- RsquareAdj(ord)$adj.r.squared
        eig_vals <- eigenvals(ord)
        
        # Calculate percentage for CONSTRAINED axes only
        rda_eigs <- eig_vals[grepl("^RDA", names(eig_vals))]
        total_constrained <- sum(rda_eigs)
        rda_var_explained <- (rda_eigs / total_constrained) * 100
        
        list(scores = scores_df, stress = NULL, method = "RDA", constrained = TRUE,
             ord_object = ord, env_data = env_matrix, scaling = scaling_val,
             r_squared = r_squared, adj_r_squared = adj_r_squared,
             eigenvalues = eig_vals,
             variance = rda_var_explained)  # Add constrained variance percentages
             
      } else if (method == "pcoa") {
        dist_mat <- vegdist(abund_matrix, method = input$distMethod)
        ord <- cmdscale(dist_mat, k = input$ordDimensions, eig = TRUE, add = TRUE)
        scores_df <- data.frame(Site = rownames(abund_matrix), 
                               ord$points[, 1:min(input$ordDimensions, 2)])
        names(scores_df)[-1] <- paste0("Axis", 1:(ncol(scores_df)-1))
        
        # Calculate variance explained
        eig_vals <- ord$eig[ord$eig > 0]
        var_explained <- eig_vals / sum(eig_vals) * 100
        
        list(scores = scores_df, stress = NULL, method = "PCoA", ord_object = ord,
             variance = var_explained, eigenvalues = eig_vals)
      }
      
      incProgress(0.7, detail = "Creating publication-quality plot...")
      
      # Store environment data and original matrix for biplot
      result$env_data <- if (!is.null(dataManagement$envData)) dataManagement$envData[, -1] else NULL
      result$species_matrix <- abund_matrix
      
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
      
      # Show detailed success message with diagnostics
      diagnostic_msg <- if (result$method == "NMDS") {
        paste0("✓ NMDS complete! Stress: ", round(result$stress, 3), 
               " | Converged: ", result$convergence, " | Tries: ", result$tries)
      } else if (result$method %in% c("PCA", "PCoA")) {
        paste0("✓ ", result$method, " complete! Axis 1: ", 
               round(result$variance[1], 1), "%, Axis 2: ", round(result$variance[2], 1), "%")
      } else if (result$method %in% c("CA", "DCA")) {
        paste0("✓ ", result$method, " complete!")
      } else if (result$method == "CCA") {
        paste0("✓ CCA complete! Constrained: ", round(result$constrained_prop, 1), "%")
      } else if (result$method == "RDA") {
        paste0("✓ RDA complete! R²: ", round(result$r_squared, 3), 
               " | Adj. R²: ", round(result$adj_r_squared, 3))
      } else {
        paste0("✓ ", result$method, " analysis complete!")
      }
      
      showNotification(
        diagnostic_msg,
        type = "message",
        duration = 5
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
            
            # CA/DCA
            tags$div(
              class = "col-lg-3 col-md-4 mb-3",
              style = "background: #1a1a3a; border: 2px solid #4169e1; border-radius: 12px; padding: 20px; transition: all 0.3s; min-height: 150px; text-align: center;",
              onmouseover = "this.style.transform='scale(1.05)'; this.style.borderColor='#5179f1'; this.style.boxShadow='0 10px 25px rgba(65,105,225,0.3)';",
              onmouseout = "this.style.transform='scale(1)'; this.style.borderColor='#4169e1'; this.style.boxShadow='none';",
              tags$div(style = "font-size: 1.8em; color: #4169e1; margin-bottom: 10px; font-weight: 700;", "CA/DCA"),
              tags$h6(style = "color: #fff; font-weight: 600; margin-bottom: 8px; font-size: 0.95em;", "Correspondence"),
              tags$p(style = "color: #aaa; font-size: 0.8em; margin: 0;", "Unimodal data")
            ),
            
            # CCA/RDA
            tags$div(
              class = "col-lg-3 col-md-4 mb-3",
              style = "background: #1a2a1a; border: 2px solid #2e8b57; border-radius: 12px; padding: 20px; transition: all 0.3s; min-height: 150px; text-align: center;",
              onmouseover = "this.style.transform='scale(1.05)'; this.style.borderColor='#3fa869'; this.style.boxShadow='0 10px 25px rgba(46,139,87,0.3)';",
              onmouseout = "this.style.transform='scale(1)'; this.style.borderColor='#2e8b57'; this.style.boxShadow='none';",
              tags$div(style = "font-size: 1.8em; color: #2e8b57; margin-bottom: 10px; font-weight: 700;", "CCA/RDA"),
              tags$h6(style = "color: #fff; font-weight: 600; margin-bottom: 8px; font-size: 0.95em;", "Constrained"),
              tags$p(style = "color: #aaa; font-size: 0.8em; margin: 0;", "Requires env data")
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
                # Stress/quality info
                if (!is.null(res$stress)) {
                  div(class = "alert alert-info", style = "background-color: #1a3a52; color: #fff;",
                     h5(paste("🎯 Stress:", round(res$stress, 3))),
                     p(ifelse(res$stress < 0.05, "✅ Excellent", ifelse(res$stress < 0.1, "✅ Good", 
                            ifelse(res$stress < 0.2, "⚠️ Acceptable", "❌ Poor")))))
                },
                
                # Eigenvalues/Variance Explained
                if (!is.null(res$variance) || !is.null(res$inertia) || !is.null(res$eigenvalues)) {
                  div(class = "alert", style = "background-color: #1a2a1a; color: #fff; border-left: 4px solid #2e8b57;",
                     h5("📊 Variance Explained", style = "color: #2e8b57;"),
                     if (!is.null(res$variance)) {
                       tagList(
                         p(paste("Axis 1:", round(res$variance[1], 2), "%")),
                         p(paste("Axis 2:", round(res$variance[2], 2), "%")),
                         p(paste("Cumulative:", round(sum(res$variance[1:2]), 2), "%"))
                       )
                     } else if (!is.null(res$inertia)) {
                       tagList(
                         p(paste("Axis 1:", round(res$inertia[1], 2), "%")),
                         p(paste("Axis 2:", round(res$inertia[2], 2), "%")),
                         p(paste("Cumulative:", round(sum(res$inertia[1:2]), 2), "%"))
                       )
                     },
                     if (!is.null(res$eigenvalues)) {
                       tagList(
                         hr(style = "border-color: #2e8b57;"),
                         h6("Eigenvalues:", style = "color: #2e8b57;"),
                         p(paste(names(res$eigenvalues), "=", round(res$eigenvalues, 4), collapse = ", "),
                           style = "font-family: monospace; font-size: 0.9em;")
                       )
                     }
                  )
                },
                
                # Ordination Scores Table
                h4("Ordination Scores (Site/Case Scores)", style = "color: #2e8b57;"),
                div(style = "margin-bottom: 15px;",
                   downloadButton("downloadOrdinationScores", "Download Scores (CSV)", 
                                 class = "btn-info", 
                                 style = "margin-right: 10px;"),
                   downloadButton("downloadOrdinationEigen", "Download Eigenvalues (CSV)", 
                                 class = "btn-info")
                ),
                DTOutput("ordinationTable"),
                
                # Visualization
                h4("Visualization", style = "color: #2e8b57; margin-top: 30px;"),
                div(style = "margin-bottom: 15px;",
                   selectInput("ordinationPlotFormat", "Export Format:", 
                              choices = c("PNG" = "png", "SVG" = "svg"), width = "150px"),
                   downloadButton("downloadOrdinationPlot", "Download Plot", class = "btn-success")),
                plotOutput("ordinationPlot", height = "650px"))
      )
    }
  })
  
  output$ordinationTable <- renderDT({
    req(ordinationResults())
    datatable(ordinationResults()$scores, options = list(pageLength = 15, scrollX = TRUE), rownames = FALSE)
  })
  
  # Reactive ordination plot that responds to biplot options
  ordinationPlotReactive <- reactive({
    req(ordinationResults())
    
    result <- ordinationResults()
    req(result$scores)
    
    # Validate we have enough columns
    if (ncol(result$scores) < 3) {
      cat("\nWARNING: Insufficient columns in scores data frame\n")
      return(NULL)
    }
    
    tryCatch({
      axis_names <- names(result$scores)[-1]
      cat("\n=== CREATING BIPLOT ===")
      cat("\nMethod:", result$method)
      cat("\nAxis names:", paste(axis_names, collapse = ", "))
      
      # Determine background color and theme based on selection FIRST
      plot_theme <- if (!is.null(input$plotTheme)) input$plotTheme else "dark"
      
      # Set theme colors with improved contrast
      if (plot_theme == "dark") {
        bg_color <- "#1a1a1a"  # Darker for better contrast
        text_color <- "#ffffff"
        grid_color <- "#3a3a3a"  # More visible grid
        panel_border <- element_blank()
        site_color <- "#00d9ff"  # Bright cyan for visibility
        species_color <- "#ff6b9d"  # Bright pink for species
        arrow_color <- "#ffa500"  # Bright orange for arrows
        grid_linewidth <- 0.3
      } else if (plot_theme == "light") {
        bg_color <- "#ffffff"
        text_color <- "#000000"
        grid_color <- "#d0d0d0"  # More visible grid
        panel_border <- element_blank()
        site_color <- "#0066cc"  # Strong blue for sites
        species_color <- "#cc0033"  # Strong red for species
        arrow_color <- "#ff8000"  # Strong orange for arrows
        grid_linewidth <- 0.4
      } else if (plot_theme == "classic") {
        bg_color <- "#fafafa"  # Slightly off-white
        text_color <- "#000000"
        grid_color <- "#b0b0b0"  # Darker grid
        panel_border <- element_rect(color = "#000000", fill = NA, linewidth = 1)
        site_color <- "#2c5aa0"  # Classic blue
        species_color <- "#c92a2a"  # Classic red
        arrow_color <- "#e67700"  # Classic orange
        grid_linewidth <- 0.5
      } else if (plot_theme == "minimal") {
        bg_color <- "#ffffff"
        text_color <- "#1a1a1a"  # Dark gray for softer contrast
        grid_color <- "#e8e8e8"  # Very subtle grid
        panel_border <- element_blank()
        site_color <- "#4a90e2"  # Modern blue
        species_color <- "#e24a90"  # Modern magenta
        arrow_color <- "#f5a623"  # Modern amber
        grid_linewidth <- 0.2
      } else if (plot_theme == "publication") {
        bg_color <- "#ffffff"
        text_color <- "#000000"
        grid_color <- "#c0c0c0"  # Strong grid for clarity
        panel_border <- element_rect(color = "#000000", fill = NA, linewidth = 1.2)
        site_color <- "#005a9c"  # Professional blue
        species_color <- "#9c0045"  # Professional burgundy
        arrow_color <- "#d97500"  # Professional orange
        grid_linewidth <- 0.6
      } else {
        # Default to dark
        bg_color <- "#1a1a1a"
        text_color <- "#ffffff"
        grid_color <- "#3a3a3a"
        panel_border <- element_blank()
        site_color <- "#00d9ff"
        species_color <- "#ff6b9d"
        arrow_color <- "#ffa500"
        grid_linewidth <- 0.3
      }
      
      plot_color <- get_color_palette(1)[1]
      
      # Flag to track if ellipses will be added
      use_ellipses <- FALSE
      
      # Check if we should add ellipses and prepare the data
      if (!is.null(input$showEnvEllipses) && input$showEnvEllipses && 
          !is.null(result$env_data) && !is.null(input$ellipseFactor)) {
        
        cat("\nChecking ellipse factor:", input$ellipseFactor)
        
        # Validate factor exists and is valid
        if (input$ellipseFactor != "No categorical variables" && 
            input$ellipseFactor %in% names(result$env_data)) {
          
          factor_col <- result$env_data[[input$ellipseFactor]]
          
          # Convert to factor if character
          if (is.character(factor_col)) {
            factor_col <- as.factor(factor_col)
          }
          
          # Check if factor has at least 2 levels and sufficient observations
          if (is.factor(factor_col) && nlevels(factor_col) >= 2) {
            # Check each level has at least 3 observations (minimum for ellipse)
            level_counts <- table(factor_col)
            
            if (all(level_counts >= 3)) {
              cat("\nAdding ellipses for factor:", input$ellipseFactor)
              cat("\nLevels:", levels(factor_col))
              cat("\nCounts:", paste(level_counts, collapse = ", "))
              
              # Add factor column to scores BEFORE creating base plot
              result$scores$FactorGroup <- factor_col
              use_ellipses <- TRUE
            } else {
              cat("\nWARNING: Some factor levels have < 3 observations, skipping ellipses")
              cat("\nLevel counts:", paste(level_counts, collapse = ", "))
            }
          } else {
            cat("\nWARNING: Factor has < 2 levels or is not a factor, skipping ellipses")
          }
        } else {
          cat("\nWARNING: Invalid or missing factor for ellipses")
        }
      }
      
      # Base plot
      plot_obj <- ggplot(result$scores, aes(x = .data[[axis_names[1]]], y = .data[[axis_names[2]]]))
      
      # Add ellipses if validated
      if (use_ellipses) {
        ellipse_level <- if (!is.null(input$ellipseConfidence)) input$ellipseConfidence else 0.95
        ellipse_alpha <- if (!is.null(input$ellipseAlpha)) input$ellipseAlpha else 0.15
        
        plot_obj <- plot_obj +
          stat_ellipse(aes(color = FactorGroup, fill = FactorGroup), 
                      geom = "polygon", alpha = ellipse_alpha, level = ellipse_level, 
                      linewidth = 1, show.legend = TRUE)
      }
      
      # Add site points and labels
      point_size <- if (!is.null(input$pointSize)) input$pointSize else 4
      label_size <- if (!is.null(input$labelSize)) input$labelSize else 3.5
      
      if (use_ellipses) {
        # Create vibrant color palette for site groups
        n_groups <- length(unique(result$scores$FactorGroup))
        
        # Use high-contrast colors based on theme
        if (plot_theme == "dark") {
          group_colors <- c("#00d9ff", "#ff6b9d", "#7fff00", "#ffa500", 
                           "#ff1493", "#00ff7f", "#ffff00", "#ff69b4")[1:n_groups]
        } else {
          group_colors <- c("#0066cc", "#cc0033", "#00aa00", "#ff8000",
                           "#9900cc", "#009999", "#cc9900", "#cc0066")[1:n_groups]
        }
        
        plot_obj <- plot_obj +
          geom_point(aes(color = FactorGroup, fill = FactorGroup), 
                    size = point_size + 1, alpha = 0.9, stroke = 1.5, shape = 21) +
          geom_text(aes(label = Site), vjust = -1.3, color = text_color, 
                   size = label_size, fontface = "bold") +
          scale_color_manual(name = "Site groups", values = group_colors) +
          scale_fill_manual(name = "Site groups", values = group_colors) +
          guides(color = guide_legend(override.aes = list(size = 5, alpha = 1)),
                fill = guide_legend(override.aes = list(size = 5, alpha = 0.3)))
      } else {
        # Add sites with manual legend entry and theme color
        plot_obj <- plot_obj +
          geom_point(aes(shape = "Sites", color = "Sites"), 
                    size = point_size + 0.5, alpha = 0.85, stroke = 1.5) +
          geom_text(aes(label = Site), vjust = -1.2, color = text_color, 
                   size = label_size, fontface = "bold") +
          scale_shape_manual(name = "",
                            values = c("Sites" = 16),
                            labels = c("Sites" = "Site scores")) +
          scale_color_manual(name = "",
                            values = c("Sites" = site_color),
                            labels = c("Sites" = "Site scores"))
      }
      
      # Add species scores if requested
      if (!is.null(input$showSpecies) && input$showSpecies && !is.null(result$ord_object)) {
        
        cat("\nAdding species scores...")
        
        # Extract species scores from ordination object
        species_scores <- tryCatch({
          if (result$method == "NMDS") {
            # For NMDS, use wascores or species scores if available
            if (!is.null(result$ord_object$species)) {
              data.frame(result$ord_object$species)
            } else {
              scores(result$ord_object, display = "species")
            }
          } else if (result$method %in% c("PCA", "CA", "DCA")) {
            # For unconstrained ordination
            scores(result$ord_object, display = "species", choices = 1:2)
          } else if (result$method %in% c("CCA", "RDA")) {
            # For constrained ordination, get species scores
            scores(result$ord_object, display = "species", choices = 1:2)
          } else if (result$method == "PCoA") {
            # PCoA doesn't have species scores - skip
            NULL
          } else {
            NULL
          }
        }, error = function(e) {
          cat("\nWARNING: Could not extract species scores:", e$message, "\n")
          NULL
        })
        
        if (!is.null(species_scores)) {
          # Convert to data frame if matrix
          if (is.matrix(species_scores)) {
            species_scores <- as.data.frame(species_scores)
          }
          
          # Ensure we have the right column names
          if (ncol(species_scores) >= 2) {
            names(species_scores)[1:2] <- axis_names[1:2]
            species_scores$Species <- rownames(species_scores)
            
            # Filter top N species if requested
            top_n <- if (!is.null(input$speciesTopN)) input$speciesTopN else 20
            
            if (top_n > 0 && nrow(species_scores) > top_n) {
              # Calculate distance from origin to select most influential species
              species_scores$dist <- sqrt(species_scores[[axis_names[1]]]^2 + 
                                         species_scores[[axis_names[2]]]^2)
              species_scores <- species_scores[order(species_scores$dist, decreasing = TRUE)[1:top_n], ]
              species_scores$dist <- NULL
              cat("\nShowing top", top_n, "species")
            }
            
            cat("\nAdding", nrow(species_scores), "species to plot")
            
            # Determine display type
            display_type <- if (!is.null(input$speciesDisplay)) input$speciesDisplay else "points"
            
            # Add species to plot with legend
            if (display_type %in% c("points", "both")) {
              plot_obj <- plot_obj +
                geom_point(data = species_scores,
                          aes(x = .data[[axis_names[1]]], y = .data[[axis_names[2]]],
                              shape = "Species", color = "Species"),
                          size = 3, alpha = 0.8, stroke = 1.2,
                          inherit.aes = FALSE) +
                scale_shape_manual(name = "",
                                  values = c("Species" = 17),
                                  labels = c("Species" = "Species scores")) +
                scale_color_manual(name = "",
                                  values = c("Species" = species_color),
                                  labels = c("Species" = "Species scores"))
            }
            
            if (display_type %in% c("text", "both")) {
              plot_obj <- plot_obj +
                geom_text(data = species_scores,
                         aes(x = .data[[axis_names[1]]], y = .data[[axis_names[2]]],
                             label = Species),
                         color = species_color, size = 3.2, fontface = "italic", 
                         alpha = 0.9, inherit.aes = FALSE, hjust = -0.1, vjust = -0.1)
            }
          }
        } else {
          cat("\nNo species scores available for", result$method, "\n")
        }
      }
      
      # Add environmental arrows for continuous variables if requested
      if (!is.null(input$showEnvArrows) && input$showEnvArrows && 
          !is.null(result$ord_object) && !is.null(result$env_data)) {
        
        cat("\nAdding environmental arrows...")
        
        # Get continuous variables
        cont_vars <- names(result$env_data)[sapply(result$env_data, is.numeric)]
        
        if (length(cont_vars) > 0) {
          cat("\nContinuous variables found:", paste(cont_vars, collapse = ", "))
          
          # Fit environmental vectors using envfit
          env_fit <- tryCatch({
            envfit(result$ord_object, result$env_data[, cont_vars, drop = FALSE], 
                  choices = 1:2, permutations = 999)
          }, error = function(e) {
            cat("\nERROR fitting environmental vectors:", e$message, "\n")
            NULL
          })
          
          if (!is.null(env_fit) && !is.null(env_fit$vectors)) {
            # Extract arrow coordinates
            arrow_coords <- as.data.frame(scores(env_fit, display = "vectors"))
            arrow_coords$variable <- rownames(arrow_coords)
            
            cat("\nArrow coords columns:", paste(names(arrow_coords), collapse = ", "))
            cat("\nAxis names from scores:", paste(axis_names, collapse = ", "))
            
            # Rename arrow coordinate columns to match axis names from result$scores
            # envfit returns columns matching the original ordination object
            # but we need them to match our standardized axis_names
            if (ncol(arrow_coords) >= 3) {  # At least 2 coord columns + variable column
              names(arrow_coords)[1:2] <- axis_names[1:2]
              cat("\nRenamed arrow coords to:", paste(names(arrow_coords)[1:2], collapse = ", "))
            }
            
            # Get arrow scaling parameter
            arrow_scale_param <- if (!is.null(input$arrowScaling)) input$arrowScaling else 0.8
            
            # Scale arrows to fit plot
            arrow_scale <- arrow_scale_param * min(
              diff(range(result$scores[[axis_names[1]]])),
              diff(range(result$scores[[axis_names[2]]]))
            ) / max(sqrt(rowSums(arrow_coords[,1:2]^2)))
            
            arrow_coords[,1:2] <- arrow_coords[,1:2] * arrow_scale
            
            cat("\nArrows scaled by:", arrow_scale, "\n")
            
            # Add arrows to plot
            plot_obj <- plot_obj +
              geom_segment(data = arrow_coords,
                         aes(x = 0, y = 0, 
                             xend = .data[[axis_names[1]]], 
                             yend = .data[[axis_names[2]]]),
                         arrow = arrow(length = unit(0.4, "cm"), type = "closed"),
                         color = arrow_color, linewidth = 1.5, alpha = 0.9,
                         inherit.aes = FALSE) +
              geom_text(data = arrow_coords,
                       aes(x = .data[[axis_names[1]]] * 1.15, 
                           y = .data[[axis_names[2]]] * 1.15, 
                           label = variable),
                       color = arrow_color, fontface = "bold", size = 4.5,
                       alpha = 0.95, inherit.aes = FALSE)
          }
        }
      }
      
      # Get base font size
      base_font <- if (!is.null(input$baseFontSize)) input$baseFontSize else 12
      
      # Apply theme and labels
      # Add variance/inertia explained to axis labels if available
      x_label <- axis_names[1]
      y_label <- axis_names[2]
      
      # Calculate percentage variance from eigenvalues if available
      # PRIORITY: Use pre-calculated variance percentages FIRST (for CCA/RDA)
      if (!is.null(result$variance) && length(result$variance) >= 2) {
        # Use pre-calculated variance percentages (CCA/RDA constrained, PCA, PCoA)
        x_label <- paste0(axis_names[1], " [", round(result$variance[1], 1), "%]")
        y_label <- paste0(axis_names[2], " [", round(result$variance[2], 1), "%]")
        
        cat("\nAxis percentages from pre-calculated variance:")
        cat("\n", axis_names[1], ":", round(result$variance[1], 1), "%")
        cat("\n", axis_names[2], ":", round(result$variance[2], 1), "%\n")
        
      } else if (!is.null(result$inertia) && length(result$inertia) >= 2) {
        # Use pre-calculated inertia percentages (CA)
        x_label <- paste0(axis_names[1], " [", round(result$inertia[1], 1), "%]")
        y_label <- paste0(axis_names[2], " [", round(result$inertia[2], 1), "%]")
        
      } else if (!is.null(result$eigenvalues) && length(result$eigenvalues) >= 2) {
        # Fallback: Calculate from eigenvalues total
        total_inertia <- sum(result$eigenvalues)
        axis1_pct <- (result$eigenvalues[1] / total_inertia) * 100
        axis2_pct <- (result$eigenvalues[2] / total_inertia) * 100
        
        x_label <- paste0(axis_names[1], " [", round(axis1_pct, 1), "%]")
        y_label <- paste0(axis_names[2], " [", round(axis2_pct, 1), "%]")
        
        cat("\nAxis percentages calculated from eigenvalues:")
        cat("\n", axis_names[1], ":", round(axis1_pct, 1), "%")
        cat("\n", axis_names[2], ":", round(axis2_pct, 1), "%\n")
      }
      
      
      plot_obj <- plot_obj +
        get_plot_theme() +
        theme(panel.background = element_rect(fill = bg_color, color = NA),
              plot.background = element_rect(fill = bg_color, color = NA),
              panel.border = panel_border,
              panel.grid.major = element_line(color = grid_color, linewidth = grid_linewidth),
              panel.grid.minor = element_line(color = grid_color, linewidth = grid_linewidth * 0.5),
              text = element_text(color = text_color, size = base_font, face = "plain"),
              axis.text = element_text(color = text_color, size = base_font - 1, face = "bold"),
              axis.title = element_text(color = text_color, size = base_font + 3, face = "bold"),
              axis.ticks = element_line(color = text_color, linewidth = 0.5),
              axis.ticks.length = unit(0.15, "cm"),
              axis.line = if (plot_theme %in% c("minimal", "publication")) {
                element_line(color = text_color, linewidth = 0.8)
              } else {
                element_blank()
              },
              plot.title = element_text(color = text_color, size = base_font + 5, 
                                       face = "bold", hjust = 0),
              plot.subtitle = element_text(color = text_color, size = base_font + 1, 
                                          face = "italic", hjust = 0),
              plot.caption = element_text(color = text_color, size = base_font - 1, 
                                         hjust = 0, face = "italic"),
              legend.background = element_rect(fill = bg_color, 
                                              color = if (plot_theme == "classic") text_color else NA,
                                              linewidth = if (plot_theme == "classic") 0.5 else 0),
              legend.text = element_text(color = text_color, size = base_font, face = "plain"),
              legend.title = element_text(color = text_color, size = base_font + 1, face = "bold"),
              legend.position = "right",
              legend.key = element_rect(fill = bg_color, color = NA),
              legend.key.size = unit(1.2, "lines"),
              plot.margin = margin(15, 15, 15, 15)) +
        labs(title = paste("Ordination:", result$method),
             subtitle = if(!is.null(result$stress)) paste("Stress:", round(result$stress, 3)) else "",
             x = x_label,
             y = y_label,
             caption = paste(
               if (!is.null(input$showEnvArrows) && input$showEnvArrows && !is.null(result$env_data)) "Orange arrows = Environmental gradients  " else "",
               if (!is.null(input$showEnvEllipses) && input$showEnvEllipses && use_ellipses) "Ellipses = 95% confidence intervals" else "",
               sep = ""
             ))
      
      cat("\nBiplot created successfully!\n")
      plot_obj
      
    }, error = function(e) {
      cat("\nERROR creating biplot:", e$message, "\n")
      # Return a simple error plot
      ggplot() + 
        annotate("text", x = 0.5, y = 0.5, 
                label = paste("Error creating plot:", e$message),
                size = 6, color = "red") +
        theme_void()
    })
  })
  
  output$ordinationPlot <- renderPlot({ 
    req(ordinationPlotReactive())
    ordinationPlotReactive()
  })
  
  output$downloadOrdinationPlot <- downloadHandler(
    filename = function() paste0("ordination_", Sys.Date(), ".", input$ordinationPlotFormat),
    content = function(file) {
      format <- input$ordinationPlotFormat
      plot_dpi <- get_plot_dpi()
      plot_to_save <- ordinationPlotReactive()
      
      if (format == "png") {
        ggsave(file, plot = plot_to_save, device = "png", width = 12, height = 8, dpi = plot_dpi, bg = "#222222")
      } else {
        ggsave(file, plot = plot_to_save, device = "svg", width = 12, height = 8, bg = "#222222")
      }
    }
  )
  
  # Download ordination scores (site/case scores)
  output$downloadOrdinationScores <- downloadHandler(
    filename = function() paste0("ordination_scores_", Sys.Date(), ".csv"),
    content = function(file) {
      req(ordinationResults())
      write.csv(ordinationResults()$scores, file, row.names = FALSE)
    }
  )
  
  # Download eigenvalues
  output$downloadOrdinationEigen <- downloadHandler(
    filename = function() paste0("ordination_eigenvalues_", Sys.Date(), ".csv"),
    content = function(file) {
      req(ordinationResults())
      result <- ordinationResults()
      
      # Create eigenvalue data frame
      if (!is.null(result$eigenvalues)) {
        eigen_df <- data.frame(
          Axis = paste0("Axis", 1:length(result$eigenvalues)),
          Eigenvalue = result$eigenvalues,
          Variance_Percent = if (!is.null(result$variance)) {
            result$variance
          } else if (!is.null(result$inertia)) {
            result$inertia
          } else {
            NA
          }
        )
      } else {
        # If no eigenvalues, create basic info
        eigen_df <- data.frame(
          Note = "Eigenvalues not available for this ordination method",
          Method = result$method
        )
      }
      
      write.csv(eigen_df, file, row.names = FALSE)
    }
  )
  
  # MODULE 3: Diversity Indices with enhanced UX
  indicesResults <- reactiveVal(NULL)
  
  observeEvent(input$runIndices, {
    cat("\n=== RUN INDICES BUTTON CLICKED ===")
    req(data())
    cat("\nData available for analysis")
    
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
        spin_loaders(42, color = "#ff8c00"),  # Professional orange spinner for indices
        h3("Calculating Diversity Indices", style = "color: #ff8c00; margin-top: 30px; font-weight: 700;"),
        p("Computing alpha diversity and evenness metrics", 
          style = "color: #999; font-size: 1rem; margin-top: 10px;"),
        tags$div(
          style = "margin-top: 20px; padding: 15px; background: rgba(255, 140, 0, 0.1); border-radius: 8px; border-left: 4px solid #ff8c00;",
          tags$p(style = "color: #aaa; font-size: 0.9rem; margin: 0;",
            icon("calculator"), " Processing community metrics with vegan package")
        )
      ),
      color = "rgba(20, 20, 20, 0.95)"
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
