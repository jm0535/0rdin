#!/bin/bash

# WSL Setup Script for Ördin
# This script sets up Ördin when running in Windows Subsystem for Linux

set -e

echo "========================================"
echo "Ördin WSL Setup"
echo "========================================"
echo ""

# Check if running in WSL
if ! grep -qi microsoft /proc/version; then
    echo "WARNING: This doesn't appear to be WSL."
    echo "This script is designed for Windows Subsystem for Linux."
    echo ""
fi

# Check R installation
echo "[1/3] Checking R installation..."
if ! command -v R &> /dev/null; then
    echo "ERROR: R is not installed in WSL!"
    echo ""
    echo "To install R in WSL (Ubuntu/Debian):"
    echo "  sudo apt update"
    echo "  sudo apt install r-base r-base-dev"
    echo ""
    exit 1
fi

R --version | head -n 1
echo "✓ R found in WSL!"
echo ""

# Check Node.js in Windows
echo "[2/3] Checking Node.js (Windows)..."
echo "NOTE: Node.js should be installed in Windows, not WSL"
echo "If 'npm install' worked in PowerShell, you're good!"
echo ""

# Install R packages
echo "[3/3] Installing R packages..."
echo "This will install packages in your WSL R library."
echo ""

Rscript add-cran-binary-pkgs.R

echo ""
echo "========================================"
echo "WSL Setup Complete!"
echo "========================================"
echo ""
echo "Next Steps:"
echo ""
echo "1. Return to PowerShell"
echo "2. Run: npm start"
echo ""
echo "The app will use your WSL R installation!"
echo "========================================"
