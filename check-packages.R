# Check which Ördin packages are installed

required_packages <- c("shiny", "bslib", "vegan", "iNEXT", "ggplot2", "DT", "readr", "dplyr", "tidyr")

cat("========================================\n")
cat("Ördin Required Packages Status\n")
cat("========================================\n\n")

installed_count <- 0
missing_count <- 0

for (pkg in required_packages) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    version <- packageVersion(pkg)
    cat(sprintf("✓ %s (%s)\n", pkg, version))
    installed_count <- installed_count + 1
  } else {
    cat(sprintf("✗ %s - NOT INSTALLED\n", pkg))
    missing_count <- missing_count + 1
  }
}

cat("\n========================================\n")
cat(sprintf("Installed: %d / %d packages\n", installed_count, length(required_packages)))
cat(sprintf("Missing: %d packages\n", missing_count))
cat("========================================\n")

if (missing_count == 0) {
  cat("\n✅ All packages installed! Ready to run Ördin.\n")
} else {
  cat(sprintf("\n⏳ Still need to install %d packages.\n", missing_count))
}
