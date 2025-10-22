#!/bin/bash

# Script to prepare and publish Ördin to GitHub
# Usage: ./publish.sh

set -e

echo "========================================"
echo "Ördin GitHub Publishing Script"
echo "========================================"
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "ERROR: git is not installed!"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "ERROR: package.json not found. Are you in the ordin directory?"
    exit 1
fi

echo "Step 1: Checking for uncommitted changes..."
if [ -d ".git" ]; then
    echo "Git repository already initialized."
    git status
else
    echo "Initializing git repository..."
    git init
    echo "✓ Git repository initialized"
fi

echo ""
echo "Step 2: Creating .gitignore (if needed)..."
if [ ! -f ".gitignore" ]; then
    echo "ERROR: .gitignore not found!"
    exit 1
else
    echo "✓ .gitignore found"
fi

echo ""
echo "Step 3: Staging all files..."
git add .
echo "✓ Files staged"

echo ""
echo "Step 4: Creating initial commit..."
git commit -m "Initial commit: Ördin v1.0.0 - Cross-platform biodiversity analysis app" || echo "Nothing to commit or already committed"

echo ""
echo "Step 5: Checking for remote..."
if git remote | grep -q origin; then
    echo "Remote 'origin' already exists:"
    git remote -v
else
    echo "Adding remote origin..."
    git remote add origin https://github.com/jm0535/0rdin.git
    echo "✓ Remote added"
fi

echo ""
echo "Step 6: Setting main branch..."
git branch -M main

echo ""
echo "========================================"
echo "Ready to Push!"
echo "========================================"
echo ""
echo "To publish to GitHub, run:"
echo "  git push -u origin main"
echo ""
echo "Make sure you've created the repository at:"
echo "  https://github.com/jm0535/0rdin"
echo ""
echo "After pushing, create a release:"
echo "  1. Build: npm run make"
echo "  2. Go to: https://github.com/jm0535/0rdin/releases/new"
echo "  3. Tag: v1.0.0"
echo "  4. Upload binaries from out/make/"
echo ""
echo "See PUBLISH.md for detailed instructions."
echo "========================================"
