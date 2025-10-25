# Install pandoc via rmarkdown
cat("Checking for pandoc...\n")

# Check if pandoc is available
pandoc_available <- rmarkdown::pandoc_available()
cat("Pandoc available:", pandoc_available, "\n")

if (!pandoc_available) {
  cat("Pandoc not found. Installing via tinytex...\n")
  # Install pandoc LaTeX package
  tinytex::tlmgr_install("pandoc")
}

# Alternative: use rmarkdown's bundled pandoc
cat("\nAttempting to use rmarkdown's bundled pandoc...\n")
Sys.setenv(RSTUDIO_PANDOC = rmarkdown::find_pandoc()$dir)
cat("RSTUDIO_PANDOC set to:", Sys.getenv("RSTUDIO_PANDOC"), "\n")

# Final verification
if (rmarkdown::pandoc_available()) {
  cat("\nPandoc is now available!\n")
  cat("Version:", as.character(rmarkdown::pandoc_version()), "\n")
  cat("Location:", rmarkdown::pandoc_exec(), "\n")
} else {
  cat("\nWARNING: Pandoc still not available. Manual installation may be required.\n")
  cat("You can download pandoc from: https://pandoc.org/installing.html\n")
}
