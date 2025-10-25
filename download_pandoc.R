# Download and install Pandoc for Windows
cat("Downloading Pandoc for Windows...\n")

# Create temp directory for download
temp_dir <- tempdir()
pandoc_installer <- file.path(temp_dir, "pandoc-installer.msi")

# Download latest Pandoc Windows installer
pandoc_url <- "https://github.com/jgm/pandoc/releases/download/3.1.9/pandoc-3.1.9-windows-x86_64.msi"

cat("Downloading from:", pandoc_url, "\n")
download.file(pandoc_url, destfile = pandoc_installer, mode = "wb")

cat("\nDownload complete. Installing Pandoc...\n")
cat("Please wait for the installation to complete.\n")

# Install using msiexec
system2("msiexec", args = c("/i", shQuote(pandoc_installer), "/qn", "/norestart"))

cat("\nPandoc installation complete!\n")
cat("You may need to restart your R session for changes to take effect.\n")

# Clean up
if (file.exists(pandoc_installer)) {
  file.remove(pandoc_installer)
}
