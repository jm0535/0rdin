// ============== DIVERSITY SIDEBAR ==============
function getSidebarDiversity() {
  return `
    <div class="section">
      <div class="section-header">▼ ANALYSIS TYPE</div>
      <div class="section-content">
        <div class="item active" onclick="showShinyTab('tab-diversity')" style="cursor: pointer;">📈 Diversity Estimation (iNEXT)</div>
        <div class="item" onclick="showShinyTab('tab-diversity')" style="cursor: pointer;">📊 Diversity Indices (vegan)</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ PLOT OPTIONS</div>
      <div class="section-content">
        <div class="item" onclick="alert('Configure in main panel')" style="cursor: pointer;">📉 Sample-Size Based</div>
        <div class="item" onclick="alert('Configure in main panel')" style="cursor: pointer;">📈 Sample Completeness</div>
        <div class="item" onclick="alert('Configure in main panel')" style="cursor: pointer;">📊 Coverage-Based</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ PARAMETERS</div>
      <div class="section-content">
        <div class="item" onclick="alert('Set in main panel')" style="cursor: pointer;">⚙️ Confidence Level</div>
        <div class="item" onclick="alert('Set in main panel')" style="cursor: pointer;">🔢 Knots</div>
        <div class="item" onclick="alert('Set in main panel')" style="cursor: pointer;">🎯 Endpoint</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ VISUALIZATION</div>
      <div class="section-content">
        <div class="item" onclick="showPlotCustomization('diversity_estimation', 'diversity_est')" style="cursor: pointer;">🎨 Customize Plot (Right Panel)</div>
        <div class="item" onclick="alert('Configure in main panel')" style="cursor: pointer;">📏 Axis Options</div>
        <div class="item" onclick="alert('Configure in main panel')" style="cursor: pointer;">🏷️ Labels & Legend</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ COMPARISON TOOLS</div>
      <div class="section-content">
        <div class="item" onclick="alert('Coming soon!')" style="cursor: pointer;">📊 Compare Assemblages</div>
        <div class="item" onclick="switchView('beta')" style="cursor: pointer;">🦠 Beta Diversity (see Beta tab →)</div>
        <div class="item" onclick="alert('Coming soon!')" style="cursor: pointer;">🔥 Similarity Indices</div>
      </div>
    </div>
  `;
}

// ============== ORDINATION SIDEBAR ==============
function getSidebarOrdination() {
  return `
    <div class="section">
      <div class="section-header">▼ UNCONSTRAINED ORDINATION</div>
      <div class="section-content">
        <div class="item active" onclick="showShinyTab('tab-ordination')" style="cursor: pointer;">🔵 NMDS</div>
        <div class="item" onclick="showShinyTab('tab-ordination')" style="cursor: pointer;">🔷 PCA</div>
        <div class="item" onclick="showShinyTab('tab-ordination')" style="cursor: pointer;">🔶 CA</div>
        <div class="item" onclick="showShinyTab('tab-ordination')" style="cursor: pointer;">🟦 DCA</div>
        <div class="item" onclick="showShinyTab('tab-ordination')" style="cursor: pointer;">⬡ PCoA</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ CONSTRAINED ORDINATION</div>
      <div class="section-content">
        <div class="item" onclick="alert('RDA - Coming soon!')" style="cursor: pointer;">🟢 RDA (Redundancy Analysis)</div>
        <div class="item" onclick="alert('CCA - Coming soon!')" style="cursor: pointer;">🟡 CCA (Canonical Correspondence)</div>
        <div class="item" onclick="alert('db-RDA - Coming soon!')" style="cursor: pointer;">🔴 db-RDA (Distance-based RDA)</div>
        <div class="item" onclick="alert('CAP - Coming soon!')" style="cursor: pointer;">🔵 CAP (Constrained Analysis Principal Coord)</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ DATASETS</div>
      <div class="section-content">
        <div class="item" onclick="showShinyTab('tab-data')" style="cursor: pointer;">📊 Species Data <span class="badge success">Loaded</span></div>
        <div class="item" onclick="showShinyTab('tab-data')" style="cursor: pointer;">🌍 Environmental Data <span class="badge">Optional</span></div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ STATISTICAL TESTS</div>
      <div class="section-content">
        <div class="item" onclick="alert('PERMANOVA - Coming soon!')" style="cursor: pointer;">🧪 PERMANOVA</div>
        <div class="item" onclick="alert('ANOSIM - Coming soon!')" style="cursor: pointer;">📊 ANOSIM</div>
        <div class="item" onclick="alert('Mantel - Coming soon!')" style="cursor: pointer;">🔗 Mantel Test</div>
        <div class="item" onclick="alert('envfit - Coming soon!')" style="cursor: pointer;">🌍 envfit (Variable Fitting)</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ VISUALIZATION</div>
      <div class="section-content">
        <div class="item" onclick="showPlotCustomization('nmds', 'nmds')" style="cursor: pointer;">🎨 Customize Plot (Right Panel)</div>
        <div class="item" onclick="alert('Configure in main panel')" style="cursor: pointer;">📏 Axis Options</div>
        <div class="item" onclick="alert('Configure in main panel')" style="cursor: pointer;">🏷️ Labels & Legend</div>
        <div class="item" onclick="alert('Coming soon!')" style="cursor: pointer;">🧩 Combine Plots (patchwork)</div>
      </div>
    </div>
  `;
}

// ============== STATISTICAL TESTS SIDEBAR ==============
function getSidebarTests() {
  return `
    <div class="section">
      <div class="section-header">▼ TEST TYPE</div>
      <div class="section-content">
        <div class="item active" onclick="showShinyTab('tab-tests')" style="cursor: pointer;">🧪 PERMANOVA</div>
        <div class="item" onclick="showShinyTab('tab-tests')" style="cursor: pointer;">📊 ANOSIM</div>
        <div class="item" onclick="showShinyTab('tab-tests')" style="cursor: pointer;">🔗 Mantel Test</div>
        <div class="item" onclick="showShinyTab('tab-tests')" style="cursor: pointer;">🌍 envfit (Variable Fitting)</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ DATA REQUIREMENTS</div>
      <div class="section-content">
        <div class="item" onclick="showShinyTab('tab-data')" style="cursor: pointer;">📊 Species Data <span class="badge success">Loaded</span></div>
        <div class="item" onclick="showShinyTab('tab-data')" style="cursor: pointer;">🌍 Environmental Data <span class="badge">Required</span></div>
        <div class="item" onclick="showShinyTab('tab-data')" style="cursor: pointer;">🏷️ Categorical Variables <span class="badge">Required</span></div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ DISTANCE METRICS</div>
      <div class="section-content">
        <div class="item" style="cursor: pointer;">📏 Bray-Curtis</div>
        <div class="item" style="cursor: pointer;">🔷 Jaccard</div>
        <div class="item" style="cursor: pointer;">📐 Euclidean</div>
        <div class="item" style="cursor: pointer;">📊 Manhattan</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ PERMUTATION SETTINGS</div>
      <div class="section-content">
        <div class="item" style="cursor: pointer;">🔢 Default: 999 permutations</div>
        <div class="item" onclick="alert('Configure in main panel')" style="cursor: pointer;">⚙️ Adjust Permutations</div>
        <div class="item" onclick="alert('Configure in main panel')" style="cursor: pointer;">🎲 Permutation Method</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ VISUALIZATION</div>
      <div class="section-content">
        <div class="item" onclick="alert('Configure in main panel')" style="cursor: pointer;">📊 Variance Partitioning Plot</div>
        <div class="item" onclick="alert('Configure in main panel')" style="cursor: pointer;">📈 Box Plots</div>
        <div class="item" onclick="alert('Configure in main panel')" style="cursor: pointer;">🌍 Environmental Vectors</div>
      </div>
    </div>
  `;
}

// ============== BETA PARTITIONING SIDEBAR ==============
function getSidebarBeta() {
  return `
    <div class="section">
      <div class="section-header">▼ ANALYSIS TYPE</div>
      <div class="section-content">
        <div class="item active" onclick="showShinyTab('tab-beta')" style="cursor: pointer;">🦠 Taxonomic Beta Partitioning</div>
        <div class="item" onclick="alert('Coming soon!')" style="cursor: pointer;">🧬 Functional Beta Diversity</div>
        <div class="item" onclick="alert('Coming soon!')" style="cursor: pointer;">🌳 Phylogenetic Beta Diversity</div>
        <div class="item" onclick="alert('Coming soon!')" style="cursor: pointer;">⏱️ Temporal Beta Diversity</div>
        <div class="item" onclick="alert('Coming soon!')" style="cursor: pointer;">📍 Distance-Decay Modeling</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ PARTITIONING METHODS</div>
      <div class="section-content">
        <div class="item" onclick="alert('Coming soon!')" style="cursor: pointer;">🔷 Sørensen-based</div>
        <div class="item" onclick="alert('Coming soon!')" style="cursor: pointer;">🟩 Jaccard-based</div>
        <div class="item" onclick="alert('Coming soon!')" style="cursor: pointer;">🔵 Bray-Curtis</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ BETA COMPONENTS</div>
      <div class="section-content">
        <div class="item" style="cursor: pointer;">🔄 Turnover Component</div>
        <div class="item" style="cursor: pointer;">🎯 Nestedness Component</div>
        <div class="item" style="cursor: pointer;">📉 Total Beta Diversity</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ DATA REQUIREMENTS</div>
      <div class="section-content">
        <div class="item" onclick="showShinyTab('tab-data')" style="cursor: pointer;">📊 Species Data <span class="badge success">Loaded</span></div>
        <div class="item" onclick="showShinyTab('tab-data')" style="cursor: pointer;">🌳 Phylogenetic Tree <span class="badge">Optional</span></div>
        <div class="item" onclick="showShinyTab('tab-data')" style="cursor: pointer;">🧬 Trait Data <span class="badge">Optional</span></div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ VISUALIZATION</div>
      <div class="section-content">
        <div class="item" onclick="alert('Coming soon!')" style="cursor: pointer;">📊 Beta Diversity Plots</div>
        <div class="item" onclick="alert('Coming soon!')" style="cursor: pointer;">🗺️ Distance-Decay Curves</div>
        <div class="item" onclick="alert('Coming soon!')" style="cursor: pointer;">🌐 Heatmaps</div>
        <div class="item" onclick="alert('Coming soon!')" style="cursor: pointer;">🌳 Dendrograms</div>
      </div>
    </div>
  `;
}

// ============== RESULTS SIDEBAR ==============
function getSidebarResults() {
  return `
    <div class="section">
      <div class="section-header">▼ EXPORT HISTORY</div>
      <div class="section-content">
        <div class="item" onclick="alert('View export - Coming soon!')" style="cursor: pointer;">📄 NMDS_plot.png <span class="badge">Ready</span></div>
        <div class="item" onclick="alert('View export - Coming soon!')" style="cursor: pointer;">📊 diversity_table.csv <span class="badge">Ready</span></div>
        <div class="item" onclick="alert('View export - Coming soon!')" style="cursor: pointer;">📈 rarefaction_curve.pdf <span class="badge">Ready</span></div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ EXPORT OPTIONS</div>
      <div class="section-content">
        <div class="item" onclick="alert('CSV export - Coming soon!')" style="cursor: pointer;">💾 Export as CSV</div>
        <div class="item" onclick="alert('Excel export - Coming soon!')" style="cursor: pointer;">📑 Export as Excel</div>
        <div class="item" onclick="alert('PNG export - Coming soon!')" style="cursor: pointer;">🖼️ Export as PNG</div>
        <div class="item" onclick="alert('PDF export - Coming soon!')" style="cursor: pointer;">📄 Export as PDF</div>
        <div class="item" onclick="alert('SVG export - Coming soon!')" style="cursor: pointer;">📝 Export as SVG</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ SAVED ANALYSES</div>
      <div class="section-content">
        <div class="item" onclick="alert('Project management - Coming soon!')" style="cursor: pointer;">📁 Project_2025</div>
        <div class="item" onclick="alert('Project management - Coming soon!')" style="cursor: pointer;">📁 Forest_Diversity</div>
        <div class="item" onclick="alert('Project management - Coming soon!')" style="cursor: pointer;">💾 Manage Projects</div>
      </div>
    </div>
  `;
}

// ============== SETTINGS SIDEBAR ==============
function getSidebarSettings() {
  return `
    <div class="section">
      <div class="section-header">▼ APPEARANCE</div>
      <div class="section-content">
        <div class="item" onclick="showSettingsSection('appearance')" style="cursor: pointer;">🌙 Dark Theme <span class="badge success">ON</span></div>
        <div class="item" onclick="showSettingsSection('appearance')" style="cursor: pointer;">☀️ Light Theme</div>
        <div class="item" onclick="showSettingsSection('appearance')" style="cursor: pointer;">🎨 Custom Colors</div>
        <div class="item" onclick="showSettingsSection('appearance')" style="cursor: pointer;">🔤 Increase Font Size</div>
        <div class="item" onclick="showSettingsSection('appearance')" style="cursor: pointer;">🔥 Decrease Font Size</div>
        <div class="item" onclick="showSettingsSection('appearance')" style="cursor: pointer;">🔄 Reset Zoom</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ PLOT DEFAULTS</div>
      <div class="section-content">
        <div class="item" onclick="showSettingsSection('plot-defaults')" style="cursor: pointer;">🎨 Default Theme: Clean</div>
        <div class="item" onclick="showSettingsSection('plot-defaults')" style="cursor: pointer;">📷 Default DPI: 300</div>
        <div class="item" onclick="showSettingsSection('plot-defaults')" style="cursor: pointer;">📄 Default Format: PDF</div>
        <div class="item" onclick="showSettingsSection('plot-defaults')" style="cursor: pointer;">📏 Width: 8 inches</div>
        <div class="item" onclick="showSettingsSection('plot-defaults')" style="cursor: pointer;">📏 Height: 6 inches</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ DATA MANAGEMENT</div>
      <div class="section-content">
        <div class="item" onclick="showSettingsSection('data-management')" style="cursor: pointer;">🗑️ Clear All Data</div>
        <div class="item" onclick="showSettingsSection('data-management')" style="cursor: pointer;">💾 Auto-Save Results <span class="badge">OFF</span></div>
        <div class="item" onclick="showSettingsSection('data-management')" style="cursor: pointer;">📊 View Session History</div>
        <div class="item" onclick="showSettingsSection('data-management')" style="cursor: pointer;">⚙️ Validation Settings</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ ANALYSIS DEFAULTS</div>
      <div class="section-content">
        <div class="item" onclick="showSettingsSection('analysis-defaults')" style="cursor: pointer;">🔵 NMDS Distance: Bray-Curtis</div>
        <div class="item" onclick="showSettingsSection('analysis-defaults')" style="cursor: pointer;">🔢 NMDS Dimensions: 2</div>
        <div class="item" onclick="showSettingsSection('analysis-defaults')" style="cursor: pointer;">🔄 iNEXT Bootstrap: 50</div>
        <div class="item" onclick="showSettingsSection('analysis-defaults')" style="cursor: pointer;">🎲 Permutations: 999</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ PERFORMANCE</div>
      <div class="section-content">
        <div class="item" onclick="showSettingsSection('performance')" style="cursor: pointer;">⚡ Performance Mode <span class="badge">Standard</span></div>
        <div class="item" onclick="showSettingsSection('advanced')" style="cursor: pointer;">📦 Package Versions</div>
        <div class="item" onclick="showSettingsSection('performance')" style="cursor: pointer;">🗑️ Clear Browser Cache</div>
        <div class="item" onclick="showSettingsSection('performance')" style="cursor: pointer;">📊 Memory Usage</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ ADVANCED</div>
      <div class="section-content">
        <div class="item" onclick="showSettingsSection('advanced')" style="cursor: pointer;">🔧 R Configuration</div>
        <div class="item" onclick="window.open('https://github.com/jm0535/0rdin/issues', '_blank')" style="cursor: pointer;">🐛 Report Issue</div>
        <div class="item" onclick="if(confirm('Export all settings?')) { const settings = { theme: localStorage.getItem('ordin_default_theme') || 'bw', dpi: localStorage.getItem('ordin_default_dpi') || '300' }; alert('Settings:\\n' + JSON.stringify(settings, null, 2)); }" style="cursor: pointer;">📥 Export Settings</div>
        <div class="item" onclick="if(confirm('Reset all settings to defaults?')) { localStorage.clear(); alert('✅ Settings reset to defaults'); location.reload(); }" style="cursor: pointer;">♻️ Reset All Settings</div>
      </div>
    </div>
  `;
}

// ============== HELP SIDEBAR ==============
function getSidebarHelp() {
  return `
    <div class="section">
      <div class="section-header">▼ GETTING STARTED</div>
      <div class="section-content">
        <div class="item" onclick="showHelpTopic('quick-start')" style="cursor: pointer;">🚀 Quick Start Guide</div>
        <div class="item" onclick="showHelpTopic('what-is-ordin')" style="cursor: pointer;">📊 What is Ördin?</div>
        <div class="item" onclick="showHelpTopic('first-steps')" style="cursor: pointer;">👣 First Steps</div>
        <div class="item" onclick="showHelpTopic('data-import')" style="cursor: pointer;">📊 Loading Data</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ ANALYSIS METHODS</div>
      <div class="section-content">
        <div class="item" onclick="showHelpTopic('ordination')" style="cursor: pointer;">📈 Ordination (NMDS, PCA, CA)</div>
        <div class="item" onclick="showHelpTopic('diversity')" style="cursor: pointer;">🦋 Diversity (iNEXT, Indices)</div>
        <div class="item" onclick="showHelpTopic('statistics')" style="cursor: pointer;">🧪 Statistical Tests</div>
        <div class="item" onclick="showHelpTopic('visualization')" style="cursor: pointer;">🎨 Plot Customization</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ TUTORIALS</div>
      <div class="section-content">
        <div class="item" onclick="showHelpTopic('data-import')" style="cursor: pointer;">📊 Data Import Guide</div>
        <div class="item" onclick="showHelpTopic('nmds-tutorial')" style="cursor: pointer;">🔵 Running NMDS Analysis</div>
        <div class="item" onclick="showHelpTopic('inext-tutorial')" style="cursor: pointer;">📈 iNEXT Rarefaction</div>
        <div class="item" onclick="showHelpTopic('publication-plots')" style="cursor: pointer;">🖼️ Publication Plots</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ REFERENCE</div>
      <div class="section-content">
        <div class="item" onclick="showHelpTopic('citations')" style="cursor: pointer;">📚 Citations & Papers</div>
        <div class="item" onclick="showHelpTopic('shortcuts')" style="cursor: pointer;">⌨️ Keyboard Shortcuts</div>
        <div class="item" onclick="showHelpTopic('export')" style="cursor: pointer;">💾 Export & Formats</div>
        <div class="item" onclick="showHelpTopic('troubleshooting')" style="cursor: pointer;">🔧 Troubleshooting</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ SUPPORT</div>
      <div class="section-content">
        <div class="item" onclick="showHelpTopic('troubleshooting')" style="cursor: pointer;">❓ FAQs</div>
        <div class="item" onclick="window.open('https://github.com/jm0535/0rdin/issues', '_blank')" style="cursor: pointer;">🐛 Report Bug</div>
        <div class="item" onclick="window.open('https://github.com/jm0535/0rdin/issues', '_blank')" style="cursor: pointer;">💡 Feature Request</div>
        <div class="item" onclick="showHelpTopic('about')" style="cursor: pointer;">👥 Community</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ ABOUT</div>
      <div class="section-content">
        <div class="item" onclick="showHelpTopic('about')" style="cursor: pointer;">ℹ️ Version 3.0</div>
        <div class="item" onclick="showHelpTopic('about')" style="cursor: pointer;">👤 Author: Jimmy Moses</div>
        <div class="item" onclick="showHelpTopic('citations')" style="cursor: pointer;">📚 How to Cite</div>
        <div class="item" onclick="window.open('https://github.com/jm0535/0rdin', '_blank')" style="cursor: pointer;">⭐ GitHub Repository</div>
        <div class="item" onclick="showHelpTopic('about')" style="cursor: pointer;">📜 MIT License</div>
        <div class="item" onclick="showHelpTopic('about')" style="cursor: pointer;">🙏 Acknowledgments</div>
      </div>
    </div>
  `;
}

// ============== SETTINGS SECTION NAVIGATION ==============
function showSettingsSection(sectionName) {
  console.log('Showing settings section:', sectionName);
  
  // Hide all settings sections
  const sections = document.querySelectorAll('.settings-section');
  sections.forEach(section => {
    section.style.display = 'none';
  });
  
  // Show the requested section
  const targetSection = document.getElementById('settings-' + sectionName);
  if (targetSection) {
    targetSection.style.display = 'block';
    console.log('Showing section:', 'settings-' + sectionName);
  } else {
    console.error('Section not found:', 'settings-' + sectionName);
  }
}

// ============== RIGHT PANEL CONTENT ==============
function updateRightPanelContent(panelType) {
  // Properties panel content is static HTML in app.R
  // Can be expanded here for dynamic content
  console.log('Right panel:', panelType);
}
