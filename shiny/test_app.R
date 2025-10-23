# Test if the app can be loaded without errors
library(shiny)

# Try to source the app file to check for syntax errors
source("app.R")

# If we get here, the app file loaded successfully
cat("App file loaded successfully!\n")
cat("No syntax errors detected.\n")