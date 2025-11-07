// Dashboard card button functionality
// Makes the dashboard cards clickable and navigate to the correct views

// Function to create a new tab/view (alias for switchView)
function createNewTab(viewId, tabTitle, viewName) {
  console.log('Creating new tab:', viewId, tabTitle, viewName);
  // Simply switch to the view
  switchView(viewId);
}

// Initialize dashboard card buttons
$(document).ready(function() {
  console.log('Dashboard cards initialized');
});
