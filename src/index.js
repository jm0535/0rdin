const path = require('path');
const { spawn } = require('child_process');
const axios = require('axios');
const { app, BrowserWindow, ipcMain, dialog } = require('electron');
const log = require('electron-log');

// Configure logging
log.transports.file.level = 'info';
log.transports.console.level = 'info';
// Optionally, redirect console to electron-log
// console.log = log.log;
// console.error = log.error;

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
    // When packaged, use process.resourcesPath to get correct resources folder
    // Fix for packaged app path resolution issue
    let baseDir;
    if (app.isPackaged) {
      // In packaged app, resources are in process.resourcesPath, not inside app.asar
      baseDir = process.resourcesPath;
    } else {
      // In development, use __dirname
      baseDir = path.join(__dirname, '..');
    }
    // Use Rscript.exe for packaged (we use -e flag), R.exe for dev
    const rExeName = app.isPackaged ? 'Rscript.exe' : 'R.exe';
    const rWinPath = path.join(baseDir, 'r-win', 'R-Portable', 'App', 'R-Portable', 'R-4.5.1', 'bin', rExeName);

    log.info('Checking for R at:', rWinPath);

    if (fs.existsSync(rWinPath)) {
      rPath = rWinPath;
      log.info('Found bundled R!');
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
          log.info(`Found R at: ${rPath}`);
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
    // Use correct paths for packaged app
    // Fix for packaged app path resolution issue
    let baseDir;
    if (app.isPackaged) {
      // In packaged app, resources are in process.resourcesPath, not inside app.asar
      baseDir = process.resourcesPath;
    } else {
      // In development, use __dirname
      baseDir = path.join(__dirname, '..');
    }
    const shinyDir = path.join(baseDir, 'shiny');

    log.info('Starting R Shiny server...');
    log.info('R Path:', rPath);
    log.info('Shiny Dir:', shinyDir);

    // For packaged app, run shiny directly with Rscript
    // For dev, use start-shiny.R script
    let rArgs;
    let rCwd;

    if (app.isPackaged) {
      // Packaged: run app.R directly from shiny folder
      rArgs = ['--vanilla', '-e', `shiny::runApp(port=${SHINY_PORT}, host='${SHINY_HOST}', launch.browser=FALSE)`];
      rCwd = shinyDir;
      log.info('Running packaged mode');
    } else {
      // Development: use start-shiny.R
      const scriptPath = path.join(__dirname, 'start-shiny.R');
      rArgs = ['--vanilla', '-f', scriptPath];
      rCwd = path.join(__dirname, '..');
      log.info('Running development mode');
    }

    rShinyProcess = spawn(rPath, rArgs, {
      cwd: rCwd,
      env: process.env
    });

    // Helper to handle ready state
    const onReady = () => {
      log.info('Shiny server started successfully (detected via output)');
      resolve();
    };

    rShinyProcess.stdout.on('data', (data) => {
      log.info(`R stdout: ${data}`);
      if (data.toString().includes('Listening on')) {
        onReady();
      }
    });

    rShinyProcess.stderr.on('data', (data) => {
      log.error(`R stderr: ${data}`);
      // R Shiny often prints 'Listening on' to stderr
      if (data.toString().includes('Listening on')) {
        onReady();
      }
    });

    rShinyProcess.on('error', (error) => {
      log.error('Failed to start R process:', error);
      reject(error);
    });

    rShinyProcess.on('close', (code) => {
      log.info(`R process exited with code ${code}`);
    });

    // Timeout fallback - check if port is open after a delay
    // Increased to 10s to allow for initial R startup time
    setTimeout(() => {
      log.info('Startup timeout reached, checking connectivity...');
      checkShinyReady(5, 1000).then(() => {
        log.info('Shiny server connectivity confirmed via fallback');
        resolve();
      }).catch((err) => {
        // Don't reject yet, let the main ready loop handle it
        log.warn('Fallback check failed, but process is running. Creating window anyway to attempt load.', err);
        resolve();
      });
    }, 10000);
  });
}

// Function to check if Shiny server is ready
async function checkShinyReady(maxAttempts = 30, interval = 1000) {
  // Check if R process is still running
  if (!rShinyProcess || rShinyProcess.exitCode !== null) {
    throw new Error(`Shiny server process exited with code ${rShinyProcess ? rShinyProcess.exitCode : 'unknown'}`);
  }

  for (let i = 0; i < maxAttempts; i++) {
    // Double check process status before every attempt
    if (rShinyProcess.exitCode !== null) {
      throw new Error(`Shiny server process exited unexpectedly with code ${rShinyProcess.exitCode}`);
    }

    try {
      await axios.get(`http://${SHINY_HOST}:${SHINY_PORT}`, {
        timeout: 2000,
        validateStatus: status => status < 500
      });
      log.info('Shiny server is ready (HTTP 200 OK)');
      return true;
    } catch (error) {
      log.info(`Waiting for Shiny server... (attempt ${i + 1}/${maxAttempts}) - ${error.message}`);
      await new Promise(resolve => setTimeout(resolve, interval));
    }
  }

  // If we got here and process is still running, check one last time
  if (rShinyProcess && rShinyProcess.exitCode === null) {
    log.info('Shiny server process is running but not responding to HTTP. Assuming ready.');
    return true;
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
          <div class="logo">\u00D6</div>
        </div>
        <div class="app-name">\u00D6RDIN</div>
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
    title: '\u00D6rdin',
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
  log.info(`Loading URL: http://${SHINY_HOST}:${SHINY_PORT}`);
  mainWindow.loadURL(`http://${SHINY_HOST}:${SHINY_PORT}`);

  // Close splash screen when main window content loads
  mainWindow.webContents.on('did-finish-load', () => {
    log.info('Main window content loaded successfully');
    closeSplashScreen();
  });

  // Fallback: Close splash screen after 5 seconds if not already closed
  setTimeout(() => {
    closeSplashScreen();
  }, 5000);

  // DevTools disabled for production - uncomment next line for debugging:
  // mainWindow.webContents.openDevTools();

  // Log when content loads
  mainWindow.webContents.on('did-finish-load', () => {
    log.info('Main window content loaded successfully');
  });

  mainWindow.webContents.on('did-fail-load', (event, errorCode, errorDescription) => {
    log.error('Failed to load:', errorCode, errorDescription);
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
    log.info('Starting Shiny server...');
    await startShiny();
    log.info('Shiny server started');

    // Create main window
    createWindow();
  } catch (error) {
    log.error('Failed to start application:', error);
    dialog.showErrorBox('Startup Error', `Failed to start \u00D6rdin:\n${error.message}\n\nCheck logs for details.`);
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
    log.info('Stopping R Shiny server...');
    rShinyProcess.kill('SIGKILL');
  }
});

// Handle uncaught exceptions
process.on('uncaughtException', (error) => {
  log.error('Uncaught exception:', error);
  dialog.showErrorBox('Unexpected Error', `An error occurred:\n${error.message}\n\nCheck logs for details.`);
});

// Handle unhandled promise rejections
process.on('unhandledRejection', (reason, promise) => {
  log.error('Unhandled Rejection at:', promise, 'reason:', reason);
  dialog.showErrorBox('Unhandled Rejection', `An unhandled promise rejection occurred:\n${reason}\n\nCheck logs for details.`);
});
