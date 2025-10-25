# Test PDF rendering with actual NMDS data
library(vegan)
library(rmarkdown)
library(knitr)
library(kableExtra)

# Source interpretation functions
source("utils/interpretation.R")

cat("\n=== Testing PDF Report Generation ===\n")

# Load sample data
data(dune)
cat("✓ Loaded dune dataset:", nrow(dune), "×", ncol(dune), "\n")

# Run NMDS
cat("\nRunning NMDS...\n")
nmds_result <- metaMDS(dune, distance = "bray", k = 2, trymax = 20, trace = FALSE)
cat("✓ NMDS complete. Stress =", nmds_result$stress, "\n")

# Get interpretation
stress_interp <- interpretNMDSStress(nmds_result$stress)
cat("✓ Stress interpretation:", stress_interp$grade, "\n")

# Prepare parameters
params <- list(
  nmds_result = nmds_result,
  distance = "bray",
  k = 2,
  permutations = 999,
  stress_interp = stress_interp,
  dataset_name = "Dune Meadow Vegetation",
  n_sites = nrow(dune),
  n_species = ncol(dune),
  trymax = 20,
  autotransform = FALSE,
  analysis_date = Sys.Date(),
  analysis_time = format(Sys.time(), "%H:%M:%S"),
  r_version = paste(R.version$major, R.version$minor, sep = "."),
  vegan_version = as.character(packageVersion("vegan")),
  ordin_version = "3.0"
)

cat("\n=== Checking PDF Dependencies ===\n")

# Check pandoc
if (pandoc_available()) {
  cat("✓ Pandoc available:", as.character(pandoc_version()), "\n")
} else {
  cat("✗ Pandoc NOT available\n")
  stop("Pandoc is required!")
}

# Check tinytex
if (tinytex::is_tinytex()) {
  cat("✓ TinyTeX installed\n")
} else {
  cat("✗ TinyTeX NOT installed\n")
  stop("TinyTeX is required!")
}

cat("\n=== Rendering PDF Report ===\n")

# Render
tryCatch({
  output_file <- file.path(getwd(), "test_nmds_report.pdf")
  
  render(
    input = "templates/nmds_report.Rmd",
    output_format = "pdf_document",
    output_file = output_file,
    params = params,
    envir = new.env(),
    quiet = FALSE
  )
  
  cat("\n✓✓✓ SUCCESS! PDF generated at:", output_file, "\n")
  cat("File size:", file.size(output_file), "bytes\n")
  
}, error = function(e) {
  cat("\n✗✗✗ ERROR! ✗✗✗\n")
  cat("Error message:", conditionMessage(e), "\n")
  cat("\nFull error:\n")
  print(e)
})
