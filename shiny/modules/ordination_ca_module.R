# Ördin - CA Module  
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Correspondence Analysis (CA) ordination workflow

library(shiny)
library(vegan)
library(waiter)
library(shinyFeedback)

#' CA Module UI
ca_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    useShinyFeedback(),
    
    div(class = "ca-workflow",
      div(class = "config-panel",
        h3("⚙️ CA Configuration"),
        
        helpText("CA is ideal for unimodal species responses and gradient analysis."),
        
        # Run button
        div(class = "action-buttons", style = "margin-top: 20px;",
          actionButton(ns("run_ca"), "▶ Run CA", class = "btn-success", style = "width: 100%;")
        )
      ),
      
      div(class = "horizontal-split",
        div(class = "plot-panel",
          uiOutput(ns("inertia_interpretation")),
          plotOutput(ns("ca_plot"), height = "500px"),
          div(class = "plot-controls", style = "margin-top: 10px;",
            downloadButton(ns("export_plot"), "💾 Export PNG", class = "btn-sm")
          )
        ),
        
        div(class = "results-panel",
          div(class = "results-section",
            h3("📊 INERTIA & VARIANCE"),
            tableOutput(ns("inertia_table"))
          ),
          
          div(class = "action-buttons", style = "margin-top: 20px;",
            downloadButton(ns("export_results"), "📋 Export CSV", class = "btn-sm")
          )
        )
      )
    )
  )
}

#' CA Module Server
ca_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ca_result <- reactiveVal(NULL)
    
    observeEvent(input$run_ca, {
      req(data())
      
      waiter_show(html = tagList(
        spin_fading_circles(),
        h3("Running CA...", style = "color: #2e8b57; margin-top: 20px;")
      ))
      
      result <- tryCatch({
        cca(data())  # cca() without constraints = CA
      }, error = function(e) {
        waiter_hide()
        showNotification(paste("❌ CA failed:", e$message), type = "error")
        NULL
      })
      
      waiter_hide()
      
      if (!is.null(result)) {
        ca_result(result)
        
        eig <- eigenvals(result)
        var_exp <- sum(eig[1:2]) / sum(eig) * 100
        
        showNotification(
          HTML(sprintf("<strong>✓ CA Complete!</strong><br/>First 2 axes: %.1f%% inertia", var_exp)),
          type = "message"
        )
      }
    })
    
    output$inertia_interpretation <- renderUI({
      req(ca_result())
      
      eig <- eigenvals(ca_result())
      var_ca1 <- eig[1] / sum(eig) * 100
      var_ca2 <- eig[2] / sum(eig) * 100
      total <- var_ca1 + var_ca2
      
      color <- if(total >= 50) "#2e8b57" else "#d4a017"
      
      HTML(sprintf('
        <div style="background: %s20; border-left: 3px solid %s; padding: 16px; margin: 20px 0;">
          <h4 style="color: %s; margin: 0 0 8px 0;">Total inertia explained: %.1f%%</h4>
          <p style="color: #ccc; font-size: 12px;">CA1: %.1f%% | CA2: %.1f%%</p>
        </div>
      ', color, color, color, total, var_ca1, var_ca2))
    })
    
    output$ca_plot <- renderPlot({
      req(ca_result())
      plot(ca_result(), main = "CA Ordination", col.main = "#2e8b57")
    })
    
    output$inertia_table <- renderTable({
      req(ca_result())
      eig <- eigenvals(ca_result())
      data.frame(
        Axis = paste0("CA", 1:min(6, length(eig))),
        Eigenvalue = sprintf("%.4f", eig[1:min(6, length(eig))]),
        `Inertia (%)` = sprintf("%.2f", eig[1:min(6, length(eig))] / sum(eig) * 100),
        check.names = FALSE
      )
    })
    
    output$export_plot <- downloadHandler(
      filename = function() paste0("ca_plot_", Sys.Date(), ".png"),
      content = function(file) {
        png(file, width = 1200, height = 800, res = 150)
        plot(ca_result(), main = "CA Ordination")
        dev.off()
      }
    )
    
    output$export_results <- downloadHandler(
      filename = function() paste0("ca_results_", Sys.Date(), ".csv"),
      content = function(file) {
        scores_df <- as.data.frame(scores(ca_result(), display = "sites"))
        write.csv(scores_df, file, row.names = TRUE)
      }
    )
  })
}
