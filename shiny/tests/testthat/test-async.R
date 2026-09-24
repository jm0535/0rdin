# Test Suite: Asynchronous Analysis (promises + future)
# Covers shiny/R/performance.R: async_ordination() and async_permanova(),
# the machinery behind the non-blocking NMDS/PERMANOVA runs in
# shiny/modules/ordination_module.R.
#
# Strategy: force the SEQUENTIAL future plan so promise work executes inline
# when the test pumps the `later` event loop. This keeps tests single-process
# and deterministic while still exercising the real promise/future code path
# (app startup in shiny/app.R switches to multisession for real sessions).

library(testthat)
library(vegan)
library(promises)

source(test_path("..", "..", "..", "shiny", "R", "performance.R"), local = TRUE)

# Run the event loop until `done` becomes non-NULL (bounded wait)
pump_until <- function(done_fn, max_ticks = 400, sleep_s = 0.05) {
  for (i in seq_len(max_ticks)) {
    later::run_now()
    if (!is.null(done_fn())) return(invisible(TRUE))
    Sys.sleep(sleep_s)
  }
  invisible(FALSE)
}

test_that("async_ordination returns a promise that resolves to a metaMDS fit", {
  skip_if_not_installed("future")
  skip_if_not_installed("later")
  data(dune)
  future::plan(future::sequential)

  p <- async_ordination(dune, method = "nmds", distance = "bray", k = 2, trymax = 1)
  expect_s3_class(p, "promise")

  result <- NULL
  promises::then(p, function(r) {
    result <<- r
  })
  expect_true(pump_until(function() result))

  expect_s3_class(result, "metaMDS")
  expect_true(is.numeric(result$stress))
  expect_equal(ncol(result$points), 2)
})

test_that("async_permanova resolves to an adonis2 result", {
  skip_if_not_installed("future")
  skip_if_not_installed("later")
  data(dune)
  data(dune.env)
  future::plan(future::sequential)

  env <- dune.env[, c("Management", "Moisture"), drop = FALSE]
  p <- async_permanova(dune, env, permutations = 99)

  result <- NULL
  promises::then(p, function(r) {
    result <<- r
  })
  expect_true(pump_until(function() result))

  expect_s3_class(result, "adonis2")
  expect_true(all(c("Management", "Moisture") %in% rownames(result)))
})

test_that("async_ordination rejects on an unknown method", {
  skip_if_not_installed("future")
  skip_if_not_installed("later")
  data(dune)
  future::plan(future::sequential)

  p <- async_ordination(dune, method = "bogus")

  err <- NULL
  promises::then(
    p,
    onFulfilled = function(r) NULL,
    onRejected = function(e) {
      err <<- e
    }
  )
  expect_true(pump_until(function() err))

  expect_s3_class(err, "condition")
  expect_match(conditionMessage(err), "Unknown method")
})
