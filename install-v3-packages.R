# Ördin v3.0 - Install Enterprise-Grade R Package Dependencies
# Run this script to install all required packages for v3.0 features

cat("═══════════════════════════════════════════════════════════════\n")
cat("  Ördin v3.0 - Enterprise Package Installation\n")
cat("═══════════════════════════════════════════════════════════════\n\n")

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# List of required packages for v3.0
v3_packages <- c(
  # Core Shiny packages (existing)
  "shiny",
  "bslib",
  
  # Data analysis packages (existing)
  "vegan",
  "iNEXT",
  "ggplot2",
  "DT",
  "readr",
  "dplyr",
  "tidyr",
  
  # NEW v3.0 Enterprise Features
  "shinyjs",          # Enhanced JavaScript interactivity & keyboard shortcuts
  "waiter",           # Professional loading screens & progress bars
  "shinyFeedback",    # Inline validation messages
  "shinycssloaders",  # Loading spinners for plots
  "shinyWidgets",     # Enhanced UI widgets (tooltips, dropdowns)
  "openxlsx",         # Excel export (.xlsx)
  "jsonlite",         # JSON export for APIs
  "clipr",            # Clipboard support (copy to clipboard)
  "shinyBS",          # Bootstrap components (tooltips, popovers)
  "shinyalert"        # Professional alert dialogs
)

cat("📦 Packages to install/update:\n")
print(v3_packages)
cat("\n")

# Check which packages are already installed
installed_pkgs <- rownames(installed.packages())
to_install <- v3_packages[!v3_packages %in% installed_pkgs]

if (length(to_install) == 0) {
  cat("✅ All v3.0 packages are already installed!\n\n")
} else {
  cat("📥 Installing", length(to_install), "new packages...\n\n")
  
  # Install missing packages with progress
  for (i in seq_along(to_install)) {
    pkg <- to_install[i]
    cat(sprintf("[%d/%d] Installing %s...", i, length(to_install), pkg))
    
    tryCatch({
      install.packages(pkg, quiet = TRUE)
      cat(" ✅\n")
    }, error = function(e) {
      cat(" ❌ FAILED\n")
      cat("  Error:", conditionMessage(e), "\n")
    })
  }
}

# Verify all packages can be loaded
cat("\n🔍 Verifying package installation...\n")
all_loaded <- TRUE

for (pkg in v3_packages) {
  result <- tryCatch({
    library(pkg, character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE)
    TRUE
  }, error = function(e) {
    FALSE
  })
  
  status <- if (result) "✅" else "❌"
  cat(sprintf("  %s %s\n", status, pkg))
  
  if (!result) all_loaded <- FALSE
}

cat("\n")
if (all_loaded) {
  cat("═══════════════════════════════════════════════════════════════\n")
  cat("  ✅ SUCCESS! All v3.0 packages installed and verified\n")
  cat("═══════════════════════════════════════════════════════════════\n\n")
  cat("🚀 You can now run Ördin v3.0 with all enterprise features!\n\n")
  cat("Next steps:\n")
  cat("1. Replace shiny/app.R with the new v3.0 version\n")
  cat("2. Update package.json version to 3.0.0\n")
  cat("3. Run 'npm start' to test the new features\n\n")
} else {
  cat("═══════════════════════════════════════════════════════════════\n")
  cat("  ⚠️  Some packages failed to install\n")
  cat("═══════════════════════════════════════════════════════════════\n\n")
  cat("Please check the errors above and try installing failed packages manually:\n")
  cat("  install.packages(c('package_name'))\n\n")
}

# Display package versions for troubleshooting
cat("📋 Installed package versions:\n")
for (pkg in v3_packages) {
  if (pkg %in% installed_pkgs) {
    version <- packageVersion(pkg)
    cat(sprintf("  %s: %s\n", pkg, version))
  }
}

cat("\n═══════════════════════════════════════════════════════════════\n")
cat("  Installation script completed!\n")
cat("═══════════════════════════════════════════════════════════════\n")
