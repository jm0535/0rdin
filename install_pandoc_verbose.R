# Download and install Pandoc for Windows with proper logging
cat("Downloading Pandoc for Windows...\n")

# Create temp directory for download
temp_dir <- tempdir()
pandoc_installer <- file.path(temp_dir, "pandoc-installer.msi")

# Download latest Pandoc Windows installer
pandoc_url <- "https://github.com/jgm/pandoc/releases/download/3.1.9/pandoc-3.1.9-windows-x86_64.msi"

cat("Downloading from:", pandoc_url, "\n")
download.file(pandoc_url, destfile = pandoc_installer, mode = "wb")

cat("\nDownload complete:", pandoc_installer, "\n")
cat("File size:", file.size(pandoc_installer), "bytes\n")

cat("\nInstalling Pandoc with logging...\n")
cat("This will install to: C:\\Program Files\\Pandoc\n\n")

# Create log file
log_file <- file.path(temp_dir, "pandoc_install.log")

# Install using msiexec with logging and wait for completion
cmd <- sprintf('msiexec /i "%s" /qn /norestart /L*V "%s"', pandoc_installer, log_file)
cat("Running:", cmd, "\n\n")

result <- system(cmd, wait = TRUE)

# Wait a moment for installation to complete
Sys.sleep(3)

cat("\nInstallation command returned code:", result, "\n")

# Check if Pandoc was installed
pandoc_paths <- c(
  "C:/Program Files/Pandoc/pandoc.exe",
  "C:/Program Files (x86)/Pandoc/pandoc.exe",
  file.path(Sys.getenv("LOCALAPPDATA"), "Pandoc", "pandoc.exe")
)

pandoc_found <- FALSE
for (path in pandoc_paths) {
  if (file.exists(path)) {
    cat("\n✅ Pandoc installed successfully!\n")
    cat("Location:", path, "\n")
    pandoc_found <- TRUE
    
    # Get version
    version_cmd <- sprintf('"%s" --version', path)
    cat("\nVersion info:\n")
    system(version_cmd)
    
    # Add to PATH for current session
    current_path <- Sys.getenv("PATH")
    pandoc_dir <- dirname(path)
    if (!grepl(pandoc_dir, current_path, fixed = TRUE)) {
      Sys.setenv(PATH = paste(pandoc_dir, current_path, sep = ";"))
      cat("\nAdded to current session PATH:", pandoc_dir, "\n")
    }
    
    break
  }
}

if (!pandoc_found) {
  cat("\n⚠️ Pandoc installation may have failed.\n")
  cat("Check the installation log:", log_file, "\n")
  
  if (file.exists(log_file)) {
    cat("\nLast 20 lines of installation log:\n")
    cat("═══════════════════════════════════════════════\n")
    log_lines <- readLines(log_file)
    cat(tail(log_lines, 20), sep = "\n")
    cat("═══════════════════════════════════════════════\n")
  }
} else {
  cat("\n✅ Installation complete!\n")
  cat("NOTE: You may need to restart R for rmarkdown to detect Pandoc.\n")
}

# Clean up
if (file.exists(pandoc_installer)) {
  file.remove(pandoc_installer)
  cat("\nCleaned up installer file.\n")
}
