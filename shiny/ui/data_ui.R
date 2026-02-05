# Data Management Tab Content
div(
  id = "tab-data", class = "tab-content", style = "display: none;",

  # PAGE HEADER
  div(
    style = "margin-bottom: 30px;",
    h2(style = "color: #2e8b57; margin: 0 0 8px 0; font-size: 24px; font-weight: 600;", "📊 Data Management"),
    p(style = "color: #888; font-size: 14px; margin: 0;", "Import your species data and preview before analysis")
  ),

  # TWO-COLUMN LAYOUT - Responsive to prevent overflow
  div(
    style = "display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px; max-width: 100%;",

    # LEFT COLUMN - Species Data
    div(
      style = "background: #252526; border: 1px solid #3e3e42; padding: 24px;",
      div(
        style = "display: flex; align-items: center; margin-bottom: 20px;",
        div(
          style = "width: 40px; height: 40px; background: #2e8b5720; border-radius: 8px; display: flex; align-items: center; justify-content: center; margin-right: 12px;",
          span(style = "font-size: 20px;", "1️⃣")
        ),
        div(
          h3(style = "color: #cccccc; margin: 0; font-size: 16px; font-weight: 600;", "Species Composition Data"),
          p(style = "color: #888; font-size: 12px; margin: 4px 0 0 0;", "Required for all analyses")
        )
      ),

      # File Upload Section
      div(
        style = "margin-bottom: 24px;",
        h4(style = "color: #aaa; font-size: 13px; margin-bottom: 12px; font-weight: 600;", "📤 UPLOAD FILE"),
        fileInput("species_file", "",
          accept = c(".csv", ".xlsx", ".xls"),
          placeholder = "Choose CSV or Excel file"
        ),
        div(
          style = "background: #1e1e1e; border-left: 3px solid #2e8b57; padding: 12px; margin-top: 8px;",
          p(
            style = "color: #888; font-size: 11px; margin: 0; line-height: 1.6;",
            "💡 ", tags$strong("Format:"), " First column = Site names, Other columns = Species abundance"
          )
        )
      ),

      # Sample Dataset Section
      div(
        style = "border-top: 1px solid #3e3e42; padding-top: 20px;",
        h4(style = "color: #aaa; font-size: 13px; margin-bottom: 12px; font-weight: 600;", "📚 LOAD SAMPLE"),
        div(
          style = "margin-bottom: 0;",
          selectInput("sample_dataset",
            label = NULL,
            choices = c(
              "Choose a sample dataset..." = "",
              "Dune Meadow (20 sites × 30 species + env)" = "dune",
              "Varespec (24 sites × 44 species)" = "varespec",
              "BCI (50 sites × 225 species)" = "BCI",
              "Ciliates Incidence (3 sites × 300 species, P/A)" = "ciliates_incidence",
              "Ant Incidence (17 sites, incidence freq)" = "ant_incidence",
              "Plant Presence (17 sites × 46 species, P/A)" = "plant_presence",
              "Phylocom (6 sites + real phylogeny)" = "phylo_example",
              "Phylocom Traits (6 sites + functional traits)" = "func_example",
              "BBS Birds (49 sites × 2 time periods)" = "temporal_example"
            )
          )
        ),
        actionButton("load_sample", "▶ Load Sample Data",
          class = "btn-success",
          style = "width: 100%; margin-top: 8px;"
        )
      )
    ),

    # RIGHT COLUMN - Environmental Data
    div(
      style = "background: #252526; border: 1px solid #3e3e42; padding: 24px;",
      div(
        style = "display: flex; align-items: center; margin-bottom: 20px;",
        div(
          style = "width: 40px; height: 40px; background: #4a90e220; border-radius: 8px; display: flex; align-items: center; justify-content: center; margin-right: 12px;",
          span(style = "font-size: 20px;", "2️⃣")
        ),
        div(
          h3(style = "color: #cccccc; margin: 0; font-size: 16px; font-weight: 600;", "Environmental Data"),
          p(style = "color: #888; font-size: 12px; margin: 4px 0 0 0;", "Optional - for constrained ordination")
        )
      ),
      h4(style = "color: #aaa; font-size: 13px; margin-bottom: 12px; font-weight: 600;", "📤 UPLOAD FILE"),
      fileInput("env_file", "",
        accept = c(".csv", ".xlsx", ".xls"),
        placeholder = "Choose environmental data file"
      ),
      div(
        style = "background: #1e1e1e; border-left: 3px solid #4a90e2; padding: 12px; margin-top: 8px;",
        p(
          style = "color: #888; font-size: 11px; margin: 0 0 8px 0; line-height: 1.6;",
          "💡 ", tags$strong("Examples:"), " pH, temperature, soil moisture, etc."
        ),
        p(
          style = "color: #888; font-size: 11px; margin: 0; line-height: 1.6;",
          "⚠️ Must have same sites as species data"
        )
      )
    )
  ),

  # DATA PREVIEW SECTION - Full Width with proper overflow handling
  div(
    style = "background: #252526; border: 1px solid #3e3e42; padding: 24px;",
    # Preview Header
    div(
      style = "display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;",
      div(
        h3(style = "color: #2e8b57; margin: 0; font-size: 18px; font-weight: 600;", "🔍 Data Preview"),
        p(style = "color: #888; font-size: 12px; margin: 4px 0 0 0;", "Preview loaded dataset before analysis")
      ),
      uiOutput("data_info_badge")
    ),

    # Species Data Preview
    div(
      style = "margin-bottom: 30px;",
      h4(style = "color: #2e8b57; font-size: 14px; margin-bottom: 12px; font-weight: 600;", "🌿 Species Composition"),
      div(
        style = "width: 100%; overflow-x: auto; overflow-y: auto; max-height: 500px; border: 1px solid #3e3e42;",
        DT::DTOutput("species_preview")
      )
    ),

    # Environmental Data Preview
    uiOutput("env_preview_section"),

    # Phylogenetic Tree Preview
    uiOutput("phylo_preview_section"),

    # Trait Data Preview
    uiOutput("trait_preview_section")
  )
)
