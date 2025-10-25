# Ördin - PCoA Module
# Principal Coordinates Analysis

library(shiny)
library(vegan)

pcoa_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(class = "config-panel",
      h3("⚙️ PCoA Configuration"),
      selectInput(ns("distance"), "Distance:",
                 choices = c("Bray-Curtis" = "bray", "Jaccard" = "jaccard", 
                            "Euclidean" = "euclidean")),
      actionButton(ns("run_pcoa"), "▶ Run PCoA", class = "btn-success", style = "width: 100%;")
    ),
    div(class = "horizontal-split",
      div(class = "plot-panel",
        plotOutput(ns("pcoa_plot"), height = "500px")
      ),
      div(class = "results-panel",
        h3("📊 EIGENVALUES"),
        tableOutput(ns("eigen_table")),
        downloadButton(ns("export_results"), "📋 Export CSV", class = "btn-sm")
      )
    )
  )
}

pcoa_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    pcoa_result <- reactiveVal(NULL)
    
    observeEvent(input$run_pcoa, {
      req(data())
      result <- tryCatch({
        capscale(data() ~ 1, distance = input$distance)
      }, error = function(e) NULL)
      
      if (!is.null(result)) {
        pcoa_result(result)
        showNotification("✓ PCoA Complete!", type = "message")
      }
    })
    
    output$pcoa_plot <- renderPlot({
      req(pcoa_result())
      plot(pcoa_result(), main = "PCoA Ordination", col.main = "#2e8b57")
      points(pcoa_result(), display = "sites", pch = 21, bg = "#2e8b57", cex = 2)
    })
    
    output$eigen_table <- renderTable({
      req(pcoa_result())
      eig <- eigenvals(pcoa_result())
      data.frame(
        Axis = paste0("PCo", 1:min(6, length(eig))),
        Eigenvalue = sprintf("%.4f", eig[1:min(6, length(eig))]),
        `Variance (%)` = sprintf("%.2f", eig[1:min(6, length(eig))] / sum(eig[eig > 0]) * 100),
        check.names = FALSE
      )
    })
    
    output$export_results <- downloadHandler(
      filename = function() paste0("pcoa_results_", Sys.Date(), ".csv"),
      content = function(file) {
        scores_df <- as.data.frame(scores(pcoa_result(), display = "sites"))
        write.csv(scores_df, file, row.names = TRUE)
      }
    )
  })
}
