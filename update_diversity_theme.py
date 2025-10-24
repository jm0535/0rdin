import re

# Read the file
with open(r'c:\Users\UOTSTD933\Documents\workspace\jmoses\github_projects\ordin\shiny\app.R', 'r', encoding='utf-8') as f:
    content = f.read()

# Define the pattern to find the theme section
pattern = r'# Set theme colors with improved contrast based on selected theme\s+if \(plot_theme == "dark"\) \{.*?\} else \{.*?\# Default to minimal \(global default\).*?\#e8e8e8"\s+\}'

# Define the replacement
replacement = '''# Set theme colors with improved contrast based on selected theme
    if (plot_theme == "dark") {
      bg_color <- "#1a1a1a"  # Darker for better contrast
      text_color <- "#ffffff"
      grid_color <- "#3a3a3a"  # More visible grid
      panel_border <- element_blank()
      grid_linewidth <- 0.3
    } else if (plot_theme == "light") {
      bg_color <- "#ffffff"
      text_color <- "#000000"
      grid_color <- "#d0d0d0"  # More visible grid
      panel_border <- element_blank()
      grid_linewidth <- 0.4
    } else if (plot_theme == "classic") {
      bg_color <- "#fafafa"  # Slightly off-white
      text_color <- "#000000"
      grid_color <- "#b0b0b0"  # Darker grid
      panel_border <- element_rect(color = "#000000", fill = NA, linewidth = 1)
      grid_linewidth <- 0.5
    } else if (plot_theme == "minimal") {
      bg_color <- "#ffffff"
      text_color <- "#1a1a1a"  # Dark gray for softer contrast
      grid_color <- "#e8e8e8"  # Very subtle grid
      panel_border <- element_blank()
      grid_linewidth <- 0.2
    } else if (plot_theme == "publication") {
      bg_color <- "#ffffff"
      text_color <- "#000000"
      grid_color <- "#c0c0c0"  # Strong grid for clarity
      panel_border <- element_rect(color = "#000000", fill = NA, linewidth = 1.2)
      grid_linewidth <- 0.6
    } else {
      # Default to minimal (global default)
      bg_color <- "#ffffff"
      text_color <- "#1a1a1a"
      grid_color <- "#e8e8e8"
      panel_border <- element_blank()
      grid_linewidth <- 0.2
    }'''

# Replace the content
updated_content = re.sub(pattern, replacement, content, flags=re.DOTALL)

# Write the updated content back to the file
with open(r'c:\Users\UOTSTD933\Documents\workspace\jmoses\github_projects\ordin\shiny\app.R', 'w', encoding='utf-8') as f:
    f.write(updated_content)

print("File updated successfully!")