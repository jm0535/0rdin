// Plot Customization Right Panel Manager
// Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
// Dynamically shows/hides plot customization based on active module

let currentPlotType = null;

// Show plot customization panel for specific plot type
function showPlotCustomization(plotType, moduleId) {
  const rightPanel = document.getElementById('rightPanel');
  const panelContent = rightPanel.querySelector('.panel-content');
  
  if (!rightPanel || !panelContent) {
    console.error('Right panel or content not found!');
    return;
  }
  
  currentPlotType = plotType;
  
  console.log('showPlotCustomization called:', plotType, moduleId);
  
  // Open the right panel
  rightPanel.classList.remove('collapsed');
  
  // Update panel header title
  const panelHeader = rightPanel.querySelector('.panel-header span');
  if (panelHeader) {
    panelHeader.textContent = 'PLOT CUSTOMIZATION';
  }
  
  // Generate customization UI based on plot type
  const customizationHTML = generatePlotCustomizationUI(plotType, moduleId);
  
  // Update panel content
  panelContent.innerHTML = customizationHTML;
  
  // CRITICAL: Re-bind Shiny inputs for dynamic controls
  if (window.Shiny && window.Shiny.unbindAll && window.Shiny.bindAll) {
    console.log('Unbinding and rebinding Shiny inputs...');
    Shiny.unbindAll(panelContent);
    Shiny.bindAll(panelContent);
    console.log('Shiny inputs rebound successfully');
  } else {
    console.warn('Shiny binding functions not available!');
  }
  
  // Log all generated input IDs
  const inputs = panelContent.querySelectorAll('input, select');
  console.log(`Generated ${inputs.length} inputs:`, Array.from(inputs).map(i => i.id));
}

// Hide plot customization panel
function hidePlotCustomization() {
  const rightPanel = document.getElementById('rightPanel');
  if (rightPanel) {
    rightPanel.classList.add('collapsed');
  }
  currentPlotType = null;
}

// Generate HTML for plot customization controls
function generatePlotCustomizationUI(plotType, moduleId) {
  
  // Check if this is a diversity/iNEXT module
  if (plotType === 'diversity_estimation' || plotType === 'inext' || moduleId === 'estimation') {
    return generateDiversityPlotControls(moduleId);
  }
  
  // Otherwise, return ordination plot controls
  return generateOrdinationPlotControls(moduleId);
}

// Generate controls for diversity/iNEXT plots (ggplot2-based)
function generateDiversityPlotControls(moduleId) {
  return `
    <div class="prop-section">
      <h4><i class="fas fa-palette"></i> Theme & Style</h4>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_plot_theme">Theme:</label>
        <select id="${moduleId}-plot_plot_theme" class="shiny-input-select form-control form-control-sm">
          <option value="bw" selected>Clean</option>
          <option value="minimal">Minimal</option>
          <option value="classic">Classic</option>
          <option value="light">Light</option>
          <option value="dark">Dark</option>
          <option value="void">Void</option>
        </select>
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_font_family">Font Family:</label>
        <select id="${moduleId}-plot_font_family" class="shiny-input-select form-control form-control-sm">
          <option value="sans" selected>Sans</option>
          <option value="serif">Serif</option>
          <option value="mono">Mono</option>
        </select>
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_base_size">Base Font Size:</label>
        <input type="number" id="${moduleId}-plot_base_size" class="shiny-input-number form-control form-control-sm" 
               value="12" min="8" max="20" step="1">
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_title_size">Title Size:</label>
        <input type="number" id="${moduleId}-plot_title_size" class="shiny-input-number form-control form-control-sm" 
               value="14" min="10" max="24" step="1">
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_axis_title_size">Axis Title Size:</label>
        <input type="number" id="${moduleId}-plot_axis_title_size" class="shiny-input-number form-control form-control-sm" 
               value="12" min="8" max="18" step="1">
      </div>
    </div>
    
    <div class="prop-section">
      <h4><i class="fas fa-chart-line"></i> Lines & Ribbons</h4>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_line_size">Line Width:</label>
        <input type="number" id="${moduleId}-plot_line_size" class="shiny-input-number form-control form-control-sm" 
               value="1.0" min="0.5" max="3" step="0.25">
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_point_size">Point Size:</label>
        <input type="number" id="${moduleId}-plot_point_size" class="shiny-input-number form-control form-control-sm" 
               value="2" min="0.5" max="5" step="0.5">
      </div>
      
      <div class="prop-item">
        <label>
          <input type="checkbox" id="${moduleId}-plot_show_ci" class="shiny-input-checkbox" checked> Show CI Ribbons
        </label>
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_ci_alpha">CI Transparency:</label>
        <input type="number" id="${moduleId}-plot_ci_alpha" class="shiny-input-number form-control form-control-sm" 
               value="0.3" min="0.1" max="1" step="0.1">
      </div>
    </div>
    
    <div class="prop-section">
      <h4><i class="fas fa-text-width"></i> Legend & Facets</h4>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_legend_size">Legend Text Size:</label>
        <input type="number" id="${moduleId}-plot_legend_size" class="shiny-input-number form-control form-control-sm" 
               value="10" min="6" max="16" step="1">
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_legend_rows">Legend Rows:</label>
        <input type="number" id="${moduleId}-plot_legend_rows" class="shiny-input-number form-control form-control-sm" 
               value="2" min="1" max="5" step="1">
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_strip_size">Facet Label Size:</label>
        <input type="number" id="${moduleId}-plot_strip_size" class="shiny-input-number form-control form-control-sm" 
               value="12" min="8" max="18" step="1">
      </div>
    </div>
    
    <div class="prop-section">
      <h4><i class="fas fa-border-all"></i> Axes & Grid</h4>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_axis_lwd">Axis Line Width:</label>
        <input type="number" id="${moduleId}-plot_axis_lwd" class="shiny-input-number form-control form-control-sm" 
               value="0.5" min="0.25" max="2" step="0.25">
      </div>
      
      <div class="prop-item">
        <label>
          <input type="checkbox" id="${moduleId}-plot_show_grid_minor" class="shiny-input-checkbox"> Minor Grid Lines
        </label>
      </div>
    </div>
    
    <div class="prop-section">
      <h4><i class="fas fa-file-export"></i> Export Settings</h4>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_plot_width">Width (inches):</label>
        <input type="number" id="${moduleId}-plot_plot_width" class="shiny-input-number form-control form-control-sm" 
               value="14" min="6" max="24" step="1">
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_plot_height">Height (inches):</label>
        <input type="number" id="${moduleId}-plot_plot_height" class="shiny-input-number form-control form-control-sm" 
               value="8" min="4" max="16" step="1">
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_plot_dpi">DPI:</label>
        <input type="number" id="${moduleId}-plot_plot_dpi" class="shiny-input-number form-control form-control-sm" 
               value="300" min="72" max="600" step="50">
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_export_format">Format:</label>
        <select id="${moduleId}-plot_export_format" class="shiny-input-select form-control form-control-sm">
          <option value="png" selected>PNG</option>
          <option value="pdf">PDF</option>
          <option value="svg">SVG</option>
          <option value="tiff">TIFF</option>
        </select>
      </div>
    </div>
  `;
}

// Generate controls for ordination plots (ggplot2-based)
function generateOrdinationPlotControls(moduleId) {
  // Common controls for all plot types with proper Shiny input IDs
  return `
    <div class="prop-section">
      <h4><i class="fas fa-palette"></i> Theme & Style</h4>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_theme">Theme:</label>
        <select id="${moduleId}-plot_theme" class="shiny-input-select form-control form-control-sm">
          <option value="bw" selected>Clean</option>
          <option value="minimal">Minimal</option>
          <option value="classic">Classic</option>
          <option value="light">Light</option>
          <option value="dark">Dark</option>
          <option value="void">Void</option>
        </select>
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_font_family">Font Family:</label>
        <select id="${moduleId}-plot_font_family" class="shiny-input-select form-control form-control-sm">
          <option value="sans" selected>Sans</option>
          <option value="serif">Serif</option>
          <option value="mono">Mono</option>
        </select>
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_base_size">Base Font Size:</label>
        <input type="number" id="${moduleId}-plot_base_size" class="shiny-input-number form-control form-control-sm" 
               value="12" min="8" max="20" step="1">
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_title_size">Title Size:</label>
        <input type="number" id="${moduleId}-plot_title_size" class="shiny-input-number form-control form-control-sm" 
               value="14" min="10" max="24" step="1">
      </div>
    </div>
    
    <div class="prop-section">
      <h4><i class="fas fa-circle"></i> Points & Markers</h4>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_point_size">Point Size:</label>
        <input type="number" id="${moduleId}-plot_point_size" class="shiny-input-number form-control form-control-sm" 
               value="2" min="0.5" max="5" step="0.5">
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_point_shape">Point Shape:</label>
        <select id="${moduleId}-plot_point_shape" class="shiny-input-select form-control form-control-sm">
          <option value="21" selected>Circle</option>
          <option value="22">Square</option>
          <option value="23">Diamond</option>
          <option value="24">Triangle</option>
        </select>
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_point_color">Point Color:</label>
        <select id="${moduleId}-plot_point_color" class="shiny-input-select form-control form-control-sm">
          <option value="#2e8b57" selected>Ördin Green</option>
          <option value="#007acc">Blue</option>
          <option value="#d4a017">Orange</option>
          <option value="#e74c3c">Red</option>
          <option value="#9b59b6">Purple</option>
          <option value="#1abc9c">Teal</option>
        </select>
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_point_lwd">Border Width:</label>
        <input type="number" id="${moduleId}-plot_point_lwd" class="shiny-input-number form-control form-control-sm" 
               value="1.5" min="0.5" max="3" step="0.5">
      </div>
    </div>
    
    <div class="prop-section">
      <h4><i class="fas fa-draw-polygon"></i> Confidence Ellipses</h4>
      
      <div class="prop-item">
        <label>
          <input type="checkbox" id="${moduleId}-plot_show_ellipses" class="shiny-input-checkbox"> Show Ellipses
        </label>
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_group_var">Grouping Variable:</label>
        <select id="${moduleId}-plot_group_var" class="shiny-input-select form-control form-control-sm">
          <option value="" selected>None</option>
        </select>
        <small class="text-muted">Requires environmental data</small>
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_ellipse_type">Ellipse Type:</label>
        <select id="${moduleId}-plot_ellipse_type" class="shiny-input-select form-control form-control-sm">
          <option value="norm" selected>Normal</option>
          <option value="t">Student's t</option>
          <option value="euclid">Euclidean</option>
        </select>
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_ellipse_level">Confidence Level:</label>
        <input type="number" id="${moduleId}-plot_ellipse_level" class="shiny-input-number form-control form-control-sm" 
               value="0.95" min="0.50" max="0.99" step="0.05">
      </div>
    </div>
    
    <div class="prop-section">
      <h4><i class="fas fa-tags"></i> Labels & Grid</h4>
      
      <div class="prop-item">
        <label>
          <input type="checkbox" id="${moduleId}-plot_show_grid" class="shiny-input-checkbox" checked> Show Grid
        </label>
      </div>
      
      <div class="prop-item">
        <label>
          <input type="checkbox" id="${moduleId}-plot_show_labels" class="shiny-input-checkbox"> Site Labels
        </label>
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_label_size">Label Size:</label>
        <input type="number" id="${moduleId}-plot_label_size" class="shiny-input-number form-control form-control-sm" 
               value="0.8" min="0.3" max="2" step="0.1">
      </div>
    </div>
    
    <div class="prop-section">
      <h4><i class="fas fa-file-export"></i> Export Settings</h4>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_width">Width (inches):</label>
        <input type="number" id="${moduleId}-plot_width" class="shiny-input-number form-control form-control-sm" 
               value="8" min="4" max="20" step="1">
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_height">Height (inches):</label>
        <input type="number" id="${moduleId}-plot_height" class="shiny-input-number form-control form-control-sm" 
               value="6" min="4" max="16" step="1">
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_dpi">DPI:</label>
        <input type="number" id="${moduleId}-plot_dpi" class="shiny-input-number form-control form-control-sm" 
               value="300" min="72" max="600" step="50">
      </div>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_export_format">Format:</label>
        <select id="${moduleId}-plot_export_format" class="shiny-input-select form-control form-control-sm">
          <option value="png" selected>PNG</option>
          <option value="pdf">PDF</option>
          <option value="svg">SVG</option>
        </select>
      </div>
    </div>
  `;
}

// Initialize - hide panel by default
$(document).ready(function() {
  hidePlotCustomization();
  
  // Listen for custom messages from R to update grouping variable dropdown
  if (window.Shiny) {
    Shiny.addCustomMessageHandler('updateGroupingVar', function(message) {
      const selectId = message.moduleId + 'plot_group_var';
      const selectElement = document.getElementById(selectId);
      
      if (selectElement && message.choices) {
        // Clear existing options
        selectElement.innerHTML = '';
        
        // Add new options
        Object.keys(message.choices).forEach(function(key) {
          const option = document.createElement('option');
          option.value = key;
          option.textContent = message.choices[key];
          selectElement.appendChild(option);
        });
        
        console.log('Updated grouping variable dropdown with', Object.keys(message.choices).length, 'options');
      }
    });
  }
});
