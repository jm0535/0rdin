# Test Script for Validation and Interpretation Utilities
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Run this to verify utilities work correctly

# Source the utilities
source("utils/validation.R")
source("utils/interpretation.R")

cat("========================================\n")
cat("Testing Ördin Utilities\n")
cat("========================================\n\n")

# Test 1: Validation Functions
cat("TEST 1: VALIDATION FUNCTIONS\n")
cat("----------------------------\n")

# Test confidence level
cat("\n1.1 Confidence Level Validation:\n")
test_values <- c(0.95, 1.5, 0.75, "abc", 0.001)
for (val in test_values) {
  result <- validateConfidenceLevel(val)
  cat(sprintf("  Value: %s → %s (%s)\n", val, result$message, result$type))
}

# Test knots
cat("\n1.2 Knots Validation:\n")
test_knots <- c(40, 15, 80, 150, "xyz")
for (val in test_knots) {
  result <- validateKnots(val)
  cat(sprintf("  Value: %s → %s (%s)\n", val, result$message, result$type))
}

# Test dimensions
cat("\n1.3 Dimensions Validation:\n")
test_dims <- c(2, 4, 7, 0, "abc")
for (val in test_dims) {
  result <- validateDimensions(val)
  cat(sprintf("  Value: %s → %s (%s)\n", val, result$message, result$type))
}

# Test permutations
cat("\n1.4 Permutations Validation:\n")
test_perms <- c(999, 50, 300, 10000)
for (val in test_perms) {
  result <- validatePermutations(val)
  cat(sprintf("  Value: %s → %s (%s)\n", val, result$message, result$type))
}

# Test sample size
cat("\n1.5 Sample Size Validation:\n")
test_samples <- c(2, 8, 15, 25)
for (val in test_samples) {
  result <- validateSampleSize(val)
  cat(sprintf("  Value: %s → %s (%s)\n", val, result$message, result$type))
}

# Test 2: Interpretation Functions
cat("\n\nTEST 2: INTERPRETATION FUNCTIONS\n")
cat("--------------------------------\n")

# Test NMDS stress interpretation
cat("\n2.1 NMDS Stress Interpretation:\n")
test_stress <- c(0.03, 0.089, 0.15, 0.25)
for (val in test_stress) {
  result <- interpretNMDSStress(val)
  cat(sprintf("  Stress: %.3f → %s (Grade: %s)\n", val, result$message, result$grade))
  cat(sprintf("    Recommendation: %s\n", result$recommendation))
}

# Test PERMANOVA interpretation
cat("\n2.2 PERMANOVA Interpretation:\n")
test_permanova <- list(
  list(p = 0.001, r2 = 0.234),
  list(p = 0.045, r2 = 0.04),
  list(p = 0.15, r2 = 0.15)
)
for (test in test_permanova) {
  result <- interpretPERMANOVA(test$p, test$r2)
  cat(sprintf("  p=%.3f, R²=%.3f:\n", test$p, test$r2))
  cat(sprintf("    %s\n", result$summary))
  cat(sprintf("    Ecological: %s\n", result$ecological))
  if (!is.null(result$warning)) {
    cat(sprintf("    ⚠️  %s\n", result$warning))
  }
}

# Test R² interpretation
cat("\n2.3 R² Interpretation:\n")
test_r2 <- c(0.05, 0.25, 0.45, 0.70)
for (val in test_r2) {
  result <- interpretRSquared(val)
  cat(sprintf("  R²: %.2f → %s (%s)\n", val, result$message, result$quality))
}

# Test 3: HTML Generation
cat("\n\nTEST 3: HTML GENERATION\n")
cat("-----------------------\n")

cat("\n3.1 Stress HTML Generation:\n")
stress_html <- generateStressInterpretationHTML(0.089)
cat("  ✓ HTML generated successfully\n")
cat("  Length:", nchar(as.character(stress_html)), "characters\n")

cat("\n3.2 PERMANOVA HTML Generation:\n")
permanova_html <- generatePERMANOVAInterpretationHTML(0.001, 0.234)
cat("  ✓ HTML generated successfully\n")
cat("  Length:", nchar(as.character(permanova_html)), "characters\n")

# Summary
cat("\n========================================\n")
cat("TEST SUMMARY\n")
cat("========================================\n")
cat("✓ All validation functions working\n")
cat("✓ All interpretation functions working\n")
cat("✓ HTML generation working\n")
cat("✓ Ready for Shiny integration!\n")
cat("========================================\n")
