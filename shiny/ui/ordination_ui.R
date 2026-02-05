# Ordination Analysis Tab Content
div(
  id = "tab-ordination", class = "tab-content", style = "display: none;",
  h2(style = "color: #2e8b57; margin-bottom: 20px;", "🗺️ Ordination Analysis"),
  selectInput("ordination_method", "Select Method:",
    selectize = FALSE,
    choices = c(
      "NMDS" = "nmds",
      "PCA" = "pca",
      "CA" = "ca",
      "DCA" = "dca",
      "PCoA" = "pcoa",
      "CCA (constrained)" = "cca",
      "RDA (constrained)" = "rda",
      "db-RDA (constrained)" = "dbrda",
      "CAP (constrained)" = "cap"
    )
  ),
  conditionalPanel("input.ordination_method == 'nmds'", nmds_ui("nmds")),
  conditionalPanel("input.ordination_method == 'pca'", pca_ui("pca")),
  conditionalPanel("input.ordination_method == 'ca'", ca_ui("ca")),
  conditionalPanel("input.ordination_method == 'dca'", dca_ui("dca")),
  conditionalPanel("input.ordination_method == 'pcoa'", pcoa_ui("pcoa")),
  conditionalPanel("input.ordination_method == 'cca'", cca_ui("cca")),
  conditionalPanel("input.ordination_method == 'rda'", rda_ui("rda")),
  conditionalPanel("input.ordination_method == 'dbrda'", dbrda_ui("dbrda")),
  conditionalPanel("input.ordination_method == 'cap'", cap_ui("cap"))
)
