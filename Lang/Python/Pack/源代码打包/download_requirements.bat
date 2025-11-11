@echo off

setlocal
set VENV_ACTIVATE_SCRIPT=.\venv\Scripts\activate.bat
set DOWNLOAD_LOCAL_PATH=.\downloads

@REM 系统开启代理后`pip download`可能会失败，设置环境变量，cmd也使用环境变量。
set HTTP_PROXY=http://127.0.0.1:6789
set HTTPS_PROXY=http://127.0.0.1:6789

call %VENV_ACTIVATE_SCRIPT%
if %ERRORLEVEL% neq 0 (
    echo [ERR] Call "%VENV_ACTIVATE_SCRIPT%" error!
    goto:ERR
)

@REM 搜集以来项。
pip freeze > requirements.txt
if %ERRORLEVEL% neq 0 (
    echo [ERR] Create requirements.txt error!
    goto:ERR
)

@REM 下载依赖到本地。
pip download -r requirements.txt -d %DOWNLOAD_LOCAL_PATH%
if %ERRORLEVEL% neq 0 (
    goto:ERR
) else (
    echo [INFO] Download requirements -^> "%DOWNLOAD_LOCAL_PATH%"
)

endlocal
:OK
@REM pause
exit 0

:ERR
echo [ERR] Download requirements error!
pause
exit 1