# Test Shiny Data Loading
# This script tests if the sample data loading works

library(httr)
library(jsonlite)

cat("Testing Shiny App Data Loading...\n\n")

# Test 1: Check if app is accessible
cat("Test 1: Checking if app is running...\n")
response <- GET("http://localhost:9054")
if (status_code(response) == 200) {
  cat("✅ App is running and accessible\n\n")
} else {
  cat("❌ App is not accessible\n")
  quit()
}

# Test 2: Check if Data Management tab HTML is present
cat("Test 2: Checking if Data Management content exists...\n")
content <- content(response, as = "text")
if (grepl("Data Management", content)) {
  cat("✅ Data Management tab content found\n\n")
} else {
  cat("❌ Data Management content not found\n\n")
}

# Test 3: Check if sample dataset dropdown exists
cat("Test 3: Checking for sample dataset selector...\n")
if (grepl("sample_dataset", content)) {
  cat("✅ Sample dataset selector found\n\n")
} else {
  cat("❌ Sample dataset selector not found\n\n")
}

# Test 4: Check if load button exists
cat("Test 4: Checking for load sample data button...\n")
if (grepl("load_sample", content)) {
  cat("✅ Load sample button found\n\n")
} else {
  cat("❌ Load sample button not found\n\n")
}

# Test 5: Check if DataTable output is defined
cat("Test 5: Checking for DataTable preview element...\n")
if (grepl("species_preview", content)) {
  cat("✅ DataTable preview element found\n\n")
} else {
  cat("❌ DataTable preview element not found\n\n")
}

# Test 6: Check CSS and JS files
cat("Test 6: Checking if assets are loading...\n")
css_response <- GET("http://localhost:9054/prototype-styles.css?v=6")
js_response <- GET("http://localhost:9054/shiny-ui.js?v=4")

if (status_code(css_response) == 200) {
  cat("✅ CSS file loaded successfully\n")
} else {
  cat("❌ CSS file failed to load\n")
}

if (status_code(js_response) == 200) {
  cat("✅ JavaScript file loaded successfully\n")
} else {
  cat("❌ JavaScript file failed to load\n")
}

cat("\n=== TEST SUMMARY ===\n")
cat("All basic tests completed. To fully test data loading:\n")
cat("1. Open the preview browser (click the button above)\n")
cat("2. Navigate to Data tab\n")
cat("3. Select a sample dataset\n")
cat("4. Click 'Load Sample Data'\n")
cat("5. Check R console for debug output\n")
cat("6. Verify DataTable appears with data\n")
