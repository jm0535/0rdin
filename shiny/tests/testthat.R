# Ördin Test Suite Entry Point
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Main test runner for the Ördin Shiny application

library(testthat)
library(shiny)

# Set test environment
Sys.setenv(TESTTHAT = "true")

# Run all tests
test_check("ordin")
