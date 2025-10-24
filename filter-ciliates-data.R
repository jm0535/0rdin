# Ördin Data Filter Script
# =========================
# Use this to properly filter ciliates data for incidence_raw analysis
# 
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Date: 2025-10-23

cat("\n=== ÖRDIN DATA FILTER FOR CILIATES ===\n\n")

# Input/Output files
input_file <- "sample-data/ciliates-abundance.csv"
output_file <- "sample-data/ciliates-filtered.csv"

# Load data
cat("Loading data from:", input_file, "\n")
d <- read.csv(input_file, row.names = 1)

cat("\n--- ORIGINAL DATA ---\n")
cat("Sites (rows):", nrow(d), "\n")
cat("Species (columns):", ncol(d), "\n")
cat("Total cells:", nrow(d) * ncol(d), "\n")

# Check if binary
is_binary <- all(d %in% c(0, 1))
cat("Is binary (0/1):", is_binary, "\n")

# Calculate sparsity
zero_cells <- sum(d == 0)
sparsity_pct <- (zero_cells / (nrow(d) * ncol(d))) * 100
cat("Zero cells:", zero_cells, "\n")
cat("Sparsity:", round(sparsity_pct, 1), "%\n")

# Check occurrences per site (row sums)
row_totals <- rowSums(d)
cat("\nOccurrences per site:\n")
for (i in 1:nrow(d)) {
  cat("  ", rownames(d)[i], ":", row_totals[i], "\n")
}
cat("Min occurrences:", min(row_totals), "\n")

# Check species presence
species_present <- colSums(d) > 0
num_present <- sum(species_present)
cat("\nSpecies with ≥1 occurrence:", num_present, "out of", ncol(d), "\n")
cat("Empty species (all 0s):", ncol(d) - num_present, "\n")

# ===== FILTERING STRATEGY =====

cat("\n--- APPLYING FILTERS ---\n")

# Filter 1: Remove species with all zeros
cat("\nFilter 1: Removing species with all zeros...\n")
d_step1 <- d[, colSums(d) > 0]
cat("  Species remaining:", ncol(d_step1), "\n")

# Filter 2: Keep species present in at least 2 sites
cat("\nFilter 2: Keeping species in ≥2 sites...\n")
species_in_multiple_sites <- colSums(d_step1 > 0) >= 2
d_step2 <- d_step1[, species_in_multiple_sites]
cat("  Species remaining:", ncol(d_step2), "\n")

# Optional Filter 3: If still too many, keep top N most common
MAX_SPECIES <- 150  # Adjust as needed
if (ncol(d_step2) > MAX_SPECIES) {
  cat("\nFilter 3: Keeping top", MAX_SPECIES, "most common species...\n")
  species_totals <- colSums(d_step2)
  top_indices <- order(species_totals, decreasing = TRUE)[1:MAX_SPECIES]
  d_filtered <- d_step2[, top_indices]
  cat("  Species remaining:", ncol(d_filtered), "\n")
} else {
  d_filtered <- d_step2
  cat("\nFilter 3: Skipped (already <", MAX_SPECIES, "species)\n")
}

# ===== FINAL DATA SUMMARY =====

cat("\n--- FILTERED DATA ---\n")
cat("Sites (rows):", nrow(d_filtered), "\n")
cat("Species (columns):", ncol(d_filtered), "\n")

# Recalculate stats
final_row_totals <- rowSums(d_filtered)
cat("\nOccurrences per site:\n")
for (i in 1:nrow(d_filtered)) {
  cat("  ", rownames(d_filtered)[i], ":", final_row_totals[i], "\n")
}
cat("Min occurrences:", min(final_row_totals), "\n")

final_zero_cells <- sum(d_filtered == 0)
final_sparsity <- (final_zero_cells / (nrow(d_filtered) * ncol(d_filtered))) * 100
cat("\nFinal sparsity:", round(final_sparsity, 1), "%\n")

final_species_present <- sum(colSums(d_filtered) > 0)
cat("Species with ≥1 occurrence:", final_species_present, "\n")

# ===== VALIDATION CHECK =====

cat("\n--- VALIDATION FOR iNEXT ---\n")

# Check 1: Min occurrences per site
min_req <- 3  # For incidence_raw
if (min(final_row_totals) >= min_req) {
  cat("✓ Min occurrences:", min(final_row_totals), "≥", min_req, "(PASS)\n")
} else {
  cat("✗ Min occurrences:", min(final_row_totals), "<", min_req, "(FAIL)\n")
  cat("  → Need to combine sites or add more data\n")
}

# Check 2: Species diversity
if (final_species_present >= 3) {
  cat("✓ Species present:", final_species_present, "≥ 3 (PASS)\n")
} else {
  cat("✗ Species present:", final_species_present, "< 3 (FAIL)\n")
  cat("  → Data too sparse, need more species\n")
}

# Check 3: Sparsity
if (final_sparsity < 90) {
  cat("✓ Sparsity:", round(final_sparsity, 1), "% < 90% (GOOD)\n")
} else if (final_sparsity < 95) {
  cat("⚠ Sparsity:", round(final_sparsity, 1), "% (BORDERLINE)\n")
  cat("  → May work, but might be slow or unreliable\n")
} else {
  cat("✗ Sparsity:", round(final_sparsity, 1), "% > 95% (TOO SPARSE)\n")
  cat("  → Filter more aggressively or combine sites\n")
}

# ===== SAVE FILTERED DATA =====

cat("\n--- SAVING FILTERED DATA ---\n")

# Ensure output directory exists
output_dir <- dirname(output_file)
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Save
write.csv(d_filtered, output_file, row.names = TRUE)
cat("Saved to:", output_file, "\n")

cat("\n=== FILTERING COMPLETE ===\n")
cat("\nNext steps:\n")
cat("1. Load", output_file, "in Ördin\n")
cat("2. Select 'Incidence_raw - Presence/absence (0/1)'\n")
cat("3. Click 'Run Analysis'\n")
cat("4. Check diagnostics in R console\n\n")

# ===== OPTIONAL: SHOW SAMPLE OF DATA =====

cat("--- SAMPLE OF FILTERED DATA (first 5 species) ---\n")
print(d_filtered[, 1:min(5, ncol(d_filtered))])
cat("\n")
