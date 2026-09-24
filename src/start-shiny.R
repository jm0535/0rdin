# Start Shiny server

# Install required packages if not already installed
# Keep in sync with shiny/DESCRIPTION (Imports section)
required_packages <- c(
  "shiny", "vegan", "iNEXT", "ggplot2", "DT", "shinyjs", "waiter",
  "shinyFeedback", "readr", "readxl", "dplyr", "tidyr", "yaml", "digest",
  "jsonlite", "R6", "promises", "future", "rmarkdown", "knitr",
  "ape", "picante", "betapart", "patchwork"
)

for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cat("Installing package:", pkg, "\n")
    install.packages(pkg, repos = "https://cloud.r-project.org/")
  }
}

# Load required packages
library(shiny)
library(shinyFeedback)

# Set working directory to shiny folder
setwd(file.path(getwd(), "shiny"))

# Set Shiny options
options(shiny.port = 9054)
options(shiny.host = "127.0.0.1")
options(shiny.launch.browser = FALSE)

# Print startup message
cat("Starting Ördin Shiny server...\n")
cat("Working directory:", getwd(), "\n")

# Run the Shiny app
shiny::runApp(
  appDir = ".",
  port = 9054,
  host = "127.0.0.1",
  launch.browser = FALSE
)
