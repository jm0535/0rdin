# Ördin - NMDS Module Test App
# Quick test to verify module functionality

library(shiny)
library(vegan)
library(waiter)
library(shinyFeedback)
library(bslib)

# Source the module
source("modules/ordination_nmds_module.R")

# UI
ui <- page_fluid(
  theme = bs_theme(
    version = 5,
    bg = "#1e1e1e",
    fg = "#cccccc",
    primary = "#2e8b57",
    base_font = font_google("Roboto")
  ),
  
  # Add custom CSS
  tags$head(
    tags$link(rel = "stylesheet", href = "custom.css"),
    tags$style(HTML("
      body { 
        background: #1e1e1e; 
        color: #cccccc;
        overflow-y: scroll;
      }
      .horizontal-split {
        display: flex;
        gap: 20px;
        margin-top: 20px;
        margin-bottom: 40px;
      }
      .plot-panel {
        flex: 7;
        background: #252526;
        padding: 20px;
        border-radius: 4px;
      }
      .results-panel {
        flex: 3;
        background: #252526;
        padding: 20px;
        border-radius: 4px;
      }
      .config-panel {
        background: #2d2d30;
        padding: 20px;
        border-radius: 4px;
        margin-bottom: 20px;
      }
      .results-section {
        margin-bottom: 20px;
      }
      .results-section h3 {
        font-size: 12px;
        font-weight: 700;
        color: #2e8b57;
        margin-bottom: 10px;
        letter-spacing: 0.5px;
      }
      table {
        width: 100%;
        font-size: 12px;
      }
      table th {
        background: #2d2d30;
        color: #2e8b57;
        font-weight: 600;
        padding: 8px;
      }
      table td {
        padding: 6px 8px;
        border-bottom: 1px solid #3e3e42;
      }
    "))
  ),
  
  # Use waiter
  use_waiter(),
  
  # Title
  h1("🗺️ NMDS Module Test", style = "color: #2e8b57; margin: 20px 0;"),
  
  # Load sample data button
  div(style = "margin: 20px 0;",
    actionButton("load_data", "📂 Load Sample Data (dune dataset)", class = "btn-primary"),
    textOutput("data_status", inline = TRUE)
  ),
  
  # NMDS Module UI
  nmds_ui("nmds_test")
)

# Server
server <- function(input, output, session) {
  
  # Reactive data
  species_data <- reactiveVal(NULL)
  
  # Load sample data
  observeEvent(input$load_data, {
    tryCatch({
      # Load dune dataset from vegan package
      data(dune, package = "vegan")
      
      # Set reactive value
      species_data(dune)
      
      # Show success notification
      showNotification(
        sprintf("✓ Loaded 'dune' dataset: %d sites × %d species", 
                nrow(dune), ncol(dune)),
        type = "message",
        duration = 5
      )
    }, error = function(e) {
      showNotification(
        paste("❌ Error loading data:", e$message),
        type = "error",
        duration = 10
      )
    })
  })
  
  # Data status
  output$data_status <- renderText({
    if (is.null(species_data())) {
      "No data loaded"
    } else {
      sprintf("  ✓ Data loaded: %d sites × %d species", 
              nrow(species_data()), ncol(species_data()))
    }
  })
  
  # Call NMDS module
  nmds_server("nmds_test", data = species_data)
}

# Run app
shinyApp(ui, server)
