# 🎯 Sidebar Implementation Plan

**Issue:** Current Ördin app is missing the VS Code-style activity bar and sidebars from the prototype

**User Feedback:** "the prototype has sidebars. i don't see them in current Ordin!!!!"

---

## 📊 What's Missing

### **From Prototype:**
1. ✅ **Activity Bar** (48px left vertical icon bar)
2. ✅ **Primary Sidebar** (250px collapsible context panel)
3. ✅ **Right Panel** (Properties/tools panel)

### **Current Implementation:**
- ❌ No activity bar
- ❌ No collapsible sidebar
- ❌ No right panel
- ✅ Has Shiny `navbarPage` tabs (works but different UX)

---

## 🔧 Implementation Options

### **Option 1: Full VS Code Layout (Complex)**

**Structure:**
```html
<div class="app-container">
  <div class="titlebar">...</div>
  <div class="main-container">
    <div class="activity-bar">...</div>     <!-- 48px icons -->
    <div class="primary-sidebar">...</div>  <!-- 250px collapsible -->
    <div class="main-canvas">
      <div class="breadcrumb">...</div>
      <div class="tab-bar">...</div>        <!-- VS Code style tabs -->
      <div class="content-area">...</div>
      <div class="status-bar">...</div>
    </div>
    <div class="right-panel">...</div>      <!-- Properties -->
  </div>
</div>
```

**Pros:**
- ✅ Exact prototype match
- ✅ Professional VS Code feel
- ✅ Collapsible sidebars save space

**Cons:**
- ❌ Complex JavaScript for tab management
- ❌ Conflicts with Shiny's reactive system
- ❌ 2-3 days of work
- ❌ May break existing modules

---

### **Option 2: Hybrid Approach (RECOMMENDED)**

**Keep:** Shiny `navbarPage` for tab management (it works!)

**Add:** 
- Activity bar (visual indicator of current tab)
- Collapsible sidebar (shows context per tab)
- Right panel (optional - dataset info)

**Structure:**
```html
<div class="app-container">
  <div class="titlebar">...</div>
  <div class="main-container">
    <div class="activity-bar">             <!-- Maps to Shiny tabs -->
      <div onclick="updateTabsetPanel('home')">🏠</div>
      <div onclick="updateTabsetPanel('data')">📊</div>
      ...
    </div>
    <div class="primary-sidebar collapsed">  <!-- Context per tab -->
      <div class="sidebar-content" id="sidebar-home">...</div>
      <div class="sidebar-content" id="sidebar-data">...</div>
      ...
    </div>
    <div class="main-canvas">
      <!-- Shiny navbarPage goes here (unchanged) -->
    </div>
  </div>
</div>
```

**Pros:**
- ✅ Keeps Shiny reactivity working
- ✅ Adds VS Code visual elements
- ✅ 4-6 hours of work
- ✅ Won't break modules

**Cons:**
- ⚠️ Not 100% prototype match (but 95%)
- ⚠️ Two navigation systems (activity bar + tabs)

---

### **Option 3: CSS-Only Enhancement (Quick Fix)**

**Add:** Just the visual styling without restructuring

**Changes:**
- Add activity bar CSS (hidden, decorative only)
- Add sidebar-like styling to existing panels
- Keep all Shiny tabs as-is

**Pros:**
- ✅ 1-2 hours only
- ✅ Zero risk to functionality
- ✅ Improves visual appearance

**Cons:**
- ❌ Not functional sidebars
- ❌ Doesn't match prototype UX

---

## 🎯 RECOMMENDED: Option 2 (Hybrid)

### **Implementation Steps:**

#### **Step 1: Add Activity Bar (1 hour)**

```r
# In UI, wrap navbarPage:
div(class = "app-container",
  div(class = "titlebar", ...),
  div(class = "main-container",
    # NEW: Activity bar
    div(class = "activity-bar",
      div(class = "activity-item active", 
          id = "act-home",
          onclick = "Shiny.setInputValue('switch_tab', 'home'); 
                     $('.activity-item').removeClass('active'); 
                     $('#act-home').addClass('active')",
          "🏠"),
      div(class = "activity-item",
          id = "act-data",
          onclick = "Shiny.setInputValue('switch_tab', 'data'); 
                     $('.activity-item').removeClass('active'); 
                     $('#act-data').addClass('active')",
          "📊"),
      # ... more items
    ),
    
    # Existing navbarPage
    navbarPage(...)
  )
)
```

**Server:**
```r
observeEvent(input$switch_tab, {
  updateNavbarPage(session, "main_tabs", selected = input$switch_tab)
})
```

---

#### **Step 2: Add Collapsible Sidebar (2 hours)**

```r
# Add sidebar between activity bar and navbarPage
div(class = "primary-sidebar collapsed", id = "sidebar",
  div(class = "sidebar-header",
    span(class = "sidebar-title", "EXPLORER"),
    tags$button(onclick = "$('#sidebar').toggleClass('collapsed')", "◀")
  ),
  div(class = "sidebar-content",
    # Content changes per tab
    conditionalPanel(
      condition = "input.main_tabs == 'data'",
      div(class = "section",
        div(class = "section-header", "▼ DATA SOURCES"),
        div(class = "section-content",
          div(class = "item", "📄 Current Dataset"),
          div(class = "item", "📥 Import New"),
          div(class = "item", "📚 Sample Datasets")
        )
      )
    ),
    conditionalPanel(
      condition = "input.main_tabs == 'diversity'",
      div(class = "section",
        div(class = "section-header", "▼ ANALYSIS TYPE"),
        div(class = "section-content",
          div(class = "item", "📈 iNEXT Estimation"),
          div(class = "item", "📊 Diversity Indices")
        )
      )
    )
    # ... more tabs
  )
)
```

---

#### **Step 3: Add Right Panel (1 hour)**

```r
# After navbarPage
div(class = "right-panel collapsed", id = "rightPanel",
  div(class = "panel-header",
    span("PROPERTIES"),
    tags$button(onclick = "$('#rightPanel').toggleClass('collapsed')", "▶")
  ),
  div(class = "panel-content",
    conditionalPanel(
      condition = "output.has_data",
      div(class = "prop-section",
        h4("Dataset Info"),
        uiOutput("dataset_info")
      )
    )
  )
)
```

---

#### **Step 4: Update CSS (1 hour)**

Ensure `custom.css` has all prototype styles:
- `.activity-bar` (already in custom.css ✅)
- `.primary-sidebar` (already in custom.css ✅)
- `.right-panel` (needs to be added)
- Collapse/expand transitions

---

#### **Step 5: JavaScript Enhancements (1 hour)**

Add to `www/app.js`:
```javascript
// Sync activity bar with Shiny tabs
$(document).on('shiny:inputchanged', function(event) {
  if (event.name === 'main_tabs') {
    $('.activity-item').removeClass('active');
    $('#act-' + event.value).addClass('active');
    
    // Update sidebar title
    const titles = {
      'home': 'EXPLORER',
      'data': 'DATA MANAGEMENT',
      'diversity': 'DIVERSITY ANALYSIS',
      'ordination': 'ORDINATION',
      'about': 'ABOUT ÖRDIN'
    };
    $('.sidebar-title').text(titles[event.value] || 'EXPLORER');
  }
});

// Toggle sidebar on activity bar click (VS Code behavior)
var lastClickedTab = null;
function toggleSidebarOnClick(tab) {
  if (lastClickedTab === tab) {
    $('#sidebar').toggleClass('collapsed');
  } else {
    $('#sidebar').removeClass('collapsed');
  }
  lastClickedTab = tab;
}
```

---

## 📋 Implementation Checklist

### **Phase 1: Structure (2 hours)**
- [ ] Add activity bar div
- [ ] Add primary sidebar div
- [ ] Add right panel div
- [ ] Wrap navbarPage in main-canvas

### **Phase 2: Content (2 hours)**
- [ ] Create sidebar content for each tab
  - [ ] Home sidebar
  - [ ] Data sidebar
  - [ ] Diversity sidebar
  - [ ] Ordination sidebar
  - [ ] About sidebar
- [ ] Create right panel content

### **Phase 3: Interactivity (2 hours)**
- [ ] Activity bar click handlers
- [ ] Sidebar toggle functionality
- [ ] Right panel toggle
- [ ] Sync with Shiny tabs
- [ ] Update active states

### **Phase 4: Testing (1 hour)**
- [ ] Test tab switching
- [ ] Test sidebar collapse/expand
- [ ] Test right panel
- [ ] Verify all modules still work
- [ ] Check on different screen sizes

**Total Time:** 7 hours (1 day)

---

## 🚀 Quick Win Alternative

**If time is critical, do THIS FIRST:**

### **30-Minute Solution:**

Just add the activity bar visual indicator:

```r
# Add before navbarPage
div(class = "activity-bar", style = "position: fixed; left: 0; top: 35px; width: 48px; height: calc(100vh - 35px); background: #333; z-index: 1000;",
  div(style = "padding: 8px 0;",
    div(class = "activity-item", style = "width: 48px; height: 48px; display: flex; align-items: center; justify-content: center; color: #888; font-size: 24px; cursor: pointer;",
        onclick = "Shiny.setInputValue('goto_tab', 'home', {priority: 'event'})",
        "🏠"),
    div(class = "activity-item", onclick = "Shiny.setInputValue('goto_tab', 'data', {priority: 'event'})", "📊"),
    div(class = "activity-item", onclick = "Shiny.setInputValue('goto_tab', 'diversity', {priority: 'event'})", "📈"),
    div(class = "activity-item", onclick = "Shiny.setInputValue('goto_tab', 'ordination', {priority: 'event'})", "🔵"),
    div(style = "flex: 1;"),
    div(class = "activity-item", onclick = "Shiny.setInputValue('goto_tab', 'about', {priority: 'event'})", "❓")
  )
)

# Add padding to navbarPage so it doesn't overlap
tags$style(".navbar { margin-left: 48px; }")
```

This gives the **visual appearance** of the prototype without breaking anything!

---

## 💡 Recommendation

**For v3.0 launch:**
- ✅ Implement 30-minute quick win NOW
- ✅ Adds visual prototype feel
- ✅ Zero risk to functionality

**For v3.1:**
- ✅ Full hybrid implementation (7 hours)
- ✅ Complete sidebar functionality
- ✅ Right panel with dataset info

---

**Current Priority:** Get v3.0 launched with visual activity bar

**Next Priority:** v3.1 adds full sidebar functionality

**Author:** Jimmy Moses  
**Date:** 2025-10-25
