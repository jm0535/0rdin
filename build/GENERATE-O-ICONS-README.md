# Generate Ö Icons for Ördin

This directory contains tools to generate the Ö icon for Ördin's taskbar/dock display.

---

## 🎯 Quick Start (Browser Method - EASIEST)

1. **Open `generate-o-icon.html` in your browser**
2. **Click "Download 256×256"** button (saves as `icon.png`)
3. **Click "Download 512×512"** button (saves as `icon-512.png`)
4. **Replace the existing icon files** in this `build/` directory
5. **Rebuild the app**: `npm run make`
6. **Done!** The Ö icon will now appear in the taskbar/dock

---

## 📦 Alternative Methods

### Method 1: Python Script (if Python + Pillow installed)

```bash
cd build
python generate-icons.py
```

**Requirements**:
- Python 3.x
- Pillow: `pip install pillow`

### Method 2: Node.js Script (if Canvas installed)

```bash
cd build
node generate-icons.js
```

**Requirements**:
- Node.js
- Canvas: `npm install canvas` (may require native build tools)

---

## 🎨 Icon Specifications

### Generated Icons

| Size | Filename | Purpose |
|------|----------|---------|
| 16×16 | `icon-16.png` | Small icons, status bar |
| 32×32 | `icon-32.png` | Standard icons |
| 48×48 | `icon-48.png` | Medium icons |
| 64×64 | `icon-64.png` | Large icons |
| 128×128 | `icon-128.png` | High-DPI small |
| **256×256** | **`icon.png`** | **Main icon (REQUIRED)** |
| 512×512 | `icon-512.png` | macOS dock, high-DPI |
| 1024×1024 | `icon-1024.png` | macOS Retina displays |

### Design

- **Symbol**: Ö (with umlaut)
- **Color**: #007acc (VS Code blue)
- **Background**: #2d2d30 (VS Code navbar gray)
- **Font**: Arial Bold, centered
- **Format**: PNG with transparency support

---

## 🖥️ Where the Icon Appears

After rebuilding the app with new icons:

### Windows
- ✅ Taskbar
- ✅ Alt+Tab switcher
- ✅ Window title bar (some systems)
- ✅ Start menu shortcuts
- ✅ Desktop shortcuts

### macOS
- ✅ Dock
- ✅ Application switcher (Cmd+Tab)
- ✅ Application folder
- ✅ Launchpad

### Linux
- ✅ Taskbar/panel
- ✅ Application menu
- ✅ Window list
- ✅ Desktop shortcuts

---

## 🔧 Rebuild Process

After generating new icons:

### 1. Verify Icons

Check that these files exist in `build/`:
- `icon.png` (256×256 - REQUIRED)
- `icon-512.png` (512×512 - recommended)

### 2. Rebuild Application

```bash
# From project root
npm run make
```

### 3. Test

The rebuilt app in `out/` directory will have the new Ö icon.

**Windows**: `out/make/squirrel.windows/x64/`  
**macOS**: `out/make/zip/darwin/x64/`  
**Linux**: `out/make/deb/x64/` or `out/make/rpm/x64/`

---

## 🎨 Customization

### Change Icon Color

Edit the generator scripts/HTML and modify:
- `fillStyle = '#007acc'` ← Change this hex color

### Change Background

Edit the generator scripts/HTML and modify:
- `fillStyle = '#2d2d30'` ← Change this hex color

### Use Different Symbol

Edit the generator scripts/HTML and modify:
- `fillText('Ö', ...)` ← Change the character

---

## ❓ Troubleshooting

### Icon not showing after rebuild

1. **Clear build cache**:
   ```bash
   rm -rf out/
   npm run make
   ```

2. **Verify icon.png exists** and is 256×256

3. **Check file size** - should be ~5-60 KB

4. **Try icon-512.png** instead for high-DPI displays

### Icon shows but looks blurry

- Use `icon-512.png` (512×512) instead
- Ensure PNG is high quality, not compressed
- On macOS, use `icon-1024.png` for Retina displays

### Generator doesn't work

- **Browser method always works** - use `generate-o-icon.html`
- Download icons manually from the preview
- Save as `icon.png` and `icon-512.png`

---

## 📚 Technical Details

### Electron Icon Configuration

The icon is set in `src/index.js`:

```javascript
mainWindow = new BrowserWindow({
  icon: path.join(__dirname, '..', 'build', 'icon.png'),
  // ... other options
});
```

### Windows `.ico` Files

For Windows installers, you may also need:
- `icon.ico` (multi-size .ico file)
- Contains 16×16, 32×32, 48×48, 256×256 in one file

Use online converters to create `.ico` from PNG:
- https://convertio.co/png-ico/
- https://icoconvert.com/

### macOS `.icns` Files

For macOS app bundles, you may need:
- `icon.icns` (Apple icon format)

Use tools like `iconutil` (macOS) or online converters:
```bash
# On macOS
iconutil -c icns icon.iconset
```

---

## ✅ Quick Checklist

- [ ] Open `generate-o-icon.html` in browser
- [ ] Download `icon.png` (256×256)
- [ ] Download `icon-512.png` (512×512)
- [ ] Replace files in `build/` directory
- [ ] Run `npm run make` from project root
- [ ] Test app in `out/` directory
- [ ] Verify Ö icon appears in taskbar/dock

---

## 🎯 Why This Matters

**Before**: Generic Electron icon (⚛️)  
**After**: Distinctive Ö branding

**Benefits**:
- ✅ Professional appearance
- ✅ Easy to identify in taskbar
- ✅ Consistent branding
- ✅ Matches app design

---

**Need Help?**

If generators don't work:
1. Use `generate-o-icon.html` in browser (always works!)
2. Download icons manually
3. Replace `icon.png` and `icon-512.png`
4. Rebuild app

**That's it!** 🎉
