# `docs/` — Ördin documentation & landing page

This folder holds **both** the Ördin documentation set and the GitHub Pages
landing site.

- 📚 **Looking for documentation?** Start at the
  [Documentation Index](DOCS-INDEX.md), or jump to
  [Quick Start](QUICKSTART.md), [Architecture](ARCHITECTURE.md),
  [Development Guide](DEVELOPMENT.md) or the [API Reference](API.md).
- 🌐 **Working on the website?** The rest of this file covers the landing page
  (`index.html`, `styles.css`, `script.js`, `_config.yml`).

---

## GitHub Pages landing page

## 🌐 Live Site

Once published, the site will be available at:
**https://jm0535.github.io/0rdin/**

## 📁 Folder Structure

```
docs/
├── index.html           # Landing page
├── index.md             # Markdown landing content
├── styles.css           # CSS styling
├── script.js            # JavaScript functionality
├── _config.yml          # GitHub Pages configuration
├── DOCS-INDEX.md        # Documentation index (start here)
├── QUICKSTART.md · ARCHITECTURE.md · DEVELOPMENT.md · API.md · WORKFLOW.md …
├── guides/              # Analysis and data guides
├── setup/               # Setup and publishing guides
├── development/         # Developer-facing documents
├── assets/
│   ├── icon.png         # Ördin logo/icon
│   ├── ordin4.png
│   └── screenshots/     # Application screenshots (see its README)
└── README.md            # This file
```

## 🚀 Setup GitHub Pages

### Step 1: Enable GitHub Pages

1. Go to your repository: https://github.com/jm0535/0rdin
2. Click **Settings** → **Pages** (in left sidebar)
3. Under **Source**, select:
   - Branch: `main`
   - Folder: `/docs`
4. Click **Save**
5. Wait 1-2 minutes for deployment

### Step 2: Add Screenshots

The landing page requires 5 screenshots. See `assets/screenshots/README.md` for details:

1. **main-interface.png** (1200x800px) - Hero section
2. **ordination.png** (800x600px) - Ordination analysis
3. **diversity.png** (800x600px) - Diversity estimation
4. **customization.png** (800x600px) - Plot customization
5. **settings.png** (800x600px) - Settings system

**To capture screenshots:**
```bash
# Run Ördin 4
npm run dev        # then open http://localhost:9054

# Use your OS screenshot tool:
# Windows: Win + Shift + S
# macOS: Cmd + Shift + 4
# Linux: Spectacle, Flameshot, or gnome-screenshot
```

Save screenshots to `docs/assets/screenshots/` with exact filenames listed above.

### Step 3: Commit and Push

```bash
# From the repository root
cd 0rdin

# Add files
git add docs/

# Commit
git commit -m "Add GitHub Pages landing page"

# Push
git push origin main
```

### Step 4: Verify Deployment

1. Go to Settings → Pages
2. Check for green checkmark: ✅ "Your site is live at https://jm0535.github.io/0rdin/"
3. Click the link to view your site

## 🎨 Features

### Landing Page Includes:

- ✅ **Hero Section**: Large Ö logo, tagline, download buttons
- ✅ **Features Grid**: 6 key features with icons
- ✅ **Screenshots Gallery**: 4 app screenshots
- ✅ **Download Section**: Platform-specific download cards for:
  - Windows (.exe installer)
  - macOS (.zip universal binary)
  - Linux Debian/Ubuntu (.deb)
  - Linux Fedora/RHEL (.rpm)
- ✅ **Installation Guide**: Tab-based OS-specific instructions
- ✅ **Documentation Links**: Quick links to all guides
- ✅ **Footer**: Social links, citation, license

### Interactive Elements:

- 🎯 **OS Detection**: Automatically highlights recommended download
- 📑 **Tabs**: Switch between Windows/macOS/Linux install guides
- 🖱️ **Smooth Scroll**: Click nav links for smooth scrolling
- 📋 **Copy Code**: Click code blocks to copy commands
- 🎭 **Animations**: Fade-in effects on scroll
- 📱 **Responsive**: Mobile-friendly design

## 🛠️ Customization

### Update Download Links

Edit `index.html` and change download URLs:

```html
<!-- Example: Update Windows download link -->
<a href="https://github.com/jm0535/0rdin/releases/latest/download/Ordin-4.0.0-Setup.exe" 
   class="btn btn-download">
  <i class="fas fa-download"></i> Download .exe
</a>
```

### Change Colors

Edit `styles.css` root variables:

```css
:root {
    --primary-color: #2e8b57;      /* Change to your color */
    --secondary-color: #007acc;    /* Change to your color */
}
```

### Add Analytics

Uncomment in `_config.yml`:

```yaml
google_analytics: UA-XXXXXXXXX-X  # Add your tracking ID
```

## 🧪 Local Testing

Test the page locally before pushing:

### Option 1: Simple HTTP Server (Python)

```bash
cd docs
python -m http.server 8000
# Open http://localhost:8000 in browser
```

### Option 2: Simple HTTP Server (Node.js)

```bash
npm install -g http-server
cd docs
http-server
# Open http://localhost:8080 in browser
```

### Option 3: Open Directly

Just open `docs/index.html` in your browser (some features like fonts may not work).

## 📸 Screenshot Tips

### Recommended Settings:

- **Theme**: Use dark theme for consistency
- **Zoom**: Set to 100%
- **Window**: Maximize or use consistent size
- **Data**: Use colorful example datasets

### Suggested Screenshots:

1. **Main Interface**: Dashboard with sample data loaded
2. **Ordination**: NMDS plot with ellipses and species scores
3. **Diversity**: iNEXT curves with 3 diversity orders
4. **Customization**: Right panel showing all controls
5. **Settings**: Settings page showing Appearance section

### Tools:

- **Windows**: Snipping Tool, Greenshot, ShareX
- **macOS**: Screenshot app, Skitch
- **Linux**: Flameshot, Spectacle, GNOME Screenshot

## 🔧 Troubleshooting

### Page Not Loading

1. Check GitHub Pages is enabled (Settings → Pages)
2. Verify source is set to `main` branch, `/docs` folder
3. Wait 5 minutes for deployment
4. Clear browser cache

### Images Not Showing

1. Verify image paths in `index.html`
2. Check filenames match exactly (case-sensitive on Linux)
3. Ensure images are in `docs/assets/screenshots/`
4. Check file extensions (.png not .PNG)

### Styling Issues

1. Clear browser cache (Ctrl+Shift+R)
2. Check `styles.css` loaded (View Source)
3. Verify no syntax errors in CSS

### JavaScript Not Working

1. Open browser DevTools (F12)
2. Check Console for errors
3. Verify `script.js` loaded

## 📄 License

This landing page follows the same MIT license as the main Ördin project.

## 👤 Author

**Jimmy Moses**
- Email: jimmy.moses@pnguot.ac.pg
- GitHub: [@jm0535](https://github.com/jm0535)

## 🤝 Contributing

To improve the landing page:

1. Fork the repository
2. Make changes in `docs/` folder
3. Test locally
4. Submit pull request

---

**Need help?** Open an issue at https://github.com/jm0535/0rdin/issues
