# Auto-generated by EclipseNSIS Script Wizard
# Sep 25, 2013 4:18:18 PM

Name "Peercoin Armory"

# General Symbol Definitions
!define REGKEY "SOFTWARE\$(^Name)"
!define COMPANY "Armory Technologies Inc."
!define URL http://bitcoinarmory.com/

# MultiUser Symbol Definitions
!define MULTIUSER_EXECUTIONLEVEL Highest
!define MULTIUSER_INSTALLMODE_COMMANDLINE
!define MULTIUSER_INSTALLMODE_INSTDIR Armory
!define MULTIUSER_INSTALLMODE_INSTDIR_REGISTRY_KEY "${REGKEY}"
!define MULTIUSER_INSTALLMODE_INSTDIR_REGISTRY_VALUE "Path"

# MUI Symbol Definitions
!define MUI_ICON img\armory48x48.ico
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULTFOLDER Armory
!define MUI_FINISHPAGE_RUN $INSTDIR\ArmoryQt.exe
!define MUI_UNICON img\armory48x48.ico
!define MUI_UNFINISHPAGE_NOAUTOCLOSE

# Included files
!include MultiUser.nsh
!include Sections.nsh
!include MUI2.nsh
!include CompilerArgs.nsi

# Reserved Files
ReserveFile "${NSISDIR}\Plugins\x86-ansi\StartMenu.dll"

# Variables
Var StartMenuGroup

# Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE LICENSE
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuGroup
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Installer languages
!insertmacro MUI_LANGUAGE English

# Installer attributes
# Default to -testing to match 90% of builds.  Manually change actual releases
OutFile armory_${VERSION}-testing_winAll.exe
InstallDir "$PROGRAMFILES\Armory"
CRCCheck on
XPStyle on
Icon img\armory48x48.ico
ShowInstDetails show
AutoCloseWindow true
LicenseData LICENSE
VIProductVersion "${VERSION}"
VIAddVersionKey ProductName "Bitcoin Armory"
VIAddVersionKey ProductVersion "${VERSION}"
VIAddVersionKey CompanyName "${COMPANY}"
VIAddVersionKey CompanyWebsite "${URL}"
VIAddVersionKey FileVersion "${VERSION}"
VIAddVersionKey FileDescription ""
VIAddVersionKey LegalCopyright ""
InstallDirRegKey HKLM "${REGKEY}" Path
UninstallIcon img\armory48x48.ico
ShowUninstDetails show

# Installer sections
# Macro for creating a registry key
!define HKEY_CLASSES_ROOT 0xffffffff80000000
!define HKEY_CURRENT_USER 0xffffffff80000001
!define HKEY_LOCAL_MACHINE 0xffffffff80000002
!define HKEY_USERS 0xffffffff80000003
!define HKEY_PERFORMANCE_DATA 0xffffffff80000004
!define HKEY_CURRENT_CONFIG 0xffffffff80000005
!define HKEY_DYN_DATA 0xffffffff80000006
!define KEY_CREATE_SUB_KEY 0x0004
!macro CreateRegKey ROOT_KEY SUB_KEY
    Push $0
    Push $1
    System::Call /NOUNLOAD "Advapi32::RegCreateKeyExA(i, t, i, t, i, i, i, *i, i) i(${ROOT_KEY}, '${SUB_KEY}', 0, '', 0, ${KEY_CREATE_SUB_KEY}, 0, .r0, 0) .r1"
    StrCmp $1 0 +2
    SetErrors
    StrCmp $0 0 +2
    System::Call /NOUNLOAD "Advapi32::RegCloseKey(i) i(r0) .r1"
    System::Free 0
    Pop $1
    Pop $0
!macroend

!macro CREATE_SMGROUP_SHORTCUT NAME PATH ARGS
    Push "${ARGS}"
    Push "${NAME}"
    Push "${PATH}"
    Call CreateSMGroupShortcut
!macroend

Section -Main SEC0000
    SetOutPath $INSTDIR
    RmDir /r $INSTDIR
    SetOverwrite on
    File /r ArmoryStandalone\*
    File ArmoryStandalone\ArmoryQt.exe
    !insertmacro CreateRegKey ${HKEY_CURRENT_USER} "Software\Armory"
    SetOutPath $DESKTOP
    CreateShortcut "$DESKTOP\Bitcoin Armory.lnk" $INSTDIR\ArmoryQt.exe
    !insertmacro CREATE_SMGROUP_SHORTCUT "Bitcoin Armory" "$INSTDIR\ArmoryQt.exe" ""
    !insertmacro CREATE_SMGROUP_SHORTCUT "Bitcoin Armory (Offline)" "$INSTDIR\ArmoryQt.exe" "--offline"
    !insertmacro CREATE_SMGROUP_SHORTCUT "Bitcoin Armory (testnet)" "$INSTDIR\ArmoryQt.exe" "--testnet"
    WriteRegStr HKLM "${REGKEY}\Components" Main 1
SectionEnd

Section -post SEC0001
    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Uninstall $(^Name).lnk" $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_END
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayVersion "${VERSION}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "${COMPANY}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1
SectionEnd

# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKLM "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}
next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"
done${UNSECTION_ID}:
    Pop $R0
!macroend

# Uninstaller sections
!macro DELETE_SMGROUP_SHORTCUT NAME
    Push "${NAME}"
    Call un.DeleteSMGroupShortcut
!macroend

Section /o -un.Main UNSEC0000
    !insertmacro DELETE_SMGROUP_SHORTCUT "Bitcoin Armory (testnet)"
    !insertmacro DELETE_SMGROUP_SHORTCUT "Bitcoin Armory (Offline)"
    !insertmacro DELETE_SMGROUP_SHORTCUT "Bitcoin Armory"
    Delete /REBOOTOK "$DESKTOP\Bitcoin Armory.lnk"
    DeleteRegKey /IfEmpty HKEY_CURRENT_USER "Software\Armory"
    Delete /REBOOTOK $INSTDIR\ArmoryQt.exe
    RmDir /r /REBOOTOK $INSTDIR
    DeleteRegValue HKLM "${REGKEY}\Components" Main
SectionEnd

Section -un.post UNSEC0001
    DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Uninstall $(^Name).lnk"
    Delete /REBOOTOK $INSTDIR\uninstall.exe
    DeleteRegValue HKLM "${REGKEY}" StartMenuGroup
    DeleteRegValue HKLM "${REGKEY}" Path
    DeleteRegKey /IfEmpty HKLM "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKLM "${REGKEY}"
    RmDir /r /REBOOTOK $SMPROGRAMS\$StartMenuGroup
    RmDir /r /REBOOTOK $INSTDIR
    Push $R0
    StrCpy $R0 $StartMenuGroup 1
    StrCmp $R0 ">" no_smgroup
no_smgroup:
    Pop $R0
SectionEnd

# Installer functions
Function .onInit
    InitPluginsDir
    !insertmacro MULTIUSER_INIT
FunctionEnd

Function CreateSMGroupShortcut
    Exch $R0 ;PATH
    Exch
    Exch $R1 ;NAME
    Exch 2
    Exch $R3
    Push $R2
    StrCpy $R2 $StartMenuGroup 1
    StrCmp $R2 ">" no_smgroup
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$R1.lnk" $R0 $R3
no_smgroup:
    Pop $R2
    Pop $R1
    Pop $R0
FunctionEnd

# Uninstaller functions
Function un.onInit
    ReadRegStr $INSTDIR HKLM "${REGKEY}" Path
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuGroup
    !insertmacro MULTIUSER_UNINIT
    !insertmacro SELECT_UNSECTION Main ${UNSEC0000}
FunctionEnd

Function un.DeleteSMGroupShortcut
    Exch $R1 ;NAME
    Push $R2
    StrCpy $R2 $StartMenuGroup 1
    StrCmp $R2 ">" no_smgroup
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\$R1.lnk"
no_smgroup:
    Pop $R2
    Pop $R1
FunctionEnd

