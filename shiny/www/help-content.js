// Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
// Help & Documentation - Individual Topic Pages

// Main entry point
function getAboutOrdinContent() {
  return getHelpContent('overview');
}

// Router function
function getHelpContent(topic) {
  const topics = {
    'overview': getOverviewContent,
    'quick-start': getQuickStartContent,
    'what-is-ordin': getWhatIsOrdinContent,
    'first-steps': getFirstStepsContent,
    'data-import': getDataImportContent,
    'ordination': getOrdinationContent,
    'diversity': getDiversityContent,
    'statistics': getStatisticsContent,
    'visualization': getVisualizationContent,
    'nmds-tutorial': getNMDSTutorialContent,
    'inext-tutorial': getINEXTTutorialContent,
    'publication-plots': getPublicationPlotsContent,
    'citations': getCitationsContent,
    'shortcuts': getShortcutsContent,
    'export': getExportContent,
    'troubleshooting': getTroubleshootingContent,
    'about': getAboutContent
  };
  
  const contentFunc = topics[topic] || topics['overview'];
  return contentFunc();
}

// Update displayed content
function showHelpTopic(topic) {
  const container = document.getElementById('help-content-container');
  if (container) {
    container.innerHTML = getHelpContent(topic);
  }
}

// Helper for page wrapper
function helpPage(icon, title, content) {
  return `
    <div class="help-container">
      <div class="help-hero">
        <h1 style="font-size: 48px; margin: 0; color: #2e8b57; font-weight: 300;">${icon}</h1>
        <h2 style="margin: 8px 0; color: #cccccc;">${title}</h2>
      </div>
      <div class="help-content">
        <section class="help-section">
          ${content}
        </section>
      </div>
    </div>
  `;
}

// =============== CONTENT PAGES ===============

function getOverviewContent() {
  return helpPage('Ö', 'Ördin Help & Documentation', `
    <h2>👋 Welcome</h2>
    <p>Select a topic from the left sidebar to learn more. Popular topics:</p>
    
    <div class="help-steps">
      <div class="help-step" onclick="showHelpTopic('quick-start')" style="cursor: pointer;">
        <div class="step-number">🚀</div>
        <div class="step-content">
          <h4>Quick Start</h4>
          <p>3-step guide to get started</p>
        </div>
      </div>
      
      <div class="help-step" onclick="showHelpTopic('ordination')" style="cursor: pointer;">
        <div class="step-number">📈</div>
        <div class="step-content">
          <h4>Ordination</h4>
          <p>NMDS, PCA, CA, and more</p>
        </div>
      </div>
      
      <div class="help-step" onclick="showHelpTopic('diversity')" style="cursor: pointer;">
        <div class="step-number">🦋</div>
        <div class="step-content">
          <h4>Diversity</h4>
          <p>iNEXT and indices</p>
        </div>
      </div>
    </div>
  `);
}

function getQuickStartContent() {
  return helpPage('🚀', 'Quick Start Guide', `
    <h2>Get Started in 3 Steps</h2>
    
    <div class="help-steps">
      <div class="help-step">
        <div class="step-number">1</div>
        <div class="step-content">
          <h4>Load Data</h4>
          <p>Click <strong>Data Management</strong> → Upload CSV/Excel or load sample dataset (e.g., 'dune')</p>
        </div>
      </div>
      
      <div class="help-step">
        <div class="step-number">2</div>
        <div class="step-content">
          <h4>Choose Analysis</h4>
          <p>Navigate to <strong>Ordination</strong>, <strong>Diversity</strong>, or <strong>Statistical Tests</strong></p>
        </div>
      </div>
      
      <div class="help-step">
        <div class="step-number">3</div>
        <div class="step-content">
          <h4>Run & Export</h4>
          <p>Configure parameters → Run analysis → Customize plot → Export results</p>
        </div>
      </div>
    </div>
    
    <div class="help-tip">
      <strong>💡 Tip:</strong> Start with 'dune' sample dataset to learn the interface
    </div>
  `);
}

function getWhatIsOrdinContent() {
  return helpPage('Ö', 'What is Ördin?', `
    <h2>Community Ecology Analysis Platform</h2>
    <p>Ördin combines R's statistical power with a modern, intuitive interface.</p>
    
    <h3>🎯 Key Features</h3>
    <ul>
      <li><strong>9 Ordination Methods:</strong> NMDS, PCA, CA, DCA, CCA, RDA, db-RDA, CAP, PCoA</li>
      <li><strong>Diversity Analysis:</strong> iNEXT rarefaction, Shannon, Simpson indices</li>
      <li><strong>Statistical Tests:</strong> PERMANOVA, ANOSIM, Mantel, envfit</li>
      <li><strong>Real-Time Customization:</strong> Themes, fonts, colors, instant updates</li>
      <li><strong>Publication Exports:</strong> PNG, PDF, SVG, TIFF up to 600 DPI</li>
    </ul>
    
    <h3>💡 Why Ördin?</h3>
    <ul>
      <li>✅ Rigorous (uses vegan, iNEXT packages)</li>
      <li>✅ User-friendly (modern GUI)</li>
      <li>✅ Reproducible (fixed seeds, tracking)</li>
      <li>✅ Cross-platform (Windows, Mac, Linux)</li>
    </ul>
  `);
}

function getFirstStepsContent() {
  return getQuickStartContent(); // Same content
}

function getDataImportContent() {
  return helpPage('📊', 'Data Import Guide', `
    <h2>Loading Your Data</h2>
    
    <h3>Supported Formats</h3>
    <ul>
      <li><strong>CSV:</strong> Comma-separated values with headers</li>
      <li><strong>Excel:</strong> .xlsx, .xls (first sheet imported)</li>
      <li><strong>Samples:</strong> Built-in datasets from vegan (dune, varespec, BCI)</li>
    </ul>
    
    <h3>Data Structure</h3>
    <h4>Species/Abundance Data (Required)</h4>
    <div class="code-block"># Rows = Sites, Columns = Species
          Sp1  Sp2  Sp3
Site1    12    5    0
Site2     8   15   23</div>
    
    <h4>Environmental Data (Optional)</h4>
    <div class="code-block"># Must match site names
          pH   Temp
Site1   6.5   18.2
Site2   7.1   19.8</div>
    
    <div class="help-tip">
      <strong>💡 Tip:</strong> For constrained ordination (CCA, RDA, db-RDA), row names must match exactly!
    </div>
  `);
}

function getOrdinationContent() {
  return helpPage('📈', 'Ordination Methods', `
    <h2>Available Methods</h2>
    
    <h3>Unconstrained</h3>
    <h4>🔵 NMDS</h4>
    <p><strong>Best for:</strong> Complex relationships, non-linear gradients</p>
    <p><strong>Stress:</strong> &lt;0.05 excellent, &lt;0.10 good, &lt;0.20 usable</p>
    
    <h4>🔷 PCA</h4>
    <p><strong>Best for:</strong> Linear relationships, normally distributed data</p>
    
    <h4>🔶 CA / 🟦 DCA</h4>
    <p><strong>Best for:</strong> Species composition, unimodal responses</p>
    <p><strong>DCA:</strong> Use when gradient &gt; 4 SD units</p>
    
    <h3>Constrained</h3>
    <h4>🟢 RDA / 🟡 CCA</h4>
    <p><strong>RDA:</strong> Linear species-environment relationships</p>
    <p><strong>CCA:</strong> Unimodal relationships (gradient &gt; 4 SD)</p>
    
    <h4>🔴 db-RDA / 🔵 CAP</h4>
    <p><strong>db-RDA:</strong> Non-Euclidean distances + env predictors</p>
    <p><strong>CAP:</strong> Hypothesis testing with predefined groups</p>
    
    <div class="help-warning">
      <strong>⚠️ Important:</strong> Constrained methods require matching site names in species and environmental data!
    </div>
  `);
}

function getDiversityContent() {
  return helpPage('🦋', 'Diversity Analysis', `
    <h2>iNEXT - Diversity Estimation</h2>
    
    <h3>Hill Numbers (q values)</h3>
    <ul>
      <li><strong>q = 0:</strong> Species richness (count)</li>
      <li><strong>q = 1:</strong> Shannon diversity (exponential entropy)</li>
      <li><strong>q = 2:</strong> Simpson diversity (inverse concentration)</li>
    </ul>
    
    <h3>Plot Types</h3>
    <ul>
      <li><strong>Sample-Size Based:</strong> Rarefaction/extrapolation by sample size</li>
      <li><strong>Sample Completeness:</strong> Coverage vs diversity</li>
      <li><strong>Coverage-Based:</strong> Standardized by completeness</li>
    </ul>
    
    <h3>Key Parameters</h3>
    <ul>
      <li><strong>Bootstrap:</strong> 50-200 replicates for CI</li>
      <li><strong>Confidence:</strong> 0.95 (95% CI) standard</li>
      <li><strong>Knots:</strong> 40 default (controls curve smoothness)</li>
    </ul>
    
    <h3>Diversity Indices</h3>
    <ul>
      <li><strong>Shannon (H'):</strong> Accounts for evenness + richness</li>
      <li><strong>Simpson:</strong> Probability of different species</li>
      <li><strong>Richness:</strong> Total species count</li>
    </ul>
    
    <div class="help-tip">
      <strong>💡 Pro Tip:</strong> Use iNEXT to compare sites with different sampling efforts!
    </div>
  `);
}

function getStatisticsContent() {
  return helpPage('📉', 'Statistical Tests', `
    <h2>Available Tests</h2>
    
    <h3>🧪 PERMANOVA</h3>
    <p><strong>Purpose:</strong> Test if group centroids differ in multivariate space</p>
    <p><strong>Output:</strong> F-statistic, R², p-value</p>
    <p><strong>Assumption:</strong> Homogeneity of dispersions</p>
    
    <h3>📊 ANOSIM</h3>
    <p><strong>Purpose:</strong> Analysis of Similarities</p>
    <p><strong>R-statistic:</strong> &gt;0.75 = well separated, 0.5-0.75 = separated, &lt;0.25 = barely separable</p>
    
    <h3>🔗 Mantel Test</h3>
    <p><strong>Purpose:</strong> Correlation between distance matrices</p>
    <p><strong>Use:</strong> Species-environment relationships, spatial autocorrelation</p>
    
    <h3>🌍 envfit</h3>
    <p><strong>Purpose:</strong> Fit environmental vectors onto ordination</p>
    <p><strong>Output:</strong> R² and p-values for each variable</p>
    
    <div class="help-tip">
      <strong>💡 Tip:</strong> Use 999+ permutations for publication. Check PERMANOVA assumptions!
    </div>
  `);
}

function getVisualizationContent() {
  return helpPage('🎨', 'Plot Customization', `
    <h2>Real-Time Customization</h2>
    <p>Click left sidebar → "Customize Plot (Right Panel)" to open controls</p>
    
    <h3>Themes</h3>
    <p>Clean (bw), Minimal, Dark, Classic, Light, Void</p>
    
    <h3>Ordination Plots</h3>
    <ul>
      <li><strong>Point Shape:</strong> Circle, square, diamond, triangle</li>
      <li><strong>Colors:</strong> Ördin Green, Blue, Orange, Red, Purple, Teal</li>
      <li><strong>Size:</strong> Point size, border width</li>
      <li><strong>Labels:</strong> Toggle site labels on/off</li>
    </ul>
    
    <h3>Diversity Plots</h3>
    <ul>
      <li><strong>Lines:</strong> Adjustable width</li>
      <li><strong>CI Ribbons:</strong> Toggle, transparency control</li>
      <li><strong>Legend:</strong> Rows, text size</li>
      <li><strong>Facets:</strong> Panel label size</li>
    </ul>
    
    <h3>Export Settings</h3>
    <ul>
      <li><strong>Dimensions:</strong> Width/height in inches</li>
      <li><strong>DPI:</strong> 72-600 (300 for publication)</li>
      <li><strong>Formats:</strong> PNG, PDF, SVG, TIFF</li>
    </ul>
    
    <div class="help-tip">
      <strong>💡 Publication:</strong> 300 DPI, PDF, 6-8" width. Presentations: PNG, 150 DPI, 10-12" width
    </div>
  `);
}

function getNMDSTutorialContent() {
  return helpPage('🔵', 'NMDS Tutorial', `
    <h2>Running NMDS Analysis</h2>
    
    <div class="help-steps">
      <div class="help-step">
        <div class="step-number">1</div>
        <div class="step-content">
          <h4>Load Data</h4>
          <p>Upload species abundance data or use 'dune' sample</p>
        </div>
      </div>
      
      <div class="help-step">
        <div class="step-number">2</div>
        <div class="step-content">
          <h4>Configure</h4>
          <p><strong>Distance:</strong> Bray-Curtis (default)<br>
          <strong>Dimensions:</strong> 2 (standard)<br>
          <strong>Iterations:</strong> 20+ (more = better convergence)</p>
        </div>
      </div>
      
      <div class="help-step">
        <div class="step-number">3</div>
        <div class="step-content">
          <h4>Interpret</h4>
          <p>Check stress value:<br>
          &lt;0.05 = excellent, &lt;0.10 = good, &lt;0.20 = usable</p>
        </div>
      </div>
    </div>
    
    <div class="help-warning">
      <strong>⚠️ High stress?</strong> Try increasing iterations, different distance, or 3D ordination
    </div>
  `);
}

function getINEXTTutorialContent() {
  return helpPage('📈', 'iNEXT Tutorial', `
    <h2>Rarefaction & Extrapolation</h2>
    
    <div class="help-steps">
      <div class="help-step">
        <div class="step-number">1</div>
        <div class="step-content">
          <h4>Prepare Data</h4>
          <p>Abundance matrix: Sites × Species</p>
        </div>
      </div>
      
      <div class="help-step">
        <div class="step-number">2</div>
        <div class="step-content">
          <h4>Configure</h4>
          <p><strong>Data Type:</strong> Abundance<br>
          <strong>q values:</strong> 0, 1, 2<br>
          <strong>Bootstrap:</strong> 50-200<br>
          <strong>Knots:</strong> 40</p>
        </div>
      </div>
      
      <div class="help-step">
        <div class="step-number">3</div>
        <div class="step-content">
          <h4>Interpret</h4>
          <p>Compare sites at equal coverage. Shaded areas = 95% CI</p>
        </div>
      </div>
    </div>
  `);
}

function getPublicationPlotsContent() {
  return helpPage('🖼️', 'Publication-Ready Plots', `
    <h2>Creating Journal Figures</h2>
    
    <h3>Recommended Settings</h3>
    
    <h4>For Journals</h4>
    <ul>
      <li><strong>Format:</strong> PDF (vector)</li>
      <li><strong>DPI:</strong> 300</li>
      <li><strong>Width:</strong> 6-8 inches</li>
      <li><strong>Theme:</strong> Clean (bw)</li>
      <li><strong>Font:</strong> Sans, 12pt base</li>
    </ul>
    
    <h4>For Presentations</h4>
    <ul>
      <li><strong>Format:</strong> PNG</li>
      <li><strong>DPI:</strong> 150</li>
      <li><strong>Width:</strong> 10-12 inches</li>
      <li><strong>Theme:</strong> Dark (high contrast)</li>
      <li><strong>Font:</strong> Sans, 14pt base</li>
    </ul>
    
    <h4>For Posters</h4>
    <ul>
      <li><strong>Format:</strong> PDF or TIFF</li>
      <li><strong>DPI:</strong> 300-600</li>
      <li><strong>Width:</strong> 14-16 inches</li>
      <li><strong>Font:</strong> 16-18pt base</li>
    </ul>
  `);
}

function getCitationsContent() {
  return helpPage('📚', 'Citations & References', `
    <h2>How to Cite</h2>
    
    <h3>R Packages</h3>
    <div class="citation-block">
      <strong>vegan:</strong> Oksanen J, et al. (2024). vegan: Community Ecology Package. R package version 2.6-8.
    </div>
    
    <div class="citation-block">
      <strong>iNEXT:</strong> Hsieh TC, Ma KH, Chao A. (2024). iNEXT: Interpolation and Extrapolation for Species Diversity.
    </div>
    
    <div class="citation-block">
      <strong>ggplot2:</strong> Wickham H. (2024). ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag.
    </div>
    
    <h3>Citing Ördin</h3>
    <div class="citation-block">
      Moses J. (2025). Ördin: Community Ecology Analysis Platform. Version 3.0.<br>
      Available at: https://github.com/jm0535/0rdin
    </div>
    
    <h3>Method References</h3>
    <ul>
      <li><strong>NMDS:</strong> Kruskal JB. (1964). Psychometrika 29: 1-27.</li>
      <li><strong>PERMANOVA:</strong> Anderson MJ. (2001). Austral Ecology 26: 32-46.</li>
      <li><strong>iNEXT:</strong> Chao A, et al. (2014). Methods in Ecology and Evolution 5: 451-456.</li>
    </ul>
  `);
}

function getShortcutsContent() {
  return helpPage('⌨️', 'Keyboard Shortcuts', `
    <h2>Productivity Shortcuts</h2>
    
    <div class="shortcuts-grid">
      <div class="shortcut-item">
        <kbd>Ctrl</kbd> + <kbd>D</kbd>
        <span>Toggle Data Panel</span>
      </div>
      <div class="shortcut-item">
        <kbd>Ctrl</kbd> + <kbd>O</kbd>
        <span>Open File</span>
      </div>
      <div class="shortcut-item">
        <kbd>Ctrl</kbd> + <kbd>S</kbd>
        <span>Save Results</span>
      </div>
      <div class="shortcut-item">
        <kbd>F5</kbd>
        <span>Refresh Page</span>
      </div>
      <div class="shortcut-item">
        <kbd>F11</kbd>
        <span>Fullscreen</span>
      </div>
      <div class="shortcut-item">
        <kbd>Ctrl</kbd> + <kbd>+/-</kbd>
        <span>Zoom In/Out</span>
      </div>
    </div>
  `);
}

function getExportContent() {
  return helpPage('💾', 'Export Guide', `
    <h2>Exporting Results</h2>
    
    <h3>Data Export</h3>
    <ul>
      <li><strong>CSV:</strong> Numerical results, indices, scores</li>
      <li><strong>Excel:</strong> Multiple sheets for complex results</li>
    </ul>
    
    <h3>Plot Formats</h3>
    <ul>
      <li><strong>PNG:</strong> Raster, web/presentations</li>
      <li><strong>PDF:</strong> Vector, publications</li>
      <li><strong>SVG:</strong> Vector, editable in Illustrator</li>
      <li><strong>TIFF:</strong> High-quality raster, archival</li>
    </ul>
    
    <h3>Reproducibility</h3>
    <ul>
      <li>✓ Fixed random seeds</li>
      <li>✓ Parameter tracking</li>
      <li>✓ Package versions recorded</li>
      <li>✓ Analysis timestamps</li>
    </ul>
    
    <div class="help-warning">
      <strong>⚠️ Note:</strong> Export settings apply when clicking "Export Plot" - they don't change preview
    </div>
  `);
}

function getTroubleshootingContent() {
  return helpPage('🔧', 'Troubleshooting', `
    <h2>Common Issues & Solutions</h2>
    
    <h3>Analysis won't run</h3>
    <ul>
      <li>✓ Check data is loaded (green badge in top bar)</li>
      <li>✓ Verify numeric data (no text in matrix)</li>
      <li>✓ Check for missing values (NA)</li>
      <li>✓ For constrained ordination, load environmental data</li>
    </ul>
    
    <h3>High NMDS stress</h3>
    <ul>
      <li>Try increasing iterations (50-100)</li>
      <li>Try different distance metrics</li>
      <li>Consider 3D ordination (k=3)</li>
      <li>Check for strong outliers</li>
    </ul>
    
    <h3>Plots not updating</h3>
    <ul>
      <li>Hard refresh browser (Ctrl+Shift+R)</li>
      <li>Check browser console (F12) for errors</li>
      <li>Ensure right panel is open</li>
      <li>Try different controls</li>
    </ul>
    
    <h3>Export issues</h3>
    <ul>
      <li>Ensure analysis ran successfully</li>
      <li>Check download location permissions</li>
      <li>Try different export format</li>
      <li>Reduce DPI if file too large</li>
    </ul>
    
    <div class="help-tip">
      <strong>💡 Still stuck?</strong> Report issues at: <a href="https://github.com/jm0535/0rdin/issues" target="_blank">GitHub Issues</a>
    </div>
  `);
}

function getAboutContent() {
  return helpPage('ℹ️', 'About Ördin', `
    <h2>Development</h2>
    <p><strong>Author:</strong> Jimmy Moses</p>
    <p><strong>Email:</strong> jimmy.moses@pnguot.ac.pg</p>
    <p><strong>Institution:</strong> Papua New Guinea University of Technology</p>
    <p><strong>Version:</strong> 3.0 (2025)</p>
    
    <h3>Technology Stack</h3>
    <ul>
      <li><strong>R:</strong> 4.5.1</li>
      <li><strong>Shiny:</strong> Interactive web apps</li>
      <li><strong>Electron:</strong> Desktop framework</li>
      <li><strong>vegan:</strong> Community ecology</li>
      <li><strong>iNEXT:</strong> Diversity estimation</li>
      <li><strong>ggplot2:</strong> Graphics</li>
    </ul>
    
    <h3>License</h3>
    <p>MIT License - Open source software. Free to use, modify, and distribute with attribution.</p>
    
    <h3>Acknowledgments</h3>
    <p>Built on the excellent work of the R community. Special thanks to Jari Oksanen, Anne Chao, and the Tidyverse team.</p>
  `);
}
