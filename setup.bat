@echo off
REM Windows batch script to set up Ördin development environment

echo ========================================
echo Ordin Development Environment Setup
echo ========================================
echo.

REM Check Node.js
echo [1/5] Checking Node.js installation...
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Node.js is not installed!
    echo Please download and install Node.js from https://nodejs.org
    pause
    exit /b 1
)
node --version
echo Node.js found!
echo.

REM Check npm
echo [2/5] Checking npm installation...
where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: npm is not installed!
    pause
    exit /b 1
)
npm --version
echo npm found!
echo.

REM Install Node.js dependencies
echo [3/5] Installing Node.js dependencies...
call npm install
if %errorlevel% neq 0 (
    echo ERROR: npm install failed!
    pause
    exit /b 1
)
echo Node.js dependencies installed!
echo.

REM Check R installation
echo [4/5] Checking R installation...
where R >nul 2>&1
if %errorlevel% neq 0 (
    echo WARNING: R is not found in PATH
    echo You'll need to run get-r-win.sh in Cygwin to set up portable R
) else (
    R --version
    echo R found!
)
echo.

REM Instructions for next steps
echo [5/5] Setup complete!
echo.
echo ========================================
echo Next Steps:
echo ========================================
echo.
echo 1. Set up portable R (in Cygwin):
echo    cd /cygdrive/c/path/to/ordin
echo    ./get-r-win.sh
echo.
echo 2. Install R packages:
echo    Rscript add-cran-binary-pkgs.R
echo.
echo 3. Start development server:
echo    npm start
echo.
echo 4. Build for production:
echo    npm run make
echo.
echo See docs/QUICKSTART.md for detailed instructions.
echo ========================================
echo.

pause
