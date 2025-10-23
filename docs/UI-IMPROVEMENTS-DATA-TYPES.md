# UI Improvements: Data Type Clarity & Extrapolation Control

**Update**: Enhanced user interface for Ördin  
**Focus**: Clear data type indication and extrapolation endpoint control  
**Date**: 2025-10-23

---

## 🎨 New UI Features

### 1. **Clear Data Type Explanation Box**

**Location**: Sidebar, under "Data Type" dropdown

**Visual**:
```
┌─────────────────────────────────────────────────┐
│ Data Type: [Abundance (individual counts) ▼]   │
├─────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────┐ │
│ │ Abundance: Individual-based rarefaction      │ │
│ │            (counts: 0,1,2,3,...)             │ │
│ │ Incidence_raw: Presence/absence              │ │
│ │                (binary: 0,1 only)            │ │
│ │ Incidence_freq: Sampling units               │ │
│ │                 (requires SamplingUnits col) │ │
│ │                                              │ │
│ │ → Auto-detects format from your data        │ │
│ └─────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────┘
```

**Code**:
```r
div(style = "background-color: #1a1a1a; padding: 10px; ...",
  tags$small(
    tags$strong("Abundance:"), " Individual-based rarefaction (counts: 0,1,2,3,...)", br(),
    tags$strong("Incidence_raw:"), " Presence/absence (binary: 0,1 only)", br(),
    tags$strong("Incidence_freq:"), " Sampling units (requires SamplingUnits column)", br(),
    br(),
    tags$em("→ Auto-detects format from your data")
  )
)
```

---

### 2. **Auto-Detection Status Display**

**Location**: Sidebar, appears after file upload

**Three Visual States**:

#### **State A: Abundance Detected**
```
┌─────────────────────────────────────────────────┐
│ 📊 Detected: Abundance                          │
│ Individual counts (0, 1, 2, 3, ...)             │
└─────────────────────────────────────────────────┘
     Green accent color (#2e8b57)
```

#### **State B: Incidence_raw Detected**
```
┌─────────────────────────────────────────────────┐
│ ✓ Detected: Incidence_raw                       │
│ Presence/absence (binary: 0, 1)                 │
└─────────────────────────────────────────────────┘
     Orange accent color (#ff8c00)
```

#### **State C: Incidence_freq Detected**
```
┌─────────────────────────────────────────────────┐
│ 🔢 Detected: Incidence_freq                     │
│ Sampling units: 599, 230, 150, 200, 200         │
└─────────────────────────────────────────────────┘
     Blue accent color (#4169e1)
```

**Code**:
```r
output$dataFormatDetected <- renderUI({
  req(data())
  
  data_format <- data()$data_format
  
  format_info <- if (data_format == "abundance") {
    list(
      icon = "📊",
      name = "Abundance",
      desc = "Individual counts (0, 1, 2, 3, ...)",
      color = "#2e8b57"  # Green
    )
  } else if (data_format == "incidence_raw") {
    list(
      icon = "✓",
      name = "Incidence_raw",
      desc = "Presence/absence (binary: 0, 1)",
      color = "#ff8c00"  # Orange
    )
  } else {
    list(
      icon = "🔢",
      name = "Incidence_freq",
      desc = paste0("Sampling units: ", paste(data()$sampling_units, collapse=", ")),
      color = "#4169e1"  # Blue
    )
  }
  
  div(
    style = paste0("background-color: ", format_info$color, "22; 
                    border-left: 4px solid ", format_info$color, "; 
                    padding: 10px; margin-top: 10px; border-radius: 3px;"),
    tags$strong(format_info$icon, " Detected: ", format_info$name),
    tags$br(),
    tags$small(format_info$desc)
  )
})
```

**Benefits**:
- ✅ **Instant feedback** on data format
- ✅ **Color-coded** for quick recognition
- ✅ **Shows sampling units** for incidence_freq
- ✅ **Confirms auto-detection** working correctly

---

### 3. **Extrapolation Endpoint Control**

**Location**: Sidebar → iNEXT Advanced Options → New section

**Visual**:
```
┌─────────────────────────────────────────────────┐
│ Extrapolation Control                           │
├─────────────────────────────────────────────────┤
│ Extrapolation Endpoint: [_________]             │
│                                                 │
│ Leave blank for auto (2× reference sample).    │
│ Set to a specific number of individuals/       │
│ sampling units to compare sites at same        │
│ extrapolation level.                            │
└─────────────────────────────────────────────────┘
```

**Code**:
```r
hr(),
h5("Extrapolation Control"),
numericInput("endpoint", "Extrapolation Endpoint",
             value = NULL, min = 1, step = 1),
helpText("Leave blank for auto (2× reference sample). 
          Set to a specific number of individuals/sampling units 
          to compare sites at same extrapolation level.")
```

**Input Behavior**:
- **Blank** (NULL): Auto mode → 2× reference sample
- **Number** (e.g., 1500): Custom endpoint → all curves extrapolate to 1500

---

## 📊 Plot Subtitle Enhancements

### **Enhanced Information Display**

**Before** (old subtitle):
```
Sites: Forest_A, Forest_B | Hill numbers q=0, 1, 2 | 95% CI (nboot=50)
```

**After** (new subtitle):
```
Sites: Forest_A, Forest_B | Hill numbers q=0, 1, 2 | 95% CI (nboot=50) | Format: abundance | Endpoint: auto (2× reference)
```

or

```
Sites: Forest_A, Forest_B | Hill numbers q=0, 1, 2 | 95% CI (nboot=50) | Format: incidence_raw | Endpoint: 1500 individuals
```

### **Subtitle Components**

1. **Sites**: List of all sites analyzed
2. **Hill numbers**: Which diversity orders (q=0,1,2)
3. **Confidence**: CI level and bootstrap replicates
4. **Format**: Data format detected (abundance/incidence_raw/incidence_freq)
5. **Endpoint**: Extrapolation target (auto or custom value)

**Code**:
```r
# Build endpoint display text
endpoint_text <- if (is.null(endpoint_value)) {
  "auto (2× reference)"
} else {
  paste0(endpoint_value, " ", 
         if(actual_datatype == "abundance") "individuals" else "sampling units")
}

# Complete subtitle
subtitle = paste0(
  "Sites: ", site_list,
  " | Hill numbers q=", paste(selected_q, collapse = ", "),
  " | ", input$conf * 100, "% CI (nboot=", input$nboot, ")",
  " | Format: ", data_format,
  " | Endpoint: ", endpoint_text
)
```

---

## 🎯 User Experience Flow

### **Complete Workflow with New Features**

#### **Step 1: Upload Data**
```
User: [Clicks "Browse" → Selects ciliates-abundance.csv]
```

#### **Step 2: Auto-Detection Display**
```
App shows:
┌─────────────────────────────────────────┐
│ ✓ Detected: Incidence_raw               │
│ Presence/absence (binary: 0, 1)         │
└─────────────────────────────────────────┘
```

**User thinks**: "Good! My 0/1 data is recognized as incidence."

#### **Step 3: Read Format Explanation**
```
User sees info box:
┌─────────────────────────────────────────┐
│ Abundance: Individual-based rarefaction  │
│            (counts: 0,1,2,3,...)         │
│ Incidence_raw: Presence/absence          │
│                (binary: 0,1 only)        │
│ Incidence_freq: Sampling units           │
│ → Auto-detects format from your data    │
└─────────────────────────────────────────┘
```

**User thinks**: "I understand the three types now!"

#### **Step 4: Select Data Type**
```
User: [Selects "Incidence (presence/absence)"]
```

App internally uses: `datatype = "incidence_raw"` (auto-detected)

#### **Step 5: Set Endpoint (Optional)**
```
User sees:
Extrapolation Endpoint: [_________]
Help: Leave blank for auto (2× reference)
```

**Option A**: Leave blank → Uses auto  
**Option B**: Enter 100 → All curves extrapolate to 100 sampling units

#### **Step 6: Run Analysis**
```
User: [Clicks "Run Analysis"]

App shows progress:
→ Validating data...
→ Calculating diversity indices...
→ Generating plots...
→ Done!
```

#### **Step 7: View Results**
```
Plot subtitle shows:
"Sites: EtoshaPan, CentralNamibDesert, SouthernNamibDesert | 
Hill numbers q=0, 1, 2 | 95% CI (nboot=50) | 
Format: incidence_raw | Endpoint: auto (2× reference)"
```

**User thinks**: "Perfect! I can see exactly what analysis was run."

---

## 📋 Comparison: Before vs After

### **Before These Updates**

| Aspect | Old Behavior |
|--------|--------------|
| **Data type info** | Generic help text only |
| **Format detection** | Silent, user doesn't know if correct |
| **Three formats** | Not clearly explained |
| **Extrapolation** | Always auto, no control |
| **Endpoint value** | Hidden, not displayed |
| **Plot subtitle** | Basic info only |

**Problems**:
- ❌ Users confused about data types
- ❌ No feedback on auto-detection
- ❌ Can't control extrapolation
- ❌ Can't reproduce exact analysis from plot

---

### **After These Updates**

| Aspect | New Behavior |
|--------|--------------|
| **Data type info** | ✅ Clear 3-format explanation box |
| **Format detection** | ✅ Color-coded visual feedback |
| **Three formats** | ✅ abundance/incidence_raw/incidence_freq clearly labeled |
| **Extrapolation** | ✅ User-controlled endpoint parameter |
| **Endpoint value** | ✅ Displayed in plot subtitle |
| **Plot subtitle** | ✅ Complete analysis parameters |

**Benefits**:
- ✅ Users understand data types immediately
- ✅ Instant feedback confirms correct detection
- ✅ Full control over extrapolation
- ✅ Plots are self-documenting
- ✅ Analysis fully reproducible from plot

---

## 🎨 Color Scheme

### **Format Detection Colors**

```
Abundance:       #2e8b57 (Forest Green)
                 ↓
                 📊 Counts/individuals
                 
Incidence_raw:   #ff8c00 (Dark Orange)
                 ↓
                 ✓ Binary presence/absence
                 
Incidence_freq:  #4169e1 (Royal Blue)
                 ↓
                 🔢 Sampling units
```

**Design rationale**:
- **Green (abundance)**: Natural, growth, counts
- **Orange (incidence_raw)**: Attention, binary decision
- **Blue (incidence_freq)**: Technical, structured data

---

## 📱 Responsive Design

All new UI elements use:
- ✅ **Bootstrap 5** components
- ✅ **Darkly theme** for consistency
- ✅ **Responsive padding** and spacing
- ✅ **Mobile-friendly** text sizing

```css
background-color: #1a1a1a;  /* Matches Darkly theme */
padding: 10px;
border-radius: 5px;
margin-bottom: 15px;
```

---

## 🧪 Testing Checklist

### **Visual Verification**

- [ ] Info box displays with correct styling
- [ ] Detection box shows after file upload
- [ ] Colors match format type (green/orange/blue)
- [ ] Extrapolation endpoint input visible
- [ ] Help text is readable

### **Functional Testing**

- [ ] Abundance data → Green box, "📊 Detected: Abundance"
- [ ] Binary data (0/1) → Orange box, "✓ Detected: Incidence_raw"
- [ ] SamplingUnits column → Blue box, "🔢 Detected: Incidence_freq"
- [ ] Blank endpoint → Subtitle shows "auto (2× reference)"
- [ ] Custom endpoint (1500) → Subtitle shows "1500 individuals"
- [ ] Plot displays correctly with all info

### **User Experience**

- [ ] First-time users understand three formats
- [ ] Auto-detection provides confidence
- [ ] Endpoint control is intuitive
- [ ] Plot subtitle is informative but not cluttered

---

## 📚 Documentation References

### Related Docs
- [`EXTRAPOLATION-ENDPOINT-GUIDE.md`](./EXTRAPOLATION-ENDPOINT-GUIDE.md) - Detailed endpoint usage
- [`INCIDENCE-DATA-FIX.md`](./INCIDENCE-DATA-FIX.md) - Data format implementation
- [`sample-data/DATA-FORMAT-GUIDE.md`](../sample-data/DATA-FORMAT-GUIDE.md) - User guide

### User-Facing Help
- Tooltip on "Data Type" dropdown
- Info box below dropdown
- Detection status box after upload
- Help text on endpoint parameter
- Plot subtitle with full parameters

---

## ✅ Summary of Changes

### **UI Additions** (app.R)

1. **Info box** explaining three data types (lines ~24-33)
2. **Detection display** showing auto-detected format (server function)
3. **Endpoint parameter** numeric input (lines ~64-67)

### **Backend Updates**

1. **Format detection** logic (already implemented)
2. **Endpoint handling** in iNEXT call
3. **Subtitle enhancement** with format and endpoint

### **User Benefits**

- ✅ **Clarity**: Understand three data types immediately
- ✅ **Confidence**: See detection confirmation
- ✅ **Control**: Set custom extrapolation endpoint
- ✅ **Transparency**: Full analysis parameters in plot
- ✅ **Reproducibility**: Can recreate analysis from plot info

---

**Result**: Users now have complete clarity on data types and full control over extrapolation! 🎉
