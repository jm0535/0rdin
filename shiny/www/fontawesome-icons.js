// Font Awesome Icon Replacement for Ördin Sidebar
// DISABLED - Replacing HTML destroys onclick handlers
// Activity bar icons are handled directly in app.R

// $(document).ready(function() {
//   // Wait a bit for sidebar content to load
//   setTimeout(function() {
//     replaceSidebarIcons();
//   }, 500);
// });

// ENTIRE FUNCTION COMMENTED OUT TO PRESERVE CLICK HANDLERS
/*
function replaceSidebarIcons() {
  // Icon mapping: emoji/text → Font Awesome class
  const iconMap = {
    // Diversity sidebar
    '📈': 'fa-chart-area',
    '📊': 'fa-chart-bar',
    '📉': 'fa-chart-line',
    '⚙️': 'fa-sliders-h',
    '🔢': 'fa-sort-numeric-up',
    '🎯': 'fa-bullseye',
    '🔗': 'fa-link',
    '🔥': 'fa-fire',
    
    // Ordination sidebar
    '🔵': 'fa-circle',
    '🔷': 'fa-square',
    '🔶': 'fa-diamond',
    '🟦': 'fa-stop',
    '⬡': 'fa-hexagon',
    '🟢': 'fa-circle',
    '🟡': 'fa-circle',
    '🔴': 'fa-circle',
    '🌍': 'fa-globe',
    '🎨': 'fa-palette',
    '📏': 'fa-ruler',
    '🏷️': 'fa-tag',
    '🧩': 'fa-puzzle-piece',
    
    // Statistical Tests sidebar
    '🧪': 'fa-flask',
    '🎲': 'fa-dice',
    '📐': 'fa-ruler-combined',
    
    // Beta Partitioning sidebar
    '🦠': 'fa-bacteria',
    '🧬': 'fa-dna',
    '🌳': 'fa-tree',
    '⏱️': 'fa-stopwatch',
    '📍': 'fa-map-marker-alt',
    '🔄': 'fa-sync-alt',
    '🗺️': 'fa-map',
    '🌐': 'fa-globe-americas',
    
    // Data sidebar
    '💻': 'fa-laptop',
    '☁️': 'fa-cloud',
    '📚': 'fa-book',
    '📄': 'fa-file-alt',
    '✅': 'fa-check-circle',
    '🔍': 'fa-search',
    '√': 'fa-square-root-alt',
    
    // Results sidebar
    '💾': 'fa-save',
    '📑': 'fa-file-excel',
    '🖼️': 'fa-image',
    '📝': 'fa-file-code',
    '📁': 'fa-folder',
    
    // Settings sidebar
    '🌙': 'fa-moon',
    '☀️': 'fa-sun',
    '🔤': 'fa-font',
    '🔔': 'fa-bell',
    '🔧': 'fa-wrench',
    '📦': 'fa-box',
    '🗑️': 'fa-trash-alt',
    '⚡': 'fa-bolt',
    
    // Help sidebar
    '📖': 'fa-book-open',
    '🎓': 'fa-graduation-cap',
    '🎥': 'fa-video',
    '❓': 'fa-question-circle',
    '🐛': 'fa-bug',
    '💡': 'fa-lightbulb',
    '👥': 'fa-users',
    'ℹ️': 'fa-info-circle',
    '👤': 'fa-user',
    '📜': 'fa-scroll',
    '⭐': 'fa-star',
    
    // Home sidebar
    '📥': 'fa-file-import',
    '✓': 'fa-check',
    '📇': 'fa-address-card'
  };
  
  // CRITICAL FIX: Use text nodes instead of .html() to preserve event handlers
  $('.sidebar-content .item').each(function() {
    const $item = $(this);
    
    // Skip if already processed
    if ($item.data('fa-processed')) return;
    
    // Get the text content
    const textContent = $item.text().trim();
    
    // Check if any emoji exists in the text
    let hasEmoji = false;
    let faIcon = null;
    
    Object.keys(iconMap).forEach(function(emoji) {
      if (textContent.includes(emoji)) {
        hasEmoji = true;
        faIcon = iconMap[emoji];
        // Use the first match
        return false;
      }
    });
    
    if (hasEmoji && faIcon) {
      // Prepend Font Awesome icon without destroying the element
      const $icon = $('<i class="fas ' + faIcon + '" style="margin-right: 8px;"></i>');
      $item.prepend($icon);
      
      // Remove emoji from text (but keep the rest)
      const textNode = $item.contents().filter(function() {
        return this.nodeType === 3; // Text node
      });
      
      textNode.each(function() {
        Object.keys(iconMap).forEach(function(emoji) {
          this.nodeValue = this.nodeValue.replace(emoji, '');
        }.bind(this));
      });
      
      // Mark as processed
      $item.data('fa-processed', true);
    }
  });
  
  console.log('✓ Font Awesome icons applied to sidebar');
}
*/

// Re-apply icons when sidebar content changes (DISABLED - causes issues)
// function observeSidebarChanges() {
//   const sidebarContent = document.getElementById('sidebar-content');
//   if (!sidebarContent) return;
//   
//   const observer = new MutationObserver(function(mutations) {
//     replaceSidebarIcons();
//   });
//   
//   observer.observe(sidebarContent, {
//     childList: true,
//     subtree: true
//   });
// }

// Initialize observer when document is ready (DISABLED)
// $(document).ready(function() {
//   setTimeout(observeSidebarChanges, 1000);
// });
