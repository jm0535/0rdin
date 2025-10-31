# Ördin - Input Validation Utilities  
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Port from prototype/validation.js

#' Validate Confidence Level
#'
#' @param value Numeric or character, user input
#' @return List with valid (logical), message (character), value (numeric or NULL)
#' @export
validateConfidenceLevel <- function(value) {
  parsed <- suppressWarnings(as.numeric(value))
  
  if (is.na(parsed)) {
    return(list(
      valid = FALSE,
      message = "❌ Confidence level must be numeric",
      value = NULL,
      type = "error"
    ))
  }
  
  if (parsed < 0 || parsed > 1) {
    return(list(
      valid = FALSE,
      message = "❌ Confidence level must be between 0 and 1",
      value = NULL,
      type = "error"
    ))
  }
  
  if (parsed < 0.5 || parsed > 0.999) {
    return(list(
      valid = TRUE,
      message = "⚠️ Typical range is 0.90-0.99. Are you sure?",
      value = parsed,
      type = "warning"
    ))
  }
  
  list(
    valid = TRUE,
    message = "✓ Valid confidence level",
    value = parsed,
    type = "success"
  )
}

#' Validate Number of Knots
#'
#' @param value Numeric or character, user input
#' @return List with validation result
#' @export
validateKnots <- function(value) {
  parsed <- suppressWarnings(as.integer(value))
  
  if (is.na(parsed)) {
    return(list(
      valid = FALSE,
      message = "❌ Knots must be an integer",
      value = NULL,
      type = "error"
    ))
  }
  
  if (parsed < 10 || parsed > 100) {
    return(list(
      valid = FALSE,
      message = "❌ Knots must be between 10 and 100",
      value = NULL,
      type = "error"
    ))
  }
  
  if (parsed < 20) {
    return(list(
      valid = TRUE,
      message = "⚠️ Knots < 20 may produce jagged curves",
      value = parsed,
      type = "warning"
    ))
  }
  
  if (parsed > 60) {
    return(list(
      valid = TRUE,
      message = "⚠️ Knots > 60 may cause overfitting",
      value = parsed,
      type = "warning"
    ))
  }
  
  list(
    valid = TRUE,
    message = "✓ Valid knots value",
    value = parsed,
    type = "success"
  )
}

#' Validate NMDS Dimensions
#'
#' @param value Numeric or character, user input
#' @return List with validation result
#' @export
validateDimensions <- function(value) {
  parsed <- suppressWarnings(as.integer(value))
  
  if (is.na(parsed)) {
    return(list(
      valid = FALSE,
      message = "❌ Dimensions must be an integer",
      value = NULL,
      type = "error"
    ))
  }
  
  if (parsed < 1 || parsed > 6) {
    return(list(
      valid = FALSE,
      message = "❌ Dimensions must be between 1 and 6",
      value = NULL,
      type = "error"
    ))
  }
  
  if (parsed > 3) {
    return(list(
      valid = TRUE,
      message = "ℹ️ Dimensions > 3 are hard to visualize",
      value = parsed,
      type = "info"
    ))
  }
  
  list(
    valid = TRUE,
    message = "✓ Valid dimensions",
    value = parsed,
    type = "success"
  )
}

#' Validate Number of Permutations
#'
#' @param value Numeric or character, user input
#' @return List with validation result
#' @export
validatePermutations <- function(value) {
  parsed <- suppressWarnings(as.integer(value))
  
  if (is.na(parsed)) {
    return(list(
      valid = FALSE,
      message = "❌ Permutations must be an integer",
      value = NULL,
      type = "error"
    ))
  }
  
  if (parsed < 99 || parsed > 9999) {
    return(list(
      valid = FALSE,
      message = "❌ Permutations must be between 99 and 9999",
      value = NULL,
      type = "error"
    ))
  }
  
  if (parsed < 499) {
    return(list(
      valid = TRUE,
      message = "⚠️ Permutations < 499 may lack precision. Recommend 999+",
      value = parsed,
      type = "warning"
    ))
  }
  
  list(
    valid = TRUE,
    message = "✓ Valid permutations",
    value = parsed,
    type = "success"
  )
}

#' Validate Sample Size Adequacy
#'
#' @param sampleSize Numeric, number of samples
#' @return List with validation result
#' @export
validateSampleSize <- function(sampleSize) {
  if (sampleSize < 3) {
    return(list(
      valid = FALSE,
      message = "❌ At least 3 samples required for statistical analysis",
      value = sampleSize,
      type = "error"
    ))
  }
  
  if (sampleSize < 10) {
    return(list(
      valid = TRUE,
      message = "⚠️ Sample size < 10 may limit statistical power. Consider collecting more samples or using bootstrap methods.",
      value = sampleSize,
      type = "warning"
    ))
  }
  
  if (sampleSize < 20) {
    return(list(
      valid = TRUE,
      message = "ℹ️ Sample size is adequate. Larger samples (20+) improve reliability.",
      value = sampleSize,
      type = "info"
    ))
  }
  
  list(
    valid = TRUE,
    message = "✓ Sample size is good",
    value = sampleSize,
    type = "success"
  )
}

#' Show Validation Feedback in Shiny
#'
#' @param session Shiny session
#' @param inputId Input ID
#' @param validation Validation result list
#' @export
showValidationFeedback <- function(session, inputId, validation) {
  if (!validation$valid) {
    shinyFeedback::feedbackDanger(inputId, show = TRUE, text = validation$message)
  } else if (validation$type == "warning") {
    shinyFeedback::feedbackWarning(inputId, show = TRUE, text = validation$message)
  } else if (validation$type == "info") {
    shinyFeedback::feedbackInfo(inputId, show = TRUE, text = validation$message)
  } else {
    shinyFeedback::feedbackSuccess(inputId, show = TRUE, text = validation$message)
  }
}
