library(testthat)
library(shiny)
library(vegan)

test_that("ordination module handles NMDS correctly", {
  testServer(ordinationServer, {
    # Create test data
    test_data <- data.frame(
      Species = c("sp1", "sp2", "sp3", "sp4"),
      Site1 = c(1, 0, 1, 0),
      Site2 = c(0, 1, 1, 1),
      Site3 = c(1, 1, 0, 0)
    )
    
    session$setInputs(
      method = "nmds",
      distance = "bray",
      transform = "none",
      dimensions = 2,
      scale = TRUE
    )
    
    # Run ordination
    session$setInputs(runOrdination = 1)
    
    # Check results
    ord <- isolate(ordination())
    expect_true(!is.null(ord))
    expect_equal(class(ord)[1], "metaMDS")
    expect_equal(ord$ndim, 2)
  })
})

test_that("ordination module handles PCA correctly", {
  testServer(ordinationServer, {
    # Create test data
    test_data <- data.frame(
      Species = c("sp1", "sp2", "sp3", "sp4"),
      Site1 = c(1, 0, 1, 0),
      Site2 = c(0, 1, 1, 1),
      Site3 = c(1, 1, 0, 0)
    )
    
    session$setInputs(
      method = "pca",
      transform = "hellinger",
      dimensions = 2,
      scale = TRUE
    )
    
    # Run ordination
    session$setInputs(runOrdination = 1)
    
    # Check results
    ord <- isolate(ordination())
    expect_true(!is.null(ord))
    expect_equal(class(ord)[1], "rda")
  })
})

test_that("data transformation works correctly", {
  testServer(ordinationServer, {
    # Create test function to access internal function
    test_transform <- function(data, method) {
      transformData(data, method)
    }
    
    # Test data
    test_data <- matrix(c(1, 2, 3, 4), ncol = 2)
    
    # Test different transformations
    expect_equal(test_transform(test_data, "none"), test_data)
    expect_equal(test_transform(test_data, "log"), log1p(test_data))
    expect_equal(test_transform(test_data, "sqrt"), sqrt(test_data))
  })
})

test_that("error handling works for invalid inputs", {
  testServer(ordinationServer, {
    # Create invalid data (all zeros)
    invalid_data <- data.frame(
      Species = c("sp1", "sp2"),
      Site1 = c(0, 0),
      Site2 = c(0, 0)
    )
    
    session$setInputs(
      method = "nmds",
      distance = "bray"
    )
    
    # Expect error notification
    expect_error(session$setInputs(runOrdination = 1))
  })
})
