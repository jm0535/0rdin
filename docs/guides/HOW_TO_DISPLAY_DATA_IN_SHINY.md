# HOW TO DISPLAY LOADED/IMPORTED DATA IN SHINY

> ⚠️ **Legacy document (Ördin 3.x).** This describes the R Shiny + Electron
> application in `shiny/` and `src/`, which is kept for maintenance only.
> For the current release see [Documentation Index](../DOCS-INDEX.md) ·
> [Quick Start](../QUICKSTART.md) · [Architecture](../ARCHITECTURE.md).

## 📚 COMPLETE GUIDE

This document explains how data loading and display works in Shiny using Ördin as the example.

---

## 🎯 THE 3-STEP PATTERN

### **Step 1: UI - Define Output Container**
```r
# In UI
DT::DTOutput("species_preview")
```

### **Step 2: Server - Create Reactive Storage**
```r
# In Server
species_data <- reactiveVal(NULL)  # Reactive variable to store data
```

### **Step 3: Server - Render Output**
```r
# In Server
output$species_preview <- DT::renderDT({
  DT::datatable(species_data())  # Display the reactive data
})
```

---

## 🔍 HOW IT WORKS IN ÖRDIN (app.R)

### **PART 1: UI - Data Preview Container (Line 262)**

```r
# UI defines WHERE the table will appear
div(id = "preview-container", style = "margin-top: 16px; min-height: 200px;",
  DT::DTOutput("species_preview")  # ← Output container with ID
)
```

**Key Points:**
- `DTOutput("species_preview")` creates a placeholder for the table
- The ID `"species_preview"` links UI to Server
- Must use `DT::DTOutput()` not `dataTableOutput()` (deprecated)

---

### **PART 2: Server - Reactive Storage (Line 369)**

```r
# Server creates REACTIVE storage for data
species_data <- reactiveVal(NULL)  # ← Starts as NULL (empty)
```

**What is `reactiveVal()`?**
- Like a variable that **automatically triggers updates**
- When you set: `species_data(new_data)`
- All outputs using `species_data()` **auto-refresh**

---

### **PART 3: Server - Render Function (Line 386)**

```r
# Server RENDERS the data into the output
output$species_preview <- DT::renderDT({
  
  if (is.null(species_data())) {
    # CASE 1: No data loaded yet
    DT::datatable(
      data.frame(Message = "No data loaded yet..."),
      options = list(dom = 't', searching = FALSE)
    )
  } else {
    # CASE 2: Data exists - show it!
    DT::datatable(
      species_data(),  # ← Get current data from reactive
      options = list(
        pageLength = 10,
        scrollX = TRUE,
        paging = TRUE,
        searching = TRUE
      )
    )
  }
})
```

**How `renderDT()` works:**
1. Checks if `species_data()` is NULL
2. If NULL → Show placeholder message
3. If has data → Show full interactive table
4. **Automatically re-runs** when `species_data()` changes!

---

### **PART 4: Server - Load Sample Data (Line 428)**

```r
# When user clicks "Load Sample Data" button
observeEvent(input$load_sample, {
  
  # 1. Get user's selection
  req(input$sample_dataset)
  
  # 2. Load the dataset
  if (input$sample_dataset == "dune") {
    data(dune, package = "vegan")
    
    # 3. STORE IN REACTIVE - THIS TRIGGERS UPDATE!
    species_data(as.data.frame(dune))  # ← Sets the reactive value
    
    # 4. Show notification
    showNotification("✅ Dune data loaded!")
  }
  
  # When species_data() changes, renderDT() auto-runs!
})
```

**The Magic Happens Here:**
```r
species_data(as.data.frame(dune))  # ← THIS line triggers everything!
```

1. Sets new value in `species_data`
2. Shiny detects the change
3. `renderDT()` automatically re-executes
4. Table updates in browser!

---

### **PART 5: Server - File Upload (Line 469)**

```r
# When user uploads a file
observeEvent(input$species_file, {
  
  # 1. Get file info
  req(input$species_file)
  ext <- tools::file_ext(input$species_file$name)
  
  # 2. Read the file based on extension
  loaded_data <- tryCatch({
    if (ext == "csv") {
      read_csv(input$species_file$datapath)
    } else if (ext %in% c("xlsx", "xls")) {
      read_excel(input$species_file$datapath)
    }
  }, error = function(e) {
    showNotification(paste("❌ Error:", e$message), type = "error")
    NULL
  })
  
  # 3. Store in reactive - TABLE UPDATES!
  if (!is.null(loaded_data)) {
    species_data(as.data.frame(loaded_data))  # ← Triggers update
    showNotification("✅ File loaded successfully!")
  }
})
```

---

## 🔄 THE REACTIVE FLOW DIAGRAM

```
USER ACTION
    │
    ├─→ Click "Load Sample" → observeEvent(input$load_sample)
    │                              │
    │                              ↓
    │                         data(dune)
    │                              │
    │                              ↓
    │                    species_data(dune) ← SET REACTIVE
    │                              │
    │                              ↓
    └─→ Upload File → observeEvent(input$species_file)
                              │
                              ↓
                        read_csv(file)
                              │
                              ↓
                    species_data(data) ← SET REACTIVE
                              │
                              ↓
                    ┌─────────┴─────────┐
                    │ SHINY DETECTS     │
                    │ REACTIVE CHANGE   │
                    └─────────┬─────────┘
                              ↓
                    ┌─────────────────────┐
                    │ renderDT() RUNS     │
                    │ AUTOMATICALLY       │
                    └─────────┬───────────┘
                              ↓
                    ┌─────────────────────┐
                    │ browser table       │
                    │ UPDATES!            │
                    └─────────────────────┘
```

---

## 💡 KEY CONCEPTS

### **1. Reactive Values**
```r
# CREATE reactive storage
my_data <- reactiveVal(NULL)

# SET value (triggers updates)
my_data(new_dataframe)

# GET value (for reading)
current_data <- my_data()
```

### **2. Render Functions**
```r
# DT package (DataTables)
output$table1 <- DT::renderDT({ DT::datatable(data) })

# Base Shiny table
output$table2 <- renderTable({ data })

# Text output
output$text1 <- renderText({ nrow(data) })

# Plot output
output$plot1 <- renderPlot({ plot(data) })
```

### **3. Observer Pattern**
```r
# Watch for button clicks
observeEvent(input$button_id, {
  # Code runs when button clicked
})

# Watch for file uploads
observeEvent(input$file_input, {
  # Code runs when file selected
})

# Watch reactive changes
observe({
  # Code runs when ANY reactive changes
})
```

---

## ✅ BEST PRACTICES

### **1. Always Use Reactive Storage**
```r
# ✅ GOOD - Reactive, updates automatically
data <- reactiveVal(NULL)
data(new_data)

# ❌ BAD - Regular variable, doesn't trigger updates
data <- NULL
data <- new_data  # Won't trigger re-render!
```

### **2. Match UI/Server Function Pairs**
```r
# ✅ CORRECT - NEW API
UI:     DT::DTOutput("table1")
Server: output$table1 <- DT::renderDT({ ... })

# ❌ WRONG - Mixing old/new causes blank tables
UI:     DT::dataTableOutput("table1")
Server: output$table1 <- DT::renderDT({ ... })
```

### **3. Handle NULL/Empty States**
```r
output$preview <- DT::renderDT({
  if (is.null(my_data())) {
    # Show helpful placeholder
    DT::datatable(
      data.frame(Message = "No data yet. Please upload."),
      options = list(dom = 't')
    )
  } else {
    # Show actual data
    DT::datatable(my_data())
  }
})
```

### **4. Use Error Handling**
```r
observeEvent(input$file, {
  loaded <- tryCatch({
    read_csv(input$file$datapath)
  }, error = function(e) {
    showNotification(paste("Error:", e$message), type = "error")
    NULL  # Return NULL on error
  })
  
  if (!is.null(loaded)) {
    my_data(loaded)
  }
})
```

---

## 🎬 EXAMPLE: MINIMAL WORKING APP

```r
library(shiny)
library(DT)

ui <- fluidPage(
  titlePanel("Data Loading Example"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload CSV"),
      actionButton("load_iris", "Load Iris Dataset")
    ),
    
    mainPanel(
      h3("Data Preview"),
      DT::DTOutput("table")
    )
  )
)

server <- function(input, output, session) {
  
  # STEP 1: Create reactive storage
  my_data <- reactiveVal(NULL)
  
  # STEP 2: Render output (updates automatically!)
  output$table <- DT::renderDT({
    if (is.null(my_data())) {
      DT::datatable(
        data.frame(Message = "No data loaded yet"),
        options = list(dom = 't')
      )
    } else {
      DT::datatable(my_data())
    }
  })
  
  # STEP 3: Load built-in dataset
  observeEvent(input$load_iris, {
    my_data(iris)  # ← Sets reactive, triggers update!
    showNotification("✅ Iris loaded!")
  })
  
  # STEP 4: Load uploaded file
  observeEvent(input$file, {
    req(input$file)
    loaded <- read.csv(input$file$datapath)
    my_data(loaded)  # ← Sets reactive, triggers update!
    showNotification("✅ File loaded!")
  })
}

shinyApp(ui, server)
```

---

## 🐛 TROUBLESHOOTING

### **Problem: Table shows but is empty**
**Cause:** Using old API `dataTableOutput()` + `renderDataTable()`  
**Fix:** Use `DTOutput()` + `renderDT()`

### **Problem: Table doesn't update after loading**
**Cause:** Not using reactive value  
**Fix:** Store data in `reactiveVal()` not regular variable

### **Problem: Error "unused argument (env_data = env_data)"**
**Cause:** Module doesn't accept that parameter  
**Fix:** Check module function signature, only pass supported parameters

### **Problem: App crashes on startup**
**Cause:** Module server calls have wrong parameters  
**Fix:** Verify each module's expected parameters

---

## 📖 FURTHER READING

- **Shiny Reactivity:** https://shiny.rstudio.com/articles/reactivity-overview.html
- **DT Package:** https://rstudio.github.io/DT/
- **File Uploads:** https://shiny.rstudio.com/articles/upload.html

---

**Author:** Jimmy Moses (jimmy.moses@pnguot.ac.pg)  
**Project:** Ördin v3.0  
**Last Updated:** 2025-10-29
