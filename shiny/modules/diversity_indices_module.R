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
      
      # WHEN TO USE guidance box
      div(style = "background: #4a90e220; border-left: 3px solid #4a90e2; padding: 12px; margin-bottom: 16px;",
        h4(style = "color: #4a90e2; margin: 0 0 8px 0; font-size: 13px; font-weight: 600;", "📘 WHEN TO USE DIVERSITY INDICES"),
        tags$ul(style = "color: #ccc; font-size: 11px; margin: 0; padding-left: 20px; line-height: 1.6;",
          tags$li("Calculate **alpha diversity** within sites using classic metrics"),
          tags$li("Quantify both **species richness** (S) and **evenness** (Pielou's J')"),
          tags$li("Compare diversity patterns across sites using **Shannon** or **Simpson**"),
          tags$li("Example: Is grassland more diverse than forest in terms of species evenness?")
        )
      ),
      
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
        div(class = "plot-panel", style = "max-width: 100%; overflow: hidden;",
          # Interpretation box
          uiOutput(ns("indices_interpretation")),
          
          plotOutput(ns("indices_plot"), width = "100%", height = "500px")
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
    
    # Plot customization defaults
    plot_defaults <- reactiveValues(
      theme = "bw",
      base_size = 12,
      title_size = 16,
      color_palette = c("#2e8b57", "#007acc", "#d4a017", "#ff6b6b", "#4ade80")
    )
    
    # Observers for plot customization (when right panel is added later)
    observeEvent(input$plot_theme, { plot_defaults$theme <- input$plot_theme }, ignoreNULL = FALSE)
    observeEvent(input$plot_base_size, { plot_defaults$base_size <- input$plot_base_size }, ignoreNULL = FALSE)
    observeEvent(input$plot_title_size, { plot_defaults$title_size <- input$plot_title_size }, ignoreNULL = FALSE)
    
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
        
        # CRITICAL: Trigger plot customization panel to open
        session$sendCustomMessage(
          type = "showPlotCustomization",
          message = list(
            plotType = "diversity",
            moduleId = "diversity_idx"
          )
        )
        
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
      
      # Force reactivity by observing ALL plot customization inputs
      plot_theme <- if(!is.null(input$plot_plot_theme)) input$plot_plot_theme else plot_defaults$theme
      plot_base_size <- if(!is.null(input$plot_base_size)) input$plot_base_size else plot_defaults$base_size
      plot_title_size <- if(!is.null(input$plot_title_size)) input$plot_title_size else plot_defaults$title_size
      
      # Reshape data for plotting
      plot_data <- tidyr::pivot_longer(
        indices_results(),
        cols = -Sample,
        names_to = "Index",
        values_to = "Value"
      )
      
      # Select theme
      selected_theme <- switch(plot_theme,
        "bw" = theme_bw(base_size = plot_base_size),
        "minimal" = theme_minimal(base_size = plot_base_size),
        "classic" = theme_classic(base_size = plot_base_size),
        "light" = theme_light(base_size = plot_base_size),
        "dark" = theme_dark(base_size = plot_base_size),
        "void" = theme_void(base_size = plot_base_size),
        theme_bw(base_size = plot_base_size)
      )
      
      ggplot(plot_data, aes(x = Sample, y = Value, fill = Index)) +
        geom_col(position = "dodge", color = "#1e1e1e") +
        facet_wrap(~Index, scales = "free_y", ncol = 1) +
        selected_theme +
        theme(
          plot.title = element_text(color = "#2e8b57", size = plot_title_size, face = "bold"),
          axis.text.x = element_text(angle = 45, hjust = 1, size = plot_base_size - 4),
          axis.title = element_text(size = plot_base_size),
          legend.position = "none",
          panel.grid.minor = element_blank(),
          strip.background = element_rect(fill = "#252526"),
          strip.text = element_text(color = "#2e8b57", face = "bold", size = plot_base_size)
        ) +
        scale_fill_manual(values = plot_defaults$color_palette) +
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
          scrollX = TRUE,
          dom = 'frtip',  # Enable full pagination controls
          paging = TRUE,
          searching = TRUE,
          info = TRUE
        ),
        rownames = FALSE,
        class = 'cell-border stripe hover compact'
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
      filename = function() paste0("diversity_indices_", Sys.Date(), ".", plot_defaults$export_format),
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
        
        ggsave(file, plot = p, width = plot_defaults$plot_width, height = plot_defaults$plot_height, 
               dpi = plot_defaults$dpi, device = plot_defaults$export_format)
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
