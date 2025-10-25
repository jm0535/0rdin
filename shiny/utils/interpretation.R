# Ördin - Statistical Interpretation Utilities
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Port from prototype/statistical-interpretation.js

library(shiny)

#' Interpret NMDS Stress Value (Clarke 1993)
#' 
#' @param stress Numeric, NMDS stress value
#' @return List with interpretation details
#' @export
interpretNMDSStress <- function(stress) {
  if (stress < 0.05) {
    list(
      level = "excellent",
      grade = "A+",
      message = "Excellent representation (stress < 0.05)",
      detail = "The ordination configuration is very reliable. Distances in the plot closely match the original dissimilarities between samples.",
      recommendation = "Results can be interpreted with high confidence.",
      color = "#2e8b57",
      citation = "Clarke, K.R. (1993). Non-parametric multivariate analyses..."
    )
  } else if (stress < 0.10) {
    list(
      level = "good",
      grade = "A",
      message = "Good representation (stress < 0.10)",
      detail = "The configuration is usable and provides a good representation of the community structure.",
      recommendation = "Interpretation is generally reliable for ecological conclusions.",
      color = "#2e8b57",
      citation = "Clarke, K.R. (1993)"
    )
  } else if (stress < 0.20) {
    list(
      level = "fair",
      grade = "B",
      message = "Fair representation (stress < 0.20)",
      detail = "The configuration should be used with caution. Some distortion of original distances is present.",
      recommendation = "Consider: (1) increasing dimensions (k), (2) trying different distance metric, or (3) checking for outliers.",
      color = "#d4a017",
      citation = "Clarke, K.R. (1993)"
    )
  } else {
    list(
      level = "poor",
      grade = "C",
      message = "Poor representation (stress ≥ 0.20)",
      detail = "The configuration may be misleading. Substantial distortion of original distances is present.",
      recommendation = "DO NOT interpret this ordination. Try: (1) increase k to 3+, (2) use different distance metric, (3) check for outliers/errors in data, (4) consider alternative ordination method (PCoA, CA).",
      color = "#ff6b6b",
      citation = "Clarke, K.R. (1993)"
    )
  }
}

#' Generate HTML for NMDS Stress Interpretation Box
#'
#' @param stress Numeric, NMDS stress value
#' @return HTML string
#' @export
generateStressInterpretationHTML <- function(stress) {
  interp <- interpretNMDSStress(stress)
  
  HTML(sprintf('
    <div style="background: %s20; border-left: 3px solid %s; padding: 16px; margin: 20px 0;">
      <h4 style="color: %s; margin: 0 0 8px 0; font-size: 14px;">
        %s [Grade: %s]
      </h4>
      <p style="color: #ccc; font-size: 12px; margin: 0 0 12px 0; line-height: 1.6;">
        %s
      </p>
      <p style="color: %s; font-size: 12px; margin: 0; line-height: 1.6; font-weight: 600;">
        📌 Recommendation: %s
      </p>
      <p style="color: #666; font-size: 10px; margin: 12px 0 0 0; font-style: italic;">
        Based on: %s
      </p>
    </div>
  ', interp$color, interp$color, interp$color, interp$message, interp$grade,
     interp$detail, interp$color, interp$recommendation, interp$citation))
}

#' Interpret PERMANOVA Results (Cohen 1988)
#'
#' @param pValue Numeric, p-value
#' @param rSquared Numeric, R² value
#' @return List with interpretation
#' @export
interpretPERMANOVA <- function(pValue, rSquared) {
  # Statistical significance
  if (pValue < 0.001) {
    significance <- list(
      text = "highly significant",
      stars = "***",
      color = "#2e8b57"
    )
  } else if (pValue < 0.01) {
    significance <- list(
      text = "very significant",
      stars = "**",
      color = "#2e8b57"
    )
  } else if (pValue < 0.05) {
    significance <- list(
      text = "significant",
      stars = "*",
      color = "#2e8b57"
    )
  } else if (pValue < 0.10) {
    significance <- list(
      text = "marginally significant",
      stars = "†",
      color = "#d4a017"
    )
  } else {
    significance <- list(
      text = "not significant",
      stars = "ns",
      color = "#888"
    )
  }
  
  # Effect size (Cohen 1988 adapted for ecology)
  if (rSquared < 0.01) {
    effectSize <- list(
      magnitude = "negligible",
      interpretation = "Very small effect. Groups barely differ.",
      color = "#888"
    )
  } else if (rSquared < 0.06) {
    effectSize <- list(
      magnitude = "small",
      interpretation = "Small but detectable effect. Ecological importance may be limited.",
      color = "#007acc"
    )
  } else if (rSquared < 0.14) {
    effectSize <- list(
      magnitude = "moderate",
      interpretation = "Moderate effect. Groups show meaningful differences in composition.",
      color = "#d4a017"
    )
  } else {
    effectSize <- list(
      magnitude = "large",
      interpretation = "Large effect. Groups are substantially different in composition.",
      color = "#2e8b57"
    )
  }
  
  varExplained <- round(rSquared * 100, 1)
  
  summary <- sprintf(
    "The effect is %s (p = %.3f%s) with a %s effect size (R² = %.3f, %.1f%% of variance explained).",
    significance$text, pValue, significance$stars, effectSize$magnitude, rSquared, varExplained
  )
  
  warning <- if (pValue < 0.05 && rSquared < 0.06) {
    "Note: Statistically significant but small effect size. Be cautious about biological/ecological importance."
  } else {
    NULL
  }
  
  list(
    significance = significance,
    effectSize = effectSize,
    summary = summary,
    ecological = effectSize$interpretation,
    warning = warning
  )
}

#' Generate HTML for PERMANOVA Interpretation
#'
#' @param pValue Numeric, p-value
#' @param rSquared Numeric, R² value
#' @return HTML string
#' @export
generatePERMANOVAInterpretationHTML <- function(pValue, rSquared) {
  interp <- interpretPERMANOVA(pValue, rSquared)
  
  html <- sprintf('
    <div style="background: #252526; border-left: 3px solid %s; padding: 16px; margin: 20px 0;">
      <h4 style="color: %s; margin: 0 0 8px 0; font-size: 14px;">
        📊 Interpretation
      </h4>
      <p style="color: #ccc; font-size: 12px; margin: 0 0 12px 0; line-height: 1.6;">
        %s
      </p>
      <p style="color: %s; font-size: 12px; margin: 0; line-height: 1.6;">
        <strong>Ecological meaning:</strong> %s
      </p>
  ', interp$effectSize$color, interp$significance$color, interp$summary,
     interp$effectSize$color, interp$ecological)
  
  if (!is.null(interp$warning)) {
    html <- paste0(html, sprintf('
      <div style="background: #d4a01720; border: 1px solid #d4a017; padding: 8px; margin-top: 12px;">
        <p style="color: #d4a017; font-size: 11px; margin: 0; line-height: 1.6;">
          ⚠️ %s
        </p>
      </div>
    ', interp$warning))
  }
  
  html <- paste0(html, '
      <p style="color: #666; font-size: 10px; margin: 12px 0 0 0; font-style: italic;">
        Effect size based on Cohen (1988) guidelines adapted for community ecology
      </p>
    </div>
  ')
  
  HTML(html)
}

#' Interpret R² (Variance Explained)
#'
#' @param rSquared Numeric, R² value (0-1)
#' @param context Character, analysis context
#' @return List with interpretation
#' @export
interpretRSquared <- function(rSquared, context = "constrained ordination") {
  percent <- round(rSquared * 100, 1)
  
  if (rSquared < 0.10) {
    list(
      quality = "weak",
      message = sprintf("Weak explanatory power (%.1f%%)", percent),
      detail = "Environmental variables explain little of the community variation. Most variation is unexplained.",
      color = "#888"
    )
  } else if (rSquared < 0.30) {
    list(
      quality = "moderate",
      message = sprintf("Moderate explanatory power (%.1f%%)", percent),
      detail = "Environmental variables explain a moderate portion of community variation. This is typical for ecological data.",
      color = "#007acc"
    )
  } else if (rSquared < 0.60) {
    list(
      quality = "good",
      message = sprintf("Good explanatory power (%.1f%%)", percent),
      detail = "Environmental variables explain a substantial portion of community variation.",
      color = "#2e8b57"
    )
  } else {
    list(
      quality = "excellent",
      message = sprintf("Excellent explanatory power (%.1f%%)", percent),
      detail = "Environmental variables explain most of the community variation. Unusually high for ecological data - verify results.",
      color = "#2e8b57"
    )
  }
}
