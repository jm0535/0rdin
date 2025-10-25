# Ördin NMDS Complete Test
# Tests full NMDS workflow including PDF generation

library(vegan)

cat("\n=== Testing NMDS Complete Workflow ===\n")

# Load sample data
data(dune)
cat("✓ Loaded dune dataset:", nrow(dune), "×", ncol(dune), "\n")

# Run NMDS
cat("\nRunning NMDS...\n")
nmds_result <- metaMDS(dune, distance = "bray", k = 2, trymax = 20, trace = FALSE)
cat("✓ NMDS complete. Stress =", nmds_result$stress, "\n")

# Source interpretation
source("utils/interpretation.R")
stress_interp <- interpretNMDSStress(nmds_result$stress)
cat("✓ Stress interpretation:", stress_interp$grade, "-", stress_interp$message, "\n")

# Source reproducibility
source("utils/reproducibility.R")
metadata <- captureAnalysisMetadata(
  dataset_name = "Dune Meadow Vegetation",
  n_sites = nrow(dune),
  n_species = ncol(dune),
  analysis_type = "NMDS Ordination",
  analysis_params = list(
    distance = "bray",
    k = 2,
    trymax = 20,
    autotransform = FALSE
  ),
  result = nmds_result
)
cat("✓ Metadata captured\n")

# Test PDF generation
cat("\n=== Testing PDF Generation ===\n")
if (rmarkdown::pandoc_available()) {
  cat("✓ Pandoc available:", as.character(rmarkdown::pandoc_version()), "\n")
  
  params <- getReportParameters(metadata, list(
    nmds_result = nmds_result,
    stress_interp = stress_interp,
    distance = "bray",
    k = 2,
    permutations = 999,
    trymax = 20,
    autotransform = FALSE
  ))
  
  tryCatch({
    rmarkdown::render(
      input = "templates/nmds_report.Rmd",
      output_format = "pdf_document",
      output_file = file.path(getwd(), "test_nmds_complete.pdf"),
      params = params,
      envir = new.env(),
      quiet = TRUE
    )
    cat("✓✓✓ PDF generated successfully!\n")
    cat("File:", file.path(getwd(), "test_nmds_complete.pdf"), "\n")
  }, error = function(e) {
    cat("✗ PDF generation failed:", conditionMessage(e), "\n")
  })
} else {
  cat("✗ Pandoc not available\n")
}

cat("\n=== Test Complete ===\n")
