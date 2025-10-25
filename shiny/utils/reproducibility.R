# Ördin - Reproducibility Utilities
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Standardized functions for capturing analysis metadata across all modules

#' Capture Analysis Metadata for Reproducibility
#'
#' This function captures comprehensive metadata about an analysis session
#' to ensure full reproducibility in PDF reports across all Ördin modules.
#'
#' @param dataset_name Character. Name of the dataset being analyzed
#' @param n_sites Integer. Number of sites/samples in the dataset
#' @param n_species Integer. Number of species/variables in the dataset
#' @param analysis_type Character. Type of analysis (e.g., "NMDS", "PCA", "Diversity Estimation")
#' @param analysis_params List. Analysis-specific parameters
#' @param result Object. The analysis result object
#'
#' @return List containing all metadata for reproducibility section
#' @export
#'
#' @examples
#' # For NMDS:
#' metadata <- captureAnalysisMetadata(
#'   dataset_name = "Community Data",
#'   n_sites = 20,
#'   n_species = 30,
#'   analysis_type = "NMDS Ordination",
#'   analysis_params = list(
#'     distance = "bray",
#'     k = 2,
#'     trymax = 20,
#'     autotransform = FALSE
#'   ),
#'   result = nmds_result
#' )
captureAnalysisMetadata <- function(dataset_name = "Community Data",
                                   n_sites = NULL,
                                   n_species = NULL,
                                   analysis_type = "Unknown",
                                   analysis_params = list(),
                                   result = NULL) {
  
  # Capture timestamp
  timestamp <- Sys.time()
  
  # Capture software versions
  software_info <- list(
    ordin_version = "3.0",
    r_version = paste(R.version$major, R.version$minor, sep = "."),
    r_version_string = R.version.string,
    platform = R.version$platform,
    os = Sys.info()["sysname"]
  )
  
  # Capture loaded package versions
  loaded_packages <- loadedNamespaces()
  key_packages <- c("vegan", "iNEXT", "ggplot2", "rmarkdown", "knitr")
  package_versions <- list()
  
  for (pkg in key_packages) {
    if (pkg %in% loaded_packages) {
      package_versions[[pkg]] <- as.character(packageVersion(pkg))
    }
  }
  
  # Build metadata list
  metadata <- list(
    # Dataset information
    dataset_name = dataset_name,
    n_sites = n_sites,
    n_species = n_species,
    
    # Analysis information
    analysis_type = analysis_type,
    analysis_date = as.Date(timestamp),
    analysis_time = format(timestamp, "%H:%M:%S %Z"),
    analysis_timestamp = timestamp,
    
    # Analysis-specific parameters
    params = analysis_params,
    
    # Analysis result (if provided)
    result = result,
    
    # Software environment
    software = software_info,
    packages = package_versions,
    
    # Session information
    locale = Sys.getlocale(),
    timezone = Sys.timezone()
  )
  
  class(metadata) <- c("ordin_metadata", "list")
  return(metadata)
}


#' Get Standard Report Parameters for Any Analysis
#'
#' Converts captured metadata into standardized parameters for RMarkdown reports.
#' This ensures all Ördin reports have consistent reproducibility sections.
#'
#' @param metadata List. Output from captureAnalysisMetadata()
#' @param analysis_specific List. Additional analysis-specific parameters
#'
#' @return List formatted for rmarkdown::render(params = ...)
#' @export
getReportParameters <- function(metadata, analysis_specific = list()) {
  
  # Merge metadata with analysis-specific parameters
  params <- c(
    # Standard reproducibility parameters (always included)
    list(
      dataset_name = metadata$dataset_name,
      n_sites = metadata$n_sites,
      n_species = metadata$n_species,
      analysis_type = metadata$analysis_type,
      analysis_date = metadata$analysis_date,
      analysis_time = metadata$analysis_time,
      r_version = metadata$software$r_version,
      ordin_version = metadata$software$ordin_version,
      platform = metadata$software$platform,
      os = metadata$software$os
    ),
    
    # Add package versions
    metadata$packages,
    
    # Analysis-specific parameters
    analysis_specific
  )
  
  return(params)
}


#' Generate Reproducibility Table for Reports
#'
#' Creates a formatted data frame for the reproducibility section of PDF reports.
#' Works with any analysis type.
#'
#' @param params List. Analysis parameters
#' @param param_descriptions List. Named list of parameter descriptions
#'
#' @return data.frame suitable for knitr::kable()
#' @export
generateReproducibilityTable <- function(params, param_descriptions = list()) {
  
  # Extract parameter names
  param_names <- names(params)
  
  # Build table
  repro_df <- data.frame(
    Parameter = character(),
    Value = character(),
    Description = character(),
    stringsAsFactors = FALSE
  )
  
  for (param_name in param_names) {
    param_value <- params[[param_name]]
    
    # Format value based on type
    if (is.logical(param_value)) {
      value_str <- ifelse(param_value, "Yes", "No")
    } else if (is.numeric(param_value)) {
      value_str <- as.character(param_value)
    } else if (is.null(param_value)) {
      value_str <- "Not specified"
    } else {
      value_str <- as.character(param_value)
    }
    
    # Get description if available
    description <- param_descriptions[[param_name]]
    if (is.null(description)) {
      description <- ""
    }
    
    repro_df <- rbind(repro_df, data.frame(
      Parameter = param_name,
      Value = value_str,
      Description = description,
      stringsAsFactors = FALSE
    ))
  }
  
  return(repro_df)
}


#' Get Software Environment Table
#'
#' Generates standardized software environment table for all reports.
#'
#' @param metadata List. Output from captureAnalysisMetadata()
#'
#' @return data.frame suitable for knitr::kable()
#' @export
getSoftwareTable <- function(metadata) {
  
  software_df <- data.frame(
    Component = c(
      "Analysis Platform",
      "Platform Version",
      "R Version",
      "Operating System",
      "Platform"
    ),
    Version = c(
      "Ördin",
      paste0("v", metadata$software$ordin_version),
      metadata$software$r_version,
      metadata$software$os,
      metadata$software$platform
    ),
    stringsAsFactors = FALSE
  )
  
  # Add package versions
  for (pkg_name in names(metadata$packages)) {
    software_df <- rbind(software_df, data.frame(
      Component = paste0(pkg_name, " package"),
      Version = metadata$packages[[pkg_name]],
      stringsAsFactors = FALSE
    ))
  }
  
  return(software_df)
}


#' Generate R Code for Reproducibility Section
#'
#' Creates properly formatted R code snippet for reproduction instructions.
#'
#' @param analysis_type Character. Type of analysis
#' @param code_template Character. R code template with {placeholders}
#' @param params List. Parameters to substitute into template
#'
#' @return Character. Formatted R code
#' @export
generateReproductionCode <- function(analysis_type, code_template, params) {
  
  # Replace placeholders in template
  code <- code_template
  
  for (param_name in names(params)) {
    placeholder <- paste0("{", param_name, "}")
    param_value <- params[[param_name]]
    
    # Format value for R code
    if (is.character(param_value)) {
      value_str <- paste0('"', param_value, '"')
    } else if (is.logical(param_value)) {
      value_str <- toupper(as.character(param_value))
    } else {
      value_str <- as.character(param_value)
    }
    
    code <- gsub(placeholder, value_str, code, fixed = TRUE)
  }
  
  return(code)
}


#' Print Reproducibility Summary to Console
#'
#' Displays reproducibility information in the R console for debugging.
#'
#' @param metadata List. Output from captureAnalysisMetadata()
#' @export
printReproducibilitySummary <- function(metadata) {
  cat("\n=== Analysis Reproducibility Summary ===\n")
  cat("Analysis Type:", metadata$analysis_type, "\n")
  cat("Dataset:", metadata$dataset_name, "\n")
  cat("Date/Time:", format(metadata$analysis_timestamp, "%Y-%m-%d %H:%M:%S %Z"), "\n")
  cat("\nSoftware:\n")
  cat("  Ördin:", metadata$software$ordin_version, "\n")
  cat("  R:", metadata$software$r_version, "\n")
  cat("  OS:", metadata$software$os, "\n")
  cat("\nPackages:\n")
  for (pkg in names(metadata$packages)) {
    cat(sprintf("  %s: %s\n", pkg, metadata$packages[[pkg]]))
  }
  cat("\n========================================\n\n")
}
