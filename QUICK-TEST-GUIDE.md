# 🚀 QUICK START: Test Diversity Modules

## ⚡ Instant Testing Guide

**App Status:** 🟢 Running at http://127.0.0.1:7051

---

## 📋 5-Minute Test Checklist

### **1. Launch the App (DONE ✅)**

Click the **preview button** in the tool panel to open Ördin v3.0.

---

### **2. Test iNEXT Diversity Estimation (2 minutes)**

**Steps:**

1. Click **"Diversity"** tab in navigation
2. Select **"Diversity Estimation (iNEXT)"** from dropdown
3. **Use default settings:**
   - Data Type: Abundance ✅
   - Diversity Orders: q=0, 1, 2 ✅
   - Bootstrap: 50 ✅
   - Confidence: 0.95 ✅
4. Click **"▶ Run iNEXT"** button
5. Wait for analysis (~5-10 seconds)
6. **Verify:**
   - ✅ Green tip boxes appear at top
   - ✅ "Step 1, 2, 3" headers visible
   - ✅ Plot appears
   - ✅ Data table shows asymptotic estimates
7. **Try different plots:**
   - Sample-size based R/E Curve
   - Sample Completeness Curve
   - Coverage-based R/E Curve
8. Click **"💾 Export PNG"** (should download)
9. Click **"📋 Export Results (CSV)"** (should download)

**Expected Result:**
- Rarefaction curves with confidence bands
- Color-coded lines for different sites
- Educational tip boxes explaining parameters
- Clean, professional plots

---

### **3. Test Diversity Indices (2 minutes)**

**Steps:**

1. In Diversity tab, select **"Diversity Indices (Shannon, Simpson, etc.)"** from dropdown
2. **Select indices:**
   - ✅ Shannon
   - ✅ Simpson
   - ✅ Species Richness
   - ☑️ Inverse Simpson (optional)
   - ☑️ Pielou's Evenness (optional)
3. Click **"▶ Calculate Indices"**
4. Wait for calculation (~2-3 seconds)
5. **Verify:**
   - ✅ Green tip boxes explain each index
   - ✅ Faceted bar plots appear (one per index)
   - ✅ Interpretation box shows mean values
   - ✅ Data table shows all sites
   - ✅ Summary statistics table visible
6. Click **"💾 Export PNG"**
7. Click **"📋 Export Results (CSV)"**

**Expected Result:**
- Faceted bar plots showing diversity by site
- Summary statistics (mean, SD, min, max)
- Interpretation box with color-coded insights
- Clean data table

---

### **4. Visual Inspection (1 minute)**

**Check UI Elements:**

- ✅ **Tip boxes** are green (#1a3a2e background, #2e8b57 border)
- ✅ **Headers** use SeaGreen (#2e8b57)
- ✅ **Background** is dark (#1e1e1e / #252526)
- ✅ **Text** is readable (#ccc, #888)
- ✅ **Buttons** are styled correctly
- ✅ **Loading spinners** appear during analysis
- ✅ **Notifications** show success/error messages

**Prototype Comparison:**

Compare with: `c:\Users\UOTSTD933\Documents\workspace\jmoses\github_projects\ordin\prototype\index.html`

Open prototype and compare:
- Educational content matches? ✅
- Colors match? ✅
- Workflow structure matches? ✅

---

## 🎯 What to Look For

### **✅ SUCCESS INDICATORS**

1. **Educational Content**
   - Tip boxes explain parameters clearly
   - Step-by-step workflow guides user
   - "TIP:", "KNOWLEDGE:" prefixes visible

2. **Functionality**
   - Analysis runs without errors
   - Plots render correctly
   - Tables populate with data
   - Export buttons work

3. **UI/UX**
   - Consistent VS Code dark theme
   - Green accent color throughout
   - Loading spinners during processing
   - Clear success notifications

4. **Professional Quality**
   - Publication-ready plots
   - Clean, readable tables
   - No UI glitches
   - Smooth interactions

---

### **❌ FAILURE INDICATORS**

If you see any of these, report immediately:

- ❌ Blank plots
- ❌ Error messages in red
- ❌ Missing tip boxes
- ❌ UI elements misaligned
- ❌ Export buttons not working
- ❌ App crashes or freezes
- ❌ Wrong colors (not VS Code theme)

---

## 🔍 Detailed Feature Checks

### **iNEXT Module**

**Tip Boxes (should see 3):**
1. ✅ "ℹ️ TIP: Choosing Your Data Type"
2. ✅ "ℹ️ TIP: Parameter Guidelines"
3. ✅ "ℹ️ TIP: Understanding Plot Types"

**Workflow Steps (should see 3):**
1. ✅ "Step 1: Select Data Type"
2. ✅ "Step 2: Configure Parameters"
3. ✅ "Step 3: Select Plot Type & View Results"

**Interactive Elements:**
- ✅ Data type dropdown (Abundance/Incidence)
- ✅ Diversity order checkboxes (q=0,1,2)
- ✅ Numeric inputs (endpoint, bootstrap, confidence)
- ✅ Plot type selector (3 options)
- ✅ Run button (green)
- ✅ Export buttons (2)

---

### **Diversity Indices Module**

**Tip Boxes (should see 2):**
1. ✅ "ℹ️ TIP: Choosing the Right Index"
2. ✅ "💡 KNOWLEDGE: When to Use Each"

**Interactive Elements:**
- ✅ Index checkboxes (5 options)
- ✅ Calculate button (green)
- ✅ Export buttons (2)

**Output Elements:**
- ✅ Interpretation box (green background)
- ✅ Faceted bar plot
- ✅ Data table (DT)
- ✅ Summary statistics table

---

## 📊 Sample Test Data

**Default Data:** Uses R's `dune` dataset (vegan package)
- 20 sites
- 30 species
- Abundance data (count data)

**Perfect for testing:**
- Small enough to run quickly
- Real ecological data
- Well-studied dataset
- Reliable results

---

## 🎨 Visual Reference

### **Expected Color Scheme**

```
Background:     #1e1e1e (dark charcoal)
Panels:         #252526 (slightly lighter)
Accent:         #2e8b57 (sea green)
Text Primary:   #cccccc (light gray)
Text Secondary: #888888 (medium gray)
Borders:        #3e3e42 (dark gray)
Tip Box BG:     #1a3a2e (dark green tint)
```

### **Expected Fonts**

```
Headers:  14-16px, bold, #2e8b57
Body:     12-13px, normal, #ccc
Tips:     12px, normal, #ccc
```

---

## 🔧 Troubleshooting

### **If App Won't Load:**

1. Check terminal output for errors
2. Verify port 7051 is available
3. Try clicking preview button again
4. Check R packages installed

### **If Analysis Fails:**

1. Check data is loaded (should use `dune` by default)
2. Verify parameters are valid
3. Look for error notifications
4. Check terminal for R error messages

### **If Exports Don't Work:**

1. Check browser download settings
2. Verify write permissions
3. Look for error notifications
4. Check file naming in code

---

## ✅ Completion Criteria

**Test is COMPLETE when you verify:**

1. ✅ Both diversity modules work
2. ✅ All tip boxes display correctly
3. ✅ Plots render professionally
4. ✅ Tables show data
5. ✅ Exports download files
6. ✅ UI matches prototype design
7. ✅ No errors in console
8. ✅ Loading indicators appear

---

## 📝 Quick Test Results Template

**Copy and fill out:**

```
=== ÖRDIN v3.0 DIVERSITY TEST RESULTS ===

Date: _____________
Tester: ___________

iNEXT Module:
[ ] Tip boxes visible
[ ] Analysis runs successfully
[ ] All 3 plot types work
[ ] PNG export works
[ ] CSV export works

Diversity Indices:
[ ] Tip boxes visible
[ ] Analysis runs successfully
[ ] Faceted plots render
[ ] Interpretation box shows
[ ] PNG export works
[ ] CSV export works

UI/UX:
[ ] Colors match VS Code theme
[ ] Loading spinners appear
[ ] Notifications work
[ ] Buttons styled correctly

Overall Status:
[ ] PASS - Ready for production
[ ] FAIL - Issues found (list below)

Issues:
_____________________
_____________________

Notes:
_____________________
_____________________
```

---

## 🚀 Next Steps After Testing

**If tests PASS:**
1. ✅ Mark diversity modules as production-ready
2. ✅ Move to next feature (if any)
3. ✅ Consider user acceptance testing
4. ✅ Plan deployment

**If tests FAIL:**
1. ❌ Document specific failures
2. ❌ Report to developer
3. ❌ Re-test after fixes
4. ❌ Update documentation

---

**Happy Testing! 🎉**

**App Location:** http://127.0.0.1:7051  
**Preview:** Click the preview button in tool panel  
**Status:** 🟢 Ready for testing

---

**Built by:** Jimmy Moses  
**Version:** Ördin v3.0  
**Date:** 2025-10-25
