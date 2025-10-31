#!/bin/bash

# Linux Setup Script for Ördin
# Supports: Ubuntu/Debian, Fedora/RHEL/CentOS, Arch, openSUSE

set -e

echo "========================================"
echo "Ördin Linux Setup"
echo "========================================"
echo ""

# Detect Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    OS_LIKE=$ID_LIKE
else
    echo "Cannot detect Linux distribution"
    exit 1
fi

echo "Detected OS: $OS"
echo ""

# Function to check if running as root
check_root() {
    if [ "$EUID" -eq 0 ]; then
        echo "WARNING: Running as root. This is not recommended."
        echo "Please run as regular user. Script will use sudo when needed."
        exit 1
    fi
}

# Check Node.js
check_nodejs() {
    echo "[1/5] Checking Node.js installation..."
    if ! command -v node &> /dev/null; then
        echo "ERROR: Node.js is not installed!"
        echo ""
        echo "To install Node.js:"
        case $OS in
            ubuntu|debian)
                echo "  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -"
                echo "  sudo apt-get install -y nodejs"
                ;;
            fedora)
                echo "  sudo dnf install -y nodejs npm"
                ;;
            rhel|centos|rocky|almalinux)
                echo "  curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -"
                echo "  sudo yum install -y nodejs"
                ;;
            arch|manjaro)
                echo "  sudo pacman -S nodejs npm"
                ;;
            opensuse*)
                echo "  sudo zypper install nodejs npm"
                ;;
        esac
        echo ""
        exit 1
    fi
    
    node --version
    npm --version
    echo "✓ Node.js found!"
    echo ""
}

# Check R
check_r() {
    echo "[2/5] Checking R installation..."
    if ! command -v R &> /dev/null; then
        echo "ERROR: R is not installed!"
        echo ""
        echo "To install R:"
        case $OS in
            ubuntu|debian)
                echo "  sudo apt update"
                echo "  sudo apt install -y r-base r-base-dev"
                ;;
            fedora)
                echo "  sudo dnf install -y R R-devel"
                ;;
            rhel|centos|rocky|almalinux)
                echo "  sudo yum install -y epel-release"
                echo "  sudo yum install -y R R-devel"
                ;;
            arch|manjaro)
                echo "  sudo pacman -S r"
                ;;
            opensuse*)
                echo "  sudo zypper install R-base R-base-devel"
                ;;
        esac
        echo ""
        exit 1
    fi
    
    R --version | head -n 1
    echo "✓ R found!"
    echo ""
}

# Install system dependencies for R packages
install_system_deps() {
    echo "[3/5] Installing system dependencies for R packages..."
    echo "This requires sudo privileges."
    echo ""
    
    case $OS in
        ubuntu|debian)
            echo "Installing dependencies for Ubuntu/Debian..."
            sudo apt-get update
            sudo apt-get install -y \
                libcurl4-openssl-dev \
                libssl-dev \
                libxml2-dev \
                libfontconfig1-dev \
                libharfbuzz-dev \
                libfribidi-dev \
                libfreetype6-dev \
                libpng-dev \
                libtiff5-dev \
                libjpeg-dev \
                libcairo2-dev \
                libgit2-dev \
                libssh2-1-dev \
                zlib1g-dev
            ;;
        fedora)
            echo "Installing dependencies for Fedora..."
            sudo dnf install -y \
                libcurl-devel \
                openssl-devel \
                libxml2-devel \
                fontconfig-devel \
                harfbuzz-devel \
                fribidi-devel \
                freetype-devel \
                libpng-devel \
                libtiff-devel \
                libjpeg-turbo-devel \
                cairo-devel \
                libgit2-devel \
                libssh2-devel \
                zlib-devel
            ;;
        rhel|centos|rocky|almalinux)
            echo "Installing dependencies for RHEL/CentOS..."
            sudo yum install -y epel-release
            sudo yum install -y \
                libcurl-devel \
                openssl-devel \
                libxml2-devel \
                fontconfig-devel \
                harfbuzz-devel \
                fribidi-devel \
                freetype-devel \
                libpng-devel \
                libtiff-devel \
                libjpeg-turbo-devel \
                cairo-devel \
                libgit2-devel \
                libssh2-devel \
                zlib-devel
            ;;
        arch|manjaro)
            echo "Installing dependencies for Arch..."
            sudo pacman -S --noconfirm \
                curl \
                openssl \
                libxml2 \
                fontconfig \
                harfbuzz \
                fribidi \
                freetype2 \
                libpng \
                libtiff \
                libjpeg-turbo \
                cairo \
                libgit2 \
                libssh2 \
                zlib
            ;;
        opensuse*)
            echo "Installing dependencies for openSUSE..."
            sudo zypper install -y \
                libcurl-devel \
                libopenssl-devel \
                libxml2-devel \
                fontconfig-devel \
                harfbuzz-devel \
                fribidi-devel \
                freetype2-devel \
                libpng16-devel \
                libtiff-devel \
                libjpeg8-devel \
                cairo-devel \
                libgit2-devel \
                libssh2-devel \
                zlib-devel
            ;;
        *)
            echo "Unknown distribution: $OS"
            echo "Please install R development dependencies manually."
            echo "Required: curl, openssl, xml2, fontconfig, cairo, etc."
            ;;
    esac
    
    echo "✓ System dependencies installed!"
    echo ""
}

# Install Node.js dependencies
install_node_deps() {
    echo "[4/5] Installing Node.js dependencies..."
    npm install
    echo "✓ Node.js dependencies installed!"
    echo ""
}

# Install R packages
install_r_packages() {
    echo "[5/5] Installing R packages..."
    echo "This may take 10-20 minutes as packages compile from source."
    echo ""
    
    Rscript add-cran-binary-pkgs.R
    
    echo ""
    echo "✓ R packages installed!"
    echo ""
}

# Main execution
check_root
check_nodejs
check_r
install_system_deps
install_node_deps
install_r_packages

echo "========================================"
echo "Ördin Setup Complete!"
echo "========================================"
echo ""
echo "Next Steps:"
echo ""
echo "1. Start development server:"
echo "   npm start"
echo ""
echo "2. Build for distribution:"
echo "   npm run make"
echo ""
echo "3. Test with sample data:"
echo "   Upload: sample-data/example-biodiversity.csv"
echo ""
echo "Documentation:"
echo "  - Quick Start: docs/QUICKSTART.md"
echo "  - Development: docs/DEVELOPMENT.md"
echo "  - Linux Guide: SETUP-LINUX.md"
echo ""
echo "========================================"
echo ""
echo "Enjoy analyzing biodiversity with Ördin! 🌿"
echo ""
