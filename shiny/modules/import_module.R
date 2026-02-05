#' Import Module UI
#' @param id Module namespace ID
#' @export
import_ui <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      class = "section-content",
      style = "padding: 20px;",

      h3("📥 Import Data"),

      # File Upload
      fileInput(ns("file"), "Choose CSV/Excel File",
        accept = c(".csv", ".xlsx", ".xls")
      ),

      selectInput(ns("file_type"), "Data Type",
        choices = c(
          "Species Abundance" = "species",
          "Environmental Data" = "env",
          "Functional Traits" = "traits"
        )
      ),

      hr(),

      h3("📚 Load Sample Data"),
      selectInput(ns("sample_dataset"), "Select Dataset",
        choices = c(
          "Choose a sample dataset..." = "",
          "Dune Meadow (20 sites × 30 species + env)" = "dune",
          "Varespec (24 sites × 44 species)" = "varespec",
          "BCI (50 sites × 225 species)" = "BCI",
          "Phylocom (6 sites + phylo)" = "phylo_example",
          "Functional Traits (6 sites + traits)" = "func_example"
        )
      ),

      actionButton(ns("load_sample"), "▶ Load Sample",
        class = "btn-success", style = "width: 100%; margin-top: 10px;"
      )
    )
  )
}

#' Import Module Server
#' @param id Module namespace ID
#' @param data_service DataService R6 instance
#' @export
import_server <- function(id, data_service) {
  moduleServer(id, function(input, output, session) {

    # Handle File Upload
    observeEvent(input$file, {
      req(input$file)

      # Show spinner
      waiter::waiter_show(html = waiter::spin_fading_circles())

      result <- data_service$load_file(input$file$datapath, input$file_type)

      waiter::waiter_hide()

      if (result$success) {
        showNotification(paste("✅", result$message), type = "message")
      } else {
        showNotification(paste("❌ Error:", result$message), type = "error")
      }
    })

    # Handle Sample Data
    observeEvent(input$load_sample, {
      req(input$sample_dataset)

      waiter::waiter_show(html = waiter::spin_fading_circles())

      result <- data_service$load_sample_data(input$sample_dataset)

      waiter::waiter_hide()

      if (result$success) {
        showNotification(paste("✅", result$message), type = "message")
      } else {
        showNotification(paste("❌ Error:", result$message), type = "error")
      }
    })
  })
}
