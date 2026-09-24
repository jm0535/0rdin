# Ördin Performance Utilities
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Performance optimization helpers: caching, debouncing, async operations

library(shiny)

#' Create Cached Reactive
#' 
#' Wraps a reactive expression with caching
#' @param expr Reactive expression
#' @param cache_key Unique cache identifier
#' @return Cached reactive
cached_reactive <- function(expr, cache_key = NULL) {
  if (is.null(cache_key)) {
    cache_key <- digest::digest(deparse(substitute(expr)))
  }
  
  reactive(expr) %>% bindCache(cache_key)
}

#' Debounced Input
#' 
#' Creates debounced version of reactive input
#' @param input_reactive Reactive input value
#' @param millis Milliseconds to wait
#' @return Debounced reactive
debounced_input <- function(input_reactive, millis = 1000) {
  debounce(input_reactive, millis)
}

#' Async Ordination
#'
#' Runs ordination asynchronously using promises + future.
#' Requires a concurrent future plan (see the `future::plan()` setup in
#' `shiny/app.R`); with the default sequential plan this would block the
#' Shiny session and defeat the purpose.
#' @param data Species data
#' @param method Ordination method
#' @param distance Distance metric (used by methods that support it)
#' @param k Number of dimensions (NMDS)
#' @param trymax NMDS restart limit
#' @param autotransform NMDS autotransform flag
#' @param trace NMDS trace level
#' @return Promise that resolves to the ordination result
async_ordination <- function(data, method = "nmds", distance = "bray", k = 2,
                             trymax = 20, autotransform = FALSE, trace = 0) {
  promises::future_promise(
    {
      switch(method,
        "nmds" = vegan::metaMDS(data,
          distance = distance, k = k, trymax = trymax,
          autotransform = autotransform, trace = trace
        ),
        "pca" = vegan::rda(data),
        "ca" = vegan::cca(data),
        "dca" = vegan::decorana(data),
        stop("Unknown method: ", method)
      )
    },
    # Explicit so workers load what they need regardless of global analysis
    packages = c("vegan"),
    # Reproducible random starts across sessions
    seed = TRUE
  )
}

#' Async PERMANOVA
#'
#' Runs adonis2() in a background R process so permutation tests never freeze
#' the Shiny session.
#' @param comm Species community matrix
#' @param env Environmental data frame (right-hand side of the formula)
#' @param permutations Number of permutations
#' @param distance Distance metric
#' @return Promise that resolves to an adonis2 result
async_permanova <- function(comm, env, permutations = 999, distance = "bray") {
  promises::future_promise(
    {
      vegan::adonis2(comm ~ ., data = env, permutations = permutations, method = distance)
    },
    packages = c("vegan"),
    seed = TRUE
  )
}

#' Batch Process Sites
#' 
#' Process large datasets in batches to avoid memory issues
#' @param data Full dataset
#' @param batch_size Number of sites per batch
#' @param process_fn Function to apply to each batch
#' @return Combined results
batch_process <- function(data, batch_size = 100, process_fn) {
  n_sites <- nrow(data)
  n_batches <- ceiling(n_sites / batch_size)
  
  results <- vector("list", n_batches)
  
  for (i in seq_len(n_batches)) {
    start_idx <- (i - 1) * batch_size + 1
    end_idx <- min(i * batch_size, n_sites)
    
    batch_data <- data[start_idx:end_idx, , drop = FALSE]
    results[[i]] <- process_fn(batch_data)
  }
  
  return(results)
}

#' Progress Bar Wrapper
#' 
#' Wraps long-running operations with progress indicator
#' @param n Total steps
#' @param expr Expression to evaluate with progress
#' @param session Shiny session
#' @return Result of expression
with_progress <- function(n, expr, session = getDefaultReactiveDomain()) {
  progress <- shiny::Progress$new(session = session)
  on.exit(progress$close())
  
  progress$set(message = "Processing...", value = 0)
  
  for (i in seq_len(n)) {
    progress$set(value = i/n, detail = sprintf("Step %d of %d", i, n))
    Sys.sleep(0.1)  # Simulate work
  }
  
  expr
}

#' Memoized Distance Matrix
#' 
#' Cache distance matrix calculations
distance_cache <- new.env()

get_distance_matrix <- function(data, method = "bray") {
  cache_key <- paste0(
    digest::digest(data),
    "_",
    method
  )
  
  if (exists(cache_key, envir = distance_cache)) {
    message("Using cached distance matrix")
    return(get(cache_key, envir = distance_cache))
  }
  
  message("Computing distance matrix")
  dist_matrix <- vegan::vegdist(data, method = method)
  
  assign(cache_key, dist_matrix, envir = distance_cache)
  
  return(dist_matrix)
}

#' Clear Distance Cache
clear_distance_cache <- function() {
  rm(list = ls(distance_cache), envir = distance_cache)
  gc()  # Garbage collection
}

#' Optimize Large Dataset
#' 
#' Reduce dataset size while preserving structure
#' @param data Large dataset
#' @param max_sites Maximum number of sites to keep
#' @param method Sampling method ("random", "stratified")
#' @return Reduced dataset
optimize_dataset <- function(data, max_sites = 500, method = "random") {
  if (nrow(data) <= max_sites) {
    return(data)
  }
  
  message(sprintf("Reducing dataset from %d to %d sites", nrow(data), max_sites))
  
  if (method == "random") {
    sampled_rows <- sample(nrow(data), max_sites)
    return(data[sampled_rows, , drop = FALSE])
  } else if (method == "stratified") {
    # Simple stratified sampling by total abundance
    total_abundance <- rowSums(data)
    strata <- cut(total_abundance, breaks = 5)
    
    sampled_rows <- c()
    sites_per_stratum <- max_sites / 5
    
    for (s in levels(strata)) {
      stratum_rows <- which(strata == s)
      n_sample <- min(length(stratum_rows), ceiling(sites_per_stratum))
      sampled_rows <- c(sampled_rows, sample(stratum_rows, n_sample))
    }
    
    return(data[sampled_rows, , drop = FALSE])
  }
}

#' Parallel NMDS
#' 
#' Run multiple NMDS with different starting configurations in parallel
#' @param data Species data
#' @param k Dimensions
#' @param n_tries Number of random starts
#' @return Best NMDS result
parallel_nmds <- function(data, k = 2, n_tries = 20) {
  if (requireNamespace("future", quietly = TRUE) &&
      requireNamespace("furrr", quietly = TRUE)) {

    # Switch to a parallel plan only for the duration of this call so the
    # app-wide plan configured in shiny/app.R is left untouched.
    old_plan <- future::plan()
    on.exit(future::plan(old_plan), add = TRUE)
    future::plan(future::multisession, workers = 4)

    results <- furrr::future_map(seq_len(n_tries), function(i) {
      vegan::metaMDS(data, k = k, trymax = 1, trace = 0)
    })
    
    # Select result with lowest stress
    stresses <- sapply(results, function(x) x$stress)
    best_idx <- which.min(stresses)
    
    return(results[[best_idx]])
  } else {
    # Fallback to sequential
    vegan::metaMDS(data, k = k, trymax = n_tries, trace = 0)
  }
}
