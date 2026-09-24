# Ördin Test Suite Entry Point
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Runs the shiny/tests/testthat suite WITHOUT installing the app as a package
# (the previous test_check("ordin") call required a built package that this
# repo does not produce).
#
# Usage (from any working directory):
#   Rscript shiny/tests/testthat.R
# CI (.github/workflows/test-r.yml) calls testthat::test_dir() directly.

library(testthat)
library(shiny)

Sys.setenv(TESTTHAT = "true")

# Resolve the testthat directory relative to THIS script's location
script_arg <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
if (length(script_arg) > 0) {
  script_dir <- dirname(normalizePath(sub("^--file=", "", script_arg[1])))
  test_dir(file.path(script_dir, "testthat"), stop_on_failure = TRUE)
} else {
  # Interactive fallback (e.g. RStudio "Run in terminal"): assume shiny/tests
  test_dir("testthat", stop_on_failure = TRUE)
}
