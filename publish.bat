@echo off
REM Script to prepare and publish Ordin to GitHub
REM Usage: publish.bat

echo ========================================
echo Ordin GitHub Publishing Script
echo ========================================
echo.

REM Check if git is installed
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: git is not installed!
    pause
    exit /b 1
)

REM Check if we're in the right directory
if not exist package.json (
    echo ERROR: package.json not found. Are you in the ordin directory?
    pause
    exit /b 1
)

echo Step 1: Checking for uncommitted changes...
if exist .git (
    echo Git repository already initialized.
    git status
) else (
    echo Initializing git repository...
    git init
    echo Git repository initialized
)

echo.
echo Step 2: Creating .gitignore (if needed)...
if not exist .gitignore (
    echo ERROR: .gitignore not found!
    pause
    exit /b 1
) else (
    echo .gitignore found
)

echo.
echo Step 3: Staging all files...
git add .
echo Files staged

echo.
echo Step 4: Creating initial commit...
git commit -m "Initial commit: Ordin v1.0.0 - Cross-platform biodiversity analysis app"
if %errorlevel% neq 0 (
    echo Nothing to commit or already committed
)

echo.
echo Step 5: Checking for remote...
git remote | findstr origin >nul
if %errorlevel% equ 0 (
    echo Remote 'origin' already exists:
    git remote -v
) else (
    echo Adding remote origin...
    git remote add origin https://github.com/jm0535/0rdin.git
    echo Remote added
)

echo.
echo Step 6: Setting main branch...
git branch -M main

echo.
echo ========================================
echo Ready to Push!
echo ========================================
echo.
echo To publish to GitHub, run:
echo   git push -u origin main
echo.
echo Make sure you've created the repository at:
echo   https://github.com/jm0535/0rdin
echo.
echo After pushing, create a release:
echo   1. Build: npm run make
echo   2. Go to: https://github.com/jm0535/0rdin/releases/new
echo   3. Tag: v1.0.0
echo   4. Upload binaries from out\make\
echo.
echo See PUBLISH.md for detailed instructions.
echo ========================================
echo.

pause
