# Ördin - Beta Diversity Partitioning Module
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Beta diversity partitioning using betapart package

library(shiny)
library(betapart)
library(ggplot2)
library(vegan)
library(waiter)
library(shinyFeedback)
library(patchwork)

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
      # WHEN TO USE guidance box
      div(style = "background: #4a90e220; border-left: 3px solid #4a90e2; padding: 12px; margin-bottom: 16px;",
        h4(style = "color: #4a90e2; margin: 0 0 8px 0; font-size: 13px; font-weight: 600;", "📘 WHEN TO USE BETA DIVERSITY PARTITIONING"),
        tags$ul(style = "color: #ccc; font-size: 11px; margin: 0; padding-left: 20px; line-height: 1.6;",
          tags$li("Decompose **beta diversity** into **turnover** (species replacement) and **nestedness** (richness differences)"),
          tags$li("Identify dominant **assembly processes**: dispersal limitation vs. environmental filtering"),
          tags$li("Compare **taxonomic, phylogenetic, functional, or temporal** beta diversity"),
          tags$li("Example: Is beta diversity driven by species replacement or nested subsets?")
        )
      ),
      
      # DATASET REQUIREMENTS INFO BOX
      div(style = "background: #1a3a2e; border-left: 4px solid #2e8b57; padding: 16px; margin-bottom: 20px; border-radius: 0 4px 4px 0;",
        h4(style = "color: #2e8b57; margin: 0 0 12px 0; font-size: 14px; font-weight: 600;",
           "📊 REQUIRED DATASETS"),
        div(style = "color: #cccccc; font-size: 13px; line-height: 1.6;",
          tags$ul(style = "margin: 0; padding-left: 20px;",
            tags$li(tags$strong("Standard/Taxonomic (Turnover & Nestedness):"), " Any dataset (Dune, Varespec, BCI)"),
            tags$li(tags$strong("Phylogenetic Beta Diversity:"), " Load ", tags$span(style = "color: #5fd38d; font-weight: 600;", "'Phylocom (6 sites + real phylogeny)'"), " from Data tab"),
            tags$li(tags$strong("Functional Beta Diversity:"), " Load ", tags$span(style = "color: #5fd38d; font-weight: 600;", "'Phylocom Traits (6 sites + functional traits)'"), " from Data tab"),
            tags$li(tags$strong("Temporal Beta Diversity:"), " Load ", tags$span(style = "color: #5fd38d; font-weight: 600;", "'BBS Birds (49 sites × 2 time periods)'"), " from Data tab")
          )
        )
      ),
      
      # Configuration Panel - Full Width at Top
      div(class = "config-panel", style = "background: #252526; padding: 20px; margin-bottom: 20px; border-radius: 4px;",
        h3(style = "color: #2e8b57; margin-bottom: 16px;", "⚙️ Beta Diversity Configuration"),
        
        fluidRow(
          column(3,
            # Data type
            selectInput(
              ns("data_type"),
              "Data Type:",
              choices = c(
                "Presence-Absence (Incidence)" = "incidence",
                "Abundance" = "abundance"
              ),
              selected = "incidence",
              selectize = FALSE
            )
          ),
          column(3,
            # Index family
            selectInput(
              ns("index_family"),
              "Beta Diversity Index:",
              choices = c(
                "Sørensen (Jaccard for abundance)" = "sorensen",
                "Jaccard" = "jaccard",
                "Bray-Curtis (abundance only)" = "bray"
              ),
              selected = "sorensen",
              selectize = FALSE
            )
          ),
          column(3,
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
              selectize = FALSE,
              selected = "standard"
            )
          ),
          column(3,
            # Run button
            div(style = "margin-top: 25px;",
              actionButton(
                ns("run_partition"),
                "▶ Run Partitioning",
                class = "btn-success",
                style = "width: 100%; padding: 10px;"
              )
            )
          )
        )
      ),
      
      # Interpretation box
      uiOutput(ns("partition_interpretation")),
      
      # Results Area - Three-panel horizontal layout
      div(style = "display: grid; grid-template-columns: 2fr 1fr; gap: 20px; margin-top: 20px;",
        # Left: Plots
        div(style = "max-width: 100%; overflow: hidden;",
          plotOutput(ns("beta_plot"), width = "100%", height = "600px")
        ),
        
        # Right: Statistics and Controls
        div(
          # Summary Statistics
          div(style = "background: #252526; padding: 16px; margin-bottom: 16px; border-radius: 4px;",
            h4(style = "color: #2e8b57; margin-top: 0; font-size: 14px; font-weight: 600;", "📊 COMPONENTS"),
            tableOutput(ns("beta_stats"))
          ),
          
          # Pairwise matrix summary
          div(style = "background: #252526; padding: 16px; margin-bottom: 16px; border-radius: 4px;",
            h4(style = "color: #2e8b57; margin-top: 0; font-size: 14px; font-weight: 600;", "🔢 SUMMARY"),
            tableOutput(ns("pairwise_summary"))
          ),
          
          # Plot Customization
          div(style = "background: #252526; padding: 16px; margin-bottom: 16px; border-radius: 4px;",
            h4(style = "color: #2e8b57; margin-top: 0; font-size: 14px; font-weight: 600;", "🎨 PLOT OPTIONS"),
            
            # Compact 3-row x 2-column layout
            fluidRow(
              column(6, selectInput(ns("plot_theme"), "Theme", 
                choices = c("Clean (bw)" = "bw", "Minimal" = "minimal", "Dark" = "dark", 
                           "Classic" = "classic", "Light" = "light"),
                selected = "bw", selectize = FALSE)),
              column(6, selectInput(ns("color_palette"), "Colors", 
                choices = c("Green-Gold-Red" = "default", "Blue-White-Red" = "bwr", 
                           "Viridis" = "viridis", "Spectral" = "spectral"),
                selected = "default", selectize = FALSE))
            ),
            fluidRow(
              column(6, numericInput(ns("base_size"), "Base Size", value = 12, min = 8, max = 20, step = 1)),
              column(6, numericInput(ns("title_size"), "Title Size", value = 14, min = 10, max = 24, step = 1))
            ),
            fluidRow(
              column(6, numericInput(ns("plot_width"), "Width (in)", value = 12, min = 4, max = 20, step = 1)),
              column(6, numericInput(ns("plot_height"), "Height (in)", value = 5, min = 3, max = 15, step = 1))
            )
          ),
          
          # Export Actions
          div(style = "background: #252526; padding: 16px; border-radius: 4px;",
            h4(style = "color: #2e8b57; margin-top: 0; font-size: 14px; font-weight: 600;", "💾 EXPORT"),
            div(style = "display: flex; flex-direction: column; gap: 8px;",
              downloadButton(ns("export_plot"), "📊 Plot (PDF)", class = "btn-sm", style = "width: 100%;"),
              downloadButton(ns("export_results"), "📋 Stats (CSV)", class = "btn-sm", style = "width: 100%;"),
              downloadButton(ns("export_matrices"), "🗂️ Matrices (ZIP)", class = "btn-sm", style = "width: 100%;")
            )
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
        style = "background: #2e8b5715; border-left: 4px solid #2e8b57; padding: 16px; margin-bottom: 16px; border-radius: 4px;",
        h4(style = "color: #2e8b57; margin-top: 0; font-size: 14px; font-weight: 600;",
           "📊 BETA DIVERSITY INTERPRETATION"),
        p(style = "color: #ccc; font-size: 13px; margin: 8px 0; line-height: 1.6;",
          HTML(generate_beta_interpretation(beta_result(), input$index_family)))
      )
    })
    
    # Render beta diversity plot
    output$beta_plot <- renderPlot({
      req(beta_result())
      
      # Observe plot customization inputs for reactivity
      input$plot_theme
      input$color_palette
      input$base_size
      input$title_size
      
      # Create multi-panel plot using ggplot2
      create_beta_plot(
        beta_result(), 
        input$index_family,
        theme = input$plot_theme,
        color_palette = input$color_palette,
        base_size = input$base_size,
        title_size = input$title_size
      )
    })
    
    # Beta diversity statistics
    output$beta_stats <- renderTable({
      req(beta_result())
      
      # Calculate mean values
      beta_total <- mean(as.dist(beta_result()[[1]]))
      turnover <- mean(as.dist(beta_result()[[2]]))
      nestedness <- mean(as.dist(beta_result()[[3]]))
      
      # Calculate additional statistics
      beta_total_sd <- sd(as.dist(beta_result()[[1]]))
      turnover_sd <- sd(as.dist(beta_result()[[2]]))
      nestedness_sd <- sd(as.dist(beta_result()[[3]]))
      
      data.frame(
        Component = c(
          paste0("β-total"),
          "Turnover",
          "Nestedness",
          "Turnover %"
        ),
        Mean = c(
          sprintf("%.4f", beta_total),
          sprintf("%.4f", turnover),
          sprintf("%.4f", nestedness),
          sprintf("%.1f%%", (turnover / beta_total) * 100)
        ),
        SD = c(
          sprintf("±%.4f", beta_total_sd),
          sprintf("±%.4f", turnover_sd),
          sprintf("±%.4f", nestedness_sd),
          ""
        ),
        stringsAsFactors = FALSE
      )
    }, 
    striped = TRUE,
    hover = TRUE,
    spacing = "xs",
    width = "100%")
    
    # Pairwise summary
    output$pairwise_summary <- renderTable({
      req(beta_result())
      
      n_sites <- nrow(data())
      n_pairs <- choose(n_sites, 2)
      
      # Get min/max values
      beta_total_vals <- as.dist(beta_result()[[1]])
      
      data.frame(
        Metric = c(
          "Sites",
          "Comparisons",
          "Min β",
          "Max β",
          "Index",
          "Type"
        ),
        Value = c(
          n_sites,
          n_pairs,
          sprintf("%.4f", min(beta_total_vals)),
          sprintf("%.4f", max(beta_total_vals)),
          tools::toTitleCase(input$index_family),
          tools::toTitleCase(input$partition_type)
        ),
        stringsAsFactors = FALSE
      )
    },
    striped = TRUE,
    hover = TRUE,
    spacing = "xs",
    width = "100%")
    
    # Export plot
    output$export_plot <- downloadHandler(
      filename = function() {
        sprintf("beta_diversity_%s_%s.%s", input$index_family, format(Sys.Date(), "%Y%m%d"), plot_defaults$export_format)
      },
      content = function(file) {
        p <- create_beta_plot(
          beta_result(), 
          input$index_family,
          theme = input$plot_theme,
          color_palette = input$color_palette,
          base_size = input$base_size,
          title_size = input$title_size
        )
        ggsave(
          file,
          plot = p,
          width = input$plot_width,
          height = input$plot_height,
          dpi = plot_defaults$dpi,
          device = plot_defaults$export_format
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
        
        beta_total_sd <- sd(as.dist(beta_result()[[1]]))
        turnover_sd <- sd(as.dist(beta_result()[[2]]))
        nestedness_sd <- sd(as.dist(beta_result()[[3]]))
        
        results <- data.frame(
          Component = c("Beta_Total", "Turnover", "Nestedness", "Turnover_Proportion"),
          Mean = c(beta_total, turnover, nestedness, turnover / beta_total),
          SD = c(beta_total_sd, turnover_sd, nestedness_sd, NA),
          Min = c(
            min(as.dist(beta_result()[[1]])),
            min(as.dist(beta_result()[[2]])),
            min(as.dist(beta_result()[[3]])),
            NA
          ),
          Max = c(
            max(as.dist(beta_result()[[1]])),
            max(as.dist(beta_result()[[2]])),
            max(as.dist(beta_result()[[3]])),
            NA
          ),
          Index = input$index_family,
          Analysis_Type = input$partition_type,
          Data_Type = input$data_type,
          N_Sites = nrow(data()),
          N_Comparisons = choose(nrow(data()), 2),
          Date = Sys.Date()
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
        tmpdir <- tempfile()
        dir.create(tmpdir)
        
        # Write matrices
        write.csv(as.matrix(beta_result()[[1]]), 
                 file.path(tmpdir, "beta_total.csv"))
        write.csv(as.matrix(beta_result()[[2]]), 
                 file.path(tmpdir, "turnover.csv"))
        write.csv(as.matrix(beta_result()[[3]]), 
                 file.path(tmpdir, "nestedness.csv"))
        
        # Create zip
        old_wd <- getwd()
        setwd(tmpdir)
        zip_files <- list.files(pattern = "\\.csv$")
        utils::zip(file, files = zip_files)
        setwd(old_wd)
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
#' @param theme Plot theme
#' @param color_palette Color palette choice
#' @param base_size Base font size
#' @param title_size Title font size
#' @return ggplot2 object (patchwork)
create_beta_plot <- function(beta_result, index_family, 
                            theme = "bw", color_palette = "default",
                            base_size = 12, title_size = 14) {
  library(reshape2)
  library(patchwork)
  
  # Convert matrices to data frames
  beta_total_df <- melt(as.matrix(beta_result[[1]]))
  turnover_df <- melt(as.matrix(beta_result[[2]]))
  nestedness_df <- melt(as.matrix(beta_result[[3]]))
  
  # Select color palette
  if (color_palette == "bwr") {
    low_color <- "#2166ac"
    mid_color <- "#f7f7f7"
    high_color <- "#b2182b"
  } else if (color_palette == "viridis") {
    # Will use scale_fill_viridis
    low_color <- NULL
    mid_color <- NULL
    high_color <- NULL
  } else if (color_palette == "spectral") {
    low_color <- "#5e4fa2"
    mid_color <- "#ffffbf"
    high_color <- "#9e0142"
  } else {  # default
    low_color <- "#2e8b57"
    mid_color <- "#ffd700"
    high_color <- "#dc143c"
  }
  
  # Create base theme
  plot_theme <- switch(theme,
    "bw" = theme_bw(base_size = base_size),
    "minimal" = theme_minimal(base_size = base_size),
    "dark" = theme_dark(base_size = base_size),
    "classic" = theme_classic(base_size = base_size),
    "light" = theme_light(base_size = base_size),
    theme_bw(base_size = base_size)
  )
  
  # Apply theme-specific customizations
  if (theme == "dark") {
    # Dark theme gets dark backgrounds
    plot_theme <- plot_theme +
      theme(
        plot.title = element_text(color = "#2e8b57", size = title_size, face = "bold", hjust = 0.5),
        axis.text.x = element_text(angle = 45, hjust = 1),
        plot.background = element_rect(fill = "#1e1e1e", color = NA),
        panel.background = element_rect(fill = "#252526"),
        legend.background = element_rect(fill = "#252526"),
        legend.text = element_text(color = "#cccccc"),
        legend.title = element_text(color = "#cccccc"),
        axis.text = element_text(color = "#cccccc"),
        axis.title = element_text(color = "#cccccc"),
        panel.grid.major = element_line(color = "#3c3c3c"),
        panel.grid.minor = element_line(color = "#2d2d2d")
      )
  } else {
    # Light themes get minimal customization
    plot_theme <- plot_theme +
      theme(
        plot.title = element_text(color = "#2e8b57", size = title_size, face = "bold", hjust = 0.5),
        axis.text.x = element_text(angle = 45, hjust = 1)
      )
  }
  
  # Create scale function
  create_fill_scale <- function() {
    if (color_palette == "viridis") {
      scale_fill_viridis_c(limits = c(0, 1), option = "viridis")
    } else {
      scale_fill_gradient2(
        low = low_color, 
        mid = mid_color, 
        high = high_color,
        midpoint = 0.5, 
        limits = c(0, 1)
      )
    }
  }
  
  # Determine tile border color based on theme
  tile_border <- if (theme == "dark") "#1e1e1e" else "#ffffff"
  
  # Plot 1: Beta total
  p1 <- ggplot(beta_total_df, aes(x = Var1, y = Var2, fill = value)) +
    geom_tile(color = tile_border, linewidth = 0.5) +
    create_fill_scale() +
    labs(title = paste0("β-Total (", index_family, ")"),
         x = NULL, y = NULL, fill = "Dissimilarity") +
    plot_theme +
    coord_fixed()
  
  # Plot 2: Turnover
  p2 <- ggplot(turnover_df, aes(x = Var1, y = Var2, fill = value)) +
    geom_tile(color = tile_border, linewidth = 0.5) +
    create_fill_scale() +
    labs(title = "Turnover Component",
         x = NULL, y = NULL, fill = "Turnover") +
    plot_theme +
    coord_fixed()
  
  # Plot 3: Nestedness
  p3 <- ggplot(nestedness_df, aes(x = Var1, y = Var2, fill = value)) +
    geom_tile(color = tile_border, linewidth = 0.5) +
    create_fill_scale() +
    labs(title = "Nestedness Component",
         x = NULL, y = NULL, fill = "Nestedness") +
    plot_theme +
    coord_fixed()
  
  # Combine plots using patchwork with theme-appropriate annotation
  annotation_bg <- if (theme == "dark") "#1e1e1e" else "white"
  
  combined_plot <- p1 + p2 + p3 + 
    plot_layout(ncol = 3) +
    plot_annotation(
      title = "Beta Diversity Partitioning",
      theme = theme(
        plot.title = element_text(size = title_size + 2, face = "bold", hjust = 0.5, color = "#2e8b57"),
        plot.background = element_rect(fill = annotation_bg, color = NA)
      )
    )
  
  return(combined_plot)
}
