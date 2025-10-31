library(testthat)
library(shiny)
library(vegan)
library(iNEXT)

test_that("diversity analysis module handles iNEXT calculations correctly", {
  testServer(diversityAnalysisServer, {
    # Create test data
    test_data <- data.frame(
      Species = c("sp1", "sp2", "sp3"),
      Site1 = c(10, 5, 2),
      Site2 = c(8, 4, 1)
    )
    session$setInputs(
      analysisType = "inext",
      dataType = "abundance",
      knots = 40,
      bootstraps = 50
    )
    
    # Run analysis
    session$setInputs(runInext = 1)
    
    # Check results
    results <- isolate(results())
    expect_true(!is.null(results))
    expect_equal(results$type, "inext")
    expect_true(!is.null(results$plots$diversity))
  })
})

test_that("diversity indices are calculated correctly", {
  testServer(diversityAnalysisServer, {
    # Create test data
    test_data <- data.frame(
      Species = c("sp1", "sp2", "sp3"),
      Site1 = c(10, 5, 2),
      Site2 = c(8, 4, 1)
    )
    session$setInputs(
      analysisType = "indices",
      indices = c("shannon", "simpson")
    )
    
    # Run analysis
    session$setInputs(runIndices = 1)
    
    # Check results
    results <- isolate(results())
    expect_true(!is.null(results))
    expect_equal(results$type, "indices")
    expect_true(!is.null(results$data$shannon))
    expect_true(!is.null(results$data$simpson))
  })
})

test_that("error handling works for invalid data", {
  testServer(diversityAnalysisServer, {
    # Create invalid data
    invalid_data <- data.frame(
      Species = c("sp1", "sp2"),
      Site1 = c(-1, -2)  # Negative values are invalid
    )
    
    # Expect error notification for iNEXT
    session$setInputs(
      analysisType = "inext",
      dataType = "abundance"
    )
    expect_error(session$setInputs(runInext = 1))
    
    # Expect error notification for indices
    session$setInputs(
      analysisType = "indices",
      indices = c("shannon")
    )
    expect_error(session$setInputs(runIndices = 1))
  })
})
