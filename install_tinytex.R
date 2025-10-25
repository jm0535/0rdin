# Install tinytex and rmarkdown packages
if (!require("tinytex", quietly = TRUE)) {
  install.packages("tinytex", repos = "https://cloud.r-project.org")
}

if (!require("rmarkdown", quietly = TRUE)) {
  install.packages("rmarkdown", repos = "https://cloud.r-project.org")
}

# Install TinyTeX distribution
if (!tinytex::is_tinytex()) {
  cat("Installing TinyTeX... This may take a few minutes.\n")
  tinytex::install_tinytex()
  cat("TinyTeX installed successfully!\n")
} else {
  cat("TinyTeX is already installed.\n")
}

# Verify installation
cat("\nVerifying pandoc installation...\n")
pandoc_path <- rmarkdown::pandoc_exec()
cat("Pandoc location:", pandoc_path, "\n")
cat("Pandoc version:", as.character(rmarkdown::pandoc_version()), "\n")
