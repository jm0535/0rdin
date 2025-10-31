# Test Suite: Statistical Tests
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Tests for PERMANOVA, ANOSIM, Mantel, and envfit

library(testthat)
library(vegan)

test_that("PERMANOVA (adonis2) works", {
  data(dune)
  data(dune.env)
  
  perm_result <- adonis2(dune ~ Management, data = dune.env, permutations = 99)
  
  expect_s3_class(perm_result, "anova")
  expect_true("Df" %in% names(perm_result))
  expect_true("R2" %in% names(perm_result))
  expect_true("Pr(>F)" %in% names(perm_result))
})

test_that("ANOSIM works", {
  data(dune)
  data(dune.env)
  
  dist_matrix <- vegdist(dune, method = "bray")
  anosim_result <- anosim(dist_matrix, dune.env$Management, permutations = 99)
  
  expect_s3_class(anosim_result, "anosim")
  expect_true("statistic" %in% names(anosim_result))
  expect_true("signif" %in% names(anosim_result))
  expect_true(anosim_result$statistic >= -1 && anosim_result$statistic <= 1)
})

test_that("Mantel test works", {
  data(dune)
  data(dune.env)
  
  # Create two distance matrices
  dist1 <- vegdist(dune, method = "bray")
  dist2 <- vegdist(dune.env[, c("A1", "Moisture")], method = "euclidean")
  
  mantel_result <- mantel(dist1, dist2, permutations = 99)
  
  expect_s3_class(mantel_result, "mantel")
  expect_true("statistic" %in% names(mantel_result))
  expect_true("signif" %in% names(mantel_result))
  expect_true(mantel_result$statistic >= -1 && mantel_result$statistic <= 1)
})

test_that("envfit works with ordination", {
  data(dune)
  data(dune.env)
  
  nmds_result <- metaMDS(dune, k = 2, trymax = 20, trace = 0)
  envfit_result <- envfit(nmds_result, dune.env[, c("A1", "Moisture")], permutations = 99)
  
  expect_s3_class(envfit_result, "envfit")
  expect_true("vectors" %in% names(envfit_result))
})

test_that("PERMANOVA handles multiple factors", {
  data(dune)
  data(dune.env)
  
  perm_result <- adonis2(dune ~ Management + Use, data = dune.env, permutations = 99)
  
  expect_true(nrow(perm_result) >= 2)
  expect_true(all(perm_result$R2 >= 0))
})

test_that("Statistical test p-values are valid", {
  data(dune)
  data(dune.env)
  
  dist_matrix <- vegdist(dune, method = "bray")
  anosim_result <- anosim(dist_matrix, dune.env$Management, permutations = 99)
  
  expect_true(anosim_result$signif >= 0)
  expect_true(anosim_result$signif <= 1)
})
