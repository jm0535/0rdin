library(shiny)
library(bslib)
library(shinyjs)
library(waiter)
library(shinyFeedback)

# Source modules
source("modules/data_management.R")
source("modules/diversity_analysis.R")
source("modules/ordination.R")

# UI Definition
ui <- page_navbar(
  title = "Ördin v3.0",
  theme = bs_theme(
    version = 5,
    preset = "shiny",
    bg = "#1e1e1e",
    fg = "#cccccc",
    primary = "#2e8b57",
    secondary = "#2d2d30",
    "navbar-bg" = "#2d2d30"
  ),
  
  # Initialize extensions
  header = tagList(
    useShinyjs(),
    use_waiter(),
    useShinyFeedback()
  ),
  
  # Data Management Tab
  nav_panel(
    title = "Data",
    icon = icon("database"),
    dataManagementUI("dataManager")
  ),
  
  # Diversity Analysis Tab
  nav_panel(
    title = "Diversity Analysis",
    icon = icon("chart-line"),
    diversityAnalysisUI("diversity")
  ),
  
  # Ordination Tab
  nav_panel(
    title = "Ordination",
    icon = icon("project-diagram"),
    ordinationUI("ordination")
  ),
  
  # Help Tab
  nav_panel(
    title = "Help",
    icon = icon("question-circle"),
    includeMarkdown("www/help.md")
  )
)

# Server Definition
server <- function(input, output, session) {
  # Initialize loading screen
  waiter_show(
    html = tagList(
      spin_loaders(42, color = "#2e8b57"),
      h2("Ördin", style = "color: #2e8b57; margin-top: 30px;"),
      p("Loading...", style = "color: #999;")
    ),
    color = "#1a1a1a"
  )
  
  # Initialize modules
  data <- dataManagementServer("dataManager")
  diversityAnalysisServer("diversity", data)
  ordinationServer("ordination", data)
  
  # Hide loading screen after delay
  Sys.sleep(1)
  waiter_hide()
  
  # Session cleanup
  onSessionEnded(function() {
    # Clean up temporary files
    unlink(file.path(tempdir(), list.files(tempdir(), pattern = "^file")))
  })
}

# Run application
shinyApp(ui = ui, server = server)
