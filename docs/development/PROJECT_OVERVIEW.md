# Ördin Project Overview

> **Current release: Ördin 4.0.0** — React + Vite front end, Tauri desktop shell,
> DuckDB-WASM data engine and R via webR.
> See [`../ARCHITECTURE.md`](../ARCHITECTURE.md) for the authoritative v4 description
> and [`../DEVELOPMENT.md`](../DEVELOPMENT.md) for the workflow.
> The sections after "Legacy v3 architecture" describe the Shiny/Electron app in
> `shiny/` and `src/`, which is retained for maintenance only.

## Project Mission

Ördin is an open-source community ecology analysis platform that pairs the
analytical authority of R (`vegan`, `iNEXT`, `betapart`, `adespatial`) with a
modern, keyboard-driven interface — and removes the installation barrier by
running R in WebAssembly.

## v4 structure at a glance

```
0rdin/
├── apps/ordin-desktop     # Vite + React application (also the Tauri front end)
├── packages/core          # OrdinProject schema + Zustand store
├── packages/processing    # webR bridge + JS statistics
├── packages/ui            # shared UI primitives
├── packages/map           # optional MapLibre helper
├── docs/                  # documentation + GitHub Pages site
├── sample-data/           # example datasets
├── scripts/ tools/ ci/    # build helpers, linters, R CI bootstrap
├── shiny/ src/            # legacy v3 application (maintenance only)
└── vercel.json            # COOP/COEP headers required by webR/DuckDB-WASM
```

### v4 components

| Component | Role |
| --- | --- |
| `apps/ordin-desktop/src/App.tsx` | Shell: activity bar, sidebar, inspector, status bar, panel routing, hotkeys |
| `components/panels/*` | Dashboard, Data, Diversity, Ordination, Tests, Beta, Classification, Traits, Settings, Help |
| `@ordin/core` | `OrdinProject` schema (zod), Zustand store, validation |
| `@ordin/processing` | `getWebR()` plus `run*ViaWebR()` analyses and JS fast paths |
| `@ordin/ui` / `@ordin/map` | Presentational primitives / MapLibre helper |
| Tauri shell | Desktop packaging, bundles webR offline |

### Technology stack (v4)

Tauri 2 · React 18 · TypeScript 5.8 · Vite 6 · Tailwind CSS 3 · Zustand 5 + Immer ·
zod · DuckDB-WASM 1.33 · Apache Arrow 21 · webR 0.4 · deck.gl 9 · MapLibre GL 6 ·
Comlink · Node.js ≥ 22.

---

# Legacy v3 architecture

> Everything below documents Ördin 3.0 (R Shiny inside Electron). It is accurate
> for the `shiny/` and `src/` trees only.

## Project Structure

```
ordin/
├── 📄 Core Configuration
│   ├── package.json                 # Node.js/Electron configuration
│   ├── .gitignore                   # Git ignore rules
│   ├── LICENSE                      # MIT License
│   └── CHANGELOG.md                 # Version history
│
├── 📖 Documentation
│   ├── README.md                    # Main documentation
│   ├── GETTING_STARTED.md           # Quick start for new users
│   ├── docs/
│   │   ├── QUICKSTART.md           # Detailed setup guide
│   │   └── DEVELOPMENT.md          # Developer guide
│   └── sample-data/
│       ├── README.md               # Data format guide
│       └── example-biodiversity.csv # Sample dataset
│
├── 🔧 Build & Setup Scripts
│   ├── setup.bat                    # Windows setup script
│   ├── setup.sh                     # macOS/Linux setup script
│   ├── get-r-win.sh                # Windows portable R installer
│   ├── get-r-mac.sh                # macOS portable R installer
│   └── install-v3-packages.R       # R package installer
│
├── 💻 Application Code
│   ├── src/
│   │   ├── index.js                # Electron main process
│   │   └── start-shiny.R           # R Shiny server starter
│   └── shiny/
│       └── app.R                   # Main Shiny application
│
├── 🎨 Assets
│   └── build/
│       ├── README.md               # Icon creation guide
│       └── icon-placeholder.txt    # Icon placeholder
│
└── 🚫 Generated (not in repo)
    ├── node_modules/               # Node.js dependencies
    ├── r-win/                      # Portable R for Windows
    ├── r-mac/                      # Portable R for macOS
    └── out/                        # Build outputs

```

## Component Overview

### 1. Electron Layer (Desktop Framework)
- **Entry Point**: `src/index.js`
- **Purpose**: Creates desktop window, manages R process, handles app lifecycle
- **Key Features**:
  - Spawns R Shiny server on port 9054
  - Waits for Shiny to be ready before showing window
  - Cleans up R process on exit
  - Cross-platform R path detection

### 2. R Shiny Layer (Application Logic)
- **Entry Point**: `shiny/app.R`
- **Purpose**: Provides community ecology analysis interface and computations
- **Key Features**:
  - VS Code-inspired flat design with dark/light theme toggle
  - Theme persistence via localStorage
  - Bootstrap 5 custom theme (bslib)
  - iNEXT diversity estimation and rarefaction
  - vegan ordination (NMDS, PCA, CA, DCA, CCA, RDA, PCoA)
  - vegan diversity indices (Shannon, Simpson, evenness, etc.)
  - Advanced visualization (confidence ellipses, species scores, env vectors)
  - Interactive plots (ggplot2) with 5 plot themes
  - Data tables (DT) with export capabilities
  - CSV upload/download with validation
  - Multi-format plot export (PNG, TIFF, SVG, etc.)
  - Dynamic theme switching without re-running analyses

### 3. Portable R Setup
- **Windows**: `get-r-win.sh` (requires Cygwin)
- **macOS**: `get-r-mac.sh`
- **Packages**: `install-v3-packages.R`
- **Purpose**: Creates self-contained R installation
- **Benefits**:
  - No system R installation needed
  - Consistent environment across machines
  - Easy distribution to end users

### 4. Build System
- **Framework**: Electron Forge
- **Makers**: Squirrel (Windows), ZIP (macOS)
- **Output**: Standalone executables
- **Configuration**: `package.json` under `config.forge`

## Technology Stack

### Frontend
| Technology | Version | Purpose |
|------------|---------|---------|
| R Shiny | Latest | Web application framework |
| bslib | Latest | Bootstrap 5 theming |
| Bootstrap | 5.x | UI components |
| Custom CSS | - | VS Code flat design + dual themes |
| Vanilla JS | - | Theme toggle & localStorage |
| DT | Latest | Interactive tables |

### Backend
| Technology | Version | Purpose |
|------------|---------|---------|
| R | 4.4.1+ | Statistical computing |
| vegan | 2.6+ | Community ecology (ordination) |
| iNEXT | 3.0+ | Diversity estimation |
| ggplot2 | Latest | Data visualization |
| readr | Latest | CSV file handling |

### Desktop
| Technology | Version | Purpose |
|------------|---------|---------|
| Electron | 28.0.0 | Desktop application framework |
| Node.js | 18.x/20.x | JavaScript runtime |
| Electron Forge | 7.2.0 | Build and packaging |

## Key Files

### `package.json`
- Defines app metadata (name, version, author)
- Lists dependencies (Electron, axios)
- Configures build makers (Squirrel, ZIP)
- Contains npm scripts (start, make, package)

### `src/index.js`
- Main Electron process
- Key functions:
  - `getRPath()`: Finds portable R executable
  - `startShiny()`: Spawns R Shiny server
  - `checkShinyReady()`: Polls Shiny server
  - `createWindow()`: Creates main app window

### `src/start-shiny.R`
- R script executed by Electron
- Sets working directory to `shiny/`
- Configures Shiny port (9054) and host (127.0.0.1)
- Launches `shiny/app.R`

### `shiny/app.R`
- Complete Shiny application
- UI structure:
  - Sidebar: File upload, analysis selector, options
  - Main: Results display (table + plot)
- Server logic:
  - `data()`: Reactive CSV loading
  - `results()`: Stores analysis outputs
  - `observeEvent(runAnalysis)`: Performs iNEXT or ordination
  - Download handlers for CSV, Excel, JSON, and plots

## Data Flow

```
User uploads CSV
    ↓
shiny/app.R reads file (readr::read_csv)
    ↓
User selects analysis type and configures parameters
    ↓
User clicks "Run Analysis"
    ↓
    ├── Diversity Estimation path:
    │   ├── iNEXT::iNEXT() → diversity calculations
    │   ├── iNEXT::ggiNEXT() → rarefaction plot
    │   └── Store in diversityResults()
    │
    ├── Diversity Indices path:
    │   ├── vegan::diversity() → diversity metrics
    │   ├── vegan::specaccum() → accumulation curves
    │   └── Store in indicesResults()
    │
    └── Ordination path:
        ├── vegan::vegdist() → dissimilarity matrix
        ├── vegan::metaMDS()/rda()/cca()/decorana() → ordination
        ├── Advanced visualization (ellipses, species scores, env vectors)
        ├── ggplot2 with theme system
        └── Store in ordinationResults()
    ↓
Display summary table (DT::datatable)
Display plot (renderPlot) with theme
    ↓
User downloads results
    ├── Data: CSV, Excel, JSON
    └── Plots: PNG, TIFF, SVG (theme-consistent)
```

## Build Process

```
npm run make
    ↓
Electron Forge starts
    ↓
Package app (asar archive)
    ├── Include: src/, shiny/, r-win/, r-mac/
    ├── Exclude: node_modules devDeps
    └── Set metadata (name, version, icon)
    ↓
Run makers
    ├── Windows: Squirrel → .exe installer
    └── macOS: ZIP → .zip with .app
    ↓
Output to out/make/
```

## Development Workflow

```
1. npm install
   └── Install Node.js dependencies

2. ./get-r-win.sh or ./get-r-mac.sh
   └── Download and extract portable R

3. Rscript install-v3-packages.R
   └── Install R packages into portable R

4. npm start
   ├── Electron starts
   ├── Spawn R process (src/start-shiny.R)
   ├── Wait for Shiny on http://127.0.0.1:9054
   └── Open BrowserWindow

5. Develop and test
   ├── Edit shiny/app.R → Refresh browser
   ├── Edit src/index.js → Restart npm start
   └── Use DevTools (Ctrl+Shift+I)

6. npm run make
   └── Build distributable app
```

## Distribution Model

### For End Users (No R Required)

**Windows:**
1. Download `Ördin-4.0.0 Setup.exe`
2. Run installer
3. Launch from Start Menu or Desktop

**macOS:**
1. Download `Ordin-darwin-x64-4.0.0.zip`
2. Unzip to get `Ördin.app`
3. Drag to Applications folder
4. Launch like any Mac app

### For Developers

1. Clone repository
2. Run `setup.bat` or `setup.sh`
3. Follow prompts to set up R
4. Use `npm start` for development
5. Use `npm run make` to build

## Design Principles

### 1. Self-Contained
- Portable R bundled with app
- No external dependencies
- Works offline after installation

### 2. User-Friendly
- No command-line needed
- Modern, familiar interface (Bootstrap)
- Clear error messages
- Sample data included

### 3. Cross-Platform
- Same codebase for Windows/macOS
- Platform-specific R installers
- Consistent UI across platforms

### 4. Extensible
- Modular R code (easy to add analyses)
- Themeable UI (bslib)
- Well-documented for contributors

### 5. Professional
- Enterprise-grade UX design
- Publication-quality outputs
- Comprehensive documentation
- Advanced visualization features

## Performance Characteristics

### Startup Time
- First launch: ~5-10 seconds (R loading)
- Subsequent launches: ~3-5 seconds

### Analysis Speed
- **Diversity Estimation**: 1-30 seconds (depends on dataset size)
  - Small (10 sites): < 5 seconds
  - Medium (50 sites): 10-15 seconds
  - Large (100+ sites): 20-30 seconds

- **Ordination Analysis**: 5-60 seconds (depends on method, sites, species, dimensions)
  - NMDS 2D with 20 sites: ~5 seconds
  - PCA 3D with 50 sites: ~15 seconds
  - CCA with 100 sites: ~30 seconds

- **Diversity Indices**: 2-10 seconds (depends on indices selected)
  - Basic indices: ~2 seconds
  - Full suite with accumulation: ~10 seconds

### Memory Usage
- Base app: ~200 MB
- With analysis: 300-500 MB (depends on dataset)

## Security Considerations

### Current State
- Local-only (no network access)
- File system access limited to user-selected files
- No external API calls
- No data collection or telemetry

### Future Enhancements
- Code signing for installers
- Notarization for macOS
- Integrity checks for R packages

## Future Roadmap

### Short Term (v3.1-v3.2)
- Additional ordination visualization features
- Enhanced data management capabilities
- More diversity indices and metrics
- Improved export options

### Medium Term (v4.0)
- Batch processing for multiple datasets
- Advanced statistical modeling
- Interactive plot manipulation
- Custom analysis workflows

### Long Term (v5.0+)
- Machine learning integration
- Cloud synchronization
- Collaborative features
- Mobile companion app

## Maintenance

### Updating R Version
1. Edit `get-r-win.sh` and `get-r-mac.sh`
2. Change `R_VERSION` variable
3. Test with new R version

### Updating Dependencies
```bash
# Node.js packages
npm update

# R packages (edit install-v3-packages.R to add/remove)
Rscript install-v3-packages.R
```

### Updating Electron
```bash
npm install electron@latest --save-dev
npm install @electron-forge/cli@latest --save-dev
```

## License & Attribution

- **License**: MIT (see LICENSE file)
- **Author**: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
- **Year**: 2025
- **Dependencies**: See package.json and R package list

---

**Project Version**: 4.0.0  
**Last Updated**: 2025-10-24  
**Status**: Production Ready ✅