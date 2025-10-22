# Start Shiny server
library(shiny)

# Set working directory to shiny folder
setwd(file.path(getwd(), "shiny"))

# Set Shiny options
options(shiny.port = 8888)
options(shiny.host = "127.0.0.1")
options(shiny.launch.browser = FALSE)

# Print startup message
cat("Starting Ördin Shiny server...\n")
cat("Working directory:", getwd(), "\n")

# Run the Shiny app
shiny::runApp(
  appDir = ".",
  port = 8888,
  host = "127.0.0.1",
  launch.browser = FALSE
)
