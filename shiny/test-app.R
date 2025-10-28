# Test script for Ördin Shiny App
library(shiny)

# Load all required packages
required_packages <- c(
  "shiny", "bslib", "vegan", "iNEXT", "ggplot2", "DT", "shinyjs", 
  "waiter", "shinydashboard", "shinyWidgets", "DT", "readr", 
  "readxl", "dplyr", "tidyr"
)

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE)) {
    cat("Package", pkg, "is not installed!\n")
  } else {
    cat("Package", pkg, "is loaded\n")
  }
}

# Check if all files exist
files_to_check <- c(
  "app.R",
  "prototype-styles.css",
  "shiny-layout-fix.css",
  "custom.css",
  "validation.js",
  "about-ordin-content.js",
  "prototype.js",
  "statistical-interpretation.js"
)

for (file in files_to_check) {
  if (file.exists(file)) {
    cat("File", file, "exists\n")
  } else {
    cat("File", file, "is missing!\n")
  }
}

# Check modules
module_files <- list.files("modules", pattern = "*.R", full.names = TRUE)
for (module in module_files) {
  if (file.exists(module)) {
    cat("Module", basename(module), "exists\n")
  } else {
    cat("Module", basename(module), "is missing!\n")
  }
}

# Try to load the app without running
cat("\nAttempting to load app UI...\n")
tryCatch({
  source("app.R", local = TRUE)
  cat("App loaded successfully!\n")
}, error = function(e) {
  cat("Error loading app:", e$message, "\n")
})

cat("\nTest complete!\n")