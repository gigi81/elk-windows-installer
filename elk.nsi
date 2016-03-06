; ELK (elasticsearch - logstash - kibana) windows installer nsis script
; Copyright (c) 2016 Luigi Grilli
;
; basic script template for NSIS installers
;
; Written by Philip Chu
; Copyright (c) 2004-2005 Technicat, LLC
;
; This software is provided 'as-is', without any express or implied warranty.
; In no event will the authors be held liable for any damages arising from the use of this software.
 
; Permission is granted to anyone to use this software for any purpose,
; including commercial applications, and to alter it ; and redistribute
; it freely, subject to the following restrictions:
 
;    1. The origin of this software must not be misrepresented; you must not claim that
;       you wrote the original software. If you use this software in a product, an
;       acknowledgment in the product documentation would be appreciated but is not required.
 
;    2. Altered source versions must be plainly marked as such, and must not be
;       misrepresented as being the original software.
 
;    3. This notice may not be removed or altered from any source distribution.

; include for some of the windows messages defines
!include "winmessages.nsh"

!include Sections.nsh
!include LogicLib.nsh

; HKLM (all users) vs HKCU (current user) defines
!define env_hklm 'HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'
!define env_hkcu 'HKCU "Environment"'

;version is passed as a parameter during makensis invocation
!define setup "dist\elk-x64-${version}.exe"
 
; change this to wherever the files to be packaged reside
!define srcdir "temp"
 
!define company "Elasticsearch"
 
!define prodname "ELK"
 
; optional stuff
 
; Set the text which prompts the user to enter the installation directory
; DirText "My Description Here."
 
; text file to open in notepad after installation
!define notefile "elasticsearch\README.textile"
 
; license text file
!define licensefile elasticsearch\license.txt
 
; icons must be Microsoft .ICO files
; !define icon "icon.ico"
 
; installer background screen
; !define screenimage background.bmp
 
; file containing list of file-installation commands
; !define files "files.nsi"
 
; file containing list of file-uninstall commands
; !define unfiles "unfiles.nsi"
 
; registry stuff
 
!define regkey "Software\${company}\${prodname}"
!define uninstkey "Software\Microsoft\Windows\CurrentVersion\Uninstall\${prodname}"
 
!define startmenu "$SMPROGRAMS\${company}\${prodname}"
!define uninstaller "uninstall.exe"

;-------------------------------- 
XPStyle on
ShowInstDetails hide
ShowUninstDetails hide
 
Name "${prodname}"
Caption "${prodname}"
 
!ifdef icon
Icon "${icon}"
!endif
 
OutFile "${setup}"
 
SetDateSave on
SetDatablockOptimize on
CRCCheck on
SilentInstall normal
 
InstallDir "C:\Elk"
InstallDirRegKey HKLM "${regkey}" ""
 
!ifdef licensefile
LicenseText "License"
LicenseData "${srcdir}\${licensefile}"
!endif
 
; pages
; we keep it simple - leave out selectable installation types
 
!ifdef licensefile
Page license
!endif
 
; Page components
Page components
Page directory
Page instfiles
 
UninstPage uninstConfirm
UninstPage instfiles
 
;--------------------------------
 
AutoCloseWindow false
ShowInstDetails show
 
 
!ifdef screenimage
 
; set up background image
; uses BgImage plugin
 
Function .onGUIInit
	; extract background BMP into temp plugin directory
	InitPluginsDir
	File /oname=$PLUGINSDIR\1.bmp "${screenimage}"
 
	BgImage::SetBg /NOUNLOAD /FILLSCREEN $PLUGINSDIR\1.bmp
	BgImage::Redraw /NOUNLOAD
FunctionEnd
 
Function .onGUIEnd
	; Destroy must not have /NOUNLOAD so NSIS will be able to unload and delete BgImage before it exits
	BgImage::Destroy
FunctionEnd
 
!endif

; beginning (invisible) section
Section
  ClearErrors
  SetRegView 64
  ReadRegStr $1 HKLM "SOFTWARE\JavaSoft\Java Development Kit" "CurrentVersion"
  ReadRegStr $2 HKLM "SOFTWARE\JavaSoft\Java Development Kit\$1" "JavaHome"
  DetailPrint "$1 $2"
  
  IfErrors 0 NoAbort
    MessageBox MB_OK "Couldn't find a Java Development Kit installed. Setup will exit now." 
    Quit
   
  NoAbort:
    DetailPrint "Found JDK in path $2"
    StrCpy $R0 "$2"
    System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("JAVA_HOME", R0).r0'

  ; set environment variable
  WriteRegExpandStr ${env_hklm} JAVA_HOME $R0
  ; make sure windows knows about the change
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000   

  WriteRegStr HKLM "${regkey}" "Install_Dir" "$INSTDIR"
  ; write uninstall strings
  WriteRegStr HKLM "${uninstkey}" "DisplayName" "${prodname} (remove only)"
  WriteRegStr HKLM "${uninstkey}" "UninstallString" '"$INSTDIR\${uninstaller}"'
 
!ifdef filetype
  WriteRegStr HKCR "${filetype}" "" "${prodname}"
!endif
 
!ifdef icon
  WriteRegStr HKCR "${prodname}\DefaultIcon" "" "$INSTDIR\${icon}"
!endif
 
  SetOutPath $INSTDIR
 
; package all files, recursively, preserving attributes
; assume files are in the correct places
 
!ifdef licensefile
  File /a "${srcdir}\${licensefile}"
!endif
 
!ifdef notefile
  File /a "${srcdir}\${notefile}"
!endif
 
!ifdef icon
  File /a "${srcdir}\${icon}"
!endif

  SetOutPath $INSTDIR\nssm
  File /r "tools\nssm\*"

  SetOutPath $INSTDIR\scripts
  File /r "scripts\*"
  
  WriteUninstaller "${uninstaller}"
SectionEnd
  
Section "Elasticsearch" Elasticsearch
  SetOutPath $INSTDIR\elasticsearch
  File /r "${srcdir}\elasticsearch\*"
  
  ; install elasticsearch service
  ExecWait "$INSTDIR\elasticsearch\bin\service.bat install" $0
  ; set service to start automatically (delayed)
  ExecWait "sc config elasticsearch-service-x64 start=delayed-auto" $0
  
  StrCpy $R0 "$INSTDIR"
  System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("INSTDIR", R0).r0'
  StrCpy $R0 "$INSTDIR\nssm\win64\nssm.exe"
  System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("NSSM", R0).r0'
  
  ; start services
  ExecWait "net start elasticsearch-service-x64" $0
SectionEnd

Section "Logstash" Logstash
  SetOutPath $INSTDIR\logstash
  File /r "${srcdir}\logstash\*"
  
  SetOutPath $INSTDIR\logstash\conf
  File /r "conf\logstash\*"

  ExecWait "$INSTDIR\scripts\logstash-install.bat" $0
  ExecWait "net start logstash" $0
SectionEnd

Section "Kibana" Kibana
  SetOutPath $INSTDIR\kibana
  File /r "${srcdir}\kibana\*"

  ExecWait "$INSTDIR\scripts\kibana-install.bat" $0
  ExecWait "net start kibana" $0
SectionEnd

Section "Marvel (requires elasticsearch, kibana)" Marvel
  ExecWait "$INSTDIR\scripts\marvel-install.bat" $0
SectionEnd

Section "Sense (requires kibana)" Sense
  ExecWait "$INSTDIR\scripts\sense-install.bat" $0
SectionEnd

Function .onSelChange
${If} ${SectionIsSelected} ${Elasticsearch}
  ${If} ${SectionIsSelected} ${Kibana}
    !insertmacro ClearSectionFlag ${Marvel} ${SF_RO}
  ${Else}
    !insertmacro UnselectSection ${Marvel}
    !insertmacro SetSectionFlag ${Marvel} ${SF_RO}
  ${EndIf}
${Else}
  !insertmacro UnselectSection ${Marvel}
  !insertmacro SetSectionFlag ${Marvel} ${SF_RO}
${EndIf}

${IfNot} ${SectionIsSelected} ${Kibana}
  !insertmacro UnselectSection ${Sense}
  !insertmacro SetSectionFlag ${Sense} ${SF_RO}
${Else}
  !insertmacro ClearSectionFlag ${Sense} ${SF_RO}
${EndIf}
FunctionEnd

; Uninstaller
; All section names prefixed by "Un" will be in the uninstaller
 
UninstallText "This will uninstall ${prodname}."
 
!ifdef icon
UninstallIcon "${icon}"
!endif
 
Section "Uninstall"

  ; stop services
  ExecWait "net stop kibana"
  ExecWait "net stop logstash"
  ExecWait "net stop elasticsearch-service-x64"

  StrCpy $R0 "$INSTDIR"
  System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("INSTDIR", R0).r0'
  StrCpy $R0 "$INSTDIR\nssm\win64\nssm.exe"
  System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("NSSM", R0).r0'
  
  ExecWait "$INSTDIR\scripts\logstash-uninstall.bat" $0
  ExecWait "$INSTDIR\scripts\kibana-uninstall.bat" $0

  ; uninstall elasticsearch service
  ExecWait "$INSTDIR\elasticsearch\bin\service.bat remove"  

  DeleteRegKey HKLM "${uninstkey}"
  DeleteRegKey HKLM "${regkey}"
 
  RmDir /r "$INSTDIR"

SectionEnd
