# Ördin Icon Assets

This directory contains icon files for the Ördin desktop application.

## Required Icons

### Windows
- **icon.ico**: Windows application icon (256x256 recommended)
  - Used for the executable and taskbar
  - Should contain multiple sizes: 16x16, 32x32, 48x48, 256x256

### macOS
- **icon.icns**: macOS application icon
  - Should contain multiple sizes for different contexts
  - Typically includes: 16x16, 32x32, 128x128, 256x256, 512x512, 1024x1024

### General
- **icon.png**: Source PNG file (1024x1024 recommended)
  - Used as the base for creating platform-specific icons
  - High resolution for best quality

## Icon Design Suggestions

For the Ördin branding (inspired by Odin):
- **Mythological Elements**: Raven, spear, all-seeing eye
- **Nature/Ecology Themes**: Tree of life, interconnected nodes, biodiversity symbols
- **Color Palette**: 
  - Primary: Forest green (#2e8b57)
  - Accent: Gold/amber (#d4af37)
  - Background: Dark gray (#222222)

## Creating Icons

### Online Tools
- [CloudConvert](https://cloudconvert.com/) - PNG to ICO/ICNS conversion
- [iConvert Icons](https://iconverticons.com/) - Multi-platform icon generator
- [Favicon.io](https://favicon.io/) - Simple icon creation

### Command Line (macOS)
```bash
# Convert PNG to ICNS
mkdir icon.iconset
sips -z 16 16     icon.png --out icon.iconset/icon_16x16.png
sips -z 32 32     icon.png --out icon.iconset/icon_16x16@2x.png
sips -z 32 32     icon.png --out icon.iconset/icon_32x32.png
sips -z 64 64     icon.png --out icon.iconset/icon_32x32@2x.png
sips -z 128 128   icon.png --out icon.iconset/icon_128x128.png
sips -z 256 256   icon.png --out icon.iconset/icon_128x128@2x.png
sips -z 256 256   icon.png --out icon.iconset/icon_256x256.png
sips -z 512 512   icon.png --out icon.iconset/icon_256x256@2x.png
sips -z 512 512   icon.png --out icon.iconset/icon_512x512.png
sips -z 1024 1024 icon.png --out icon.iconset/icon_512x512@2x.png
iconutil -c icns icon.iconset
```

### Command Line (Windows)
Use ImageMagick:
```powershell
magick convert icon.png -define icon:auto-resize=256,128,96,64,48,32,16 icon.ico
```

## Placeholder Icon

A temporary placeholder icon (icon.png) is provided. Replace it with your custom Ördin branding when ready.

## Installation Loading GIF

For Windows installer:
- **install-spinner.gif**: Animated loading graphic shown during installation
- Recommended size: 150x150 to 300x300 pixels
- Keep file size small (< 500 KB) for quick loading
