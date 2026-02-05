# Data Management Tab Content
div(
  id = "tab-data", class = "tab-content", style = "display: none;",

  # PAGE HEADER
  div(
    style = "margin-bottom: 30px;",
    h2(style = "color: #2e8b57; margin: 0 0 8px 0; font-size: 24px; font-weight: 600;", "📊 Data Management"),
    p(style = "color: #888; font-size: 14px; margin: 0;", "Import your species data and preview before analysis")
  ),

  # IMPORT MODULE SECTION
  div(
    style = "margin-bottom: 24px; background: #252526; border: 1px solid #3e3e42; border-radius: 4px;",
    import_ui("import")
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
