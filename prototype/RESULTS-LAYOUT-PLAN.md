# Ördin v3.0 - Results & Plotting Layout Architecture

## 📐 UI Layout System Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│ TITLE BAR: Ördin v3.0 | species_data.csv | ● Ready | 👤 Jimmy Moses        │
├───┬─────────────────────────────────────────────────────────────────────┬───┤
│ A │ PRIMARY SIDEBAR                  │ MAIN CANVAS                      │ R │
│ C │ (Collapsible)                    │                                  │ I │
│ T │                                  │ ┌─ TAB BAR ─────────────────┐   │ G │
│ I │ ▼ DIVERSITY TOOLS                │ │ 🏠 Dashboard × │ 📊 NMDS × │   │ H │
│ V │   • iNEXT Estimation             │ └───────────────────────────┘   │ T │
│ I │   • Diversity Indices            │                                  │   │
│ T │   • Beta Partitioning            │ ┌─ CONTENT AREA ────────────┐   │ P │
│ Y │                                  │ │                            │   │ A │
│   │ ▼ ORDINATION                     │ │  [WORKFLOW INPUTS]         │   │ N │
│ B │   • NMDS                         │ │  or                        │   │ E │
│ A │   • PCA                          │ │  [SPLIT VIEW:]             │   │ L │
│ R │   • RDA/CCA                      │ │  ┌──────────┬──────────┐  │   │   │
│   │                                  │ │  │  PLOT    │ RESULTS  │  │   │ ( │
│   │ ▼ STATISTICAL TESTS              │ │  │          │ Table/   │  │   │ C │
│   │   • PERMANOVA                    │ │  │          │ Stats    │  │   │ O │
│   │   • ANOSIM                       │ │  └──────────┴──────────┘  │   │ L │
│   │                                  │ │                            │   │ L │
│   │                                  │ └────────────────────────────┘   │ A │
│   │                                  │                                  │ P │
│   │                                  │ ┌─ STATUS BAR ──────────────┐   │ S │
│   │                                  │ │ Ln 1, Col 1 │ UTF-8 │ R   │   │ I │
│   │                                  │ └────────────────────────────┘   │ B │
│   │                                  │                                  │ L │
│   │                                  │                                  │ E │
│   │                                  │                                  │ ) │
└───┴──────────────────────────────────────────────────────────────────────┴───┘
```

---

## 🔄 **Three Display Modes for Analysis Results:**

### **Mode 1: Single Panel (Input/Configuration)**
Used when configuring analysis parameters.

```
┌─────────────────────────────────────────────────────────┐
│ TAB: 📊 NMDS Analysis                                   │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  NMDS Configuration                                     │
│  ┌────────────────────────────────────┐                │
│  │ Distance Metric: [Bray-Curtis ▼]   │                │
│  │ Dimensions: [2 ▼]                  │                │
│  │ Transformation: [Hellinger ▼]      │                │
│  │                                    │                │
│  │ [▶ Run NMDS Analysis]              │                │
│  └────────────────────────────────────┘                │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### **Mode 2: Horizontal Split (Plot + Results)**
Default mode after running analysis - **70% plot, 30% results**.

```
┌─────────────────────────────────────────────────────────┐
│ TAB: 📊 NMDS Results                            [⬌ ⬍]  │
├──────────────────────────────┬──────────────────────────┤
│ PLOT PANEL (70%)             │ RESULTS PANEL (30%)      │
│                              │                          │
│  ┌──────────────────────┐    │ ▼ STATISTICS             │
│  │                      │    │   Stress: 0.089          │
│  │      NMDS Plot       │    │   Iterations: 20         │
│  │                      │    │   Converged: ✓           │
│  │    [Ordination]      │    │                          │
│  │                      │    │ ▼ PERMANOVA              │
│  │                      │    │   F: 12.45               │
│  │                      │    │   R²: 0.234              │
│  └──────────────────────┘    │   p-value: 0.001 ***     │
│                              │                          │
│  [🎨 Customize] [💾 Export]  │ ▼ PAIRWISE TESTS         │
│                              │   Group A vs B: 0.002 ** │
│                              │   Group A vs C: 0.045 *  │
│                              │                          │
│                              │ [📋 Copy] [💾 Export]    │
└──────────────────────────────┴──────────────────────────┘
```

### **Mode 3: Vertical Split (Multiple Plots)**
For comparing plots or multi-panel figures.

```
┌─────────────────────────────────────────────────────────┐
│ TAB: 📊 Diversity Comparison                   [⬍ ⬌]   │
├─────────────────────────────────────────────────────────┤
│ PLOT PANEL 1 (Top 50%)                                  │
│  ┌──────────────────────────────────────────────────┐   │
│  │         Rarefaction Curve (iNEXT)                │   │
│  │                                                  │   │
│  └──────────────────────────────────────────────────┘   │
├─────────────────────────────────────────────────────────┤
│ PLOT PANEL 2 (Bottom 50%)                               │
│  ┌──────────────────────────────────────────────────┐   │
│  │         NMDS Ordination                          │   │
│  │                                                  │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## 📊 **Detailed Results Panel Components:**

### **Results Panel Structure:**
```
┌─ RESULTS PANEL ─────────────────┐
│                                 │
│ ▼ STATISTICAL SUMMARY          │
│   ├─ Model fit statistics      │
│   ├─ Variance explained        │
│   └─ Goodness-of-fit           │
│                                 │
│ ▼ PERMUTATION TESTS            │
│   ├─ PERMANOVA results         │
│   ├─ Post-hoc tests            │
│   └─ P-value matrix            │
│                                 │
│ ▼ ORDINATION AXES              │
│   ├─ Eigenvalues               │
│   ├─ % Variance explained      │
│   └─ Cumulative variance       │
│                                 │
│ ▼ SPECIES SCORES               │
│   └─ [View Table ▶]            │
│                                 │
│ ▼ SITE SCORES                  │
│   └─ [View Table ▶]            │
│                                 │
│ ┌─ ACTIONS ─────────────────┐  │
│ │ [📋 Copy Results]         │  │
│ │ [💾 Export CSV]           │  │
│ │ [📄 Export Report]        │  │
│ │ [📊 Export Plot]          │  │
│ └───────────────────────────┘  │
└─────────────────────────────────┘
```

---

## 🎨 **Plot Panel Components:**

### **Plot Panel Structure:**
```
┌─ PLOT PANEL ────────────────────────────────┐
│                                             │
│  ┌─ PLOT AREA ───────────────────────────┐  │
│  │                                       │  │
│  │         [Interactive Plot]            │  │
│  │         (Plotly/ggplot2)              │  │
│  │                                       │  │
│  │  - Zoom in/out                        │  │
│  │  - Pan                                │  │
│  │  - Hover tooltips                     │  │
│  │  - Select points                      │  │
│  │                                       │  │
│  └───────────────────────────────────────┘  │
│                                             │
│  ┌─ PLOT CONTROLS ──────────────────────┐   │
│  │ [🎨 Customize] [🔄 Reset View]       │   │
│  │ [📸 Screenshot] [💾 Export PNG/PDF]  │   │
│  │ [🧩 Add to patchwork]                │   │
│  └──────────────────────────────────────┘   │
└─────────────────────────────────────────────┘
```

---

## 🔀 **Layout Toggle Controls:**

Users can switch between layouts using **toolbar buttons**:

```
┌─ LAYOUT CONTROLS (Top Right) ───────────────┐
│  [⬍] Full Plot                              │
│  [⬌] Horizontal Split (Plot + Results)      │
│  [⬍] Vertical Split (Multi-plot)            │
│  [▦] Grid View (4 panels)                   │
└──────────────────────────────────────────────┘
```

---

## 📋 **Tab Types & Their Purposes:**

### **1. Configuration Tabs**
- Show input forms and parameters
- Example: "Configure NMDS", "Import Data"

### **2. Results Tabs**
- Show plots + statistical results
- Example: "NMDS Results", "Diversity Analysis"
- **Auto-created** when analysis completes

### **3. Comparison Tabs**
- Side-by-side or grid comparisons
- Example: "Compare Groups", "Multi-plot View"

### **4. Report Tabs**
- Comprehensive analysis reports
- Combine multiple analyses
- Export-ready format

---

## 🎯 **Workflow Example: Running NMDS**

### Step 1: User clicks "NMDS" in sidebar
→ Opens **Configuration Tab**: "Configure NMDS"
```
┌────────────────────────────────┐
│ TAB: Configure NMDS            │
│ [Input parameters & settings]  │
│ [▶ Run Analysis]               │
└────────────────────────────────┘
```

### Step 2: User clicks "Run Analysis"
→ Shows loading spinner
→ Runs R computation in background

### Step 3: Analysis completes
→ Opens **NEW Results Tab**: "NMDS Results"
→ Switches to horizontal split layout (plot + results)
```
┌──────────────────┬──────────────┐
│ NMDS Plot        │ Statistics   │
│ (Interactive)    │ - Stress     │
│                  │ - PERMANOVA  │
│ [Customize]      │ [Export]     │
└──────────────────┴──────────────┘
```

### Step 4: User customizes plot
→ Opens **Plot Settings Panel** (right side)
→ Live preview updates

### Step 5: User exports
→ Options: PNG, PDF, SVG
→ Option to save entire session

---

## 🗂️ **Right Panel Multi-Purpose Usage:**

The **Right Panel** (currently showing "Properties") becomes **context-aware**:

### **When viewing results:**
```
┌─ RIGHT PANEL ────────────────┐
│ ▼ PLOT SETTINGS              │
│   • Color palette            │
│   • Point size               │
│   • Labels                   │
│                              │
│ ▼ EXPORT OPTIONS             │
│   • Resolution (DPI)         │
│   • Dimensions               │
│   • Format (PNG/PDF/SVG)     │
│                              │
│ ▼ STATISTICAL OPTIONS        │
│   • Confidence level         │
│   • Permutations             │
│   • Post-hoc tests           │
└──────────────────────────────┘
```

---

## 💾 **Session Management:**

### **Tabs persist in session:**
- All open tabs saved
- Can reopen closed tabs (like browser)
- Session export includes all analyses

### **Tab Management:**
```
┌─ TAB BAR ──────────────────────────────────┐
│ 🏠 Dashboard × │ 📊 NMDS × │ 📈 Diversity × │ ➕ │
└────────────────────────────────────────────┘
        ↑              ↑            ↑          ↑
     Close         Active        Inactive    New Tab
```

---

## 🎨 **Special View: patchwork Multi-Panel Mode**

When using **patchwork** to combine plots:

```
┌─ TAB: Multi-Panel Figure ─────────────────────────┐
│ ┌─ LAYOUT GRID ─────────┬─ PANEL SETTINGS ─────┐ │
│ │  ┌─────┬─────┐        │ Selected: Panel A    │ │
│ │  │  A  │  B  │        │ [Plot Settings]      │ │
│ │  ├─────┴─────┤        │ [Label: (A)]         │ │
│ │  │     C     │        │                      │ │
│ │  └───────────┘        │ [Apply to All]       │ │
│ │                       │ [Export Combined]     │ │
│ │  [Add Panel +]        │                      │ │
│ └───────────────────────┴──────────────────────┘ │
└────────────────────────────────────────────────────┘
```

---

## ✅ **Key Principles:**

1. **Tabs = Documents** (like VS Code files)
   - Each analysis gets its own tab
   - Can have multiple tabs open
   - Easy to switch between analyses

2. **Panels = Views within a tab**
   - Split views for plot + results
   - Resizable and toggleable
   - Context-aware (change based on content)

3. **Right Panel = Context Tools**
   - Customization for active plot
   - Export settings
   - Quick actions

4. **Activity Bar = Main Navigation**
   - Switch between major sections (Data, Diversity, Ordination)
   - Each section populates sidebar with relevant tools

5. **Results are Non-Destructive**
   - All analyses preserved in tabs
   - Can revisit and re-export anytime
   - Session can be saved/loaded

---

## 🚀 **Implementation Priority:**

### **Phase 1: Basic Results Display**
- Single tab with plot or results
- Simple export buttons

### **Phase 2: Split Views**
- Horizontal split (plot + results table)
- Resizable panels

### **Phase 3: Advanced Layouts**
- Vertical split for comparisons
- Grid view for multiple plots
- patchwork integration

### **Phase 4: Interactive Features**
- Real-time plot customization
- Drag-and-drop panel arrangement
- Advanced export options

---

## 📝 **Technical Implementation Notes:**

### **Shiny Implementation:**
```r
# Main content area uses conditional panels
output$mainContent <- renderUI({
  if (layoutMode() == "single") {
    # Full width single panel
    plotOutput("mainPlot", height = "100%")
  } else if (layoutMode() == "horizontal") {
    # 70-30 split
    fluidRow(
      column(8, plotOutput("mainPlot")),
      column(4, uiOutput("resultsPanel"))
    )
  } else if (layoutMode() == "vertical") {
    # 50-50 vertical
    tags$div(
      plotOutput("plot1", height = "50%"),
      plotOutput("plot2", height = "50%")
    )
  }
})
```

### **Tab Management:**
```r
# Dynamic tab creation
observeEvent(input$runAnalysis, {
  # Create new results tab
  appendTab(
    inputId = "mainTabs",
    tabPanel(
      paste0("NMDS Results - ", Sys.time()),
      value = paste0("nmds_", runif(1)),
      # Tab content: plot + results
    )
  )
})
```

---

**This layout system provides:**
✅ Flexible viewing options
✅ Professional statistical output
✅ Interactive plot customization
✅ Easy comparison of analyses
✅ Publication-ready exports
✅ Familiar IDE-like experience
