# Splash Screen - Quick Guide

> ⚠️ **Legacy document (Ördin 3.x).** This describes the R Shiny + Electron
> application in `shiny/` and `src/`, which is kept for maintenance only.
> For the current release see [Documentation Index](DOCS-INDEX.md) ·
> [Quick Start](QUICKSTART.md) · [Architecture](ARCHITECTURE.md).

**What**: Professional loading screen with Ö logo  
**When**: Displays during app startup  
**Duration**: 5-9 seconds (typical)

---

## What You'll See

```
┌─────────────────────────────────┐
│                                 │
│                                 │
│           Ö (Huge)              │
│     (Pulsing gently)            │
│                                 │
│          Ördin                  │
│                                 │
│  Biodiversity Analysis Platform │
│                                 │
│   ═══════════════════           │
│   [Animated loading bar]        │
│                                 │
│   ● Loading R environment...    │
│                                 │
│                                 │
│       Version 1.0               │
│                                 │
└─────────────────────────────────┘
```

---

## Features

### ✨ Professional Design
- Dark gradient background
- Rounded corners with shadow
- Frameless window (no title bar)
- Always on top

### 🎨 Ö Logo
- **Size**: 120px (large and visible)
- **Color**: Forest green (#2e8b57)
- **Animation**: Gentle pulsing effect
- **Shadow**: Glowing effect

### 📊 Loading Indicators
- **Progress bar**: Animated sweeping gradient
- **Status text**: Rotating messages every 2 seconds
- **Activity dot**: Blinking green indicator

### 💚 Brand Consistency
- Same colors as main app
- Ördin branding
- Professional typography

---

## Loading Messages

The splash screen shows these status messages in rotation:

1. ⚙️ **Initializing...**
2. 📦 **Loading R environment...**
3. 🚀 **Starting Shiny server...**
4. 🔧 **Preparing analysis tools...**
5. ✅ **Almost ready...**

Each message displays for 2 seconds.

---

## Startup Sequence

1. **Launch Ördin** → Splash appears instantly
2. **Background loading** → R and Shiny start
3. **Progress updates** → Status messages rotate
4. **App ready** → Splash fades out, main window appears

**Total time**: Usually 5-9 seconds

---

## How It Works

### Technical Flow

```
User clicks Ördin icon
        ↓
Splash window opens (< 100ms)
        ↓
R environment loads (background)
        ↓
Shiny server starts (background)
        ↓
Main window prepares (hidden)
        ↓
Main window ready → Event fires
        ↓
500ms smooth transition
        ↓
Splash closes + Main window shows
        ↓
User interaction begins
```

---

## Enterprise Features

✅ **Immediate feedback** - No blank screen  
✅ **Brand identity** - Ö logo showcased  
✅ **Progress indication** - User knows what's happening  
✅ **Smooth transitions** - Professional feel  
✅ **Error handling** - Closes properly on failure  
✅ **Cross-platform** - Works everywhere  

---

## Testing

When you launch Ördin, you should see:

1. ✅ Splash appears immediately
2. ✅ Ö logo is large and centered
3. ✅ Logo pulses smoothly
4. ✅ Loading bar animates left-to-right
5. ✅ Status messages change every 2 seconds
6. ✅ Green dot blinks continuously
7. ✅ After 5-9 seconds, splash closes
8. ✅ Main window appears smoothly

---

## Troubleshooting

**Splash doesn't appear?**
- Check console for errors
- Verify index.js was updated

**Splash never closes?**
- Check if Shiny server starts
- Look for R startup errors

**Choppy animations?**
- Normal on slower systems
- Doesn't affect functionality

---

## Customization

Want to modify the splash screen? Edit `src/index.js`:

- **Logo size**: Change `font-size: 120px`
- **Colors**: Change `#2e8b57` to your color
- **Messages**: Edit `statusMessages` array
- **Timing**: Adjust `setInterval` and `setTimeout` values

See [`SPLASH-SCREEN-IMPLEMENTATION.md`](DOCS-INDEX.md) for detailed customization guide.

---

**Perfect for professional applications!** 🚀

**Ördin** - *Enterprise-grade biodiversity analysis*
