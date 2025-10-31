# Ördin - Mantel Test & envfit Module
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Mantel test: correlates two distance matrices
# envfit: fits environmental vectors/factors onto ordination

library(shiny)
library(vegan)
library(waiter)

#' Mantel & envfit Module UI
mantel_envfit_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(class = "mantel-envfit-workflow",
      selectInput(ns("test_type"), "Analysis Type:",
                 choices = c("Mantel Test" = "mantel", "Environmental Fitting (envfit)" = "envfit"),
                 selected = "mantel"),
      
      # Mantel Test Panel
      conditionalPanel(
        condition = sprintf("input['%s'] == 'mantel'", ns("test_type")),
        div(class = "config-panel",
          h3("⚙️ Mantel Test Configuration"),
          
          # When to use Mantel Test
          div(style = "background: #4a90e220; border-left: 3px solid #4a90e2; padding: 12px; margin-bottom: 16px;",
            h4(style = "color: #4a90e2; margin: 0 0 8px 0; font-size: 13px; font-weight: 600;", "📘 WHEN TO USE MANTEL TEST"),
            tags$ul(style = "color: #ccc; font-size: 11px; margin: 0; padding-left: 20px; line-height: 1.6;",
              tags$li("Test **correlation between two distance matrices**"),
              tags$li("Example: Does **species distance** correlate with **environmental distance**?"),
              tags$li("r close to **1** = strong positive correlation"),
              tags$li("Useful for **spatial autocorrelation** analysis")
            )
          ),
          
          helpText("Tests correlation between two distance/dissimilarity matrices."),
          
          selectInput(ns("distance1"), "Species Distance:",
                     choices = c("Bray-Curtis" = "bray", "Euclidean" = "euclidean"),
                     selected = "bray"),
          
          selectInput(ns("distance2"), "Environmental Distance:",
                     choices = c("Euclidean" = "euclidean", "Manhattan" = "manhattan"),
                     selected = "euclidean"),
          
          numericInput(ns("mantel_perm"), "Permutations:", value = 999, min = 99, max = 9999),
          
          div(class = "action-buttons", style = "margin-top: 20px;",
            actionButton(ns("run_mantel"), "▶ Run Mantel Test", class = "btn-success", style = "width: 100%;")
          )
        ),
        
        div(class = "horizontal-split",
          div(class = "plot-panel", style = "max-width: 100%; overflow: hidden;",
            uiOutput(ns("mantel_interpretation")),
            plotOutput(ns("mantel_plot"), width = "100%", height = "400px")
          ),
          
          div(class = "results-panel",
            div(class = "results-section",
              h3("📊 MANTEL RESULTS"),
              tableOutput(ns("mantel_table"))
            )
          )
        )
      ),
      
      # envfit Panel
      conditionalPanel(
        condition = sprintf("input['%s'] == 'envfit'", ns("test_type")),
        div(class = "config-panel",
          h3("⚙️ envfit Configuration"),
          
          # When to use envfit
          div(style = "background: #4a90e220; border-left: 3px solid #4a90e2; padding: 12px; margin-bottom: 16px;",
            h4(style = "color: #4a90e2; margin: 0 0 8px 0; font-size: 13px; font-weight: 600;", "📘 WHEN TO USE ENVFIT"),
            tags$ul(style = "color: #ccc; font-size: 11px; margin: 0; padding-left: 20px; line-height: 1.6;",
              tags$li("Fit **environmental vectors/surfaces** onto ordination plot"),
              tags$li("Visualize which **env variables drive patterns** in community"),
              tags$li("Shows **direction & strength** of environmental gradients"),
              tags$li("Example: Which factors (pH, temp) correlate with NMDS axes?")
            )
          ),
          
          helpText("Fits environmental variables as vectors/surfaces onto ordination."),
          
          div(style = "background: #d4a01720; border-left: 3px solid #d4a017; padding: 12px; margin: 10px 0;",
            p(style = "color: #d4a017; font-size: 12px; margin: 0;",
              "⚠️ Run an ordination first (NMDS, PCA, etc.), then use envfit to overlay environmental vectors.")
          ),
          
          uiOutput(ns("env_vars_ui")),
          
          numericInput(ns("envfit_perm"), "Permutations:", value = 999, min = 99, max = 9999),
          
          div(class = "action-buttons", style = "margin-top: 20px;",
            actionButton(ns("run_envfit"), "▶ Fit Env Vectors", class = "btn-success", style = "width: 100%;")
          )
        ),
        
        div(class = "horizontal-split",
          div(class = "plot-panel", style = "max-width: 100%; overflow: hidden;",
            uiOutput(ns("envfit_interpretation")),
            plotOutput(ns("envfit_plot"), width = "100%", height = "500px")
          ),
          
          div(class = "results-panel",
            div(class = "results-section",
              h3("📊 ENVFIT RESULTS"),
              tableOutput(ns("envfit_table"))
            )
          )
        )
      )
    )
  )
}

#' Mantel & envfit Module Server
mantel_envfit_server <- function(id, data, env_data, ordination_result = NULL) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    mantel_result <- reactiveVal(NULL)
    envfit_result <- reactiveVal(NULL)
    
    # Mantel Test
    observeEvent(input$run_mantel, {
      req(data(), env_data())
      
      waiter_show(html = tagList(spin_fading_circles(), h3("Running Mantel Test...", style = "color: #2e8b57; margin-top: 20px;")))
      
      result <- tryCatch({
        dist1 <- vegdist(data(), method = input$distance1)
        dist2 <- vegdist(env_data(), method = input$distance2)
        mantel(dist1, dist2, permutations = input$mantel_perm)
      }, error = function(e) {
        waiter_hide()
        showNotification(paste("❌ Mantel test failed:", e$message), type = "error")
        NULL
      })
      
      waiter_hide()
      
      if (!is.null(result)) {
        mantel_result(result)
        showNotification(HTML(sprintf("<strong>✓ Mantel Test Complete!</strong><br/>r = %.4f, p = %.4f", result$statistic, result$signif)), type = "message")
      }
    })
    
    output$mantel_interpretation <- renderUI({
      req(mantel_result())
      r_stat <- mantel_result()$statistic
      p_value <- mantel_result()$signif
      
      color <- if(p_value < 0.05 && abs(r_stat) > 0.5) "#2e8b57" else if(p_value < 0.05) "#d4a017" else "#888"
      strength <- if(abs(r_stat) > 0.7) "Strong" else if(abs(r_stat) > 0.4) "Moderate" else "Weak"
      
      HTML(sprintf('<div style="background: %s20; border-left: 3px solid %s; padding: 16px; margin: 20px 0;">
        <h4 style="color: %s; margin: 0 0 8px 0;">%s correlation (r = %.4f, p = %.4f)</h4>
        <p style="color: #ccc; font-size: 12px;">Mantel r ranges from -1 to +1</p>
      </div>', color, color, color, strength, r_stat, p_value))
    })
    
    output$mantel_table <- renderTable({
      req(mantel_result())
      data.frame(
        Statistic = "Mantel r",
        Value = sprintf("%.4f", mantel_result()$statistic),
        `p-value` = sprintf("%.4f", mantel_result()$signif),
        Permutations = mantel_result()$permutations,
        check.names = FALSE
      )
    })
    
    output$mantel_plot <- renderPlot({
      req(mantel_result())
      
      # Create scatter plot of distance matrices
      dist1 <- vegdist(data(), method = input$distance1)
      dist2 <- vegdist(env_data(), method = input$distance2)
      
      par(family = "sans", bg = "#252526", fg = "#cccccc", 
          col.axis = "#cccccc", col.lab = "#cccccc", col.main = "#2e8b57",
          mar = c(5, 4, 4, 2))  # Standard margins
      
      plot(as.vector(dist1), as.vector(dist2),
           xlab = paste(input$distance1, "distance (species)"),
           ylab = paste(input$distance2, "distance (environment)"),
           main = "Mantel Test: Distance-Distance Correlation",
           pch = 21, bg = "#2e8b5760", col = "#2e8b57", cex = 1.2)
      
      abline(lm(as.vector(dist2) ~ as.vector(dist1)), col = "#d4a017", lwd = 2)
      grid(col = "#404040", lty = 1)
      
      legend("topleft", 
             legend = sprintf("r = %.4f\np = %.4f", mantel_result()$statistic, mantel_result()$signif),
             bty = "n", text.col = "#2e8b57", cex = 1.0)
    }, res = 96)
    
    # envfit
    output$env_vars_ui <- renderUI({
      req(env_data())
      selectInput(ns("env_vars"), "Environmental Variables:",
                 choices = names(env_data()),
                 selected = names(env_data()),
                 multiple = TRUE)
    })
    
    observeEvent(input$run_envfit, {
      req(data(), env_data(), input$env_vars)
      
      waiter_show(html = tagList(spin_fading_circles(), h3("Fitting Environmental Vectors...", style = "color: #2e8b57; margin-top: 20px;")))
      
      result <- tryCatch({
        # Run simple NMDS first if no ordination provided
        ord <- metaMDS(data(), distance = "bray", trymax = 20, trace = 0)
        env_subset <- env_data()[, input$env_vars, drop = FALSE]
        envfit(ord, env_subset, permutations = input$envfit_perm)
      }, error = function(e) {
        waiter_hide()
        showNotification(paste("❌ envfit failed:", e$message), type = "error")
        NULL
      })
      
      waiter_hide()
      
      if (!is.null(result)) {
        envfit_result(result)
        showNotification(HTML("<strong>✓ envfit Complete!</strong>"), type = "message")
      }
    })
    
    output$envfit_interpretation <- renderUI({
      req(envfit_result())
      
      HTML('<div style="background: #2e8b5720; border-left: 3px solid #2e8b57; padding: 16px; margin: 20px 0;">
        <h4 style="color: #2e8b57; margin: 0 0 8px 0;">Environmental vectors fitted</h4>
        <p style="color: #ccc; font-size: 12px;">Arrows show direction & strength of environmental gradients</p>
      </div>')
    })
    
    output$envfit_table <- renderTable({
      req(envfit_result())
      
      # Extract vectors
      vec_df <- as.data.frame(envfit_result()$vectors$r)
      vec_df$Variable <- rownames(vec_df)
      vec_df$`R-squared` <- envfit_result()$vectors$r
      vec_df$`p-value` <- envfit_result()$vectors$pvals
      
      vec_df <- vec_df[, c("Variable", "R-squared", "p-value")]
      vec_df$`R-squared` <- sprintf("%.4f", vec_df$`R-squared`)
      vec_df$`p-value` <- sprintf("%.4f", vec_df$`p-value`)
      
      vec_df
    }, rownames = FALSE)
    
    output$envfit_plot <- renderPlot({
      req(envfit_result())
      
      ord <- metaMDS(data(), distance = "bray", trymax = 20, trace = 0)
      
      par(family = "sans", bg = "#252526", fg = "#cccccc", 
          col.axis = "#cccccc", col.lab = "#cccccc", col.main = "#2e8b57",
          mar = c(5, 4, 4, 2))  # Standard margins
      
      plot(ord, type = "n", main = "envfit: Environmental Vectors on NMDS")
      points(ord, pch = 21, bg = "#2e8b5760", col = "#2e8b57", cex = 1.5)
      plot(envfit_result(), col = "#d4a017", lwd = 2, cex = 0.8)
      grid(col = "#404040", lty = 1)
    }, res = 96)
  })
}
