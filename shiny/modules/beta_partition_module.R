# Ördin - Beta Diversity Partitioning Module
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Beta diversity partitioning using betapart package

library(shiny)
library(betapart)
library(ggplot2)
library(vegan)
library(waiter)
library(shinyFeedback)

#' Beta Diversity Partitioning Module UI
#'
#' @param id Module namespace ID
#' @return UI elements for beta diversity partitioning
#' @export
beta_partition_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    useShinyFeedback(),
    
    div(class = "beta-partition-workflow",
      # Configuration Panel
      div(class = "config-panel",
        h3("⚙️ Beta Diversity Configuration"),
        
        # Data type
        selectInput(
          ns("data_type"),
          "Data Type:",
          choices = c(
            "Presence-Absence (Incidence)" = "incidence",
            "Abundance" = "abundance"
          ),
          selected = "incidence"
        ),
        
        # Index family
        selectInput(
          ns("index_family"),
          "Beta Diversity Index:",
          choices = c(
            "Sørensen (Jaccard for abundance)" = "sorensen",
            "Jaccard" = "jaccard",
            "Bray-Curtis (abundance only)" = "bray"
          ),
          selected = "sorensen"
        ),
        
        # Partitioning method
        selectInput(
          ns("partition_type"),
          "Partitioning Components:",
          choices = c(
            "Turnover & Nestedness" = "standard",
            "Temporal Beta Diversity" = "temporal",
            "Functional Beta Diversity" = "functional",
            "Phylogenetic Beta Diversity" = "phylogenetic"
          ),
          selected = "standard"
        ),
        
        # Run button
        div(class = "action-buttons", style = "margin-top: 20px;",
          actionButton(
            ns("run_partition"),
            "▶ Run Partitioning",
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
          uiOutput(ns("partition_interpretation")),
          
          # Beta diversity plots
          plotOutput(ns("beta_plot"), height = "500px"),
          
          # Plot controls
          div(class = "plot-controls", style = "margin-top: 10px;",
            downloadButton(ns("export_plot"), "💾 Export Plot", class = "btn-sm")
          )
        ),
        
        # Results Panel (30%)
        div(class = "results-panel",
          # Summary Statistics
          div(class = "results-section",
            h3("📊 BETA DIVERSITY COMPONENTS"),
            tableOutput(ns("beta_stats"))
          ),
          
          # Pairwise matrix summary
          div(class = "results-section", style = "margin-top: 20px;",
            h3("🔢 PAIRWISE COMPARISONS"),
            tableOutput(ns("pairwise_summary"))
          ),
          
          # Export Actions
          div(class = "action-buttons", style = "margin-top: 20px;",
            downloadButton(ns("export_results"), "📋 Export Results (CSV)", class = "btn-sm"),
            downloadButton(ns("export_matrices"), "🗂️ Export Matrices", class = "btn-sm", 
                          style = "margin-top: 8px;")
          )
        )
      )
    )
  )
}

#' Beta Diversity Partitioning Module Server
#'
#' @param id Module namespace ID
#' @param data Reactive containing species matrix
#' @param env_data Reactive containing environmental data (optional)
#' @param traits Reactive containing trait data (optional)
#' @param tree Reactive containing phylogenetic tree (optional)
#' @return Server logic for beta partitioning
#' @export
beta_partition_server <- function(id, data, env_data = reactive(NULL), 
                                  traits = reactive(NULL), tree = reactive(NULL)) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Reactive values
    beta_result <- reactiveVal(NULL)
    
    # Default plot settings
    plot_defaults <- reactiveValues(
      theme = "bw",
      font_family = "sans",
      base_size = 12,
      title_size = 14,
      plot_width = 10,
      plot_height = 6,
      dpi = 300
    )
    
    # Run Beta Partitioning
    observeEvent(input$run_partition, {
      req(data())
      
      # Validate data
      if (nrow(data()) < 2) {
        showNotification(
          "❌ Need at least 2 sites for beta diversity analysis",
          type = "error",
          duration = 5
        )
        return()
      }
      
      # Show loading
      waiter_show(html = tagList(
        spin_fading_circles(),
        h3("Computing Beta Diversity...", style = "color: #2e8b57; margin-top: 20px;")
      ))
      
      # Prepare data based on type
      beta_data <- if (input$data_type == "incidence") {
        # Convert to presence-absence
        ifelse(data() > 0, 1, 0)
      } else {
        as.matrix(data())
      }
      
      # Compute partitioning based on type
      result <- tryCatch({
        if (input$partition_type == "standard") {
          # Standard beta partitioning
          if (input$data_type == "incidence") {
            if (input$index_family == "sorensen") {
              beta.pair(beta_data, index.family = "sorensen")
            } else {
              beta.pair(beta_data, index.family = "jaccard")
            }
          } else {
            # Abundance-based
            beta.pair.abund(beta_data, index.family = "bray")
          }
        } else if (input$partition_type == "temporal") {
          # Temporal beta diversity
          if (input$data_type == "incidence") {
            beta.temp(beta_data, index.family = input$index_family)
          } else {
            showNotification("Temporal analysis requires incidence data", type = "warning")
            return(NULL)
          }
        } else if (input$partition_type == "functional") {
          # Functional beta diversity
          if (is.null(traits())) {
            showNotification("Functional analysis requires trait data", type = "warning")
            return(NULL)
          }
          functional.beta.pair(beta_data, traits(), index.family = input$index_family)
        } else if (input$partition_type == "phylogenetic") {
          # Phylogenetic beta diversity
          if (is.null(tree())) {
            showNotification("Phylogenetic analysis requires a phylogenetic tree", type = "warning")
            return(NULL)
          }
          phylo.beta.pair(beta_data, tree(), index.family = input$index_family)
        }
      }, error = function(e) {
        waiter_hide()
        showNotification(
          paste("❌ Beta partitioning failed:", e$message),
          type = "error",
          duration = 10
        )
        NULL
      })
      
      waiter_hide()
      
      if (!is.null(result)) {
        beta_result(result)
        
        showNotification(
          HTML("<strong>✓ Beta Diversity Partitioning Complete!</strong>"),
          type = "message",
          duration = 5
        )
      }
    })
    
    # Generate interpretation
    output$partition_interpretation <- renderUI({
      req(beta_result())
      
      div(
        style = "background: #2e8b5715; border-left: 4px solid #2e8b57; padding: 16px; margin-bottom: 16px;",
        h4(style = "color: #2e8b57; margin-top: 0; font-size: 14px; font-weight: 600;",
           "📊 BETA DIVERSITY INTERPRETATION"),
        p(style = "color: #ccc; font-size: 13px; margin: 8px 0; line-height: 1.6;",
          HTML(generate_beta_interpretation(beta_result(), input$index_family)))
      )
    })
    
    # Render beta diversity plot
    output$beta_plot <- renderPlot({
      req(beta_result())
      
      # Create multi-panel plot using ggplot2
      create_beta_plot(beta_result(), input$index_family, plot_defaults)
    })
    
    # Beta diversity statistics
    output$beta_stats <- renderTable({
      req(beta_result())
      
      # Calculate mean values
      beta_total <- mean(as.dist(beta_result()[[1]]))
      turnover <- mean(as.dist(beta_result()[[2]]))
      nestedness <- mean(as.dist(beta_result()[[3]]))
      
      data.frame(
        Component = c(
          paste0("β-total (", input$index_family, ")"),
          "Turnover Component",
          "Nestedness Component",
          "Turnover Proportion"
        ),
        Value = c(
          sprintf("%.4f", beta_total),
          sprintf("%.4f", turnover),
          sprintf("%.4f", nestedness),
          sprintf("%.1f%%", (turnover / beta_total) * 100)
        ),
        stringsAsFactors = FALSE
      )
    }, 
    striped = TRUE,
    hover = TRUE,
    spacing = "s",
    width = "100%")
    
    # Pairwise summary
    output$pairwise_summary <- renderTable({
      req(beta_result())
      
      n_pairs <- choose(nrow(data()), 2)
      
      data.frame(
        Metric = c(
          "Total Comparisons",
          "Sites Analyzed",
          "Analysis Type"
        ),
        Value = c(
          n_pairs,
          nrow(data()),
          tools::toTitleCase(input$partition_type)
        ),
        stringsAsFactors = FALSE
      )
    },
    striped = TRUE,
    hover = TRUE,
    spacing = "s",
    width = "100%")
    
    # Export plot
    output$export_plot <- downloadHandler(
      filename = function() {
        sprintf("beta_diversity_%s.png", format(Sys.Date(), "%Y%m%d"))
      },
      content = function(file) {
        p <- create_beta_plot(beta_result(), input$index_family, plot_defaults)
        ggsave(
          file,
          plot = p,
          width = plot_defaults$plot_width,
          height = plot_defaults$plot_height,
          dpi = plot_defaults$dpi
        )
      }
    )
    
    # Export results
    output$export_results <- downloadHandler(
      filename = function() {
        sprintf("beta_diversity_results_%s.csv", format(Sys.Date(), "%Y%m%d"))
      },
      content = function(file) {
        beta_total <- mean(as.dist(beta_result()[[1]]))
        turnover <- mean(as.dist(beta_result()[[2]]))
        nestedness <- mean(as.dist(beta_result()[[3]]))
        
        results <- data.frame(
          Component = c("Beta_Total", "Turnover", "Nestedness", "Turnover_Proportion"),
          Value = c(beta_total, turnover, nestedness, turnover / beta_total)
        )
        
        write.csv(results, file, row.names = FALSE)
      }
    )
    
    # Export matrices
    output$export_matrices <- downloadHandler(
      filename = function() {
        sprintf("beta_diversity_matrices_%s.zip", format(Sys.Date(), "%Y%m%d"))
      },
      content = function(file) {
        # Create temp directory
        tmpdir <- tempdir()
        
        # Write matrices
        write.csv(as.matrix(beta_result()[[1]]), 
                 file.path(tmpdir, "beta_total.csv"))
        write.csv(as.matrix(beta_result()[[2]]), 
                 file.path(tmpdir, "turnover.csv"))
        write.csv(as.matrix(beta_result()[[3]]), 
                 file.path(tmpdir, "nestedness.csv"))
        
        # Create zip
        zip(file, files = dir(tmpdir, pattern = "\\.csv$", full.names = TRUE))
      }
    )
  })
}

#' Generate beta diversity interpretation
#'
#' @param beta_result Beta diversity result object
#' @param index_family Index family used
#' @return HTML string with interpretation
generate_beta_interpretation <- function(beta_result, index_family) {
  beta_total <- mean(as.dist(beta_result[[1]]))
  turnover <- mean(as.dist(beta_result[[2]]))
  nestedness <- mean(as.dist(beta_result[[3]]))
  turnover_prop <- (turnover / beta_total) * 100
  
  interpretation <- sprintf(
    "<strong>Average β-diversity:</strong> %.3f<br>",
    beta_total
  )
  
  if (turnover_prop > 70) {
    interpretation <- paste0(interpretation,
      "<strong>Dominant process:</strong> <span style='color: #5fd38d;'>Species replacement (turnover)</span><br>",
      "Communities differ primarily due to species replacement rather than richness differences."
    )
  } else if (turnover_prop < 30) {
    interpretation <- paste0(interpretation,
      "<strong>Dominant process:</strong> <span style='color: #ffa500;'>Nestedness</span><br>",
      "Communities differ primarily due to species loss/gain (nestedness) rather than replacement."
    )
  } else {
    interpretation <- paste0(interpretation,
      "<strong>Dominant process:</strong> <span style='color: #4a90e2;'>Mixed (both turnover and nestedness)</span><br>",
      "Both species replacement and richness differences contribute to beta diversity."
    )
  }
  
  return(interpretation)
}

#' Create beta diversity plot using ggplot2
#'
#' @param beta_result Beta diversity result
#' @param index_family Index family
#' @param plot_defaults Plot settings
#' @return ggplot2 object
create_beta_plot <- function(beta_result, index_family, plot_defaults) {
  library(reshape2)
  library(gridExtra)
  
  # Convert matrices to data frames
  beta_total_df <- melt(as.matrix(beta_result[[1]]))
  turnover_df <- melt(as.matrix(beta_result[[2]]))
  nestedness_df <- melt(as.matrix(beta_result[[3]]))
  
  # Create theme
  plot_theme <- theme_bw(base_size = plot_defaults$base_size, 
                        base_family = plot_defaults$font_family) +
    theme(
      plot.title = element_text(size = plot_defaults$title_size, face = "bold"),
      axis.text.x = element_text(angle = 45, hjust = 1)
    )
  
  # Plot 1: Beta total
  p1 <- ggplot(beta_total_df, aes(x = Var1, y = Var2, fill = value)) +
    geom_tile() +
    scale_fill_gradient2(low = "#2e8b57", mid = "#ffd700", high = "#dc143c",
                        midpoint = 0.5, limits = c(0, 1)) +
    labs(title = paste0("β-Total (", index_family, ")"),
         x = "", y = "", fill = "Dissimilarity") +
    plot_theme
  
  # Plot 2: Turnover
  p2 <- ggplot(turnover_df, aes(x = Var1, y = Var2, fill = value)) +
    geom_tile() +
    scale_fill_gradient2(low = "#2e8b57", mid = "#ffd700", high = "#dc143c",
                        midpoint = 0.5, limits = c(0, 1)) +
    labs(title = "Turnover Component",
         x = "", y = "", fill = "Turnover") +
    plot_theme
  
  # Plot 3: Nestedness
  p3 <- ggplot(nestedness_df, aes(x = Var1, y = Var2, fill = value)) +
    geom_tile() +
    scale_fill_gradient2(low = "#2e8b57", mid = "#ffd700", high = "#dc143c",
                        midpoint = 0.5, limits = c(0, 1)) +
    labs(title = "Nestedness Component",
         x = "", y = "", fill = "Nestedness") +
    plot_theme
  
  # Combine plots
  grid.arrange(p1, p2, p3, ncol = 3)
}
