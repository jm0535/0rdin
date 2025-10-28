// Ördin v3.0 - Prototype Interactive Features

// Track current active view for toggle behavior
let currentView = 'home';
let currentRightPanel = null;

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
    const clickedItem = document.getElementById(`activity-${view}`);
    if (clickedItem) {
        clickedItem.classList.add('active');
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
    if (sidebarTitle) {
        sidebarTitle.textContent = titles[view] || 'EXPLORER';
    }
    
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
    if (breadcrumb) {
        breadcrumb.textContent = breadcrumbs[view] || 'Home';
    }
    
    // Update Shiny inputs
    if (typeof Shiny !== 'undefined') {
        Shiny.setInputValue('current_view', view, {priority: 'event'});
        Shiny.setInputValue('main_tabs', view, {priority: 'event'});
    }
    
    console.log(`Switched to: ${view}`);
}

// Keyboard shortcuts
document.addEventListener('keydown', function(e) {
    // Ctrl+O: Open file dialog
    if (e.ctrlKey && e.key === 'o') {
        e.preventDefault();
        const fileInput = document.getElementById('species_file');
        if (fileInput) fileInput.click();
    }
    
    // Ctrl+S: Save/Export results
    if (e.ctrlKey && e.key === 's') {
        e.preventDefault();
        const downloadBtn = document.querySelector(".btn-success[id*=download]");
        if (downloadBtn) downloadBtn.click();
    }
    
    // Ctrl+1/2/3: Switch tabs
    if (e.ctrlKey && ["1", "2", "3"].includes(e.key)) {
        e.preventDefault();
        const views = ['home', 'data', 'diversity'];
        const index = parseInt(e.key) - 1;
        if (views[index]) switchView(views[index]);
    }
    
    // F1: Help
    if (e.key === 'F1') {
        e.preventDefault();
        switchView('help');
    }
});

// Initialize on document ready
document.addEventListener('DOMContentLoaded', function() {
    // Set initial state
    const homeItem = document.getElementById('activity-home');
    if (homeItem) {
        homeItem.classList.add('active');
    }
});