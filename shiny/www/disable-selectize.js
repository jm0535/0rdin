// Disable selectize.js globally for all select inputs
// This ensures clean HTML select dropdowns throughout the app

$(document).ready(function() {
  // Function to clean up select elements
  function cleanSelectElement(select) {
    const $select = $(select);
    
    // Destroy selectize if present
    if ($select.data('selectize')) {
      $select[0].selectize.destroy();
    }
    
    // Remove any checkbox/radio elements that appear before the select
    $select.siblings('input[type="checkbox"]').remove();
    $select.siblings('input[type="radio"]').remove();
    
    // Remove any icon elements
    $select.siblings('.icon, i, .checkbox-icon, .radio-icon').remove();
    
    // Remove empty divs that might contain checkboxes
    $select.parent().find('> div:empty').remove();
    
    // If the select is wrapped in extra divs, unwrap it
    const $container = $select.closest('.shiny-input-container');
    if ($container.length) {
      // Move select directly under the container
      $select.appendTo($container);
    }
  }
  
  // Clean all existing select inputs
  $('select').each(function() {
    cleanSelectElement(this);
  });
  
  // Override Shiny's selectize initialization
  if (typeof Shiny !== 'undefined') {
    Shiny.addCustomMessageHandler('selectize-init', function(message) {
      // Do nothing - prevent selectize initialization
    });
  }
  
  // Monitor for new select elements and clean them
  const observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
      mutation.addedNodes.forEach(function(node) {
        if (node.nodeType === 1) { // Element node
          const selects = node.querySelectorAll ? node.querySelectorAll('select') : [];
          selects.forEach(function(select) {
            cleanSelectElement(select);
          });
          
          // Also check if the node itself is a select
          if (node.tagName === 'SELECT') {
            cleanSelectElement(node);
          }
        }
      });
    });
  });
  
  observer.observe(document.body, {
    childList: true,
    subtree: true
  });
  
  // Run cleanup again after a short delay to catch any late-rendered elements
  setTimeout(function() {
    $('select').each(function() {
      cleanSelectElement(this);
    });
  }, 1000);
});
