// Settings page navigation
// Handles switching between different settings sections

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
  
  // Update navigation active state
  const navItems = document.querySelectorAll('.settings-nav-item');
  navItems.forEach(item => {
    item.classList.remove('active');
  });
  
  // Add active class to clicked item
  event.target.classList.add('active');
}

// Initialize settings page
$(document).ready(function() {
  console.log('Settings navigation initialized');
});
