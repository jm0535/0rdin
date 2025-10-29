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
        <div class="item active" style="cursor: pointer;">🌙 Dark Theme</div>
        <div class="item" onclick="alert('Light theme - Coming soon!')" style="cursor: pointer;">☀️ Light Theme</div>
        <div class="item" onclick="alert('Custom colors - Coming soon!')" style="cursor: pointer;">🎨 Custom Colors</div>
        <div class="item" onclick="alert('Font size - Coming soon!')" style="cursor: pointer;">🔤 Font Size</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ GENERAL</div>
      <div class="section-content">
        <div class="item" onclick="alert('Auto-save settings - Coming soon!')" style="cursor: pointer;">💾 Auto-Save <span class="badge success">ON</span></div>
        <div class="item" onclick="alert('Notifications - Coming soon!')" style="cursor: pointer;">🔔 Notifications</div>
        <div class="item" onclick="alert('Language - Coming soon!')" style="cursor: pointer;">🌐 Language</div>
        <div class="item" onclick="alert('Default parameters - Coming soon!')" style="cursor: pointer;">⚙️ Default Parameters</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ ADVANCED</div>
      <div class="section-content">
        <div class="item" onclick="alert('R configuration - Coming soon!')" style="cursor: pointer;">🔧 R Configuration</div>
        <div class="item" onclick="alert('Package manager - Coming soon!')" style="cursor: pointer;">📦 Package Manager</div>
        <div class="item" onclick="alert('Clear cache - Coming soon!')" style="cursor: pointer;">🗑️ Clear Cache</div>
        <div class="item" onclick="alert('Performance - Coming soon!')" style="cursor: pointer;">⚡ Performance Settings</div>
      </div>
    </div>
  `;
}

// ============== HELP SIDEBAR ==============
function getSidebarHelp() {
  return `
    <div class="section">
      <div class="section-header">▼ DOCUMENTATION</div>
      <div class="section-content">
        <div class="item" onclick="alert('User guide - Coming soon!')" style="cursor: pointer;">📖 User Guide</div>
        <div class="item" onclick="alert('Tutorials - Coming soon!')" style="cursor: pointer;">🎓 Tutorials</div>
        <div class="item" onclick="alert('API reference - Coming soon!')" style="cursor: pointer;">📚 API Reference</div>
        <div class="item" onclick="alert('Video tutorials - Coming soon!')" style="cursor: pointer;">🎥 Video Tutorials</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ SUPPORT</div>
      <div class="section-content">
        <div class="item" onclick="alert('FAQs - Coming soon!')" style="cursor: pointer;">❓ FAQs</div>
        <div class="item" onclick="alert('Report bug - Coming soon!')" style="cursor: pointer;">🐛 Report Bug</div>
        <div class="item" onclick="alert('Feature request - Coming soon!')" style="cursor: pointer;">💡 Feature Request</div>
        <div class="item" onclick="alert('Community - Coming soon!')" style="cursor: pointer;">👥 Community Forum</div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ ABOUT</div>
      <div class="section-content">
        <div class="item" onclick="alert('Version 3.0\\nÖrdin Community Ecology Software')" style="cursor: pointer;">ℹ️ Version 3.0</div>
        <div class="item" onclick="alert('Author: Jimmy Moses\\nEmail: jimmy.moses@pnguot.ac.pg')" style="cursor: pointer;">👤 Author: Jimmy Moses</div>
        <div class="item" onclick="alert('Changelog - Coming soon!')" style="cursor: pointer;">📜 Changelog</div>
        <div class="item" onclick="window.open('https://github.com', '_blank')" style="cursor: pointer;">⭐ GitHub Repository</div>
        <div class="item" onclick="alert('MIT License - Open Source')" style="cursor: pointer;">📜 License</div>
        <div class="item" onclick="alert('Citations - Coming soon!')" style="cursor: pointer;">📚 Citations & References</div>
      </div>
    </div>
  `;
}

// ============== RIGHT PANEL CONTENT ==============
function updateRightPanelContent(panelType) {
  // Properties panel content is static HTML in app.R
  // Can be expanded here for dynamic content
  console.log('Right panel:', panelType);
}
