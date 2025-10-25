// Auto-save functionality
let autoSaveInterval = null;
let isDirty = false;

function enableAutoSave() {
  // Mark data as changed
  isDirty = true;
  
  // Auto-save every 30 seconds
  if (!autoSaveInterval) {
    autoSaveInterval = setInterval(function() {
      if (isDirty) {
        const timestamp = new Date().toISOString();
        localStorage.setItem("ordin-autosave-timestamp", timestamp);
        isDirty = false;
        
        // Show subtle notification
        const notification = document.getElementById("autosave-indicator");
        if (notification) {
          notification.style.opacity = "1";
          setTimeout(() => { notification.style.opacity = "0"; }, 2000);
        }
      }
    }, 30000); // 30 seconds
  }
}

// Keyboard shortcuts
document.addEventListener("keydown", function(e) {
  // Ctrl+O: Open file dialog
  if (e.ctrlKey && e.key === "o") {
    e.preventDefault();
    const fileInput = document.getElementById("dataFile");
    if (fileInput) fileInput.click();
  }
  
  // Ctrl+S: Save/Export results
  if (e.ctrlKey && e.key === "s") {
    e.preventDefault();
    const downloadBtn = document.querySelector(".btn-success[id*=download]");
    if (downloadBtn) downloadBtn.click();
  }
  
  // Ctrl+T: Toggle theme
  if (e.ctrlKey && e.key === "t") {
    e.preventDefault();
    toggleTheme();
  }
  
  // Ctrl+1/2/3: Switch tabs
  if (e.ctrlKey && ["1", "2", "3"].includes(e.key)) {
    e.preventDefault();
    const tabs = document.querySelectorAll(".nav-link");
    const index = parseInt(e.key) - 1;
    if (tabs[index]) tabs[index].click();
  }
  
  // F1: Help
  if (e.key === "F1") {
    e.preventDefault();
    const helpTab = document.querySelector(".nav-link[data-value='Help']");
    if (helpTab) helpTab.click();
  }
});

// Theme toggle functionality (for Ctrl+T shortcut)
function toggleTheme() {
  const body = document.body;
  const currentTheme = body.classList.contains("light-theme") ? "light" : "dark";
  const newTheme = currentTheme === "dark" ? "light" : "dark";
  
  // Toggle CSS class
  if (newTheme === "light") {
    body.classList.add("light-theme");
    body.classList.remove("dark-theme");
  } else {
    body.classList.add("dark-theme");
    body.classList.remove("light-theme");
  }
  
  localStorage.setItem("ordin-theme", newTheme);
  
  // Update theme selector in settings
  const themeSelector = document.getElementById("themeSelector");
  if (themeSelector) {
    themeSelector.value = newTheme;
  }
}

// Handle theme change from settings dropdown
function handleThemeChange(theme) {
  const body = document.body;
  
  if (theme === "auto") {
    // Use system preference
    const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
    theme = prefersDark ? "dark" : "light";
  }
  
  if (theme === "light") {
    body.classList.add("light-theme");
    body.classList.remove("dark-theme");
  } else {
    body.classList.add("dark-theme");
    body.classList.remove("light-theme");
  }
  
  localStorage.setItem("ordin-theme", theme);
  
  // Send to Shiny
  Shiny.setInputValue("settingsTheme", theme);
}

// Handle font size change
function handleFontSizeChange(size) {
  const body = document.body;
  body.classList.remove("font-small", "font-medium", "font-large");
  body.classList.add("font-" + size);
  localStorage.setItem("ordin-font-size", size);
  Shiny.setInputValue("settingsFontSize", size);
}

// Save settings to localStorage when changed
function saveSettingToLocalStorage(key, value) {
  localStorage.setItem("ordin-" + key, value);
}

// Toggle settings sidebar
function toggleSettingsSidebar() {
  const sidebar = document.getElementById("settings-sidebar");
  const overlay = document.getElementById("settings-overlay");
  const isOpen = sidebar.style.right === "0px";
  
  if (isOpen) {
    // Close sidebar
    sidebar.style.right = "-400px";
    overlay.style.display = "none";
    overlay.style.opacity = "0";
    document.body.style.overflow = "auto";
  } else {
    // Open sidebar
    sidebar.style.right = "0px";
    overlay.style.display = "block";
    setTimeout(() => { overlay.style.opacity = "1"; }, 10);
    document.body.style.overflow = "hidden";
  }
}

// Activity bar navigation
function switchView(view) {
  // Remove active class from all activity items
  var activityItems = document.querySelectorAll('.activity-item');
  for (var i = 0; i < activityItems.length; i++) {
    activityItems[i].classList.remove('active');
  }
  
  // Add active class to clicked item
  var activeItem = document.querySelector('.activity-item[data-view="' + view + '"]');
  if (activeItem) {
    activeItem.classList.add('active');
  }
  
  // Hide all content sections
  var contentSections = document.querySelectorAll('.content-section');
  for (var i = 0; i < contentSections.length; i++) {
    contentSections[i].style.display = 'none';
  }
  
  // Show the selected section
  var selectedSection = document.getElementById(view + '-section');
  if (selectedSection) {
    selectedSection.style.display = 'block';
  }
  
  // Update main nav if needed
  Shiny.setInputValue('main_nav', view.charAt(0).toUpperCase() + view.slice(1).replace(/-/g, ' '));
}

// Toggle sidebar visibility
function toggleSidebar() {
  var sidebar = document.querySelector('.primary-sidebar');
  var mainContent = document.querySelector('.main-content');
  
  if (sidebar && mainContent) {
    sidebar.classList.toggle('collapsed');
    mainContent.classList.toggle('sidebar-collapsed');
  }
}

// Initialize activity bar
document.addEventListener('DOMContentLoaded', function() {
  // Add click listeners to activity items
  var activityItems = document.querySelectorAll('.activity-item');
  for (var i = 0; i < activityItems.length; i++) {
    activityItems[i].addEventListener('click', function() {
      var view = this.getAttribute('data-view');
      switchView(view);
    });
  }
  
  // Add click listeners to sidebar section headers for collapse/expand
  var sidebarHeaders = document.querySelectorAll('.sidebar-section-header');
  for (var i = 0; i < sidebarHeaders.length; i++) {
    sidebarHeaders[i].addEventListener('click', function() {
      this.parentElement.classList.toggle('collapsed');
    });
  }
});

// Zoom functionality
let currentZoom = 100;

function zoomIn() {
  if (currentZoom < 200) {
    currentZoom += 10;
    applyZoom();
  }
}

function zoomOut() {
  if (currentZoom > 50) {
    currentZoom -= 10;
    applyZoom();
  }
}

function zoomReset() {
  currentZoom = 100;
  applyZoom();
}

function applyZoom() {
  document.body.style.zoom = currentZoom + "%";
  document.getElementById("zoom-level").textContent = currentZoom + "%";
  localStorage.setItem("ordin-zoom-level", currentZoom);
  Shiny.setInputValue("settingsZoomLevel", currentZoom);
}

// Reset all settings to defaults
function resetAllSettings() {
  // Clear localStorage
  localStorage.removeItem("ordin-theme");
  localStorage.removeItem("ordin-font-size");
  localStorage.removeItem("ordin-autosave-timestamp");
  localStorage.removeItem("ordin-zoom-level");
  localStorage.removeItem("ordin-ggplot-theme");
  localStorage.removeItem("ordin-plot-dpi");
  localStorage.removeItem("ordin-color-palette");
  
  // Reset theme to dark
  handleThemeChange("dark");
  
  // Reset font size to medium
  handleFontSizeChange("medium");
  
  // Reset zoom to 100%
  currentZoom = 100;
  applyZoom();
  
  // Reset toggles
  document.getElementById("autoSaveToggle").checked = true;
  document.getElementById("notificationsToggle").checked = true;
  
  // Reset selects
  document.getElementById("themeSelector").value = "dark";
  document.getElementById("fontSizeSelector").value = "medium";
  document.getElementById("exportFormatSelector").value = "csv";
  document.getElementById("decimalPrecisionSelector").value = "3";
  document.getElementById("ggplotThemeSelector").value = "minimal";
  document.getElementById("plotDpiSelector").value = "300";
  document.getElementById("colorPaletteSelector").value = "ordin";
  
  // Notify user
  alert("Settings reset to defaults!");
  
  // Notify Shiny
  Shiny.setInputValue("settingsReset", Date.now());
}

// Load saved theme on startup
document.addEventListener("DOMContentLoaded", function() {
  // Load saved theme
  const savedTheme = localStorage.getItem("ordin-theme") || "dark";
  const body = document.body;
  
  if (savedTheme === "light") {
    body.classList.add("light-theme");
    body.classList.remove("dark-theme");
  } else {
    body.classList.add("dark-theme");
    body.classList.remove("light-theme");
  }
  
  // Load saved font size
  const savedFontSize = localStorage.getItem("ordin-font-size") || "medium";
  body.classList.add("font-" + savedFontSize);
  
  // Load saved zoom level
  const savedZoom = localStorage.getItem("ordin-zoom-level");
  if (savedZoom) {
    currentZoom = parseInt(savedZoom);
    document.body.style.zoom = currentZoom + "%";
    const zoomElement = document.getElementById("zoom-level");
    if (zoomElement) {
      zoomElement.textContent = currentZoom + "%";
    }
  }
  
  // Load settings into dropdown (with delay to ensure elements exist)
  setTimeout(function() {
    const themeSelector = document.getElementById("themeSelector");
    if (themeSelector) themeSelector.value = savedTheme;
    
    const fontSizeSelector = document.getElementById("fontSizeSelector");
    if (fontSizeSelector) fontSizeSelector.value = savedFontSize;
    
    // Load other settings from localStorage
    const autoSaveEnabled = localStorage.getItem("ordin-autosave-enabled");
    if (autoSaveEnabled !== null) {
      const toggle = document.getElementById("autoSaveToggle");
      if (toggle) toggle.checked = autoSaveEnabled === "true";
    }
    
    const notificationsEnabled = localStorage.getItem("ordin-notifications-enabled");
    if (notificationsEnabled !== null) {
      const toggle = document.getElementById("notificationsToggle");
      if (toggle) toggle.checked = notificationsEnabled === "true";
    }
    
    const exportFormat = localStorage.getItem("ordin-export-format");
    if (exportFormat) {
      const selector = document.getElementById("exportFormatSelector");
      if (selector) selector.value = exportFormat;
    }
    
    const decimalPrecision = localStorage.getItem("ordin-decimal-precision");
    if (decimalPrecision) {
      const selector = document.getElementById("decimalPrecisionSelector");
      if (selector) selector.value = decimalPrecision;
    }
    
    // Load plot settings
    const ggplotTheme = localStorage.getItem("ordin-ggplot-theme");
    if (ggplotTheme) {
      const selector = document.getElementById("ggplotThemeSelector");
      if (selector) selector.value = ggplotTheme;
    }
    
    const plotDpi = localStorage.getItem("ordin-plot-dpi");
    if (plotDpi) {
      const selector = document.getElementById("plotDpiSelector");
      if (selector) selector.value = plotDpi;
    }
    
    const colorPalette = localStorage.getItem("ordin-color-palette");
    if (colorPalette) {
      const selector = document.getElementById("colorPaletteSelector");
      if (selector) selector.value = colorPalette;
    }
    
    // Load global publication quality toggle
    const globalPubQuality = localStorage.getItem("ordin-global-pub-quality");
    if (globalPubQuality !== null) {
      const toggle = document.getElementById("globalPubQuality");
      if (toggle) toggle.checked = globalPubQuality === "true";
    }
    
    const globalPlotTheme = localStorage.getItem("ordin-global-plot-theme");
    if (globalPlotTheme) {
      const selector = document.getElementById("globalPlotTheme");
      if (selector) selector.value = globalPlotTheme;
    }
  }, 500);
  
  // Set window title to just "Ördin"
  document.title = "Ördin";
  
  // Initialize auto-save indicator
  const navbar = document.querySelector(".navbar");
  if (navbar && !document.getElementById("autosave-indicator")) {
    const indicator = document.createElement("div");
    indicator.id = "autosave-indicator";
    indicator.style.cssText = "position: fixed; top: 10px; right: 70px; background: #2e8b57; color: white; padding: 5px 12px; border-radius: 3px; font-size: 0.75rem; opacity: 0; transition: opacity 0.3s; z-index: 9999;";
    indicator.innerHTML = "💾 Auto-saved";
    document.body.appendChild(indicator);
  }
});
