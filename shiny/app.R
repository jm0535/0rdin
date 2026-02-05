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
library(ape) # For phylogenetic trees
library(picante) # For phylogenetic beta diversity examples

# Source configuration and utilities
source("config/constants.R")
source("config/defaults.R")
source("R/error_handler.R")
source("R/performance.R")

# Source all modules
source("services/DataService.R")

# Source all modules
source("modules/import_module.R")
source("modules/ordination_module.R")
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
source("modules/beta_partition_module.R")

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
    # Accessibility: Set language
    tags$script("document.documentElement.lang = 'en';"),

    useShinyjs(),
    useShinyFeedback(),
    use_waiter(),

    # Load JavaScript files (with cache-busting version)
    tags$script(src = "disable-selectize.js?v=1"),
    tags$script(src = "performance-monitor.js?v=1"),
    tags$script(src = "help-loader.js?v=1"),
    tags$script(src = "validation.js?v=3"),
    tags$script(src = "statistical-interpretation.js?v=3"),
    tags$script(src = "about-ordin-content.js?v=3"),
    tags$script(src = "help-content.js?v=3"),
    tags$script(src = "shiny-ui.js?v=12"),
    tags$script(src = "dashboard-cards.js?v=1"),
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
    div(
      class = "titlebar",
      div(
        class = "titlebar-left",
        span(class = "app-icon", "Ö"),
        span(class = "app-title", "Ördin v3.0")
      ),
      div(
        class = "titlebar-center",
        span(
          class = "status-badge",
          tags$i(class = "fas fa-circle", style = "font-size: 8px; margin-right: 6px;"),
          "Ready"
        )
      ),
      div(
        class = "titlebar-right",
        span(
          class = "user-info",
          tags$i(class = "fas fa-user", style = "margin-right: 6px;"),
          Sys.info()["user"]
        ),
        tags$button(
          class = "window-btn", onclick = "location.reload()", title = "Reload",
          tags$i(class = "fas fa-sync-alt")
        ),
        tags$button(class = "window-btn", onclick = "if(window.electronAPI) window.electronAPI.minimizeWindow()", title = "Minimize", "—"),
        tags$button(class = "window-btn", onclick = "if(window.electronAPI) window.electronAPI.maximizeWindow()", title = "Maximize", "□"),
        tags$button(class = "window-btn close", onclick = "if(window.electronAPI) window.electronAPI.closeWindow()", title = "Close", "×")
      )
    ),

    # ============== MAIN CONTAINER ==============
    div(
      class = "main-container",

      # ACTIVITY BAR
      div(
        class = "activity-bar",
        div(
          class = "activity-item active", onclick = "switchView('home')", title = "Home",
          tags$i(class = "fas fa-home")
        ),
        div(
          class = "activity-item", onclick = "switchView('data')", title = "Data",
          tags$i(class = "fas fa-database")
        ),
        div(
          class = "activity-item", onclick = "switchView('diversity')", title = "Diversity",
          tags$i(class = "fas fa-chart-line")
        ),
        div(
          class = "activity-item", onclick = "switchView('ordination')", title = "Ordination",
          tags$i(class = "fas fa-project-diagram")
        ),
        div(
          class = "activity-item", onclick = "switchView('tests')", title = "Statistical Tests",
          tags$i(class = "fas fa-flask")
        ),
        div(
          class = "activity-item", onclick = "switchView('beta')", title = "Beta Partitioning",
          tags$i(class = "fas fa-dna")
        ),
        div(class = "spacer"),
        div(
          class = "activity-item", onclick = "switchView('settings')", title = "Settings",
          tags$i(class = "fas fa-cog")
        ),
        div(
          class = "activity-item", onclick = "switchView('help')", title = "Help",
          tags$i(class = "fas fa-question-circle")
        )
      ),

      # PRIMARY SIDEBAR (starts expanded for easier access)
      div(
        class = "primary-sidebar", id = "sidebar",
        div(
          class = "sidebar-header",
          span(class = "sidebar-title", "EXPLORER"),
          tags$button(onclick = "toggleSidebar()", "◀")
        ),
        div(
          class = "sidebar-content", id = "sidebar-content",
          # Default HOME content
          div(
            class = "section",
            div(class = "section-header", "▼ DATA SOURCES"),
            div(
              class = "section-content",
              div(class = "item", onclick = "switchView('data')", style = "cursor: pointer;", "📄 Current Dataset"),
              div(class = "item", onclick = "switchView('data')", style = "cursor: pointer;", "📥 Import New File"),
              div(class = "item", onclick = "switchView('data')", style = "cursor: pointer;", "📚 Sample Datasets")
            )
          ),
          div(
            class = "section",
            div(class = "section-header", "▼ WORKSPACE"),
            div(
              class = "section-content",
              div(class = "item", onclick = "switchView('data')", style = "cursor: pointer;", "📊 Current Dataset ", span(class = "badge", "45×12")),
              div(class = "item", onclick = "alert('Metadata view coming soon!')", style = "cursor: pointer;", "ℹ️ Metadata"),
              div(class = "item", onclick = "alert('Validation tools coming soon!')", style = "cursor: pointer;", "✅ Validation ", span(class = "badge success", "OK"))
            )
          ),
          div(
            class = "section",
            div(class = "section-header", "▼ RECENT"),
            div(
              class = "section-content",
              div(class = "item", onclick = "switchView('diversity')", style = "cursor: pointer;", "📈 iNEXT analysis ", span(class = "badge", "2m"))
            )
          )
        )
      ),

      # MAIN CANVAS
      div(
        class = "main-canvas",

        # Breadcrumb
        div(class = "breadcrumb", "Home → Dashboard"),

        # Tab Bar
        div(
          class = "tab-bar", id = "tabBar",
          div(
            class = "tab active", `data-tab-id` = "dashboard", onclick = "switchToTab('dashboard')",
            "🏠 Dashboard ",
            span(class = "tab-close", onclick = "closeTab(event, 'dashboard')", "×")
          )
        ),

        # Content Area
        div(
          class = "content-area", id = "contentArea",

          # Dashboard Tab Content
          source("ui/dashboard_ui.R", local = TRUE)$value,
          # Data Management Tab
          source("ui/data_ui.R", local = TRUE)$value,
          # Diversity Analysis Tab
          source("ui/diversity_ui.R", local = TRUE)$value,
          # Ordination Analysis Tab
          source("ui/ordination_ui.R", local = TRUE)$value,
          # Statistical Tests Tab
          source("ui/tests_ui.R", local = TRUE)$value,
          # Beta Diversity Partitioning Tab
          source("ui/beta_ui.R", local = TRUE)$value,
          # Analysis Results Tab
          source("ui/results_ui.R", local = TRUE)$value,
          # Settings Tab
          source("ui/settings_ui.R", local = TRUE)$value,
          # Help Tab
          source("ui/help_ui.R", local = TRUE)$value
        ),

        # STATUS BAR
        div(
          class = "status-bar",
          div(
            style = "display: flex; align-items: center; gap: 16px; width: 100%; overflow: hidden;",
            span(
              style = "display: inline-flex; align-items: center; gap: 4px; flex-shrink: 0;",
              span(style = "color: #2e8b57;", "●"),
              span("Ready")
            ),
            span(style = "flex-shrink: 0;", "|"),
            div(style = "flex-shrink: 0;", uiOutput("status_bar_data", inline = TRUE)),
            span(style = "flex-shrink: 0;", "|"),
            span(style = "flex-shrink: 0;", paste0("R ", R.version$major, ".", R.version$minor, ".", R.version$patch)),
            span(style = "flex-shrink: 0;", "|"),
            span(style = "flex-shrink: 0;", "Ördin v3.0"),
            span(style = "flex-shrink: 0;", "|"),
            div(style = "flex-shrink: 0;", uiOutput("status_bar_memory", inline = TRUE)),
            span(style = "flex-shrink: 0;", "|"),
            span(style = "flex-shrink: 0;", paste0("© 2025 ", Sys.info()["user"]))
          )
        )
      ),

      # RIGHT PANEL (Properties - starts collapsed)
      div(
        class = "right-panel collapsed", id = "rightPanel",
        div(
          class = "panel-header",
          span("PROPERTIES"),
          tags$button(onclick = "toggleRightPanel()", "▶")
        ),
        div(
          class = "panel-content",
          # Dataset Info (reactive)
          uiOutput("right_panel_dataset_info"),

          # Quick Actions
          div(
            class = "prop-section",
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
  # ============== SERVICES ==============
  # Initialize DataService (R6)
  data_service <- DataService$new()

  # Reactive bindings for backward compatibility with modules
  # Modules expect reactive expressions, so we pass the service's reactive fields
  species_data <- data_service$species_data
  env_data <- data_service$env_data
  phylo_tree <- data_service$phylo_tree
  trait_data <- data_service$trait_data



  # ============== MODULE SERVERS (WITH DATA) ==============
  # Call module servers and pass reactive data
  # NOTE: NMDS, CCA, RDA, db-RDA, and CAP modules accept env_data parameter for constrained ordination

  # Data Import logic
  import_server("import", data_service)

  # Diversity modules
  diversity_estimation_server("diversity_est", data = species_data)
  diversity_indices_server("diversity_idx", data = species_data)

  # Ordination modules
  nmds_server("nmds", data = species_data, env_data = env_data) # NMDS supports environmental data
  pca_server("pca", data = species_data) # PCA does not use env_data
  ca_server("ca", data = species_data) # CA does not use env_data
  dca_server("dca", data = species_data) # DCA does not use env_data
  pcoa_server("pcoa", data = species_data) # PCoA does not use env_data
  cca_server("cca", data = species_data, env_data = env_data) # CCA is constrained ordination
  rda_server("rda", data = species_data, env_data = env_data) # RDA is constrained ordination
  dbrda_server("dbrda", data = species_data, env_data = env_data) # db-RDA is constrained ordination
  cap_server("cap", data = species_data, env_data = env_data) # CAP is constrained ordination

  # Statistical test modules
  permanova_server("permanova", data = species_data, env_data = env_data)
  anosim_server("anosim", data = species_data, env_data = env_data)
  mantel_envfit_server("mantel_envfit", data = species_data, env_data = env_data)

  # Beta diversity partitioning module
  beta_partition_server("beta_partition",
    data = species_data, env_data = env_data,
    traits = trait_data, tree = phylo_tree
  )

  # ============== INITIALIZE DATA PREVIEW ==============
  # Initialize empty data table - REACTIVE to species_data changes
  # CRITICAL: Must use renderDT from DT package, not renderDataTable

  # Data info badge
  output$data_info_badge <- renderUI({
    species_count <- if (!is.null(species_data())) paste0(nrow(species_data()), " sites × ", ncol(species_data()), " species") else ""
    env_count <- if (!is.null(env_data())) paste0(ncol(env_data()), " variables") else ""

    if (!is.null(species_data()) || !is.null(env_data())) {
      div(
        style = "display: flex; gap: 12px;",
        if (!is.null(species_data())) {
          div(
            style = "background: #2e8b5720; border: 1px solid #2e8b57; border-radius: 4px; padding: 8px 16px; display: flex; align-items: center; gap: 8px;",
            span(style = "color: #2e8b57; font-size: 14px; font-weight: 600;", "✓"),
            span(style = "color: #2e8b57; font-size: 13px; font-weight: 600;", species_count)
          )
        },
        if (!is.null(env_data())) {
          div(
            style = "background: #4a90e220; border: 1px solid #4a90e2; border-radius: 4px; padding: 8px 16px; display: flex; align-items: center; gap: 8px;",
            span(style = "color: #4a90e2; font-size: 14px; font-weight: 600;", "✓"),
            span(style = "color: #4a90e2; font-size: 13px; font-weight: 600;", env_count)
          )
        }
      )
    }
  })

  # Status bar data info
  output$status_bar_data <- renderUI({
    if (!is.null(species_data())) {
      data_info <- paste0(nrow(species_data()), " sites × ", ncol(species_data()), " species")
      if (!is.null(env_data())) {
        data_info <- paste0(data_info, " + ", ncol(env_data()), " env")
      }
      span(style = "color: #2e8b57;", data_info)
    } else {
      span(style = "color: #666;", "No data")
    }
  })

  # Status bar memory info
  output$status_bar_memory <- renderUI({
    mem_info <- gc()
    mem_mb <- round(sum(mem_info[, 2]) / 1024, 1)
    span(style = "color: #888;", paste0("Mem: ", mem_mb, " MB"))
  })

  # Environmental data preview section (conditional)
  output$env_preview_section <- renderUI({
    if (!is.null(env_data())) {
      div(
        style = "margin-bottom: 30px;",
        h4(style = "color: #4a90e2; font-size: 14px; margin-bottom: 12px; font-weight: 600;", "🌍 Environmental Data"),
        div(
          style = "width: 100%; overflow-x: auto; overflow-y: auto; max-height: 400px; border: 1px solid #3e3e42;",
          DT::DTOutput("env_preview")
        )
      )
    }
  })

  output$phylo_preview_section <- renderUI({
    if (!is.null(phylo_tree())) {
      tree <- phylo_tree()
      div(
        style = "margin-bottom: 30px;",
        h4(style = "color: #9b59b6; font-size: 14px; margin-bottom: 12px; font-weight: 600;", "🌳 Phylogenetic Tree"),
        div(
          style = "background: #252526; padding: 16px; border: 1px solid #3e3e42; border-radius: 4px;",
          div(
            class = "prop-item",
            tags$label("Tree Type:"),
            span(style = "color: #9b59b6;", class(tree)[1])
          ),
          div(
            class = "prop-item",
            tags$label("Number of Tips:"),
            span(style = "color: #9b59b6; font-weight: 600;", length(tree$tip.label))
          ),
          div(
            class = "prop-item",
            tags$label("Number of Nodes:"),
            span(style = "color: #9b59b6;", tree$Nnode)
          ),
          div(
            class = "prop-item",
            tags$label("Species:"),
            span(style = "color: #aaa; font-size: 11px;", paste(tree$tip.label[1:min(5, length(tree$tip.label))], collapse = ", "), "...")
          ),
          div(
            style = "margin-top: 12px; padding: 8px; background: #1a3a2e; border-left: 3px solid #9b59b6; border-radius: 0 4px 4px 0;",
            div(style = "color: #9b59b6; font-size: 11px; font-weight: 600; margin-bottom: 4px;", "✅ TREE LOADED"),
            div(style = "color: #aaa; font-size: 10px;", "Ready for phylogenetic beta diversity analysis")
          )
        )
      )
    }
  })

  output$trait_preview_section <- renderUI({
    if (!is.null(trait_data())) {
      div(
        style = "margin-bottom: 30px;",
        h4(style = "color: #e74c3c; font-size: 14px; margin-bottom: 12px; font-weight: 600;", "🧬 Functional Trait Data"),
        div(
          style = "width: 100%; overflow-x: auto; overflow-y: auto; max-height: 400px; border: 1px solid #3e3e42;",
          DT::DTOutput("trait_preview")
        )
      )
    }
  })

  # Right Panel - Dataset Info (reactive to loaded data)
  output$right_panel_dataset_info <- renderUI({
    if (is.null(species_data())) {
      # No data loaded
      div(
        class = "prop-section",
        h4("Dataset Info"),
        div(
          style = "color: #888; font-size: 12px; padding: 12px; text-align: center;",
          "⚠️ No dataset loaded"
        )
      )
    } else {
      # Show actual data info
      div(
        class = "prop-section",
        h4("Dataset Info"),
        div(
          class = "prop-item",
          tags$label("Rows (Sites):"),
          span(style = "color: #2e8b57; font-weight: 600;", nrow(species_data()))
        ),
        div(
          class = "prop-item",
          tags$label("Columns (Species):"),
          span(style = "color: #2e8b57; font-weight: 600;", ncol(species_data()))
        ),
        div(
          class = "prop-item",
          tags$label("Type:"),
          span(style = "color: #cccccc;", "Abundance")
        ),
        if (!is.null(env_data())) {
          div(
            class = "prop-item",
            tags$label("Env Variables:"),
            span(style = "color: #4a90e2; font-weight: 600;", ncol(env_data()))
          )
        }
      )
    }
  })

  output$species_preview <- DT::renderDT({
    if (is.null(species_data())) {
      # Show empty placeholder
      DT::datatable(
        data.frame(
          Status = "⚠️ No Data Loaded",
          Instructions = "Upload a CSV/Excel file or load a sample dataset to get started"
        ),
        options = list(
          pageLength = 5,
          scrollX = FALSE,
          dom = "t",
          ordering = FALSE,
          searching = FALSE,
          columnDefs = list(
            list(width = "30%", targets = 0),
            list(width = "70%", targets = 1)
          )
        ),
        rownames = FALSE,
        style = "bootstrap4",
        class = "cell-border"
      )
    } else {
      # Show actual data
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
          dom = "frtip",
          columnDefs = list(
            list(width = "70px", targets = "_all")
          )
        ),
        style = "bootstrap4",
        class = "cell-border stripe hover compact",
        rownames = TRUE
      )
    }
  })

  # Environmental data preview table
  output$env_preview <- DT::renderDT({
    if (!is.null(env_data())) {
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
          dom = "frtip",
          columnDefs = list(
            list(width = "100px", targets = "_all")
          )
        ),
        style = "bootstrap4",
        class = "cell-border stripe hover compact",
        rownames = TRUE
      )
    }
  })

  # Trait data preview table
  output$trait_preview <- DT::renderDT({
    if (!is.null(trait_data())) {
      DT::datatable(
        trait_data(),
        options = list(
          pageLength = 10,
          scrollX = FALSE,
          scrollY = FALSE,
          paging = TRUE,
          searching = TRUE,
          info = TRUE,
          autoWidth = TRUE,
          dom = "frtip",
          columnDefs = list(
            list(width = "120px", targets = "_all")
          )
        ),
        style = "bootstrap4",
        class = "cell-border stripe hover compact",
        rownames = TRUE
      )
    }
  })

  # ============== SAMPLE DATA LOADING ==============
  # ============== SAMPLE DATA LOADING ==============
  # Handled by import_module via DataService


  # ============== FILE UPLOAD HANDLING ==============
  # ============== SETTINGS HANDLERS ==============

  # Apply Appearance Settings button
  observeEvent(input$settings_save_appearance, {
    session$sendCustomMessage("applyFont", input$settings_font)
    session$sendCustomMessage("setZoom", input$settings_zoom / 100)
    showNotification("✅ Appearance settings applied!", type = "message", duration = 2)
  })

  # UI Zoom slider
  observeEvent(input$settings_zoom, {
    session$sendCustomMessage("setZoom", input$settings_zoom / 100)
  })

  # Save Settings Button
  observeEvent(input$settings_save, {
    # Save to browser localStorage via JavaScript
    settings <- list(
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
      duration = NULL # User must dismiss
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

    loaded_data <- tryCatch(
      {
        if (ext == "csv") {
          read_csv(input$species_file$datapath, show_col_types = FALSE)
        } else if (ext %in% c("xlsx", "xls")) {
          read_excel(input$species_file$datapath)
        }
      },
      error = function(e) {
        showNotification(paste("❌ Error loading file:", e$message), type = "error", duration = 5)
        NULL
      }
    )

    if (!is.null(loaded_data)) {
      # Store as data frame
      species_data(as.data.frame(loaded_data)) # Store reactively

      showNotification(
        paste0(
          "✅ ", input$species_file$name, " loaded successfully! (",
          nrow(loaded_data), " rows, ", ncol(loaded_data), " columns)"
        ),
        type = "message",
        duration = 3
      )
    }
  })

  # Environmental data file upload
  observeEvent(input$env_file, {
    req(input$env_file)

    ext <- tools::file_ext(input$env_file$name)

    loaded_env <- tryCatch(
      {
        if (ext == "csv") {
          read_csv(input$env_file$datapath, show_col_types = FALSE)
        } else if (ext %in% c("xlsx", "xls")) {
          read_excel(input$env_file$datapath)
        }
      },
      error = function(e) {
        showNotification(paste("❌ Error loading environmental data:", e$message), type = "error")
        NULL
      }
    )

    if (!is.null(loaded_env)) {
      # Store as data frame
      env_data(as.data.frame(loaded_env)) # Store reactively

      showNotification(
        paste0(
          "✅ Environmental data loaded! (",
          nrow(loaded_env), " rows, ", ncol(loaded_env), " variables)"
        ),
        type = "message"
      )
    }
  })
}

# Run app
shinyApp(ui, server)
