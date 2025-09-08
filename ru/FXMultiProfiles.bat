@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

:: --- Ваши настройки (Все настройки тут: https://github.com/citizenfx/txAdmin/blob/master/docs/env-config.md)---
set TXHOST_DATA_PATH=%~dp0txData

:MainMenu
cls
for /f %%a in ('"prompt $E & for %%b in (1) do rem"') do set "ESC=%%a"

echo.%ESC%[92m
echo  _____  ____  __     _ _  _ ___        __ _ _
echo ^| __\ \/ /  \/  ^|_  _^| ^| ^|_(_) _ \_ _ ___ / _(_) ^|___ ___
echo ^| _^| ^>  ^<^| ^|\/^| ^| ^|^| ^| ^|  _^| ^|  _/ '_/ _ \  _^| ^| / -_^|_-^<
echo ^|_^| /_/\_\_^|  ^|_^|\_,_^|_^|\__^|_^| ^|_^| \___/_^| ^|_^|_\___/__/
echo.%ESC%[0m
echo.
echo              Простая утилита для управления профилями вашего сервера.
echo                                Разработано: github @dev.drozd
echo =================================================================================
echo.

set count=0
if not exist "%TXHOST_DATA_PATH%" mkdir "%TXHOST_DATA_PATH%"
for /d %%d in ("%TXHOST_DATA_PATH%/*") do (
    set /a count+=1
    set "folder[!count!]=%%~nxd"
)

if %count%==0 (
    echo У вас еще нет ни одного профиля сервера. Давайте создадим первый!
    goto CreateNew
)

echo Доступные профили серверов:
echo -------------------------------------------------
for /l %%i in (1, 1, %count%) do (
    echo    %%i. !folder[%%i]!
)
echo.
echo    0. [Создать новый профиль]
echo -------------------------------------------------
echo.

:AskForChoice
set "choice="
set /p choice="Введите номер профиля (или 0 для создания) и нажмите ENTER: "

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
    echo Выбран профиль: !selectedProfile!
    call :SelectPort
    goto LaunchServer
)

echo.
echo %ESC%[91mОшибка: Такого номера нет в списке.%ESC%[0m
timeout /t 2 /nobreak > nul
goto MainMenu


:CreateNew
echo.
:AskForNameLoop
set "newProfileName="
set /p newProfileName="Введите имя для нового профиля (латиница и цифры, без пробелов): "

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
    echo %ESC%[91mОшибка: Имя содержит запрещённые символы.%ESC%[0m
    goto AskForNameLoop
)

for /l %%i in (1, 1, !count!) do (
    if /i "!folder[%%i]!"=="!newProfileName!" (
        echo.
        echo %ESC%[91mОшибка: Профиль с таким именем уже существует.%ESC%[0m
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
set /p userPort="Введите порт для txAdmin (нажмите ENTER для 40120): "

if not defined userPort goto :eof

set /a numeric_port=%userPort% 2>nul

if %numeric_port% LSS 1 (
    echo.
    echo %ESC%[91mОшибка: Порт должен быть числом от 1 до 65535.%ESC%[0m
    goto AskForPortLoop
)

if %numeric_port% GTR 65535 (
    echo.
    echo %ESC%[91mОшибка: Порт должен быть числом от 1 до 65535.%ESC%[0m
    goto AskForPortLoop
)

set "TXHOST_TXA_PORT=!userPort!"
echo Порт !userPort! установлен.
goto :eof


:LaunchServer
call "%~dp0artifact\FXServer.exe" +set serverProfile "!selectedProfile!"

:EndScript
echo --- Скрипт завершил работу ---
pause
endlocal
