// Plot Customization Right Panel Manager
// Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
// Dynamically shows/hides plot customization based on active module

let currentPlotType = null;

// Show plot customization panel for specific plot type
function showPlotCustomization(plotType, moduleId) {
  const rightPanel = document.getElementById('rightPanel');
  const panelContent = rightPanel.querySelector('.panel-content');
  
  if (!rightPanel || !panelContent) return;
  
  currentPlotType = plotType;
  
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
  
  // Re-bind Shiny inputs if needed
  if (window.Shiny) {
    Shiny.unbindAll(panelContent);
    Shiny.bindAll(panelContent);
  }
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
  // Common controls for all plot types with proper Shiny input IDs
  const commonControls = `
    <div class="prop-section">
      <h4><i class="fas fa-palette"></i> Theme & Style</h4>
      
      <div class="prop-item">
        <label for="${moduleId}-plot_theme">Theme:</label>
        <select id="${moduleId}-plot_theme" class="shiny-input-select form-control form-control-sm">
          <option value="bw" selected>Clean</option>
          <option value="minimal">Minimal</option>
          <option value="dark">Dark</option>
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
  
  return commonControls;
}

// Initialize - hide panel by default
$(document).ready(function() {
  hidePlotCustomization();
});
