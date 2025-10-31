# Development Guide for Ördin

This guide is for developers who want to modify, extend, or contribute to the Ördin project.

## Project Architecture

### Technology Stack

- **Frontend**: R Shiny with {bslib} (Bootstrap 5)
- **Backend**: R (vegan, iNEXT packages)
- **Desktop Framework**: Electron
- **Build System**: Electron Forge
- **Package Manager**: npm (Node.js)

### Directory Structure

```
ordin/
├── src/                    # Electron main process
│   ├── index.js           # Main Electron entry point
│   └── start-shiny.R      # R Shiny server startup
├── shiny/                 # Shiny application
│   ├── app.R             # Main Shiny app
│   └── www/              # Static web assets
├── build/                # Build assets (icons, etc.)
├── sample-data/          # Example datasets
├── docs/                 # Documentation
├── r-win/               # Portable R for Windows (generated)
├── r-mac/               # Portable R for macOS (generated)
├── out/                 # Build output (generated)
├── package.json         # Node.js configuration
├── get-r-win.sh        # Windows R setup script
├── get-r-mac.sh        # macOS R setup script
└── add-cran-binary-pkgs.R  # R package installer
```

## Development Workflow

### Setting Up Development Environment

1. **Clone and Install**
   ```bash
   git clone <repo-url>
   cd ordin
   npm install
   ```

2. **Set Up R**
   ```bash
   # Windows (in Cygwin)
   ./get-r-win.sh
   
   # macOS
   ./get-r-mac.sh
   ```

3. **Install R Packages**
   ```bash
   Rscript add-cran-binary-pkgs.R
   ```

### Running in Development Mode

```bash
npm start
```

This starts Electron with:
- Hot reload for Electron changes
- DevTools open by default
- Console logging enabled

**Pro Tip**: Keep DevTools open to see R console output and JavaScript errors.

### Making Changes

#### Modifying the Shiny UI

Edit `shiny/app.R`:

```r
# Change theme
ui <- page_sidebar(
  theme = bs_theme(
    version = 5, 
    bootswatch = "darkly",  # Try: flatly, cosmo, united, etc.
    primary = "#2e8b57"
  ),
  # ... rest of UI
)
```

Available bootswatch themes: darkly, flatly, cosmo, united, sandstone, etc.

#### Adding New Analysis Methods

1. Add new choice to `selectInput`:
   ```r
   selectInput("analysisType", "Select Analysis",
     choices = c(
       "Diversity Estimation (iNEXT)", 
       "Ordination (NMDS via vegan)",
       "Your New Method"  # Add here
     ))
   ```

2. Add handler in `observeEvent(input$runAnalysis)`:
   ```r
   } else if (input$analysisType == "Your New Method") {
     # Your analysis code
     # Must set results() with list(summary = df, plot = ggplot_obj)
   }
   ```

#### Modifying Electron Behavior

Edit `src/index.js`:

```javascript
// Change window size
function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1600,  // Wider window
    height: 1000,
    // ...
  });
}

// Change Shiny port
const SHINY_PORT = 9999;  // Different port
```

### Testing

#### Manual Testing Checklist

- [ ] Upload sample CSV
- [ ] Run iNEXT analysis
- [ ] Run NMDS analysis (2D and 3D)
- [ ] Download summary CSV
- [ ] Download plot PNG
- [ ] Test with invalid CSV (should show error)
- [ ] Test with empty CSV
- [ ] Restart app and verify clean startup

#### Automated Tests (Future Enhancement)

Consider adding:
- Unit tests for R functions (testthat package)
- Integration tests for Electron (Spectron)
- CI/CD pipeline (GitHub Actions)

## Building and Distribution

### Development Build

```bash
npm run package
```

Creates unpackaged app in `out/` for quick testing.

### Production Build

```bash
npm run make
```

Creates installers:
- Windows: `.exe` installer
- macOS: `.zip` with `.app` bundle

### Build Configuration

Edit `package.json` under `config.forge`:

```json
"packagerConfig": {
  "name": "Ördin",
  "icon": "./build/icon",  # Icon path (no extension)
  "asar": true             # Package app in archive
}
```

### Code Signing (Optional)

For production distribution:

**macOS:**
```json
"packagerConfig": {
  "osxSign": {
    "identity": "Developer ID Application: Your Name"
  },
  "osxNotarize": {
    "appleId": "your@email.com",
    "appleIdPassword": "@keychain:AC_PASSWORD"
  }
}
```

**Windows:**
```json
"packagerConfig": {
  "certificateFile": "./cert.pfx",
  "certificatePassword": "password"
}
```

## Customization Examples

### 1. Adding a Custom Logo

1. Place `logo.png` in `shiny/www/`
2. Update `shiny/app.R`:
   ```r
   ui <- page_sidebar(
     theme = bs_theme(...),
     title = tagList(
       img(src = "logo.png", height = "50px", style = "margin-right: 10px;"),
       "Ördin: Biodiversity Analysis"
     ),
     # ...
   )
   ```

### 2. Changing Color Scheme

Edit theme in `shiny/app.R`:

```r
bs_theme(
  version = 5, 
  bootswatch = "flatly",      # Light theme
  primary = "#3498db",        # Blue
  secondary = "#2ecc71",      # Green
  success = "#27ae60",
  info = "#3498db",
  warning = "#f39c12",
  danger = "#e74c3c",
  "font-scale" = 1.2          # Larger fonts
)
```

### 3. Adding New R Packages

1. Add to `add-cran-binary-pkgs.R`:
   ```r
   required_packages <- c(
     "shiny", "bslib", "vegan", "iNEXT",
     "ggplot2", "DT", "readr",
     "your_new_package"  # Add here
   )
   ```

2. Install:
   ```bash
   Rscript add-cran-binary-pkgs.R
   ```

3. Use in `shiny/app.R`:
   ```r
   library(your_new_package)
   ```

### 4. Custom Plot Styling

Modify plot generation in `shiny/app.R`:

```r
plot_obj <- ggplot(data, aes(x, y)) +
  geom_point(size = 5, color = "#2e8b57", alpha = 0.8) +
  theme_minimal(base_size = 16) +
  theme(
    plot.background = element_rect(fill = "#1a1a1a"),
    panel.background = element_rect(fill = "#2a2a2a"),
    text = element_text(color = "#ffffff"),
    axis.text = element_text(color = "#cccccc"),
    panel.grid = element_line(color = "#444444")
  ) +
  labs(title = "Custom Title", subtitle = "Custom Subtitle")
```

## Performance Optimization

### R Performance

1. **Use data.table for large datasets**:
   ```r
   library(data.table)
   dt <- fread(input$dataFile$datapath)
   ```

2. **Cache expensive computations**:
   ```r
   cached_result <- reactive({
     # Expensive computation
   }) %>% bindCache(input$dataFile, input$analysisType)
   ```

3. **Use parallel processing**:
   ```r
   library(parallel)
   cl <- makeCluster(detectCores() - 1)
   # Parallel computations
   stopCluster(cl)
   ```

### Electron Performance

1. **Lazy load modules**:
   ```javascript
   // Instead of require() at top
   const moduleIOnlyNeedSometimes = () => require('module');
   ```

2. **Reduce memory usage**:
   ```javascript
   mainWindow.webContents.on('dom-ready', () => {
     mainWindow.webContents.setZoomFactor(1);
     mainWindow.webContents.setVisualZoomLevelLimits(1, 1);
   });
   ```

## Debugging

### R Debugging

Add to `shiny/app.R`:

```r
# Enable console logging
options(shiny.trace = TRUE)
options(shiny.fullstacktrace = TRUE)

# Add breakpoints
browser()  # Execution stops here when running in R console

# Print debugging
observeEvent(input$runAnalysis, {
  cat("Starting analysis...\n")
  cat("Data dimensions:", dim(data()), "\n")
  # ...
})
```

### Electron Debugging

In `src/index.js`:

```javascript
// Always show DevTools
mainWindow.webContents.openDevTools();

// Log all R output
rShinyProcess.stdout.on('data', (data) => {
  console.log(`[R] ${data}`);
});

// Detailed error logging
mainWindow.webContents.on('crashed', () => {
  console.error('Window crashed!');
});
```

### Common Issues

**Issue**: Shiny server won't start
- Check: R path in `src/index.js` matches your setup
- Check: Port 8888 is not in use
- Solution: Run R directly: `Rscript src/start-shiny.R`

**Issue**: Packages not found
- Check: `.libPaths()` in R includes portable R library
- Solution: Run `Rscript add-cran-binary-pkgs.R` again

**Issue**: Electron window is blank
- Check: DevTools console for JavaScript errors
- Check: Shiny server is actually running (check terminal output)
- Solution: Increase timeout in `checkShinyReady()`

## Contributing

### Code Style

**R Code**:
- Use 2-space indentation
- Follow [tidyverse style guide](https://style.tidyverse.org/)
- Add comments for complex logic

**JavaScript**:
- Use 2-space indentation
- Use `const` over `let`, avoid `var`
- Use async/await over callbacks

### Commit Messages

Follow conventional commits:
```
feat: Add new diversity index
fix: Correct NMDS stress calculation
docs: Update installation guide
refactor: Simplify data loading logic
```

### Pull Request Process

1. Fork the repository
2. Create feature branch: `git checkout -b feature/my-feature`
3. Make changes and test thoroughly
4. Commit with clear messages
5. Push and create PR

## Deployment

### Distributing to Users

**Windows**:
1. Build: `npm run make`
2. Share `out/make/squirrel.windows/x64/Ördin-1.0.0 Setup.exe`
3. Users double-click to install

**macOS**:
1. Build: `npm run make`
2. Unzip `out/make/zip/darwin/x64/Ordin-darwin-x64-1.0.0.zip`
3. Share `Ördin.app`
4. Users drag to Applications folder

### Auto-Updates (Advanced)

Consider implementing Electron auto-updater:

1. Add to `package.json`:
   ```json
   "dependencies": {
     "electron-updater": "^6.0.0"
   }
   ```

2. Add to `src/index.js`:
   ```javascript
   const { autoUpdater } = require('electron-updater');
   
   app.on('ready', () => {
     autoUpdater.checkForUpdatesAndNotify();
   });
   ```

3. Set up update server (e.g., GitHub Releases)

## Resources

- [Electron Documentation](https://www.electronjs.org/docs)
- [Shiny Documentation](https://shiny.rstudio.com/)
- [vegan Package Guide](https://github.com/vegandevs/vegan)
- [iNEXT Package Guide](https://github.com/JohnsonHsieh/iNEXT)
- [Bootstrap 5 Themes](https://bootswatch.com/)
- [bslib Documentation](https://rstudio.github.io/bslib/)

## License

MIT License - See LICENSE file
