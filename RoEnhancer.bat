@echo off
color 8f
title RoEnhancer - Quality Of Life Roblox Script!
mode 60,15
set d=%temp%\RoEnhancer
md %d% 2>nul >nul
cd %d%
set c=ClientAppSettings.json
@echo off
echo Getting latest Roblox version from internet..
for /f "tokens=*" %%v in ('powershell -Command "Invoke-WebRequest -Uri 'https://clientsettingscdn.roblox.com/v2/client-version/windowsplayer/channel/live' -UseBasicParsing | ConvertFrom-Json | Select-Object -ExpandProperty clientVersionUpload"') do set "v=%%v"
echo - latest version: %v%
echo Downloading theme..
powershell -command "$ProgressPreference = 'SilentlyContinue'; Start-BitsTransfer -Source "https://github.com/xf1op/roblox-menu/archive/refs/heads/main.zip" -Dynamic -Destination "$env:TEMP\RoEnhancer\theme.zip" -TransferPolicy None; Get-BitsTransfer | Remove-BitsTransfer"
echo - Success
cls
echo.
echo ---      RoEnhancer - Quality Of Life Roblox Script      ---
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Would You like to enhance your Roblox experience?		Script will close Roblox and ask you to open it again!', 'RoEnhancer - Quality Of Life Roblox Script', '4', [System.Windows.Forms.MessageBoxIcon]::Question);}" > %d%\Prompt.txt
set /p p=<%d%\prompt.txt
if %p%==No (goto ext)
echo.
echo ---               Closing Roblox Client...               ---
taskkill /f /im RobloxPlayerBeta.exe 2>nul >nul
taskkill /f /im bloxstrap.exe 2>nul >nul
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Do you want to use the most performant settings for Roblox?	It will result in lowered graphics in game!   (Cancel to exit)', 'RoEnhancer - Quality Of Life Roblox Script', '3', [System.Windows.Forms.MessageBoxIcon]::Question);}" > %d%\Prompt.txt
set /p p=<%d%\prompt.txt
if %p%==Cancel (goto ext)
echo.
echo ---              Downloading ClientSettings              ---
if %p%==Yes (powershell -command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/xf1op/ClientAppSettingsRBLX/main/FPS-FFlags.json -OutFile %D%\%c%")
if %p%==No (powershell -command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/xf1op/ClientAppSettingsRBLX/main/FPSAndQuality-FFlags.json -OutFile %D%\%c%")
echo.
echo ---           Searching If Roblox Is Installed           ---
if exist %localappdata%\bloxstrap cd %localappdata%\bloxstrap && goto bs
if exist %localappdata%\roblox\versions\%v% cd %localappdata%\roblox\versions\%v% && goto rb
if exist %ProgramFiles(x86)%\roblox\versions\%v% cd %ProgramFiles(x86)%\roblox\versions\%v% && goto rb
goto NF
:rb
echo.
echo ---           Applying New Settings To Roblox!           ---
rd ClientSettings /s /q
xcopy /s %d%\theme.zip /y >nul
tar -xf theme.zip
xcopy /s roblox-menu-main /y >nul
if '%errorlevel%'=='1' (goto AR)
rd roblox-menu-main /s /q
erase theme.zip /f 2>nul
md ClientSettings 2>nul
cd ClientSettings
copy %d%\%C% /y >nul
if '%errorlevel%'=='1' (goto AR)
echo.
echo ---      Copying New Settings To Roblox Successful!      ---
echo. & timeout 2 /nobreak >nul
goto cm
:AR
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Roblox is installed in "Program Files" folder!		Please run script as administrator to continue!', 'RoEnhancer - Quality Of Life Roblox Script', '5', [System.Windows.Forms.MessageBoxIcon]::Warning);}" > %D%\Prompt.txt
set /p p=<%D%\Prompt.txt
if %p%==Cancel (goto ext)
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Admin granted
) else (
    if not "%1"=="runAsAdmin" (
        echo Relaunching script with administrative privileges...
        powershell -Command "Start-Process '%~0' -ArgumentList 'runAsAdmin' -Verb RunAs"
        exit /b
    )
)
:NF
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Outdated Roblox version has been found!       Please reopen Roblox client and download the update!', 'RoEnhancer - Quality Of Life Roblox Script', '0', [System.Windows.Forms.MessageBoxIcon]::Error);}" >nul
goto ext
:bs
echo.
echo ---          Applying New Settings To Bloxstrap          ---
rd Modifications /s /q >nul
erase state.json /f 2>nul >nul
echo { "ShowFFlagEditorWarning": false, "PlayerVersionGuid": "%v%" } >state.json
md Modifications\ClientSettings >nul
xcopy /s %d%\theme.zip /y >nul
tar -xf theme.zip >nul
xcopy /s roblox-menu-main modifications >nul
rd roblox-menu-main /s /q >nul
erase theme.zip /f 2>nul >nul
cd Modifications\ClientSettings
copy %d%\%C% /y >nul
echo.
echo ---     Copying New Settings To Bloxtrap Successful!     ---
echo. & timeout 2 /nobreak >nul
goto cm
:cm
echo ---                Cleaning Roblox Logs..                ---
rd "%localappdata%\Roblox\logs" /s /q 2>nul >nul
rd "%localappdata%\Bloxstrap\Logs" /s /q 2>nul >nul
echo.
echo ---           Thank You For Using This Script!           ---
timeout 1 /nobreak >nul
:opr
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Do you want to open Roblox client?', 'RoEnhancer - Quality Of Life Roblox Script', '4', [System.Windows.Forms.MessageBoxIcon]::Question);}" > %D%\Prompt.txt
set /p p=<%d%\Prompt.txt
if %p%==No (goto ext)
echo.
echo ---               Opening Roblox Client..                ---
if exist %localappdata%\bloxstrap cd %localappdata%\bloxstrap && start bloxstrap.exe -player && goto ext
if exist %localappdata%\roblox\versions\%v% cd %localappdata%\roblox\versions\%v% && start RobloxPlayerBeta.exe && goto ext
if exist %ProgramFiles(x86)%\roblox\versions\%v% cd %ProgramFiles(x86)%\roblox\versions\%v% && start RobloxPlayerBeta.exe && goto ext
goto NF
:ext
echo.
echo ---                      Exiting...                      ---
cd %temp%
rd "%d%" /s /q 2>nul >nul
timeout 1 >nul
exit