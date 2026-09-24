#' DataService R6 Class
#'
#' Centralized service for managing application data state
#' Handles loading, validation, and transformation of all datasets
#'
#' @export
DataService <- R6::R6Class("DataService",
  public = list(
    #' @field species_data ReactiveVal for species community matrix
    species_data = NULL,

    #' @field env_data ReactiveVal for environmental variables
    env_data = NULL,

    #' @field phylo_tree ReactiveVal for phylogenetic tree
    phylo_tree = NULL,

    #' @field trait_data ReactiveVal for functional traits
    trait_data = NULL,

    #' @description
    #' Initialize the DataService
    #' @return A new DataService object
    initialize = function() {
      self$species_data <- reactiveVal(NULL)
      self$env_data <- reactiveVal(NULL)
      self$phylo_tree <- reactiveVal(NULL)
      self$trait_data <- reactiveVal(NULL)
    },

    #' @description
    #' Load a sample dataset by name
    #' @param dataset_name Name of the dataset ("dune", "varespec", "BCI", etc.)
    #' @return TRUE if successful, FALSE otherwise
    load_sample_data = function(dataset_name) {
      tryCatch({
        if (dataset_name == "dune") {
          data(dune, package = "vegan")
          self$species_data(as.data.frame(dune))
          data(dune.env, package = "vegan")
          self$env_data(as.data.frame(dune.env))
          return(list(success = TRUE, message = "Dune meadow data loaded"))

        } else if (dataset_name == "varespec") {
          data(varespec, package = "vegan")
          self$species_data(as.data.frame(varespec))
          data(varechem, package = "vegan")
          self$env_data(as.data.frame(varechem))
          return(list(success = TRUE, message = "Varespec data loaded"))

        } else if (dataset_name == "BCI") {
          data(BCI, package = "vegan")
          self$species_data(as.data.frame(BCI))
          return(list(success = TRUE, message = "BCI data loaded"))

        } else if (dataset_name == "phylo_example") {
          data(phylocom, package = "picante")
          self$species_data(as.data.frame(phylocom$sample))
          self$phylo_tree(phylocom$phylo)
          return(list(success = TRUE, message = "Phylocom data loaded"))

        } else if (dataset_name == "func_example") {
          data(phylocom, package = "picante")
          self$species_data(as.data.frame(phylocom$sample))
          self$trait_data(phylocom$traits)
          return(list(success = TRUE, message = "Functional traits example loaded"))

        } else {
          # Handle other datasets or return error
          # For file-based samples, we assume they are in ../sample-data/
          # This logic can be expanded
          return(list(success = FALSE, message = paste("Unknown dataset:", dataset_name)))
        }
      }, error = function(e) {
        return(list(success = FALSE, message = e$message))
      })
    },

    #' @description
    #' Load data from a file
    #' @param file_path Path to the file
    #' @param type Type of data ("species", "env", "traits")
    #' @return List with success status and message
    load_file = function(file_path, type = "species") {
      tryCatch({
        ext <- tools::file_ext(file_path)
        data <- switch(ext,
          "csv" = read.csv(file_path, row.names = 1),
          "xlsx" = readxl::read_excel(file_path) %>% as.data.frame() %>% {rownames(.) <- .[[1]]; .[,-1]},
          "xls" = readxl::read_excel(file_path) %>% as.data.frame() %>% {rownames(.) <- .[[1]]; .[,-1]},
          stop("Unsupported file format")
        )

        # Validate BEFORE storing (validators live in shiny/R/error_handler.R;
        # the exists() guard keeps DataService usable when sourced standalone)
        if (type == "species" && exists("validate_species_data", mode = "function")) {
          check <- validate_species_data(data)
          if (!isTRUE(check$valid)) {
            return(list(success = FALSE,
                        message = paste("Species data rejected:", check$message)))
          }
        }
        if (type == "env" && exists("validate_env_data", mode = "function")) {
          sp <- self$species_data()
          if (!is.null(sp)) {
            check <- validate_env_data(sp, data)
            if (!isTRUE(check$valid)) {
              return(list(success = FALSE,
                          message = paste("Environmental data rejected:", check$message)))
            }
          }
        }

        switch(type,
          "species" = self$species_data(data),
          "env" = self$env_data(data),
          "traits" = self$trait_data(data)
        )

        return(list(success = TRUE, message = paste(type, "data loaded successfully")))
      }, error = function(e) {
        return(list(success = FALSE, message = e$message))
      })
    },

    #' @description
    #' Reset all data
    reset = function() {
      self$species_data(NULL)
      self$env_data(NULL)
      self$phylo_tree(NULL)
      self$trait_data(NULL)
    }
  )
)
