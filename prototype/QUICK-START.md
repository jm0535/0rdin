# Quick Start Guide - Ördin v3.0 Prototype

**For:** User Testing & Demo  
**Time:** 5 minutes

---

## 🚀 Open the Prototype

1. Navigate to: `prototype/index.html`
2. Double-click to open in browser
3. Press **Ctrl+Shift+R** to hard refresh (clears cache)

---

## 🎯 Test the New Features

### ✅ Feature 1: Dashboard Tab (Home Screen)

**What to see:**
- Large green "Ö" logo
- "Ördin v3.0" title
- Three action cards

**What to test:**
1. Click **"Get Started →"** (Import Data)
   - Sidebar switches to DATA MANAGER view
   - Breadcrumb updates
2. Return to Home view (🏠 icon in activity bar)

---

### ✅ Feature 2: Create Diversity Tab

**What to test:**
1. From Dashboard, click **"Analyze →"** button
2. **New tab appears:** `📈 Diversity Analysis`
3. **Look for:**
   - Green knowledge box explaining iNEXT
   - Plot placeholder (gray box, 400px)
   - Control buttons (Customize, Zoom, Export)
   - Configuration panel with:
     - Plot Type dropdown
     - Diversity Order dropdown
     - Confidence Level input
     - "▶ Run Diversity Analysis" button

**Breadcrumb should show:** `Analysis → Diversity Estimation`  
**Status badge should show:** `● Analysis Complete`

---

### ✅ Feature 3: Create NMDS Results Tab

**What to test:**
1. From Dashboard (or any tab), click **"Explore →"** button
2. **New tab appears:** `🗺️ NMDS Results`
3. **Look for:**
   - **Left side (70%):** NMDS plot with:
     - SVG visualization
     - Three colored groups (Forest, Grassland, Disturbed)
     - Stress value: 0.089
     - Control buttons below plot
   - **Right side (30%):** Results panel with:
     - Ordination Statistics (collapsible)
     - PERMANOVA Results
     - Pairwise Comparisons
     - Export buttons

**Breadcrumb should show:** `Analysis → NMDS Results`  
**Status badge should show:** `● Analysis Complete`

---

### ✅ Feature 4: Switch Between Tabs

**What to test:**
1. You should now have **3 tabs open:**
   - 🏠 Dashboard
   - 📈 Diversity Analysis
   - 🗺️ NMDS Results

2. **Click each tab** and verify:
   - Content area changes
   - Breadcrumb updates
   - Status badge updates
   - Active tab has **green bottom border**
   - Tab text changes from gray (#888) to white (#ccc)

---

### ✅ Feature 5: Close Tabs

**What to test:**
1. **Hover over any tab** (except Dashboard if it's the only one)
2. **× button appears** on the right
3. **Click ×** to close the tab
4. **Verify:**
   - Tab disappears
   - If you closed the active tab → switches to previous tab
   - Tab bar updates

5. **Try closing the last remaining tab:**
   - Alert: "Cannot close the last tab"
   - Tab remains open

---

### ✅ Feature 6: Prevent Duplicate Tabs

**What to test:**
1. Click **"Analyze →"** button again
2. **Should NOT create a new tab**
3. Instead, **switches to existing Diversity tab**
4. Same for NMDS tab

---

## 📊 Visual Checklist

After testing, you should have confirmed:

- [ ] Dashboard shows welcome screen + 3 cards
- [ ] Diversity tab shows full configuration UI
- [ ] NMDS tab shows 70/30 split layout
- [ ] SVG plot renders correctly
- [ ] Results panel shows statistics
- [ ] Tabs are clickable and switch content
- [ ] Active tab has green border
- [ ] × button closes tabs
- [ ] Last tab cannot be closed
- [ ] Duplicate tabs prevented
- [ ] Breadcrumb updates per tab
- [ ] Status badge updates per tab

---

## 🎨 Visual Reference

### Expected Tab Bar
```
┌─────────────────────────────────────────────────────┐
│ 🏠 Dashboard × │ 📈 Diversity Analysis × │ 🗺️ NMDS Results × │
│     (active)                                         │
└─────────────────────────────────────────────────────┘
     ▲ Green border
```

### Expected NMDS Layout
```
┌──────────────────────────────────────────────────────┐
│ Plot (70%)                 │ Results (30%)           │
│                            │                         │
│  ┌──────────────────────┐  │ ORDINATION STATISTICS   │
│  │                      │  │ Stress: 0.089           │
│  │   NMDS Plot (SVG)    │  │ Convergence: ✓          │
│  │   • Forest (green)   │  │                         │
│  │   • Grassland (blue) │  │ PERMANOVA RESULTS       │
│  │   • Disturbed (amber)│  │ F-statistic: 12.450     │
│  │                      │  │ p-value: 0.001 ***      │
│  └──────────────────────┘  │                         │
│                            │ PAIRWISE COMPARISONS    │
│ [🎨][🔍][🔍][💾][📄]       │ Forest vs Grassland: ** │
│                            │                         │
└──────────────────────────────────────────────────────┘
```

---

## 🐛 Common Issues

### Issue: Tabs not appearing
**Fix:** Hard refresh (Ctrl+Shift+R) to clear browser cache

### Issue: Styles not loading
**Fix:** Check console for CSS errors, ensure `prototype-styles.css?v=7`

### Issue: JavaScript errors
**Fix:** Check console, ensure `prototype.js?v=21`

### Issue: Content not switching
**Fix:** Inspect element, verify `.tab-content.active` class exists

---

## 📝 Quick Notes

- **Cache version:** v=21 (JavaScript), v=7 (CSS)
- **Total tabs system:** 365 lines of new code
- **Content templates:** 2 (Diversity, NMDS)
- **Tab types:** 3 (Dashboard, Diversity, Results)
- **Default tab:** Dashboard (always open on load)

---

## 🎓 For Developers

**Key functions to know:**

```javascript
// Create new tab
createNewTab(tabId, tabTitle, contentType);

// Switch to existing tab
switchToTab(tabId);

// Close tab
closeTab(event, tabId);

// Example: Create diversity tab from code
createNewTab('diversity', '📈 Diversity Analysis', 'diversity');
```

**Where content is defined:**

- Dashboard: `index.html` (static HTML)
- Diversity: `prototype.js` → `getDiversityTabContent()`
- NMDS: `prototype.js` → `getNMDSResultsTabContent()`

---

## 📚 Full Documentation

For complete details, see:
- **MERGED-PROTOTYPE-GUIDE.md** - Full technical guide
- **TASKS-COMPLETION-SUMMARY.md** - Implementation summary
- **TAB-SWITCHING-GUIDE.md** - Tab system specifics
- **RESULTS-LAYOUT-PLAN.md** - Layout architecture

---

**Happy Testing! 🎉**

If everything works as described above, all 3 tasks are **successfully completed!**
