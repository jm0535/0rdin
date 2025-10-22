#!/bin/bash

# macOS/Linux setup script for Ördin development environment

set -e

echo "========================================"
echo "Ördin Development Environment Setup"
echo "========================================"
echo ""

# Check Node.js
echo "[1/5] Checking Node.js installation..."
if ! command -v node &> /dev/null; then
    echo "ERROR: Node.js is not installed!"
    echo "Please download and install Node.js from https://nodejs.org"
    exit 1
fi
node --version
echo "Node.js found!"
echo ""

# Check npm
echo "[2/5] Checking npm installation..."
if ! command -v npm &> /dev/null; then
    echo "ERROR: npm is not installed!"
    exit 1
fi
npm --version
echo "npm found!"
echo ""

# Install Node.js dependencies
echo "[3/5] Installing Node.js dependencies..."
npm install
echo "Node.js dependencies installed!"
echo ""

# Check R installation
echo "[4/5] Checking R installation..."
if ! command -v R &> /dev/null; then
    echo "WARNING: R is not found in PATH"
    echo "You'll need to run ./get-r-mac.sh to set up portable R"
else
    R --version
    echo "R found!"
fi
echo ""

# Make scripts executable
echo "[5/5] Setting script permissions..."
chmod +x get-r-mac.sh
chmod +x get-r-win.sh
echo "Scripts are now executable!"
echo ""

echo "========================================"
echo "Setup complete!"
echo "========================================"
echo ""
echo "Next Steps:"
echo "========================================"
echo ""
echo "1. Set up portable R:"
echo "   ./get-r-mac.sh"
echo ""
echo "2. Install R packages:"
echo "   Rscript add-cran-binary-pkgs.R"
echo ""
echo "3. Start development server:"
echo "   npm start"
echo ""
echo "4. Build for production:"
echo "   npm run make"
echo ""
echo "See docs/QUICKSTART.md for detailed instructions."
echo "========================================"
echo ""
