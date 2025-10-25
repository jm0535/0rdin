# Proof-of-Concept: NMDS Workflow Migration

**Author:** Jimmy Moses (jmoses@pnguot.ac.pg)  
**Date:** 2025-10-25  
**Status:** IN PROGRESS - Foundation Complete

---

## 🎯 Goal

Migrate NMDS workflow from prototype to production as a proof-of-concept for the full refactoring process.

---

## ✅ Completed Steps

### 1. Directory Structure Created
```
shiny/
├── modules/     ✅ Created (empty, ready for modules)
├── utils/       ✅ Created
│   ├── interpretation.R  ✅ 252 lines (statistical interpretation)
│   └── validation.R      ✅ 244 lines (input validation)
└── www/         ✅ Updated
    ├── custom.css ✅ Copied from prototype (prototype-styles.css)
    ├── validation.js ✅ Copied from prototype
    ├── statistical-interpretation.js ✅ Copied from prototype
    └── about-ordin-content.js ✅ Copied from prototype
```

### 2. Utilities Ported from Prototype

#### interpretation.R (R port of statistical-interpretation.js)
**Functions:**
- ✅ `interpretNMDSStress(stress)` - Clarke (1993) guidelines
- ✅ `generateStressInterpretationHTML(stress)` - HTML box generation
- ✅ `interpretPERMANOVA(pValue, rSquared)` - Cohen (1988) effect sizes
- ✅ `generatePERMANOVAInterpretationHTML(pValue, rSquared)` - HTML generation
- ✅ `interpretRSquared(rSquared, context)` - Variance explained

**Example Usage in Shiny:**
```r
# In server logic after NMDS calculation
nmds_result <- metaMDS(data, distance = "bray", k = 2)
stress <- nmds_result$stress

# Generate interpretation
interpretation_html <- generateStressInterpretationHTML(stress)

# Display in UI
output$nmds_interpretation <- renderUI({
  interpretation_html
})
```

#### validation.R (R port of validation.js)
**Functions:**
- ✅ `validateConfidenceLevel(value)` - 0-1 range, warns if outside 0.5-0.999
- ✅ `validateKnots(value)` - 10-100 range, warns if < 20 or > 60
- ✅ `validateDimensions(value)` - 1-6 range, warns if > 3
- ✅ `validatePermutations(value)` - 99-9999 range, recommends 999+
- ✅ `validateSampleSize(sampleSize)` - Warns if < 10, errors if < 3
- ✅ `showValidationFeedback(session, inputId, validation)` - Shiny integration

**Example Usage in Shiny:**
```r
# In server logic
observeEvent(input$nmds_dimensions, {
  validation <- validateDimensions(input$nmds_dimensions)
  showValidationFeedback(session, "nmds_dimensions", validation)
  
  if (!validation$valid) {
    # Prevent analysis from running
    shinyjs::disable("run_nmds_button")
  } else {
    shinyjs::enable("run_nmds_button")
  }
})
```

### 3. Files Copied from Prototype

All prototype assets are now in `shiny/www/`:
- ✅ `custom.css` (561 lines) - VS Code styling + accessibility fixes
- ✅ `validation.js` (376 lines) - Client-side validation
- ✅ `statistical-interpretation.js` (308 lines) - JavaScript interpretation
- ✅ `about-ordin-content.js` (196 lines) - About Ördin content

---

## 📋 Next Steps for POC

### Step 3: Create NMDS Module (NEXT)

**File:** `shiny/modules/ordination_nmds_module.R`

**Contents:**
```r
# NMDS Module UI
nmds_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Use prototype CSS classes
    div(class = "nmds-workflow",
      # Configuration Panel
      div(class = "workflow-section",
        h3("NMDS Configuration"),
        
        # Distance Metric
        selectInput(ns("distance"), "Distance Metric:",
          choices = c("Bray-Curtis" = "bray",
                     "Jaccard" = "jaccard",
                     "Euclidean" = "euclidean")),
        
        # Dimensions (with validation)
        numericInput(ns("k"), "Dimensions (k):",
          value = 2, min = 1, max = 6),
        
        # Permutations (with validation)
        numericInput(ns("permutations"), "Permutations:",
          value = 999, min = 99, max = 9999),
        
        # Run Button
        actionButton(ns("run_nmds"), "▶ Run NMDS Analysis",
          class = "btn-primary")
      ),
      
      # Results Display (70% plot + 30% results like prototype)
      conditionalPanel(
        condition = "output.nmds_complete",
        div(class = "horizontal-split",
          # Plot Panel (70%)
          div(class = "plot-panel",
            # Stress interpretation box
            uiOutput(ns("stress_interpretation")),
            plotOutput(ns("nmds_plot"), height = "500px"),
            # Plot controls
            div(class = "plot-controls",
              downloadButton(ns("export_plot"), "💾 Export PNG")
            )
          ),
          
          # Results Panel (30%)
          div(class = "results-panel",
            # Ordination Statistics
            div(class = "results-section",
              h3("ORDINATION STATISTICS"),
              tableOutput(ns("nmds_stats"))
            ),
            
            # PERMANOVA Results (if env data loaded)
            conditionalPanel(
              condition = "output.has_env_data",
              div(class = "results-section",
                # PERMANOVA interpretation box
                uiOutput(ns("permanova_interpretation")),
                h3("PERMANOVA RESULTS"),
                tableOutput(ns("permanova_stats"))
              )
            ),
            
            # Export Actions
            div(class = "action-buttons",
              downloadButton(ns("export_results"), "📋 Export Results (CSV)"),
              downloadButton(ns("export_report"), "📄 Generate Report (PDF)")
            )
          )
        )
      )
    )
  )
}

# NMDS Module Server
nmds_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Source utilities
    source("utils/validation.R", local = TRUE)
    source("utils/interpretation.R", local = TRUE)
    
    # Reactive values
    nmds_result <- reactiveVal(NULL)
    
    # Validate dimensions
    observeEvent(input$k, {
      validation <- validateDimensions(input$k)
      showValidationFeedback(session, "k", validation)
    })
    
    # Validate permutations
    observeEvent(input$permutations, {
      validation <- validatePermutations(input$permutations)
      showValidationFeedback(session, "permutations", validation)
    })
    
    # Run NMDS
    observeEvent(input$run_nmds, {
      req(data())
      
      # Validate sample size
      sample_validation <- validateSampleSize(nrow(data()))
      if (!sample_validation$valid) {
        showNotification(sample_validation$message, type = "error")
        return()
      }
      
      # Show loading
      waiter_show(html = tagList(
        spin_loaders(42, color = "#2e8b57"),
        h3("Running NMDS Analysis...", style = "color: #2e8b57;")
      ))
      
      # Run NMDS
      result <- tryCatch({
        metaMDS(data(), 
               distance = input$distance,
               k = input$k,
               trymax = 20,
               trace = FALSE)
      }, error = function(e) {
        waiter_hide()
        showNotification(paste("NMDS failed:", e$message), type = "error")
        NULL
      })
      
      waiter_hide()
      
      if (!is.null(result)) {
        nmds_result(result)
        
        # Show success notification with stress
        showNotification(
          sprintf("NMDS complete! Stress = %.3f", result$stress),
          type = "message",
          duration = 5
        )
      }
    })
    
    # Generate stress interpretation
    output$stress_interpretation <- renderUI({
      req(nmds_result())
      generateStressInterpretationHTML(nmds_result()$stress)
    })
    
    # Plot NMDS
    output$nmds_plot <- renderPlot({
      req(nmds_result())
      
      # Create ordination plot
      ordiplot(nmds_result(), type = "none", main = "NMDS Ordination")
      points(nmds_result(), display = "sites", pch = 21,
             bg = "#2e8b57", cex = 2)
      
      # Add stress annotation
      stress_text <- sprintf("Stress = %.3f", nmds_result()$stress)
      mtext(stress_text, side = 3, line = 0.5, col = "#2e8b57",
            font = 2, adj = 0)
    })
    
    # NMDS Statistics Table
    output$nmds_stats <- renderTable({
      req(nmds_result())
      
      data.frame(
        Statistic = c("Stress", "Convergence", "Dimensions", 
                     "Distance", "Iterations"),
        Value = c(
          sprintf("%.3f", nmds_result()$stress),
          if(nmds_result()$converged) "✓ Converged" else "✗ Not converged",
          input$k,
          input$distance,
          nmds_result()$iters
        )
      )
    })
    
    # Export plot
    output$export_plot <- downloadHandler(
      filename = function() {
        paste0("nmds_plot_", Sys.Date(), ".png")
      },
      content = function(file) {
        png(file, width = 2400, height = 1800, res = 300)
        ordiplot(nmds_result(), type = "none", main = "NMDS Ordination")
        points(nmds_result(), display = "sites", pch = 21,
               bg = "#2e8b57", cex = 2)
        dev.off()
      }
    )
  })
}
```

### Step 4: Integrate into Main App

**Modify app.R:**
```r
# At top of file
source("modules/ordination_nmds_module.R")
source("utils/validation.R")
source("utils/interpretation.R")

# In UI
navbarPage(
  "Ördin",
  theme = bslib::bs_theme(version = 5),
  
  # Link CSS/JS from prototype
  tags$head(
    tags$link(rel = "stylesheet", href = "custom.css"),
    tags$script(src = "validation.js"),
    tags$script(src = "statistical-interpretation.js")
  ),
  
  # NMDS Tab
  tabPanel("Ordination",
    layout_sidebar(
      sidebar = sidebar(
        # Ordination methods list
        actionButton("nmds_btn", "🗺️ NMDS")
      ),
      # Main content area
      nmds_ui("nmds_module")
    )
  )
)

# In Server
server <- function(input, output, session) {
  # Call NMDS module
  nmds_server("nmds_module", data = reactive(current_data()))
}
```

### Step 5: Test POC

**Test Checklist:**
- [ ] NMDS runs successfully
- [ ] Stress interpretation appears
- [ ] Stress value is correct (matches Clarke 1993)
- [ ] Validation works (dimensions, permutations)
- [ ] Plot displays correctly
- [ ] Results table shows stats
- [ ] Export works (PNG download)
- [ ] Layout matches prototype (70/30 split)

---

## 🎨 Visual Verification

**Expected Output:**

```
┌──────────────────────────────────────────────────────────┐
│ ┌─ Stress Interpretation Box (Green/Amber/Red) ────────┐ │
│ │ Good representation (stress < 0.10) [Grade: A]       │ │
│ │ The configuration is usable...                       │ │
│ │ 📌 Recommendation: Interpretation is reliable...     │ │
│ └──────────────────────────────────────────────────────┘ │
│                                                          │
│ ┌────────────────────┐  ┌──────────────────────────┐    │
│ │                    │  │ ORDINATION STATISTICS    │    │
│ │   NMDS Plot        │  │ Stress: 0.089            │    │
│ │   (70% width)      │  │ Convergence: ✓ Converged │    │
│ │                    │  │ Dimensions: 2            │    │
│ │   [Stress = 0.089] │  │                          │    │
│ │                    │  │ [📋 Export Results]      │    │
│ │   [💾 Export PNG]  │  │ [📄 Generate Report]     │    │
│ └────────────────────┘  └──────────────────────────┘    │
└──────────────────────────────────────────────────────────┘
```

---

## 📊 Success Metrics

### Code Quality
- ✅ Modular structure (separate R files)
- ✅ Validation utilities (244 lines, reusable)
- ✅ Interpretation utilities (252 lines, reusable)
- ✅ No code duplication
- ✅ Well-documented functions

### Feature Parity with Prototype
- ⏳ NMDS workflow functional (Next step)
- ⏳ Stress interpretation displays (Next step)
- ⏳ 70/30 layout preserved (Next step)
- ⏳ Validation active (Next step)
- ✅ CSS/JS files copied
- ✅ Utilities ported to R

### Quality
- ✅ R functions match JS logic
- ✅ Scientific accuracy preserved
- ✅ Citations included
- ⏳ User testing (After integration)

---

## 🚀 What's Working Now

1. **✅ Utilities Ready**
   - Statistical interpretation (R + JS)
   - Input validation (R + JS)
   - Both tested and documented

2. **✅ Assets Copied**
   - All prototype CSS in www/custom.css
   - All prototype JS in www/
   - Ready to use in Shiny

3. **✅ Foundation Complete**
   - Directory structure created
   - Module pattern established
   - Integration path clear

---

## 📝 Next Actions

**Immediate (Day 1):**
1. Create `modules/ordination_nmds_module.R` (template above)
2. Test module in isolation
3. Integrate into simplified app.R
4. Verify stress interpretation displays

**Short-term (Days 2-3):**
5. Add PERMANOVA interpretation
6. Implement export functionality
7. Polish UI to match prototype exactly
8. User testing

**Medium-term (Week 2):**
9. Use this module as template for other ordinations (PCA, CA, etc.)
10. Replicate pattern for diversity modules
11. Continue full refactoring

---

## 🎓 Lessons Learned

### What Works Well
- ✅ R port of JS functions is straightforward
- ✅ Utilities are highly reusable
- ✅ Module pattern fits Shiny well
- ✅ Prototype provides excellent blueprint

### Challenges
- ⚠️ HTML generation in R (sprintf) is verbose
- ⚠️ Shiny + custom CSS needs careful integration
- ⚠️ Testing requires full app context

### Best Practices Established
- ✅ One module per analysis method
- ✅ Shared utilities in utils/
- ✅ CSS/JS external in www/
- ✅ Validation before computation
- ✅ Interpretation after results

---

**Status:** Foundation complete, ready for module creation! 🎉

**Next Step:** Create `ordination_nmds_module.R` and integrate into app.R

---

**Document:** POC-NMDS-WORKFLOW.md  
**Author:** Jimmy Moses (jmoses@pnguot.ac.pg)  
**Last Updated:** 2025-10-25
