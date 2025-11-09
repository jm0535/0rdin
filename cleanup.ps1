# Ordin Project Cleanup Script
# Safely removes build artifacts and temporary files

Write-Host "Starting Ordin Project Cleanup..." -ForegroundColor Cyan

# Kill any running Rscript processes that might lock files
Write-Host "`nStopping Rscript processes..." -ForegroundColor Yellow
Get-Process -Name "Rscript" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Kill any running Electron/Ordin processes
Write-Host "Stopping Electron/Ordin processes..." -ForegroundColor Yellow
Get-Process -Name "ordin" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Remove temporary command files
Write-Host "`nRemoving temporary files..." -ForegroundColor Yellow
$tempFiles = @("11.6.2", "electron-forge", "npm", "ordin@3.0.0", "taskkill", "wsl", "test-path-resolution.js")
foreach ($file in $tempFiles) {
    if (Test-Path $file) {
        Remove-Item $file -Force -ErrorAction SilentlyContinue
        Write-Host "  Removed: $file" -ForegroundColor Green
    }
}

# Remove out folder (build artifacts)
Write-Host "`nRemoving build artifacts (out folder)..." -ForegroundColor Yellow
if (Test-Path "out") {
    try {
        Remove-Item "out" -Recurse -Force -ErrorAction Stop
        Write-Host "  Removed: out/" -ForegroundColor Green
    } catch {
        Write-Host "  Could not remove 'out' folder - files may be locked" -ForegroundColor Red
        Write-Host "  Try closing all applications and run this script again" -ForegroundColor Red
    }
}

# Remove r-win folder (R portable installation used for building)
Write-Host "`nRemoving R portable build folder..." -ForegroundColor Yellow
if (Test-Path "r-win") {
    try {
        Remove-Item "r-win" -Recurse -Force -ErrorAction Stop
        Write-Host "  Removed: r-win/" -ForegroundColor Green
    } catch {
        Write-Host "  Could not remove 'r-win' folder - files may be locked" -ForegroundColor Red
    }
}

# Remove archive folder if empty
Write-Host "`nChecking archive folder..." -ForegroundColor Yellow
if (Test-Path "archive") {
    $archiveItems = Get-ChildItem "archive" -ErrorAction SilentlyContinue
    if ($archiveItems.Count -eq 0) {
        Remove-Item "archive" -Force -ErrorAction SilentlyContinue
        Write-Host "  Removed empty: archive/" -ForegroundColor Green
    } else {
        Write-Host "  Keeping archive/ (contains files)" -ForegroundColor Cyan
    }
}

# Check node_modules
Write-Host "`nChecking node_modules..." -ForegroundColor Yellow
if (Test-Path "node_modules") {
    Write-Host "  Keeping node_modules/ (run 'npm prune' to clean unused packages)" -ForegroundColor Cyan
}

Write-Host "`nCleanup complete!" -ForegroundColor Green
Write-Host "`nPreserved:" -ForegroundColor Cyan
Write-Host "  - Source code (src/, shiny/)" -ForegroundColor White
Write-Host "  - Documentation (docs/, README.md, CHANGELOG.md)" -ForegroundColor White
Write-Host "  - Configuration (package.json, .gitignore)" -ForegroundColor White
Write-Host "  - Sample data (sample-data/)" -ForegroundColor White
Write-Host "  - Build scripts (setup.bat, setup.sh, etc.)" -ForegroundColor White
