// Disable selectize.js globally for all select inputs
// This ensures clean HTML select dropdowns throughout the app

$(document).ready(function() {
  console.log('Disable-selectize.js loaded');
  
  // Function to clean up select elements - simplified version
  function cleanSelectElement(select) {
    try {
      const $select = $(select);
      
      // Destroy selectize if present
      if ($select.data('selectize')) {
        $select[0].selectize.destroy();
      }
      
      // Remove any checkbox/radio elements that are siblings
      $select.siblings('input[type="checkbox"]').hide();
      $select.siblings('input[type="radio"]').hide();
      
      console.log('Cleaned select element:', select.id || select.name);
    } catch (e) {
      console.error('Error cleaning select:', e);
    }
  }
  
  // Clean all existing select inputs after page load
  setTimeout(function() {
    console.log('Running select cleanup...');
    $('select').each(function() {
      cleanSelectElement(this);
    });
  }, 500);
});
