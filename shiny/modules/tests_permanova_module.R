# Ördin - PERMANOVA Module
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Permutational Multivariate Analysis of Variance (PERMANOVA) using adonis2

library(shiny)
library(vegan)
library(waiter)

#' PERMANOVA Module UI
permanova_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(class = "permanova-workflow",
      div(class = "config-panel",
        h3("⚙️ PERMANOVA Configuration"),
        
        helpText("Tests if group centroids differ across environmental/categorical variables (multivariate ANOVA using distances)."),
        
        # Distance metric
        selectInput(ns("distance"), "Distance/Dissimilarity:",
                   choices = c("Bray-Curtis" = "bray", "Jaccard" = "jaccard", 
                              "Euclidean" = "euclidean", "Manhattan" = "manhattan"),
                   selected = "bray"),
        
        # Grouping variable selection
        uiOutput(ns("group_vars_ui")),
        
        # Permutation settings
        numericInput(ns("permutations"), "Permutations:", value = 999, min = 99, max = 9999, step = 100),
        
        selectInput(ns("method"), "Permutation Method:",
                   choices = c("Unrestricted" = "free", "Within strata" = "strata"),
                   selected = "free"),
        
        # Run button
        div(class = "action-buttons", style = "margin-top: 20px;",
          actionButton(ns("run_permanova"), "▶ Run PERMANOVA", class = "btn-success", style = "width: 100%;")
        )
      ),
      
      div(class = "horizontal-split",
        div(class = "plot-panel",
          # Interpretation box
          uiOutput(ns("permanova_interpretation")),
          
          # Results visualization
          h4("📊 Variance Partitioning", style = "color: #2e8b57; margin: 20px 0 10px 0;"),
          plotOutput(ns("variance_plot"), height = "400px")
        ),
        
        div(class = "results-panel",
          div(class = "results-section",
            h3("📊 PERMANOVA TABLE"),
            tableOutput(ns("permanova_table"))
          ),
          
          div(class = "results-section", style = "margin-top: 20px;",
            h3("📈 R-SQUARED VALUES"),
            tableOutput(ns("r2_table"))
          ),
          
          div(class = "action-buttons", style = "margin-top: 20px;",
            downloadButton(ns("export_results"), "📋 Export CSV", class = "btn-sm")
          )
        )
      )
    )
  )
}

#' PERMANOVA Module Server
permanova_server <- function(id, data, env_data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    permanova_result <- reactiveVal(NULL)
    
    # Dynamic UI for grouping variable selection
    output$group_vars_ui <- renderUI({
      req(env_data())
      
      # Detect categorical/factor variables
      categorical_vars <- names(env_data())[sapply(env_data(), function(x) is.factor(x) || is.character(x))]
      
      if (length(categorical_vars) == 0) {
        div(style = "background: #d4a01720; border-left: 3px solid #d4a017; padding: 12px; margin: 10px 0;",
          p(style = "color: #d4a017; font-size: 12px; margin: 0;",
            "⚠️ No categorical variables found. PERMANOVA requires at least one grouping factor.")
        )
      } else {
        selectInput(ns("group_vars"), 
                   "Grouping Variables:",
                   choices = categorical_vars,
                   selected = categorical_vars[1],
                   multiple = TRUE)
      }
    })
    
    # Run PERMANOVA
    observeEvent(input$run_permanova, {
      req(data(), env_data(), input$group_vars)
      
      waiter_show(html = tagList(
        spin_fading_circles(),
        h3("Running PERMANOVA...", style = "color: #2e8b57; margin-top: 20px;")
      ))
      
      result <- tryCatch({
        # Build formula
        formula_str <- paste("data() ~", paste(input$group_vars, collapse = " + "))
        formula_obj <- as.formula(formula_str)
        
        # Run adonis2
        adonis2(formula_obj, 
               data = env_data(), 
               permutations = input$permutations,
               method = input$distance)
      }, error = function(e) {
        waiter_hide()
        showNotification(paste("❌ PERMANOVA failed:", e$message), type = "error")
        NULL
      })
      
      waiter_hide()
      
      if (!is.null(result)) {
        permanova_result(result)
        
        # Get main effect p-value
        p_value <- result$`Pr(>F)`[1]
        
        significance <- if(p_value < 0.001) "***"
        else if(p_value < 0.01) "**"
        else if(p_value < 0.05) "*"
        else "ns"
        
        showNotification(
          HTML(sprintf("<strong>✓ PERMANOVA Complete!</strong><br/>p-value: %.4f %s", p_value, significance)),
          type = if(p_value < 0.05) "message" else "warning"
        )
      }
    })
    
    # Interpretation box
    output$permanova_interpretation <- renderUI({
      req(permanova_result())
      
      p_value <- permanova_result()$`Pr(>F)`[1]
      r2 <- permanova_result()$R2[1]
      
      color <- if(p_value < 0.05) "#2e8b57" else "#888"
      result_text <- if(p_value < 0.05) "Significant difference" else "No significant difference"
      
      HTML(sprintf('
        <div style="background: %s20; border-left: 3px solid %s; padding: 16px; margin: 20px 0;">
          <h4 style="color: %s; margin: 0 0 8px 0;">%s (p = %.4f)</h4>
          <p style="color: #ccc; font-size: 12px;">Groups explain %.1f%% of community variation (R-squared = %.4f)</p>
        </div>
      ', color, color, color, result_text, p_value, r2 * 100, r2))
    })
    
    # PERMANOVA table
    output$permanova_table <- renderTable({
      req(permanova_result())
      
      df <- as.data.frame(permanova_result())
      df$Source <- rownames(df)
      df <- df[, c("Source", "Df", "SumOfSqs", "R2", "F", "Pr(>F)")]
      names(df) <- c("Source", "Df", "Sum of Squares", "R-squared", "F-value", "p-value")
      
      # Format numbers
      df$`Sum of Squares` <- sprintf("%.4f", df$`Sum of Squares`)
      df$`R-squared` <- sprintf("%.4f", df$`R-squared`)
      df$`F-value` <- sprintf("%.4f", df$`F-value`)
      df$`p-value` <- ifelse(is.na(df$`p-value`), "", sprintf("%.4f", df$`p-value`))
      
      df
    }, rownames = FALSE)
    
    # R² table
    output$r2_table <- renderTable({
      req(permanova_result())
      
      r2_vals <- permanova_result()$R2
      data.frame(
        Component = rownames(permanova_result()),
        `R-squared Value` = sprintf("%.4f", r2_vals),
        `Explained Percent` = sprintf("%.2f%%", r2_vals * 100),
        check.names = FALSE
      )
    })
    
    # Variance partitioning plot
    output$variance_plot <- renderPlot({
      req(permanova_result())
      
      r2_vals <- permanova_result()$R2
      labels <- rownames(permanova_result())
      
      # Create bar plot
      par(family = "sans", bg = "#252526", fg = "#cccccc", col.axis = "#cccccc",
          col.lab = "#cccccc", col.main = "#2e8b57", mar = c(5, 10, 4, 2))
      
      barplot(r2_vals * 100, horiz = TRUE, las = 1, 
              names.arg = labels,
              col = c(rep("#2e8b57", length(r2_vals)-1), "#888888"),
              border = NA,
              xlab = "Variance Explained (%)",
              main = "PERMANOVA Variance Partitioning",
              xlim = c(0, max(r2_vals * 100) * 1.2))
      
      grid(col = "#404040", lty = 1)
    })
    
    # Export results
    output$export_results <- downloadHandler(
      filename = function() paste0("permanova_results_", Sys.Date(), ".csv"),
      content = function(file) {
        df <- as.data.frame(permanova_result())
        df$Source <- rownames(df)
        write.csv(df, file, row.names = FALSE)
      }
    )
  })
}
