# Statistical Tests Tab Content
div(
  id = "tab-tests", class = "tab-content", style = "display: none;",
  h2(style = "color: #2e8b57; margin-bottom: 20px;", "🧪 Statistical Tests"),
  selectInput("test_method", "Select Test:",
    selectize = FALSE,
    choices = c(
      "PERMANOVA" = "permanova",
      "ANOSIM" = "anosim",
      "Mantel Test & envfit" = "mantel_envfit"
    )
  ),
  conditionalPanel("input.test_method == 'permanova'", permanova_ui("permanova")),
  conditionalPanel("input.test_method == 'anosim'", anosim_ui("anosim")),
  conditionalPanel("input.test_method == 'mantel_envfit'", mantel_envfit_ui("mantel_envfit"))
)
