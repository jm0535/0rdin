# Ciliates Data Diagnostic Report
# ================================

library(dplyr)

cat("\n📊 CILIATES ABUNDANCE DATA ANALYSIS\n")
cat("=====================================\n\n")

# Load data
d <- read.csv('sample-data/ciliates-abundance.csv', row.names=1)

# Basic structure
cat("📐 DATA STRUCTURE:\n")
cat("  Sites (rows):     ", nrow(d), "\n")
cat("  Species (columns):", ncol(d), "\n\n")

# Transpose for iNEXT format (sites as columns)
d_t <- t(d)

# Calculate key metrics
cat("📊 ABUNDANCE METRICS:\n")
site_totals <- colSums(d_t)
for (i in 1:length(site_totals)) {
  cat(sprintf("  %-25s: %5d individuals\n", names(site_totals)[i], site_totals[i]))
}
cat("\n")

# Species metrics
species_present <- sum(rowSums(d_t) > 0)
cat("🐛 SPECIES METRICS:\n")
cat("  Total species columns:   ", nrow(d_t), "\n")
cat("  Species with >0 indiv:   ", species_present, "\n")
cat("  Empty species (all 0s):  ", sum(rowSums(d_t) == 0), "\n\n")

# Data sparsity
total_cells <- nrow(d_t) * ncol(d_t)
zero_cells <- sum(d_t == 0)
sparsity_pct <- (zero_cells / total_cells) * 100

cat("🔍 DATA QUALITY:\n")
cat(sprintf("  Total data cells:        %d\n", total_cells))
cat(sprintf("  Cells with zeros:        %d (%.1f%%)\n", zero_cells, sparsity_pct))
cat(sprintf("  Cells with data:         %d (%.1f%%)\n", total_cells - zero_cells, 100 - sparsity_pct))
cat("\n")

# Richness per site
cat("🌿 RICHNESS PER SITE:\n")
for (i in 1:ncol(d_t)) {
  richness <- sum(d_t[, i] > 0)
  cat(sprintf("  %-25s: %4d species\n", colnames(d_t)[i], richness))
}
cat("\n")

# Assessment
cat("⚠️  DATA QUALITY ASSESSMENT:\n")
if (min(site_totals) < 5) {
  cat("  ❌ FAIL: Insufficient sample size (min = ", min(site_totals), ", need ≥5)\n")
} else {
  cat("  ✅ PASS: Sample size adequate (min = ", min(site_totals), ")\n")
}

if (species_present < 3) {
  cat("  ❌ FAIL: Too few species (", species_present, ", need ≥3)\n")
} else {
  cat("  ✅ PASS: Species richness adequate (", species_present, ")\n")
}

if (sparsity_pct >= 99.9) {
  cat(sprintf("  ❌ FAIL: Data too sparse (%.1f%% zeros, need <99.9%%)\n", sparsity_pct))
} else {
  cat(sprintf("  ✅ PASS: Data sparsity acceptable (%.1f%% zeros)\n", sparsity_pct))
}

cat("\n")

# Recommendations
cat("💡 RECOMMENDATIONS:\n")
cat("  1. Filter out rare species (e.g., species with <2 occurrences)\n")
cat("  2. Consider pooling similar habitats to increase sample sizes\n")
cat("  3. This dataset may be better suited for presence/absence analysis\n")
cat("  4. Reduce computational load: lower knots (20-30) and nboot (20-30)\n")
cat("\n")

# Try iNEXT to see exact error
cat("🧪 TESTING iNEXT:\n")
library(iNEXT)

tryCatch({
  result <- iNEXT(d_t, q=c(0), datatype="abundance", knots=20, nboot=20)
  cat("  ✅ SUCCESS: iNEXT ran successfully!\n")
  cat("  Plot data rows:", nrow(result$iNextEst$size_based), "\n")
}, error = function(e) {
  cat("  ❌ ERROR:", e$message, "\n")
})
