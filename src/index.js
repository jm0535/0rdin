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
const SHINY_PORT = 9054;
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
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
          background: #0a0a0a;
          display: flex;
          align-items: center;
          justify-content: center;
          height: 100vh;
          overflow: hidden;
        }
        .splash-container {
          text-align: center;
          position: relative;
        }
        .logo-container {
          position: relative;
          display: inline-block;
          margin-bottom: 40px;
        }
        .logo {
          font-size: 180px;
          color: #2e8b57;
          font-weight: 300;
          letter-spacing: -8px;
          line-height: 1;
          animation: fadeInScale 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards;
          opacity: 0;
        }
        .logo-glow {
          position: absolute;
          top: 50%;
          left: 50%;
          transform: translate(-50%, -50%);
          width: 200px;
          height: 200px;
          background: radial-gradient(circle, rgba(46, 139, 87, 0.2) 0%, transparent 70%);
          border-radius: 50%;
          animation: pulse 3s ease-in-out infinite;
        }
        .app-name {
          font-size: 42px;
          color: #ffffff;
          font-weight: 200;
          letter-spacing: 12px;
          margin-bottom: 12px;
          animation: fadeInUp 0.8s cubic-bezier(0.16, 1, 0.3, 1) 0.2s forwards;
          opacity: 0;
        }
        .tagline {
          font-size: 13px;
          color: #666;
          font-weight: 400;
          letter-spacing: 2px;
          text-transform: uppercase;
          margin-bottom: 60px;
          animation: fadeInUp 0.8s cubic-bezier(0.16, 1, 0.3, 1) 0.3s forwards;
          opacity: 0;
        }
        .loading-container {
          width: 280px;
          margin: 0 auto;
          animation: fadeInUp 0.8s cubic-bezier(0.16, 1, 0.3, 1) 0.4s forwards;
          opacity: 0;
        }
        .loading-bar-bg {
          width: 100%;
          height: 2px;
          background: #1a1a1a;
          border-radius: 2px;
          overflow: hidden;
          position: relative;
        }
        .loading-bar {
          height: 100%;
          background: linear-gradient(90deg, #2e8b57 0%, #3fa869 100%);
          width: 0%;
          animation: loadProgress 2s ease-out forwards;
          box-shadow: 0 0 10px rgba(46, 139, 87, 0.5);
        }
        .loading-text {
          margin-top: 20px;
          font-size: 11px;
          color: #444;
          font-weight: 400;
          letter-spacing: 1px;
          text-align: center;
        }
        @keyframes fadeInScale {
          from {
            opacity: 0;
            transform: scale(0.8);
          }
          to {
            opacity: 1;
            transform: scale(1);
          }
        }
        @keyframes fadeInUp {
          from {
            opacity: 0;
            transform: translateY(20px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
        @keyframes pulse {
          0%, 100% {
            opacity: 0.4;
            transform: translate(-50%, -50%) scale(1);
          }
          50% {
            opacity: 0.6;
            transform: translate(-50%, -50%) scale(1.1);
          }
        }
        @keyframes loadProgress {
          0% { width: 0%; }
          50% { width: 70%; }
          100% { width: 100%; }
        }
      </style>
    </head>
    <body>
      <div class="splash-container">
        <div class="logo-container">
          <div class="logo-glow"></div>
          <div class="logo">Ö</div>
        </div>
        <div class="app-name">ÖRDIN</div>
        <div class="tagline">Community Ecology Analysis Platform</div>
        <div class="loading-container">
          <div class="loading-bar-bg">
            <div class="loading-bar"></div>
          </div>
          <div class="loading-text">INITIALIZING</div>
        </div>
      </div>
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
    frame: false,  // Remove OS title bar to use custom title bar
    icon: path.join(__dirname, '..', 'build', 'icon.png'),
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      enableRemoteModule: false,
      preload: path.join(__dirname, 'preload.js'),
      webSecurity: true
    },
    backgroundColor: '#222222',
    show: true,  // SHOW IMMEDIATELY - removed delay
    autoHideMenuBar: true  // Automatically hide menu bar
  });
  
  // Completely remove the menu bar
  mainWindow.setMenuBarVisibility(false);
  mainWindow.removeMenu();
  
  // Set Content Security Policy
  mainWindow.webContents.session.webRequest.onHeadersReceived((details, callback) => {
    callback({
      responseHeaders: {
        ...details.responseHeaders,
        'Content-Security-Policy': [
          "default-src 'self' 'unsafe-inline' 'unsafe-eval' http://127.0.0.1:* ws://127.0.0.1:* data: blob:;"
        ]
      }
    });
  });
  
  // Load the Shiny app
  console.log(`Loading URL: http://${SHINY_HOST}:${SHINY_PORT}`);
  mainWindow.loadURL(`http://${SHINY_HOST}:${SHINY_PORT}`);
  
  // Close splash screen after a short delay
  setTimeout(() => {
    closeSplashScreen();
  }, 2000);
  
  // DevTools disabled for production - uncomment next line for debugging:
  // mainWindow.webContents.openDevTools();
  
  // Log when content loads
  mainWindow.webContents.on('did-finish-load', () => {
    console.log('Main window content loaded successfully');
  });
  
  mainWindow.webContents.on('did-fail-load', (event, errorCode, errorDescription) => {
    console.error('Failed to load:', errorCode, errorDescription);
  });
  
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
