import re

# Read the app.R file
with open('shiny/app.R', 'r', encoding='utf-8') as f:
    content = f.read()

# Replace the Data Management sidebar with ordination-style sidebar
data_sidebar_pattern = r'# DATA MANAGEMENT TAB\s+nav_panel\(\s+title = "Data",\s+icon = icon\("database"\),\s+[^}]+?layout_sidebar\(\s+sidebar = sidebar\(\s+width = 350,[^}]+?\)\s+\)[^}]+?\)[^}]+?\)'
data_sidebar_replacement = '''# DATA MANAGEMENT TAB
  nav_panel(
    title = "Data",
    icon = icon("database"),
    layout_sidebar(
      sidebar = sidebar(
        width = 350,
        card(
          card_header(
            "Data Management"
          ),
          card_body(
            uiOutput("dataSettingsContent")
          )
        )
      ),
      # Main Content Area
      tags$div(
        style = "flex: 1; overflow-y: auto; background: #1a1a1a;",
        uiOutput("dataMainContent")
      )
    )
  )'''

# Replace the Diversity Analysis sidebar with ordination-style sidebar
diversity_sidebar_pattern = r'# DIVERSITY ANALYSIS\s+nav_panel\(\s+title = "Diversity Analysis",\s+icon = icon\("chart-line"\),\s+[^}]+?layout_sidebar\(\s+sidebar = sidebar\(\s+width = 350,[^}]+?\)\s+\)[^}]+?\)[^}]+?\)'
diversity_sidebar_replacement = '''# DIVERSITY ANALYSIS
  nav_panel(
    title = "Diversity Analysis",
    icon = icon("chart-line"),
    layout_sidebar(
      sidebar = sidebar(
        width = 350,
        card(
          card_header(
            "Diversity Analysis Settings"
          ),
          card_body(
            # Data Status
            uiOutput("diversityDataStatus"),
            
            tags$hr(style = "border-color: #444; margin: 20px 0;"),
            
            # Dynamic settings based on sub-nav
            uiOutput("diversitySettingsContent")
          )
        )
      ),
      # Main Content Area
      tags$div(
        style = "flex: 1; overflow-y: auto; background: #1a1a1a;",
        uiOutput("diversityMainContent")
      )
    )
  )'''

# Perform the replacements
content = re.sub(data_sidebar_pattern, data_sidebar_replacement, content, flags=re.DOTALL)
content = re.sub(diversity_sidebar_pattern, diversity_sidebar_replacement, content, flags=re.DOTALL)

# Write the updated content back to the file
with open('shiny/app.R', 'w', encoding='utf-8') as f:
    f.write(content)

print("Sidebars updated successfully!")