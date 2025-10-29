# Ördin App Review - CRITICAL ISSUES FOUND

**Date:** December 2025  
**Author:** Jimmy Moses (jimmy.moses@pnguot.ac.pg)  
**Status:** 🔴 **CRITICAL BUGS IDENTIFIED**

---

## 🚨 CRITICAL ISSUES

### 1. **Data Flow Broken - Modules Not Connected**

**Problem:**
- All 7 analysis modules expect `data()` and `env_data()` reactive parameters
- `app.R` calls module servers WITHOUT passing any data
- Users cannot perform ANY analyses - modules have no data to work with

**Current Code (BROKEN):**
```r
# In app.R server - lines 350-357
diversity_estimation_server("diversity_est")  # ❌ NO DATA!
diversity_indices_server("diversity_idx")     # ❌ NO DATA!
nmds_server("nmds")                            # ❌ NO DATA!
pca_server("pca")                              # ❌ NO DATA!
ca_server("ca")                                # ❌ NO DATA!
dca_server("dca")                              # ❌ NO DATA!
pcoa_server("pcoa")                            # ❌ NO DATA!
```

**Module Signatures (EXPECTING DATA):**
```r
# modules/ordination_nmds_module.R
nmds_server <- function(id, data, env_data = reactive(NULL))

# modules/diversity_estimation_module.R
diversity_estimation_server <- function(id, data)
```

**Impact:** 🔴 **CRITICAL**
- All analyses are completely non-functional
- "Run Analysis" buttons will fail
- No plots or results can be generated

---

### 2. **Data Loading Not Reactive**

**Problem:**
- File uploads and sample data loading don't create reactive values
- Data is only shown in preview table
- No centralized data storage for modules to access

**Current Code:**
```r
observeEvent(input$load_sample, {
  # Data loaded but NOT stored reactively
  output$species_preview <- DT::renderDataTable({
    DT::datatable(dune, ...)  # Just shown in table
  })
  # ❌ No reactive data storage!
})
```

**Impact:** 🔴 **CRITICAL**
- Loaded data is not accessible to analysis modules
- Cannot run any analyses even after loading data

---

### 3. **Tab Content Not Synchronized with Shiny Inputs**

**Problem:**
- Tab content divs use `display: none` in HTML
- Shiny conditional panels won't work properly
- Module UIs may not render when tabs are shown via JavaScript

**Current Structure:**
```html
<div id="tab-diversity" style="display: none;">
  <!-- Shiny conditionalPanel won't work here -->
</div>
```

**Impact:** 🟡 **MEDIUM**
- Module UIs may not initialize properly
- Conditional panels may not show/hide correctly

---

### 4. **Missing Utility Functions**

**Problem:**
- Modules call utility functions that don't exist:
  - `utils/validation.R`
  - `utils/interpretation.R`
  - `utils/reproducibility.R`

**Module Code:**
```r
source("utils/validation.R", local = TRUE)  # ❌ File doesn't exist
source("utils/interpretation.R", local = TRUE)  # ❌ File doesn't exist
source("utils/reproducibility.R", local = TRUE)  # ❌ File doesn't exist
```

**Impact:** 🔴 **CRITICAL**
- Modules will crash on load
- Validation feedback won't work
- App won't start properly

---

### 5. **DCA and PCoA Modules Incomplete**

**Checked:**
- `ordination_dca_module.R` - 2.0 KB (likely stub)
- `ordination_pcoa_module.R` - 2.2 KB (likely stub)

**Impact:** 🟡 **MEDIUM**
- Two ordination methods may not work
- UI may show incomplete/broken interfaces

---

## ✅ FIXES REQUIRED

### Fix #1: Create Reactive Data Storage

```r
server <- function(input, output, session) {
  # Reactive values for data storage
  species_data <- reactiveVal(NULL)
  env_data <- reactiveVal(NULL)
  
  # Update when file uploaded
  observeEvent(input$species_file, {
    data <- read_csv(input$species_file$datapath)
    species_data(data)  # Store reactively
  })
  
  # Update when sample loaded
  observeEvent(input$load_sample, {
    data(dune, package = "vegan")
    species_data(dune)  # Store reactively
  })
}
```

### Fix #2: Pass Data to Modules

```r
# Call module servers WITH data
diversity_estimation_server("diversity_est", data = species_data)
diversity_indices_server("diversity_idx", data = species_data)
nmds_server("nmds", data = species_data, env_data = env_data)
pca_server("pca", data = species_data, env_data = env_data)
ca_server("ca", data = species_data, env_data = env_data)
dca_server("dca", data = species_data, env_data = env_data)
pcoa_server("pcoa", data = species_data, env_data = env_data)
```

### Fix #3: Create Missing Utility Files

Create these files:
- `shiny/utils/validation.R`
- `shiny/utils/interpretation.R`
- `shiny/utils/reproducibility.R`

Or remove the source() calls from modules.

### Fix #4: Fix Tab Visibility

Use Shiny's `conditionalPanel` with proper conditions:
```r
conditionalPanel(
  "input.active_tab == 'diversity'",
  # Module UI here
)
```

Or use `shinyjs::show()` / `shinyjs::hide()` in observers.

---

## 📊 Severity Assessment

| Issue | Severity | Blocks Functionality | Fix Priority |
|-------|----------|---------------------|--------------|
| Data flow broken | 🔴 CRITICAL | Yes - All analyses | 1 (IMMEDIATE) |
| Data not reactive | 🔴 CRITICAL | Yes - All analyses | 1 (IMMEDIATE) |
| Missing utilities | 🔴 CRITICAL | Yes - App crash | 1 (IMMEDIATE) |
| Tab synchronization | 🟡 MEDIUM | Partial | 2 (HIGH) |
| Incomplete modules | 🟡 MEDIUM | 2 methods | 3 (MEDIUM) |

---

## 🎯 Required Actions

### IMMEDIATE (Before App Can Work):

1. **Create reactive data storage**
   - Add `species_data <- reactiveVal(NULL)`
   - Add `env_data <- reactiveVal(NULL)`
   - Update on file upload/sample load

2. **Pass data to modules**
   - Update all 7 module server calls
   - Pass `data = species_data`
   - Pass `env_data = env_data` (ordination only)

3. **Create or remove utility calls**
   - Either create the 3 utility files
   - Or comment out `source()` calls in modules

### HIGH PRIORITY:

4. **Fix tab visibility system**
   - Ensure Shiny inputs work in hidden tabs
   - Use proper conditional rendering

5. **Test data flow end-to-end**
   - Load sample data
   - Verify data reaches modules
   - Run test analysis

### MEDIUM PRIORITY:

6. **Complete DCA and PCoA modules**
   - Implement full UI
   - Implement full server logic

---

## 🧪 Test Plan

After fixes, test this workflow:

1. **Start app** → Should load without errors
2. **Click Data tab** → Should show data management UI
3. **Load sample dataset** → Should populate preview
4. **Click Diversity tab** → Should show iNEXT UI
5. **Run iNEXT** → Should generate plot and results
6. **Click Ordination tab** → Should show NMDS UI
7. **Run NMDS** → Should generate ordination plot
8. **Export results** → Should download files

---

## 📝 Recommendation

**DO NOT DEPLOY** until these critical issues are fixed. The app is currently non-functional for its primary purpose (data analysis).

**Estimated Fix Time:** 2-3 hours for critical issues

**Next Steps:**
1. Fix reactive data storage (30 min)
2. Connect modules to data (30 min)
3. Handle utility files (30 min)
4. Test all workflows (60 min)

---

**Contact:** jimmy.moses@pnguot.ac.pg
