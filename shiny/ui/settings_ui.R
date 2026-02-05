# Settings Tab Content
div(
  id = "tab-settings", class = "tab-content", style = "display: none;",
  h2(style = "color: #2e8b57; margin-bottom: 20px;", "⚙️ Settings"),

  # APPEARANCE SETTINGS
  div(
    id = "settings-appearance", class = "settings-section",
    div(
      style = "background: #252526; padding: 20px; margin-bottom: 20px; border-radius: 4px;",
      h3(style = "color: #ccc; margin-bottom: 16px;", "🌨️ Appearance"),
      div(
        style = "display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 16px;",
        div(
          class = "setting-item",
          tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "Font Family"),
          selectInput("settings_font", NULL,
            choices = c("System" = "system", "Sans" = "sans", "Serif" = "serif", "Mono" = "mono"),
            selected = "system",
            width = "100%",
            selectize = FALSE
          )
        ),
        div(
          class = "setting-item",
          tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "UI Zoom (%)"),
          sliderInput("settings_zoom", NULL, min = 75, max = 150, value = 100, step = 5, width = "100%")
        )
      ),

      # Save button for this section
      div(
        style = "margin-top: 20px;",
        actionButton("settings_save_appearance", "Apply Appearance Settings",
          style = "background: #2e8b57; color: white; border: none; padding: 10px 24px; border-radius: 4px; cursor: pointer;"
        )
      )
    )
  ),

  # PLOT DEFAULTS
  div(
    id = "settings-plot-defaults", class = "settings-section", style = "display: none;",
    div(
      style = "background: #252526; padding: 20px; margin-bottom: 20px; border-radius: 4px;",
      h3(style = "color: #ccc; margin-bottom: 16px;", "🎨 Plot Defaults"),
      div(
        style = "display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 16px;",
        div(
          class = "setting-item",
          tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "Default Theme"),
          selectInput("settings_plot_theme", NULL,
            choices = c(
              "Clean (bw)" = "bw", "Minimal" = "minimal", "Dark" = "dark",
              "Classic" = "classic", "Light" = "light", "Void" = "void"
            ),
            selected = "bw",
            width = "100%",
            selectize = FALSE
          )
        ),
        div(
          class = "setting-item",
          tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "Default DPI"),
          numericInput("settings_plot_dpi", NULL, value = 300, min = 72, max = 600, step = 50, width = "100%")
        ),
        div(
          class = "setting-item",
          tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "Default Format"),
          selectInput("settings_plot_format", NULL,
            choices = c("PDF" = "pdf", "PNG" = "png", "SVG" = "svg", "TIFF" = "tiff"),
            selected = "pdf",
            width = "100%",
            selectize = FALSE
          )
        ),
        div(
          class = "setting-item",
          tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "Width (inches)"),
          numericInput("settings_plot_width", NULL, value = 8, min = 3, max = 20, step = 1, width = "100%")
        ),
        div(
          class = "setting-item",
          tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "Height (inches)"),
          numericInput("settings_plot_height", NULL, value = 6, min = 3, max = 20, step = 1, width = "100%")
        )
      ),
      div(
        style = "margin-top: 20px;",
        actionButton("settings_save_plot", "Apply Plot Defaults",
          style = "background: #2e8b57; color: white; border: none; padding: 10px 24px; border-radius: 4px; cursor: pointer;"
        )
      )
    )
  ),

  # ANALYSIS DEFAULTS
  div(
    id = "settings-analysis-defaults", class = "settings-section", style = "display: none;",
    div(
      style = "background: #252526; padding: 20px; margin-bottom: 20px; border-radius: 4px;",
      h3(style = "color: #ccc; margin-bottom: 16px;", "🧪 Analysis Defaults"),
      div(
        style = "display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 16px;",
        div(
          class = "setting-item",
          tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "NMDS Distance"),
          selectInput("settings_nmds_distance", NULL,
            choices = c(
              "Bray-Curtis" = "bray", "Jaccard" = "jaccard", "Euclidean" = "euclidean",
              "Manhattan" = "manhattan", "Canberra" = "canberra"
            ),
            selected = "bray",
            width = "100%",
            selectize = FALSE
          )
        ),
        div(
          class = "setting-item",
          tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "NMDS Dimensions (k)"),
          numericInput("settings_nmds_k", NULL, value = 2, min = 2, max = 5, step = 1, width = "100%")
        ),
        div(
          class = "setting-item",
          tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "iNEXT Bootstrap"),
          numericInput("settings_inext_nboot", NULL, value = 50, min = 20, max = 200, step = 10, width = "100%")
        ),
        div(
          class = "setting-item",
          tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "Permutations"),
          numericInput("settings_permutations", NULL, value = 999, min = 99, max = 9999, step = 100, width = "100%")
        )
      ),
      div(
        style = "margin-top: 20px;",
        actionButton("settings_save_analysis", "Apply Analysis Defaults",
          style = "background: #2e8b57; color: white; border: none; padding: 10px 24px; border-radius: 4px; cursor: pointer;"
        )
      )
    )
  ),

  # DATA MANAGEMENT
  div(
    id = "settings-data-management", class = "settings-section", style = "display: none;",
    div(
      style = "background: #252526; padding: 20px; margin-bottom: 20px; border-radius: 4px;",
      h3(style = "color: #ccc; margin-bottom: 16px;", "📊 Data Management"),
      div(
        style = "display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 16px;",
        div(
          class = "setting-item",
          checkboxInput("settings_auto_save", "Auto-save results", value = FALSE)
        ),
        div(
          class = "setting-item",
          checkboxInput("settings_validation", "Enable data validation", value = TRUE)
        ),
        div(
          class = "setting-item",
          actionButton("settings_clear_data", "Clear All Data",
            style = "background: #d32f2f; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer;"
          )
        )
      )
    )
  ),

  # PERFORMANCE
  div(
    id = "settings-performance", class = "settings-section", style = "display: none;",
    div(
      style = "background: #252526; padding: 20px; margin-bottom: 20px; border-radius: 4px;",
      h3(style = "color: #ccc; margin-bottom: 16px;", "⚡ Performance"),
      div(
        style = "display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 16px;",
        div(
          class = "setting-item",
          tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "Performance Mode"),
          selectInput("settings_performance", NULL,
            choices = c("Standard" = "standard", "High Performance" = "high", "Eco" = "eco"),
            selected = "standard",
            width = "100%",
            selectize = FALSE
          )
        ),
        div(
          class = "setting-item",
          checkboxInput("settings_cache", "Enable result caching", value = TRUE)
        ),
        div(
          class = "setting-item",
          actionButton("settings_clear_cache", "Clear Browser Cache",
            style = "background: #424242; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer;"
          )
        )
      )
    )
  ),

  # ADVANCED SETTINGS
  div(
    id = "settings-advanced", class = "settings-section", style = "display: none;",
    div(
      style = "background: #252526; padding: 20px; margin-bottom: 20px; border-radius: 4px;",
      h3(style = "color: #ccc; margin-bottom: 16px;", "🔧 Advanced Settings"),
      div(
        style = "display: grid; grid-template-columns: 1fr; gap: 16px;",
        div(
          class = "setting-item",
          tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "R Configuration"),
          tags$pre(
            style = "background: #1e1e1e; color: #ccc; padding: 12px; border-radius: 4px; font-size: 12px;",
            "Version: 4.5.1\nPlatform: x86_64-w64-mingw32\nLibrary: C:/Program Files/R/R-4.5.1/library"
          )
        ),
        div(
          class = "setting-item",
          tags$label(style = "color: #888; font-size: 13px; display: block; margin-bottom: 8px;", "Package Versions"),
          tags$pre(
            style = "background: #1e1e1e; color: #ccc; padding: 12px; border-radius: 4px; font-size: 12px;",
            "vegan: 2.6-8\niNEXT: 3.0.1\nggplot2: 3.5.1\nshiny: 1.9.1"
          )
        )
      )
    )
  ),

  # ACTION BUTTONS
  div(
    style = "display: flex; gap: 12px; justify-content: flex-end; margin-top: 24px;",
    actionButton("settings_reset", "Reset to Defaults",
      style = "background: #757575; color: white; border: none; padding: 10px 24px; border-radius: 4px; cursor: pointer;"
    ),
    actionButton("settings_export", "Export Settings",
      style = "background: #424242; color: white; border: none; padding: 10px 24px; border-radius: 4px; cursor: pointer;"
    ),
    actionButton("settings_save", "Save Settings",
      style = "background: #2e8b57; color: white; border: none; padding: 10px 24px; border-radius: 4px; cursor: pointer;"
    )
  )
)
