// Settings page navigation
// Handles switching between different settings sections using the existing sidebar

function showSettingsSection(sectionId) {
  console.log('Switching to settings section:', sectionId);
  
  // Hide all settings sections
  const sections = document.querySelectorAll('.settings-section');
  sections.forEach(section => {
    section.style.display = 'none';
  });
  
  // Show the selected section
  const targetSection = document.getElementById('settings-' + sectionId);
  if (targetSection) {
    targetSection.style.display = 'block';
  }
}

// Dark/Light Theme Toggle
function toggleTheme(theme) {
  console.log('toggleTheme called with:', theme);
  const body = document.body;
  const root = document.documentElement;
  
  // Normalize theme to lowercase for comparison
  const normalizedTheme = theme ? theme.toLowerCase() : 'dark';
  
  if (normalizedTheme === 'dark') {
    console.log('Applying dark theme...');
    body.classList.remove('light-theme');
    body.classList.add('dark-theme');
    
    // Remove all inline styles to let CSS take over
    body.style.backgroundColor = '';
    body.style.color = '';
    
    // Set CSS custom properties for dark theme
    root.style.setProperty('--bg-primary', '#1e1e1e');
    root.style.setProperty('--bg-secondary', '#252526');
    root.style.setProperty('--text-primary', '#cccccc');
    root.style.setProperty('--text-secondary', '#888888');
    
    // Clear all inline styles from major elements
    const elementsToReset = document.querySelectorAll('.titlebar, .activity-bar, .sidebar, .main-content, .tab-content, .footer, .card, .tab');
    elementsToReset.forEach(el => {
      el.style.backgroundColor = '';
      el.style.color = '';
      el.style.border = '';
      el.style.borderBottom = '';
      el.style.borderRight = '';
      el.style.borderTop = '';
    });
    
    // Update Shiny input
    if (typeof Shiny !== 'undefined') {
      Shiny.setInputValue('settings_theme', 'dark');
    }
    
    console.log('Dark theme restored - all inline styles cleared');
  } else if (normalizedTheme === 'light') {
    console.log('Applying light theme...');
    body.classList.remove('dark-theme');
    body.classList.add('light-theme');
    
    // Set CSS custom properties for light theme
    root.style.setProperty('--bg-primary', '#ffffff');
    root.style.setProperty('--bg-secondary', '#f5f5f5');
    root.style.setProperty('--text-primary', '#1e1e1e');
    root.style.setProperty('--text-secondary', '#4a4a4a');
    
    // Directly modify body background
    body.style.backgroundColor = '#ffffff';
    body.style.color = '#1e1e1e';
    
    // ===== TITLEBAR =====
    const titlebar = document.querySelector('.titlebar');
    if (titlebar) {
      titlebar.style.backgroundColor = '#f3f3f3';
      titlebar.style.borderBottom = '1px solid #d0d0d0';
      titlebar.style.color = '#1e1e1e';
    }
    
    const appTitle = document.querySelector('.app-title');
    if (appTitle) {
      appTitle.style.color = '#1e1e1e';
    }
    
    const statusBadge = document.querySelector('.status-badge');
    if (statusBadge) {
      statusBadge.style.color = '#2e8b57';
    }
    
    // ===== ACTIVITY BAR (Left icon bar) =====
    const activityBar = document.querySelector('.activity-bar');
    if (activityBar) {
      activityBar.style.backgroundColor = '#e8e8e8';
      activityBar.style.borderRight = '1px solid #d0d0d0';
    }
    
    const activityItems = document.querySelectorAll('.activity-item');
    activityItems.forEach(item => {
      item.style.color = '#4a4a4a';
    });
    
    // ===== SIDEBAR =====
    const sidebar = document.querySelector('.sidebar');
    if (sidebar) {
      sidebar.style.backgroundColor = '#f5f5f5';
      sidebar.style.borderRight = '1px solid #d0d0d0';
      sidebar.style.color = '#1e1e1e';
    }
    
    // ===== MAIN CONTENT =====
    const mainContent = document.querySelector('.main-content');
    if (mainContent) {
      mainContent.style.backgroundColor = '#ffffff';
      mainContent.style.color = '#1e1e1e';
    }
    
    // ===== TABS =====
    const tabContents = document.querySelectorAll('.tab-content');
    tabContents.forEach(tab => {
      tab.style.backgroundColor = '#ffffff';
      tab.style.color = '#1e1e1e';
    });
    
    const tabs = document.querySelectorAll('.tab');
    tabs.forEach(tab => {
      tab.style.backgroundColor = '#f5f5f5';
      tab.style.color = '#4a4a4a';
      tab.style.borderBottom = '1px solid #d0d0d0';
    });
    
    // ===== FOOTER =====
    const footer = document.querySelector('.footer, footer');
    if (footer) {
      footer.style.backgroundColor = '#f3f3f3';
      footer.style.borderTop = '1px solid #d0d0d0';
      footer.style.color = '#4a4a4a';
    }
    
    // Make all cards light
    const cards = document.querySelectorAll('.card');
    cards.forEach(card => {
      card.style.backgroundColor = '#f9f9f9';
      card.style.color = '#1e1e1e';
      card.style.border = '1px solid #e0e0e0';
    });
    
    // Update all headings for better contrast
    const headings = document.querySelectorAll('h1, h2, h3, h4, h5, h6');
    headings.forEach(heading => {
      heading.style.color = '#1e1e1e';
    });
    
    // Update all paragraphs
    const paragraphs = document.querySelectorAll('p');
    paragraphs.forEach(p => {
      const currentColor = p.style.color;
      if (currentColor && (currentColor.includes('#888') || currentColor.includes('#666') || currentColor.includes('#ccc'))) {
        p.style.color = '#4a4a4a';
      }
    });
    
    // Update form controls - including dropdowns
    const inputs = document.querySelectorAll('input, select, textarea');
    inputs.forEach(input => {
      input.style.backgroundColor = '#ffffff !important';
      input.style.color = '#1e1e1e !important';
      input.style.border = '1px solid #d0d0d0 !important';
    });
    
    // Force update ALL select dropdowns
    const selects = document.querySelectorAll('select');
    selects.forEach(select => {
      select.style.setProperty('background-color', '#ffffff', 'important');
      select.style.setProperty('color', '#1e1e1e', 'important');
      select.style.setProperty('border', '1px solid #d0d0d0', 'important');
    });
    
    // Update buttons
    const buttons = document.querySelectorAll('button, .btn');
    buttons.forEach(button => {
      // Don't change green action buttons
      if (!button.style.backgroundColor || !button.style.backgroundColor.includes('46, 139, 87')) {
        button.style.backgroundColor = '#f0f0f0';
        button.style.color = '#1e1e1e';
        button.style.border = '1px solid #d0d0d0';
      }
    });
    
    // Update section headers
    const sectionHeaders = document.querySelectorAll('.section-header');
    sectionHeaders.forEach(header => {
      header.style.backgroundColor = '#f0f0f0';
      header.style.color = '#1e1e1e';
    });
    
    // Update sidebar items
    const items = document.querySelectorAll('.item');
    items.forEach(item => {
      item.style.color = '#1e1e1e';
    });
    
    // Update results panels
    const resultsPanels = document.querySelectorAll('.results-panel, .results-section');
    resultsPanels.forEach(panel => {
      panel.style.backgroundColor = '#f9f9f9';
      panel.style.color = '#1e1e1e';
      panel.style.border = '1px solid #e0e0e0';
    });
    
    // Update ALL divs with dark backgrounds - AGGRESSIVE MODE
    const allDivs = document.querySelectorAll('div');
    allDivs.forEach(div => {
      const computedBg = window.getComputedStyle(div).backgroundColor;
      const inlineBg = div.style.backgroundColor;
      
      // Check both computed and inline styles
      const bgToCheck = inlineBg || computedBg;
      
      // Convert ANY dark background to light
      if (bgToCheck && (
        bgToCheck.includes('30, 30, 30') || 
        bgToCheck.includes('37, 37, 38') || 
        bgToCheck.includes('45, 45, 48') ||
        bgToCheck.includes('51, 51, 51') ||
        bgToCheck.includes('33, 33, 33') ||
        bgToCheck.includes('40, 40, 40') ||
        bgToCheck.includes('#1e1e1e') ||
        bgToCheck.includes('#252526') ||
        bgToCheck.includes('#2d2d30') ||
        bgToCheck.includes('#333333') ||
        bgToCheck.includes('#282828') ||
        bgToCheck.includes('rgba(0, 0, 0') ||
        bgToCheck.includes('rgb(30, 30, 30)') ||
        bgToCheck.includes('rgb(37, 37, 38)') ||
        bgToCheck.includes('rgb(45, 45, 48)') ||
        bgToCheck.includes('rgb(51, 51, 51)') ||
        bgToCheck.includes('rgb(33, 33, 33)') ||
        bgToCheck.includes('rgb(40, 40, 40)')
      )) {
        div.style.backgroundColor = '#ffffff';
        div.style.color = '#1e1e1e';
        if (!div.style.border) {
          div.style.border = '1px solid #e0e0e0';
        }
      }
    });
    
    // Update workflow containers specifically
    const workflows = document.querySelectorAll(
      '.diversity-estimation-workflow, .nmds-workflow, .pca-workflow, ' +
      '.diversity-indices-workflow, .beta-partition-workflow, ' +
      '.permanova-workflow, .anosim-workflow, .mantel-workflow'
    );
    workflows.forEach(wf => {
      wf.style.backgroundColor = '#ffffff';
      wf.style.color = '#1e1e1e';
    });
    
    // Update config panels, results sections
    const panels = document.querySelectorAll(
      '.config-panel, .results-section, .customization-panel, ' +
      '.settings-section, .help-section'
    );
    panels.forEach(panel => {
      panel.style.backgroundColor = '#f9f9f9';
      panel.style.color = '#1e1e1e';
      panel.style.border = '1px solid #e0e0e0';
    });
    
    // Update labels for better contrast
    const labels = document.querySelectorAll('label');
    labels.forEach(label => {
      const currentColor = label.style.color;
      if (currentColor && (currentColor.includes('#888') || currentColor.includes('#999') || currentColor.includes('#aaa'))) {
        label.style.color = '#4a4a4a';
      }
    });
    
    // Update spans with gray text
    const spans = document.querySelectorAll('span');
    spans.forEach(span => {
      const currentColor = span.style.color;
      if (currentColor && (currentColor.includes('#888') || currentColor.includes('#666') || currentColor.includes('#ccc'))) {
        span.style.color = '#4a4a4a';
      }
    });
    
    console.log('Enterprise-grade light theme applied with complete coverage');
    
    // Update Shiny input
    if (typeof Shiny !== 'undefined') {
      Shiny.setInputValue('settings_theme', 'light');
    }
  }
  
  console.log('Theme toggle complete. Body classes:', body.className);
  
  // Force a reflow to ensure styles are applied
  void document.body.offsetHeight;
}

// Font Size Adjustment
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

// Reset Zoom
function resetZoom() {
  console.log('Resetting zoom');
  const root = document.documentElement;
  root.style.fontSize = '14px';
  
  // Update Shiny slider if it exists
  if (typeof Shiny !== 'undefined') {
    Shiny.setInputValue('settings_zoom', 100);
  }
}

// Initialize settings page
$(document).ready(function() {
  console.log('Settings navigation initialized');
  
  // Show appearance section by default
  showSettingsSection('appearance');
  
  // Listen for theme changes from Shiny
  if (typeof Shiny !== 'undefined') {
    Shiny.addCustomMessageHandler('applyTheme', function(theme) {
      console.log('Applying theme from Shiny:', theme);
      toggleTheme(theme);
    });
    
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
