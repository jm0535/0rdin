# Ördin - DCA Module
# Detrended Correspondence Analysis

library(shiny)
library(vegan)

dca_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(class = "config-panel",
      h3("⚙️ DCA Configuration"),
      actionButton(ns("run_dca"), "▶ Run DCA", class = "btn-success", style = "width: 100%;")
    ),
    div(class = "horizontal-split",
      div(class = "plot-panel",
        plotOutput(ns("dca_plot"), height = "500px")
      ),
      div(class = "results-panel",
        h3("📊 AXIS LENGTHS"),
        tableOutput(ns("lengths_table")),
        downloadButton(ns("export_results"), "📋 Export CSV", class = "btn-sm")
      )
    )
  )
}

dca_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    dca_result <- reactiveVal(NULL)
    
    observeEvent(input$run_dca, {
      req(data())
      result <- tryCatch(decorana(data()), error = function(e) NULL)
      if (!is.null(result)) {
        dca_result(result)
        showNotification("✓ DCA Complete!", type = "message")
      }
    })
    
    output$dca_plot <- renderPlot({
      req(dca_result())
      plot(dca_result(), main = "DCA Ordination", col.main = "#2e8b57")
    })
    
    output$lengths_table <- renderTable({
      req(dca_result())
      lengths <- dca_result()$evals
      data.frame(
        Axis = paste0("DCA", 1:4),
        Length = sprintf("%.3f", lengths[1:4]),
        Interpretation = c(
          if(lengths[1] > 4) "Long gradient (unimodal)" else "Short gradient (linear)",
          if(lengths[2] > 4) "Long gradient" else "Short gradient",
          "Secondary gradient",
          "Tertiary gradient"
        )
      )
    })
    
    output$export_results <- downloadHandler(
      filename = function() paste0("dca_results_", Sys.Date(), ".csv"),
      content = function(file) {
        scores_df <- as.data.frame(scores(dca_result(), display = "sites"))
        write.csv(scores_df, file, row.names = TRUE)
      }
    )
  })
}
