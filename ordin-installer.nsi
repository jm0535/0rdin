; Ördin Installer Script
!define APPNAME "Ördin"
!define COMPANYNAME "Ordin"
!define DESCRIPTION "A Community Ecology Analysis Platform"
!define VERSION "3.0.0"
!define INSTALLSIZE 450000

; Main Install settings
Name "${APPNAME} ${VERSION}"
InstallDir "$PROGRAMFILES\${APPNAME}"
InstallDirRegKey HKCU "Software\${APPNAME}" ""
OutFile "out\installer\${APPNAME}-${VERSION}-Setup.exe"

; Use compression
SetCompressor /SOLID LZMA

; Modern interface settings
!include "MUI2.nsh"

!define MUI_ABORTWARNING
!define MUI_UNABORTWARNING

; Icon settings
!define MUI_ICON "build\icon.ico"
!define MUI_UNICON "build\icon.ico"

; Show details by default
!define MUI_INSTFILESPAGE_PROGRESSBAR colored

; Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; Languages
!insertmacro MUI_LANGUAGE "English"

; Reserve files for faster loading
ReserveFile "${NSISDIR}\Plugins\x86-ansi\InstallOptions.dll"

; Installer section
Section "install"
  ; Set output path to the installation directory
  SetOutPath $INSTDIR
  
  ; Display progress information
  DetailPrint "Installing ${APPNAME} ${VERSION}..."
  DetailPrint "Installation directory: $INSTDIR"
  
  ; Copy main files with progress
  DetailPrint "Copying application files..."
  File /r "out\Ördin-win32-x64\*.*"
  
  ; Create uninstaller
  WriteUninstaller "$INSTDIR\uninstall.exe"
  
  ; Write to registry
  DetailPrint "Updating Windows registry..."
  WriteRegStr HKCU "Software\${APPNAME}" "" $INSTDIR
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" \
                   "DisplayName" "${APPNAME}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" \
                   "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" \
                   "DisplayIcon" "$INSTDIR\ordin.exe"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" \
                   "Publisher" "${COMPANYNAME}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" \
                   "DisplayVersion" "${VERSION}"
  WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" \
                     "EstimatedSize" ${INSTALLSIZE}
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" \
                   "Comments" "${DESCRIPTION}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" \
                   "HelpLink" "https://github.com/jm0535/0rdin"
  
  ; Create start menu shortcuts
  DetailPrint "Creating shortcuts..."
  CreateDirectory "$SMPROGRAMS\${APPNAME}"
  CreateShortCut "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk" "$INSTDIR\ordin.exe"
  CreateShortCut "$SMPROGRAMS\${APPNAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe"
  
  ; Create desktop shortcut
  CreateShortCut "$DESKTOP\${APPNAME}.lnk" "$INSTDIR\ordin.exe"
  
  DetailPrint "${APPNAME} installation completed successfully!"
SectionEnd

; Uninstaller section
Section "uninstall"
  ; Show uninstall progress
  DetailPrint "Uninstalling ${APPNAME}..."
  DetailPrint "Removing files from: $INSTDIR"
  
  ; Remove files with progress
  DetailPrint "Removing application files..."
  RMDir /r "$INSTDIR"
  
  ; Remove start menu shortcuts
  DetailPrint "Removing shortcuts..."
  RMDir /r "$SMPROGRAMS\${APPNAME}"
  
  ; Remove desktop shortcut
  Delete "$DESKTOP\${APPNAME}.lnk"
  
  ; Remove registry keys
  DetailPrint "Cleaning up registry..."
  DeleteRegKey HKCU "Software\${APPNAME}"
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
  
  DetailPrint "${APPNAME} uninstalled successfully!"
SectionEnd