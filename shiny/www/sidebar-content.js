// ============== DIVERSITY SIDEBAR ==============
function getSidebarDiversity() {
  return `
    <div class="section">
      <div class="section-header">▼ ANALYSIS TYPE</div>
      <div class="section-content">
        <div class="item active" onclick="showShinyTab('tab-diversity')" style="cursor: pointer;">📈 Diversity Estimation (iNEXT)</div>
        <div class="item" onclick="showShinyTab('tab-diversity')" style="cursor: pointer;">📊 Diversity Indices (vegan)</div>
        <div style="padding: 8px; background: #2e2e2e; margin: 8px 0; border-radius: 4px;">
          <div style="color: #888; font-size: 10px; line-height: 1.4;">
            ℹ️ Switch methods using <strong>"Select Method"</strong> dropdown
          </div>
        </div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ PLOT OPTIONS</div>
      <div class="section-content">
        <div class="item" style="cursor: default;">📉 Sample-Size Based</div>
        <div class="item" style="cursor: default;">📈 Sample Completeness</div>
        <div class="item" style="cursor: default;">📊 Coverage-Based</div>
        <div style="padding: 8px; background: #2e2e2e; margin: 8px 0; border-radius: 4px;">
          <div style="color: #888; font-size: 10px; line-height: 1.4;">
            ✅ Available in <strong>Diversity Estimation</strong> module
          </div>
        </div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ PARAMETERS</div>
      <div class="section-content">
        <div class="item" style="cursor: default;">⚙️ Confidence Level</div>
        <div class="item" style="cursor: default;">🔢 Knots</div>
        <div class="item" style="cursor: default;">🎯 Endpoint</div>
        <div style="padding: 8px; background: #2e2e2e; margin: 8px 0; border-radius: 4px;">
          <div style="color: #888; font-size: 10px; line-height: 1.4;">
            ⚙️ Configure in main panel parameters
          </div>
        </div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ VISUALIZATION</div>
      <div class="section-content">
        <div class="item" style="cursor: default;">🎨 Plot Customization <span class="badge success">Active</span></div>
        <div class="item" style="cursor: default;">📏 Axis Options <span class="badge success">Active</span></div>
        <div class="item" style="cursor: default;">🏷️ Labels & Legend <span class="badge success">Active</span></div>
        <div style="padding: 8px; background: #2e2e2e; margin: 8px 0; border-radius: 4px;">
          <div style="color: #888; font-size: 10px; line-height: 1.4;">
            ✅ Use <strong>"PLOT OPTIONS"</strong> in right panel
          </div>
        </div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ COMPARISON TOOLS</div>
      <div class="section-content">
        <div class="item" onclick="switchView('beta')" style="cursor: pointer;">🦠 Beta Diversity (Beta tab →)</div>
        <div class="item" onclick="switchView('tests')" style="cursor: pointer;">🧪 Statistical Tests (Tests tab →)</div>
        <div style="padding: 8px; background: #2e2e2e; margin: 8px 0; border-radius: 4px;">
          <div style="color: #888; font-size: 10px; line-height: 1.4;">
            🔗 Related analyses available in other tabs
          </div>
        </div>
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
        <div class="item" onclick="showShinyTab('tab-ordination')" style="cursor: pointer;">🔵 NMDS <span class="badge success">Ready</span></div>
        <div class="item" onclick="showShinyTab('tab-ordination')" style="cursor: pointer;">🔷 PCA <span class="badge success">Ready</span></div>
        <div class="item" onclick="showShinyTab('tab-ordination')" style="cursor: pointer;">🔶 CA <span class="badge success">Ready</span></div>
        <div class="item" onclick="showShinyTab('tab-ordination')" style="cursor: pointer;">🟦 DCA <span class="badge success">Ready</span></div>
        <div class="item" onclick="showShinyTab('tab-ordination')" style="cursor: pointer;">⬡ PCoA <span class="badge success">Ready</span></div>
        <div style="padding: 8px; background: #2e2e2e; margin: 8px 0; border-radius: 4px;">
          <div style="color: #888; font-size: 10px; line-height: 1.4;">
            ✅ Select from <strong>"Select Method"</strong> dropdown
          </div>
        </div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ CONSTRAINED ORDINATION</div>
      <div class="section-content">
        <div class="item" onclick="showShinyTab('tab-ordination')" style="cursor: pointer;">🟢 RDA <span class="badge success">Ready</span></div>
        <div class="item" onclick="showShinyTab('tab-ordination')" style="cursor: pointer;">🟡 CCA <span class="badge success">Ready</span></div>
        <div class="item" onclick="showShinyTab('tab-ordination')" style="cursor: pointer;">🔴 db-RDA <span class="badge success">Ready</span></div>
        <div class="item" onclick="showShinyTab('tab-ordination')" style="cursor: pointer;">🔵 CAP <span class="badge success">Ready</span></div>
        <div style="padding: 8px; background: #1a3a2e; border-left: 3px solid #2e8b57; margin: 8px 0; border-radius: 0 4px 4px 0;">
          <div style="color: #5fd38d; font-size: 10px; font-weight: 600; margin-bottom: 4px;">ℹ️ REQUIRES ENV DATA</div>
          <div style="color: #aaa; font-size: 10px; line-height: 1.4;">
            Load environmental data in <strong>Data tab</strong>
          </div>
        </div>
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
        <div class="item" onclick="switchView('tests')" style="cursor: pointer;">🧪 PERMANOVA (Tests tab →)</div>
        <div class="item" onclick="switchView('tests')" style="cursor: pointer;">📊 ANOSIM (Tests tab →)</div>
        <div class="item" onclick="switchView('tests')" style="cursor: pointer;">🔗 Mantel Test (Tests tab →)</div>
        <div class="item" onclick="switchView('tests')" style="cursor: pointer;">🌍 envfit (Tests tab →)</div>
        <div style="padding: 8px; background: #2e2e2e; margin: 8px 0; border-radius: 4px;">
          <div style="color: #888; font-size: 10px; line-height: 1.4;">
            🔗 All tests available in <strong>Tests</strong> tab
          </div>
        </div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ VISUALIZATION</div>
      <div class="section-content">
        <div class="item" style="cursor: default;">🎨 Plot Customization <span class="badge success">Active</span></div>
        <div class="item" style="cursor: default;">📏 Axis Options <span class="badge success">Active</span></div>
        <div class="item" style="cursor: default;">🏷️ Labels & Legend <span class="badge success">Active</span></div>
        <div style="padding: 8px; background: #2e2e2e; margin: 8px 0; border-radius: 4px;">
          <div style="color: #888; font-size: 10px; line-height: 1.4;">
            ✅ Use <strong>"PLOT OPTIONS"</strong> in right panel
          </div>
        </div>
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
        <div class="item" onclick="showShinyTab('tab-tests')" style="cursor: pointer;">🧪 PERMANOVA <span class="badge success">Ready</span></div>
        <div class="item" onclick="showShinyTab('tab-tests')" style="cursor: pointer;">📊 ANOSIM <span class="badge success">Ready</span></div>
        <div class="item" onclick="showShinyTab('tab-tests')" style="cursor: pointer;">🔗 Mantel Test <span class="badge success">Ready</span></div>
        <div class="item" onclick="showShinyTab('tab-tests')" style="cursor: pointer;">🌍 envfit <span class="badge success">Ready</span></div>
        <div style="padding: 8px; background: #2e2e2e; margin: 8px 0; border-radius: 4px;">
          <div style="color: #888; font-size: 10px; line-height: 1.4;">
            ✅ Select from <strong>"Select Test"</strong> dropdown
          </div>
        </div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ DATA REQUIREMENTS</div>
      <div class="section-content">
        <div class="item" onclick="showShinyTab('tab-data')" style="cursor: pointer;">📊 Species Data <span class="badge success">Loaded</span></div>
        <div class="item" onclick="showShinyTab('tab-data')" style="cursor: pointer;">🌍 Environmental Data <span class="badge">Required</span></div>
        <div class="item" onclick="showShinyTab('tab-data')" style="cursor: pointer;">🏷️ Categorical Variables <span class="badge">Required</span></div>
        <div style="padding: 8px; background: #1a3a2e; border-left: 3px solid #2e8b57; margin: 8px 0; border-radius: 0 4px 4px 0;">
          <div style="color: #5fd38d; font-size: 10px; font-weight: 600; margin-bottom: 4px;">ℹ️ ENV DATA NEEDED</div>
          <div style="color: #aaa; font-size: 10px; line-height: 1.4;">
            Load environmental data in <strong>Data tab</strong>
          </div>
        </div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ DISTANCE METRICS</div>
      <div class="section-content">
        <div class="item" style="cursor: default;">📏 Bray-Curtis</div>
        <div class="item" style="cursor: default;">🔷 Jaccard</div>
        <div class="item" style="cursor: default;">📐 Euclidean</div>
        <div class="item" style="cursor: default;">📊 Manhattan</div>
        <div style="padding: 8px; background: #2e2e2e; margin: 8px 0; border-radius: 4px;">
          <div style="color: #888; font-size: 10px; line-height: 1.4;">
            ⚙️ Configure in test parameters
          </div>
        </div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ PERMUTATION SETTINGS</div>
      <div class="section-content">
        <div class="item" style="cursor: default;">🔢 Default: 999 permutations</div>
        <div class="item" style="cursor: default;">⚙️ Adjust Permutations</div>
        <div class="item" style="cursor: default;">🎲 Permutation Method</div>
        <div style="padding: 8px; background: #2e2e2e; margin: 8px 0; border-radius: 4px;">
          <div style="color: #888; font-size: 10px; line-height: 1.4;">
            ⚙️ Set in main panel parameters
          </div>
        </div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ VISUALIZATION</div>
      <div class="section-content">
        <div class="item" style="cursor: default;">📊 Variance Partitioning <span class="badge success">Active</span></div>
        <div class="item" style="cursor: default;">📈 Box Plots <span class="badge success">Active</span></div>
        <div class="item" style="cursor: default;">🌍 Environmental Vectors <span class="badge success">Active</span></div>
        <div style="padding: 8px; background: #2e2e2e; margin: 8px 0; border-radius: 4px;">
          <div style="color: #888; font-size: 10px; line-height: 1.4;">
            ✅ Plots generated with test results
          </div>
        </div>
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
        <div class="item active" style="cursor: default;">🦠 Beta Diversity Partitioning</div>
        <div style="padding: 12px; background: #1a3a2e; border-left: 3px solid #2e8b57; margin: 8px 0; border-radius: 0 4px 4px 0;">
          <div style="color: #5fd38d; font-size: 11px; font-weight: 600; margin-bottom: 6px;">ℹ️ ALL FEATURES AVAILABLE</div>
          <div style="color: #aaa; font-size: 11px; line-height: 1.5;">
            Use the <strong style="color: #2e8b57;">"Partitioning Components"</strong> dropdown above to select:
            <ul style="margin: 6px 0 0 0; padding-left: 16px;">
              <li>Turnover & Nestedness</li>
              <li>Temporal Beta Diversity</li>
              <li>Functional Beta Diversity</li>
              <li>Phylogenetic Beta Diversity</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ PARTITIONING METHODS</div>
      <div class="section-content">
        <div class="item" style="cursor: default;">🔷 Sørensen-based</div>
        <div class="item" style="cursor: default;">🟩 Jaccard-based</div>
        <div class="item" style="cursor: default;">🔵 Bray-Curtis</div>
        <div style="padding: 8px; background: #2e2e2e; margin: 8px 0; border-radius: 4px;">
          <div style="color: #888; font-size: 10px; line-height: 1.4;">
            ℹ️ Select from <strong>"Beta Diversity Index"</strong> dropdown
          </div>
        </div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ BETA COMPONENTS</div>
      <div class="section-content">
        <div class="item" style="cursor: default;">🔄 Turnover Component</div>
        <div class="item" style="cursor: default;">🎯 Nestedness Component</div>
        <div class="item" style="cursor: default;">📉 Total Beta Diversity</div>
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
        <div class="item" style="cursor: default;">📊 Beta Diversity Plots <span class="badge success">Active</span></div>
        <div class="item" style="cursor: default;">🌐 Heatmaps <span class="badge success">Active</span></div>
        <div style="padding: 8px; background: #2e2e2e; margin: 8px 0; border-radius: 4px;">
          <div style="color: #888; font-size: 10px; line-height: 1.4;">
            ✅ Customize plots using <strong>"PLOT OPTIONS"</strong> panel
          </div>
        </div>
      </div>
    </div>
  `;
}

// ============== RESULTS SIDEBAR ==============
function getSidebarResults() {
  return `
    <div class="section">
      <div class="section-header">▼ EXPORT FORMATS</div>
      <div class="section-content">
        <div class="item" style="cursor: default;">📄 PDF Export <span class="badge success">Active</span></div>
        <div class="item" style="cursor: default;">📊 CSV Export <span class="badge success">Active</span></div>
        <div class="item" style="cursor: default;">🖼️ PNG Export <span class="badge success">Active</span></div>
        <div class="item" style="cursor: default;">🗂️ ZIP (Multiple files) <span class="badge success">Active</span></div>
        <div style="padding: 12px; background: #1a3a2e; border-left: 3px solid #2e8b57; margin: 8px 0; border-radius: 0 4px 4px 0;">
          <div style="color: #5fd38d; font-size: 11px; font-weight: 600; margin-bottom: 6px;">✅ EXPORT READY</div>
          <div style="color: #aaa; font-size: 11px; line-height: 1.5;">
            Use <strong>"EXPORT"</strong> buttons in each analysis module's right panel
          </div>
        </div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ AVAILABLE EXPORTS</div>
      <div class="section-content">
        <div style="padding: 8px; background: #2e2e2e; margin: 8px 0; border-radius: 4px;">
          <div style="color: #888; font-size: 10px; line-height: 1.4;">
            📊 <strong>Plots:</strong> All ordination & diversity plots
          </div>
        </div>
        <div style="padding: 8px; background: #2e2e2e; margin: 8px 0; border-radius: 4px;">
          <div style="color: #888; font-size: 10px; line-height: 1.4;">
            📄 <strong>Statistics:</strong> Test results, diversity tables
          </div>
        </div>
        <div style="padding: 8px; background: #2e2e2e; margin: 8px 0; border-radius: 4px;">
          <div style="color: #888; font-size: 10px; line-height: 1.4;">
            🗺️ <strong>Matrices:</strong> Distance, beta diversity matrices
          </div>
        </div>
      </div>
    </div>
    <div class="section">
      <div class="section-header">▼ EXPORT SETTINGS</div>
      <div class="section-content">
        <div class="item" onclick="switchView('settings')" style="cursor: pointer;">🎨 Plot Defaults (Settings →)</div>
        <div class="item" onclick="switchView('settings')" style="cursor: pointer;">📷 DPI: 300 (Settings →)</div>
        <div class="item" onclick="switchView('settings')" style="cursor: pointer;">📏 Dimensions (Settings →)</div>
        <div style="padding: 8px; background: #2e2e2e; margin: 8px 0; border-radius: 4px;">
          <div style="color: #888; font-size: 10px; line-height: 1.4;">
            ⚙️ Configure export defaults in <strong>Settings</strong>
          </div>
        </div>
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
        <div class="item" onclick="showSettingsSection('appearance')" style="cursor: pointer;">🎨 Custom Colors</div>
        <div class="item" onclick="adjustFontSize('increase'); showSettingsSection('appearance');" style="cursor: pointer;">🔤 Increase Font Size</div>
        <div class="item" onclick="adjustFontSize('decrease'); showSettingsSection('appearance');" style="cursor: pointer;">🔥 Decrease Font Size</div>
        <div class="item" onclick="resetZoom(); showSettingsSection('appearance');" style="cursor: pointer;">🔍 Reset Zoom</div>
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

// ============== FONT SIZE AND ZOOM FUNCTIONS ==============
function adjustFontSize(action) {
  console.log('Adjusting font size:', action);
  const root = document.documentElement;
  const currentSize = parseFloat(getComputedStyle(root).fontSize);
  
  if (action === 'increase') {
    root.style.fontSize = (currentSize + 1) + 'px';
  } else if (action === 'decrease') {
    root.style.fontSize = Math.max(12, currentSize - 1) + 'px';
  }
}

function resetZoom() {
  console.log('Resetting zoom');
  const root = document.documentElement;
  root.style.fontSize = '14px';
  
  // Update Shiny slider if it exists
  if (typeof Shiny !== 'undefined') {
    Shiny.setInputValue('settings_zoom', 100);
  }
}

// ============== SHINY MESSAGE HANDLERS ==============
// Add message handlers when document is ready
$(document).ready(function() {
  if (typeof Shiny !== 'undefined') {
    Shiny.addCustomMessageHandler('applyFont', function(font) {
      console.log('Applying font from Shiny:', font);
      const body = document.body;
      body.style.fontFamily = font === 'system' ? '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif' :
                              font === 'sans' ? 'Arial, Helvetica, sans-serif' :
                              font === 'serif' ? 'Georgia, "Times New Roman", serif' :
                              font === 'mono' ? '"Courier New", Courier, monospace' :
                              '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif';
    });
  }
});

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
