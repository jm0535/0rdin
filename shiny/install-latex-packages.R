# Install required LaTeX packages for kableExtra
# Run this once to ensure all LaTeX dependencies are available

cat("\n=== Installing Required LaTeX Packages ===\n")

# Check if tinytex is installed
if (!tinytex::is_tinytex()) {
  cat("TinyTeX not found. Installing...\n")
  tinytex::install_tinytex()
} else {
  cat("✓ TinyTeX is installed\n")
}

# List of LaTeX packages required by kableExtra and our template
latex_packages <- c(
  "booktabs",
  "longtable",
  "array",
  "multirow",
  "wrapfig",
  "float",
  "colortbl",
  "pdflscape",
  "tabu",
  "threeparttable",
  "threeparttablex",
  "ulem",
  "makecell",
  "xcolor",
  "fancyhdr",
  "varwidth",
  "environ",
  "trimspaces"
)

cat("\nInstalling LaTeX packages...\n")

for (pkg in latex_packages) {
  cat(sprintf("  - %s... ", pkg))
  tryCatch({
    tinytex::tlmgr_install(pkg)
    cat("✓\n")
  }, error = function(e) {
    cat("⚠ (may already exist)\n")
  })
}

cat("\n✓ LaTeX package installation complete!\n")
cat("\nYou can now generate PDF reports from the Shiny app.\n")
