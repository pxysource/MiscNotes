@echo off

setlocal

set SET_QT_ENV="C:\Qt\Qt5.14.2\5.14.2\mingw73_32\bin\qtenv2.bat"
set SRC_TOP=%~dp0
set INSTALL_DIR=%SRC_TOP%\output\lua

REM Qt envoriment
call %SET_QT_ENV%
if %errorlevel% neq 0 (
   echo [ERR] Set Qt envoriment error!
   goto:ERR
)

echo [INFO] %CD%
cd /d %SRC_TOP%
echo [INFO] %CD%

mingw32-make --version > nul
if %ERRORLEVEL% neq 0 (
    echo [ERR] Please setup Qt envoriment!
    goto:ERR
)

mingw32-make clean
mingw32-make mingw
if %ERRORLEVEL% neq 0 (
    echo [ERR] Build mingw version error!
    goto:ERR
)

if not exist %INSTALL_DIR% (
    mkdir %INSTALL_DIR%
)

echo %CD%
@REM NOTE: 无法识别windows路径
mingw32-make install INSTALL_TOP=../output/lua
if %ERRORLEVEL% neq 0 (
    echo [ERR] Install error!
    goto:ERR
)

copy %SRC_TOP%\src\lua54.dll %INSTALL_DIR%\bin\

endlocal

exit 0

:ERR
pause
exit 1