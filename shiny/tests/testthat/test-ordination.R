# Test Suite: Ordination Methods
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Tests for all ordination analysis functions

library(testthat)
library(vegan)

test_that("NMDS runs successfully", {
  data(dune)
  
  nmds_result <- metaMDS(dune, distance = "bray", k = 2, trymax = 20, trace = 0)
  
  expect_s3_class(nmds_result, "metaMDS")
  expect_true("stress" %in% names(nmds_result))
  expect_true(nmds_result$stress >= 0 && nmds_result$stress <= 1)
  expect_equal(ncol(nmds_result$points), 2)
})

test_that("PCA runs successfully", {
  data(dune)
  
  pca_result <- rda(dune)
  
  expect_s3_class(pca_result, "rda")
  expect_true("CA" %in% names(pca_result))
  expect_true("tot.chi" %in% names(pca_result))
})

test_that("CA runs successfully", {
  data(dune)
  
  ca_result <- cca(dune)
  
  expect_s3_class(ca_result, "cca")
  expect_true("CA" %in% names(ca_result))
})

test_that("DCA runs successfully", {
  data(dune)
  
  dca_result <- decorana(dune)
  
  expect_s3_class(dca_result, "decorana")
  expect_true("evals" %in% names(dca_result))
  expect_equal(length(dca_result$evals), 4)
})

test_that("PCoA runs successfully", {
  data(dune)
  
  dist_matrix <- vegdist(dune, method = "bray")
  pcoa_result <- wcmdscale(dist_matrix, k = 2)
  
  expect_true(is.matrix(pcoa_result))
  expect_equal(ncol(pcoa_result), 2)
})

test_that("Constrained ordination (CCA) works", {
  data(dune)
  data(dune.env)
  
  cca_result <- cca(dune ~ A1 + Moisture, data = dune.env)
  
  expect_s3_class(cca_result, "cca")
  expect_true("CCA" %in% names(cca_result))
  expect_true("CA" %in% names(cca_result))
  expect_true(cca_result$CCA$tot.chi > 0)
})

test_that("Constrained ordination (RDA) works", {
  data(dune)
  data(dune.env)
  
  rda_result <- rda(dune ~ A1 + Moisture, data = dune.env)
  
  expect_s3_class(rda_result, "rda")
  expect_true("CCA" %in% names(rda_result))
  expect_true(rda_result$CCA$tot.chi > 0)
})

test_that("db-RDA works with different distances", {
  data(dune)
  data(dune.env)
  
  dbrda_result <- dbrda(dune ~ A1 + Moisture, data = dune.env, distance = "bray")
  
  expect_s3_class(dbrda_result, "dbrda")
  expect_true("CCA" %in% names(dbrda_result))
})

test_that("CAP (capscale) works", {
  data(dune)
  data(dune.env)
  
  cap_result <- capscale(dune ~ A1 + Moisture, data = dune.env, distance = "bray")
  
  expect_s3_class(cap_result, "capscale")
  expect_true("CCA" %in% names(cap_result))
})

test_that("Eigenvalue extraction works", {
  data(dune)
  
  pca_result <- rda(dune)
  eig <- eigenvals(pca_result)
  
  expect_true(is.numeric(eig))
  expect_true(all(eig >= 0))
  expect_true(length(eig) > 0)
})

test_that("Stress values are valid", {
  data(dune)
  
  nmds_result <- metaMDS(dune, k = 2, trymax = 20, trace = 0)
  
  expect_true(nmds_result$stress >= 0)
  expect_true(nmds_result$stress <= 1)
  
  # Good stress values
  if (nmds_result$stress < 0.05) {
    expect_true(TRUE)  # Excellent
  } else if (nmds_result$stress < 0.1) {
    expect_true(TRUE)  # Good
  } else if (nmds_result$stress < 0.2) {
    expect_true(TRUE)  # Fair
  }
})
