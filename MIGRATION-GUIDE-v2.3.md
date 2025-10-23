# Migration Guide: v2.2.0 → v2.3.0

## Overview

Upgrading from Ördin v2.2.0 to v2.3.0 is **seamless** with **zero breaking changes**. This guide helps you understand what's new and how to take advantage of the theme toggle feature.

**Note**: Ördin is a **community ecology analysis platform**, encompassing diversity estimation, ordination, community structure, and ecological indices - not limited to biodiversity alone.

---

## 🚀 Quick Migration Steps

### For End Users

1. **Download v2.3.0** installer/package
2. **Install** (overwrites v2.2.0)
3. **Launch Ördin**
4. **Done!** 

That's it. No configuration needed.

---

## ✅ What Works Exactly the Same

Everything from v2.2.0 continues to work identically:

### Analysis Features
- ✅ Diversity Estimation (iNEXT)
- ✅ Ordination Analysis (5 methods)
- ✅ Diversity Indices (vegan)
- ✅ All plot types
- ✅ All export formats

### Data Formats
- ✅ CSV upload (same format)
- ✅ Abundance data
- ✅ Incidence data (raw & frequency)
- ✅ All sample datasets

### Workflows
- ✅ File upload process
- ✅ Analysis configuration
- ✅ Results display
- ✅ Download/export

### UI Layout
- ✅ Navbar structure
- ✅ Sidebar controls
- ✅ Tab organization
- ✅ All buttons and inputs

---

## 🎨 What's New

### Single New Feature: Theme Toggle

**Location**: Far right of navbar

**What it does**:
- Click ☀️ (sun) icon → switches to light theme
- Click 🌙 (moon) icon → switches to dark theme
- Your choice is saved automatically

**Default behavior**:
- First launch: Dark theme (same as v2.2.0)
- Subsequent launches: Your last choice

---

## 📊 Side-by-Side Comparison

| Feature | v2.2.0 | v2.3.0 |
|---------|--------|--------|
| **Theme** | Dark only | Dark + Light |
| **Theme Toggle** | ❌ | ✅ (navbar button) |
| **Theme Persistence** | N/A | ✅ (localStorage) |
| **Diversity Analysis** | ✅ | ✅ (unchanged) |
| **Ordination** | ✅ | ✅ (unchanged) |
| **Indices** | ✅ | ✅ (unchanged) |
| **Export Formats** | 5 formats | 5 formats (same) |
| **Data Upload** | CSV | CSV (same) |
| **Port** | 8895 | 8896 (new) |

---

## 🔄 Differences in Detail

### 1. Port Number Change

**v2.2.0**: Port 8895  
**v2.3.0**: Port 8896

**Impact**: 
- No user impact (automatic)
- Avoids port conflicts
- Both versions can run simultaneously (if needed)

**Action Required**: None

---

### 2. Theme System

**v2.2.0**: 
- Fixed dark theme
- No customization

**v2.3.0**:
- Dark theme (default)
- Light theme (toggle)
- Persistent preference

**Action Required**: 
- Optional: Click theme toggle to try light theme
- Your choice is saved automatically

---

### 3. CSS Architecture

**v2.2.0**: 
- Standard Bootstrap theme
- Fixed colors

**v2.3.0**:
- Custom CSS classes
- Dual-theme support
- Optimized selectors

**Impact**: 
- Slightly faster rendering
- More maintainable code
- Better browser compatibility

**Action Required**: None (internal change)

---

## 🛠️ Installation Methods

### Windows

**Option 1: Clean Install** (Recommended)
```bash
1. Uninstall v2.2.0 (optional)
2. Run Ördin-2.3.0-Setup.exe
3. Launch from Start Menu
```

**Option 2: Overwrite**
```bash
1. Run Ördin-2.3.0-Setup.exe
2. Install to same directory
3. Overwrites v2.2.0 automatically
```

---

### macOS

**Option 1: Replace App** (Recommended)
```bash
1. Delete /Applications/Ördin.app (v2.2.0)
2. Unzip Ordin-darwin-x64-2.3.0.zip
3. Drag new Ördin.app to Applications
```

**Option 2: Rename**
```bash
1. Rename /Applications/Ördin.app to Ördin-2.2.0.app
2. Install new Ördin.app
3. Keep both versions (different ports)
```

---

### Linux (Debian/Ubuntu)

```bash
# Remove v2.2.0
sudo dpkg -r ordin

# Install v2.3.0
sudo dpkg -i ordin_2.3.0_amd64.deb
```

---

### Linux (Fedora/RHEL)

```bash
# Remove v2.2.0
sudo dnf remove ordin

# Install v2.3.0
sudo dnf install ordin-2.3.0-1.x86_64.rpm
```

---

## 💾 Data & Settings

### What's Preserved

**✅ Your data files** (CSV files you uploaded)
- Location: Your Documents/Downloads folder
- Action: None needed

**✅ R packages**
- Location: Bundled with app
- Action: None needed

**✅ Sample datasets**
- Location: `sample-data/` folder
- Action: None needed

### What's New

**🆕 Theme preference**
- Stored in browser localStorage
- Key: `ordin-theme`
- Values: `"dark"` or `"light"`

**First launch**: 
- No saved preference → defaults to `"dark"`
- Same experience as v2.2.0

---

## 🧪 Testing Your Migration

### Recommended Tests

1. **Launch app**
   - ✅ Should open without errors
   - ✅ Should show dark theme by default
   
2. **Upload data**
   - ✅ Try a sample CSV from v2.2.0
   - ✅ Should work identically
   
3. **Run analysis**
   - ✅ Diversity Estimation
   - ✅ Ordination
   - ✅ Indices
   
4. **Try theme toggle**
   - ✅ Click sun icon → light theme
   - ✅ Click moon icon → dark theme
   - ✅ Restart app → theme persists
   
5. **Export results**
   - ✅ Download table (CSV)
   - ✅ Download plot (PNG, SVG, etc.)

---

## 🐛 Troubleshooting

### Issue: App won't start

**Symptoms**: Error on launch, blank window

**Fix**:
```bash
1. Completely uninstall v2.2.0
2. Delete app cache:
   - Windows: %APPDATA%\ordin
   - macOS: ~/Library/Application Support/ordin
   - Linux: ~/.config/ordin
3. Fresh install v2.3.0
```

---

### Issue: Theme doesn't persist

**Symptoms**: Always reverts to dark on restart

**Fix**:
```bash
1. Open DevTools (Ctrl+Shift+I or Cmd+Option+I)
2. Go to Application → Local Storage
3. Find 'ordin-theme' key
4. If missing, toggle theme once to create it
```

---

### Issue: Port conflict (8896 already in use)

**Symptoms**: "Address already in use" error

**Fix**:
```bash
Option 1: Kill existing process using port 8896
Option 2: Edit src/start-shiny.R:
  options(shiny.port = 8897)  # Use different port
```

---

### Issue: Old and new version conflict

**Symptoms**: Both v2.2.0 and v2.3.0 trying to start

**Fix**:
```bash
1. Uninstall v2.2.0 completely
2. Restart computer
3. Install only v2.3.0
```

---

## 📚 Documentation Updates

All documentation is updated for v2.3.0:

- ✅ **README.md** - Main documentation
- ✅ **CHANGELOG.md** - Version history
- ✅ **GETTING_STARTED.md** - Quick start guide
- ✅ **PROJECT_OVERVIEW.md** - Technical overview
- 🆕 **RELEASE-NOTES-v2.3.md** - Release notes
- 🆕 **UPDATE-SUMMARY-v2.3.md** - Quick summary
- 🆕 **VISUAL-GUIDE-THEME-TOGGLE.md** - Visual guide
- 🆕 **MIGRATION-GUIDE-v2.3.md** - This document

---

## ❓ FAQ

### Q: Will my v2.2.0 data work in v2.3.0?
**A**: Yes, 100% compatible.

### Q: Can I keep both versions installed?
**A**: Yes, they use different ports (8895 vs 8896).

### Q: Do I need to reconfigure anything?
**A**: No, everything works out of the box.

### Q: Will theme toggle affect analysis speed?
**A**: No, zero performance impact.

### Q: Can I customize the colors?
**A**: Yes, edit `shiny/app.R` `bs_theme()` section.

### Q: Is there a keyboard shortcut for theme toggle?
**A**: Not yet, but could be added in v2.4.0.

### Q: Does theme affect exported plots?
**A**: Not currently, but could be added.

### Q: Can I set light theme as default?
**A**: Yes, toggle once and it becomes your default.

---

## 🎯 Recommendations

### For Most Users

1. ✅ **Install v2.3.0** (clean install or overwrite)
2. ✅ **Try theme toggle** (experience both themes)
3. ✅ **Choose preference** (it saves automatically)
4. ✅ **Continue your work** (everything else unchanged)

### For Organizations

1. ✅ **Test on one machine first**
2. ✅ **Verify workflows still work**
3. ✅ **Roll out to all users**
4. ✅ **Optional: Provide theme toggle training**

### For Developers

1. ✅ **Review CHANGELOG.md** for technical details
2. ✅ **Check CSS architecture changes**
3. ✅ **Update custom extensions** (if any)
4. ✅ **Test theme compatibility** with customizations

---

## 📞 Support

Need help migrating?

- **GitHub Issues**: https://github.com/jm0535/0rdin/issues
- **Email**: jmoses@pnguot.ac.pg
- **Discussions**: https://github.com/jm0535/0rdin/discussions

---

## ✅ Migration Checklist

Print this checklist for smooth migration:

- [ ] Back up any custom CSV data
- [ ] Uninstall v2.2.0 (optional but recommended)
- [ ] Download v2.3.0 installer
- [ ] Install v2.3.0
- [ ] Launch Ördin
- [ ] Verify dark theme loads
- [ ] Upload a test CSV
- [ ] Run a test analysis
- [ ] Try theme toggle (☀️/🌙)
- [ ] Verify theme persists on restart
- [ ] Export a test result
- [ ] Update bookmarks/shortcuts (if needed)
- [ ] Notify team members (if organizational)
- [ ] Archive v2.2.0 installer (just in case)

---

**Migration Complete!** 🎉

Enjoy your new theme toggle feature in Ördin v2.3.0!

---

**Version**: 2.3.0  
**Author**: Jimmy Moses  
**Date**: October 23, 2025  
**License**: MIT
