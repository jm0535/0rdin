# Auto-Select Data Type Feature

**Feature**: Automatic data type selection based on detection  
**Status**: ✅ Implemented  
**Date**: 2025-10-23  
**Author**: Jimmy Moses (jmoses@pnguot.ac.pg)

---

## 🎯 **What Changed**

### **Before** (Manual Selection)
1. User uploads data file
2. Ördin detects format and shows detection box
3. **User must manually select** from dropdown
4. User clicks "Run Analysis"

**Problem**: Extra step, users might select wrong type

---

### **After** (Auto-Selection) ✅
1. User uploads data file
2. Ördin detects format and shows detection box
3. **Dropdown automatically updates** to match detected format
4. Notification confirms auto-selection
5. User clicks "Run Analysis" (or changes selection if needed)

**Benefit**: One less step, correct type pre-selected!

---

## 🔧 **How It Works**

### **Technical Implementation**

```r
# Auto-update data type selection based on detection
observeEvent(data(), {
  req(data())
  
  detected_format <- data()$data_format
  
  # Update the selectInput to match detected format
  updateSelectInput(session, "dataType", selected = detected_format)
  
  # Show notification about auto-selection
  showNotification(
    paste0("✓ Auto-selected: ", 
           if(detected_format == "abundance") "Abundance - Individual counts"
           else if(detected_format == "incidence_raw") "Incidence_raw - Presence/absence (0/1)"
           else "Incidence_freq - Sampling units (SamplingUnits column)"),
    type = "message",
    duration = 4
  )
})
```

### **Trigger**
- Activates **immediately after** data is loaded
- Uses `observeEvent(data(), ...)` to watch for new data
- Runs **before** user clicks "Run Analysis"

### **Actions**
1. **Detects** format (abundance/incidence_raw/incidence_freq)
2. **Updates** dropdown to match detected format
3. **Shows** notification confirming selection

---

## 🎨 **User Experience**

### **Scenario 1: Spider Abundance Data**

**User Action**: Upload `spider-abundance.csv`

**Ördin Response**:
```
1. File loads ✓
2. Detection box appears:
   ┌─────────────────────────────────────┐
   │ 📊 Detected: Abundance              │
   │ Individual counts (0, 1, 2, 3, ...) │
   └─────────────────────────────────────┘

3. Dropdown automatically changes to:
   "Abundance - Individual counts" ✓

4. Notification shows:
   "✓ Auto-selected: Abundance - Individual counts"

5. User sees dropdown is already correct ✓
6. User clicks "Run Analysis" → Works!
```

**Result**: **No manual selection needed!**

---

### **Scenario 2: Plant Presence Data**

**User Action**: Upload `plant-presence.csv`

**Ördin Response**:
```
1. File loads ✓
2. Detection box appears:
   ┌─────────────────────────────────────┐
   │ ✓ Detected: Incidence_raw           │
   │ Presence/absence (binary: 0, 1)     │
   └─────────────────────────────────────┘

3. Dropdown automatically changes to:
   "Incidence_raw - Presence/absence (0/1)" ✓

4. Notification shows:
   "✓ Auto-selected: Incidence_raw - Presence/absence (0/1)"

5. User sees correct type pre-selected ✓
6. User clicks "Run Analysis" → Works!
```

**Result**: **Perfect match, no action needed!**

---

### **Scenario 3: Ant Incidence Frequency Data**

**User Action**: Upload `ant-incidence.csv`

**Ördin Response**:
```
1. File loads ✓
2. Detection box appears:
   ┌──────────────────────────────────────────┐
   │ 🔢 Detected: Incidence_freq              │
   │ Sampling units: 599, 230, 150, 200, 200  │
   └──────────────────────────────────────────┘

3. Dropdown automatically changes to:
   "Incidence_freq - Sampling units (SamplingUnits column)" ✓

4. Notification shows:
   "✓ Auto-selected: Incidence_freq - Sampling units (SamplingUnits column)"

5. User sees specialized type pre-selected ✓
6. User clicks "Run Analysis" → Works!
```

**Result**: **Complex format handled automatically!**

---

## ⚙️ **User Control**

### **Can Users Override?**

**YES!** Auto-selection is a **default**, not a lock.

**If user wants to change**:
1. Data loads and auto-selects type
2. User clicks dropdown
3. User selects different type
4. Ördin shows warning if mismatch (already implemented)
5. Analysis uses auto-detected format (safe override)

**Example**:
```
User uploads binary data (0/1)
→ Auto-selects: "Incidence_raw"
→ User manually changes to: "Abundance"
→ Ördin shows warning: "Auto-detected binary data (0/1). 
   Using incidence_raw format instead of abundance."
→ Analysis proceeds with incidence_raw (correct choice)
```

**Safety**: Auto-detection **always** overrides user selection in analysis logic, so wrong selection won't break analysis.

---

## 📊 **Visual Feedback**

### **Notification Appearance**

```
┌─────────────────────────────────────────────────────┐
│ ✓ Auto-selected: Abundance - Individual counts     │
└─────────────────────────────────────────────────────┘
    Duration: 4 seconds
    Type: Info (blue)
    Position: Top-right
```

### **Dropdown Update**

```
BEFORE upload:
┌────────────────────────────────────────────────┐
│ Abundance - Individual counts               ▼ │  ← Default
└────────────────────────────────────────────────┘

AFTER upload (incidence_raw detected):
┌────────────────────────────────────────────────┐
│ Incidence_raw - Presence/absence (0/1)      ▼ │  ← Auto-updated!
└────────────────────────────────────────────────┘
```

---

## 🎓 **Benefits**

### **For New Users**
- ✅ **One less step** to worry about
- ✅ **Correct type pre-selected**
- ✅ **Immediate feedback** (notification)
- ✅ **Builds confidence** in auto-detection
- ✅ **Faster workflow**

### **For Advanced Users**
- ✅ **Can still override** if needed
- ✅ **Validates understanding** (does selection match detection?)
- ✅ **Saves time** on routine uploads
- ✅ **Clear feedback** on what was detected

### **For Teaching**
- ✅ **Demonstrates** auto-detection in action
- ✅ **Shows** correct data type for each dataset
- ✅ **Explains** format through selection
- ✅ **Reinforces** the three data types

---

## 🧪 **Testing Scenarios**

### **Test 1: Upload Spider Data**
```
Expected:
1. Upload spider-abundance.csv
2. See "📊 Detected: Abundance"
3. Dropdown auto-selects "Abundance - Individual counts"
4. Notification: "✓ Auto-selected: Abundance - Individual counts"
✅ PASS if dropdown shows "Abundance"
```

### **Test 2: Upload Plant Data**
```
Expected:
1. Upload plant-presence.csv
2. See "✓ Detected: Incidence_raw"
3. Dropdown auto-selects "Incidence_raw - Presence/absence (0/1)"
4. Notification: "✓ Auto-selected: Incidence_raw - Presence/absence (0/1)"
✅ PASS if dropdown shows "Incidence_raw"
```

### **Test 3: Upload Ant Data**
```
Expected:
1. Upload ant-incidence.csv
2. See "🔢 Detected: Incidence_freq"
3. Dropdown auto-selects "Incidence_freq - Sampling units (SamplingUnits column)"
4. Notification: "✓ Auto-selected: Incidence_freq - Sampling units (SamplingUnits column)"
✅ PASS if dropdown shows "Incidence_freq"
```

### **Test 4: Change Data Files**
```
Expected:
1. Upload spider-abundance.csv → Dropdown: "Abundance" ✓
2. Upload plant-presence.csv → Dropdown: "Incidence_raw" ✓
3. Upload ant-incidence.csv → Dropdown: "Incidence_freq" ✓
✅ PASS if dropdown updates each time
```

### **Test 5: Manual Override**
```
Expected:
1. Upload plant-presence.csv → Auto-selects "Incidence_raw"
2. Manually change to "Abundance"
3. Click "Run Analysis"
4. See warning: "Auto-detected binary data (0/1)..."
5. Analysis uses incidence_raw (correct)
✅ PASS if warning shows and correct format used
```

---

## 📝 **Code Changes**

### **Location**: `shiny/app.R`

### **Added** (lines ~220-240):
```r
# Auto-update data type selection based on detection
observeEvent(data(), {
  req(data())
  
  detected_format <- data()$data_format
  
  # Update the selectInput to match detected format
  updateSelectInput(session, "dataType", selected = detected_format)
  
  # Show notification about auto-selection
  showNotification(
    paste0("✓ Auto-selected: ", 
           if(detected_format == "abundance") "Abundance - Individual counts"
           else if(detected_format == "incidence_raw") "Incidence_raw - Presence/absence (0/1)"
           else "Incidence_freq - Sampling units (SamplingUnits column)"),
    type = "message",
    duration = 4
  )
})
```

### **Key Function**: `updateSelectInput()`
- Shiny function that updates dropdown value
- `session`: Current Shiny session
- `"dataType"`: ID of the selectInput to update
- `selected = detected_format`: New value to select

---

## 🔄 **Workflow Comparison**

### **Old Workflow** (5 steps):
```
1. Upload file
2. See detection box
3. Manually select data type from dropdown
4. Verify selection matches detection
5. Click "Run Analysis"
```

### **New Workflow** (3 steps):
```
1. Upload file
2. See detection box + auto-selection notification ✓
3. Click "Run Analysis"
```

**Improvement**: **40% fewer steps!**

---

## ⚠️ **Edge Cases**

### **Case 1: File Upload Error**
```
If file fails to load:
→ No auto-selection (req(data()) fails)
→ Dropdown stays at default
→ No notification
```

### **Case 2: Ambiguous Data**
```
Not possible - detection is deterministic:
- Has SamplingUnits column? → incidence_freq
- All values 0/1? → incidence_raw
- Otherwise → abundance
```

### **Case 3: Multiple File Uploads**
```
Upload file A → Auto-selects type A
Upload file B → Auto-selects type B (overwrites)
Upload file A again → Auto-selects type A (correct)
```

### **Case 4: User Changes Type Before Analysis**
```
Auto-selects → User changes → User changes back
→ No problem, selection is just a UI state
→ Analysis always uses auto-detected format
```

---

## 📚 **Related Features**

### **Works With**:
1. **Format auto-detection** (already implemented)
2. **Detection status box** (already implemented)
3. **Validation warnings** (already implemented)
4. **Error handling** (already implemented)

### **Complements**:
1. **Data type info box** - Users learn what each type is
2. **Detection confirmation** - Visual feedback reinforces selection
3. **Diagnostics output** - Shows format in console

---

## ✅ **Summary**

### **What This Feature Does**:
- ✅ **Automatically selects** correct data type after upload
- ✅ **Shows notification** confirming auto-selection
- ✅ **Updates dropdown** to match detected format
- ✅ **Allows override** if user wants to change
- ✅ **Reduces steps** in workflow

### **User Impact**:
- ✅ **Faster**: One less click
- ✅ **Easier**: No need to figure out which to select
- ✅ **Safer**: Correct type pre-selected
- ✅ **Clearer**: Notification confirms what happened
- ✅ **Flexible**: Can still override if needed

### **Implementation**:
- ✅ **Simple**: One `observeEvent()` block
- ✅ **Reliable**: Uses existing detection logic
- ✅ **User-friendly**: Clear notification
- ✅ **Safe**: Doesn't prevent manual selection

---

**Result**: Seamless auto-selection that "just works"! 🎉
