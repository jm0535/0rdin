// Disable selectize.js globally for all select inputs
// This ensures clean HTML select dropdowns throughout the app

$(document).ready(function() {
  // Disable selectize for all existing select inputs
  $('select').each(function() {
    if ($(this).data('selectize')) {
      $(this)[0].selectize.destroy();
    }
  });
  
  // Override Shiny's selectize initialization
  if (typeof Shiny !== 'undefined') {
    Shiny.addCustomMessageHandler('selectize-init', function(message) {
      // Do nothing - prevent selectize initialization
    });
  }
  
  // Monitor for new select elements and prevent selectize
  const observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
      mutation.addedNodes.forEach(function(node) {
        if (node.nodeType === 1) { // Element node
          const selects = node.querySelectorAll ? node.querySelectorAll('select') : [];
          selects.forEach(function(select) {
            if (select.selectize) {
              select.selectize.destroy();
            }
          });
        }
      });
    });
  });
  
  observer.observe(document.body, {
    childList: true,
    subtree: true
  });
});
