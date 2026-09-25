# CI dependency installer for Ördin
# Installs the minimal R package set required to build/test the app.
# Mirrors shiny/DESCRIPTION (Imports + test Suggests).
# Used by .github/workflows/test.yml and test-r.yml.

pkgs <- c(
  # Core app (shiny/DESCRIPTION Imports)
  "shiny", "vegan", "iNEXT", "ggplot2", "DT", "shinyjs", "waiter",
  "shinyFeedback", "readr", "readxl", "dplyr", "tidyr", "yaml", "digest",
  "jsonlite", "R6", "promises", "future", "rmarkdown", "knitr",
  "ape", "picante", "betapart", "patchwork",
  # Testing / async test harness
  "testthat", "later"
)

missing <- pkgs[!vapply(pkgs, requireNamespace, quietly = TRUE, logical(1))]
if (length(missing) > 0) {
  cat("Installing", length(missing), "missing package(s):", paste(missing, collapse = ", "), "\n")
  install.packages(missing, Ncpus = max(1L, parallel::detectCores() - 1L))
}

still_missing <- pkgs[!vapply(pkgs, requireNamespace, quietly = TRUE, logical(1))]
if (length(still_missing) > 0) {
  stop("Failed to install: ", paste(still_missing, collapse = ", "))
}
cat("All", length(pkgs), "CI packages available\n")
