# Ördin Code Standards & Best Practices

**Author:** Jimmy Moses (jimmy.moses@pnguot.ac.pg)  
**Version:** 3.0  
**Last Updated:** October 29, 2025

---

## **📋 Table of Contents**

1. [Project Structure](#project-structure)
2. [Coding Standards](#coding-standards)
3. [Testing Requirements](#testing-requirements)
4. [Error Handling](#error-handling)
5. [Performance Guidelines](#performance-guidelines)
6. [Documentation Standards](#documentation-standards)
7. [Version Control](#version-control)

---

## **🗂️ Project Structure**

```
ordin/shiny/
├── app.R                    # Main application entry point
├── DESCRIPTION              # Package metadata
├── config/                  # Configuration management
│   ├── config.yml          # YAML configuration
│   ├── constants.R         # Global constants
│   └── defaults.R          # Default parameters
├── R/                      # Core utilities
│   ├── error_handler.R    # Error handling & validation
│   └── performance.R      # Performance optimization
├── modules/                # Shiny modules
│   ├── ordination_*.R     # Ordination modules
│   ├── diversity_*.R      # Diversity modules
│   └── tests_*.R          # Statistical test modules
├── www/                    # Web assets
│   ├── prototype-styles.css
│   ├── shiny-ui.js
│   └── ...
└── tests/                  # Test suite
    ├── testthat.R
    └── testthat/
        ├── test-data-loading.R
        ├── test-ordination.R
        └── test-statistical-tests.R
```

---

## **💻 Coding Standards**

### **R Code Style**

1. **Naming Conventions**
   - Functions: `snake_case()` (e.g., `validate_species_data()`)
   - Variables: `snake_case` (e.g., `nmds_result`)
   - Constants: `UPPER_SNAKE_CASE` (e.g., `COLOR_PRIMARY`)
   - Modules: `moduleName_ui()`, `moduleName_server()`

2. **Indentation & Spacing**
   - Use 2 spaces (not tabs)
   - Maximum line length: 100 characters
   - Space after commas, around operators

3. **Function Documentation**
   ```r
   #' Function Title
   #'
   #' Detailed description of what the function does.
   #'
   #' @param param1 Description of parameter 1
   #' @param param2 Description of parameter 2
   #' @return Description of return value
   #' @export
   #' @examples
   #' function_name(param1 = "value", param2 = 10)
   ```

4. **Module Pattern**
   ```r
   # UI Function
   moduleName_ui <- function(id) {
     ns <- NS(id)
     tagList(
       # UI elements
     )
   }
   
   # Server Function
   moduleName_server <- function(id, data, ...) {
     moduleServer(id, function(input, output, session) {
       # Server logic
     })
   }
   ```

### **JavaScript/CSS Style**

1. **JavaScript**
   - Use ES6+ features
   - camelCase for variables/functions
   - Semicolons required
   - Add cache-busting version parameters: `?v=X`

2. **CSS**
   - Class names: `kebab-case`
   - Group related rules
   - Comment major sections
   - Use CSS variables for theming

---

## **🧪 Testing Requirements**

### **Unit Tests (testthat)**

All new functions must include unit tests:

```r
test_that("Function description", {
  result <- my_function(input)
  expect_equal(result, expected_output)
  expect_true(condition)
  expect_error(invalid_input, "error message")
})
```

### **Test Coverage Goals**

- **Core utilities:** 90%+ coverage
- **Data validation:** 95%+ coverage
- **Ordination methods:** 80%+ coverage
- **Statistical tests:** 85%+ coverage

### **Integration Tests (shinytest2)**

Critical user workflows must have integration tests:

```r
test_that("NMDS workflow completes", {
  app <- AppDriver$new()
  app$set_inputs(ordination_method = "nmds")
  app$click("run_nmds")
  app$expect_values()
})
```

### **Running Tests**

```r
# Run all tests
testthat::test_dir("tests/testthat")

# Run specific test file
testthat::test_file("tests/testthat/test-ordination.R")

# Check test coverage
covr::package_coverage()
```

---

## **⚠️ Error Handling**

### **Mandatory Error Handling**

ALL analysis functions must use the global error handler:

```r
result <- safe_execute(
  expr = {
    # Analysis code
    metaMDS(data, k = 2)
  },
  context = "NMDS Analysis",
  session = session
)
```

### **Data Validation**

Always validate inputs before processing:

```r
validation <- validate_species_data(data)
if (!validation$valid) {
  showNotification(validation$message, type = "error")
  return(NULL)
}
```

### **User-Friendly Error Messages**

- ❌ **Bad:** `"Error in metaMDS: NA/NaN/Inf in foreign function call"`
- ✅ **Good:** `"NMDS failed: Your data contains missing values (NA). Please clean your data before analysis."`

---

## **⚡ Performance Guidelines**

### **Caching**

Use caching for expensive operations:

```r
# Reactive caching
cached_distance <- reactive({
  get_distance_matrix(data(), method = input$distance)
}) %>% bindCache(data(), input$distance)
```

### **Debouncing**

Debounce rapid user inputs:

```r
# Wait 1 second after user stops typing
debounced_k <- debounce(reactive(input$k), 1000)
```

### **Async Operations**

Use promises for long-running tasks:

```r
result_promise <- async_ordination(data, method = "nmds")
result_promise %...>% {
  # Handle result
}
```

### **Large Datasets**

Implement dataset size limits and optimization:

```r
if (nrow(data) > 1000) {
  data <- optimize_dataset(data, max_sites = 500)
  showNotification("Large dataset detected - sampling 500 sites")
}
```

---

## **📚 Documentation Standards**

### **Code Comments**

- **Purpose:** What the code does (not how)
- **Complex Logic:** Explain WHY not WHAT
- **Parameters:** Document all function parameters
- **Return Values:** Document what is returned

### **README Structure**

Each module should have:
1. Purpose/Description
2. Dependencies
3. Usage Examples
4. Parameter Descriptions
5. Return Value Details

### **Inline Help**

Use `helpText()` in UI for user guidance:

```r
helpText("NMDS attempts to represent dissimilarity in low-dimensional space.")
```

---

## **🔄 Version Control**

### **Commit Messages**

Format: `type(scope): description`

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Adding tests
- `perf`: Performance improvement

**Examples:**
```
feat(nmds): add stress interpretation tooltips
fix(permanova): correct p-value calculation
docs(readme): update installation instructions
test(ordination): add PCA validation tests
```

### **Branching Strategy**

- `main`: Production-ready code
- `develop`: Integration branch
- `feature/*`: New features
- `bugfix/*`: Bug fixes
- `hotfix/*`: Critical production fixes

---

## **✅ Pre-Commit Checklist**

Before committing code:

- [ ] All tests pass (`testthat::test_dir("tests")`)
- [ ] No console warnings/errors
- [ ] Code follows style guide
- [ ] Functions documented with roxygen2
- [ ] Error handling implemented
- [ ] User-facing messages are clear
- [ ] Performance tested with large datasets
- [ ] Git commit message follows format

---

## **🚀 Deployment Checklist**

Before production release:

- [ ] All integration tests pass
- [ ] Error handling covers edge cases
- [ ] Performance profiling completed
- [ ] Documentation updated
- [ ] Version number incremented
- [ ] Changelog updated
- [ ] Security audit completed
- [ ] User acceptance testing done

---

## **📞 Contact & Support**

**Maintainer:** Jimmy Moses  
**Email:** jimmy.moses@pnguot.ac.pg  
**Project:** Ördin v3.0

For questions or suggestions, please open an issue on GitHub or contact the maintainer directly.
