# Contributing to Ördin

Thank you for your interest in contributing to Ördin! This document provides guidelines for contributing to the project.

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what is best for the community
- Show empathy towards other community members

## How Can I Contribute?

### 🐛 Reporting Bugs

**Before submitting a bug report:**
- Check the [documentation](README.md) and [troubleshooting guide](docs/QUICKSTART.md)
- Search existing issues to avoid duplicates

**When submitting a bug report, include:**
- Ördin version (from package.json)
- Operating system and version
- R version (run `R --version`)
- Node.js version (run `node --version`)
- Steps to reproduce the issue
- Expected vs actual behavior
- Screenshots (if applicable)
- Error messages from DevTools console

### 💡 Suggesting Enhancements

**Before suggesting an enhancement:**
- Check the [roadmap](CHANGELOG.md) to see if it's already planned
- Search existing feature requests

**When suggesting an enhancement, include:**
- Clear description of the feature
- Use case: What problem does it solve?
- Example implementation (if you have ideas)
- Mockups or screenshots (for UI changes)

### 📝 Contributing Code

#### First-Time Contributors

Good first issues:
- Documentation improvements
- UI/theme tweaks
- Adding new bootswatch themes
- Sample datasets
- Bug fixes with clear reproduction steps

#### Development Process

1. **Fork the repository**
   ```bash
   git clone https://github.com/yourusername/ordin.git
   cd ordin
   ```

2. **Set up development environment**
   ```bash
   # Windows
   setup.bat
   
   # macOS/Linux
   ./setup.sh
   ```

3. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Make your changes**
   - Follow the code style guide (see below)
   - Test your changes thoroughly
   - Add documentation if needed

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: Add your feature description"
   ```
   
   Use [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat:` New feature
   - `fix:` Bug fix
   - `docs:` Documentation changes
   - `style:` Code style changes (formatting, etc.)
   - `refactor:` Code refactoring
   - `test:` Adding tests
   - `chore:` Maintenance tasks

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Open a Pull Request**
   - Describe what your PR does
   - Link to related issues
   - Include screenshots for UI changes
   - Ensure all checks pass

## Code Style Guide

### R Code Style

Follow the [tidyverse style guide](https://style.tidyverse.org/):

```r
# Good
calculate_diversity <- function(data) {
  result <- iNEXT(data, q = c(0, 1, 2), datatype = "abundance")
  return(result)
}

# Bad
CalculateDiversity<-function(data){
result<-iNEXT(data,q=c(0,1,2),datatype="abundance")
return(result)}
```

**Key points:**
- Use 2-space indentation
- Use `<-` for assignment, not `=`
- Add spaces around operators
- Use descriptive variable names
- Comment complex logic
- Use tidyverse functions where appropriate

### JavaScript Code Style

Follow standard JavaScript conventions:

```javascript
// Good
function checkShinyReady(maxAttempts = 30, interval = 1000) {
  return new Promise((resolve, reject) => {
    // Implementation
  });
}

// Bad
function checkShinyReady(maxAttempts,interval){
return new Promise((resolve,reject)=>{
// Implementation
})}
```

**Key points:**
- Use 2-space indentation
- Use `const` over `let`, avoid `var`
- Use camelCase for variables and functions
- Add semicolons
- Use async/await over callbacks
- Add JSDoc comments for public functions

### Shiny UI Code Style

```r
# Good
ui <- page_sidebar(
  theme = bs_theme(
    version = 5,
    bootswatch = "darkly",
    primary = "#2e8b57"
  ),
  sidebar = sidebar(
    width = 350,
    fileInput("dataFile", "Upload CSV")
  ),
  card(
    card_header("Results"),
    uiOutput("resultsUI")
  )
)

# Bad
ui<-page_sidebar(theme=bs_theme(version=5,bootswatch="darkly",primary="#2e8b57"),sidebar=sidebar(width=350,fileInput("dataFile","Upload CSV")),card(card_header("Results"),uiOutput("resultsUI")))
```

## Testing Guidelines

### Manual Testing Checklist

Before submitting a PR, test:

**Basic Functionality:**
- [ ] App starts without errors
- [ ] Sample data loads correctly
- [ ] iNEXT analysis runs and displays results
- [ ] NMDS analysis runs and displays results
- [ ] CSV download works
- [ ] PNG download works

**Error Handling:**
- [ ] Invalid CSV shows error message
- [ ] Missing columns handled gracefully
- [ ] Non-numeric data shows error
- [ ] Empty file handled properly

**UI/UX:**
- [ ] All buttons are clickable
- [ ] Theme renders correctly
- [ ] Tables are readable
- [ ] Plots display properly
- [ ] Responsive layout works

**Cross-Platform (if applicable):**
- [ ] Works on Windows
- [ ] Works on macOS
- [ ] Build process succeeds

### Automated Tests (Future)

We plan to add:
- R unit tests using `testthat`
- JavaScript tests using Jest
- Integration tests using Spectron
- CI/CD with GitHub Actions

## Adding New Features

### Adding a New Analysis Method

1. **Update UI** (`shiny/app.R`):
   ```r
   selectInput("analysisType", "Select Analysis",
     choices = c(
       "Diversity Estimation (iNEXT)",
       "Ordination (NMDS via vegan)",
       "Your New Analysis"  # Add here
     ))
   ```

2. **Add analysis logic**:
   ```r
   observeEvent(input$runAnalysis, {
     
     } else if (input$analysisType == "Your New Analysis") {
       # Your analysis code here
       analysis_result <- your_function(abund_matrix)
       
       # Create summary
       summary_df <- data.frame(...)
       
       # Create plot
       plot_obj <- ggplot(...) + ...
       
       # Store results
       results(list(
         summary = summary_df,
         plot = plot_obj,
         type = "YourAnalysis"
       ))
     }
   })
   ```

3. **Add required R packages**:
   - Edit `add-cran-binary-pkgs.R`
   - Add package to `required_packages`
   - Add `library()` call in `shiny/app.R`

4. **Update documentation**:
   - Add to README.md features list
   - Update CHANGELOG.md
   - Add usage example

### Adding a New Theme

1. **Create theme in** `shiny/app.R`:
   ```r
   # Option 1: Use bootswatch theme
   theme = bs_theme(version = 5, bootswatch = "flatly")
   
   # Option 2: Custom theme
   theme = bs_theme(
     version = 5,
     bg = "#ffffff",
     fg = "#000000",
     primary = "#007bff",
     # ... more customization
   )
   ```

2. **Add theme selector** (optional):
   ```r
   # In sidebar
   selectInput("theme", "Select Theme",
     choices = c("darkly", "flatly", "cosmo", "united"))
   
   # In server
   observe({
     session$setCurrentTheme(
       bs_theme(version = 5, bootswatch = input$theme)
     )
   })
   ```

## Documentation

### Documentation Standards

- **Code comments**: Explain WHY, not WHAT
- **Function docs**: Include parameters, return values, examples
- **README updates**: Keep in sync with code changes
- **Changelog**: Document all user-facing changes

### Example R Function Documentation

```r
#' Calculate Species Diversity Using iNEXT
#'
#' This function runs iNEXT diversity estimation on an abundance matrix
#' and returns both the statistical results and a visualization.
#'
#' @param abundance_matrix A matrix with sites as rows and species as columns
#' @param q A numeric vector of diversity orders (default: c(0, 1, 2))
#'
#' @return A list containing:
#'   \item{summary}{Data frame with diversity estimates}
#'   \item{plot}{ggplot2 object with rarefaction curves}
#'
#' @examples
#' data <- matrix(c(15, 23, 8, 18, 19, 12), nrow = 2)
#' result <- calculate_diversity(data)
#'
#' @export
calculate_diversity <- function(abundance_matrix, q = c(0, 1, 2)) {
  # Implementation
}
```

## Commit Message Guidelines

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting, missing semicolons, etc.
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `perf`: Performance improvement
- `test`: Adding tests
- `chore`: Updating build tasks, package manager configs, etc.

**Examples:**

```
feat: Add PCA ordination method

Implements PCA ordination using vegan::rda(). Includes:
- UI selector for PCA
- Analysis logic with eigenvalue display
- Biplot visualization

Closes #123
```

```
fix: Handle empty CSV files gracefully

Previously, uploading an empty CSV would crash the app.
Now displays a user-friendly error message.

Fixes #456
```

## Review Process

### What Reviewers Look For

- **Functionality**: Does it work as intended?
- **Code quality**: Is it readable and maintainable?
- **Performance**: Are there any bottlenecks?
- **Documentation**: Is it well-documented?
- **Testing**: Has it been tested thoroughly?
- **Style**: Does it follow the style guide?

### Responding to Feedback

- Be open to suggestions
- Ask for clarification if needed
- Make requested changes promptly
- Push updates to the same branch

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md (coming soon)
- Mentioned in release notes for significant contributions
- Credited in the About section of the app

## Questions?

- Open an issue for general questions
- Email jmoses@pnguot.ac.pg for private inquiries
- Check [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md) for architecture details

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to Ördin!** 🌿

Your efforts help make biodiversity analysis more accessible to researchers worldwide.
