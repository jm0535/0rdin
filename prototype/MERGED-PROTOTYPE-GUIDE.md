# Merged Prototype Guide - Ördin v3.0

**Author:** Jimmy Moses (jimmy.moses@pnguot.ac.pg)  
**Date:** 2025-10-25  
**Version:** Prototype v3.0 (Merged Edition)

---

## 🎉 What's New

The **index.html** prototype has been upgraded with **full tab management functionality** from results-demo.html!

### ✅ Tasks Completed

1. ✅ **Added content for remaining tabs** - Dashboard and Diversity Analysis tabs now fully functional
2. ✅ **Merged prototypes** - Combined index.html workflow system with results-demo.html tab system
3. ✅ **Added tab functionality** - Full VS Code-style tab management implemented

---

## 📋 Features Overview

### Tab Management System

The prototype now includes a **complete tab management system** similar to VS Code:

- **Create new tabs** dynamically when analysis starts
- **Switch between tabs** by clicking
- **Close tabs** with × button (except last tab)
- **Active tab highlighting** with green border
- **Breadcrumb updates** based on active tab
- **Status badge updates** showing analysis state

### Three Tab Types

#### 1. Dashboard Tab (Home)
- **Icon:** 🏠
- **Purpose:** Welcome screen and quick actions
- **Content:** 
  - Welcome message
  - Three action cards (Import Data, Diversity, Ordination)
- **Breadcrumb:** `Home → Dashboard`
- **Status:** `● Ready`

#### 2. Diversity Analysis Tab
- **Icon:** 📈
- **Purpose:** iNEXT rarefaction and diversity estimation
- **Content:**
  - Knowledge box explaining iNEXT
  - Rarefaction curve placeholder (400px height)
  - Plot controls (Customize, Zoom, Export)
  - Configuration panel (Plot type, Diversity order, Confidence level)
  - Run Analysis button
- **Breadcrumb:** `Analysis → Diversity Estimation`
- **Status:** `● Analysis Complete`

#### 3. NMDS Results Tab
- **Icon:** 🗺️
- **Purpose:** Ordination results visualization
- **Content:**
  - **Horizontal split layout** (70% plot + 30% results)
  - Interactive NMDS plot with SVG
  - Results panel with collapsible sections:
    - Ordination Statistics (Stress, Convergence, etc.)
    - PERMANOVA Results (F-statistic, R², p-value)
    - Pairwise Comparisons
  - Export buttons (CSV, PDF)
- **Breadcrumb:** `Analysis → NMDS Results`
- **Status:** `● Analysis Complete`

---

## 🔧 Technical Implementation

### HTML Structure

```html
<!-- Tab Bar -->
<div class="tab-bar" id="tabBar">
    <div class="tab active" 
         data-tab-id="dashboard" 
         onclick="switchToTab('dashboard')">
        🏠 Dashboard 
        <span class="tab-close" onclick="closeTab(event, 'dashboard')">×</span>
    </div>
</div>

<!-- Content Area -->
<div class="content-area" id="contentArea">
    <!-- Dashboard Tab Content -->
    <div id="tab-dashboard" class="tab-content active">
        <!-- Dashboard content here -->
    </div>
</div>
```

### JavaScript Functions

#### 1. Create New Tab
```javascript
createNewTab(tabId, tabTitle, contentType)
```
- **tabId:** Unique identifier (e.g., 'nmds', 'diversity')
- **tabTitle:** Display title with emoji (e.g., '📈 Diversity Analysis')
- **contentType:** Content template to use ('diversity', 'results')

**Example Usage:**
```javascript
// From dashboard action card
createNewTab('diversity', '📈 Diversity Analysis', 'diversity');
```

#### 2. Switch to Tab
```javascript
switchToTab(tabId)
```
- Updates active states for tabs and content
- Updates breadcrumb and status badge
- **Called automatically** when creating new tabs or clicking tabs

#### 3. Close Tab
```javascript
closeTab(event, tabId)
```
- Prevents closing the last remaining tab
- Automatically switches to previous tab if closing active tab
- Removes tab from array and DOM

#### 4. Render Tab Bar
```javascript
renderTabBar()
```
- Re-renders all tabs in the tab bar
- Called after creating or closing tabs
- Maintains active state

---

## 🎨 CSS Styling

### Tab Styles

```css
.tab {
    padding: 8px 16px;
    background: #2a2a2a;
    border-right: 1px solid #3e3e42;
    cursor: pointer;
    color: #888;
}

.tab.active {
    background: #1e1e1e;
    color: #cccccc;
    border-bottom: 1px solid #2e8b57; /* Green accent */
}

.tab-close {
    margin-left: 4px;
    opacity: 0.6;
}

.tab-close:hover {
    opacity: 1;
    color: #ff6b6b; /* Red on hover */
}
```

### Tab Content Styles

```css
.tab-content {
    display: none;
    width: 100%;
    height: 100%;
}

.tab-content.active {
    display: block;
}
```

---

## 🚀 How to Use the Prototype

### Testing Tab Creation

1. **Open index.html** in browser
2. Click **"Analyze →"** button in Diversity card
3. **New tab appears:** `📈 Diversity Analysis`
4. Click **"Explore →"** button in Ordination card
5. **New tab appears:** `🗺️ NMDS Results`

### Testing Tab Switching

1. **Click any tab** in the tab bar
2. **Content area updates** to show that tab's content
3. **Breadcrumb updates** (top-left)
4. **Status badge updates** (top-center)
5. **Tab highlighting** shows active tab with green border

### Testing Tab Closing

1. **Hover over any tab** (except if it's the only tab)
2. **× button appears** on the right
3. **Click ×** to close tab
4. **Previous tab activates** automatically
5. **Try closing last tab:** Alert says "Cannot close the last tab"

---

## 📊 Data Flow Diagram

```
User Action
    ↓
Dashboard Card Click
    ↓
createNewTab('diversity', '📈 Diversity Analysis', 'diversity')
    ↓
├─ Check if tab exists
│   ↓ Yes → switchToTab(tabId)
│   ↓ No  → Continue
├─ Add to openTabs array
├─ renderTabBar()
├─ createTabContent(tabId, 'diversity')
│   ↓
│   └─ getDiversityTabContent() returns HTML
├─ Append to DOM
└─ switchToTab(tabId)
    ↓
    ├─ Update tab active states
    ├─ Update content active states
    └─ updateBreadcrumbForTab(tabId)
```

---

## 🔀 Differences from results-demo.html

| Feature | results-demo.html | index.html (Merged) |
|---------|------------------|-------------------|
| **Tab Creation** | Static (3 hardcoded tabs) | Dynamic (create on demand) |
| **Workflow System** | ❌ Not implemented | ✅ Full workflow integration |
| **Layout Modes** | 3 buttons (Single, H-Split, V-Split) | Integrated in NMDS tab content |
| **Sidebar** | Static ordination menu | Dynamic (changes per view) |
| **Dashboard** | Minimal (alert only) | Full welcome screen + action cards |
| **Diversity Tab** | Alert placeholder | Full iNEXT configuration UI |

---

## 🎯 Recommended Workflow

### For Users

1. **Start:** Open prototype → Dashboard tab active
2. **Import Data:** Click "Get Started →" → Switches to Data view
3. **Run Analysis:** 
   - Click "Analyze →" → Creates Diversity tab
   - Configure parameters
   - Click "▶ Run Diversity Analysis"
4. **View Results:**
   - Click "Explore →" → Creates NMDS tab
   - See plot (70%) + results panel (30%)
   - Export as needed

### For Developers

1. **Test all tabs:** Create and switch between multiple tabs
2. **Test closing:** Close tabs in different orders
3. **Test workflows:** Navigate sidebar items (opens workflows in active tab)
4. **Test persistence:** Tabs should remain until explicitly closed

---

## 📝 Implementation Notes

### Global Variables

```javascript
let openTabs = [{ id: 'dashboard', title: '🏠 Dashboard', type: 'dashboard' }];
let activeTabId = 'dashboard';
```

- **openTabs:** Array tracking all open tabs
- **activeTabId:** Currently visible tab ID

### Content Templates

Two main content generators:

1. **getDiversityTabContent()** - Returns 200+ lines of HTML for diversity analysis UI
2. **getNMDSResultsTabContent()** - Returns 180+ lines of HTML with SVG plot + results panel

Both use **inline styles** for portability (no external CSS dependencies).

---

## 🐛 Known Limitations

1. **No persistence:** Tabs lost on page refresh (use localStorage in production)
2. **No unsaved changes warning:** Closing tabs doesn't warn about data loss
3. **Static content:** Plots and results are placeholders (need R Shiny integration)
4. **No tab reordering:** Can't drag tabs to rearrange (VS Code feature)
5. **No split views:** Can't view multiple tabs side-by-side

---

## 🔮 Future Enhancements

### Recommended for Production

1. **LocalStorage Integration**
   ```javascript
   // Save tabs on change
   localStorage.setItem('ordin_tabs', JSON.stringify(openTabs));
   
   // Restore on load
   const savedTabs = JSON.parse(localStorage.getItem('ordin_tabs'));
   ```

2. **Unsaved Changes Detection**
   ```javascript
   let tabsWithChanges = new Set();
   
   function closeTab(event, tabId) {
       if (tabsWithChanges.has(tabId)) {
           if (!confirm('Discard unsaved changes?')) return;
       }
       // ... close logic
   }
   ```

3. **Tab Context Menu**
   ```javascript
   // Right-click menu
   - Close Tab
   - Close Other Tabs
   - Close Tabs to Right
   - Close All Tabs
   ```

4. **Tab Overflow Handling**
   ```css
   .tab-bar {
       overflow-x: auto;
       overflow-y: hidden;
   }
   ```

5. **Keyboard Shortcuts**
   ```javascript
   // Ctrl+W to close tab
   // Ctrl+Tab to switch tabs
   // Ctrl+Shift+T to reopen closed tab
   ```

---

## 📚 File Versions

- **index.html** - Updated to v21 (prototype.js?v=21)
- **prototype.js** - Updated with 365 new lines of tab management code
- **prototype-styles.css** - Updated to v7 (added .tab-close and .tab-content styles)

---

## ✅ Testing Checklist

- [ ] Dashboard tab loads on initial open
- [ ] Clicking "Analyze →" creates Diversity tab
- [ ] Clicking "Explore →" creates NMDS tab
- [ ] Switching tabs updates breadcrumb
- [ ] Switching tabs updates status badge
- [ ] Active tab has green bottom border
- [ ] × button appears on hover (not on last tab)
- [ ] Clicking × closes tab
- [ ] Cannot close last remaining tab
- [ ] Closing active tab switches to previous tab
- [ ] Duplicate tabs not created (switches to existing)
- [ ] NMDS tab shows horizontal split (70/30)
- [ ] Diversity tab shows configuration panel
- [ ] Dashboard shows action cards
- [ ] Sidebar workflows still work (opens content in active tab)
- [ ] Hard refresh clears cache (Ctrl+Shift+R)

---

## 🎓 Educational Notes

### Why This Design?

**VS Code-inspired tab system** because:
- ✅ Familiar to developers
- ✅ Efficient use of screen space
- ✅ Clear visual hierarchy
- ✅ Easy to switch contexts
- ✅ Industry-standard UX pattern

**Horizontal split (70/30)** because:
- ✅ Plot is primary focus (larger)
- ✅ Results panel always visible (no scrolling needed)
- ✅ Matches scientific workflow (visual → numerical)
- ✅ Efficient for wide monitors

**Dynamic tab creation** because:
- ✅ Only opens tabs when needed (reduces clutter)
- ✅ User controls their workspace
- ✅ Reflects actual workflow (configure → run → view results)
- ✅ Scalable (can have 10+ analyses open)

---

## 📞 Support

For questions or issues:
- **Author:** Jimmy Moses
- **Email:** jimmy.moses@pnguot.ac.pg
- **Institution:** PNG University of Technology

---

**Happy Testing! 🚀**
