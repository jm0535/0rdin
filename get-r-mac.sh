#!/bin/bash

# Script to download and extract portable R for macOS

set -e

# Configuration
R_VERSION="4.4.1"
R_URL="https://cloud.r-project.org/bin/macosx/base/R-${R_VERSION}-arm64.pkg"
DOWNLOAD_DIR="r-mac"
INSTALLER="R-${R_VERSION}.pkg"

echo "========================================="
echo "Downloading Portable R for macOS"
echo "Version: ${R_VERSION}"
echo "========================================="

# Create download directory
mkdir -p "${DOWNLOAD_DIR}"
cd "${DOWNLOAD_DIR}"

# Download R installer
if [ ! -f "${INSTALLER}" ]; then
  echo "Downloading R installer..."
  curl -L "${R_URL}" -o "${INSTALLER}"
else
  echo "R installer already downloaded."
fi

# Extract the package
echo "Extracting R installer..."
pkgutil --expand "${INSTALLER}" R-extracted

# Extract R from the package
echo "Extracting R files..."
cd R-extracted
tar -xvf R-app.pkg/Payload -C ../

# Move R.app to bin location
cd ..
if [ -d "R.app" ]; then
  mkdir -p bin
  cp -R R.app/Contents/MacOS/* bin/
  cp -R R.app/Contents/Resources/* bin/
  
  echo "========================================="
  echo "Portable R for macOS ready!"
  echo "Location: $(pwd)/bin"
  echo "========================================="
else
  echo "Error: Extraction failed."
  exit 1
fi

# Clean up
echo "Cleaning up..."
rm -rf R-extracted
rm -f "${INSTALLER}"

echo "Done!"
