@echo off

setlocal
set VENV_ACTIVATE_SCRIPT=.\venv\Scripts\activate.bat
set DOWNLOAD_LOCAL_PATH=.\downloads

call .\venv\Scripts\activate.bat
if %ERRORLEVEL% neq 0 (
    echo [ERR] Call "%VENV_ACTIVATE_SCRIPT%" error!
    goto:ERR
)

@REM 从本地目录安装依赖。
pip install --no-index --find-links=%DOWNLOAD_LOCAL_PATH% -r requirements.txt
if %ERRORLEVEL% neq 0 (
    echo [ERR] install requirements error!
    goto:ERR
) else (
    echo [INFO] Download requirements from "%DOWNLOAD_LOCAL_PATH%"
)

endlocal
:OK
@REM pause
exit 0

:ERR
echo [ERR] Setup error!
pause
exit 1