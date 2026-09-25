# Ördin Quick Start for Fedora

> ⚠️ **Legacy document (Ördin 3.x).** This describes the R Shiny + Electron
> application in `shiny/` and `src/`, which is kept for maintenance only.
> For the current release see [Documentation Index](../DOCS-INDEX.md) ·
> [Quick Start](../QUICKSTART.md) · [Architecture](../ARCHITECTURE.md).

**Fast setup guide for Fedora Linux users**

---

## One-Command Install

```bash
cd /path/to/ordin
chmod +x setup-linux.sh && ./setup-linux.sh
```

That's it! The script handles everything automatically.

---

## Manual Install (if you prefer)

### Step 1: Install Prerequisites

```bash
# Install Node.js and npm
sudo dnf install -y nodejs npm

# Install R
sudo dnf install -y R R-devel

# Install system dependencies for R packages
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
```

### Step 2: Install Project Dependencies

```bash
cd /path/to/ordin
npm install
```

### Step 3: Install R Packages

```bash
Rscript add-cran-binary-pkgs.R
```

⏱️ Takes 10-20 minutes (compiling from source)

---

## Running Ördin

### Development Mode

```bash
npm start
```

Opens the app in an Electron window.

### Build RPM Package

```bash
npm run make
```

**Output**: `out/make/rpm/x64/ordin-1.0.0-1.x86_64.rpm`

### Install RPM

```bash
sudo dnf install out/make/rpm/x64/ordin-1.0.0-1.x86_64.rpm
```

Then launch from Applications menu or run `ordin` in terminal.

---

## First Analysis

1. **Launch**: `npm start`
2. **Upload CSV**: Click "Upload Species Abundance CSV"
3. **Load Sample**: Navigate to `sample-data/example-biodiversity.csv`
4. **Select Analysis**: Choose "Diversity Estimation (iNEXT)"
5. **Run**: Click "Run Analysis"
6. **View Results**: See diversity table and rarefaction curves!

---

## Tips for Fedora

### Performance
- Fedora's optimized packages make R 10-20% faster than Windows
- First launch: ~5 seconds
- Analysis: Usually < 30 seconds

### SELinux
If SELinux blocks Electron:
```bash
# Temporarily disable (testing)
sudo setenforce 0

# Make permanent (not recommended)
sudo nano /etc/selinux/config
# Set: SELINUX=permissive
```

### Firewall (if running server mode)
```bash
sudo firewall-cmd --add-port=9054/tcp --permanent
sudo firewall-cmd --reload
```

### Package Management
```bash
# Update Ördin dependencies
npm update

# Update R packages
Rscript add-cran-binary-pkgs.R
```

---

## Troubleshooting

### "dnf install nodejs" fails

Enable NodeSource repository:
```bash
curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
sudo dnf install -y nodejs
```

### R package compilation fails

Missing development tools:
```bash
sudo dnf groupinstall "Development Tools"
sudo dnf install gcc-c++ make
```

### "Cannot find module" in npm

Rebuild native modules:
```bash
npm rebuild
```

---

## Distribution

Share your built RPM with other Fedora users:

```bash
# On your system (build)
npm run make

# Share this file
out/make/rpm/x64/ordin-1.0.0-1.x86_64.rpm

# On recipient's system (install)
sudo dnf install ordin-1.0.0-1.x86_64.rpm
```

---

## System Requirements

**Minimum**:
- Fedora 37+
- 2 GB RAM
- 500 MB disk space

**Recommended**:
- Fedora 39+
- 4 GB RAM
- 1 GB disk space

---

## Documentation

- **Full Linux Guide**: [SETUP-LINUX.md](SETUP-LINUX.md)
- **General Guide**: [README.md](../../README.md)
- **Development**: [docs/DEVELOPMENT.md](../DEVELOPMENT.md)

---

## Support

**Email**: jimmy.moses@pnguot.ac.pg

**Issues**: Report on GitHub (if applicable)

---

**Enjoy biodiversity analysis on Fedora!** 🎩🐧🌿
