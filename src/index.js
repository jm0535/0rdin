const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');
const { spawn } = require('child_process');
const axios = require('axios');

// Handle creating/removing shortcuts on Windows when installing/uninstalling
if (require('electron-squirrel-startup')) {
  app.quit();
}

let mainWindow;
let splashWindow;
let rShinyProcess;
const SHINY_PORT = 9033;
const SHINY_HOST = '127.0.0.1';

// Function to find R executable
function getRPath() {
  const platform = process.platform;
  const fs = require('fs');
  let rPath;
  
  if (platform === 'win32') {
    // Windows - try portable R first, then system R
    const rWinPath = path.join(__dirname, '..', 'r-win', 'R-Portable', 'App', 'R-Portable', 'bin', 'R.exe');
    
    if (fs.existsSync(rWinPath)) {
      rPath = rWinPath;
    } else {
      // Try common system R locations
      const systemRPaths = [
        'C:\\Program Files\\R\\R-4.5.1\\bin\\R.exe',
        'C:\\Program Files\\R\\R-4.4.1\\bin\\R.exe',
        'C:\\Program Files\\R\\R-4.3.3\\bin\\R.exe',
        'C:\\Program Files\\R\\R-4.2.3\\bin\\R.exe',
      ];
      
      for (const testPath of systemRPaths) {
        if (fs.existsSync(testPath)) {
          rPath = testPath;
          console.log(`Found R at: ${rPath}`);
          break;
        }
      }
      
      // Fallback to 'R' command
      if (!rPath) {
        rPath = 'R';
      }
    }
  } else if (platform === 'darwin') {
    // macOS
    const rMacPath = path.join(__dirname, '..', 'r-mac', 'bin', 'R');
    rPath = rMacPath;
  } else {
    // Linux (including WSL)
    rPath = 'R';  // Use system R from PATH
  }
  
  return rPath;
}

// Function to start R Shiny server
function startShiny() {
  return new Promise((resolve, reject) => {
    const rPath = getRPath();
    const scriptPath = path.join(__dirname, 'start-shiny.R');
    
    console.log('Starting R Shiny server...');
    console.log('R Path:', rPath);
    console.log('Script Path:', scriptPath);
    
    rShinyProcess = spawn(rPath, ['--vanilla', '-f', scriptPath], {
      cwd: path.join(__dirname, '..'),
      env: process.env
    });
    
    rShinyProcess.stdout.on('data', (data) => {
      console.log(`R stdout: ${data}`);
      if (data.toString().includes('Listening on')) {
        console.log('Shiny server started successfully');
        resolve();
      }
    });
    
    rShinyProcess.stderr.on('data', (data) => {
      console.error(`R stderr: ${data}`);
    });
    
    rShinyProcess.on('error', (error) => {
      console.error('Failed to start R process:', error);
      reject(error);
    });
    
    rShinyProcess.on('close', (code) => {
      console.log(`R process exited with code ${code}`);
    });
    
    // Timeout fallback
    setTimeout(() => {
      checkShinyReady().then(resolve).catch(reject);
    }, 5000);
  });
}

// Function to check if Shiny server is ready
async function checkShinyReady(maxAttempts = 30, interval = 1000) {
  for (let i = 0; i < maxAttempts; i++) {
    try {
      await axios.get(`http://${SHINY_HOST}:${SHINY_PORT}`);
      console.log('Shiny server is ready');
      return true;
    } catch (error) {
      console.log(`Waiting for Shiny server... (attempt ${i + 1}/${maxAttempts})`);
      await new Promise(resolve => setTimeout(resolve, interval));
    }
  }
  throw new Error('Shiny server failed to start');
}

// Function to create splash screen
function createSplashScreen() {
  splashWindow = new BrowserWindow({
    width: 500,
    height: 400,
    frame: false,
    transparent: true,
    alwaysOnTop: true,
    center: true,
    resizable: false,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true
    }
  });
  
  // Create splash screen HTML
  const splashHTML = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <style>
        * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
        }
        body {
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', sans-serif;
          background: transparent;
          display: flex;
          align-items: center;
          justify-content: center;
          height: 100vh;
          overflow: hidden;
        }
        .splash-container {
          background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
          border-radius: 20px;
          padding: 60px 40px;
          text-align: center;
          box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
          border: 2px solid #333;
          width: 100%;
          height: 100%;
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
        }
        .logo {
          font-size: 120px;
          color: #2e8b57;
          font-weight: bold;
          margin-bottom: 20px;
          text-shadow: 0 4px 12px rgba(46, 139, 87, 0.4);
          animation: pulse 2s ease-in-out infinite;
        }
        .app-name {
          font-size: 32px;
          color: #2e8b57;
          font-weight: 600;
          margin-bottom: 10px;
          letter-spacing: 1px;
        }
        .tagline {
          font-size: 14px;
          color: #aaa;
          margin-bottom: 40px;
          font-weight: 400;
        }
        .loading-container {
          width: 100%;
          max-width: 300px;
          margin-top: 20px;
        }
        .loading-bar {
          width: 100%;
          height: 4px;
          background: #333;
          border-radius: 2px;
          overflow: hidden;
          position: relative;
        }
        .loading-bar::before {
          content: '';
          position: absolute;
          left: -50%;
          width: 50%;
          height: 100%;
          background: linear-gradient(90deg, transparent, #2e8b57, transparent);
          animation: loading 1.5s ease-in-out infinite;
        }
        .loading-text {
          margin-top: 15px;
          font-size: 13px;
          color: #888;
          font-weight: 400;
        }
        .status-dot {
          display: inline-block;
          width: 8px;
          height: 8px;
          border-radius: 50%;
          background: #2e8b57;
          margin-right: 8px;
          animation: blink 1s ease-in-out infinite;
        }
        .version {
          position: absolute;
          bottom: 20px;
          font-size: 11px;
          color: #666;
        }
        @keyframes pulse {
          0%, 100% { transform: scale(1); }
          50% { transform: scale(1.05); }
        }
        @keyframes loading {
          0% { left: -50%; }
          100% { left: 100%; }
        }
        @keyframes blink {
          0%, 100% { opacity: 1; }
          50% { opacity: 0.3; }
        }
      </style>
    </head>
    <body>
      <div class="splash-container">
        <div class="logo">Ö</div>
        <div class="app-name">Ördin</div>
        <div class="tagline">Biodiversity Analysis Platform</div>
        <div class="loading-container">
          <div class="loading-bar"></div>
          <div class="loading-text">
            <span class="status-dot"></span>
            <span id="status">Initializing...</span>
          </div>
        </div>
        <div class="version">Version 3.0</div>
      </div>
      <script>
        const statusMessages = [
          'Initializing...',
          'Loading R environment...',
          'Starting Shiny server...',
          'Preparing analysis tools...',
          'Almost ready...'
        ];
        let currentStatus = 0;
        
        setInterval(() => {
          currentStatus = (currentStatus + 1) % statusMessages.length;
          document.getElementById('status').textContent = statusMessages[currentStatus];
        }, 2000);
      </script>
    </body>
    </html>
  `;
  
  splashWindow.loadURL(`data:text/html;charset=utf-8,${encodeURIComponent(splashHTML)}`);
  
  // Remove menu bar
  splashWindow.setMenuBarVisibility(false);
}

// Function to close splash screen
function closeSplashScreen() {
  if (splashWindow) {
    splashWindow.close();
    splashWindow = null;
  }
}

// Function to create the main window
function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1400,
    height: 900,
    title: 'Ördin',
    icon: path.join(__dirname, '..', 'build', 'icon.png'),
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      enableRemoteModule: false
    },
    backgroundColor: '#222222',
    show: false,  // Don't show until ready
    autoHideMenuBar: true  // Automatically hide menu bar
  });
  
  // Completely remove the menu bar
  mainWindow.setMenuBarVisibility(false);
  mainWindow.removeMenu();
  
  // Load the Shiny app
  mainWindow.loadURL(`http://${SHINY_HOST}:${SHINY_PORT}`);
  
  // Show window when ready and close splash screen
  mainWindow.once('ready-to-show', () => {
    setTimeout(() => {
      closeSplashScreen();
      mainWindow.show();
      mainWindow.focus();
    }, 500);  // Small delay for smooth transition
  });
  
  // Open DevTools in development mode
  if (process.env.NODE_ENV === 'development') {
    mainWindow.webContents.openDevTools();
  }
  
  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

// Handle window controls from custom title bar
ipcMain.on('window-minimize', () => {
  if (mainWindow) mainWindow.minimize();
});

ipcMain.on('window-maximize', () => {
  if (mainWindow) {
    if (mainWindow.isMaximized()) {
      mainWindow.unmaximize();
    } else {
      mainWindow.maximize();
    }
  }
});

ipcMain.on('window-close', () => {
  if (mainWindow) mainWindow.close();
});

// App lifecycle
app.on('ready', async () => {
  try {
    // Show splash screen immediately
    createSplashScreen();
    
    // Start Shiny server in background
    await startShiny();
    
    // Create main window (hidden initially)
    createWindow();
  } catch (error) {
    console.error('Failed to start application:', error);
    closeSplashScreen();
    app.quit();
  }
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});

app.on('will-quit', () => {
  // Kill R Shiny process
  if (rShinyProcess) {
    console.log('Stopping R Shiny server...');
    rShinyProcess.kill();
  }
});

// Handle uncaught exceptions
process.on('uncaughtException', (error) => {
  console.error('Uncaught exception:', error);
});
