# Ördin - Verify PDF Export Setup
# Author: Jimmy Moses (jmoses@pnguot.ac.pg)
# Check if all dependencies for PDF report generation are properly installed

cat("═══════════════════════════════════════════════════════════════\n")
cat("  Ördin - PDF Export Setup Verification\n")
cat("═══════════════════════════════════════════════════════════════\n\n")

# Function to check package availability
check_package <- function(pkg_name) {
  available <- requireNamespace(pkg_name, quietly = TRUE)
  if (available) {
    version <- packageVersion(pkg_name)
    cat(sprintf("  ✅ %s (v%s)\n", pkg_name, version))
  } else {
    cat(sprintf("  ❌ %s - NOT INSTALLED\n", pkg_name))
  }
  return(available)
}

# Check R packages
cat("📦 Checking R Packages:\n")
packages_ok <- TRUE
packages_ok <- packages_ok && check_package("rmarkdown")
packages_ok <- packages_ok && check_package("knitr")
packages_ok <- packages_ok && check_package("tinytex")
packages_ok <- packages_ok && check_package("flextable")
packages_ok <- packages_ok && check_package("officer")

cat("\n")

# Check Pandoc
cat("🔧 Checking Pandoc:\n")
pandoc_ok <- FALSE

if (requireNamespace("rmarkdown", quietly = TRUE)) {
  pandoc_available <- rmarkdown::pandoc_available()
  
  if (pandoc_available) {
    pandoc_version <- rmarkdown::pandoc_version()
    pandoc_path <- rmarkdown::pandoc_exec()
    
    cat(sprintf("  ✅ Pandoc is installed\n"))
    cat(sprintf("     Version: %s\n", pandoc_version))
    cat(sprintf("     Location: %s\n", pandoc_path))
    
    if (pandoc_version >= "1.12.3") {
      cat("     ✅ Version is sufficient (≥ 1.12.3)\n")
      pandoc_ok <- TRUE
    } else {
      cat(sprintf("     ❌ Version too old (need ≥ 1.12.3, have %s)\n", pandoc_version))
    }
  } else {
    cat("  ❌ Pandoc is NOT installed\n")
    cat("     Install from: https://pandoc.org/installing.html\n")
  }
} else {
  cat("  ⚠️  Cannot check Pandoc (rmarkdown not installed)\n")
}

cat("\n")

# Check TinyTeX
cat("📝 Checking LaTeX (TinyTeX):\n")
latex_ok <- FALSE

if (requireNamespace("tinytex", quietly = TRUE)) {
  tinytex_installed <- tinytex::is_tinytex()
  
  if (tinytex_installed) {
    cat("  ✅ TinyTeX is installed\n")
    
    # Check for pdflatex
    pdflatex_path <- Sys.which("pdflatex")
    if (nchar(pdflatex_path) > 0) {
      cat(sprintf("     Location: %s\n", dirname(pdflatex_path)))
      cat("     ✅ pdflatex is available\n")
      latex_ok <- TRUE
    } else {
      cat("     ⚠️  pdflatex not found in PATH\n")
    }
  } else {
    cat("  ❌ TinyTeX is NOT installed\n")
    cat("     Install by running in R: tinytex::install_tinytex()\n")
  }
} else {
  cat("  ⚠️  Cannot check TinyTeX (tinytex package not installed)\n")
}

cat("\n")

# Overall status
cat("═══════════════════════════════════════════════════════════════\n")

if (packages_ok && pandoc_ok && latex_ok) {
  cat("  ✅ SUCCESS! PDF export is fully configured\n")
  cat("═══════════════════════════════════════════════════════════════\n\n")
  cat("You can now generate PDF reports from Ördin!\n\n")
  
} else {
  cat("  ⚠️  PDF export requires additional setup\n")
  cat("═══════════════════════════════════════════════════════════════\n\n")
  
  cat("To fix missing components:\n\n")
  
  if (!packages_ok) {
    cat("1. Install R packages:\n")
    cat("   install.packages(c('rmarkdown', 'knitr', 'tinytex', 'flextable', 'officer'))\n\n")
  }
  
  if (!pandoc_ok) {
    cat("2. Install Pandoc:\n")
    cat("   • Windows: Download from https://pandoc.org/installing.html\n")
    cat("   • Or run: install.packages('pandoc'); pandoc::pandoc_install()\n\n")
  }
  
  if (!latex_ok) {
    cat("3. Install TinyTeX (LaTeX):\n")
    cat("   tinytex::install_tinytex()\n\n")
  }
  
  cat("After installation, restart R and run this script again.\n\n")
}

cat("═══════════════════════════════════════════════════════════════\n")
