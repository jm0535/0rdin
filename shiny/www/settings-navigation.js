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

// Initialize settings page
$(document).ready(function() {
  console.log('Settings navigation initialized');
  
  // Show appearance section by default
  showSettingsSection('appearance');
});
