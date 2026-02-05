# Dashboard Tab Content
div(
  id = "tab-dashboard", class = "tab-content active",
  # Hero Section
  div(
    class = "welcome",
    h1("Ö"),
    h2("Ördin"),
    p("Next-Gen Open-Source Community Ecology Analysis Platform"),
    div(
      style = "margin-top: 20px; display: flex; gap: 12px; justify-content: center; flex-wrap: wrap;",
      span(style = "background: #2e8b5720; color: #2e8b57; padding: 6px 12px; border-radius: 4px; font-size: 12px; font-weight: 600;", "✓ Open Source"),
      span(style = "background: #4a90e220; color: #4a90e2; padding: 6px 12px; border-radius: 4px; font-size: 12px; font-weight: 600;", "✓ Cross-Platform"),
      span(style = "background: #ffa50020; color: #ffa500; padding: 6px 12px; border-radius: 4px; font-size: 12px; font-weight: 600;", "✓ Publication-Ready")
    )
  ),

  # Stats Overview
  div(
    style = "display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; width: 100%; margin: 30px 0;",
    div(
      style = "background: linear-gradient(135deg, #2e8b57 0%, #1e5f3f 100%); padding: 24px; border-radius: 8px; text-align: center;",
      div(style = "font-size: 32px; font-weight: 700; color: white; margin-bottom: 8px;", "9"),
      div(style = "color: #e0e0e0; font-size: 13px; font-weight: 600;", "Ordination Methods")
    ),
    div(
      style = "background: linear-gradient(135deg, #4a90e2 0%, #2563a8 100%); padding: 24px; border-radius: 8px; text-align: center;",
      div(style = "font-size: 32px; font-weight: 700; color: white; margin-bottom: 8px;", "15+"),
      div(style = "color: #e0e0e0; font-size: 13px; font-weight: 600;", "Analysis Tools")
    ),
    div(
      style = "background: linear-gradient(135deg, #ffa500 0%, #cc8400 100%); padding: 24px; border-radius: 8px; text-align: center;",
      div(style = "font-size: 32px; font-weight: 700; color: white; margin-bottom: 8px;", "600"),
      div(style = "color: #e0e0e0; font-size: 13px; font-weight: 600;", "DPI Export")
    ),
    div(
      style = "background: linear-gradient(135deg, #9b59b6 0%, #6c3483 100%); padding: 24px; border-radius: 8px; text-align: center;",
      div(style = "font-size: 32px; font-weight: 700; color: white; margin-bottom: 8px;", "A+"),
      div(style = "color: #e0e0e0; font-size: 13px; font-weight: 600;", "Code Quality")
    )
  ),

  # Key Features Section
  div(
    style = "width: 100%; margin: 40px 0;",
    h3(style = "color: #2e8b57; text-align: center; margin-bottom: 30px; font-size: 24px;", "🎯 Why Choose Ördin?"),
    div(
      style = "display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px;",
      # Feature 1
      div(
        style = "background: #252526; border-left: 4px solid #2e8b57; padding: 20px;",
        div(
          style = "display: flex; align-items: center; margin-bottom: 12px;",
          div(
            style = "width: 40px; height: 40px; background: #2e8b5720; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-right: 12px;",
            span(style = "font-size: 20px;", "🔬")
          ),
          h4(style = "color: #cccccc; margin: 0; font-size: 16px;", "Scientifically Rigorous")
        ),
        p(
          style = "color: #888; font-size: 13px; line-height: 1.6; margin: 0;",
          "Built on battle-tested R packages (vegan, iNEXT, betapart). Every analysis is reproducible and peer-reviewed."
        )
      ),
      # Feature 2
      div(
        style = "background: #252526; border-left: 4px solid #4a90e2; padding: 20px;",
        div(
          style = "display: flex; align-items: center; margin-bottom: 12px;",
          div(
            style = "width: 40px; height: 40px; background: #4a90e220; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-right: 12px;",
            span(style = "font-size: 20px;", "🎨")
          ),
          h4(style = "color: #cccccc; margin: 0; font-size: 16px;", "Beautiful & Intuitive")
        ),
        p(
          style = "color: #888; font-size: 13px; line-height: 1.6; margin: 0;",
          "Modern IDE-inspired interface with real-time plot customization. No R coding required."
        )
      ),
      # Feature 3
      div(
        style = "background: #252526; border-left: 4px solid #ffa500; padding: 20px;",
        div(
          style = "display: flex; align-items: center; margin-bottom: 12px;",
          div(
            style = "width: 40px; height: 40px; background: #ffa50020; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-right: 12px;",
            span(style = "font-size: 20px;", "📊")
          ),
          h4(style = "color: #cccccc; margin: 0; font-size: 16px;", "Publication-Ready")
        ),
        p(
          style = "color: #888; font-size: 13px; line-height: 1.6; margin: 0;",
          "Export high-resolution plots (up to 600 DPI) in PNG, PDF, SVG, or TIFF formats."
        )
      )
    )
  ),

  # Quick Start Actions
  div(
    class = "action-cards", style = "width: 100%; margin: 40px 0;",
    div(
      class = "card",
      div(style = "font-size: 48px; margin-bottom: 12px;", "📥"),
      h3("Import Data"),
      p("Load CSV, Excel, or explore sample datasets from vegan package"),
      tags$button(onclick = "switchView('data')", "Get Started →")
    ),
    div(
      class = "card",
      div(style = "font-size: 48px; margin-bottom: 12px;", "📈"),
      h3("Diversity Analysis"),
      p("iNEXT rarefaction, Hill numbers, Shannon & Simpson indices"),
      tags$button(onclick = "createNewTab('diversity', '📈 Diversity Analysis', 'diversity')", "Analyze →")
    ),
    div(
      class = "card",
      div(style = "font-size: 48px; margin-bottom: 12px;", "🗺️"),
      h3("Ordination"),
      p("NMDS, PCA, CA, DCA, CCA, RDA, db-RDA, CAP, PCoA methods"),
      tags$button(onclick = "createNewTab('ordination', '🗺️ Ordination', 'ordination')", "Explore →")
    ),
    div(
      class = "card",
      div(style = "font-size: 48px; margin-bottom: 12px;", "🦠"),
      h3("Beta Diversity"),
      p("Partitioning into turnover & nestedness components"),
      tags$button(onclick = "createNewTab('beta', '🦠 Beta Partitioning', 'beta')", "Partition →")
    )
  ),

  # Citation/Credit
  div(
    style = "width: 100%; margin: 50px 0 30px; padding: 20px; background: #1e1e1e; border-radius: 8px; text-align: center;",
    p(
      style = "color: #888; font-size: 12px; margin: 0 0 12px 0;",
      "Built with ❤️ for the ecology community"
    ),
    p(
      style = "color: #666; font-size: 11px; margin: 0;",
      HTML("Powered by <strong style='color: #4a90e2;'>R</strong>, <strong style='color: #2e8b57;'>vegan</strong>, <strong style='color: #ffa500;'>iNEXT</strong>, <strong style='color: #e74c3c;'>betapart</strong>, and <strong style='color: #9b59b6;'>Electron</strong>")
    )
  )
)
