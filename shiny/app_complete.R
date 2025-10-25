# Ördin v3.0 - Complete Production App
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Mirrors approved prototype with all ordination modules

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
# Ordination modules
source("modules/ordination_nmds_module.R")
source("modules/ordination_pca_module.R")
source("modules/ordination_ca_module.R")
source("modules/ordination_dca_module.R")
source("modules/ordination_pcoa_module.R")

# Diversity modules
source("modules/diversity_estimation_module.R")
source("modules/diversity_indices_module.R")

# UI
ui <- page_fluid(
  theme = bs_theme(
    version = 5,
    bg = "#1e1e1e",
    fg = "#cccccc",
    primary = "#2e8b57",
    base_font = font_google("Roboto")
  ),
  
  useShinyjs(),
  use_waiter(),
  useShinyFeedback(),
  
  # Include CSS
  tags$head(
    tags$link(rel = "stylesheet", href = "custom.css"),
    tags$link(rel = "stylesheet", href = "styles.css")
  ),
  
  # Include JS
  tags$script(src = "app.js"),
  tags$script(src = "validation.js"),
  tags$script(src = "statistical-interpretation.js"),
  tags$script(src = "about-ordin-content.js"),
  
  # Loading screen
  waiter_show_on_load(
    html = tagList(
      spin_loaders(42, color = "#2e8b57"),
      h2("Ördin v3.0", style = "color: #2e8b57; margin-top: 30px; font-weight: 800;"),
      p("Community Ecology Analysis Platform", style = "color: #999;")
    ),
    color = "#1a1a1a"
  ),
  
  # Main layout with VS Code structure
  div(class = "app-container",
    
    # Title bar
    div(class = "titlebar",
      div(class = "titlebar-left",
        span(class = "app-icon", "Ö"),
        span(class = "app-title", "Ördin"),
        span(class = "divider", "|"),
        uiOutput("dataset_name_display")
      ),
      div(class = "titlebar-center",
        span(class = "status-badge", "● Ready")
      ),
      div(class = "titlebar-right",
        span(class = "user-info", "👤 Jimmy Moses")
      )
    ),
    
    # Main container with activity bar + sidebar + content
    div(class = "main-container",
      
      # Activity Bar (VS Code style)
      div(class = "activity-bar",
        div(class = "activity-item", 
            id = "activity-home",
            title = "Home",
            onclick = "Shiny.setInputValue('activity_click', 'home', {priority: 'event'})",
            "🏠"),
        div(class = "activity-item",
            id = "activity-data", 
            title = "Data",
            onclick = "Shiny.setInputValue('activity_click', 'data', {priority: 'event'})",
            "📋"),
        div(class = "activity-item",
            id = "activity-diversity",
            title = "Diversity",
            onclick = "Shiny.setInputValue('activity_click', 'diversity', {priority: 'event'})",
            "📈"),
        div(class = "activity-item",
            id = "activity-ordination",
            title = "Ordination",
            onclick = "Shiny.setInputValue('activity_click', 'ordination', {priority: 'event'})",
            "🔵"),
        div(class = "spacer"),
        div(class = "activity-item",
            id = "activity-about",
            title = "About",
            onclick = "Shiny.setInputValue('activity_click', 'about', {priority: 'event'})",
            "❓")
      ),
      
      # Primary Sidebar (collapsible)
      div(class = "primary-sidebar collapsed", id = "sidebar",
        div(class = "sidebar-header",
          span(class = "sidebar-title", "EXPLORER"),
          tags$button(onclick = "$('#sidebar').toggleClass('collapsed')", "◀")
        ),
        div(class = "sidebar-content",
          uiOutput("sidebar_content")
        )
      ),
      
      # Main canvas
      div(class = "main-canvas",
      
      # Home Tab
      tabPanel("Home",
        value = "home",
        div(class = "home-page",
          div(style = "max-width: 1200px; margin: 0 auto; padding: 60px 20px;",
            
            # Welcome
            div(style = "text-align: center; margin-bottom: 50px;",
              h1(style = "color: #2e8b57; font-size: 48px; margin: 0;", "Ördin"),
              h2(style = "color: #ccc; font-size: 24px; margin: 10px 0;", 
                 "Community Ecology Analysis Platform"),
              p(style = "color: #888; font-size: 16px;",
                "Open-source, cross-platform, publication-quality biodiversity analysis")
            ),
            
            # What Makes Ördin Special
            div(style = "background: #252526; border-left: 4px solid #2e8b57; padding: 30px; margin: 40px 0;",
              h2(style = "color: #2e8b57; margin-top: 0;", "⚡ What Makes Ördin Special?"),
              tags$ul(style = "color: #ccc; font-size: 15px; line-height: 1.8;",
                tags$li(strong("Open Source & Free"), " - No subscriptions, no paywalls"),
                tags$li(strong("Desktop-First"), " - Works offline, your data stays local"),
                tags$li(strong("Publication-Quality"), " - Export-ready figures and reports"),
                tags$li(strong("Intelligent Interpretation"), " - Automatic statistical guidance"),
                tags$li(strong("Reproducible"), " - Complete methodology documentation"),
                tags$li(strong("Accessible"), " - WCAG AA compliant, keyboard navigation")
              )
            ),
            
            # Action cards
            div(style = "display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin: 40px 0;",
              div(class = "action-card",
                style = "background: #252526; border: 1px solid #3e3e42; padding: 30px; text-align: center; cursor: pointer;",
                onclick = "Shiny.setInputValue('goto_tab', 'data', {priority: 'event'})",
                div(style = "font-size: 48px; margin-bottom: 20px;", "📊"),
                h3(style = "color: #2e8b57; margin: 0 0 10px 0;", "Import Data"),
                p(style = "color: #888; font-size: 13px;", "Load your ecology data"),
                div(style = "color: #2e8b57; margin-top: 20px;", "Start →")
              ),
              div(class = "action-card",
                style = "background: #252526; border: 1px solid #3e3e42; padding: 30px; text-align: center; cursor: pointer;",
                onclick = "Shiny.setInputValue('goto_tab', 'ordination', {priority: 'event'})",
                div(style = "font-size: 48px; margin-bottom: 20px;", "🗺️"),
                h3(style = "color: #2e8b57; margin: 0 0 10px 0;", "Ordination"),
                p(style = "color: #888; font-size: 13px;", "NMDS, PCA, CA, DCA, PCoA"),
                div(style = "color: #2e8b57; margin-top: 20px;", "Analyze →")
              ),
              div(class = "action-card",
                style = "background: #252526; border: 1px solid #3e3e42; padding: 30px; text-align: center; cursor: pointer;",
                onclick = "Shiny.setInputValue('goto_tab', 'about', {priority: 'event'})",
                div(style = "font-size: 48px; margin-bottom: 20px;", "📖"),
                h3(style = "color: #2e8b57; margin: 0 0 10px 0;", "About"),
                p(style = "color: #888; font-size: 13px;", "Learn about Ördin"),
                div(style = "color: #2e8b57; margin-top: 20px;", "Read →")
              )
            )
          )
        )
      ),
      
      # Data Tab
      tabPanel("Data",
        value = "data",
        div(class = "data-page",
          h2("📊 Data Management", style = "color: #2e8b57;"),
          
          # Educational tip box
          div(style = "background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin: 20px 0;",
            p(style = "color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;", "ℹ️ TIP: Data Structure Requirements"),
            HTML('<p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
              <strong>Species Composition Data:</strong><br>
              • First column: Site names (sites/traps/transects/plots)<br>
              • Remaining columns: Species abundance/presence data<br>
              • Example: Site | Species1 | Species2 | Species3<br><br>
              <strong>Environmental Data (Optional):</strong><br>
              • First column: Site names (matching species data)<br>
              • Remaining columns: Environmental variables (pH, temp, elevation, etc.)<br>
              • Example: Site | pH | Temperature | Moisture<br>
              • Used for constrained ordination (RDA, CCA) and environmental fitting
            </p>')
          ),
          
          # Species composition data
          div(style = "background: #252526; padding: 20px; margin: 20px 0;",
            h3("1️⃣ Species Composition Data", style = "color: #2e8b57;"),
            
            # Upload species data
            div(style = "margin-bottom: 20px;",
              fileInput("species_file", "Upload Species Data (CSV or Excel):",
                       accept = c(".csv", ".xlsx", ".xls")),
              tags$small(style = "color: #888;", 
                        "First column = Site names | Other columns = Species abundance")
            ),
            
            # Or load sample data
            div(style = "border-top: 1px solid #3e3e42; padding-top: 20px;",
              h4("Or Load Sample Dataset", style = "color: #ccc;"),
              selectInput("sample_dataset", "Choose sample:",
                         choices = c(
                           "None" = "", 
                           "Dune Meadow (20 sites × 30 species)" = "dune",
                           "Varespec (24 sites × 44 species)" = "varespec",
                           "BCI (50 sites × 225 species)" = "BCI"
                         )),
              actionButton("load_sample", "▶ Load Sample Data", class = "btn-success")
            )
          ),
          
          # Environmental data
          div(style = "background: #252526; padding: 20px; margin: 20px 0;",
            h3("2️⃣ Environmental Data (Optional)", style = "color: #2e8b57;"),
            
            fileInput("env_file", "Upload Environmental Data (CSV or Excel):",
                     accept = c(".csv", ".xlsx", ".xls")),
            tags$small(style = "color: #888;", 
                      "First column = Site names (must match species data) | Other columns = Environmental variables"),
            
            # Environmental data preview
            conditionalPanel(
              condition = "output.env_data_loaded",
              div(style = "margin-top: 15px; padding: 10px; background: #1a3a2e; border-left: 3px solid #2e8b57;",
                uiOutput("env_data_status")
              )
            )
          ),
          
          # Data Transformations
          div(style = "background: #252526; padding: 20px; margin: 20px 0;",
            h3("3️⃣ Data Transformations (Optional)", style = "color: #2e8b57;"),
            
            # Tip box
            div(style = "background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;",
              p(style = "color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;", "ℹ️ TIP: When to Transform Data"),
              HTML('<p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                <strong>Hellinger:</strong> Recommended for abundance data before PCA/RDA. Reduces weight of rare species.<br>
                <strong>Wisconsin:</strong> Double standardization by species maxima and site totals. Good for vegetation data.<br>
                <strong>Log (log1p):</strong> Reduces influence of highly abundant species. Use for skewed distributions.<br>
                <strong>Square Root:</strong> Mild transformation. Balances common and rare species.
              </p>')
            ),
            
            checkboxGroupInput("transformations", "Select transformations to apply:",
              choices = c(
                "Hellinger transformation" = "hellinger",
                "Wisconsin double standardization" = "wisconsin",
                "Log transformation (log1p)" = "log",
                "Square root transformation" = "sqrt"
              )
            ),
            
            tags$small(style = "color: #888;", 
                      "Transformations will be applied to species composition data before analyses"),
            
            br(), br(),
            
            actionButton("apply_transform", "▶ Apply Transformations", class = "btn-success"),
            actionButton("reset_data", "🔄 Reset to Original Data", class = "btn-secondary", style = "margin-left: 10px;"),
            
            # Transformation status
            conditionalPanel(
              condition = "output.transform_applied",
              div(style = "margin-top: 15px; padding: 10px; background: #1a3a2e; border-left: 3px solid #2e8b57;",
                uiOutput("transform_status")
              )
            )
          ),
          
          # Data preview tabs
          div(style = "margin-top: 30px;",
            h3("🔍 Data Preview", style = "color: #2e8b57;"),
            
            tabsetPanel(
              id = "data_preview_tabs",
              tabPanel("Species Composition",
                DT::dataTableOutput("species_preview")
              ),
              tabPanel("Environmental Variables",
                DT::dataTableOutput("env_preview")
              ),
              tabPanel("Data Summary",
                div(style = "padding: 20px;",
                  uiOutput("data_summary")
                )
              )
            )
          )
        )
      ),
      
      # Diversity Tab
      tabPanel("Diversity",
        value = "diversity",
        div(class = "diversity-page",
          h2("🔬 Diversity Analysis", style = "color: #2e8b57;"),
          
          # Method selector
          div(style = "background: #252526; padding: 20px; margin: 20px 0;",
            selectInput("diversity_method", "Select Method:",
                       choices = c(
                         "Diversity Estimation (iNEXT)" = "estimation",
                         "Diversity Indices (Shannon, Simpson, etc.)" = "indices"
                       ),
                       selected = "estimation")
          ),
          
          # Module UIs (conditional)
          conditionalPanel(
            condition = "input.diversity_method == 'estimation'",
            diversity_estimation_ui("diversity_est")
          ),
          conditionalPanel(
            condition = "input.diversity_method == 'indices'",
            diversity_indices_ui("diversity_idx")
          )
        )
      ),
      
      # Ordination Tab
      tabPanel("Ordination",
        value = "ordination",
        div(class = "ordination-page",
          h2("🗺️ Ordination Analysis", style = "color: #2e8b57;"),
          
          # Method selector
          div(style = "background: #252526; padding: 20px; margin: 20px 0;",
            selectInput("ordination_method", "Select Method:",
                       choices = c(
                         "NMDS (Non-metric MDS)" = "nmds",
                         "PCA (Principal Components)" = "pca",
                         "CA (Correspondence Analysis)" = "ca",
                         "DCA (Detrended CA)" = "dca",
                         "PCoA (Principal Coordinates)" = "pcoa"
                       ),
                       selected = "nmds")
          ),
          
          # Module UIs (conditional)
          conditionalPanel(
            condition = "input.ordination_method == 'nmds'",
            nmds_ui("nmds")
          ),
          conditionalPanel(
            condition = "input.ordination_method == 'pca'",
            pca_ui("pca")
          ),
          conditionalPanel(
            condition = "input.ordination_method == 'ca'",
            ca_ui("ca")
          ),
          conditionalPanel(
            condition = "input.ordination_method == 'dca'",
            dca_ui("dca")
          ),
          conditionalPanel(
            condition = "input.ordination_method == 'pcoa'",
            pcoa_ui("pcoa")
          )
        )
      ),
      
      # About Tab
      tabPanel("About",
        value = "about",
        div(class = "about-page",
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
  )

# Server
server <- function(input, output, session) {
  
  # Hide loading screen
  Sys.sleep(1)
  waiter_hide()
  
  # Reactive data storage
  community_data <- reactiveVal(NULL)  # Species composition
  environmental_data <- reactiveVal(NULL)  # Environmental variables
  original_data <- reactiveVal(NULL)  # Original data backup
  applied_transformations <- reactiveVal(NULL)  # Track transformations
  
  # Handle tab navigation from action cards
  observeEvent(input$goto_tab, {
    updateNavbarPage(session, "main_tabs", selected = input$goto_tab)
  })
  
  # Load sample data
  observeEvent(input$load_sample, {
    req(input$sample_dataset)
    
    tryCatch({
      data(list = input$sample_dataset, package = "vegan")
      dataset <- get(input$sample_dataset)
      community_data(dataset)
      original_data(dataset)  # Store original
      applied_transformations(NULL)  # Clear transformations
      
      # Load corresponding environmental data if available
      if (input$sample_dataset == "dune") {
        data("dune.env", package = "vegan")
        environmental_data(dune.env)
        showNotification(
          HTML(sprintf("✓ <strong>Loaded %s:</strong><br>
                       Species: %d sites × %d species<br>
                       Environment: %d variables", 
                input$sample_dataset, nrow(dataset), ncol(dataset), ncol(dune.env))),
          type = "message",
          duration = 5
        )
      } else if (input$sample_dataset == "varespec") {
        data("varechem", package = "vegan")
        environmental_data(varechem)
        showNotification(
          HTML(sprintf("✓ <strong>Loaded %s:</strong><br>
                       Species: %d sites × %d species<br>
                       Environment: %d variables", 
                input$sample_dataset, nrow(dataset), ncol(dataset), ncol(varechem))),
          type = "message",
          duration = 5
        )
      } else {
        environmental_data(NULL)
        showNotification(
          sprintf("✓ Loaded %s: %d sites × %d species", 
                  input$sample_dataset, nrow(dataset), ncol(dataset)),
          type = "message",
          duration = 5
        )
      }
    }, error = function(e) {
      showNotification(paste("❌ Error:", e$message), type = "error")
    })
  })
  
  # Upload species composition data
  observeEvent(input$species_file, {
    req(input$species_file)
    
    tryCatch({
      ext <- tools::file_ext(input$species_file$name)
      
      data <- if (ext == "csv") {
        read.csv(input$species_file$datapath, row.names = 1, check.names = FALSE)
      } else if (ext %in% c("xlsx", "xls")) {
        df <- readxl::read_excel(input$species_file$datapath)
        # Set first column as row names
        rownames_col <- df[[1]]
        df <- df[, -1]
        rownames(df) <- rownames_col
        as.data.frame(df)
      }
      
      # Validate: should be numeric data
      if (!all(sapply(data, is.numeric))) {
        showNotification(
          "⚠️ Warning: Some columns are not numeric. Please ensure species data contains only abundance values.",
          type = "warning",
          duration = 8
        )
      }
      
      community_data(data)
      original_data(data)  # Store original for reset
      applied_transformations(NULL)  # Clear transformations
      
      showNotification(
        HTML(sprintf("✓ <strong>Species data loaded:</strong><br>%d sites × %d species", 
                     nrow(data), ncol(data))),
        type = "message",
        duration = 5
      )
    }, error = function(e) {
      showNotification(paste("❌ Error loading species file:", e$message), type = "error", duration = 10)
    })
  })
  
  # Upload environmental data
  observeEvent(input$env_file, {
    req(input$env_file)
    req(community_data())  # Must have species data first
    
    tryCatch({
      ext <- tools::file_ext(input$env_file$name)
      
      data <- if (ext == "csv") {
        read.csv(input$env_file$datapath, row.names = 1, check.names = FALSE)
      } else if (ext %in% c("xlsx", "xls")) {
        df <- readxl::read_excel(input$env_file$datapath)
        # Set first column as row names
        rownames_col <- df[[1]]
        df <- df[, -1]
        rownames(df) <- rownames_col
        as.data.frame(df)
      }
      
      # Validate: row names should match species data
      species_sites <- rownames(community_data())
      env_sites <- rownames(data)
      
      if (!all(species_sites %in% env_sites)) {
        missing_sites <- setdiff(species_sites, env_sites)
        showNotification(
          HTML(sprintf("⚠️ <strong>Warning:</strong> Some sites missing in environmental data:<br>%s",
                      paste(missing_sites, collapse = ", "))),
          type = "warning",
          duration = 10
        )
      }
      
      # Reorder to match species data
      data <- data[species_sites, , drop = FALSE]
      
      environmental_data(data)
      
      showNotification(
        HTML(sprintf("✓ <strong>Environmental data loaded:</strong><br>%d sites × %d variables", 
                     nrow(data), ncol(data))),
        type = "message",
        duration = 5
      )
    }, error = function(e) {
      showNotification(paste("❌ Error loading environmental file:", e$message), type = "error", duration = 10)
    })
  })
  
  # Species composition preview
  output$species_preview <- DT::renderDataTable({
    req(community_data())
    
    # Add site names as first column for display
    df <- community_data()
    df <- cbind(Site = rownames(df), df)
    
    DT::datatable(
      df,
      options = list(
        pageLength = 10,
        scrollX = TRUE,
        dom = 'Bfrtip',
        columnDefs = list(
          list(className = 'dt-left', targets = 0)
        )
      ),
      class = 'cell-border stripe',
      rownames = FALSE
    ) %>%
      DT::formatStyle(0, fontWeight = 'bold', color = '#2e8b57')
  })
  
  # Environmental data preview
  output$env_preview <- DT::renderDataTable({
    req(environmental_data())
    
    # Add site names as first column for display
    df <- environmental_data()
    df <- cbind(Site = rownames(df), df)
    
    DT::datatable(
      df,
      options = list(
        pageLength = 10,
        scrollX = TRUE,
        dom = 'Bfrtip',
        columnDefs = list(
          list(className = 'dt-left', targets = 0)
        )
      ),
      class = 'cell-border stripe',
      rownames = FALSE
    ) %>%
      DT::formatStyle(0, fontWeight = 'bold', color = '#2e8b57')
  })
  
  # Environmental data status
  output$env_data_loaded <- reactive({
    !is.null(environmental_data())
  })
  outputOptions(output, "env_data_loaded", suspendWhenHidden = FALSE)
  
  output$env_data_status <- renderUI({
    req(environmental_data())
    HTML(sprintf('
      <p style="color: #2e8b57; font-weight: 600; margin: 0;">
        ✓ Environmental data ready: %d sites × %d variables
      </p>
    ', nrow(environmental_data()), ncol(environmental_data())))
  })
  
  # Data summary
  output$data_summary <- renderUI({
    req(community_data())
    
    species_df <- community_data()
    n_sites <- nrow(species_df)
    n_species <- ncol(species_df)
    total_abundance <- sum(species_df)
    mean_richness <- mean(rowSums(species_df > 0))
    
    summary_html <- sprintf('
      <div style="background: #252526; padding: 20px; border: 1px solid #3e3e42;">
        <h3 style="color: #2e8b57; margin-top: 0;">Species Composition Summary</h3>
        <table style="color: #ccc; width: 100%%; border-collapse: collapse;">
          <tr style="border-bottom: 1px solid #3e3e42;">
            <td style="padding: 8px;"><strong>Number of Sites:</strong></td>
            <td style="padding: 8px;">%d</td>
          </tr>
          <tr style="border-bottom: 1px solid #3e3e42;">
            <td style="padding: 8px;"><strong>Number of Species:</strong></td>
            <td style="padding: 8px;">%d</td>
          </tr>
          <tr style="border-bottom: 1px solid #3e3e42;">
            <td style="padding: 8px;"><strong>Total Abundance:</strong></td>
            <td style="padding: 8px;">%.0f</td>
          </tr>
          <tr>
            <td style="padding: 8px;"><strong>Mean Species Richness:</strong></td>
            <td style="padding: 8px;">%.2f species/site</td>
          </tr>
        </table>
      </div>
    ', n_sites, n_species, total_abundance, mean_richness)
    
    if (!is.null(environmental_data())) {
      env_df <- environmental_data()
      n_env_vars <- ncol(env_df)
      env_var_names <- paste(colnames(env_df), collapse = ", ")
      
      summary_html <- paste0(summary_html, sprintf('
        <div style="background: #252526; padding: 20px; border: 1px solid #3e3e42; margin-top: 20px;">
          <h3 style="color: #2e8b57; margin-top: 0;">Environmental Data Summary</h3>
          <table style="color: #ccc; width: 100%%; border-collapse: collapse;">
            <tr style="border-bottom: 1px solid #3e3e42;">
              <td style="padding: 8px;"><strong>Number of Variables:</strong></td>
              <td style="padding: 8px;">%d</td>
            </tr>
            <tr>
              <td style="padding: 8px; vertical-align: top;"><strong>Variables:</strong></td>
              <td style="padding: 8px;">%s</td>
            </tr>
          </table>
          <div style="margin-top: 15px; padding: 10px; background: #1a3a2e; border-left: 3px solid #2e8b57;">
            <p style="color: #2e8b57; font-weight: 600; margin: 0 0 5px 0;">ℹ️ Note</p>
            <p style="color: #ccc; font-size: 12px; margin: 0;">Environmental data will be available for constrained ordination methods (RDA, CCA) and environmental fitting (envfit).</p>
          </div>
        </div>
      ', n_env_vars, env_var_names))
    }
    
    HTML(summary_html)
  })
  
  # Data transformations
  observeEvent(input$apply_transform, {
    req(community_data())
    req(input$transformations)
    
    tryCatch({
      # Start with current data (or original if resetting)
      data <- if (!is.null(original_data())) original_data() else community_data()
      transformed <- data
      
      # Apply selected transformations in order
      for (trans in input$transformations) {
        transformed <- switch(trans,
          "hellinger" = decostand(transformed, method = "hellinger"),
          "wisconsin" = wisconsin(transformed),
          "log" = log1p(transformed),
          "sqrt" = sqrt(transformed),
          transformed
        )
      }
      
      community_data(transformed)
      applied_transformations(input$transformations)
      
      showNotification(
        HTML(sprintf("✓ <strong>Transformations applied:</strong><br>%s",
                    paste(input$transformations, collapse = ", "))),
        type = "message",
        duration = 5
      )
    }, error = function(e) {
      showNotification(paste("❌ Error applying transformations:", e$message), type = "error", duration = 10)
    })
  })
  
  # Reset to original data
  observeEvent(input$reset_data, {
    req(original_data())
    
    community_data(original_data())
    applied_transformations(NULL)
    
    showNotification(
      "✓ Data reset to original values",
      type = "message",
      duration = 3
    )
  })
  
  # Transformation status
  output$transform_applied <- reactive({
    !is.null(applied_transformations())
  })
  outputOptions(output, "transform_applied", suspendWhenHidden = FALSE)
  
  output$transform_status <- renderUI({
    req(applied_transformations())
    HTML(sprintf('
      <p style="color: #2e8b57; font-weight: 600; margin: 0;">
        ✓ Active transformations: %s
      </p>
    ', paste(applied_transformations(), collapse = ", ")))
  })
  
  # Call all module servers
  # Diversity modules
  diversity_estimation_server("diversity_est", data = community_data)
  diversity_indices_server("diversity_idx", data = community_data)
  
  # Ordination modules
  nmds_server("nmds", data = community_data)
  pca_server("pca", data = community_data)
  ca_server("ca", data = community_data)
  dca_server("dca", data = community_data)
  pcoa_server("pcoa", data = community_data)
}

# Run app
shinyApp(ui, server)
