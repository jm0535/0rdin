// Settings page navigation
// Handles switching between different settings sections using the existing sidebar

function showSettingsSection(sectionId) {
  console.log('Switching to settings section:', sectionId);
  
  // Hide all settings sections
  const sections = document.querySelectorAll('.settings-section');
  sections.forEach(section => {
    section.style.display = 'none';
  });
  
  // Show the selected section
  const targetSection = document.getElementById('settings-' + sectionId);
  if (targetSection) {
    targetSection.style.display = 'block';
  }
}

// Dark/Light Theme Toggle
function toggleTheme(theme) {
  console.log('Toggling theme to:', theme);
  const body = document.body;
  
  if (theme === 'dark') {
    body.classList.remove('light-theme');
    body.classList.add('dark-theme');
    // Update Shiny input
    if (typeof Shiny !== 'undefined') {
      Shiny.setInputValue('settings_theme', 'dark');
    }
  } else if (theme === 'light') {
    body.classList.remove('dark-theme');
    body.classList.add('light-theme');
    // Update Shiny input
    if (typeof Shiny !== 'undefined') {
      Shiny.setInputValue('settings_theme', 'light');
    }
  }
}

// Font Size Adjustment
function adjustFontSize(action) {
  console.log('Adjusting font size:', action);
  const root = document.documentElement;
  const currentSize = parseFloat(getComputedStyle(root).fontSize);
  
  if (action === 'increase') {
    root.style.fontSize = (currentSize + 1) + 'px';
  } else if (action === 'decrease') {
    root.style.fontSize = Math.max(12, currentSize - 1) + 'px';
  }
}

// Reset Zoom
function resetZoom() {
  console.log('Resetting zoom');
  const root = document.documentElement;
  root.style.fontSize = '14px';
  
  // Update Shiny slider if it exists
  if (typeof Shiny !== 'undefined') {
    Shiny.setInputValue('settings_zoom', 100);
  }
}

// Initialize settings page
$(document).ready(function() {
  console.log('Settings navigation initialized');
  
  // Show appearance section by default
  showSettingsSection('appearance');
  
  // Listen for theme changes from Shiny
  if (typeof Shiny !== 'undefined') {
    Shiny.addCustomMessageHandler('applyTheme', function(theme) {
      console.log('Applying theme from Shiny:', theme);
      toggleTheme(theme);
    });
    
    Shiny.addCustomMessageHandler('applyFont', function(font) {
      console.log('Applying font from Shiny:', font);
      const body = document.body;
      body.style.fontFamily = font === 'system' ? '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif' :
                              font === 'sans' ? 'Arial, Helvetica, sans-serif' :
                              font === 'serif' ? 'Georgia, "Times New Roman", serif' :
                              font === 'mono' ? '"Courier New", Courier, monospace' :
                              '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif';
    });
  }
});
