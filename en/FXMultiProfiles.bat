@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

:: --- Your Settings (All settings here: https://github.com/citizenfx/txAdmin/blob/master/docs/env-config.md)---
set TXHOST_DATA_PATH=%~dp0txData

:MainMenu
cls
for /f %%a in ('"prompt $E & for %%b in (1) do rem"') do set "ESC=%%a"

echo.%ESC%[92m
echo    _____  ____  __      _ _   _ ___          __ _ _        
echo   ^| __\ \/ /  \/  ^|_  _^| ^| ^|_(_) _ \_ _ ___ / _(_) ^|___ ___
echo   ^| _^| ^>  ^<^| ^|\/^| ^| ^|^| ^| ^|  _^| ^|  _/ '_/ _ \  _^| ^| / -_^|_-^<
echo   ^|_^| /_/\_\_^|  ^|_^|\_,_^|_^|\__^|_^|_^| ^|_^| \___/_^| ^|_^|_\___/__/
echo.%ESC%[0m
echo.
echo              A simple utility for managing your server profiles.
echo                                Developed by: github @dev.drozd
echo =================================================================================
echo.

set count=0
if not exist "%TXHOST_DATA_PATH%" mkdir "%TXHOST_DATA_PATH%"
for /d %%d in ("%TXHOST_DATA_PATH%/*") do (
    set /a count+=1
    set "folder[!count!]=%%~nxd"
)

if %count%==0 (
    echo You don't have any server profiles yet. Let's create the first one!
    goto CreateNew
)

echo Available server profiles:
echo -------------------------------------------------
for /l %%i in (1, 1, %count%) do (
    echo    %%i. !folder[%%i]!
)
echo.
echo    0. [Create a new profile]
echo -------------------------------------------------
echo.

:AskForChoice
set "choice="
set /p choice="Enter the profile number (or 0 to create) and press ENTER: "

if not defined choice (
    goto MainMenu
)

if "%choice%"=="0" (
    goto CreateNew
)

set /a numeric_choice=%choice% 2>nul

if %numeric_choice% GEQ 1 if %numeric_choice% LEQ %count% (
    set "selectedProfile=!folder[%numeric_choice%]!"
    echo.
    echo Selected profile: !selectedProfile!
    call :SelectPort
    goto LaunchServer
)

echo.
echo %ESC%[91mError: This number is not in the list.%ESC%[0m
timeout /t 2 /nobreak > nul
goto MainMenu


:CreateNew
echo.
:AskForNameLoop
set "newProfileName="
set /p newProfileName="Enter a name for the new profile (letters and numbers, no spaces): "

if not defined newProfileName goto MainMenu
echo.

set "validationResult=0"
for /l %%i in (0,1,127) do (
    set "ch=!newProfileName:~%%i,1!"
    if "!ch!"=="" goto CheckDone
    for /f "delims=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" %%A in ("!ch!") do (
        set "validationResult=1"
        goto CheckDone
    )
)
:CheckDone

if "!validationResult!"=="1" (
    echo.
    echo %ESC%[91mError: The name contains forbidden characters.%ESC%[0m
    goto AskForNameLoop
)

for /l %%i in (1, 1, !count!) do (
    if /i "!folder[%%i]!"=="!newProfileName!" (
        echo.
        echo %ESC%[91mError: A profile with this name already exists.%ESC%[0m
        goto AskForNameLoop
    )
)


call :SelectPort
set "selectedProfile=!newProfileName!"
goto LaunchServer

:SelectPort
echo.
:AskForPortLoop
set "userPort="
set /p userPort="Enter the txAdmin port (press ENTER for 40120): "

if not defined userPort goto :eof

set /a numeric_port=%userPort% 2>nul

if %numeric_port% LSS 1 (
    echo.
    echo %ESC%[91mError: Port must be a number between 1 and 65535.%ESC%[0m
    goto AskForPortLoop
)

if %numeric_port% GTR 65535 (
    echo.
    echo %ESC%[91mError: Port must be a number between 1 and 65535.%ESC%[0m
    goto AskForPortLoop
)

set "TXHOST_TXA_PORT=!userPort!"
echo Port !userPort! has been set.
goto :eof


:LaunchServer
call "%~dp0artifact\FXServer.exe" +set serverProfile "!selectedProfile!"

:EndScript
echo --- Script finished ---
pause
endlocal
