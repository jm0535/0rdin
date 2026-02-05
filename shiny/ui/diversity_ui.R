# Diversity Analysis Tab Content
div(
  id = "tab-diversity", class = "tab-content", style = "display: none;",
  h2(style = "color: #2e8b57; margin-bottom: 20px;", "🔬 Diversity Analysis"),
  selectInput("diversity_method", "Select Method:",
    choices = c(
      "Diversity Estimation (iNEXT)" = "estimation",
      "Diversity Indices (Shannon, Simpson)" = "indices"
    ),
    selectize = FALSE
  ),
  conditionalPanel(
    "input.diversity_method == 'estimation'",
    diversity_estimation_ui("diversity_est")
  ),
  conditionalPanel(
    "input.diversity_method == 'indices'",
    diversity_indices_ui("diversity_idx")
  )
)
