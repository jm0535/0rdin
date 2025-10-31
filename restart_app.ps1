# Restart Ördin Shiny App
Write-Host "=== Restarting Ördin Shiny App ===" -ForegroundColor Cyan

# Kill all R processes
Write-Host "Stopping all R processes..." -ForegroundColor Yellow
Get-Process | Where-Object {$_.ProcessName -eq "Rterm" -or $_.ProcessName -eq "R" -or $_.ProcessName -eq "Rgui"} | Stop-Process -Force
Start-Sleep -Seconds 2

# Navigate to shiny directory
Set-Location -Path "$PSScriptRoot\shiny"

# Start the app
Write-Host "Starting Shiny app on port 9054..." -ForegroundColor Green
Write-Host "App will be available at: http://localhost:9054" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press CTRL+C to stop the app" -ForegroundColor Yellow
Write-Host ""

# Run the app
& "C:\Program Files\R\R-4.5.1\bin\x64\Rscript.exe" -e "shiny::runApp(port=9054)"
