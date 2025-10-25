# Ördin - Simple NMDS Test (No Waiter)
# Author: Jimmy Moses (jmoses@pnguot.ac.pg)
# Minimal test without waiter package

library(shiny)
library(vegan)
library(shinyFeedback)
library(bslib)

# Source utilities only
source("utils/validation.R")
source("utils/interpretation.R")

# UI
ui <- page_fluid(
  theme = bs_theme(
    version = 5,
    bg = "#1e1e1e",
    fg = "#cccccc",
    primary = "#2e8b57"
  ),
  
  useShinyFeedback(),
  
  h1("🗺️ Simple NMDS Test", style = "color: #2e8b57; margin: 20px;"),
  
  # Data loader
  div(style = "margin: 20px; padding: 20px; background: #252526;",
    h3("Load Data", style = "color: #2e8b57;"),
    selectInput("dataset", "Choose dataset:",
               choices = c("dune", "varespec", "BCI")),
    actionButton("load", "📂 Load Data", class = "btn-primary"),
    textOutput("status")
  ),
  
  # NMDS Config
  div(style = "margin: 20px; padding: 20px; background: #252526;",
    h3("NMDS Configuration", style = "color: #2e8b57;"),
    numericInput("k", "Dimensions (k):", value = 2, min = 1, max = 5),
    selectInput("distance", "Distance:",
               choices = c("bray", "jaccard", "euclidean")),
    actionButton("run", "▶ Run NMDS", class = "btn-success")
  ),
  
  # Results
  div(style = "margin: 20px; padding: 20px; background: #252526;",
    h3("Results", style = "color: #2e8b57;"),
    uiOutput("interpretation"),
    plotOutput("plot", height = "500px"),
    tableOutput("stats")
  )
)

# Server
server <- function(input, output, session) {
  
  # Data storage
  community_data <- reactiveVal(NULL)
  nmds_result <- reactiveVal(NULL)
  
  # Load data
  observeEvent(input$load, {
    cat("\n=== Loading data ===\n")
    tryCatch({
      data(list = input$dataset, package = "vegan")
      dataset <- get(input$dataset)
      community_data(dataset)
      
      cat("Loaded:", input$dataset, "\n")
      cat("Dimensions:", nrow(dataset), "x", ncol(dataset), "\n")
      
      showNotification(
        sprintf("✓ Loaded %s: %d × %d", input$dataset, nrow(dataset), ncol(dataset)),
        type = "message"
      )
    }, error = function(e) {
      cat("Error:", e$message, "\n")
      showNotification(paste("Error:", e$message), type = "error")
    })
  })
  
  # Status
  output$status <- renderText({
    if (is.null(community_data())) {
      "No data loaded"
    } else {
      sprintf("✓ %d sites × %d species loaded", 
              nrow(community_data()), ncol(community_data()))
    }
  })
  
  # Run NMDS
  observeEvent(input$run, {
    cat("\n=== RUN BUTTON CLICKED ===\n")
    
    if (is.null(community_data())) {
      cat("ERROR: No data loaded!\n")
      showNotification("Please load data first!", type = "error")
      return()
    }
    
    cat("Data check passed\n")
    cat("Running NMDS with k =", input$k, "and distance =", input$distance, "\n")
    
    tryCatch({
      result <- metaMDS(
        community_data(),
        distance = input$distance,
        k = input$k,
        trymax = 20,
        autotransform = FALSE,
        trace = TRUE  # Show progress in console
      )
      
      cat("NMDS completed! Stress =", result$stress, "\n")
      nmds_result(result)
      
      showNotification(
        sprintf("✓ NMDS Complete! Stress = %.3f", result$stress),
        type = "message"
      )
    }, error = function(e) {
      cat("NMDS ERROR:", e$message, "\n")
      showNotification(paste("NMDS failed:", e$message), type = "error")
    })
  })
  
  # Interpretation
  output$interpretation <- renderUI({
    req(nmds_result())
    generateStressInterpretationHTML(nmds_result()$stress)
  })
  
  # Plot
  output$plot <- renderPlot({
    req(nmds_result())
    
    plot(nmds_result(), type = "none", main = "NMDS Ordination")
    points(nmds_result(), display = "sites", pch = 21, bg = "#2e8b57", cex = 2)
    
    stress_text <- sprintf("Stress = %.3f", nmds_result()$stress)
    mtext(stress_text, side = 3, col = "#2e8b57", font = 2)
  })
  
  # Stats
  output$stats <- renderTable({
    req(nmds_result())
    
    interp <- interpretNMDSStress(nmds_result()$stress)
    
    data.frame(
      Statistic = c("Stress", "Grade", "Convergence", "Iterations"),
      Value = c(
        sprintf("%.4f", nmds_result()$stress),
        interp$grade,
        if(nmds_result()$converged) "✓" else "✗",
        nmds_result()$iters
      )
    )
  })
}

shinyApp(ui, server)
