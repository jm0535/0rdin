# Ördin Global Error Handler
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Centralized error handling and logging system

library(shiny)

#' Global Error Handler
#' 
#' Wraps analysis functions with consistent error handling
#' @param expr Expression to evaluate
#' @param context String describing the operation context
#' @param session Shiny session object for notifications
#' @return Result of expression or NULL on error
safe_execute <- function(expr, context = "Analysis", session = NULL) {
  tryCatch(
    {
      result <- expr
      
      # Log success
      log_info(paste(context, "completed successfully"))
      
      # Show success notification if session provided
      if (!is.null(session)) {
        showNotification(
          paste0("✓ ", context, " complete!"),
          type = "message",
          duration = 3000,
          session = session
        )
      }
      
      return(result)
    },
    error = function(e) {
      # Log error
      log_error(paste(context, "failed:", e$message))
      
      # Show user-friendly error
      if (!is.null(session)) {
        error_message <- format_error_message(e, context)
        showNotification(
          error_message,
          type = "error",
          duration = 10000,
          session = session
        )
      }
      
      return(NULL)
    },
    warning = function(w) {
      # Log warning
      log_warning(paste(context, "warning:", w$message))
      
      # Show warning notification
      if (!is.null(session)) {
        showNotification(
          paste0("⚠️ Warning: ", w$message),
          type = "warning",
          duration = 5000,
          session = session
        )
      }
      
      # Continue execution
      suppressWarnings(expr)
    }
  )
}

#' Format Error Message
#' 
#' Converts technical errors to user-friendly messages
#' @param error Error object
#' @param context Context string
#' @return Formatted HTML error message
format_error_message <- function(error, context) {
  error_msg <- as.character(error$message)
  
  # Common error patterns and solutions
  solutions <- list(
    "supply both 'x' and 'y'" = "Please check your data format. Species data must be a numeric matrix.",
    "matrix-like" = "Data must be in matrix format with numeric values.",
    "non-numeric" = "All species abundances must be numeric values.",
    "missing values" = "Your data contains missing values (NA). Please clean your data.",
    "identical sites" = "Some sites have identical species composition. Consider removing duplicates.",
    "singular" = "The data matrix is singular (no variation). Check for constant columns.",
    "dimension" = "Species and environmental data have mismatched dimensions. Ensure same number of sites.",
    "No categorical" = "No grouping variables found. PERMANOVA/ANOSIM require categorical factors.",
    "convergence" = "NMDS did not converge. Try increasing 'trymax' or using different starting configuration."
  )
  
  # Find matching solution
  solution <- NULL
  for (pattern in names(solutions)) {
    if (grepl(pattern, error_msg, ignore.case = TRUE)) {
      solution <- solutions[[pattern]]
      break
    }
  }
  
  # Build HTML message
  if (!is.null(solution)) {
    HTML(sprintf(
      "<strong>%s Failed</strong><br/>
      <span style='color: #e74c3c;'>%s</span><br/>
      <span style='color: #d4a017;'>💡 Solution: %s</span>",
      context,
      error_msg,
      solution
    ))
  } else {
    HTML(sprintf(
      "<strong>%s Failed</strong><br/>
      <span style='color: #e74c3c;'>%s</span>",
      context,
      error_msg
    ))
  }
}

#' Validate Species Data
#' 
#' Checks if species data is valid for analysis
#' @param data Species abundance data frame
#' @return List with 'valid' (logical) and 'message' (string)
validate_species_data <- function(data) {
  if (is.null(data)) {
    return(list(valid = FALSE, message = "No data loaded"))
  }
  
  if (!is.data.frame(data) && !is.matrix(data)) {
    return(list(valid = FALSE, message = "Data must be a data frame or matrix"))
  }
  
  if (nrow(data) < 3) {
    return(list(valid = FALSE, message = "Minimum 3 sites required"))
  }
  
  if (ncol(data) < 2) {
    return(list(valid = FALSE, message = "Minimum 2 species required"))
  }
  
  if (!all(sapply(data, is.numeric))) {
    return(list(valid = FALSE, message = "All columns must be numeric"))
  }
  
  if (any(is.na(data))) {
    return(list(valid = FALSE, message = "Data contains missing values (NA)"))
  }
  
  if (any(data < 0)) {
    return(list(valid = FALSE, message = "Negative abundances not allowed"))
  }
  
  return(list(valid = TRUE, message = "Data is valid"))
}

#' Validate Environmental Data
#' 
#' Checks if environmental data is compatible
#' @param species_data Species data
#' @param env_data Environmental data
#' @return List with 'valid' and 'message'
validate_env_data <- function(species_data, env_data) {
  if (is.null(env_data)) {
    return(list(valid = FALSE, message = "No environmental data loaded"))
  }
  
  if (nrow(species_data) != nrow(env_data)) {
    return(list(valid = FALSE, message = sprintf(
      "Row mismatch: species (%d sites) vs environment (%d sites)",
      nrow(species_data), nrow(env_data)
    )))
  }
  
  return(list(valid = TRUE, message = "Environmental data compatible"))
}

#' Logging Functions
log_info <- function(message) {
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  cat(sprintf("[INFO] %s: %s\n", timestamp, message))
}

log_warning <- function(message) {
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  cat(sprintf("[WARNING] %s: %s\n", timestamp, message))
}

log_error <- function(message) {
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  cat(sprintf("[ERROR] %s: %s\n", timestamp, message))
}

#' Show Loading Spinner
show_loading <- function(message = "Processing...") {
  waiter::waiter_show(
    html = tagList(
      waiter::spin_fading_circles(),
      h3(message, style = "color: #2e8b57; margin-top: 20px;")
    ),
    color = "rgba(0,0,0,0.8)"
  )
}

#' Hide Loading Spinner
hide_loading <- function() {
  waiter::waiter_hide()
}
