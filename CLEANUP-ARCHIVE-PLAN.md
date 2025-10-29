# Ördin Project Cleanup Plan

**Author:** Jimmy Moses (jimmy.moses@pnguot.ac.pg)  
**Date:** December 2025  
**Purpose:** Remove obsolete development documentation and consolidate current docs

---

## 📋 Files to Archive/Delete

### ✅ **KEEP - Essential Documentation**
- `README.md` - Main project documentation
- `CHANGELOG.md` - Version history
- `LICENSE` - MIT license
- `CODE_OF_CONDUCT.md` - Community guidelines
- `CONTRIBUTING.md` - Contribution guide
- `SECURITY.md` - Security policy
- `SECURITY-AUDIT.md` - Security audit report
- `SECURITY-CLEANUP-SUMMARY.md` - Security cleanup summary
- `PRODUCTION-BUILD-COMPLETE.md` - Production build documentation
- `GETTING_STARTED.md` - User quickstart guide
- `PROJECT_OVERVIEW.md` - Project overview

### ✅ **KEEP - Technical Guides (User-Facing)**
- `DATA-STRUCTURE-GUIDE.md` - Data format reference
- `DATA_MANAGEMENT_GUIDE.md` - Data handling guide
- `BIPLOT_GUIDE.md` - Biplot interpretation
- `CCA_RDA_GUIDE.md` - Constrained ordination guide
- `ENTERPRISE_ORDINATION_GUIDE.md` - Ordination methods
- `INCIDENCE-VS-ABUNDANCE.md` - Data types explained
- `ESTIMATES-AND-RAREFACTION-TYPES.md` - Rarefaction guide
- `EXPORT-FEATURES.md` - Export functionality
- `SETTINGS_GUIDE.md` - Settings reference

### ✅ **KEEP - Setup Guides**
- `SETUP-LINUX.md` - Linux installation
- `SETUP-WSL.md` - WSL setup
- `FEDORA-QUICKSTART.md` - Fedora-specific
- `DEVELOPER-GUIDE-REPRODUCIBILITY.md` - Developer setup
- `PUBLISH.md` - Publishing guide
- `QUICK-PUBLISH.md` - Quick publish reference

### 🗑️ **DELETE - Old Development Status Files** (37 files)

#### Phase/Progress Tracking (Obsolete)
1. `COMPLETION_IN_PROGRESS.md` - Old status tracker
2. `PHASE2-COMPLETION-SUMMARY.md` - Phase 2 complete
3. `PHASE2-IMPLEMENTATION.md` - Phase 2 docs
4. `PHASE2-PROGRESS-DAY4.md` - Daily progress log
5. `POC-COMPLETION-REPORT.md` - POC complete
6. `POC-NMDS-WORKFLOW.md` - POC workflow
7. `SESSION_COMPLETION_REPORT.md` - Old session report
8. `TASKS-COMPLETED.md` - Old task list
9. `IMPLEMENTATION-STATUS.md` - Old implementation status

#### Package Installation Docs (Obsolete)
10. `CORE-PACKAGES-SUMMARY.md` - Package install summary
11. `CORE-PACKAGES-UPDATE-v3.0.md` - Package update docs
12. `PACKAGE-RESEARCH-RECOMMENDATIONS.md` - Research notes
13. `PACKAGES-FINAL-SUMMARY.md` - Final package summary
14. `PACKAGES-INSTALLATION-COMPLETE.md` - Installation complete
15. `PACKAGES-QUICK-REFERENCE.md` - Quick reference
16. `PACKAGES-UPDATE-BATCH-2.md` - Batch 2 updates
17. `TIER1-PACKAGES-COMPLETE.md` - Tier 1 complete

#### Module Completion Docs (Obsolete)
18. `DIVERSITY-MODULES-COMPLETE.md` - Diversity modules done
19. `MODULES-COMPLETE.md` - All modules done
20. `INTEGRATION-COMPLETE.md` - Integration complete
21. `INSTALLATION-COMPLETE.md` - Installation complete
22. `MIGRATION-COMPLETE.md` - Migration complete

#### Feature Implementation Docs (Obsolete)
23. `DIVERSITY_TAB_RESTRUCTURE.md` - Old restructure plan
24. `DUAL-DATA-LOADING-UPDATE.md` - Dual loading update
25. `ENTERPRISE-UPGRADE-v3.0.md` - Enterprise upgrade notes
26. `FAVICON-AND-NAVBAR-UPDATE-v2.3.md` - Favicon update
27. `IMPLEMENT-PROTOTYPE-SIDEBARS.md` - Sidebar implementation
28. `IN-APP-TEXT-UPDATES-v2.3.md` - Text updates
29. `LOADING_SPINNERS.md` - Spinner implementation
30. `NMDS-PDF-REPORT-COMPLETE.md` - PDF report complete
31. `NMDS-REPORT-REPRODUCIBILITY.md` - Report reproducibility
32. `NMDS-REPORT-VISUAL-GUIDE.md` - Visual guide
33. `PDF-EXPORT-COMPLETE.md` - PDF export complete
34. `PDF-EXPORT-FIX.md` - PDF export fix
35. `SETTINGS-MENU-IMPLEMENTATION.md` - Settings menu impl
36. `SIDEBAR-IMPLEMENTATION-PLAN.md` - Sidebar plan
37. `TASKBAR-ICON-SETUP-v2.3.md` - Taskbar icon setup
38. `VISUAL-GUIDE-THEME-TOGGLE.md` - Theme toggle guide

#### Version-Specific Docs (Obsolete)
39. `MIGRATION-GUIDE-v2.3.md` - v2.3 migration
40. `RELEASE-NOTES-v2.0.md` - v2.0 release notes
41. `RELEASE-NOTES-v2.3.md` - v2.3 release notes
42. `TEST-v2.2-SUMMARY.md` - v2.2 test summary
43. `UPDATE-SUMMARY-v2.3.md` - v2.3 update summary
44. `V3-CHANGES-SUMMARY.md` - v3 changes
45. `V3-IMPLEMENTATION-PLAN.md` - v3 implementation plan
46. `V3.0-IMPLEMENTATION-COMPLETE.md` - v3 implementation complete
47. `V3.0-STATUS-AND-NEXT-STEPS.md` - v3 status
48. `ORDIN-V3-COMPLETE-READY.md` - v3 complete
49. `ORDIN-V3-PRODUCTION-READY.md` - v3 production ready

#### Planning Docs (Obsolete)
50. `DOCUMENTATION-UPDATE-SUMMARY.md` - Doc update summary
51. `DOCUMENTATION_UPDATES.md` - Documentation updates
52. `LINUX-SUPPORT-SUMMARY.md` - Linux support summary
53. `POSITIONING-UPDATE-COMMUNITY-ECOLOGY.md` - Positioning update
54. `PROTOTYPE-GAP-ANALYSIS.md` - Gap analysis
55. `PROTOTYPE-MATCHING-COMPLETE.md` - Prototype matching done
56. `PROTOTYPE-TO-PRODUCTION-PLAN.md` - Production plan
57. `PUSH-TO-GITHUB.md` - GitHub push notes
58. `QUICK-TEST-GUIDE.md` - Quick test guide
59. `RAPID-BUILD-PLAN.md` - Rapid build plan
60. `REDESIGN_PLAN.md` - Redesign plan
61. `REPRODUCIBILITY-FRAMEWORK-SUMMARY.md` - Framework summary
62. `REPRODUCIBILITY-QUICK-REFERENCE.md` - Quick reference

### 🗑️ **DELETE - Utility Scripts** (11 files)

1. `add-cran-binary-pkgs.R` - CRAN install helper
2. `check-ciliates.R` - Ciliates data check
3. `check-packages.R` - Package checker
4. `create_sample_data.R` - Sample data creator
5. `diagnose-ciliates.R` - Ciliates diagnostics
6. `download_pandoc.R` - Pandoc downloader
7. `extract-ant-data.R` - Ant data extractor
8. `extract-inext-data.R` - iNEXT data extractor
9. `filter-ciliates-data.R` - Ciliates filter
10. `install_pandoc.R` - Pandoc installer
11. `install_pandoc_verbose.R` - Verbose pandoc installer
12. `install_tinytex.R` - TinyTeX installer
13. `RUN_TEST_APP.R` - Test runner
14. `SAMPLE_DATA_README.md` - Sample data notes
15. `setup-pdf-export.R` - PDF export setup
16. `update_diversity_theme.py` - Theme updater
17. `update_sidebars.py` - Sidebar updater
18. `verify-pdf-export.R` - PDF verification
19. `$null` - Empty file (Windows artifact)

---

## 📊 Cleanup Summary

### Before Cleanup
- **Total MD files:** 94
- **Utility scripts:** 19
- **Total size:** ~500 KB

### After Cleanup
- **Essential docs:** 21 files
- **Removed:** 73+ obsolete files
- **Space saved:** ~400 KB

### Remaining Structure
```
ordin/
├── README.md
├── CHANGELOG.md
├── LICENSE
├── SECURITY.md
├── SECURITY-AUDIT.md
├── SECURITY-CLEANUP-SUMMARY.md
├── PRODUCTION-BUILD-COMPLETE.md
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── GETTING_STARTED.md
├── PROJECT_OVERVIEW.md
├── PUBLISH.md
├── QUICK-PUBLISH.md
│
├── [Setup Guides]
├── SETUP-LINUX.md
├── SETUP-WSL.md
├── FEDORA-QUICKSTART.md
├── DEVELOPER-GUIDE-REPRODUCIBILITY.md
│
├── [User Guides]
├── DATA-STRUCTURE-GUIDE.md
├── DATA_MANAGEMENT_GUIDE.md
├── BIPLOT_GUIDE.md
├── CCA_RDA_GUIDE.md
├── ENTERPRISE_ORDINATION_GUIDE.md
├── INCIDENCE-VS-ABUNDANCE.md
├── ESTIMATES-AND-RAREFACTION-TYPES.md
├── EXPORT-FEATURES.md
└── SETTINGS_GUIDE.md
```

---

## ✅ Action Items

1. **Create archive directory** (optional)
   ```bash
   mkdir archive
   ```

2. **Move obsolete files to archive** (or delete directly)
   - All *-COMPLETE.md files
   - All *-SUMMARY.md files  
   - All *-UPDATE-*.md files
   - All PHASE*.md files
   - All POC*.md files
   - All v2.* specific files

3. **Delete utility scripts** (already have installed packages)

4. **Update README.md** if needed to reflect current state

---

## 🔒 Safety Checks

Before deletion, verify:
- [ ] No references in active code
- [ ] No links from README.md
- [ ] No build dependencies
- [ ] Git history preserved (files remain in git history)

---

**Ready to execute cleanup!**
