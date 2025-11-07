# Create a simple installer for Ördin
Write-Host "Creating Ördin installer..." -ForegroundColor Cyan

# Define paths
$sourceDir = "out\Ördin-win32-x64"
$installerDir = "out\installer"
$zipFile = "out\make\zip\win32\x64\Ördin-win32-x64-3.0.0.zip"

# Create installer directory
if (!(Test-Path $installerDir)) {
    New-Item -ItemType Directory -Path $installerDir | Out-Null
}

# Copy the executable to the installer directory
Copy-Item -Path "$sourceDir\ordin.exe" -Destination $installerDir

# Create a simple batch file to run the app
$batchContent = @"
@echo off
cd /d "%~dp0"
ordin.exe
"@
$batchContent | Out-File -FilePath "$installerDir\start-ordin.bat" -Encoding ASCII

# Create a simple installer batch file
$installerContent = @"
@echo off
echo Installing Ördin...
echo Copying files to C:\Program Files\Ördin...
xcopy /E /I /Y "$sourceDir" "C:\Program Files\Ördin"
echo Creating desktop shortcut...
powershell -Command "\$s = (New-Object -ComObject WScript.Shell).CreateShortcut('\$env:USERPROFILE\Desktop\Ördin.lnk'); \$s.TargetPath = 'C:\Program Files\Ördin\ordin.exe'; \$s.Save()"
echo Installation complete!
pause
"@
$installerContent | Out-File -FilePath "$installerDir\install-ordin.bat" -Encoding ASCII

Write-Host "Installer created at $installerDir" -ForegroundColor Green