# Script to install R packages into portable R installation
# Run this after setting up portable R with get-r-win.sh or get-r-mac.sh

# Determine platform and set paths
platform <- Sys.info()["sysname"]

if (platform == "Windows") {
  r_home <- file.path(getwd(), "r-win", "R-Portable", "App", "R-Portable")
  lib_path <- file.path(r_home, "library")
} else if (platform == "Darwin") {
  r_home <- file.path(getwd(), "r-mac")
  lib_path <- file.path(r_home, "library")
} else if (platform == "Linux") {
  # For WSL/Linux, use system R library (Electron will use system R)
  cat("Running on Linux/WSL - using system R libraries\n")
  lib_path <- .libPaths()[1]  # Use default library path
  r_home <- R.home()
} else {
  stop("Unsupported platform: ", platform)
}

# Create library directory if it doesn't exist
if (!dir.exists(lib_path)) {
  dir.create(lib_path, recursive = TRUE)
}

# Set library path
.libPaths(c(lib_path, .libPaths()))

cat("========================================\n")
cat("Installing R packages for Ördin\n")
cat("Platform:", platform, "\n")
cat("Library path:", lib_path, "\n")
cat("========================================\n")

# List of required packages
required_packages <- c(
  "shiny",
  "shinydashboard",
  "bslib",
  "vegan",
  "iNEXT",
  "ggplot2",
  "DT",
  "readr",
  "dplyr",
  "tidyr"
)

# Install packages
for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cat("\nInstalling package:", pkg, "\n")
    tryCatch({
      # Determine package type based on platform
      pkg_type <- if (platform == "Linux") "source" else "binary"
      
      install.packages(
        pkg,
        lib = lib_path,
        repos = "https://cloud.r-project.org/",  # Try: https://cran.rstudio.com/ or https://ftp.osuosl.org/pub/cran/
        dependencies = TRUE,
        type = pkg_type,
        Ncpus = parallel::detectCores() - 1  # Use multiple cores for faster compilation
      )
      cat("✓ Successfully installed:", pkg, "\n")
    }, error = function(e) {
      cat("✗ Failed to install:", pkg, "\n")
      cat("  Error:", e$message, "\n")
    })
  } else {
    cat("✓ Package already installed:", pkg, "\n")
  }
}

cat("\n========================================\n")
cat("Package installation complete!\n")
cat("========================================\n")

# Verify installations
cat("\nVerifying installations:\n")
for (pkg in required_packages) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    version <- packageVersion(pkg)
    cat("✓", pkg, "(version", as.character(version), ")\n")
  } else {
    cat("✗", pkg, "- NOT FOUND\n")
  }
}

cat("\nLibrary contents:\n")
print(list.files(lib_path))
