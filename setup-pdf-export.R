# Ördin - Automated PDF Export Setup
# Author: Jimmy Moses (jmoses@pnguot.ac.pg)
# Automatically installs and configures all dependencies for PDF report generation

cat("═══════════════════════════════════════════════════════════════\n")
cat("  Ördin - PDF Export Automated Setup\n")
cat("═══════════════════════════════════════════════════════════════\n\n")

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Required packages for PDF export
pdf_packages <- c("rmarkdown", "knitr", "tinytex", "quarto", "flextable", "officer")

cat("Step 1: Installing R packages for PDF generation...\n")
cat("────────────────────────────────────────────────────────────────\n")

for (pkg in pdf_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cat(sprintf("Installing %s...", pkg))
    tryCatch({
      install.packages(pkg, quiet = TRUE)
      cat(" ✅\n")
    }, error = function(e) {
      cat(" ❌\n")
      cat("  Error:", conditionMessage(e), "\n")
    })
  } else {
    cat(sprintf("✅ %s already installed (v%s)\n", pkg, packageVersion(pkg)))
  }
}

cat("\n")
cat("Step 2: Checking Pandoc installation...\n")
cat("────────────────────────────────────────────────────────────────\n")

pandoc_installed <- FALSE
if (requireNamespace("rmarkdown", quietly = TRUE)) {
  pandoc_installed <- rmarkdown::pandoc_available()
  
  if (pandoc_installed) {
    pandoc_version <- rmarkdown::pandoc_version()
    cat(sprintf("✅ Pandoc is already installed (v%s)\n", pandoc_version))
    
    if (pandoc_version < "1.12.3") {
      cat("⚠️  Warning: Pandoc version is too old. Please update manually.\n")
      cat("   Download from: https://pandoc.org/installing.html\n")
      pandoc_installed <- FALSE
    }
  } else {
    cat("❌ Pandoc is not installed.\n")
    cat("\nTo install Pandoc:\n")
    cat("  Windows: winget install --id=JohnMacFarlane.Pandoc -e\n")
    cat("  macOS:   brew install pandoc\n")
    cat("  Linux:   sudo apt-get install pandoc  (or your package manager)\n")
    cat("\nOr download from: https://pandoc.org/installing.html\n")
  }
}

cat("\n")
cat("Step 3: Checking TinyTeX (LaTeX) installation...\n")
cat("────────────────────────────────────────────────────────────────\n")

tinytex_installed <- FALSE
if (requireNamespace("tinytex", quietly = TRUE)) {
  tinytex_installed <- tinytex::is_tinytex()
  
  if (tinytex_installed) {
    cat("✅ TinyTeX is already installed\n")
  } else {
    cat("⚠️  TinyTeX is not installed. Installing now...\n")
    cat("   This may take 2-5 minutes...\n\n")
    
    tryCatch({
      tinytex::install_tinytex()
      tinytex_installed <- TRUE
      cat("\n✅ TinyTeX installed successfully!\n")
    }, error = function(e) {
      cat("\n❌ Failed to install TinyTeX automatically.\n")
      cat("   Error:", conditionMessage(e), "\n")
      cat("   Please run manually: tinytex::install_tinytex()\n")
    })
  }
}

cat("\n")
cat("═══════════════════════════════════════════════════════════════\n")
cat("  Setup Summary\n")
cat("═══════════════════════════════════════════════════════════════\n\n")

# Check all components
all_ok <- TRUE

cat("R Packages:\n")
for (pkg in pdf_packages) {
  installed <- requireNamespace(pkg, quietly = TRUE)
  status <- if (installed) "✅" else "❌"
  cat(sprintf("  %s %s\n", status, pkg))
  if (!installed) all_ok <- FALSE
}

cat("\nPandoc:\n")
status <- if (pandoc_installed) "✅" else "❌"
cat(sprintf("  %s Pandoc (document converter)\n", status))
if (!pandoc_installed) all_ok <- FALSE

cat("\nLaTeX:\n")
status <- if (tinytex_installed) "✅" else "❌"
cat(sprintf("  %s TinyTeX (PDF rendering)\n", status))
if (!tinytex_installed) all_ok <- FALSE

cat("\n")
cat("═══════════════════════════════════════════════════════════════\n")

if (all_ok) {
  cat("  ✅ SUCCESS! PDF export is fully configured!\n")
  cat("═══════════════════════════════════════════════════════════════\n\n")
  cat("You can now:\n")
  cat("1. Start Ördin\n")
  cat("2. Run NMDS analysis\n")
  cat("3. Generate PDF reports\n\n")
  cat("To verify: Rscript verify-pdf-setup.R\n\n")
} else {
  cat("  ⚠️  PDF export setup incomplete\n")
  cat("═══════════════════════════════════════════════════════════════\n\n")
  cat("Please address the missing components above.\n")
  cat("After fixing, verify with: Rscript verify-pdf-setup.R\n\n")
}

cat("═══════════════════════════════════════════════════════════════\n")
