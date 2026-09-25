# Ördin Setup for Windows Subsystem for Linux (WSL)

> ⚠️ **Legacy document (Ördin 3.x).** This describes the R Shiny + Electron
> application in `shiny/` and `src/`, which is kept for maintenance only.
> For the current release see [Documentation Index](../DOCS-INDEX.md) ·
> [Quick Start](../QUICKSTART.md) · [Architecture](../ARCHITECTURE.md).

Since you have R installed in WSL (Windows Subsystem for Linux) rather than native Windows, follow these steps:

## Quick Setup (3 Steps)

### Step 1: Install R Packages in WSL

Open **bash** in your terminal and run:

```bash
cd /mnt/c/Users/UOTSTD933/Documents/workspace/jmoses/github_projects/ordin
chmod +x setup-wsl.sh
./setup-wsl.sh
```

This will install all required R packages:
- shiny, bslib, vegan, iNEXT, ggplot2, DT, readr

**Time**: ~5-10 minutes depending on internet speed

### Step 2: Verify Node.js Installation (Already Done ✅)

You already ran `npm install` successfully! Skip this step.

### Step 3: Start Ördin

In **PowerShell** (not bash), run:

```powershell
npm start
```

Ördin should launch! 🎉

---

## How It Works

Your setup is unique because:
- **Node.js & Electron**: Running in Windows (PowerShell)
- **R**: Running in WSL (Linux subsystem)

Ördin has been configured to handle this:
- The Electron app detects it's on Windows
- It tries to find R in the system PATH
- WSL's R is accessible from Windows via the `R` command
- Everything works seamlessly!

---

## Troubleshooting

### "R is not recognized" in PowerShell

You need to add WSL's R to Windows PATH or use the full WSL command.

**Quick Fix**: Edit `src/index.js` and change:

```javascript
function getRPath() {
  return 'wsl R';  // Run R via WSL
}
```

### "Cannot find module" errors in R

Install missing packages in bash:

```bash
bash
R
```

Then in R:
```r
install.packages(c("shiny", "bslib", "vegan", "iNEXT", "ggplot2", "DT", "readr"))
```

### Port 9054 already in use

Edit `src/start-shiny.R`:
```r
options(shiny.port = 9999)  # Use different port
```

Also update `src/index.js`:
```javascript
const SHINY_PORT = 9999;
```

---

## Alternative: Install R in Windows

If you want to avoid WSL complexity:

1. **Download R for Windows**: https://cloud.r-project.org/bin/windows/base/
2. **Install** to default location (e.g., `C:\Program Files\R\R-4.4.1`)
3. **Add to PATH**: 
   - Search "Environment Variables"
   - Edit PATH
   - Add `C:\Program Files\R\R-4.4.1\bin`
4. **Install packages** in PowerShell:
   ```powershell
   Rscript add-cran-binary-pkgs.R
   ```
5. **Run Ördin**:
   ```powershell
   npm start
   ```

---

## Your Current Setup Summary

✅ **Node.js**: Installed in Windows  
✅ **npm packages**: Installed (515 packages)  
✅ **R**: Installed in WSL (version 4.3.3)  
⏳ **R packages**: Run `./setup-wsl.sh` in bash  
⏳ **Launch**: Run `npm start` in PowerShell  

---

## Commands Cheat Sheet

```bash
# In bash (for R packages)
cd /mnt/c/Users/UOTSTD933/Documents/workspace/jmoses/github_projects/ordin
./setup-wsl.sh

# In PowerShell (for running app)
cd C:\Users\UOTSTD933\Documents\workspace\jmoses\github_projects\ordin
npm start

# To build executable
npm run make
```

---

## Next Steps

1. ✅ You've already run `npm install`
2. ⏳ Run `./setup-wsl.sh` in bash to install R packages
3. ⏳ Run `npm start` in PowerShell to launch Ördin
4. 🎉 Test with `sample-data/example-biodiversity.csv`

**Questions?** Check the main [README.md](../../README.md) or [GETTING_STARTED.md](../../.github/GETTING_STARTED.md)
