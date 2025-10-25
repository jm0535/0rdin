# Ördin - Diversity Indices Module (vegan)
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Alpha diversity metrics (Shannon, Simpson, etc.)

library(shiny)
library(vegan)
library(ggplot2)
library(waiter)

#' Diversity Indices Module UI
diversity_indices_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    div(class = "diversity-indices-workflow",
      # Header
      h2("📋 Diversity Indices (vegan)", style = "color: #2e8b57; margin-bottom: 20px;"),
      p("Calculate Shannon, Simpson, and other diversity metrics", style = "color: #888; margin-bottom: 30px;"),
      
      # TIP BOX: Choosing Indices
      div(style = "background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;",
        p(style = "color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;", "ℹ️ TIP: Choosing the Right Index"),
        HTML('<p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
          • <strong>Shannon (H’):</strong> Most common; balances richness & evenness. Higher = more diverse<br>
          • <strong>Simpson (D):</strong> Probability two individuals are same species. Lower = more diverse<br>
          • <strong>Inverse Simpson:</strong> More intuitive (higher = more diverse). Good for dominance<br>
          • <strong>Pielou’s J’:</strong> Evenness measure (0-1). Shows how evenly species are distributed<br>
          • <strong>Richness (S):</strong> Simple species count. Ignores abundance patterns
        </p>')
      ),
      
      # Configuration Panel
      div(class = "config-panel",
        h3("Select Indices to Calculate", style = "color: #cccccc; margin-bottom: 16px;"),
        
        # Select indices
        checkboxGroupInput(
          ns("indices"),
          "Select Indices:",
          choices = c(
            "Shannon" = "shannon",
            "Simpson" = "simpson",
            "Inverse Simpson" = "invsimpson",
            "Species Richness" = "richness",
            "Pielou's Evenness" = "evenness"
          ),
          selected = c("shannon", "simpson", "richness")
        ),
        
        # TIP BOX: When to Use Each
        div(style = "background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin: 20px 0;",
          p(style = "color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;", "💡 KNOWLEDGE: When to Use Each"),
          HTML('<p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
            • Report <strong>Shannon & Simpson</strong> together for comprehensive diversity assessment<br>
            • Use <strong>Pielou’s J’</strong> to understand if communities are dominated by few species<br>
            • <strong>Richness alone</strong> misses abundance patterns - combine with evenness metrics
          </p>')
        ),
        
        # Run button
        div(class = "action-buttons", style = "margin-top: 20px;",
          actionButton(
            ns("run_indices"),
            "▶ Calculate Indices",
            class = "btn-success",
            style = "width: 100%;"
          )
        )
      ),
      
      # Results Area
      div(class = "horizontal-split",
        # Plot Panel (70%)
        div(class = "plot-panel",
          # Interpretation box
          uiOutput(ns("indices_interpretation")),
          
          plotOutput(ns("indices_plot"), height = "500px"),
          
          # Plot controls
          div(class = "plot-controls", style = "margin-top: 10px;",
            downloadButton(ns("export_plot"), "💾 Export PNG", class = "btn-sm")
          )
        ),
        
        # Results Panel (30%)
        div(class = "results-panel",
          # Indices table
          div(class = "results-section",
            h3("📊 DIVERSITY INDICES"),
            DT::dataTableOutput(ns("indices_table"))
          ),
          
          # Summary statistics
          div(class = "results-section", style = "margin-top: 20px;",
            h3("📈 SUMMARY STATISTICS"),
            tableOutput(ns("summary_table"))
          ),
          
          # Export Actions
          div(class = "action-buttons", style = "margin-top: 20px;",
            downloadButton(ns("export_results"), "📋 Export Results (CSV)", class = "btn-sm")
          )
        )
      )
    )
  )
}

#' Diversity Indices Module Server
diversity_indices_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Reactive values
    indices_results <- reactiveVal(NULL)
    
    # Calculate diversity indices
    observeEvent(input$run_indices, {
      req(data())
      req(input$indices)
      
      waiter_show(html = tagList(
        spin_fading_circles(),
        h3("Calculating Diversity Indices...", style = "color: #2e8b57; margin-top: 20px;")
      ))
      
      results <- tryCatch({
        indices_list <- list()
        
        # Calculate selected indices
        if ("shannon" %in% input$indices) {
          indices_list$Shannon <- diversity(data(), index = "shannon")
        }
        if ("simpson" %in% input$indices) {
          indices_list$Simpson <- diversity(data(), index = "simpson")
        }
        if ("invsimpson" %in% input$indices) {
          indices_list$InvSimpson <- diversity(data(), index = "invsimpson")
        }
        if ("richness" %in% input$indices) {
          indices_list$Richness <- specnumber(data())
        }
        if ("evenness" %in% input$indices) {
          H <- diversity(data(), index = "shannon")
          S <- specnumber(data())
          indices_list$Evenness <- H / log(S)
        }
        
        # Combine into data frame
        results_df <- as.data.frame(indices_list)
        results_df$Sample <- rownames(data())
        results_df <- results_df[, c("Sample", setdiff(names(results_df), "Sample"))]
        
        results_df
      }, error = function(e) {
        waiter_hide()
        showNotification(paste("Error:", e$message), type = "error")
        NULL
      })
      
      waiter_hide()
      
      if (!is.null(results)) {
        indices_results(results)
        showNotification("✓ Diversity indices calculated!", type = "message")
      }
    })
    
    # Interpretation box
    output$indices_interpretation <- renderUI({
      req(indices_results())
      
      # Calculate means
      means <- colMeans(indices_results()[, -1, drop = FALSE], na.rm = TRUE)
      
      HTML(sprintf('
        <div style="background: #2e8b5720; border-left: 3px solid #2e8b57; padding: 16px; margin: 20px 0;">
          <h4 style="color: #2e8b57; margin: 0 0 8px 0; font-size: 14px;">
            📊 Mean Diversity Across Sites
          </h4>
          <p style="color: #ccc; font-size: 12px; margin: 0; line-height: 1.8;">
            %s
          </p>
        </div>
      ', paste(
        sapply(names(means), function(idx) {
          sprintf("<strong>%s:</strong> %.3f", idx, means[idx])
        }),
        collapse = " | "
      )))
    })
    
    # Plot indices
    output$indices_plot <- renderPlot({
      req(indices_results())
      
      # Reshape data for plotting
      plot_data <- tidyr::pivot_longer(
        indices_results(),
        cols = -Sample,
        names_to = "Index",
        values_to = "Value"
      )
      
      ggplot(plot_data, aes(x = Sample, y = Value, fill = Index)) +
        geom_col(position = "dodge", color = "#1e1e1e") +
        facet_wrap(~Index, scales = "free_y", ncol = 1) +
        theme_bw() +
        theme(
          plot.title = element_text(color = "#2e8b57", size = 16, face = "bold"),
          axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
          axis.title = element_text(size = 12),
          legend.position = "none",
          panel.grid.minor = element_blank(),
          strip.background = element_rect(fill = "#252526"),
          strip.text = element_text(color = "#2e8b57", face = "bold")
        ) +
        scale_fill_manual(values = c("#2e8b57", "#007acc", "#d4a017", "#ff6b6b", "#4ade80")) +
        labs(
          title = "Diversity Indices by Site",
          x = "Sample Site",
          y = "Index Value"
        )
    })
    
    # Indices table
    output$indices_table <- DT::renderDataTable({
      req(indices_results())
      
      DT::datatable(
        indices_results(),
        options = list(
          pageLength = 10,
          scrollX = TRUE
        ),
        rownames = FALSE
      ) %>%
        DT::formatRound(columns = setdiff(names(indices_results()), "Sample"), digits = 4)
    })
    
    # Summary statistics
    output$summary_table <- renderTable({
      req(indices_results())
      
      numeric_cols <- indices_results()[, -1, drop = FALSE]
      
      summary_df <- data.frame(
        Index = names(numeric_cols),
        Mean = colMeans(numeric_cols, na.rm = TRUE),
        SD = apply(numeric_cols, 2, sd, na.rm = TRUE),
        Min = apply(numeric_cols, 2, min, na.rm = TRUE),
        Max = apply(numeric_cols, 2, max, na.rm = TRUE)
      )
      
      summary_df
    }, digits = 4)
    
    # Export plot
    output$export_plot <- downloadHandler(
      filename = function() paste0("diversity_indices_", Sys.Date(), ".png"),
      content = function(file) {
        plot_data <- tidyr::pivot_longer(
          indices_results(),
          cols = -Sample,
          names_to = "Index",
          values_to = "Value"
        )
        
        p <- ggplot(plot_data, aes(x = Sample, y = Value, fill = Index)) +
          geom_col(position = "dodge") +
          facet_wrap(~Index, scales = "free_y") +
          theme_bw() +
          scale_fill_manual(values = c("#2e8b57", "#007acc", "#d4a017"))
        
        ggsave(file, plot = p, width = 12, height = 8, dpi = 300)
      }
    )
    
    # Export results
    output$export_results <- downloadHandler(
      filename = function() paste0("diversity_indices_", Sys.Date(), ".csv"),
      content = function(file) {
        write.csv(indices_results(), file, row.names = FALSE)
      }
    )
  })
}
