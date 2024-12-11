@echo off
REM package the project

setlocal
set SET_QT_ENV="G:\Qt\Qt5.14.2\5.14.2\mingw73_32\bin\qtenv2.bat"
set SETUP_DIR=%~dp0..\..\setup
set EXEFILE_NAME=SvarMonitor.exe
set EXEFILE_DIR=%~dp0..\..\build-SvarMonitor-Desktop_Qt_5_14_2_MinGW_32_bit-Release\release
set LIB_COMM_I6=%~dp0..\lib\i6\x86
set LIB_COMM_I7=%~dp0..\lib\i7\x86

REM Qt envoriment
call %SET_QT_ENV%
if %errorlevel% neq 0 (
   echo "Set Qt envoriment error!"
   goto err
)

cd /d %SETUP_DIR%
if %errorlevel% neq 0 (
   echo %SETUP_DIR% not exist!
   goto:err
)

copy %EXEFILE_DIR%\%EXEFILE_NAME% . /Y
if %errorlevel% neq 0 (
   echo "Copy file error!"
   goto:err
)

windeployqt.exe --no-quick-import --no-translations --no-webkit2 --no-angle --no-opengl-sw %EXEFILE_NAME%
if %errorlevel% neq 0 (
   echo "windeployqt error!"
   goto:err
)

xcopy %LIB_COMM_I6% . /s/e/y
if %errorlevel% neq 0 (
   echo "Copy lib error!"
   goto:err
)

xcopy %LIB_COMM_I7% . /s/e/y
if %errorlevel% neq 0 (
   echo "Copy lib error!"
   goto:err
)

endlocal

exit 0

:err
pause
