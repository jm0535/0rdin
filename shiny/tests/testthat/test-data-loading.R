# Test Suite: Data Loading
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Tests for data import and validation functionality

library(testthat)
library(vegan)

test_that("Sample datasets load correctly", {
  # Test dune dataset
  data(dune)
  expect_true(is.data.frame(dune))
  expect_equal(nrow(dune), 20)
  expect_equal(ncol(dune), 30)
  expect_true(all(sapply(dune, is.numeric)))
  
  # Test dune.env
  data(dune.env)
  expect_true(is.data.frame(dune.env))
  expect_equal(nrow(dune.env), 20)
  
  # Test varespec
  data(varespec)
  expect_true(is.data.frame(varespec))
  expect_equal(nrow(varespec), 24)
  expect_equal(ncol(varespec), 44)
})

test_that("Data validation catches errors", {
  # Empty data
  expect_error(vegdist(data.frame()), "supply both 'x' and 'y' or a matrix-like 'x'")
  
  # Non-numeric data
  invalid_data <- data.frame(a = c("x", "y"), b = c("z", "w"))
  expect_error(vegdist(invalid_data))
  
  # Mismatched dimensions
  species <- data.frame(sp1 = 1:10, sp2 = 1:10)
  env <- data.frame(var1 = 1:5)
  expect_error(rda(species ~ var1, data = env))
})

test_that("Distance matrix calculations work", {
  data(dune)
  
  # Bray-Curtis
  dist_bray <- vegdist(dune, method = "bray")
  expect_s3_class(dist_bray, "dist")
  expect_equal(attr(dist_bray, "Size"), 20)
  
  # Euclidean
  dist_eucl <- vegdist(dune, method = "euclidean")
  expect_s3_class(dist_eucl, "dist")
  
  # Jaccard
  dist_jacc <- vegdist(dune, method = "jaccard")
  expect_s3_class(dist_jacc, "dist")
})

test_that("Environmental data compatibility", {
  data(dune)
  data(dune.env)
  
  # Check row alignment
  expect_equal(nrow(dune), nrow(dune.env))
  
  # Check for categorical variables
  categorical_vars <- sapply(dune.env, function(x) is.factor(x) || is.character(x))
  expect_true(any(categorical_vars))
  
  # Check for numeric variables
  numeric_vars <- sapply(dune.env, is.numeric)
  expect_true(any(numeric_vars))
})
