#!/bin/bash

# Script to download and extract portable R for Windows
# Requires Cygwin with wget and innoextract

set -e

# Configuration
R_VERSION="4.4.1"
R_URL="https://cloud.r-project.org/bin/windows/base/old/${R_VERSION}/R-${R_VERSION}-win.exe"
DOWNLOAD_DIR="r-win"
INSTALLER="R-${R_VERSION}-win.exe"

echo "========================================="
echo "Downloading Portable R for Windows"
echo "Version: ${R_VERSION}"
echo "========================================="

# Create download directory
mkdir -p "${DOWNLOAD_DIR}"
cd "${DOWNLOAD_DIR}"

# Download R installer
if [ ! -f "${INSTALLER}" ]; then
  echo "Downloading R installer..."
  wget "${R_URL}" -O "${INSTALLER}"
else
  echo "R installer already downloaded."
fi

# Extract using innoextract
echo "Extracting R installer..."
innoextract "${INSTALLER}"

# Verify extraction
if [ -d "app" ]; then
  echo "R extracted successfully to ${DOWNLOAD_DIR}/app"
  
  # Rename for consistency
  if [ ! -d "R-Portable" ]; then
    mv app R-Portable
  fi
  
  echo "========================================="
  echo "Portable R for Windows ready!"
  echo "Location: $(pwd)/R-Portable"
  echo "========================================="
else
  echo "Error: Extraction failed. Check innoextract installation."
  exit 1
fi

# Clean up installer
echo "Cleaning up..."
rm -f "${INSTALLER}"

echo "Done!"
