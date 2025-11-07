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
  console.log('toggleTheme called with:', theme);
  const body = document.body;
  const root = document.documentElement;
  
  if (theme === 'dark') {
    console.log('Applying dark theme...');
    body.classList.remove('light-theme');
    body.classList.add('dark-theme');
    
    // Set CSS custom properties for dark theme
    root.style.setProperty('--bg-primary', '#1e1e1e');
    root.style.setProperty('--bg-secondary', '#252526');
    root.style.setProperty('--text-primary', '#cccccc');
    root.style.setProperty('--text-secondary', '#888888');
    
    // Update Shiny input
    if (typeof Shiny !== 'undefined') {
      Shiny.setInputValue('settings_theme', 'dark');
    }
  } else if (theme === 'light') {
    console.log('Applying light theme...');
    body.classList.remove('dark-theme');
    body.classList.add('light-theme');
    
    // Set CSS custom properties for light theme
    root.style.setProperty('--bg-primary', '#ffffff');
    root.style.setProperty('--bg-secondary', '#f5f5f5');
    root.style.setProperty('--text-primary', '#1e1e1e');
    root.style.setProperty('--text-secondary', '#4a4a4a');
    
    // Directly modify body background
    body.style.backgroundColor = '#ffffff';
    body.style.color = '#1e1e1e';
    
    // Modify main content areas
    const mainContent = document.querySelector('.main-content');
    if (mainContent) {
      mainContent.style.backgroundColor = '#ffffff';
      mainContent.style.color = '#1e1e1e';
    }
    
    const sidebar = document.querySelector('.sidebar');
    if (sidebar) {
      sidebar.style.backgroundColor = '#e8e8e8';
      sidebar.style.borderRight = '1px solid #d0d0d0';
    }
    
    const tabContents = document.querySelectorAll('.tab-content');
    tabContents.forEach(tab => {
      tab.style.backgroundColor = '#ffffff';
      tab.style.color = '#1e1e1e';
    });
    
    console.log('Light theme applied with inline styles');
    
    // Update Shiny input
    if (typeof Shiny !== 'undefined') {
      Shiny.setInputValue('settings_theme', 'light');
    }
  }
  
  console.log('Theme toggle complete. Body classes:', body.className);
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
