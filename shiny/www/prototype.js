// Ördin v3.0 - Prototype Interactive Features

// Track current active view for toggle behavior
let currentView = 'home';
let currentRightPanel = null;

// Tab Management
let openTabs = [{ id: 'dashboard', title: '🏠 Dashboard', type: 'dashboard' }];
let activeTabId = 'dashboard';

// Add "About Ördin" function accessible from dashboard
function showAboutOrdin() {
    createNewTab('about', '✨ About Ördin', 'about');
}

// Toggle Primary Sidebar
function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    sidebar.classList.toggle('collapsed');
}

// Toggle Right Panel
function toggleRightPanel() {
    const panel = document.getElementById('rightPanel');
    panel.classList.toggle('collapsed');
}

// Switch Right Panel (VSCode behavior for right panel)
function switchRightPanel(panelType) {
    const panel = document.getElementById('rightPanel');
    const wasCollapsed = panel.classList.contains('collapsed');
    const clickedSamePanel = (currentRightPanel === panelType);
    
    // VSCode behavior: clicking same icon toggles panel
    if (clickedSamePanel && !wasCollapsed) {
        panel.classList.add('collapsed');
        currentRightPanel = null;
        return;
    }
    
    // Open panel if collapsed or switching panels
    if (wasCollapsed || !clickedSamePanel) {
        panel.classList.remove('collapsed');
    }
    
    // Update current panel
    currentRightPanel = panelType;
    
    console.log(`Switched to panel: ${panelType}`);
}

// Switch View (Activity Bar Navigation) - VSCode behavior
function switchView(view) {
    const sidebar = document.getElementById('sidebar');
    const wasCollapsed = sidebar.classList.contains('collapsed');
    const clickedSameView = (currentView === view);
    
    // VSCode behavior: clicking same icon toggles sidebar
    if (clickedSameView && !wasCollapsed) {
        sidebar.classList.add('collapsed');
        return;
    }
    
    // Update activity bar active state
    document.querySelectorAll('.activity-item').forEach(item => {
        item.classList.remove('active');
    });
    
    // Find the clicked activity item and set it as active
    const activityItem = document.getElementById('activity-' + view);
    if (activityItem) {
        activityItem.classList.add('active');
    }
    
    // Open sidebar if collapsed or switching views
    if (wasCollapsed || !clickedSameView) {
        sidebar.classList.remove('collapsed');
    }
    
    // Update current view
    currentView = view;
    
    // Update sidebar title based on view
    const sidebarTitle = document.querySelector('.sidebar-title');
    const titles = {
        'home': 'EXPLORER',
        'data': 'DATA MANAGER',
        'diversity': 'DIVERSITY',
        'ordination': 'ORDINATION',
        'results': 'RESULTS',
        'settings': 'SETTINGS',
        'help': 'HELP'
    };
    sidebarTitle.textContent = titles[view] || 'EXPLORER';
    
    // Update sidebar content dynamically
    updateSidebarContent(view);
    
    // Update breadcrumb
    const breadcrumb = document.querySelector('.breadcrumb');
    const breadcrumbs = {
        'home': 'Home → Dashboard',
        'data': 'Data → Import & Manage',
        'diversity': 'Analysis → Diversity Estimation',
        'ordination': 'Analysis → Ordination',
        'results': 'Results → Export History',
        'settings': 'Settings → Application',
        'help': 'Help → Documentation'
    };
    breadcrumb.textContent = breadcrumbs[view] || 'Home';
    
    // Update Shiny inputs if available
    if (typeof Shiny !== 'undefined') {
        Shiny.setInputValue('current_view', view, {priority: 'event'});
        Shiny.setInputValue('main_tabs', view, {priority: 'event'});
    }
    
    console.log(`Switched to: ${view}`);
}

// Update sidebar content based on active view
function updateSidebarContent(view) {
    const sidebarContent = document.querySelector('.sidebar-content');
    
    const contentMap = {
        'home': `
            <div class="section">
                <div class="section-header">▼ DATA SOURCES</div>
                <div class="section-content">
                    <div class="item active" onclick="openWorkflow('current-dataset')">📄 species_data.csv</div>
                    <div class="item" onclick="openWorkflow('import-file')">📥 Import New File</div>
                    <div class="item" onclick="openWorkflow('sample-datasets')">📚 Sample Datasets</div>
                </div>
            </div>
            <div class="section">
                <div class="section-header">▼ WORKSPACE</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('current-dataset')">📊 Current Dataset <span class="badge">45×12</span></div>
                    <div class="item" onclick="openWorkflow('metadata')">ℹ️ Metadata</div>
                    <div class="item" onclick="openWorkflow('validation')">✅ Validation <span class="badge success">OK</span></div>
                </div>
            </div>
            <div class="section">
                <div class="section-header">▼ RECENT</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('inext-analysis')">📈 iNEXT analysis <span class="badge">2m</span></div>
                    <div class="item" onclick="openWorkflow('nmds-analysis')">🔵 NMDS analysis <span class="badge">1h</span></div>
                </div>
            </div>
        `,
        'data': `
            <div class="section">
                <div class="section-header">▼ IMPORT OPTIONS</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('import-csv')">💻 Local File (CSV)</div>
                    <div class="item" onclick="openWorkflow('import-excel')">💻 Local File (Excel)</div>
                    <div class="item" onclick="openWorkflow('import-gdrive')">☁️ Google Drive</div>
                    <div class="item" onclick="openWorkflow('sample-datasets')">📚 Sample Datasets</div>
                </div>
            </div>
            <div class="section">
                <div class="section-header">▼ LOADED DATASETS</div>
                <div class="section-content">
                    <div class="item active" onclick="openWorkflow('view-species-data')">📄 species_data.csv <span class="badge success">Active</span></div>
                    <div class="item" onclick="openWorkflow('view-env-data')">🌍 env_variables.csv</div>
                </div>
            </div>
            <div class="section">
                <div class="section-header">▼ DATA VALIDATION</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('check-format')">✅ Check Format</div>
                    <div class="item" onclick="openWorkflow('preview-data')">🔍 Preview Data</div>
                    <div class="item" onclick="openWorkflow('data-summary')">📊 Data Summary</div>
                </div>
            </div>
            <div class="section">
                <div class="section-header">▼ DATA TRANSFORMATION</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('transform-log')">📉 Log Transformation</div>
                    <div class="item" onclick="openWorkflow('transform-sqrt')">√ Square Root Transform</div>
                    <div class="item" onclick="openWorkflow('transform-hellinger')">📊 Hellinger Transformation</div>
                    <div class="item" onclick="openWorkflow('transform-wisconsin')">🔢 Wisconsin Double Standardization</div>
                </div>
            </div>
        `,
        'diversity': `
            <div class="section">
                <div class="section-header">▼ ANALYSIS TYPE</div>
                <div class="section-content">
                    <div class="item active" onclick="openWorkflow('inext-estimation')">📈 Diversity Estimation (iNEXT)</div>
                    <div class="item" onclick="openWorkflow('vegan-indices')">📊 Diversity Indices (vegan)</div>
                </div>
            </div>
            <div class="section">
                <div class="section-header">▼ PLOT OPTIONS</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('plot-sample-size')">📉 Sample-Size Based</div>
                    <div class="item" onclick="openWorkflow('plot-completeness')">📈 Sample Completeness</div>
                    <div class="item" onclick="openWorkflow('plot-coverage')">📊 Coverage-Based</div>
                </div>
            </div>
            <div class="section">
                <div class="section-header">▼ PARAMETERS</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('set-confidence')">⚙️ Confidence Level</div>
                    <div class="item" onclick="openWorkflow('set-knots')">🔢 Knots</div>
                    <div class="item" onclick="openWorkflow('set-endpoint')">🎯 Endpoint</div>
                </div>
            </div>
            <div class="section">
                <div class="section-header">▼ COMPARISON TOOLS</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('compare-assemblages')">📊 Compare Assemblages</div>
                    <div class="item" onclick="openWorkflow('beta-diversity')">🔗 Beta Diversity</div>
                    <div class="item" onclick="openWorkflow('similarity-indices')">🔥 Similarity Indices</div>
                </div>
            </div>
            <div class="section">
                <div class="section-header">▼ BETA PARTITIONING (betapart)</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('betapart-taxonomic')">🦠 Taxonomic Beta Partitioning</div>
                    <div class="item" onclick="openWorkflow('betapart-functional')">🧲 Functional Beta Diversity</div>
                    <div class="item" onclick="openWorkflow('betapart-phylogenetic')">🌳 Phylogenetic Beta Diversity</div>
                    <div class="item" onclick="openWorkflow('betapart-temporal')">⏱️ Temporal Beta Diversity</div>
                    <div class="item" onclick="openWorkflow('betapart-decay')">📍 Distance-Decay Modeling</div>
                </div>
            </div>
        `,
        'ordination': `
            <div class="section">
                <div class="section-header">▼ UNCONSTRAINED ORDINATION</div>
                <div class="section-content">
                    <div class="item active" onclick="openWorkflow('nmds-analysis')">🔵 NMDS</div>
                    <div class="item" onclick="openWorkflow('pca-analysis')">🔷 PCA</div>
                    <div class="item" onclick="openWorkflow('ca-analysis')">🔶 CA</div>
                    <div class="item" onclick="openWorkflow('dca-analysis')">🟦 DCA</div>
                    <div class="item" onclick="openWorkflow('pcoa-analysis')">⬡ PCoA</div>
                </div>
            </div>
            <div class="section">
                <div class="section-header">▼ CONSTRAINED ORDINATION</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('rda-analysis')">🟢 RDA (Redundancy Analysis)</div>
                    <div class="item" onclick="openWorkflow('cca-analysis')">🟡 CCA (Canonical Correspondence)</div>
                    <div class="item" onclick="openWorkflow('dbrda-analysis')">🔴 db-RDA (Distance-based RDA)</div>
                    <div class="item" onclick="openWorkflow('cap-analysis')">🔵 CAP (Constrained Analysis Principal Coord)</div>
                </div>
            </div>
            <div class="section">
                <div class="section-header">▼ DATASETS</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('load-species')">📊 Species Data <span class="badge success">Loaded</span></div>
                    <div class="item" onclick="openWorkflow('load-environment')">🌍 Environmental Data <span class="badge">Optional</span></div>
                </div>
            </div>
            <div class="section">
                <div class="section-header">▼ STATISTICAL TESTS</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('permanova-test')">🧪 PERMANOVA</div>
                    <div class="item" onclick="openWorkflow('anosim-test')">📊 ANOSIM</div>
                    <div class="item" onclick="openWorkflow('mantel-test')">🔗 Mantel Test</div>
                    <div class="item" onclick="openWorkflow('envfit-test')">🌍 envfit (Variable Fitting)</div>
                </div>
            </div>
            <div class="section">
                <div class="section-header">▼ VISUALIZATION</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('plot-settings')">🎨 Plot Settings</div>
                    <div class="item" onclick="openWorkflow('axis-options')">📏 Axis Options</div>
                    <div class="item" onclick="openWorkflow('labels-legend')">🏷️ Labels & Legend</div>
                    <div class="item" onclick="openWorkflow('combine-plots')">🧩 Combine Plots (patchwork)</div>
                </div>
            </div>
        `,
        'results': `
            <div class="section">
                <div class="section-header">▼ EXPORT HISTORY</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('view-export-nmds')">📄 NMDS_plot.png <span class="badge">5m ago</span></div>
                    <div class="item" onclick="openWorkflow('view-export-diversity')">📊 diversity_table.csv <span class="badge">15m ago</span></div>
                    <div class="item" onclick="openWorkflow('view-export-rarefaction')">📈 rarefaction_curve.pdf <span class="badge">1h ago</span></div>
                </div>
            </div>
            <div class="section">
                <div class="section-header">▼ EXPORT OPTIONS</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('export-csv')">💾 Export as CSV</div>
                    <div class="item" onclick="openWorkflow('export-excel')">📑 Export as Excel</div>
                    <div class="item" onclick="openWorkflow('export-png')">🖼️ Export as PNG</div>
                    <div class="item" onclick="openWorkflow('export-pdf')">📄 Export as PDF</div>
                    <div class="item" onclick="openWorkflow('export-svg')">📝 Export as SVG</div>
                </div>
            </div>
            <div class="section">
                <div class="section-header">▼ SAVED ANALYSES</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('open-project-2025')">📁 Project_2025</div>
                    <div class="item" onclick="openWorkflow('open-forest-diversity')">📁 Forest_Diversity</div>
                    <div class="item" onclick="openWorkflow('manage-projects')">💾 Manage Projects</div>
                </div>
            </div>
        `,
        'settings': `
            <div class="section">
                <div class="section-header">▼ APPEARANCE</div>
                <div class="section-content">
                    <div class="item active" onclick="openWorkflow('theme-dark')">🌙 Dark Theme</div>
                    <div class="item" onclick="openWorkflow('theme-light')">☀️ Light Theme</div>
                    <div class="item" onclick="openWorkflow('theme-custom')">🎨 Custom Colors</div>
                    <div class="item" onclick="openWorkflow('font-size')">🔤 Font Size</div>
                </div>
            </div>
            <div class="section">
                <div class="section-header">▼ GENERAL</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('toggle-autosave')">💾 Auto-Save <span class="badge success">ON</span></div>
                    <div class="item" onclick="openWorkflow('notifications')">🔔 Notifications</div>
                    <div class="item" onclick="openWorkflow('language')">🌐 Language</div>
                    <div class="item" onclick="openWorkflow('default-params')">⚙️ Default Parameters</div>
                </div>
            </div>
            <div class="section">
                <div class="section-header">▼ ADVANCED</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('r-config')">🔧 R Configuration</div>
                    <div class="item" onclick="openWorkflow('package-manager')">📦 Package Manager</div>
                    <div class="item" onclick="openWorkflow('clear-cache')">🗑️ Clear Cache</div>
                    <div class="item" onclick="openWorkflow('performance')">⚡ Performance Settings</div>
                </div>
            </div>
        `,
        'help': `
            <div class="section">
                <div class="section-header">▼ DOCUMENTATION</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('user-guide')">📖 User Guide</div>
                    <div class="item" onclick="openWorkflow('tutorials')">🎓 Tutorials</div>
                    <div class="item" onclick="openWorkflow('api-reference')">📚 API Reference</div>
                    <div class="item" onclick="openWorkflow('video-tutorials')">🎥 Video Tutorials</div>
                </div>
            </div>
            <div class="section">
                <div class="section-header">▼ SUPPORT</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('faqs')">❓ FAQs</div>
                    <div class="item" onclick="openWorkflow('report-bug')">🐛 Report Bug</div>
                    <div class="item" onclick="openWorkflow('feature-request')">💡 Feature Request</div>
                    <div class="item" onclick="openWorkflow('community')">👥 Community Forum</div>
                </div>
            </div>
            <div class="section">
                <div class="section-header">▼ ABOUT</div>
                <div class="section-content">
                    <div class="item" onclick="openWorkflow('version-info')">ℹ️ Version 3.0</div>
                    <div class="item" onclick="openWorkflow('author-info')">👤 Author: Jimmy Moses</div>
                    <div class="item" onclick="openWorkflow('changelog')">📜 Changelog</div>
                    <div class="item" onclick="openWorkflow('github-repo')">⭐ GitHub Repository</div>
                    <div class="item" onclick="openWorkflow('license-info')">📜 License</div>
                    <div class="item" onclick="openWorkflow('citations')">📚 Citations & References</div>
                </div>
            </div>
        `
    };
    
    sidebarContent.innerHTML = contentMap[view] || contentMap['home'];
}

// Collapsible Sections
document.addEventListener('DOMContentLoaded', function() {
    const sectionHeaders = document.querySelectorAll('.section-header');
    sectionHeaders.forEach(header => {
        header.addEventListener('click', function() {
            const content = this.nextElementSibling;
            if (content && content.classList.contains('section-content')) {
                content.style.display = content.style.display === 'none' ? 'block' : 'none';
                this.textContent = content.style.display === 'none' 
                    ? this.textContent.replace('▼', '▶')
                    : this.textContent.replace('▶', '▼');
            }
        });
    });
});

// Add notification for prototype
window.addEventListener('load', function() {
    const notification = document.createElement('div');
    notification.style.cssText = `
        position: fixed;
        top: 50px;
        right: 20px;
        background: #2e8b57;
        color: white;
        padding: 16px 24px;
        border: 1px solid #3fa869;
        z-index: 9999;
        font-size: 13px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.3);
    `;
    notification.innerHTML = `
        <strong>🎨 UI/UX Prototype</strong><br>
        <span style="font-size: 11px; color: #e0e0e0;">
        • Click activity bar items to see sidebar changes<br>
        • No backend - visual demo only<br>
        • Shows proposed enterprise layout
        </span>
    `;
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.style.transition = 'opacity 0.5s';
        notification.style.opacity = '0';
        setTimeout(() => notification.remove(), 500);
    }, 8000);
});

// Open workflow in main canvas area
function openWorkflow(workflowId) {
    const contentArea = document.querySelector('.content-area');
    
    // Workflow content templates
    const workflows = {
        // DIVERSITY WORKFLOWS
        'inext-estimation': {
            title: '📈 Diversity Estimation (iNEXT)',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📈 Diversity Estimation (iNEXT)</h2>
                <p style="color: #888; margin-bottom: 30px;">Rarefaction and extrapolation curves for Hill numbers</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Choosing Your Data Type</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Abundance Data:</strong> Use when you have count data (e.g., number of individuals per species)<br>
                        • <strong>Incidence Data:</strong> Use for presence/absence across sampling units (e.g., species occurrence in plots)<br>
                        • If unsure, abundance data is more common for community ecology datasets
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 1: Select Data Type</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="datatype" checked> Abundance Data
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="radio" name="datatype"> Incidence/Presence-Absence Data
                    </label>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Parameter Guidelines</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Confidence Level:</strong> 0.95 (95%) is standard; use 0.99 for more conservative estimates<br>
                        • <strong>Knots:</strong> Higher values (40-50) create smoother curves; lower values (20-30) for small datasets<br>
                        • <strong>Endpoint:</strong> 2x your largest sample size is recommended for extrapolation
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 2: Configure Parameters</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Confidence Level:</label>
                        <input type="number" value="0.95" step="0.01" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Number of Knots:</label>
                        <input type="number" value="40" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                    <div>
                        <label style="color: #888; display: block; margin-bottom: 4px;">Endpoint:</label>
                        <input type="number" value="100" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Understanding Plot Types</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Sample-Size Based:</strong> Classic rarefaction - shows diversity vs. sample effort<br>
                        • <strong>Sample Completeness:</strong> Shows how complete your sampling is (0-1 scale)<br>
                        • <strong>Coverage-Based:</strong> Best for comparing assemblages with different sampling intensities
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 3: Select Plot Type</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Sample-Size Based R/E Curve
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Sample Completeness Curve
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="checkbox" checked> Coverage-Based R/E Curve
                    </label>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Run Analysis
                </button>
            `
        },
        'vegan-indices': {
            title: '📊 Diversity Indices (vegan)',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📊 Diversity Indices (vegan)</h2>
                <p style="color: #888; margin-bottom: 30px;">Calculate Shannon, Simpson, and other diversity metrics</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Choosing the Right Index</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Shannon (H'):</strong> Most common; balances richness & evenness. Higher = more diverse<br>
                        • <strong>Simpson (D):</strong> Probability two individuals are same species. Lower = more diverse<br>
                        • <strong>Inverse Simpson:</strong> More intuitive (higher = more diverse). Good for dominance<br>
                        • <strong>Pielou's J':</strong> Evenness measure (0-1). Shows how evenly species are distributed<br>
                        • <strong>Richness (S):</strong> Simple species count. Ignores abundance patterns
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Select Indices to Calculate</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Shannon (H')
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Simpson (D)
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox"> Inverse Simpson
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox"> Pielou's Evenness (J')
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="checkbox"> Species Richness (S)
                    </label>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: When to Use Each</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • Report <strong>Shannon & Simpson</strong> together for comprehensive diversity assessment<br>
                        • Use <strong>Pielou's J'</strong> to understand if communities are dominated by few species<br>
                        • <strong>Richness alone</strong> misses abundance patterns - combine with evenness metrics
                    </p>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Calculate Indices
                </button>
            `
        },
        'plot-completeness': {
            title: '📈 Sample Completeness Curve',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📈 Sample Completeness Curve</h2>
                <p style="color: #888; margin-bottom: 30px;">Visualize sample completeness across assemblages</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Display Options</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Show reference lines
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="checkbox" checked> Display confidence bands
                    </label>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Generate Plot
                </button>
            `
        },
        'plot-coverage': {
            title: '📊 Coverage-Based Curve',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📊 Coverage-Based Rarefaction/Extrapolation</h2>
                <p style="color: #888; margin-bottom: 30px;">Compare diversity at standardized coverage levels</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Coverage Settings</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Target Coverage:</label>
                        <input type="number" value="0.95" step="0.01" min="0" max="1" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                    <label style="display: block; color: #888;">
                        <input type="checkbox" checked> Interpolate to base sample
                    </label>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Generate Plot
                </button>
            `
        },
        'set-confidence': {
            title: '⚙️ Confidence Level Settings',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">⚙️ Configure Confidence Level</h2>
                <p style="color: #888; margin-bottom: 30px;">Set confidence interval for diversity estimates</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Confidence Level</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Level (0-1):</label>
                        <input type="number" value="0.95" step="0.01" min="0" max="1" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                    <p style="color: #888; font-size: 12px;">Common values: 0.90 (90%), 0.95 (95%), 0.99 (99%)</p>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ✓ Apply Settings
                </button>
            `
        },
        'set-knots': {
            title: '🔢 Knots Configuration',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🔢 Set Number of Knots</h2>
                <p style="color: #888; margin-bottom: 30px;">Control smoothness of rarefaction curves</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Knots Setting</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Number of Knots:</label>
                        <input type="number" value="40" min="10" max="100" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                    <p style="color: #888; font-size: 12px;">Higher values = smoother curves (default: 40)</p>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ✓ Apply Settings
                </button>
            `
        },
        'set-endpoint': {
            title: '🎯 Endpoint Configuration',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🎯 Set Extrapolation Endpoint</h2>
                <p style="color: #888; margin-bottom: 30px;">Define maximum sample size for extrapolation</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Endpoint Value</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Maximum Sample Size:</label>
                        <input type="number" value="100" min="10" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                    <label style="display: block; color: #888;">
                        <input type="radio" name="endpoint" checked> Use absolute value
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="radio" name="endpoint"> Use multiplier of base sample
                    </label>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ✓ Apply Settings
                </button>
            `
        },
        'plot-sample-size': {
            title: '📉 Sample-Size Based Plot',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📉 Sample-Size Based Rarefaction/Extrapolation</h2>
                <p style="color: #888; margin-bottom: 30px;">Plot diversity estimates as a function of sample size</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Plot Configuration</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Hill Number (q):</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>q = 0 (Species Richness)</option>
                            <option>q = 1 (Shannon Diversity)</option>
                            <option>q = 2 (Simpson Diversity)</option>
                        </select>
                    </div>
                    <div>
                        <label style="color: #888; display: block; margin-bottom: 4px;">Show Confidence Intervals:</label>
                        <input type="checkbox" checked> 95% CI
                    </div>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Generate Plot
                </button>
            `
        },
        // DIVERSITY COMPARISON WORKFLOWS
        'compare-assemblages': {
            title: '📊 Compare Assemblages',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📊 Compare Assemblages</h2>
                <p style="color: #888; margin-bottom: 30px;">Statistical comparison of diversity between multiple assemblages</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: When to Use Assemblage Comparison</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Multiple sites/treatments:</strong> Compare diversity across 2+ groups<br>
                        • <strong>Temporal comparisons:</strong> Track diversity changes over time<br>
                        • <strong>Spatial patterns:</strong> Compare diversity across geographic locations<br>
                        • <strong>Hypothesis testing:</strong> Test if diversity differs significantly between groups
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Overlap Detection</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        iNEXT automatically detects <strong>confidence interval overlap</strong> between assemblages:<br>
                        • <strong>No overlap:</strong> Significant difference (conservative test)<br>
                        • <strong>Overlap:</strong> No significant difference detected<br>
                        • <strong>Coverage-based comparison:</strong> Recommended for unequal sampling effort
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 1: Select Assemblages to Compare</h3>
                    <div style="background: #1e1e1e; border: 1px solid #3e3e42; padding: 12px; margin-bottom: 12px;">
                        <label style="display: block; margin-bottom: 8px; color: #888;">
                            <input type="checkbox" checked> Assemblage 1 (Forest A)
                        </label>
                        <label style="display: block; margin-bottom: 8px; color: #888;">
                            <input type="checkbox" checked> Assemblage 2 (Forest B)
                        </label>
                        <label style="display: block; margin-bottom: 8px; color: #888;">
                            <input type="checkbox"> Assemblage 3 (Grassland)
                        </label>
                        <label style="display: block; color: #888;">
                            <input type="checkbox"> Assemblage 4 (Wetland)
                        </label>
                    </div>
                    <p style="color: #888; font-size: 12px; margin: 0;">Select at least 2 assemblages to compare</p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 2: Comparison Method</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="comparison" checked> Coverage-based (recommended)
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="comparison"> Sample-size based
                    </label>
                    <div style="margin-top: 16px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Target Coverage/Sample Size:</label>
                        <input type="number" value="0.95" step="0.01" min="0" max="1" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Hill Numbers for Comparison</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        Compare all three Hill numbers (q = 0, 1, 2) for comprehensive assessment:<br>
                        • <strong>q = 0 (Richness):</strong> Total species count (sensitive to rare species)<br>
                        • <strong>q = 1 (Shannon):</strong> Effective number of common species<br>
                        • <strong>q = 2 (Simpson):</strong> Effective number of dominant species
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 3: Diversity Order (Hill Numbers)</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> q = 0 (Species Richness)
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> q = 1 (Shannon Diversity)
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="checkbox" checked> q = 2 (Simpson Diversity)
                    </label>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #d4a017; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #d4a017; font-weight: 600; margin: 0 0 8px 0;">⚠️ IMPORTANT: Interpretation Guidelines</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • Non-overlapping CIs suggest <strong>significant differences</strong><br>
                        • Overlapping CIs do NOT prove similarity (low statistical power)<br>
                        • Use <strong>coverage-based</strong> comparison when sample sizes differ<br>
                        • Consider ecological significance alongside statistical significance
                    </p>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Compare Assemblages
                </button>
            `
        },
        'beta-diversity': {
            title: '🔗 Beta Diversity',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🔗 Beta Diversity Analysis</h2>
                <p style="color: #888; margin-bottom: 30px;">Quantify compositional turnover between assemblages</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Understanding Beta Diversity</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Alpha diversity:</strong> Diversity within sites (local diversity)<br>
                        • <strong>Beta diversity:</strong> Diversity between sites (turnover/differentiation)<br>
                        • <strong>Gamma diversity:</strong> Total diversity across all sites (regional)<br>
                        • <strong>Relationship:</strong> γ = α × β (multiplicative) or γ = α + β (additive)
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Beta Diversity Frameworks</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Two main approaches:</strong><br>
                        1. <strong>Multiplicative (Whittaker 1960):</strong> β = γ/α<br>
                        &nbsp;&nbsp;&nbsp;→ Interpretation: Number of compositional units<br>
                        2. <strong>Additive (Lande 1996):</strong> β = γ - α<br>
                        &nbsp;&nbsp;&nbsp;→ Interpretation: Species not shared between sites<br><br>
                        <strong>Modern approach:</strong> Use Hill numbers for β diversity (Chao et al. 2012)
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 1: Select Beta Diversity Measure</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="betamethod" checked> Jaccard Dissimilarity (presence/absence)
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="betamethod"> Bray-Curtis Dissimilarity (abundance)
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="betamethod"> Sørensen Index
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="betamethod"> Horn-Morisita (abundance-based)
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="radio" name="betamethod"> Hill number-based β (iNEXT)
                    </label>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Choosing Beta Metrics</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Jaccard:</strong> Best for presence/absence; ranges 0-1<br>
                        • <strong>Bray-Curtis:</strong> Most common for abundance data; sensitive to dominants<br>
                        • <strong>Sørensen:</strong> Similar to Jaccard but gives more weight to shared species<br>
                        • <strong>Horn-Morisita:</strong> Less sensitive to sample size; good for abundance<br>
                        • <strong>Hill-based:</strong> Integrates with α & γ diversity; allows rarefaction
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 2: Partitioning Method</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="partition" checked> Multiplicative (β = γ/α)
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="radio" name="partition"> Additive (β = γ - α)
                    </label>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 3: Visualization Options</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Distance/dissimilarity matrix
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Heatmap visualization
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox"> Dendrogram (cluster analysis)
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="checkbox"> Partition plot (α, β, γ)
                    </label>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #d4a017; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #d4a017; font-weight: 600; margin: 0 0 8px 0;">⚠️ CAUTION: Common Pitfalls</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Sample size effects:</strong> Unequal sampling can inflate β diversity<br>
                        • <strong>Scale dependency:</strong> β increases with spatial scale<br>
                        • <strong>Metric choice matters:</strong> Different indices can give conflicting results<br>
                        • <strong>Solution:</strong> Use coverage-based standardization when possible
                    </p>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Calculate Beta Diversity
                </button>
            `
        },
        'similarity-indices': {
            title: '🔥 Similarity Indices',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🔥 Similarity/Dissimilarity Indices</h2>
                <p style="color: #888; margin-bottom: 30px;">Calculate pairwise similarity between assemblages</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Similarity vs Dissimilarity</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Similarity:</strong> How alike assemblages are (0 = different, 1 = identical)<br>
                        • <strong>Dissimilarity/Distance:</strong> How different they are (0 = identical, 1 = completely different)<br>
                        • <strong>Conversion:</strong> Dissimilarity = 1 - Similarity<br>
                        • Most ecology software uses <strong>dissimilarity</strong> (distance matrices)
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 1: Select Data Type</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="datatype" checked> Abundance data
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="radio" name="datatype"> Presence/Absence (Incidence) data
                    </label>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 2: Choose Similarity Index</h3>
                    
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 12px 0; font-size: 13px;">For Abundance Data:</p>
                    <label style="display: block; margin-bottom: 8px; color: #888; margin-left: 16px;">
                        <input type="checkbox" checked> Bray-Curtis
                    </label>
                    <label style="display: block; margin-bottom: 8px; color: #888; margin-left: 16px;">
                        <input type="checkbox"> Morisita-Horn
                    </label>
                    <label style="display: block; margin-bottom: 8px; color: #888; margin-left: 16px;">
                        <input type="checkbox"> Chao (abundance-based)
                    </label>
                    <label style="display: block; margin-bottom: 20px; color: #888; margin-left: 16px;">
                        <input type="checkbox"> Ružička (quantitative Jaccard)
                    </label>
                    
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 12px 0; font-size: 13px;">For Presence/Absence Data:</p>
                    <label style="display: block; margin-bottom: 8px; color: #888; margin-left: 16px;">
                        <input type="checkbox"> Jaccard
                    </label>
                    <label style="display: block; margin-bottom: 8px; color: #888; margin-left: 16px;">
                        <input type="checkbox"> Sørensen (Dice)
                    </label>
                    <label style="display: block; margin-bottom: 8px; color: #888; margin-left: 16px;">
                        <input type="checkbox"> Chao (incidence-based)
                    </label>
                    <label style="display: block; color: #888; margin-left: 16px;">
                        <input type="checkbox"> Simpson (asymmetric)
                    </label>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Index Properties</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Bray-Curtis:</strong> Most popular for abundance; semi-metric (violates triangle inequality)<br>
                        <strong>Jaccard:</strong> Classic for presence/absence; metric; ranges 0-1<br>
                        <strong>Sørensen:</strong> Similar to Jaccard but weights shared species 2×<br>
                        <strong>Morisita-Horn:</strong> Independent of sample size; good for abundance<br>
                        <strong>Chao indices:</strong> Account for unseen species; best for incomplete sampling
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Mathematical Formulas</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5; font-family: monospace;">
                        <strong>Bray-Curtis:</strong> BC = Σ|x<sub>i</sub>-y<sub>i</sub>| / Σ(x<sub>i</sub>+y<sub>i</sub>)<br>
                        <strong>Jaccard:</strong> J = a / (a+b+c)<br>
                        <strong>Sørensen:</strong> S = 2a / (2a+b+c)<br>
                        where a = shared species, b = unique to site 1, c = unique to site 2
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 3: Output Format</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="output" checked> Distance matrix (all pairwise comparisons)
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="output"> Heatmap visualization
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="output"> Network diagram (threshold-based)
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="radio" name="output"> Export as CSV
                    </label>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #d4a017; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #d4a017; font-weight: 600; margin: 0 0 8px 0;">⚠️ IMPORTANT: Index Selection Guidelines</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>For NMDS/clustering:</strong> Bray-Curtis or Jaccard<br>
                        • <strong>For PERMANOVA:</strong> Any metric; Bray-Curtis most common<br>
                        • <strong>Incomplete sampling:</strong> Use Chao indices<br>
                        • <strong>Unequal sample sizes:</strong> Morisita-Horn or Chao<br>
                        • <strong>Nested designs:</strong> Simpson's asymmetric index
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Advanced Options</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox"> Apply square-root transformation before calculation
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox"> Standardize by site totals
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="checkbox"> Remove rare species (singletons/doubletons)
                    </label>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Calculate Similarity Indices
                </button>
            `
        },
        // BETAPART MODULE - Beta Diversity Partitioning
        'betapart-taxonomic': {
            title: '🦠 Taxonomic Beta Partitioning (betapart)',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🦠 Taxonomic Beta Diversity Partitioning</h2>
                <p style="color: #888; margin-bottom: 30px;">Separate beta diversity into turnover and nestedness components</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Turnover vs Nestedness</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Turnover (species replacement):</strong> Species in one site replaced by different species in another<br>
                        • <strong>Nestedness (species loss/gain):</strong> One assemblage is subset of another<br>
                        • <strong>Total beta = Turnover + Nestedness</strong><br>
                        • <strong>Why partition?</strong> Different ecological processes drive each component
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Baselga Framework</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>For Sørensen dissimilarity (presence/absence):</strong><br>
                        β<sub>SOR</sub> = β<sub>SIM</sub> + β<sub>SNE</sub><br>
                        where β<sub>SIM</sub> = turnover, β<sub>SNE</sub> = nestedness-resultant<br><br>
                        <strong>For Jaccard dissimilarity:</strong><br>
                        β<sub>JAC</sub> = β<sub>JTU</sub> + β<sub>JNE</sub><br><br>
                        <strong>For Bray-Curtis (abundance-based):</strong><br>
                        β<sub>BC</sub> = β<sub>BC-BAL</sub> + β<sub>BC-GRA</sub><br>
                        where BAL = balanced variation, GRA = abundance gradient
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 1: Select Analysis Type</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="betaparttype" checked> Pair-wise dissimilarities (all pairs of sites)
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="radio" name="betaparttype"> Multiple-site dissimilarity (overall beta)
                    </label>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 2: Select Index Family</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">For Incidence Data (presence/absence):</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Sørensen family (β.SOR, β.SIM, β.SNE)</option>
                            <option>Jaccard family (β.JAC, β.JTU, β.JNE)</option>
                        </select>
                    </div>
                    <div>
                        <label style="color: #888; display: block; margin-bottom: 4px;">For Abundance Data:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Bray-Curtis (β.BC, β.BC-BAL, β.BC-GRA)</option>
                            <option>Rúzicka (β.RUZ, β.RUZ-BAL, β.RUZ-GRA)</option>
                        </select>
                    </div>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Interpreting Components</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>High turnover:</strong> Environmental filtering, dispersal limitation<br>
                        <strong>High nestedness:</strong> Selective colonization/extinction, habitat loss<br>
                        <strong>Example:</strong> Islands typically show nestedness (species loss with distance); mountain gradients show turnover (species replacement)
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 3: Output Options</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Distance matrices (total, turnover, nestedness)
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Summary table
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox"> Tri-plot visualization
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="checkbox"> Export matrices as CSV
                    </label>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #d4a017; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #d4a017; font-weight: 600; margin: 0 0 8px 0;">⚠️ IMPORTANT: Citation Required</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        If using betapart for taxonomic partitioning, cite:<br>
                        <em>Baselga, A., & Orme, C. D. L. (2012). betapart: an R package for the study of beta diversity. Methods in Ecology and Evolution, 3(5), 808-812.</em>
                    </p>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Run Beta Partitioning
                </button>
            `
        },
        'betapart-functional': {
            title: '🧲 Functional Beta Diversity (betapart)',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🧲 Functional Beta Diversity Partitioning</h2>
                <p style="color: #888; margin-bottom: 30px;">Partition functional beta diversity into turnover and nestedness based on species traits</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Functional vs Taxonomic Beta</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Taxonomic:</strong> Based on species identity (presence/absence)<br>
                        • <strong>Functional:</strong> Based on trait differences (ecological roles)<br>
                        • <strong>When to use:</strong> When trait diversity matters more than species identity<br>
                        • <strong>Example:</strong> Different tree species with similar traits = low functional turnover
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Functional Space Approach</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        betapart uses <strong>convex hull volume</strong> in trait space:<br>
                        • Each assemblage = convex hull in multidimensional trait space<br>
                        • Intersection = shared functional space<br>
                        • Partitioning based on Villéger et al. (2013) framework<br>
                        • Captures trait diversity independent of species richness
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 1: Load Trait Data</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox"> Load species trait matrix
                    </label>
                    <p style="color: #666; font-size: 11px; margin: 0;">Rows = species, Columns = traits (numeric)</p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 2: Configure Analysis</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Functional Space Dimensionality:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Automatic (PCoA-based)</option>
                            <option>2D (for visualization)</option>
                            <option>3D</option>
                            <option>4D+ (full dimensionality)</option>
                        </select>
                    </div>
                    <label style="display: block; color: #888;">
                        <input type="checkbox" checked> Standardize traits (recommended)
                    </label>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #d4a017; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #d4a017; font-weight: 600; margin: 0 0 8px 0;">⚠️ CAUTION: Computational Intensity</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        Convex hull calculations can be slow for:<br>
                        • High-dimensional trait spaces (&gt;6 traits)<br>
                        • Many species (&gt;100 per assemblage)<br>
                        • Consider trait reduction (PCA) for large datasets
                    </p>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Calculate Functional Beta
                </button>
            `
        },
        'betapart-phylogenetic': {
            title: '🌳 Phylogenetic Beta Diversity (betapart)',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🌳 Phylogenetic Beta Diversity Partitioning</h2>
                <p style="color: #888; margin-bottom: 30px;">Partition phylogenetic beta diversity based on evolutionary relationships</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: When to Use Phylogenetic Beta</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Phylogenetic diversity:</strong> Captures evolutionary history turnover<br>
                        • <strong>Beyond species counts:</strong> Related species = less phylogenetic diversity<br>
                        • <strong>Conservation:</strong> Prioritize areas with unique evolutionary lineages<br>
                        • <strong>Requires:</strong> Phylogenetic tree for all species
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 1: Load Phylogenetic Tree</h3>
                    <button style="background: #2a2a2a; border: 1px solid #3e3e42; color: #cccccc; padding: 12px 24px; cursor: pointer;">
                        🌳 Load Tree File (Newick/Nexus)
                    </button>
                    <p style="color: #666; font-size: 11px; margin-top: 12px;">Must include all species in community data</p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Phylogenetic Metrics</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        betapart calculates:<br>
                        • <strong>phylo.beta.multi:</strong> Overall phylogenetic beta across all sites<br>
                        • <strong>phylo.beta.pair:</strong> Pair-wise phylogenetic beta<br>
                        • <strong>Partitioning:</strong> Turnover (lineage replacement) vs nestedness (lineage loss)
                    </p>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Calculate Phylogenetic Beta
                </button>
            `
        },
        'betapart-temporal': {
            title: '⏱️ Temporal Beta Diversity (betapart)',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">⏱️ Temporal Beta Diversity</h2>
                <p style="color: #888; margin-bottom: 30px;">Quantify compositional change over time</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Temporal vs Spatial Beta</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Temporal beta:</strong> Compositional change at same sites over time<br>
                        • <strong>Paired samples:</strong> Time 1 vs Time 2 for each site<br>
                        • <strong>Applications:</strong> Climate change, disturbance recovery, succession<br>
                        • <strong>Interpretation:</strong> Turnover = species replacement; Nestedness = species loss
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Data Structure</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="temporal" checked> Two time periods (baseline vs current)
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="radio" name="temporal"> Multiple time series
                    </label>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: beta.temp Function</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        Computes temporal beta diversity for paired samples:<br>
                        • Automatically matches sites between time periods<br>
                        • Calculates turnover & nestedness components<br>
                        • Useful for before-after impact assessment
                    </p>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Calculate Temporal Beta
                </button>
            `
        },
        'betapart-decay': {
            title: '📍 Distance-Decay Modeling (betapart)',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📍 Distance-Decay Modeling</h2>
                <p style="color: #888; margin-bottom: 30px;">Model relationship between compositional dissimilarity and geographic/environmental distance</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Distance-Decay of Similarity</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Concept:</strong> Compositional similarity decreases with distance<br>
                        • <strong>Models:</strong> Exponential, power-law, or linear decay<br>
                        • <strong>Applications:</strong> Dispersal limitation, environmental gradients<br>
                        • <strong>Compare slopes:</strong> Turnover vs nestedness decay rates
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: decay.model Function</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Models fitted:</strong><br>
                        1. <strong>Exponential:</strong> y = c + ae<sup>-bx</sup><br>
                        2. <strong>Power-law:</strong> y = c + ax<sup>b</sup><br>
                        3. <strong>Linear:</strong> y = a + bx<br><br>
                        • Compares AIC to select best model<br>
                        • Bootstrap confidence intervals available<br>
                        • Separate models for total, turnover, nestedness
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 1: Distance Data</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="distance" checked> Geographic distance (coordinates)
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="distance"> Environmental distance
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="radio" name="distance"> Custom distance matrix
                    </label>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 2: Model Selection</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Exponential model
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Power-law model
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox"> Linear model
                    </label>
                    <div style="margin-top: 16px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Bootstrap Replicates:</label>
                        <input type="number" value="100" min="0" max="1000" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #d4a017; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #d4a017; font-weight: 600; margin: 0 0 8px 0;">⚠️ IMPORTANT: Interpretation</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Steeper slope:</strong> Faster compositional change with distance<br>
                        <strong>Compare components:</strong> If turnover slope >> nestedness slope, dispersal limitation dominates<br>
                        <strong>Statistical test:</strong> Use zdep() to test if slopes differ between two datasets
                    </p>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Fit Distance-Decay Models
                </button>
            `
        },
        // ORDINATION WORKFLOWS
        'nmds-analysis': {
            title: '🔵 NMDS Analysis',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🔵 Non-metric Multidimensional Scaling (NMDS)</h2>
                <p style="color: #888; margin-bottom: 30px;">Ordination method for community composition analysis</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: When to Use NMDS</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Best for:</strong> Ecological community data with non-linear species responses<br>
                        • <strong>Advantages:</strong> Makes no assumptions about data distribution; handles any distance metric<br>
                        • <strong>Goal:</strong> Stress value &lt; 0.2 (excellent &lt; 0.1, good &lt; 0.15, acceptable &lt; 0.2)
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 1: Configure NMDS</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Number of Dimensions:</label>
                        <input type="number" value="2" min="1" max="3" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Distance Metric:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Bray-Curtis</option>
                            <option>Jaccard</option>
                            <option>Euclidean</option>
                            <option>Manhattan</option>
                        </select>
                    </div>
                    <div>
                        <label style="color: #888; display: block; margin-bottom: 4px;">Maximum Iterations:</label>
                        <input type="number" value="200" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Choosing Distance Metrics</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Bray-Curtis:</strong> Best for abundance data (default choice for ecology)<br>
                        • <strong>Jaccard:</strong> Best for presence/absence data<br>
                        • <strong>Euclidean:</strong> For linear relationships or environmental variables<br>
                        • <strong>Manhattan:</strong> Robust to outliers; good for sparse data
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 2: Environmental Overlay (Optional)</h3>
                    <label style="display: block; color: #888;">
                        <input type="checkbox"> Fit environmental variables
                    </label>
                    <p style="color: #666; font-size: 11px; margin-top: 8px;">Requires environmental data to be loaded</p>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Run NMDS
                </button>
            `
        },
        'pca-analysis': {
            title: '🔷 PCA Analysis',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🔷 Principal Component Analysis (PCA)</h2>
                <p style="color: #888; margin-bottom: 30px;">Linear ordination for Euclidean distance-based analysis</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Configuration</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Center variables
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Scale variables
                    </label>
                    <div style="margin-top: 16px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Biplot Type:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Type I (Distance biplot)</option>
                            <option>Type II (Correlation biplot)</option>
                        </select>
                    </div>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Run PCA
                </button>
            `
        },
        'ca-analysis': {
            title: '🔶 CA Analysis',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🔶 Correspondence Analysis (CA)</h2>
                <p style="color: #888; margin-bottom: 30px;">Ordination for species abundance data (chi-square distance)</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Options</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Axes to Display:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Axes 1 & 2</option>
                            <option>Axes 1 & 3</option>
                            <option>Axes 2 & 3</option>
                        </select>
                    </div>
                    <label style="display: block; color: #888;">
                        <input type="checkbox" checked> Show species scores
                    </label>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Run CA
                </button>
            `
        },
        'dca-analysis': {
            title: '🟦 DCA Analysis',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🟦 Detrended Correspondence Analysis (DCA)</h2>
                <p style="color: #888; margin-bottom: 30px;">CA with detrending to remove arch effect</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Detrending Options</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Detrending Method:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Polynomial (default)</option>
                            <option>Segments</option>
                        </select>
                    </div>
                    <label style="display: block; color: #888;">
                        <input type="checkbox" checked> Rescale axes
                    </label>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Run DCA
                </button>
            `
        },
        'pcoa-analysis': {
            title: '⬡ PCoA Analysis',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">⬡ Principal Coordinates Analysis (PCoA)</h2>
                <p style="color: #888; margin-bottom: 30px;">Metric ordination for any distance matrix</p>
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Distance Matrix</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Distance Metric:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Bray-Curtis</option>
                            <option>Jaccard</option>
                            <option>Euclidean</option>
                            <option>Manhattan</option>
                        </select>
                    </div>
                    <div>
                        <label style="color: #888; display: block; margin-bottom: 4px;">Number of Dimensions:</label>
                        <input type="number" value="2" min="1" max="3" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Run PCoA
                </button>
            `
        },
        'rda-analysis': {
            title: '🟢 RDA - Redundancy Analysis',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🟢 Redundancy Analysis (RDA)</h2>
                <p style="color: #888; margin-bottom: 30px;">Constrained ordination for linear responses</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: RDA vs CCA</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Use RDA:</strong> Linear species responses (short gradients &lt; 3 SD)<br>
                        • <strong>Use CCA:</strong> Unimodal responses (long gradients &gt; 4 SD)<br>
                        • Run DCA first to check gradient length
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 1: Load Required Datasets</h3>
                    <label style="display: block; color: #888;">
                        <input type="checkbox"> Load species data
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="checkbox"> Load environmental data
                    </label>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Variable Selection</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • Avoid correlated variables (r &gt; 0.7)<br>
                        • Center & scale if different units<br>
                        • Max variables: N/10 (e.g., 45 samples = 4-5 vars)
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 2: Configure RDA</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Center variables
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Scale variables
                    </label>
                    <div style="margin-top: 16px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Biplot Type:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Type I (Distance biplot)</option>
                            <option>Type II (Correlation biplot)</option>
                        </select>
                    </div>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 3: Run RDA</h3>
                    <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                        ▶ Run RDA
                    </button>
                </div>
            `
        },
        'cca-analysis': {
            title: '🟡 CCA - Canonical Correspondence Analysis',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🟡 Canonical Correspondence Analysis</h2>
                <p style="color: #888; margin-bottom: 30px;">Constrained ordination for unimodal responses</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: When to Use CCA</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • Best for species data along long environmental gradients<br>
                        • Assumes unimodal (hump-shaped) species distributions<br>
                        • Good for ecological community data across environmental gradients
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Configure CCA</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Center variables
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Scale variables
                    </label>
                    <div style="margin-top: 16px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Biplot Type:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Type I (Distance biplot)</option>
                            <option>Type II (Correlation biplot)</option>
                        </select>
                    </div>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Run CCA</h3>
                    <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                        ▶ Run CCA
                    </button>
                </div>
            `
        },
        'dbrda-analysis': {
            title: '🔴 db-RDA - Distance-based RDA',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🔴 Distance-based Redundancy Analysis (db-RDA)</h2>
                <p style="color: #888; margin-bottom: 30px;">Constrained ordination using any distance measure</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: When to Use db-RDA</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Best for:</strong> Ecological distances (Bray-Curtis, Jaccard) with environmental constraints<br>
                        • <strong>Advantage over RDA:</strong> Can use non-Euclidean distances<br>
                        • <strong>Use instead of CCA:</strong> When you prefer distance-based methods<br>
                        • <strong>Alternative name:</strong> CAP (Constrained Analysis of Principal Coordinates)
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Distance Measure</h3>
                    <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                        <option>Bray-Curtis</option>
                        <option>Jaccard</option>
                        <option>Euclidean</option>
                    </select>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Run db-RDA
                </button>
            `
        },
        'cap-analysis': {
            title: '🔵 CAP Analysis',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🔵 Constrained Analysis of Principal Coordinates</h2>
                <p style="color: #888; margin-bottom: 30px;">Discriminant analysis in distance-based ordination space</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: CAP Applications</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Group discrimination:</strong> Classify assemblages by habitat/treatment<br>
                        • <strong>Cross-validation:</strong> Test classification accuracy<br>
                        • <strong>Impact assessment:</strong> Separate impacted from control sites
                    </p>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Run CAP
                </button>
            `
        },
        'anosim-test': {
            title: '📊 ANOSIM Test',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📊 ANOSIM - Analysis of Similarities</h2>
                <p style="color: #888; margin-bottom: 30px;">Non-parametric test for differences between groups</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: ANOSIM vs PERMANOVA</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>PERMANOVA:</strong> More powerful, preferred method<br>
                        • <strong>ANOSIM:</strong> Tests rank distances (0-1 scale)<br>
                        • <strong>R > 0.75:</strong> Well separated groups
                    </p>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Run ANOSIM
                </button>
            `
        },
        'mantel-test': {
            title: '🔗 Mantel Test',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🔗 Mantel Test</h2>
                <p style="color: #888; margin-bottom: 30px;">Test correlation between two distance matrices</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Common Applications</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Isolation by distance:</strong> Geographic vs ecological distance<br>
                        • <strong>Environment-community:</strong> Test correlations<br>
                        • <strong>Permutations:</strong> 999 standard
                    </p>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Run Mantel Test
                </button>
            `
        },
        'envfit-test': {
            title: '🌍 envfit - Variable Fitting',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🌍 envfit - Fit Environmental Variables</h2>
                <p style="color: #888; margin-bottom: 30px;">Overlay environmental vectors/factors on ordination</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: When to Use envfit</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Post-hoc interpretation:</strong> After NMDS/PCA/PCoA<br>
                        • <strong>Continuous variables:</strong> Shown as vectors (arrows)<br>
                        • <strong>Categorical variables:</strong> Shown as centroids
                    </p>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Fit Variables
                </button>
            `
        },
        'permanova-test': {
            title: '🧪 PERMANOVA Test',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🧪 PERMANOVA</h2>
                <p style="color: #888; margin-bottom: 30px;">Test for differences between groups</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Understanding PERMANOVA</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • Non-parametric alternative to MANOVA<br>
                        • Tests if groups have different multivariate centroids<br>
                        • <strong>Assumption:</strong> Similar dispersion among groups (check with betadisper)<br>
                        • <strong>Permutations:</strong> 999 is standard (p-value resolution of 0.001)
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Configuration</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Distance Metric:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Bray-Curtis</option>
                            <option>Jaccard</option>
                            <option>Euclidean</option>
                            <option>Manhattan</option>
                        </select>
                    </div>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Number of Permutations:</label>
                        <input type="number" value="999" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                    <div>
                        <label style="color: #888; display: block; margin-bottom: 4px;">Grouping Variable:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Group1</option>
                            <option>Group2</option>
                            <option>Group3</option>
                        </select>
                    </div>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Run PERMANOVA
                </button>
            `
        },
        // DATA TRANSFORMATION WORKFLOWS
        'transform-log': {
            title: '📉 Log Transformation',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📉 Log Transformation</h2>
                <p style="color: #888; margin-bottom: 30px;">Reduce the influence of highly abundant species</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: When to Use Log Transformation</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>High variance:</strong> When abundance values span multiple orders of magnitude<br>
                        • <strong>Right-skewed data:</strong> Many small values, few very large values<br>
                        • <strong>Before RDA/PCA:</strong> These methods assume linear relationships<br>
                        • <strong>NOT for:</strong> Data with many zeros (use log(x+1) or log(x+c) instead)
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 1: Select Transformation Type</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="logtype" checked> log(x + 1) — Handles zeros
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="logtype"> log(x) — Natural log (data must have no zeros)
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="logtype"> log10(x + 1) — Base-10 log
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="radio" name="logtype"> log(x + c) — Custom constant
                    </label>
                    <div style="margin-top: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Custom Constant (c):</label>
                        <input type="number" value="0.5" step="0.1" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Why Log Transformation Works</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Stabilizes variance:</strong> Converts multiplicative effects to additive<br>
                        • <strong>Down-weights dominants:</strong> Abundant species have less influence on analyses<br>
                        • <strong>Linearizes relationships:</strong> Exponential patterns become linear<br>
                        • <strong>Historical use:</strong> Common in ecology before specialized methods (Hellinger, etc.)
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #d4a017; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #d4a017; font-weight: 600; margin: 0 0 8px 0;">⚠️ CAUTION: Consider Alternatives</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        For RDA/PCA on species data, <strong>Hellinger transformation is often preferred</strong> (Legendre & Gallagher 2001).<br>
                        Log transformation changes ecological distances in ways that may not be meaningful.
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 2: Preview Effect</h3>
                    <label style="display: block; color: #888;">
                        <input type="checkbox" checked> Show distribution comparison (before/after)
                    </label>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Apply Transformation
                </button>
            `
        },
        'transform-sqrt': {
            title: '√ Square Root Transformation',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">√ Square Root Transformation</h2>
                <p style="color: #888; margin-bottom: 30px;">Moderate transformation for count data</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: When to Use Square Root</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Moderate skewness:</strong> Less extreme than log transformation<br>
                        • <strong>Count data:</strong> Especially good for Poisson-distributed data<br>
                        • <strong>Preserve structure:</strong> Maintains more of the original data structure than log<br>
                        • <strong>Safe with zeros:</strong> √0 = 0, no need to add constants
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Transformation Options</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="sqrttype" checked> Square root — √x
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="sqrttype"> Fourth root — ∜x (even gentler)
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="radio" name="sqrttype"> Wisconsin sqrt — Double standardization + √
                    </label>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Comparison with Other Methods</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Transformation strength (weakest → strongest):</strong><br>
                        Fourth root &lt; Square root &lt; Log &lt; Presence/Absence<br><br>
                        • <strong>Square root:</strong> Good balance for most ecological data<br>
                        • <strong>Gentler than log:</strong> Dominant species still have influence<br>
                        • <strong>Statistical basis:</strong> Variance-stabilizing for Poisson counts
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Historical Context</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        Widely used in classical community ecology (Clarke & Warwick 2001). Recommended for NMDS and cluster analysis on species abundance data when you want to down-weight dominants moderately.
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Data Preview</h3>
                    <label style="display: block; color: #888;">
                        <input type="checkbox" checked> Show distribution histogram
                    </label>
                    <label style="display: block; color: #888; margin-top: 8px;">
                        <input type="checkbox"> Calculate effect on most abundant species
                    </label>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Apply Transformation
                </button>
            `
        },
        'transform-hellinger': {
            title: '📊 Hellinger Transformation',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📊 Hellinger Transformation</h2>
                <p style="color: #888; margin-bottom: 30px;">Optimal for RDA with species abundance data</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Why Hellinger for RDA?</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Best practice for RDA:</strong> Recommended by Legendre & Gallagher (2001)<br>
                        • <strong>Gives Euclidean distance</strong> meaningful ecological interpretation<br>
                        • <strong>Removes double-zero problem:</strong> Absent species don't affect similarity<br>
                        • <strong>Use instead of:</strong> Raw data for RDA/PCA on species abundance
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: How Hellinger Works</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Two-step process:</strong><br>
                        1. Divide each value by row total (site relativization)<br>
                        2. Take square root of result<br><br>
                        <strong>Formula:</strong> y'<sub>ij</sub> = √(y<sub>ij</sub> / y<sub>i+</sub>)<br><br>
                        This converts abundance data to "relative abundance" scale (0-1), then applies gentle transformation.
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #d4a017; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #d4a017; font-weight: 600; margin: 0 0 8px 0;">⚠️ IMPORTANT: Citation Required</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        If using Hellinger transformation in publications, cite:<br>
                        <em>Legendre, P., & Gallagher, E. D. (2001). Ecologically meaningful transformations for ordination of species data. Oecologia, 129(2), 271-280.</em>
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Transformation Settings</h3>
                    <p style="color: #888; font-size: 13px; margin-bottom: 16px;">Hellinger transformation has no parameters — it's a standardized method.</p>
                    <label style="display: block; color: #888;">
                        <input type="checkbox" checked> Show transformation effect summary
                    </label>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: When NOT to Use Hellinger</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>For CA/CCA:</strong> Use raw data (chi-square distance is built-in)<br>
                        • <strong>For presence/absence:</strong> No transformation needed<br>
                        • <strong>For environmental data:</strong> Use centering/scaling instead<br>
                        • <strong>For NMDS:</strong> Optional (can use raw data with Bray-Curtis)
                    </p>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Apply Hellinger Transformation
                </button>
            `
        },
        'transform-wisconsin': {
            title: '🔢 Wisconsin Double Standardization',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🔢 Wisconsin Double Standardization</h2>
                <p style="color: #888; margin-bottom: 30px;">Standardize by species maxima, then by site totals</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: When to Use Wisconsin</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Varying species abundances:</strong> When some species are inherently more abundant<br>
                        • <strong>Unequal sampling effort:</strong> Different sample sizes across sites<br>
                        • <strong>Before PCA/RDA:</strong> When species need equal weighting<br>
                        • <strong>Classic method:</strong> Widely used in vegetation ecology
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: How Wisconsin Works</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Two-step standardization:</strong><br>
                        1. <strong>Species standardization:</strong> Divide each species by its maximum across all sites<br>
                        &nbsp;&nbsp;&nbsp;→ All species now range from 0 to 1<br>
                        2. <strong>Site standardization:</strong> Divide each site by its row total<br>
                        &nbsp;&nbsp;&nbsp;→ All sites now sum to 1<br><br>
                        <strong>Effect:</strong> Equalizes influence of rare and common species, and small and large samples.
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Standardization Options</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="wisconsin" checked> Wisconsin (species max, then site totals)
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="radio" name="wisconsin"> Species totals only (divide by column sums)
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="radio" name="wisconsin"> Site totals only (divide by row sums)
                    </label>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Comparison with Alternatives</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>vs. Hellinger:</strong> More aggressive standardization; Hellinger preferred for RDA<br>
                        • <strong>vs. Simple relativization:</strong> Wisconsin gives equal weight to all species<br>
                        • <strong>Historical note:</strong> Named after Wisconsin school of vegetation ecology<br>
                        • <strong>Modern use:</strong> Less common now; Hellinger/chord often preferred
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #d4a017; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #d4a017; font-weight: 600; margin: 0 0 8px 0;">⚠️ CAUTION: Loss of Quantitative Information</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        Wisconsin treats rare and abundant species equally. You lose information about species dominance patterns. Consider whether this is appropriate for your question.
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Preview</h3>
                    <label style="display: block; color: #888;">
                        <input type="checkbox" checked> Show effect on species ranges
                    </label>
                    <label style="display: block; color: #888; margin-top: 8px;">
                        <input type="checkbox"> Display standardized vs. original data
                    </label>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Apply Wisconsin Standardization
                </button>
            `
        },
        'import-csv': {
            title: '💻 Import CSV File',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">💻 Import Local CSV File</h2>
                <p style="color: #888; margin-bottom: 30px;">Load community ecology data from CSV format</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Data Format Requirements</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Rows:</strong> Samples/sites (e.g., Site1, Site2...)<br>
                        • <strong>Columns:</strong> Species (e.g., Sp1, Sp2...)<br>
                        • <strong>Values:</strong> Abundance counts or presence/absence (0/1)<br>
                        • First row should be species names, first column should be site names
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 1: Select CSV File</h3>
                    <input type="file" accept=".csv" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 2: Configure Data</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> First row contains species names
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> First column contains site names
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox"> Data is transposed (species x sites)
                    </label>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Import CSV
                </button>
            `
        },
        'labels-legend': {
            title: '🏷️ Labels & Legend',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🏷️ Labels & Legend</h2>
                <p style="color: #888; margin-bottom: 30px;">Configure plot labels and legend</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Plot Configuration</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Title:</label>
                        <input type="text" value="My Plot" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">X-axis Label:</label>
                        <input type="text" value="X-axis" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Distance Metric:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Bray-Curtis</option>
                            <option>Jaccard</option>
                            <option>Euclidean</option>
                            <option>UniFrac</option>
                        </select>
                    </div>
                    <label style="display: block; color: #888;">
                        <input type="checkbox"> Correct for negative eigenvalues
                    </label>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Run PCoA
                </button>
            `
        },
        'load-species': {
            title: '📊 Load Species Data',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📊 Load Species Composition Data</h2>
                <p style="color: #888; margin-bottom: 30px;">Primary dataset for ordination analysis</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Current Dataset</h3>
                    <p style="color: #2e8b57;">✓ species_data.csv <span style="color: #888;">(45 samples × 12 species)</span></p>
                    <button style="background: #2a2a2a; border: 1px solid #3e3e42; color: #cccccc; padding: 8px 16px; margin-top: 12px; cursor: pointer;">
                        📁 Load Different File
                    </button>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Data Preview</h3>
                    <p style="color: #888; font-size: 12px;">Table preview would appear here</p>
                </div>
            `
        },
        'load-environment': {
            title: '🌍 Load Environmental Data',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🌍 Load Environmental Variables (Optional)</h2>
                <p style="color: #888; margin-bottom: 30px;">Secondary dataset for constrained ordination and overlays</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Import Environmental Data</h3>
                    <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                        📁 Browse Files...
                    </button>
                    <p style="color: #888; margin-top: 12px; font-size: 12px;">Variables: pH, temperature, moisture, etc.</p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Requirements</h3>
                    <p style="color: #888; font-size: 13px;">• Same number of rows as species data<br>• Numeric variables only<br>• Row names must match species data</p>
                </div>
            `
        },
        'plot-settings': {
            title: '🎨 Plot Settings',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🎨 Customize Plot Appearance</h2>
                <p style="color: #888; margin-bottom: 30px;">Configure colors, symbols, and visual elements for publication-quality figures</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Color Palette Selection</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Viridis/Plasma:</strong> Colorblind-friendly, perceptually uniform<br>
                        • <strong>Set1/Paired:</strong> Good for categorical groups (&lt;8 categories)<br>
                        • <strong>Grayscale:</strong> For black & white publications<br>
                        • <strong>Custom:</strong> Match your institution/publication colors
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Color Palette</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Color Scheme:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Viridis (colorblind-safe)</option>
                            <option>Plasma</option>
                            <option>Set1 (categorical)</option>
                            <option>Paired</option>
                            <option>RdYlBu (diverging)</option>
                            <option>Grayscale</option>
                            <option>Custom colors</option>
                        </select>
                    </div>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Publication Standards</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Journal requirements:</strong><br>
                        • <strong>Point size:</strong> 2-4 for scatter plots (readable at column width)<br>
                        • <strong>Line width:</strong> 1-2 pt for axes, 0.5-1 pt for grid<br>
                        • <strong>Font size:</strong> 10-12pt for labels (match journal style)<br>
                        • <strong>Resolution:</strong> 300+ DPI for print, 150 DPI for web
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Symbol Options</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Point Shape:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Circle (●)</option>
                            <option>Square (■)</option>
                            <option>Triangle (▲)</option>
                            <option>Diamond (◆)</option>
                            <option>Plus (+)</option>
                        </select>
                    </div>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Point Size:</label>
                        <input type="range" min="1" max="10" value="3" style="width: 100%;">
                        <p style="color: #666; font-size: 11px; margin: 4px 0 0 0;">Current: 3pt</p>
                    </div>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Point Transparency (alpha):</label>
                        <input type="range" min="0" max="100" value="80" style="width: 100%;">
                        <p style="color: #666; font-size: 11px; margin: 4px 0 0 0;">Current: 80%</p>
                    </div>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Background & Grid</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Show grid lines
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox"> White background (for publication)
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="checkbox"> Transparent background (for slides)
                    </label>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #d4a017; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #d4a017; font-weight: 600; margin: 0 0 8px 0;">⚠️ IMPORTANT: Accessibility</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        Avoid red-green combinations (8% of males are colorblind). Use Viridis or add point shapes for group differentiation.
                    </p>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ✓ Apply Settings
                </button>
            `
        },
        'axis-options': {
            title: '📏 Axis Options',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📏 Configure Axis Settings</h2>
                <p style="color: #888; margin-bottom: 30px;">Customize axis labels, ranges, scaling, and tick marks</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Axis Scaling for Ordination</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Equal aspect ratio:</strong> Essential for NMDS, PCA, PCoA (preserves distances)<br>
                        • <strong>Free scaling:</strong> OK for RDA/CCA (emphasizes variation)<br>
                        • <strong>Include zero:</strong> Not necessary for ordination plots<br>
                        • <strong>Axis labels:</strong> Include % variance explained for PCA/RDA/CCA
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Axis Labels</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">X-Axis Label:</label>
                        <input type="text" value="NMDS1" placeholder="e.g., NMDS1, PC1 (45.2%)" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Y-Axis Label:</label>
                        <input type="text" value="NMDS2" placeholder="e.g., NMDS2, PC2 (23.1%)" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Font Size:</label>
                        <input type="number" value="12" min="8" max="24" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Variance Explained</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        For PCA, RDA, CCA, include % variance explained in axis labels:<br>
                        • <strong>Example:</strong> "PC1 (45.2%)" or "RDA1 (32.1% of fitted variation)"<br>
                        • <strong>NMDS:</strong> Report stress value in plot caption instead<br>
                        • <strong>Good practice:</strong> Report cumulative variance for first 2-3 axes
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Axis Scaling</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Equal aspect ratio (1:1)
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox"> Include origin (0,0)
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="checkbox"> Symmetric axes (same +/- range)
                    </label>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Tick Marks & Grid</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Number of Tick Marks:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Automatic</option>
                            <option>3</option>
                            <option>5</option>
                            <option>7</option>
                            <option>10</option>
                        </select>
                    </div>
                    <label style="display: block; color: #888;">
                        <input type="checkbox" checked> Show minor grid lines
                    </label>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ✓ Apply Settings
                </button>
            `
        },
        'labels-legend': {
            title: '🏷️ Labels & Legend',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🏷️ Configure Labels and Legend</h2>
                <p style="color: #888; margin-bottom: 30px;">Manage point labels, legend position, and plot title</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Sample Labels vs Legend</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Small datasets (&lt;20 samples):</strong> Can show sample labels directly<br>
                        • <strong>Large datasets (&gt;20 samples):</strong> Use legend for groups only<br>
                        • <strong>Interactive plots:</strong> Enable hover tooltips instead of permanent labels<br>
                        • <strong>Publication:</strong> Label only key/outlier samples to reduce clutter
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Plot Title</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Title:</label>
                        <input type="text" placeholder="e.g., NMDS of Forest Communities (Stress=0.12)" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Subtitle:</label>
                        <input type="text" placeholder="e.g., Bray-Curtis distance on square-root transformed data" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Legend Best Practices</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Position:</strong> Top-right default; move if it obscures data<br>
                        • <strong>Background:</strong> Semi-transparent white for readability<br>
                        • <strong>Order:</strong> Match factor levels or arrange alphabetically<br>
                        • <strong>Size:</strong> Proportional to plot (not too large)
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Sample Labels</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox"> Show all sample labels
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox"> Show labels for selected samples only
                    </label>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Enable hover tooltips
                    </label>
                    <div style="margin-top: 16px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Label Size:</label>
                        <input type="number" value="10" min="6" max="16" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Legend Settings</h3>
                    <label style="display: block; margin-bottom: 12px; color: #888;">
                        <input type="checkbox" checked> Show legend
                    </label>
                    <div style="margin-top: 16px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Legend Position:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Top Right (default)</option>
                            <option>Top Left</option>
                            <option>Bottom Right</option>
                            <option>Bottom Left</option>
                            <option>Outside Right</option>
                            <option>Outside Top</option>
                        </select>
                    </div>
                    <div style="margin-top: 16px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Legend Title:</label>
                        <input type="text" value="Groups" placeholder="e.g., Habitat Type, Treatment" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #d4a017; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #d4a017; font-weight: 600; margin: 0 0 8px 0;">⚠️ AVOID: Label Overload</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        Showing all sample labels on plots with &gt;30 samples creates unreadable overlap. Use interactive tooltips or label only outliers/key samples.
                    </p>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ✓ Apply Settings
                </button>
            `
        },
        
        'combine-plots': {
            title: '🧩 Combine Plots (patchwork)',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🧩 Combine Multiple Plots with patchwork</h2>
                <p style="color: #888; margin-bottom: 30px;">Create multi-panel figures for publication using the patchwork R package</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Why Use patchwork?</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Flexible layouts:</strong> Combine ordination + diversity plots in one figure<br>
                        • <strong>Shared legends:</strong> Automatically merge legends across panels<br>
                        • <strong>Automatic labeling:</strong> Add (A), (B), (C) panel labels for publications<br>
                        • <strong>Simple syntax:</strong> Use +, /, | operators to arrange plots
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: patchwork Syntax</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Basic operators:</strong><br>
                        • <strong>p1 + p2:</strong> Place plots side-by-side horizontally<br>
                        • <strong>p1 / p2:</strong> Stack plots vertically<br>
                        • <strong>p1 | p2:</strong> Alternative horizontal placement<br>
                        • <strong>(p1 + p2) / p3:</strong> Complex layouts with grouping<br>
                        • <strong>p1 + p2 + plot_layout(ncol = 1):</strong> Force single column<br>
                        • <strong>Citation:</strong> Pedersen, T. L. (2020). patchwork: The Composer of Plots. R package.
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 1: Select Plots to Combine</h3>
                    
                    <label style="display: flex; align-items: center; margin-bottom: 12px; cursor: pointer;">
                        <input type="checkbox" checked style="margin-right: 10px;">
                        <span style="color: #cccccc; font-size: 13px;">🗺️ NMDS Ordination (Plot A)</span>
                    </label>
                    <label style="display: flex; align-items: center; margin-bottom: 12px; cursor: pointer;">
                        <input type="checkbox" checked style="margin-right: 10px;">
                        <span style="color: #cccccc; font-size: 13px;">📊 Rarefaction Curve (Plot B)</span>
                    </label>
                    <label style="display: flex; align-items: center; margin-bottom: 12px; cursor: pointer;">
                        <input type="checkbox" checked style="margin-right: 10px;">
                        <span style="color: #cccccc; font-size: 13px;">📈 Beta Diversity Barplot (Plot C)</span>
                    </label>
                    <label style="display: flex; align-items: center; cursor: pointer;">
                        <input type="checkbox" style="margin-right: 10px;">
                        <span style="color: #cccccc; font-size: 13px;">🌳 Dendrogram (Plot D)</span>
                    </label>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 2: Choose Layout</h3>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">LAYOUT TYPE</label>
                    <select style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 20px;">
                        <option selected>2 columns (side-by-side)</option>
                        <option>1 column (stacked vertically)</option>
                        <option>2 rows (stacked horizontally)</option>
                        <option>Grid (automatic wrap)</option>
                        <option>Custom layout (manual arrangement)</option>
                    </select>
                    
                    <div style="background: #1e1e1e; padding: 15px; border-radius: 4px; margin-bottom: 15px;">
                        <p style="color: #888; font-size: 11px; margin-bottom: 10px;">PREVIEW LAYOUT</p>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                            <div style="background: #2e8b57; padding: 20px; border-radius: 4px; text-align: center; color: white; font-size: 11px;">
                                A<br>NMDS
                            </div>
                            <div style="background: #2e8b57; padding: 20px; border-radius: 4px; text-align: center; color: white; font-size: 11px;">
                                B<br>Rarefaction
                            </div>
                        </div>
                        <div style="display: grid; grid-template-columns: 1fr; gap: 10px; margin-top: 10px;">
                            <div style="background: #2e8b57; padding: 20px; border-radius: 4px; text-align: center; color: white; font-size: 11px;">
                                C<br>Beta Diversity
                            </div>
                        </div>
                    </div>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">WIDTH RATIOS (if applicable)</label>
                    <input type="text" placeholder="e.g., 2:1 or 1:1" value="1:1" style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 15px;">
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">HEIGHT RATIOS (if applicable)</label>
                    <input type="text" placeholder="e.g., 2:1:1" value="2:1" style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px;">
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Common Layout Patterns</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Publication-ready layouts:</strong><br>
                        • <strong>2-panel horizontal:</strong> Compare ordinations (e.g., NMDS vs PCA)<br>
                        • <strong>2-panel vertical:</strong> Ordination + dendrogram or barplot<br>
                        • <strong>3-panel L-shape:</strong> Large plot + 2 smaller supplementary plots<br>
                        • <strong>4-panel grid:</strong> Multiple treatments/sites comparison<br>
                        • <strong>Inset plots:</strong> Use plot_annotation() to place small plot inside larger
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 3: Panel Labels & Annotations</h3>
                    
                    <label style="display: flex; align-items: center; margin-bottom: 12px; cursor: pointer;">
                        <input type="checkbox" checked style="margin-right: 10px;">
                        <span style="color: #cccccc; font-size: 13px;">Add automatic panel labels (A, B, C, ...)</span>
                    </label>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">LABEL STYLE</label>
                    <select style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 20px;">
                        <option selected>A, B, C (uppercase)</option>
                        <option>a, b, c (lowercase)</option>
                        <option>(A), (B), (C) (parentheses)</option>
                        <option>1, 2, 3 (numbers)</option>
                    </select>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">LABEL POSITION</label>
                    <select style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 20px;">
                        <option selected>Top-left</option>
                        <option>Top-right</option>
                        <option>Bottom-left</option>
                        <option>Bottom-right</option>
                    </select>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">OVERALL TITLE (optional)</label>
                    <input type="text" placeholder="e.g., Community composition across forest types" style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px;">
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 4: Legend Settings</h3>
                    
                    <label style="display: flex; align-items: center; margin-bottom: 12px; cursor: pointer;">
                        <input type="checkbox" checked style="margin-right: 10px;">
                        <span style="color: #cccccc; font-size: 13px;">Collect legends into single shared legend</span>
                    </label>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">SHARED LEGEND POSITION</label>
                    <select style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 20px;">
                        <option selected>Right side</option>
                        <option>Bottom</option>
                        <option>Top</option>
                        <option>Left side</option>
                    </select>
                    
                    <label style="display: flex; align-items: center; cursor: pointer;">
                        <input type="checkbox" style="margin-right: 10px;">
                        <span style="color: #cccccc; font-size: 13px;">Keep individual legends for each plot</span>
                    </label>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Example patchwork Code</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>R code that Ördin will generate:</strong><br>
                        <code style="background: #1e1e1e; padding: 2px 6px; border-radius: 2px; font-family: monospace; font-size: 11px; display: block; margin-top: 8px; white-space: pre; overflow-x: auto;">library(patchwork)

# Basic 2-panel layout
p1 + p2

# Vertical stack with labels
(p1 / p2) + plot_annotation(tag_levels = 'A')

# Complex layout with custom heights
(p1 + p2) / p3 + plot_layout(heights = c(2, 1))

# Shared legend on right
(p1 + p2) + plot_layout(guides = 'collect')</code>
                    </p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 5: Export Settings</h3>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">COMBINED PLOT WIDTH</label>
                    <input type="number" value="12" min="4" max="20" step="0.5" style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 15px;">
                    <p style="color: #666; font-size: 11px; margin: -10px 0 15px 0;">Inches (for publication)</p>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">COMBINED PLOT HEIGHT</label>
                    <input type="number" value="8" min="4" max="20" step="0.5" style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 15px;">
                    <p style="color: #666; font-size: 11px; margin: -10px 0 15px 0;">Inches (for publication)</p>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">RESOLUTION</label>
                    <select style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px;">
                        <option>150 DPI (screen)</option>
                        <option selected>300 DPI (print standard)</option>
                        <option>600 DPI (high quality)</option>
                    </select>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #d4a017; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #d4a017; font-weight: 600; margin: 0 0 8px 0;">⚠️ CAUTION: Plot Proportions</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        When combining plots with different aspect ratios (e.g., square ordination + rectangular barplot), consider using <code style="background: #1e1e1e; padding: 2px 4px; border-radius: 2px;">plot_layout(widths = ...)</code> to balance visual weight. Test at final export dimensions to ensure text is readable.
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Advanced patchwork Features</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Professional techniques:</strong><br>
                        • <strong>Inset plots:</strong> Use <code style="background: #1e1e1e; padding: 2px 4px; border-radius: 2px;">inset_element()</code> to place small plot inside larger<br>
                        • <strong>Spacers:</strong> Add <code style="background: #1e1e1e; padding: 2px 4px; border-radius: 2px;">plot_spacer()</code> for empty panels in grid<br>
                        • <strong>Alignment:</strong> Use <code style="background: #1e1e1e; padding: 2px 4px; border-radius: 2px;">align_plots()</code> to align axes across rows/columns<br>
                        • <strong>Themes:</strong> Apply consistent theme to all panels with <code style="background: #1e1e1e; padding: 2px 4px; border-radius: 2px;">& theme_bw()</code><br>
                        • <strong>Nesting:</strong> Combine patchwork objects for complex multi-level layouts
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px;">
                    <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: 600; width: 100%; margin-bottom: 10px;">▶ Preview Combined Plot</button>
                    <button style="background: #444; color: #ccc; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%; margin-bottom: 10px;">💾 Save patchwork Layout Template</button>
                    <button style="background: #444; color: #ccc; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%;">📝 Export R Code</button>
                </div>
            `
        },
        // DATA WORKFLOWS
        'import-csv': {
            title: '💻 Import CSV File',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">💻 Import Local CSV File</h2>
                <p style="color: #888; margin-bottom: 30px;">Load community ecology data from CSV format</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 1: Select File</h3>
                    <button style="background: #2a2a2a; border: 1px solid #3e3e42; color: #cccccc; padding: 12px 24px; cursor: pointer;">
                        📁 Browse Files...
                    </button>
                    <p style="color: #888; margin-top: 12px; font-size: 12px;">Accepted formats: .csv, .txt (comma or tab delimited)</p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 2: Configure Import Options</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Delimiter:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Comma (,)</option>
                            <option>Tab</option>
                            <option>Semicolon (;)</option>
                        </select>
                    </div>
                    <label style="display: block; color: #888;">
                        <input type="checkbox" checked> First row contains headers
                    </label>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Import Data
                </button>
            `
        },
        'import-excel': {
            title: '💻 Import Excel File',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">💻 Import Excel Spreadsheet</h2>
                <p style="color: #888; margin-bottom: 30px;">Load data from .xlsx or .xls files</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 1: Select File</h3>
                    <button style="background: #2a2a2a; border: 1px solid #3e3e42; color: #cccccc; padding: 12px 24px; cursor: pointer;">
                        📁 Browse Files...
                    </button>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 2: Select Sheet</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Worksheet:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Sheet1</option>
                            <option>Sheet2</option>
                        </select>
                    </div>
                    <label style="display: block; color: #888;">
                        <input type="checkbox" checked> First row contains headers
                    </label>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Import Data
                </button>
            `
        },
        'import-gdrive': {
            title: '☁️ Import from Google Drive',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">☁️ Import from Google Drive</h2>
                <p style="color: #888; margin-bottom: 30px;">Connect to Google Drive and load datasets</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 1: Authenticate</h3>
                    <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                        🔐 Sign in with Google
                    </button>
                    <p style="color: #888; margin-top: 12px; font-size: 12px;">Secure OAuth authentication</p>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 2: Select File</h3>
                    <p style="color: #888; font-size: 13px;">After authentication, browse your Google Drive files</p>
                </div>
            `
        },
        'sample-datasets': {
            title: '📚 Sample Datasets',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📚 Load Sample Datasets</h2>
                <p style="color: #888; margin-bottom: 30px;">Try ördin with built-in example datasets</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Available Datasets</h3>
                    <div style="margin-bottom: 16px; padding: 12px; background: #1e1e1e; border: 1px solid #3e3e42; cursor: pointer;">
                        <h4 style="color: #2e8b57; margin: 0 0 8px 0;">🌳 Spider Data</h4>
                        <p style="color: #888; font-size: 12px; margin: 0;">Abundance data from vegan package (28 samples × 12 species)</p>
                    </div>
                    <div style="margin-bottom: 16px; padding: 12px; background: #1e1e1e; border: 1px solid #3e3e42; cursor: pointer;">
                        <h4 style="color: #2e8b57; margin: 0 0 8px 0;">🦋 Butterfly Data</h4>
                        <p style="color: #888; font-size: 12px; margin: 0;">Incidence data from iNEXT package (6 assemblages)</p>
                    </div>
                    <div style="padding: 12px; background: #1e1e1e; border: 1px solid #3e3e42; cursor: pointer;">
                        <h4 style="color: #2e8b57; margin: 0 0 8px 0;">🌿 Dune Meadow</h4>
                        <p style="color: #888; font-size: 12px; margin: 0;">Classic ecological dataset with environmental variables</p>
                    </div>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Load Selected Dataset
                </button>
            `
        },
        'check-format': {
            title: '✅ Check Data Format',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">✅ Validate Data Format</h2>
                <p style="color: #888; margin-bottom: 30px;">Ensure your data meets requirements for analysis</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Validation Results</h3>
                    <p style="color: #2e8b57;">✓ All checks passed</p>
                    <div style="margin-top: 16px; font-size: 13px; color: #888;">
                        <p>✓ No missing values</p>
                        <p>✓ All values are numeric</p>
                        <p>✓ No negative abundances</p>
                        <p>✓ Row and column names present</p>
                    </div>
                </div>
                
                <button style="background: #2a2a2a; border: 1px solid #3e3e42; color: #cccccc; padding: 12px 24px; cursor: pointer;">
                    🔄 Re-check
                </button>
            `
        },
        'preview-data': {
            title: '🔍 Preview Data',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🔍 Data Preview</h2>
                <p style="color: #888; margin-bottom: 30px;">View the first few rows of your dataset</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">species_data.csv (45 × 12)</h3>
                    <div style="background: #1e1e1e; padding: 16px; overflow-x: auto;">
                        <table style="color: #888; font-size: 12px; font-family: monospace; border-collapse: collapse; width: 100%;">
                            <tr style="border-bottom: 1px solid #3e3e42;">
                                <th style="text-align: left; padding: 4px;">Sample</th>
                                <th style="text-align: right; padding: 4px;">Sp1</th>
                                <th style="text-align: right; padding: 4px;">Sp2</th>
                                <th style="text-align: right; padding: 4px;">Sp3</th>
                                <th style="text-align: right; padding: 4px;">...</th>
                            </tr>
                            <tr>
                                <td style="padding: 4px;">Site_01</td>
                                <td style="text-align: right; padding: 4px;">23</td>
                                <td style="text-align: right; padding: 4px;">45</td>
                                <td style="text-align: right; padding: 4px;">12</td>
                                <td style="text-align: right; padding: 4px;">...</td>
                            </tr>
                            <tr>
                                <td style="padding: 4px;">Site_02</td>
                                <td style="text-align: right; padding: 4px;">18</td>
                                <td style="text-align: right; padding: 4px;">39</td>
                                <td style="text-align: right; padding: 4px;">8</td>
                                <td style="text-align: right; padding: 4px;">...</td>
                            </tr>
                        </table>
                    </div>
                </div>
            `
        },
        'data-summary': {
            title: '📊 Data Summary Statistics',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📊 Dataset Summary</h2>
                <p style="color: #888; margin-bottom: 30px;">Statistical overview of your data</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Basic Statistics</h3>
                    <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; font-size: 13px;">
                        <div>
                            <p style="color: #888; margin: 0;">Number of Samples:</p>
                            <p style="color: #cccccc; font-size: 24px; margin: 4px 0;">45</p>
                        </div>
                        <div>
                            <p style="color: #888; margin: 0;">Number of Species:</p>
                            <p style="color: #cccccc; font-size: 24px; margin: 4px 0;">12</p>
                        </div>
                        <div>
                            <p style="color: #888; margin: 0;">Total Abundance:</p>
                            <p style="color: #cccccc; font-size: 24px; margin: 4px 0;">2,847</p>
                        </div>
                        <div>
                            <p style="color: #888; margin: 0;">Mean per Sample:</p>
                            <p style="color: #cccccc; font-size: 24px; margin: 4px 0;">63.3</p>
                        </div>
                    </div>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    📥 Export Summary
                </button>
            `
        },
        
        // SETTINGS WORKFLOWS - APPEARANCE
        'theme-dark': {
            title: '🌙 Dark Theme',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🌙 Dark Theme</h2>
                <p style="color: #888; margin-bottom: 30px;">Enable dark color scheme optimized for low-light environments</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: When to Use Dark Theme</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Extended work sessions:</strong> Reduces eye strain in low-light conditions<br>
                        • <strong>Night work:</strong> Minimizes blue light exposure before sleep<br>
                        • <strong>Focus mode:</strong> Dark UI reduces distractions, keeps attention on data visualizations<br>
                        • <strong>Battery saving:</strong> On OLED screens, dark pixels consume less power
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: VSCode Dark+ Color Scheme</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Color palette:</strong><br>
                        • Background: #1e1e1e (main editor)<br>
                        • Sidebar: #252526<br>
                        • Accents: #2e8b57 (sea green), #007acc (blue)<br>
                        • Contrast ratio: WCAG AAA compliant (7:1+)<br>
                        • Designed for prolonged coding sessions with minimal fatigue
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">Color Configuration</h3>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-top: 15px;">
                        <div style="background: #1e1e1e; padding: 12px; border-radius: 4px;">
                            <label style="color: #888; font-size: 11px; display: block; margin-bottom: 5px;">BACKGROUND</label>
                            <div style="color: #cccccc; font-size: 13px;">#1e1e1e</div>
                        </div>
                        <div style="background: #252526; padding: 12px; border-radius: 4px;">
                            <label style="color: #888; font-size: 11px; display: block; margin-bottom: 5px;">SIDEBAR</label>
                            <div style="color: #cccccc; font-size: 13px;">#252526</div>
                        </div>
                        <div style="background: #2d2d30; padding: 12px; border-radius: 4px;">
                            <label style="color: #888; font-size: 11px; display: block; margin-bottom: 5px;">PANELS</label>
                            <div style="color: #cccccc; font-size: 13px;">#2d2d30</div>
                        </div>
                        <div style="background: #2e8b57; padding: 12px; border-radius: 4px;">
                            <label style="color: #fff; font-size: 11px; display: block; margin-bottom: 5px;">ACCENT</label>
                            <div style="color: #fff; font-size: 13px;">#2e8b57</div>
                        </div>
                    </div>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px;">
                    <button style="background: #2e8b57; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%;">✓ Apply Dark Theme</button>
                </div>
            `
        },
        
        'theme-light': {
            title: '☀️ Light Theme',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">☀️ Light Theme</h2>
                <p style="color: #888; margin-bottom: 30px;">Enable light color scheme optimized for bright environments</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: When to Use Light Theme</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Bright environments:</strong> Better contrast in well-lit offices or outdoor settings<br>
                        • <strong>Presentations:</strong> Projector displays typically show light themes better<br>
                        • <strong>Document preparation:</strong> Matches typical paper/publication backgrounds<br>
                        • <strong>Accessibility:</strong> Some users find light backgrounds easier to read
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Light Theme Design Principles</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Color palette recommendations:</strong><br>
                        • Background: #ffffff or #f5f5f5 (pure white or off-white)<br>
                        • Text: #333333 (dark gray, not pure black - reduces strain)<br>
                        • Accents: #2e8b57 (maintains brand consistency)<br>
                        • Borders: #e0e0e0 (subtle separation)<br>
                        • Contrast ratio: WCAG AA minimum (4.5:1 for normal text)
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">Light Mode Preview</h3>
                    <div style="background: #ffffff; padding: 20px; border-radius: 4px; border: 1px solid #e0e0e0;">
                        <div style="color: #333333; font-size: 13px; margin-bottom: 10px;">Sample text in light theme</div>
                        <div style="color: #2e8b57; font-weight: 600;">Accent color: Sea Green</div>
                    </div>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px;">
                    <button style="background: #2e8b57; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%;">✓ Apply Light Theme</button>
                </div>
            `
        },
        
        'theme-custom': {
            title: '🎨 Custom Colors',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🎨 Custom Color Theme</h2>
                <p style="color: #888; margin-bottom: 30px;">Create your own color scheme matching institutional branding or personal preferences</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Custom Theme Use Cases</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Institutional branding:</strong> Match your university/organization colors<br>
                        • <strong>Accessibility needs:</strong> High-contrast themes for visual impairments<br>
                        • <strong>Personal preference:</strong> Create comfortable working environment<br>
                        • <strong>Publication consistency:</strong> Match figures to journal color schemes
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Color Accessibility Guidelines</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>WCAG Contrast Requirements:</strong><br>
                        • <strong>AA (minimum):</strong> 4.5:1 for normal text, 3:1 for large text<br>
                        • <strong>AAA (enhanced):</strong> 7:1 for normal text, 4.5:1 for large text<br>
                        • <strong>Colorblind considerations:</strong> Avoid red-green only distinctions<br>
                        • <strong>Test tool:</strong> WebAIM Contrast Checker
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #d4a017; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #d4a017; font-weight: 600; margin: 0 0 8px 0;">⚠️ CAUTION: Contrast Requirements</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        Always verify sufficient contrast between text and backgrounds. Poor contrast causes eye strain and reduces readability, especially during long analysis sessions.
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">Color Picker</h3>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-top: 15px;">
                        <div>
                            <label style="color: #888; font-size: 11px; display: block; margin-bottom: 5px;">PRIMARY BACKGROUND</label>
                            <input type="color" value="#1e1e1e" style="width: 100%; height: 40px; border: 1px solid #444; background: transparent;">
                        </div>
                        <div>
                            <label style="color: #888; font-size: 11px; display: block; margin-bottom: 5px;">ACCENT COLOR</label>
                            <input type="color" value="#2e8b57" style="width: 100%; height: 40px; border: 1px solid #444; background: transparent;">
                        </div>
                        <div>
                            <label style="color: #888; font-size: 11px; display: block; margin-bottom: 5px;">TEXT COLOR</label>
                            <input type="color" value="#cccccc" style="width: 100%; height: 40px; border: 1px solid #444; background: transparent;">
                        </div>
                        <div>
                            <label style="color: #888; font-size: 11px; display: block; margin-bottom: 5px;">SIDEBAR COLOR</label>
                            <input type="color" value="#252526" style="width: 100%; height: 40px; border: 1px solid #444; background: transparent;">
                        </div>
                    </div>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px;">
                    <button style="background: #2e8b57; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%; margin-bottom: 10px;">✓ Save Custom Theme</button>
                    <button style="background: #444; color: #ccc; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%;">↻ Reset to Default</button>
                </div>
            `
        },
        
        'font-size': {
            title: '🔤 Font Size',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🔤 Font Size Configuration</h2>
                <p style="color: #888; margin-bottom: 30px;">Adjust text size for optimal readability</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Choosing Font Size</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Small (11px):</strong> Maximize screen real estate, good for large monitors<br>
                        • <strong>Medium (13px):</strong> Default, balanced readability and space<br>
                        • <strong>Large (15px):</strong> Improved readability, reduces eye strain<br>
                        • <strong>Extra Large (17px):</strong> Accessibility, presentations, visual impairments
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Typography Best Practices</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Readability factors:</strong><br>
                        • <strong>Line height:</strong> 1.5-1.6x font size for optimal reading<br>
                        • <strong>Line length:</strong> 50-75 characters per line (optimal 66)<br>
                        • <strong>Font family:</strong> Monospace for code, sans-serif for UI<br>
                        • <strong>Zoom:</strong> Combine with Ctrl+/- for temporary adjustments
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">Size Preview</h3>
                    <div style="margin-bottom: 15px; padding: 10px; background: #1e1e1e; border-radius: 4px;">
                        <div style="color: #888; font-size: 10px; margin-bottom: 5px;">SMALL (11px)</div>
                        <div style="color: #cccccc; font-size: 11px;">The quick brown fox jumps over the lazy dog</div>
                    </div>
                    <div style="margin-bottom: 15px; padding: 10px; background: #1e1e1e; border-radius: 4px;">
                        <div style="color: #888; font-size: 10px; margin-bottom: 5px;">MEDIUM (13px) - DEFAULT</div>
                        <div style="color: #cccccc; font-size: 13px;">The quick brown fox jumps over the lazy dog</div>
                    </div>
                    <div style="margin-bottom: 15px; padding: 10px; background: #1e1e1e; border-radius: 4px;">
                        <div style="color: #888; font-size: 10px; margin-bottom: 5px;">LARGE (15px)</div>
                        <div style="color: #cccccc; font-size: 15px;">The quick brown fox jumps over the lazy dog</div>
                    </div>
                    <div style="padding: 10px; background: #1e1e1e; border-radius: 4px;">
                        <div style="color: #888; font-size: 10px; margin-bottom: 5px;">EXTRA LARGE (17px)</div>
                        <div style="color: #cccccc; font-size: 17px;">The quick brown fox jumps over the lazy dog</div>
                    </div>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px;">
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">FONT SIZE</label>
                    <select style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 15px;">
                        <option>Small (11px)</option>
                        <option selected>Medium (13px)</option>
                        <option>Large (15px)</option>
                        <option>Extra Large (17px)</option>
                    </select>
                    <button style="background: #2e8b57; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%;">✓ Apply Font Size</button>
                </div>
            `
        },
        
        // SETTINGS WORKFLOWS - GENERAL
        'toggle-autosave': {
            title: '💾 Auto-Save',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">💾 Auto-Save Configuration</h2>
                <p style="color: #888; margin-bottom: 30px;">Automatically save your work at regular intervals</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Auto-Save Benefits</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Prevents data loss:</strong> Protects against crashes, power failures, or accidental closures<br>
                        • <strong>Hands-free:</strong> No need to remember to save manually<br>
                        • <strong>Version history:</strong> Creates timestamped snapshots for recovery<br>
                        • <strong>Recommended interval:</strong> 5 minutes for most workflows
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Auto-Save Best Practices</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Save strategies:</strong><br>
                        • <strong>Session state:</strong> Save entire workspace (data, transformations, plots)<br>
                        • <strong>Incremental saves:</strong> Only save changes since last save (faster)<br>
                        • <strong>Save location:</strong> Default to Documents/Ördin/AutoSaves/<br>
                        • <strong>Retention:</strong> Keep last 10 auto-saves, delete older files automatically
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #d4a017; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #d4a017; font-weight: 600; margin: 0 0 8px 0;">⚠️ CAUTION: Large Datasets</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        For very large datasets (>100MB), consider increasing auto-save interval to 10-15 minutes to avoid performance impacts during analysis. Auto-save temporarily freezes UI while writing to disk.
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">Auto-Save Settings</h3>
                    
                    <label style="display: flex; align-items: center; margin-bottom: 20px; cursor: pointer;">
                        <input type="checkbox" checked style="margin-right: 10px;">
                        <span style="color: #cccccc; font-size: 13px;">Enable Auto-Save</span>
                    </label>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">AUTO-SAVE INTERVAL</label>
                    <select style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 20px;">
                        <option>Every 2 minutes</option>
                        <option selected>Every 5 minutes</option>
                        <option>Every 10 minutes</option>
                        <option>Every 15 minutes</option>
                        <option>Every 30 minutes</option>
                    </select>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">SAVE LOCATION</label>
                    <div style="display: flex; gap: 10px; margin-bottom: 20px;">
                        <input type="text" value="Documents/Ördin/AutoSaves" style="flex: 1; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px;">
                        <button style="background: #444; color: #ccc; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer;">📂 Browse</button>
                    </div>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">RETENTION POLICY</label>
                    <select style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px;">
                        <option>Keep last 5 auto-saves</option>
                        <option selected>Keep last 10 auto-saves</option>
                        <option>Keep last 20 auto-saves</option>
                        <option>Keep all auto-saves</option>
                    </select>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px;">
                    <button style="background: #2e8b57; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%;">✓ Save Auto-Save Settings</button>
                </div>
            `
        },
        
        'notifications': {
            title: '🔔 Notifications',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🔔 Notification Preferences</h2>
                <p style="color: #888; margin-bottom: 30px;">Configure how Ördin alerts you about analysis completion and important events</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Notification Types</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Analysis complete:</strong> Long-running ordinations, permutation tests finished<br>
                        • <strong>Errors/warnings:</strong> Data format issues, convergence failures<br>
                        • <strong>Auto-save:</strong> Confirmation when workspace is saved<br>
                        • <strong>Updates:</strong> New version of Ördin available
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Desktop Notifications</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Notification system:</strong><br>
                        • <strong>OS-level notifications:</strong> Uses Windows/macOS native notification system<br>
                        • <strong>In-app toasts:</strong> Non-intrusive messages within Ördin window<br>
                        • <strong>Sound alerts:</strong> Optional audio cues for important events<br>
                        • <strong>Focus mode:</strong> Suppress all notifications during presentations
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">Notification Settings</h3>
                    
                    <div style="margin-bottom: 20px;">
                        <p style="color: #888; font-size: 11px; margin-bottom: 12px;">ANALYSIS NOTIFICATIONS</p>
                        <label style="display: flex; align-items: center; margin-bottom: 10px; cursor: pointer;">
                            <input type="checkbox" checked style="margin-right: 10px;">
                            <span style="color: #cccccc; font-size: 13px;">Notify when analysis completes</span>
                        </label>
                        <label style="display: flex; align-items: center; margin-bottom: 10px; cursor: pointer;">
                            <input type="checkbox" checked style="margin-right: 10px;">
                            <span style="color: #cccccc; font-size: 13px;">Show errors and warnings</span>
                        </label>
                        <label style="display: flex; align-items: center; cursor: pointer;">
                            <input type="checkbox" style="margin-right: 10px;">
                            <span style="color: #cccccc; font-size: 13px;">Play sound for important alerts</span>
                        </label>
                    </div>
                    
                    <div style="margin-bottom: 20px;">
                        <p style="color: #888; font-size: 11px; margin-bottom: 12px;">SYSTEM NOTIFICATIONS</p>
                        <label style="display: flex; align-items: center; margin-bottom: 10px; cursor: pointer;">
                            <input type="checkbox" checked style="margin-right: 10px;">
                            <span style="color: #cccccc; font-size: 13px;">Auto-save confirmations</span>
                        </label>
                        <label style="display: flex; align-items: center; margin-bottom: 10px; cursor: pointer;">
                            <input type="checkbox" checked style="margin-right: 10px;">
                            <span style="color: #cccccc; font-size: 13px;">Update availability</span>
                        </label>
                        <label style="display: flex; align-items: center; cursor: pointer;">
                            <input type="checkbox" style="margin-right: 10px;">
                            <span style="color: #cccccc; font-size: 13px;">Tips and suggestions</span>
                        </label>
                    </div>
                    
                    <div>
                        <p style="color: #888; font-size: 11px; margin-bottom: 12px;">DELIVERY METHOD</p>
                        <label style="display: flex; align-items: center; margin-bottom: 10px; cursor: pointer;">
                            <input type="radio" name="notifmethod" checked style="margin-right: 10px;">
                            <span style="color: #cccccc; font-size: 13px;">Desktop notifications (OS-level)</span>
                        </label>
                        <label style="display: flex; align-items: center; margin-bottom: 10px; cursor: pointer;">
                            <input type="radio" name="notifmethod" style="margin-right: 10px;">
                            <span style="color: #cccccc; font-size: 13px;">In-app toasts only</span>
                        </label>
                        <label style="display: flex; align-items: center; cursor: pointer;">
                            <input type="radio" name="notifmethod" style="margin-right: 10px;">
                            <span style="color: #cccccc; font-size: 13px;">Silent mode (no notifications)</span>
                        </label>
                    </div>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px;">
                    <button style="background: #2e8b57; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%; margin-bottom: 10px;">✓ Save Notification Settings</button>
                    <button style="background: #444; color: #ccc; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%;">🔔 Test Notification</button>
                </div>
            `
        },
        
        'language': {
            title: '🌐 Language',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🌐 Language Preferences</h2>
                <p style="color: #888; margin-bottom: 30px;">Set your preferred language for the Ördin interface</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Multilingual Support</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>UI translation:</strong> Menus, buttons, and labels translated<br>
                        • <strong>Scientific terms:</strong> Preserved in English by default (standardized)<br>
                        • <strong>Plot labels:</strong> Can use localized or English terms<br>
                        • <strong>Documentation:</strong> Help system translated for major languages
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Publication Considerations</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Language best practices:</strong><br>
                        • <strong>Working language:</strong> Use your preferred language for daily analysis<br>
                        • <strong>Publication plots:</strong> Switch to English for international journals<br>
                        • <strong>Statistical terms:</strong> Keep standardized (e.g., "NMDS" not "NMEM")<br>
                        • <strong>Export:</strong> Easy to regenerate plots in different languages
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">Select Language</h3>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">INTERFACE LANGUAGE</label>
                    <select style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 20px;">
                        <option selected>🇬🇧 English</option>
                        <option>🇪🇸 Español (Spanish)</option>
                        <option>🇫🇷 Français (French)</option>
                        <option>🇩🇪 Deutsch (German)</option>
                        <option>🇯🇵 日本語 (Japanese)</option>
                        <option>🇨🇳 中文 (Chinese)</option>
                        <option>🇵🇹 Português (Portuguese)</option>
                    </select>
                    
                    <label style="display: flex; align-items: center; margin-bottom: 15px; cursor: pointer;">
                        <input type="checkbox" checked style="margin-right: 10px;">
                        <span style="color: #cccccc; font-size: 13px;">Keep scientific terms in English</span>
                    </label>
                    
                    <label style="display: flex; align-items: center; cursor: pointer;">
                        <input type="checkbox" style="margin-right: 10px;">
                        <span style="color: #cccccc; font-size: 13px;">Translate plot labels and legends</span>
                    </label>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px;">
                    <button style="background: #2e8b57; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%;">✓ Apply Language Settings</button>
                    <p style="color: #888; font-size: 11px; margin: 10px 0 0 0; text-align: center;">Application will restart to apply changes</p>
                </div>
            `
        },
        
        'default-params': {
            title: '⚙️ Default Parameters',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">⚙️ Default Analysis Parameters</h2>
                <p style="color: #888; margin-bottom: 30px;">Set default values for common analysis parameters</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Why Set Defaults?</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Consistency:</strong> Apply same parameters across multiple analyses<br>
                        • <strong>Time-saving:</strong> No need to re-enter common values each time<br>
                        • <strong>Lab standards:</strong> Match your research group's conventions<br>
                        • <strong>Override anytime:</strong> Defaults can be changed for individual analyses
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Recommended Defaults</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Ecological best practices:</strong><br>
                        • <strong>Permutations:</strong> 999 or 9999 for publication-quality p-values<br>
                        • <strong>Distance metric:</strong> Bray-Curtis for abundance, Jaccard for presence/absence<br>
                        • <strong>Transformation:</strong> Hellinger for ordination, log for diversity<br>
                        • <strong>Confidence level:</strong> 95% (alpha = 0.05) is standard
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">Statistical Defaults</h3>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">NUMBER OF PERMUTATIONS</label>
                    <select style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 20px;">
                        <option>99 (quick testing)</option>
                        <option selected>999 (standard)</option>
                        <option>9999 (publication)</option>
                        <option>99999 (high precision)</option>
                    </select>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">CONFIDENCE LEVEL</label>
                    <select style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 20px;">
                        <option>90% (α = 0.10)</option>
                        <option selected>95% (α = 0.05)</option>
                        <option>99% (α = 0.01)</option>
                    </select>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">DEFAULT DISTANCE METRIC</label>
                    <select style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 20px;">
                        <option selected>Bray-Curtis</option>
                        <option>Jaccard</option>
                        <option>Euclidean</option>
                        <option>Hellinger</option>
                        <option>Morisita-Horn</option>
                    </select>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">DEFAULT TRANSFORMATION</label>
                    <select style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px;">
                        <option>None (raw data)</option>
                        <option selected>Hellinger</option>
                        <option>Log (log1p)</option>
                        <option>Square Root</option>
                        <option>Wisconsin</option>
                    </select>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">Plot Defaults</h3>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">DEFAULT COLOR PALETTE</label>
                    <select style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 20px;">
                        <option selected>Viridis</option>
                        <option>Plasma</option>
                        <option>Set1</option>
                        <option>Paired</option>
                    </select>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">PLOT RESOLUTION (DPI)</label>
                    <select style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px;">
                        <option>150 (screen)</option>
                        <option selected>300 (print)</option>
                        <option>600 (high quality)</option>
                    </select>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px;">
                    <button style="background: #2e8b57; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%; margin-bottom: 10px;">✓ Save Default Parameters</button>
                    <button style="background: #444; color: #ccc; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%;">↻ Reset to Factory Defaults</button>
                </div>
            `
        },
        
        // SETTINGS WORKFLOWS - ADVANCED
        'r-config': {
            title: '🔧 R Configuration',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🔧 R Environment Configuration</h2>
                <p style="color: #888; margin-bottom: 30px;">Configure R installation and environment settings</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: R Version Requirements</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Minimum version:</strong> R 4.0.0 or later required<br>
                        • <strong>Recommended:</strong> R 4.3.0+ for latest vegan/betapart features<br>
                        • <strong>Multiple versions:</strong> Ördin can detect and switch between R installations<br>
                        • <strong>Rtools:</strong> Required on Windows for some package compilation
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: R Integration Architecture</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>How Ördin uses R:</strong><br>
                        • <strong>Electron + Shiny:</strong> Desktop app wraps R Shiny server<br>
                        • <strong>Process management:</strong> R runs in background, communicates via HTTP<br>
                        • <strong>Package libraries:</strong> Separate user library for Ördin packages<br>
                        • <strong>Environment variables:</strong> R_HOME, R_LIBS_USER configured automatically
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #d4a017; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #d4a017; font-weight: 600; margin: 0 0 8px 0;">⚠️ CAUTION: Changing R Path</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        Changing R installation path requires restarting Ördin and may trigger package re-installation. Ensure new R version has all required packages before switching.
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">Current R Installation</h3>
                    
                    <div style="background: #1e1e1e; padding: 15px; border-radius: 4px; margin-bottom: 20px;">
                        <div style="display: grid; grid-template-columns: 140px 1fr; gap: 10px; font-size: 13px;">
                            <div style="color: #888;">R Version:</div>
                            <div style="color: #2e8b57; font-weight: 600;">4.3.2 (2023-10-31)</div>
                            
                            <div style="color: #888;">R Home:</div>
                            <div style="color: #cccccc;">C:/Program Files/R/R-4.3.2</div>
                            
                            <div style="color: #888;">Library Path:</div>
                            <div style="color: #cccccc;">C:/Users/Username/Documents/R/win-library/4.3</div>
                            
                            <div style="color: #888;">Status:</div>
                            <div style="color: #2e8b57;">✓ Connected</div>
                        </div>
                    </div>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">R EXECUTABLE PATH</label>
                    <div style="display: flex; gap: 10px; margin-bottom: 20px;">
                        <input type="text" value="C:/Program Files/R/R-4.3.2/bin/R.exe" style="flex: 1; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px;">
                        <button style="background: #444; color: #ccc; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer;">📂 Browse</button>
                    </div>
                    
                    <button style="background: #444; color: #ccc; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%; margin-bottom: 10px;">🔍 Auto-Detect R Installations</button>
                    <button style="background: #444; color: #ccc; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%;">✓ Test R Connection</button>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">Environment Variables</h3>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">R_LIBS_USER (Package Library)</label>
                    <div style="display: flex; gap: 10px; margin-bottom: 20px;">
                        <input type="text" value="~/Documents/R/Ördin-packages" style="flex: 1; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px;">
                        <button style="background: #444; color: #ccc; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer;">📂 Browse</button>
                    </div>
                    
                    <label style="display: flex; align-items: center; cursor: pointer;">
                        <input type="checkbox" checked style="margin-right: 10px;">
                        <span style="color: #cccccc; font-size: 13px;">Use isolated package library for Ördin</span>
                    </label>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px;">
                    <button style="background: #2e8b57; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%; margin-bottom: 10px;">✓ Save R Configuration</button>
                    <p style="color: #888; font-size: 11px; margin: 0; text-align: center;">Changes require application restart</p>
                </div>
            `
        },
        
        'package-manager': {
            title: '📦 Package Manager',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📦 R Package Manager</h2>
                <p style="color: #888; margin-bottom: 30px;">Install, update, and manage R packages required for Ördin</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Required vs Optional Packages</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Core packages (required):</strong> vegan, ggplot2, dplyr, iNEXT<br>
                        • <strong>Extended analysis:</strong> betapart, FD, ape (phylogenetics)<br>
                        • <strong>Visualization:</strong> cowplot, patchwork, viridis<br>
                        • <strong>Auto-install:</strong> Ördin installs missing packages on first use
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Package Repositories</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Installation sources:</strong><br>
                        • <strong>CRAN:</strong> Main R package repository (most packages)<br>
                        • <strong>Bioconductor:</strong> Specialized packages for biological data<br>
                        • <strong>GitHub:</strong> Development versions and custom packages<br>
                        • <strong>CRAN mirror:</strong> Choose geographically close mirror for faster downloads
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #d4a017; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #d4a017; font-weight: 600; margin: 0 0 8px 0;">⚠️ CAUTION: Package Updates</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        Updating packages may introduce breaking changes. Ördin maintains compatibility with specific package versions. Only update if experiencing bugs or need new features.
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">Installed Packages</h3>
                    
                    <div style="background: #1e1e1e; padding: 12px; border-radius: 4px; margin-bottom: 10px; display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <div style="color: #cccccc; font-weight: 600; margin-bottom: 4px;">vegan</div>
                            <div style="color: #888; font-size: 11px;">Version 2.6-4 • Core package</div>
                        </div>
                        <div style="display: flex; gap: 8px;">
                            <span style="color: #2e8b57; font-size: 11px;">✓ Up to date</span>
                        </div>
                    </div>
                    
                    <div style="background: #1e1e1e; padding: 12px; border-radius: 4px; margin-bottom: 10px; display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <div style="color: #cccccc; font-weight: 600; margin-bottom: 4px;">betapart</div>
                            <div style="color: #888; font-size: 11px;">Version 1.6 • Beta diversity partitioning</div>
                        </div>
                        <div style="display: flex; gap: 8px;">
                            <span style="color: #2e8b57; font-size: 11px;">✓ Up to date</span>
                        </div>
                    </div>
                    
                    <div style="background: #1e1e1e; padding: 12px; border-radius: 4px; margin-bottom: 10px; display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <div style="color: #cccccc; font-weight: 600; margin-bottom: 4px;">iNEXT</div>
                            <div style="color: #888; font-size: 11px;">Version 3.0.0 • Diversity estimation</div>
                        </div>
                        <div style="display: flex; gap: 8px;">
                            <span style="color: #d4a017; font-size: 11px;">⚠️ Update available (3.0.1)</span>
                            <button style="background: #2e8b57; color: white; border: none; padding: 4px 12px; border-radius: 4px; cursor: pointer; font-size: 11px;">Update</button>
                        </div>
                    </div>
                    
                    <div style="background: #1e1e1e; padding: 12px; border-radius: 4px; display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <div style="color: #cccccc; font-weight: 600; margin-bottom: 4px;">ggplot2</div>
                            <div style="color: #888; font-size: 11px;">Version 3.4.4 • Plotting system</div>
                        </div>
                        <div style="display: flex; gap: 8px;">
                            <span style="color: #2e8b57; font-size: 11px;">✓ Up to date</span>
                        </div>
                    </div>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">Install New Package</h3>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">PACKAGE NAME</label>
                    <div style="display: flex; gap: 10px; margin-bottom: 15px;">
                        <input type="text" placeholder="e.g., ape, FD, phyloseq" style="flex: 1; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px;">
                        <button style="background: #2e8b57; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer;">Install</button>
                    </div>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">REPOSITORY</label>
                    <select style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px;">
                        <option selected>CRAN (https://cloud.r-project.org)</option>
                        <option>Bioconductor</option>
                        <option>GitHub</option>
                    </select>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px;">
                    <button style="background: #2e8b57; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%; margin-bottom: 10px;">✓ Check for Updates (All Packages)</button>
                    <button style="background: #444; color: #ccc; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%; margin-bottom: 10px;">🔄 Reinstall Core Packages</button>
                    <button style="background: #444; color: #ccc; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%;">📋 View Installed Packages List</button>
                </div>
            `
        },
        
        'clear-cache': {
            title: '🗑️ Clear Cache',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🗑️ Clear Cache & Temporary Files</h2>
                <p style="color: #888; margin-bottom: 30px;">Free up disk space by removing cached data and temporary files</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: What Gets Cached?</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>Plot cache:</strong> Rendered plots for quick re-display<br>
                        • <strong>Analysis results:</strong> Cached ordination/PERMANOVA results<br>
                        • <strong>Temporary data:</strong> Intermediate transformations and calculations<br>
                        • <strong>Session backups:</strong> Auto-save temporary files
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Cache Performance Benefits</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Why caching improves speed:</strong><br>
                        • <strong>Ordination results:</strong> NMDS/PCA stored to avoid re-computation<br>
                        • <strong>Distance matrices:</strong> Expensive calculations cached<br>
                        • <strong>Plot rendering:</strong> High-res plots cached for export<br>
                        • <strong>Trade-off:</strong> Disk space vs computation time
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #d4a017; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #d4a017; font-weight: 600; margin: 0 0 8px 0;">⚠️ CAUTION: Clearing Cache</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        Clearing cache will require re-running all analyses. Save your workspace before clearing cache. Auto-save backups will be preserved unless explicitly deleted.
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">Cache Statistics</h3>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 20px;">
                        <div style="background: #1e1e1e; padding: 15px; border-radius: 4px;">
                            <div style="color: #888; font-size: 11px; margin-bottom: 5px;">PLOT CACHE</div>
                            <div style="color: #cccccc; font-size: 20px; font-weight: 600;">127 MB</div>
                            <div style="color: #888; font-size: 11px; margin-top: 5px;">43 cached plots</div>
                        </div>
                        <div style="background: #1e1e1e; padding: 15px; border-radius: 4px;">
                            <div style="color: #888; font-size: 11px; margin-bottom: 5px;">ANALYSIS CACHE</div>
                            <div style="color: #cccccc; font-size: 20px; font-weight: 600;">89 MB</div>
                            <div style="color: #888; font-size: 11px; margin-top: 5px;">12 cached analyses</div>
                        </div>
                        <div style="background: #1e1e1e; padding: 15px; border-radius: 4px;">
                            <div style="color: #888; font-size: 11px; margin-bottom: 5px;">TEMP FILES</div>
                            <div style="color: #cccccc; font-size: 20px; font-weight: 600;">34 MB</div>
                            <div style="color: #888; font-size: 11px; margin-top: 5px;">18 temporary files</div>
                        </div>
                        <div style="background: #1e1e1e; padding: 15px; border-radius: 4px;">
                            <div style="color: #888; font-size: 11px; margin-bottom: 5px;">TOTAL CACHE</div>
                            <div style="color: #2e8b57; font-size: 20px; font-weight: 600;">250 MB</div>
                            <div style="color: #888; font-size: 11px; margin-top: 5px;">Can be cleared</div>
                        </div>
                    </div>
                    
                    <div style="background: #1e1e1e; padding: 15px; border-radius: 4px;">
                        <div style="color: #888; font-size: 11px; margin-bottom: 5px;">CACHE LOCATION</div>
                        <div style="color: #cccccc; font-size: 12px;">C:/Users/Username/AppData/Local/Ördin/Cache</div>
                    </div>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">Clear Options</h3>
                    
                    <label style="display: flex; align-items: center; margin-bottom: 12px; cursor: pointer;">
                        <input type="checkbox" checked style="margin-right: 10px;">
                        <span style="color: #cccccc; font-size: 13px;">Plot cache (127 MB)</span>
                    </label>
                    <label style="display: flex; align-items: center; margin-bottom: 12px; cursor: pointer;">
                        <input type="checkbox" checked style="margin-right: 10px;">
                        <span style="color: #cccccc; font-size: 13px;">Analysis results cache (89 MB)</span>
                    </label>
                    <label style="display: flex; align-items: center; margin-bottom: 12px; cursor: pointer;">
                        <input type="checkbox" checked style="margin-right: 10px;">
                        <span style="color: #cccccc; font-size: 13px;">Temporary files (34 MB)</span>
                    </label>
                    <label style="display: flex; align-items: center; cursor: pointer;">
                        <input type="checkbox" style="margin-right: 10px;">
                        <span style="color: #cccccc; font-size: 13px;">Auto-save backups (preserve by default)</span>
                    </label>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px;">
                    <button style="background: #d4a017; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%; margin-bottom: 10px; font-weight: 600;">🗑️ Clear Selected Cache</button>
                    <button style="background: #444; color: #ccc; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%;">🔄 Refresh Cache Statistics</button>
                </div>
            `
        },
        
        'performance': {
            title: '⚡ Performance Settings',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">⚡ Performance & Memory Settings</h2>
                <p style="color: #888; margin-bottom: 30px;">Optimize Ördin for your system's capabilities</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ TIP: Performance Tuning</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        • <strong>CPU cores:</strong> Use more cores for parallel permutations (PERMANOVA, Mantel)<br>
                        • <strong>Memory allocation:</strong> Increase for large datasets (>10,000 samples)<br>
                        • <strong>GPU acceleration:</strong> Experimental support for distance matrix calculations<br>
                        • <strong>Trade-off:</strong> Higher performance = more system resources
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Parallel Computing in R</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>How parallelization works:</strong><br>
                        • <strong>Permutation tests:</strong> Each permutation runs independently on separate core<br>
                        • <strong>Bootstrap:</strong> Resampling iterations parallelized<br>
                        • <strong>Distance calculations:</strong> Pairwise distances computed in parallel<br>
                        • <strong>Overhead:</strong> Fewer than 4 cores may not show speedup due to threading overhead
                    </p>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #d4a017; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #d4a017; font-weight: 600; margin: 0 0 8px 0;">⚠️ CAUTION: System Resources</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        Allocating too many CPU cores or excessive memory can freeze other applications. Leave at least 1-2 cores and 2GB RAM free for your operating system.
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">System Information</h3>
                    
                    <div style="background: #1e1e1e; padding: 15px; border-radius: 4px; margin-bottom: 15px;">
                        <div style="display: grid; grid-template-columns: 140px 1fr; gap: 10px; font-size: 13px;">
                            <div style="color: #888;">CPU Cores:</div>
                            <div style="color: #cccccc;">8 cores (16 threads)</div>
                            
                            <div style="color: #888;">Total RAM:</div>
                            <div style="color: #cccccc;">16 GB</div>
                            
                            <div style="color: #888;">Available RAM:</div>
                            <div style="color: #2e8b57;">8.4 GB (53%)</div>
                            
                            <div style="color: #888;">GPU:</div>
                            <div style="color: #cccccc;">NVIDIA GeForce GTX 1660 Ti</div>
                        </div>
                    </div>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">CPU Settings</h3>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">PARALLEL PROCESSING CORES</label>
                    <input type="range" min="1" max="16" value="6" style="width: 100%; margin-bottom: 10px;">
                    <div style="display: flex; justify-content: space-between; color: #888; font-size: 11px; margin-bottom: 20px;">
                        <span>1 core</span>
                        <span style="color: #2e8b57; font-weight: 600;">6 cores (recommended)</span>
                        <span>16 cores (all)</span>
                    </div>
                    
                    <label style="display: flex; align-items: center; cursor: pointer;">
                        <input type="checkbox" checked style="margin-right: 10px;">
                        <span style="color: #cccccc; font-size: 13px;">Enable parallel computing for permutation tests</span>
                    </label>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">Memory Settings</h3>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 10px;">MAXIMUM R MEMORY (GB)</label>
                    <select style="width: 100%; padding: 8px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 20px;">
                        <option>2 GB (minimal)</option>
                        <option>4 GB (standard)</option>
                        <option selected>8 GB (recommended)</option>
                        <option>12 GB (large datasets)</option>
                        <option>16 GB (maximum)</option>
                    </select>
                    
                    <label style="display: flex; align-items: center; cursor: pointer;">
                        <input type="checkbox" checked style="margin-right: 10px;">
                        <span style="color: #cccccc; font-size: 13px;">Automatic garbage collection (free memory when idle)</span>
                    </label>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">Advanced Options</h3>
                    
                    <label style="display: flex; align-items: center; margin-bottom: 12px; cursor: pointer;">
                        <input type="checkbox" style="margin-right: 10px;">
                        <span style="color: #cccccc; font-size: 13px;">Enable GPU acceleration (experimental)</span>
                    </label>
                    <label style="display: flex; align-items: center; margin-bottom: 12px; cursor: pointer;">
                        <input type="checkbox" checked style="margin-right: 10px;">
                        <span style="color: #cccccc; font-size: 13px;">Preload common packages on startup</span>
                    </label>
                    <label style="display: flex; align-items: center; cursor: pointer;">
                        <input type="checkbox" style="margin-right: 10px;">
                        <span style="color: #cccccc; font-size: 13px;">Low power mode (reduce CPU usage when on battery)</span>
                    </label>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px;">
                    <button style="background: #2e8b57; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%; margin-bottom: 10px;">✓ Save Performance Settings</button>
                    <button style="background: #444; color: #ccc; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%;">↻ Reset to Auto-Detect</button>
                </div>
            `
        },
        
        // HELP WORKFLOWS - DOCUMENTATION
        'user-guide': {
            title: '📖 User Guide',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📖 Ördin v3.0 User Guide</h2>
                <p style="color: #888; margin-bottom: 30px;">Complete guide to community ecology analysis with Ördin</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ GETTING STARTED</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        Welcome to Ördin! This guide will help you get started with community ecology analysis.<br>
                        <strong>First time users:</strong> Start with the Tutorials section for hands-on examples.
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">Table of Contents</h3>
                    
                    <div style="margin-bottom: 15px;">
                        <h4 style="color: #cccccc; margin: 0 0 8px 0; font-size: 14px;">1. Introduction</h4>
                        <p style="color: #888; font-size: 12px; margin: 0; line-height: 1.5;">
                            • What is Ördin?<br>
                            • Who should use Ördin?<br>
                            • Key features overview<br>
                            • System requirements
                        </p>
                    </div>
                    
                    <div style="margin-bottom: 15px;">
                        <h4 style="color: #cccccc; margin: 0 0 8px 0; font-size: 14px;">2. Data Management</h4>
                        <p style="color: #888; font-size: 12px; margin: 0; line-height: 1.5;">
                            • Importing data (CSV, Excel, Google Drive)<br>
                            • Data format requirements<br>
                            • Data validation and quality checks<br>
                            • Data transformation workflows
                        </p>
                    </div>
                    
                    <div style="margin-bottom: 15px;">
                        <h4 style="color: #cccccc; margin: 0 0 8px 0; font-size: 14px;">3. Diversity Analysis</h4>
                        <p style="color: #888; font-size: 12px; margin: 0; line-height: 1.5;">
                            • iNEXT rarefaction and extrapolation<br>
                            • Diversity indices (Shannon, Simpson, etc.)<br>
                            • Beta diversity partitioning (betapart)<br>
                            • Comparing assemblages
                        </p>
                    </div>
                    
                    <div style="margin-bottom: 15px;">
                        <h4 style="color: #cccccc; margin: 0 0 8px 0; font-size: 14px;">4. Ordination Methods</h4>
                        <p style="color: #888; font-size: 12px; margin: 0; line-height: 1.5;">
                            • Unconstrained ordination (NMDS, PCA, CA, DCA, PCoA)<br>
                            • Constrained ordination (RDA, CCA, db-RDA, CAP)<br>
                            • Choosing the right method<br>
                            • Interpreting ordination plots
                        </p>
                    </div>
                    
                    <div style="margin-bottom: 15px;">
                        <h4 style="color: #cccccc; margin: 0 0 8px 0; font-size: 14px;">5. Statistical Tests</h4>
                        <p style="color: #888; font-size: 12px; margin: 0; line-height: 1.5;">
                            • PERMANOVA (permutational MANOVA)<br>
                            • ANOSIM (Analysis of Similarities)<br>
                            • Mantel test<br>
                            • envfit (variable fitting)
                        </p>
                    </div>
                    
                    <div>
                        <h4 style="color: #cccccc; margin: 0 0 8px 0; font-size: 14px;">6. Visualization & Export</h4>
                        <p style="color: #888; font-size: 12px; margin: 0; line-height: 1.5;">
                            • Plot customization (colors, symbols, themes)<br>
                            • Combining plots with patchwork<br>
                            • Exporting publication-ready figures<br>
                            • Saving and loading analysis sessions
                        </p>
                    </div>
                </div>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: Typical Analysis Workflow</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        <strong>Standard workflow for community ecology:</strong><br>
                        1. Import and validate species composition data<br>
                        2. Apply appropriate data transformation (Hellinger, log, etc.)<br>
                        3. Calculate diversity indices or rarefaction curves<br>
                        4. Run ordination analysis (NMDS, PCA, etc.)<br>
                        5. Test for significant group differences (PERMANOVA)<br>
                        6. Visualize and export results for publication
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px;">
                    <button style="background: #2e8b57; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%; margin-bottom: 10px;">📝 Download Full PDF Guide</button>
                    <button style="background: #444; color: #ccc; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%;">🎬 Watch Video Overview (10 min)</button>
                </div>
            `
        },
        
        'tutorials': {
            title: '🎓 Tutorials',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🎓 Step-by-Step Tutorials</h2>
                <p style="color: #888; margin-bottom: 30px;">Learn by doing with these guided analysis examples</p>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 15px;">
                    <h3 style="color: #2e8b57; margin-top: 0; font-size: 15px;">🌳 Tutorial 1: Basic Diversity Analysis</h3>
                    <p style="color: #888; font-size: 12px; margin-bottom: 12px;">Duration: 15 minutes | Difficulty: Beginner</p>
                    <p style="color: #cccccc; font-size: 13px; margin-bottom: 15px; line-height: 1.5;">
                        Learn to import data, calculate diversity indices, and create rarefaction curves using the spider dataset from the vegan package.
                    </p>
                    <div style="background: #1e1e1e; padding: 12px; border-radius: 4px; margin-bottom: 10px;">
                        <p style="color: #888; font-size: 11px; margin: 0 0 8px 0;">WHAT YOU'LL LEARN:</p>
                        <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                            • How to import CSV data into Ördin<br>
                            • Running iNEXT rarefaction analysis<br>
                            • Calculating Shannon and Simpson indices<br>
                            • Exporting plots and tables
                        </p>
                    </div>
                    <button style="background: #2e8b57; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-size: 12px;">▶ Start Tutorial</button>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 15px;">
                    <h3 style="color: #2e8b57; margin-top: 0; font-size: 15px;">🗺️ Tutorial 2: NMDS Ordination</h3>
                    <p style="color: #888; font-size: 12px; margin-bottom: 12px;">Duration: 20 minutes | Difficulty: Intermediate</p>
                    <p style="color: #cccccc; font-size: 13px; margin-bottom: 15px; line-height: 1.5;">
                        Master Non-metric Multidimensional Scaling (NMDS) to visualize community composition patterns and test for group differences.
                    </p>
                    <div style="background: #1e1e1e; padding: 12px; border-radius: 4px; margin-bottom: 10px;">
                        <p style="color: #888; font-size: 11px; margin: 0 0 8px 0;">WHAT YOU'LL LEARN:</p>
                        <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                            • Data transformation (Hellinger, Wisconsin)<br>
                            • Running NMDS with stress interpretation<br>
                            • PERMANOVA to test group differences<br>
                            • Customizing ordination plots for publication
                        </p>
                    </div>
                    <button style="background: #2e8b57; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-size: 12px;">▶ Start Tutorial</button>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 15px;">
                    <h3 style="color: #2e8b57; margin-top: 0; font-size: 15px;">🌿 Tutorial 3: Constrained Ordination (RDA/CCA)</h3>
                    <p style="color: #888; font-size: 12px; margin-bottom: 12px;">Duration: 25 minutes | Difficulty: Advanced</p>
                    <p style="color: #cccccc; font-size: 13px; margin-bottom: 15px; line-height: 1.5;">
                        Explore relationships between community composition and environmental variables using Redundancy Analysis (RDA) and Canonical Correspondence Analysis (CCA).
                    </p>
                    <div style="background: #1e1e1e; padding: 12px; border-radius: 4px; margin-bottom: 10px;">
                        <p style="color: #888; font-size: 11px; margin: 0 0 8px 0;">WHAT YOU'LL LEARN:</p>
                        <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                            • Loading species and environmental datasets<br>
                            • Choosing between RDA and CCA<br>
                            • Interpreting variance explained and biplots<br>
                            • Testing environmental variable significance
                        </p>
                    </div>
                    <button style="background: #2e8b57; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-size: 12px;">▶ Start Tutorial</button>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 15px;">
                    <h3 style="color: #2e8b57; margin-top: 0; font-size: 15px;">🧩 Tutorial 4: Beta Diversity Partitioning</h3>
                    <p style="color: #888; font-size: 12px; margin-bottom: 12px;">Duration: 20 minutes | Difficulty: Intermediate</p>
                    <p style="color: #cccccc; font-size: 13px; margin-bottom: 15px; line-height: 1.5;">
                        Use betapart package to separate beta diversity into turnover and nestedness components, revealing ecological processes driving community differences.
                    </p>
                    <div style="background: #1e1e1e; padding: 12px; border-radius: 4px; margin-bottom: 10px;">
                        <p style="color: #888; font-size: 11px; margin: 0 0 8px 0;">WHAT YOU'LL LEARN:</p>
                        <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                            • Understanding turnover vs nestedness<br>
                            • Taxonomic beta partitioning (Baselga framework)<br>
                            • Visualizing beta diversity components<br>
                            • Functional and phylogenetic beta diversity
                        </p>
                    </div>
                    <button style="background: #2e8b57; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-size: 12px;">▶ Start Tutorial</button>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px;">
                    <h3 style="color: #2e8b57; margin-top: 0; font-size: 15px;">🎨 Tutorial 5: Creating Publication Figures</h3>
                    <p style="color: #888; font-size: 12px; margin-bottom: 12px;">Duration: 15 minutes | Difficulty: Beginner</p>
                    <p style="color: #cccccc; font-size: 13px; margin-bottom: 15px; line-height: 1.5;">
                        Master plot customization and learn to combine multiple panels using patchwork for journal-ready figures.
                    </p>
                    <div style="background: #1e1e1e; padding: 12px; border-radius: 4px; margin-bottom: 10px;">
                        <p style="color: #888; font-size: 11px; margin: 0 0 8px 0;">WHAT YOU'LL LEARN:</p>
                        <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                            • Color palette selection (colorblind-friendly)<br>
                            • Combining plots with patchwork<br>
                            • Adding panel labels (A, B, C)<br>
                            • Exporting at 300+ DPI for publication
                        </p>
                    </div>
                    <button style="background: #2e8b57; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-size: 12px;">▶ Start Tutorial</button>
                </div>
            `
        },
        
        'api-reference': {
            title: '📚 API Reference',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📚 R Package API Reference</h2>
                <p style="color: #888; margin-bottom: 30px;">Technical documentation for R packages used in Ördin</p>
                
                <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                    <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">ℹ️ ABOUT THIS REFERENCE</p>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        Ördin integrates multiple R packages for community ecology analysis. This reference provides links to official documentation and common function signatures.
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 15px;">
                    <h3 style="color: #2e8b57; margin-top: 0; font-size: 15px;">📊 vegan - Community Ecology Package</h3>
                    <p style="color: #888; font-size: 12px; margin-bottom: 12px;">Version 2.6-4+ | CRAN Package</p>
                    <p style="color: #cccccc; font-size: 13px; margin-bottom: 15px; line-height: 1.5;">
                        The workhorse package for ordination, diversity indices, and community analysis.
                    </p>
                    <div style="background: #1e1e1e; padding: 12px; border-radius: 4px; margin-bottom: 10px;">
                        <p style="color: #888; font-size: 11px; margin: 0 0 8px 0;">KEY FUNCTIONS:</p>
                        <p style="color: #cccccc; font-size: 11px; margin: 0; line-height: 1.5; font-family: monospace;">
                            diversity() - Calculate diversity indices<br>
                            metaMDS() - Non-metric multidimensional scaling<br>
                            rda() - Redundancy analysis<br>
                            cca() - Canonical correspondence analysis<br>
                            adonis2() - PERMANOVA<br>
                            anosim() - Analysis of similarities<br>
                            mantel() - Mantel test<br>
                            envfit() - Fit environmental vectors
                        </p>
                    </div>
                    <button style="background: #444; color: #ccc; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-size: 12px;">🔗 Open CRAN Documentation</button>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 15px;">
                    <h3 style="color: #2e8b57; margin-top: 0; font-size: 15px;">📈 iNEXT - Interpolation and Extrapolation</h3>
                    <p style="color: #888; font-size: 12px; margin-bottom: 12px;">Version 3.0.0+ | CRAN Package</p>
                    <p style="color: #cccccc; font-size: 13px; margin-bottom: 15px; line-height: 1.5;">
                        Rarefaction and extrapolation for Hill numbers with seamless sample-size- and coverage-based diversity estimation.
                    </p>
                    <div style="background: #1e1e1e; padding: 12px; border-radius: 4px; margin-bottom: 10px;">
                        <p style="color: #888; font-size: 11px; margin: 0 0 8px 0;">KEY FUNCTIONS:</p>
                        <p style="color: #cccccc; font-size: 11px; margin: 0; line-height: 1.5; font-family: monospace;">
                            iNEXT() - Main estimation function<br>
                            ggiNEXT() - ggplot2 visualization<br>
                            ChaoRichness() - Richness estimation<br>
                            ChaoShannon() - Shannon entropy estimation<br>
                            ChaoSimpson() - Simpson diversity estimation
                        </p>
                    </div>
                    <button style="background: #444; color: #ccc; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-size: 12px;">🔗 Open Package Website</button>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 15px;">
                    <h3 style="color: #2e8b57; margin-top: 0; font-size: 15px;">🧩 betapart - Beta Diversity Partitioning</h3>
                    <p style="color: #888; font-size: 12px; margin-bottom: 12px;">Version 1.6+ | CRAN Package</p>
                    <p style="color: #cccccc; font-size: 13px; margin-bottom: 15px; line-height: 1.5;">
                        Partition beta diversity into turnover and nestedness components for taxonomic, functional, and phylogenetic diversity.
                    </p>
                    <div style="background: #1e1e1e; padding: 12px; border-radius: 4px; margin-bottom: 10px;">
                        <p style="color: #888; font-size: 11px; margin: 0 0 8px 0;">KEY FUNCTIONS:</p>
                        <p style="color: #cccccc; font-size: 11px; margin: 0; line-height: 1.5; font-family: monospace;">
                            beta.pair() - Pairwise taxonomic beta diversity<br>
                            beta.multi() - Multiple-site beta diversity<br>
                            functional.beta.pair() - Functional beta diversity<br>
                            phylo.beta.pair() - Phylogenetic beta diversity<br>
                            beta.temp() - Temporal beta diversity
                        </p>
                    </div>
                    <button style="background: #444; color: #ccc; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-size: 12px;">🔗 Open CRAN Documentation</button>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px;">
                    <h3 style="color: #2e8b57; margin-top: 0; font-size: 15px;">🎨 patchwork - Plot Composition</h3>
                    <p style="color: #888; font-size: 12px; margin-bottom: 12px;">Version 1.1.2+ | CRAN Package</p>
                    <p style="color: #cccccc; font-size: 13px; margin-bottom: 15px; line-height: 1.5;">
                        Combine ggplot2 plots into multi-panel figures with automatic alignment and annotation.
                    </p>
                    <div style="background: #1e1e1e; padding: 12px; border-radius: 4px; margin-bottom: 10px;">
                        <p style="color: #888; font-size: 11px; margin: 0 0 8px 0;">KEY OPERATORS:</p>
                        <p style="color: #cccccc; font-size: 11px; margin: 0; line-height: 1.5; font-family: monospace;">
                            + | Horizontal composition<br>
                            / - Vertical composition<br>
                            plot_layout() - Control layout parameters<br>
                            plot_annotation() - Add titles and tags<br>
                            inset_element() - Add inset plots
                        </p>
                    </div>
                    <button style="background: #444; color: #ccc; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-size: 12px;">🔗 Open Package Website</button>
                </div>
            `
        },
        
        'video-tutorials': {
            title: '🎬 Video Tutorials',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🎬 Video Tutorial Library</h2>
                <p style="color: #888; margin-bottom: 30px;">Watch and learn with our comprehensive video series</p>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 15px;">
                    <h3 style="color: #2e8b57; margin-top: 0; font-size: 15px;">🎓 Getting Started Series</h3>
                    
                    <div style="background: #1e1e1e; padding: 15px; border-radius: 4px; margin-bottom: 12px; display: flex; gap: 15px; align-items: center;">
                        <div style="background: #2e8b57; width: 80px; height: 60px; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: white; font-size: 24px;">▶</div>
                        <div style="flex: 1;">
                            <h4 style="color: #cccccc; margin: 0 0 4px 0; font-size: 13px;">Welcome to Ördin v3.0</h4>
                            <p style="color: #888; font-size: 11px; margin: 0;">10:23 | Introduction to interface and key features</p>
                        </div>
                    </div>
                    
                    <div style="background: #1e1e1e; padding: 15px; border-radius: 4px; margin-bottom: 12px; display: flex; gap: 15px; align-items: center;">
                        <div style="background: #2e8b57; width: 80px; height: 60px; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: white; font-size: 24px;">▶</div>
                        <div style="flex: 1;">
                            <h4 style="color: #cccccc; margin: 0 0 4px 0; font-size: 13px;">Importing Your First Dataset</h4>
                            <p style="color: #888; font-size: 11px; margin: 0;">8:15 | CSV and Excel import walkthrough</p>
                        </div>
                    </div>
                    
                    <div style="background: #1e1e1e; padding: 15px; border-radius: 4px; display: flex; gap: 15px; align-items: center;">
                        <div style="background: #2e8b57; width: 80px; height: 60px; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: white; font-size: 24px;">▶</div>
                        <div style="flex: 1;">
                            <h4 style="color: #cccccc; margin: 0 0 4px 0; font-size: 13px;">Understanding Data Formats</h4>
                            <p style="color: #888; font-size: 11px; margin: 0;">12:40 | Abundance vs incidence data explained</p>
                        </div>
                    </div>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 15px;">
                    <h3 style="color: #2e8b57; margin-top: 0; font-size: 15px;">📊 Diversity Analysis Series</h3>
                    
                    <div style="background: #1e1e1e; padding: 15px; border-radius: 4px; margin-bottom: 12px; display: flex; gap: 15px; align-items: center;">
                        <div style="background: #2e8b57; width: 80px; height: 60px; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: white; font-size: 24px;">▶</div>
                        <div style="flex: 1;">
                            <h4 style="color: #cccccc; margin: 0 0 4px 0; font-size: 13px;">Rarefaction Curves with iNEXT</h4>
                            <p style="color: #888; font-size: 11px; margin: 0;">18:30 | Complete guide to diversity estimation</p>
                        </div>
                    </div>
                    
                    <div style="background: #1e1e1e; padding: 15px; border-radius: 4px; margin-bottom: 12px; display: flex; gap: 15px; align-items: center;">
                        <div style="background: #2e8b57; width: 80px; height: 60px; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: white; font-size: 24px;">▶</div>
                        <div style="flex: 1;">
                            <h4 style="color: #cccccc; margin: 0 0 4px 0; font-size: 13px;">Beta Diversity Partitioning</h4>
                            <p style="color: #888; font-size: 11px; margin: 0;">22:15 | Turnover vs nestedness analysis</p>
                        </div>
                    </div>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 15px;">
                    <h3 style="color: #2e8b57; margin-top: 0; font-size: 15px;">🗺️ Ordination Series</h3>
                    
                    <div style="background: #1e1e1e; padding: 15px; border-radius: 4px; margin-bottom: 12px; display: flex; gap: 15px; align-items: center;">
                        <div style="background: #2e8b57; width: 80px; height: 60px; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: white; font-size: 24px;">▶</div>
                        <div style="flex: 1;">
                            <h4 style="color: #cccccc; margin: 0 0 4px 0; font-size: 13px;">Mastering NMDS</h4>
                            <p style="color: #888; font-size: 11px; margin: 0;">25:45 | From data transformation to interpretation</p>
                        </div>
                    </div>
                    
                    <div style="background: #1e1e1e; padding: 15px; border-radius: 4px; margin-bottom: 12px; display: flex; gap: 15px; align-items: center;">
                        <div style="background: #2e8b57; width: 80px; height: 60px; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: white; font-size: 24px;">▶</div>
                        <div style="flex: 1;">
                            <h4 style="color: #cccccc; margin: 0 0 4px 0; font-size: 13px;">RDA and CCA Explained</h4>
                            <p style="color: #888; font-size: 11px; margin: 0;">28:20 | Constrained ordination with environmental data</p>
                        </div>
                    </div>
                    
                    <div style="background: #1e1e1e; padding: 15px; border-radius: 4px; display: flex; gap: 15px; align-items: center;">
                        <div style="background: #2e8b57; width: 80px; height: 60px; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: white; font-size: 24px;">▶</div>
                        <div style="flex: 1;">
                            <h4 style="color: #cccccc; margin: 0 0 4px 0; font-size: 13px;">PERMANOVA Statistical Testing</h4>
                            <p style="color: #888; font-size: 11px; margin: 0;">16:50 | Testing group differences in community composition</p>
                        </div>
                    </div>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px;">
                    <h3 style="color: #2e8b57; margin-top: 0; font-size: 15px;">🎨 Visualization Series</h3>
                    
                    <div style="background: #1e1e1e; padding: 15px; border-radius: 4px; margin-bottom: 12px; display: flex; gap: 15px; align-items: center;">
                        <div style="background: #2e8b57; width: 80px; height: 60px; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: white; font-size: 24px;">▶</div>
                        <div style="flex: 1;">
                            <h4 style="color: #cccccc; margin: 0 0 4px 0; font-size: 13px;">Publication-Ready Plots</h4>
                            <p style="color: #888; font-size: 11px; margin: 0;">14:30 | Color palettes, fonts, and export settings</p>
                        </div>
                    </div>
                    
                    <div style="background: #1e1e1e; padding: 15px; border-radius: 4px; display: flex; gap: 15px; align-items: center;">
                        <div style="background: #2e8b57; width: 80px; height: 60px; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: white; font-size: 24px;">▶</div>
                        <div style="flex: 1;">
                            <h4 style="color: #cccccc; margin: 0 0 4px 0; font-size: 13px;">Multi-Panel Figures with patchwork</h4>
                            <p style="color: #888; font-size: 11px; margin: 0;">12:10 | Combining plots for complex figures</p>
                        </div>
                    </div>
                </div>
            `
        },
        
        // HELP WORKFLOWS - SUPPORT & ABOUT (Continued)
        'faqs': {
            title: '❓ FAQs',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">❓ Frequently Asked Questions</h2>
                <p style="color: #888; margin-bottom: 30px;">Quick answers to common questions</p>
                
                <div style="background: #2d2d30; padding: 16px; border-radius: 4px; margin-bottom: 12px;">
                    <h4 style="color: #2e8b57; margin: 0 0 8px 0; font-size: 14px;">Q: What data formats does Ördin support?</h4>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        A: Ördin supports CSV (.csv), Excel (.xlsx, .xls), and Google Drive imports. Data must be in site-by-species matrix format with rows as samples and columns as species.
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 16px; border-radius: 4px; margin-bottom: 12px;">
                    <h4 style="color: #2e8b57; margin: 0 0 8px 0; font-size: 14px;">Q: Should I use abundance or incidence data?</h4>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        A: Use abundance data when you have counts (number of individuals). Use incidence data for presence/absence across sampling units. Abundance data is more common and provides more information.
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 16px; border-radius: 4px; margin-bottom: 12px;">
                    <h4 style="color: #2e8b57; margin: 0 0 8px 0; font-size: 14px;">Q: Which ordination method should I choose?</h4>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        A: NMDS is recommended for most ecological data. Use RDA/CCA when you have environmental variables. See the ordination workflow tips for detailed guidance.
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 16px; border-radius: 4px; margin-bottom: 12px;">
                    <h4 style="color: #2e8b57; margin: 0 0 8px 0; font-size: 14px;">Q: What does "stress" mean in NMDS?</h4>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        A: Stress measures how well the 2D plot represents your data. Stress <0.05 = excellent, <0.10 = good, <0.20 = acceptable, >0.20 = poor (try different distance metrics or more dimensions).
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 16px; border-radius: 4px;">
                    <h4 style="color: #2e8b57; margin: 0 0 8px 0; font-size: 14px;">Q: How do I export publication-quality figures?</h4>
                    <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                        A: Use 300 DPI for print, 150 DPI for web. Choose colorblind-friendly palettes (Viridis/Plasma). Export as PNG for manuscripts or SVG for editing in Illustrator.
                    </p>
                </div>
            `
        },
        
        'report-bug': {
            title: '🐛 Report Bug',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🐛 Report a Bug</h2>
                <p style="color: #888; margin-bottom: 30px;">Help us improve Ördin by reporting issues</p>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">Bug Report Form</h3>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 8px;">ISSUE TITLE *</label>
                    <input type="text" placeholder="e.g., NMDS plot not displaying after analysis" style="width: 100%; padding: 10px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 15px;">
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 8px;">DESCRIPTION *</label>
                    <textarea placeholder="Describe what happened..." rows="5" style="width: 100%; padding: 10px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 15px; font-family: inherit;"></textarea>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 8px;">STEPS TO REPRODUCE</label>
                    <textarea placeholder="1. Go to...\n2. Click on...\n3. See error" rows="4" style="width: 100%; padding: 10px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 15px; font-family: inherit;"></textarea>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 8px;">SYSTEM INFORMATION</label>
                    <div style="background: #1e1e1e; padding: 12px; border-radius: 4px; margin-bottom: 15px;">
                        <p style="color: #cccccc; font-size: 11px; margin: 0; font-family: monospace;">
                            Ördin Version: 3.0.0<br>
                            OS: Windows 11<br>
                            R Version: 4.3.2
                        </p>
                    </div>
                    
                    <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%; font-weight: 600;">📤 Submit Bug Report</button>
                </div>
            `
        },
        
        'feature-request': {
            title: '💡 Feature Request',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">💡 Request a Feature</h2>
                <p style="color: #888; margin-bottom: 30px;">Suggest new features or improvements</p>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px;">
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 8px;">FEATURE TITLE *</label>
                    <input type="text" placeholder="e.g., Add support for phylogenetic trees" style="width: 100%; padding: 10px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 15px;">
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 8px;">DESCRIPTION *</label>
                    <textarea placeholder="Describe the feature you'd like to see..." rows="6" style="width: 100%; padding: 10px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 15px; font-family: inherit;"></textarea>
                    
                    <label style="color: #888; font-size: 11px; display: block; margin-bottom: 8px;">USE CASE</label>
                    <textarea placeholder="How would this feature help your research?" rows="4" style="width: 100%; padding: 10px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 15px; font-family: inherit;"></textarea>
                    
                    <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%; font-weight: 600;">🚀 Submit Feature Request</button>
                </div>
            `
        },
        
        'community': {
            title: '👥 Community Forum',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">👥 Join the Ördin Community</h2>
                <p style="color: #888; margin-bottom: 30px;">Connect with other community ecologists</p>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 15px; text-align: center;">
                    <h3 style="color: #2e8b57; margin-top: 0;">💬 Discussion Forum</h3>
                    <p style="color: #cccccc; font-size: 13px; margin-bottom: 20px;">Ask questions, share analyses, and learn from other users</p>
                    <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; border-radius: 4px; cursor: pointer; font-size: 13px; font-weight: 600;">🔗 Visit Forum</button>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 15px; text-align: center;">
                    <h3 style="color: #2e8b57; margin-top: 0;">📝 Mailing List</h3>
                    <p style="color: #cccccc; font-size: 13px; margin-bottom: 20px;">Get updates on new features and releases</p>
                    <input type="email" placeholder="your.email@example.com" style="width: 100%; padding: 10px; background: #1e1e1e; border: 1px solid #444; color: #ccc; border-radius: 4px; margin-bottom: 10px;">
                    <button style="background: #444; color: #ccc; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 13px; width: 100%;">✉️ Subscribe</button>
                </div>
            `
        },
        
        'version-info': {
            title: 'ℹ️ Version Info',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">ℹ️ Ördin Version 3.0.0</h2>
                <p style="color: #888; margin-bottom: 30px;">Release Date: 2025-01-15</p>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">What's New in v3.0</h3>
                    <div style="color: #cccccc; font-size: 13px; line-height: 1.8;">
                        • VS Code-inspired flat design interface<br>
                        • Integrated betapart package for beta diversity partitioning<br>
                        • patchwork support for multi-panel figures<br>
                        • Enhanced ordination suite (db-RDA, CAP, ANOSIM)<br>
                        • Comprehensive tooltips and knowledge boxes<br>
                        • Google Drive integration for cloud storage<br>
                        • Performance improvements and bug fixes
                    </div>
                </div>
                
                <div style="background: #1e1e1e; padding: 16px; border-radius: 4px;">
                    <p style="color: #888; font-size: 11px; margin: 0; font-family: monospace;">
                        Build: 3.0.0-stable<br>
                        Platform: Windows x64<br>
                        R Version: 4.3.2+<br>
                        Electron: 28.0.0
                    </p>
                </div>
            `
        },
        
        'author-info': {
            title: '👤 Author Info',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">👤 About the Author</h2>
                
                <div style="background: #2d2d30; padding: 24px; border-radius: 4px; margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">Jimmy Moses</h3>
                    <p style="color: #cccccc; font-size: 13px; line-height: 1.6; margin-bottom: 15px;">
                        Community ecologist and software developer specializing in biodiversity analysis tools for tropical ecosystems.
                    </p>
                    <div style="background: #1e1e1e; padding: 12px; border-radius: 4px;">
                        <p style="color: #888; font-size: 11px; margin: 0;">
                            📧 Email: jmoses@pnguot.ac.pg<br>
                            🎓 Institution: PNG University of Technology<br>
                            🔗 GitHub: github.com/jmoses
                        </p>
                    </div>
                </div>
            `
        },
        
        'changelog': {
            title: '📜 Changelog',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📜 Version History</h2>
                
                <div style="background: #2d2d30; padding: 16px; border-radius: 4px; margin-bottom: 12px;">
                    <h4 style="color: #2e8b57; margin: 0 0 8px 0;">v3.0.0 - 2025-01-15</h4>
                    <p style="color: #888; font-size: 12px; margin: 0 0 8px 0;">Major release with new UI</p>
                    <p style="color: #cccccc; font-size: 11px; margin: 0; line-height: 1.6;">
                        • Complete UI redesign (VS Code theme)<br>
                        • Added betapart integration<br>
                        • Added patchwork multi-panel support
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 16px; border-radius: 4px; margin-bottom: 12px;">
                    <h4 style="color: #2e8b57; margin: 0 0 8px 0;">v2.5.0 - 2024-09-10</h4>
                    <p style="color: #888; font-size: 12px; margin: 0 0 8px 0;">Enhanced ordination</p>
                    <p style="color: #cccccc; font-size: 11px; margin: 0; line-height: 1.6;">
                        • Added db-RDA and CAP methods<br>
                        • Improved PERMANOVA interface
                    </p>
                </div>
            `
        },
        
        'github-repo': {
            title: '⭐ GitHub',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">⭐ Ördin on GitHub</h2>
                
                <div style="background: #2d2d30; padding: 24px; border-radius: 4px; text-align: center;">
                    <p style="color: #cccccc; font-size: 14px; margin-bottom: 20px;">View source code, contribute, or report issues</p>
                    <button style="background: #2e8b57; color: white; border: none; padding: 14px 28px; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: 600; margin-bottom: 10px;">🔗 Open GitHub Repository</button>
                    <p style="color: #888; font-size: 11px; margin: 0;">github.com/jmoses/ordin</p>
                </div>
            `
        },
        
        'license-info': {
            title: '📜 License',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📜 Software License</h2>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px;">
                    <h3 style="color: #2e8b57; margin-top: 0;">MIT License</h3>
                    <p style="color: #cccccc; font-size: 12px; line-height: 1.6;">
                        Copyright (c) 2025 Jimmy Moses<br><br>
                        Permission is hereby granted, free of charge, to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software.
                    </p>
                </div>
            `
        },
        
        'citations': {
            title: '📚 Citations',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📚 How to Cite</h2>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px; margin-bottom: 15px;">
                    <h4 style="color: #2e8b57; margin-top: 0;">Citing Ördin</h4>
                    <p style="color: #cccccc; font-size: 12px; background: #1e1e1e; padding: 12px; border-radius: 4px; font-family: monospace;">
                        Moses, J. (2025). Ördin: Community Ecology Analysis Tool v3.0. PNG University of Technology.
                    </p>
                </div>
                
                <div style="background: #2d2d30; padding: 20px; border-radius: 4px;">
                    <h4 style="color: #2e8b57; margin-top: 0;">Key R Packages to Cite</h4>
                    <p style="color: #cccccc; font-size: 11px; line-height: 1.6;">
                        <strong>vegan:</strong> Oksanen et al. (2022)<br>
                        <strong>iNEXT:</strong> Hsieh et al. (2016)<br>
                        <strong>betapart:</strong> Baselga & Orme (2012)<br>
                        <strong>patchwork:</strong> Pedersen (2020)
                    </p>
                </div>
            `
        },
        
        // Default workflow for undefined items
        'default': {
            title: '⚙️ Workflow',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">⚙️ Feature Workflow</h2>
                <p style="color: #888; margin-bottom: 30px;">This workflow interface will display step-by-step instructions and controls for the selected feature.</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; text-align: center;">
                    <p style="color: #888;">Workflow UI will be implemented here</p>
                </div>
            `
        }
    };
    
    const workflow = workflows[workflowId] || workflows['default'];
    
    // Update content area
    contentArea.innerHTML = workflow.content;
    
    // Update breadcrumb
    const breadcrumb = document.querySelector('.breadcrumb');
    if (breadcrumb) {
        breadcrumb.textContent = currentView.charAt(0).toUpperCase() + currentView.slice(1) + ' → ' + workflow.title;
    }
    
    console.log(`Opened workflow: ${workflowId}`);
}

// =======================
// TAB MANAGEMENT SYSTEM
// =======================

// Create new tab
function createNewTab(tabId, tabTitle, contentType) {
    // Check if tab already exists
    const existingTab = openTabs.find(tab => tab.id === tabId);
    if (existingTab) {
        switchToTab(tabId);
        return;
    }
    
    // Add to tabs array
    openTabs.push({ id: tabId, title: tabTitle, type: contentType });
    
    // Render tab bar
    renderTabBar();
    
    // Create tab content
    createTabContent(tabId, contentType);
    
    // Switch to new tab
    switchToTab(tabId);
    
    console.log(`Created new tab: ${tabId}`);
}

// Switch to existing tab
function switchToTab(tabId) {
    activeTabId = tabId;
    
    // Update tab active states
    document.querySelectorAll('.tab').forEach(tab => {
        if (tab.getAttribute('data-tab-id') === tabId) {
            tab.classList.add('active');
        } else {
            tab.classList.remove('active');
        }
    });
    
    // Update content active states
    document.querySelectorAll('.tab-content').forEach(content => {
        if (content.id === `tab-${tabId}`) {
            content.classList.add('active');
        } else {
            content.classList.remove('active');
        }
    });
    
    // Update breadcrumb and status
    updateBreadcrumbForTab(tabId);
    
    console.log(`Switched to tab: ${tabId}`);
}

// Close tab
function closeTab(event, tabId) {
    event.stopPropagation(); // Prevent tab click
    
    // Don't close if it's the last tab
    if (openTabs.length === 1) {
        alert('Cannot close the last tab');
        return;
    }
    
    // Find tab index
    const tabIndex = openTabs.findIndex(tab => tab.id === tabId);
    if (tabIndex === -1) return;
    
    // Remove from array
    openTabs.splice(tabIndex, 1);
    
    // Remove content
    const tabContent = document.getElementById(`tab-${tabId}`);
    if (tabContent) tabContent.remove();
    
    // If closing active tab, switch to previous tab
    if (activeTabId === tabId) {
        const newActiveIndex = Math.max(0, tabIndex - 1);
        switchToTab(openTabs[newActiveIndex].id);
    }
    
    // Re-render tab bar
    renderTabBar();
    
    console.log(`Closed tab: ${tabId}`);
}

// Render tab bar
function renderTabBar() {
    const tabBar = document.getElementById('tabBar');
    if (!tabBar) return;
    
    tabBar.innerHTML = openTabs.map(tab => `
        <div class="tab ${tab.id === activeTabId ? 'active' : ''}" 
             data-tab-id="${tab.id}" 
             onclick="switchToTab('${tab.id}')">
            ${tab.title} 
            <span class="tab-close" onclick="closeTab(event, '${tab.id}')">&times;</span>
        </div>
    `).join('');
}

// Create tab content based on type
function createTabContent(tabId, contentType) {
    const contentArea = document.getElementById('contentArea');
    if (!contentArea) return;
    
    const tabContent = document.createElement('div');
    tabContent.id = `tab-${tabId}`;
    tabContent.className = 'tab-content';
    
    // Generate content based on type
    if (contentType === 'diversity') {
        tabContent.innerHTML = getDiversityTabContent();
    } else if (contentType === 'results') {
        tabContent.innerHTML = getNMDSResultsTabContent();
    } else if (contentType === 'about') {
        tabContent.innerHTML = getAboutOrdinContent();
    } else {
        tabContent.innerHTML = `<div style="padding: 20px; color: #888;">Content for ${tabId}</div>`;
    }
    
    contentArea.appendChild(tabContent);
}

// Update breadcrumb for tab
function updateBreadcrumbForTab(tabId) {
    const breadcrumb = document.querySelector('.breadcrumb');
    const statusBadge = document.querySelector('.status-badge');
    
    if (!breadcrumb) return;
    
    const breadcrumbs = {
        'dashboard': 'Home → Dashboard',
        'diversity': 'Analysis → Diversity Estimation',
        'nmds': 'Analysis → NMDS Results'
    };
    
    const statuses = {
        'dashboard': '● Ready',
        'diversity': '● Analysis Complete',
        'nmds': '● Analysis Complete'
    };
    
    breadcrumb.textContent = breadcrumbs[tabId] || 'Home';
    if (statusBadge) statusBadge.textContent = statuses[tabId] || '● Ready';
}

// Get Diversity tab content
function getDiversityTabContent() {
    return `
        <div style="padding: 20px;">
            <h2 style="color: #2e8b57; margin-bottom: 20px;">📈 Diversity Estimation (iNEXT)</h2>
            
            <div style="background: #1a3a2e; border-left: 3px solid #2e8b57; padding: 12px 16px; margin-bottom: 20px;">
                <p style="color: #2e8b57; font-weight: 600; margin: 0 0 8px 0;">💡 KNOWLEDGE: What is iNEXT?</p>
                <p style="color: #cccccc; font-size: 12px; margin: 0; line-height: 1.5;">
                    iNEXT (iNterpolation and EXTrapolation) computes Hill numbers for rarefaction and extrapolation curves.
                    It standardizes sample size and coverage to compare diversity across assemblages.
                </p>
            </div>
            
            <!-- Rarefaction Curve Placeholder -->
            <div style="background: #252526; border: 1px solid #3e3e42; padding: 20px; margin-bottom: 20px; height: 400px; display: flex; align-items: center; justify-content: center;">
                <div style="text-align: center; color: #888;">
                    <h3 style="color: #2e8b57; margin-bottom: 10px;">📈 Rarefaction Curve</h3>
                    <p>Sample-size based rarefaction and extrapolation curve</p>
                    <p style="font-size: 11px; margin-top: 10px;">Plot will be rendered here</p>
                </div>
            </div>
            
            <!-- Plot Controls -->
            <div style="display: flex; gap: 8px; margin-bottom: 20px;">
                <button style="padding: 8px 16px; background: #2d2d30; border: 1px solid #3e3e42; color: #ccc; cursor: pointer;">🎨 Customize Plot</button>
                <button style="padding: 8px 16px; background: #2d2d30; border: 1px solid #3e3e42; color: #ccc; cursor: pointer;">🔍 Zoom In</button>
                <button style="padding: 8px 16px; background: #2d2d30; border: 1px solid #3e3e42; color: #ccc; cursor: pointer;">🔍 Zoom Out</button>
                <button style="padding: 8px 16px; background: #2e8b57; border: 1px solid #2e8b57; color: white; cursor: pointer;">💾 Export PNG</button>
            </div>
            
            <!-- Configuration Panel -->
            <div style="background: #252526; padding: 20px; border: 1px solid #3e3e42;">
                <h3 style="color: #2e8b57; margin-top: 0; font-size: 14px;">Analysis Configuration</h3>
                
                <label style="display: block; margin-bottom: 15px; color: #888; font-size: 12px;">
                    PLOT TYPE
                    <select style="width: 100%; margin-top: 6px; padding: 8px; background: #1e1e1e; border: 1px solid #3e3e42; color: #ccc;">
                        <option selected>Sample-size based</option>
                        <option>Sample completeness</option>
                        <option>Coverage-based</option>
                    </select>
                </label>
                
                <label style="display: block; margin-bottom: 15px; color: #888; font-size: 12px;">
                    DIVERSITY ORDER (q)
                    <select style="width: 100%; margin-top: 6px; padding: 8px; background: #1e1e1e; border: 1px solid #3e3e42; color: #ccc;">
                        <option>q = 0 (Species richness)</option>
                        <option selected>q = 1 (Shannon diversity)</option>
                        <option>q = 2 (Simpson diversity)</option>
                        <option>All orders (0, 1, 2)</option>
                    </select>
                </label>
                
                <label style="display: block; margin-bottom: 15px; color: #888; font-size: 12px;">
                    CONFIDENCE LEVEL
                    <input type="number" value="0.95" step="0.01" min="0.8" max="0.99" 
                           style="width: 100%; margin-top: 6px; padding: 8px; background: #1e1e1e; border: 1px solid #3e3e42; color: #ccc;">
                </label>
                
                <button style="width: 100%; padding: 12px; background: #2e8b57; border: none; color: white; cursor: pointer; font-weight: 600;">
                    ▶ Run Diversity Analysis
                </button>
            </div>
        </div>
    `;
}

// Get NMDS Results tab content
function getNMDSResultsTabContent() {
    // Calculate stress interpretation
    const stress = 0.089;
    const stressHTML = typeof generateStressInterpretationHTML === 'function' 
        ? generateStressInterpretationHTML(stress)
        : '';
    
    // Calculate PERMANOVA interpretation
    const pValue = 0.001;
    const rSquared = 0.234;
    const permanovaHTML = typeof generatePERMANOVAInterpretationHTML === 'function'
        ? generatePERMANOVAInterpretationHTML(pValue, rSquared)
        : '';
    
    return `
        <div style="display: flex; height: 100%;">
            <!-- Plot Panel (70%) -->
            <div style="flex: 0 0 70%; padding: 20px; border-right: 1px solid #3e3e42;">
                ${stressHTML}
                <div style="background: #252526; border: 1px solid #3e3e42; height: 500px; display: flex; align-items: center; justify-content: center; margin-bottom: 15px;">
                    <svg viewBox="0 0 600 400" style="width: 100%; height: 100%;">
                        <!-- Background grid -->
                        <defs>
                            <pattern id="grid" width="50" height="50" patternUnits="userSpaceOnUse">
                                <path d="M 50 0 L 0 0 0 50" fill="none" stroke="#2d2d30" stroke-width="0.5"/>
                            </pattern>
                        </defs>
                        <rect width="600" height="400" fill="url(#grid)"/>
                        
                        <!-- Axes -->
                        <line x1="50" y1="350" x2="550" y2="350" stroke="#3e3e42" stroke-width="2"/>
                        <line x1="50" y1="50" x2="50" y2="350" stroke="#3e3e42" stroke-width="2"/>
                        
                        <!-- Axis labels -->
                        <text x="300" y="385" text-anchor="middle" fill="#888" font-size="12">NMDS1</text>
                        <text x="20" y="200" text-anchor="middle" fill="#888" font-size="12" transform="rotate(-90 20 200)">NMDS2</text>
                        
                        <!-- Sample points - Group A (Forest) -->
                        <circle cx="120" cy="100" r="6" fill="#2e8b57" opacity="0.8"/>
                        <circle cx="150" cy="120" r="6" fill="#2e8b57" opacity="0.8"/>
                        <circle cx="100" cy="140" r="6" fill="#2e8b57" opacity="0.8"/>
                        <circle cx="130" cy="160" r="6" fill="#2e8b57" opacity="0.8"/>
                        <circle cx="170" cy="110" r="6" fill="#2e8b57" opacity="0.8"/>
                        <circle cx="140" cy="90" r="6" fill="#2e8b57" opacity="0.8"/>
                        
                        <!-- Sample points - Group B (Grassland) -->
                        <circle cx="350" cy="200" r="6" fill="#007acc" opacity="0.8"/>
                        <circle cx="380" cy="220" r="6" fill="#007acc" opacity="0.8"/>
                        <circle cx="320" cy="240" r="6" fill="#007acc" opacity="0.8"/>
                        <circle cx="360" cy="260" r="6" fill="#007acc" opacity="0.8"/>
                        <circle cx="400" cy="210" r="6" fill="#007acc" opacity="0.8"/>
                        <circle cx="370" cy="190" r="6" fill="#007acc" opacity="0.8"/>
                        
                        <!-- Sample points - Group C (Disturbed) -->
                        <circle cx="450" cy="100" r="6" fill="#d4a017" opacity="0.8"/>
                        <circle cx="480" cy="120" r="6" fill="#d4a017" opacity="0.8"/>
                        <circle cx="420" cy="140" r="6" fill="#d4a017" opacity="0.8"/>
                        <circle cx="460" cy="160" r="6" fill="#d4a017" opacity="0.8"/>
                        <circle cx="500" cy="110" r="6" fill="#d4a017" opacity="0.8"/>
                        <circle cx="470" cy="90" r="6" fill="#d4a017" opacity="0.8"/>
                        
                        <!-- Legend -->
                        <rect x="480" y="300" width="100" height="80" fill="#1e1e1e" stroke="#3e3e42"/>
                        <circle cx="495" cy="315" r="4" fill="#2e8b57"/>
                        <text x="505" y="320" fill="#ccc" font-size="11">Forest</text>
                        <circle cx="495" cy="335" r="4" fill="#007acc"/>
                        <text x="505" y="340" fill="#ccc" font-size="11">Grassland</text>
                        <circle cx="495" cy="355" r="4" fill="#d4a017"/>
                        <text x="505" y="360" fill="#ccc" font-size="11">Disturbed</text>
                        
                        <!-- Stress value -->
                        <text x="60" y="70" fill="#2e8b57" font-size="13" font-weight="bold">Stress: 0.089</text>
                    </svg>
                </div>
                
                <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                    <button style="padding: 8px 16px; background: #2d2d30; border: 1px solid #3e3e42; color: #ccc; cursor: pointer; font-size: 12px;">🎨 Customize Plot</button>
                    <button style="padding: 8px 16px; background: #2d2d30; border: 1px solid #3e3e42; color: #ccc; cursor: pointer; font-size: 12px;">🔍 Zoom In</button>
                    <button style="padding: 8px 16px; background: #2d2d30; border: 1px solid #3e3e42; color: #ccc; cursor: pointer; font-size: 12px;">🔍 Zoom Out</button>
                    <button style="padding: 8px 16px; background: #2e8b57; border: 1px solid #2e8b57; color: white; cursor: pointer; font-size: 12px;">💾 Export PNG</button>
                    <button style="padding: 8px 16px; background: #2d2d30; border: 1px solid #3e3e42; color: #ccc; cursor: pointer; font-size: 12px;">📄 Export PDF</button>
                </div>
            </div>

            <!-- Results Panel (30%) -->
            <div style="flex: 0 0 30%; padding: 20px; overflow-y: auto;">
                ${permanovaHTML}
                
                <div style="margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; font-size: 13px; margin-bottom: 12px; padding-bottom: 6px; border-bottom: 1px solid #3e3e42;">ORDINATION STATISTICS</h3>
                    <div style="font-size: 12px; line-height: 1.8;">
                        <div style="display: flex; justify-content: space-between; padding: 4px 0;">
                            <span style="color: #888;">Stress:</span>
                            <span style="color: #2e8b57; font-family: monospace; font-weight: 600;">0.089</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding: 4px 0;">
                            <span style="color: #888;">Convergence:</span>
                            <span style="color: #2e8b57; font-family: monospace; font-weight: 600;">✓ Converged</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding: 4px 0;">
                            <span style="color: #888;">Iterations:</span>
                            <span style="color: #ccc; font-family: monospace;">20</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding: 4px 0;">
                            <span style="color: #888;">Dimensions:</span>
                            <span style="color: #ccc; font-family: monospace;">2</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding: 4px 0;">
                            <span style="color: #888;">Distance:</span>
                            <span style="color: #ccc; font-family: monospace;">Bray-Curtis</span>
                        </div>
                    </div>
                </div>

                <div style="margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; font-size: 13px; margin-bottom: 12px; padding-bottom: 6px; border-bottom: 1px solid #3e3e42;">PERMANOVA RESULTS</h3>
                    <div style="font-size: 12px; line-height: 1.8;">
                        <div style="display: flex; justify-content: space-between; padding: 4px 0;">
                            <span style="color: #888;">F-statistic:</span>
                            <span style="color: #ccc; font-family: monospace;">12.450</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding: 4px 0;">
                            <span style="color: #888;">R²:</span>
                            <span style="color: #ccc; font-family: monospace;">0.234</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding: 4px 0;">
                            <span style="color: #888;">p-value:</span>
                            <span style="color: #2e8b57; font-family: monospace; font-weight: 600;">0.001 ***</span>
                        </div>
                    </div>
                </div>

                <div style="margin-bottom: 20px;">
                    <h3 style="color: #2e8b57; font-size: 13px; margin-bottom: 12px; padding-bottom: 6px; border-bottom: 1px solid #3e3e42;">PAIRWISE COMPARISONS</h3>
                    <div style="font-size: 12px; line-height: 1.8;">
                        <div style="display: flex; justify-content: space-between; padding: 4px 0;">
                            <span style="color: #888;">Forest vs Grassland:</span>
                            <span style="color: #2e8b57; font-family: monospace; font-weight: 600;">0.002 **</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding: 4px 0;">
                            <span style="color: #888;">Forest vs Disturbed:</span>
                            <span style="color: #2e8b57; font-family: monospace; font-weight: 600;">0.001 ***</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding: 4px 0;">
                            <span style="color: #888;">Grassland vs Disturbed:</span>
                            <span style="color: #ccc; font-family: monospace;">0.045 *</span>
                        </div>
                    </div>
                </div>

                <div style="display: flex; flex-direction: column; gap: 8px; margin-top: 20px;">
                    <button style="padding: 10px 16px; background: #2d2d30; border: 1px solid #3e3e42; color: #ccc; cursor: pointer; font-size: 12px; text-align: left;">📋 Copy All Results</button>
                    <button style="padding: 10px 16px; background: #2d2d30; border: 1px solid #3e3e42; color: #ccc; cursor: pointer; font-size: 12px; text-align: left;">💾 Export Results (CSV)</button>
                    <button style="padding: 10px 16px; background: #2d2d30; border: 1px solid #3e3e42; color: #ccc; cursor: pointer; font-size: 12px; text-align: left;">📄 Generate Report (PDF)</button>
                </div>
            </div>
        </div>
    `;
}
