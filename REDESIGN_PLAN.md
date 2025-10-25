# Ördin v3.0 - Enterprise UI/UX Redesign Plan

## Current Problems

### 1. **Navigation Chaos**
- Activity bar (VSCode-style sidebar) ✓ Good
- Top navbar with tabs ✗ Redundant
- Landing page cards ✗ Duplicate navigation
- Hidden settings overlay ✗ Not discoverable
- **Result:** 4 different navigation methods competing

### 2. **Endless Scrolling**
- Landing page has multiple full-screen sections
- Analysis pages scroll infinitely
- No clear workflow boundaries
- **Result:** Users get lost, don't know where they are

### 3. **Poor Module Integration**
- VSCode sidebar exists but doesn't control content
- Each module is a separate full page
- No persistent workspace context
- **Result:** Disconnected experience

### 4. **Duplicate IDs & Bootstrap Issues**
- Multiple input IDs used twice
- Bootstrap version mismatch warnings
- Shiny duplicate input warnings
- **Result:** Console errors, potential functionality issues

## Redesign Solution: Enterprise-Grade VSCode-Inspired Layout

### Core Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  Title Bar: Ördin v3.0  │ Dataset: [name] │ Status │ User  │
├──┬──────────────┬───────────────────────────────────┬────────┤
│  │              │                                   │        │
│  │  Primary     │                                   │ Right  │
│A │  Sidebar     │      Main Canvas                  │ Panel  │
│c │              │                                   │        │
│t │  Contextual  │      Workflow Area                │Context │
│i │  Navigation  │                                   │ Tools  │
│v │              │      Results & Viz                │        │
│i │  Data Tree   │                                   │ Props  │
│t │  Analysis    │                                   │        │
│y │  History     │                                   │        │
│  │              │                                   │        │
│B │              │                                   │        │
│a │              │                                   │        │
│r │              │                                   │        │
└──┴──────────────┴───────────────────────────────────┴────────┘
```

### Layout Specifications

#### 1. **Title Bar** (Fixed, 40px height)
- App title & version
- Current dataset indicator
- Global status (connected, data loaded, processing)
- User profile & quick actions

#### 2. **Activity Bar** (Fixed left, 48px width)
- **Home** - Dashboard & quick start
- **Data** - Import, manage, validate
- **Diversity** - iNEXT analysis
- **Ordination** - Multivariate analysis  
- **Results** - History & exports
- **Settings** - All app settings
- **Help** - Documentation

#### 3. **Primary Sidebar** (250px, collapsible)
**Context-Aware Content based on Activity Bar selection:**

- **Home View**: Quick actions, recent files, tutorials
- **Data View**: File browser, dataset tree, metadata
- **Diversity View**: Analysis parameters, plot options
- **Ordination View**: Method selector, environmental vars
- **Results View**: Export history, saved analyses
- **Settings View**: Categorized settings tree
- **Help View**: Table of contents, search

#### 4. **Main Canvas** (Flexible width)
**Single-page application - NO scrolling pages**

- **Breadcrumb navigation** at top
- **Tabbed workspace** for multiple analyses
- **Split view** option for compare
- **Embedded plots** with interactive controls
- **Data tables** with inline editing
- **Status bar** at bottom

#### 5. **Right Panel** (300px, collapsible, contextual)
**Shows only when relevant:**

- **Data View**: Column inspector, data types, statistics
- **Analysis Views**: Plot customization, export options
- **Settings**: Live preview of changes

### Workflow Integration

#### Unified Data Workflow:
```
1. Data Import (Activity: Data)
   ↓ Primary Sidebar: File browser
   ↓ Main Canvas: Preview table + validation
   ↓ Right Panel: Column types, stats

2. Analysis Setup (Activity: Diversity/Ordination)
   ↓ Primary Sidebar: Parameters form
   ↓ Main Canvas: Live preview
   ↓ Right Panel: Plot customization

3. Results (Activity: Results)
   ↓ Primary Sidebar: Analysis history
   ↓ Main Canvas: Full visualization
   ↓ Right Panel: Export options
```

### Technical Implementation

#### Remove:
- ❌ Top navbar with tabs
- ❌ Landing page cards
- ❌ Settings overlay sidebar
- ❌ Multiple navigation systems
- ❌ Page-based architecture

#### Add:
- ✅ Title bar component
- ✅ Integrated breadcrumb system
- ✅ Tabbed workspace manager
- ✅ Right panel system
- ✅ Unified state management
- ✅ Single-page routing via activity bar

#### Refactor:
- 🔄 Activity bar controls all views
- 🔄 Primary sidebar content switches based on activity
- 🔄 Main canvas uses tabs, not pages
- 🔄 All settings in Settings activity (not overlay)
- 🔄 Consistent 3-column layout always visible

### Color System (VSCode Dark Theme)
```css
--titlebar-bg: #2d2d30
--activitybar-bg: #333333
--sidebar-bg: #252526
--canvas-bg: #1e1e1e
--panel-bg: #252526
--border: #3e3e42
--accent: #2e8b57 (Ördin green)
--text-primary: #cccccc
--text-secondary: #888888
```

### Key Improvements

1. **No Endless Scrolling**: Fixed height sections, scroll only where needed
2. **Clear Context**: Title bar + breadcrumbs always show location
3. **Discoverable**: All features visible in activity bar + sidebar
4. **Consistent**: Same 3-column layout for all activities
5. **Efficient**: Quick access to everything, no modal hell
6. **Professional**: True VSCode-like experience

### Migration Plan

#### Phase 1: Structure (Critical)
- Implement title bar
- Remove navbar
- Remove landing page cards
- Integrate settings into activity view
- Fix duplicate IDs

#### Phase 2: Integration (High Priority)
- Make activity bar functional
- Implement sidebar content switching
- Convert pages to tab system
- Add right panel

#### Phase 3: Polish (Medium Priority)
- Add breadcrumb navigation
- Implement workspace tabs
- Add keyboard shortcuts
- Smooth transitions

#### Phase 4: Enhancement (Low Priority)
- Command palette (Ctrl+P)
- Split view mode
- Customizable panels
- Themes

## Implementation Notes

### Bootstrap Compatibility
- Use Bootstrap 5 exclusively
- Remove all Bootstrap 3 dependencies
- Fix card() vs tags$div() inconsistencies
- Consolidate all CSS in styles.css

### Shiny Architecture
- Use modules for each activity view
- Shared reactive values for data state
- Single ui object, no page-based nav
- Event-driven sidebar content switching

### Performance
- Lazy load analysis modules
- Cache plot renders
- Debounce reactive inputs
- Optimize large dataset handling

## Success Metrics

✅ Zero console warnings/errors
✅ No endless scrolling
✅ Single navigation paradigm
✅ All features discoverable within 2 clicks
✅ Consistent layout across all views
✅ < 3 second load time
✅ Smooth 60fps interactions
