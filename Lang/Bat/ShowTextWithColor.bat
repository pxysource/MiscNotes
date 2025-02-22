@REM 以指定的颜色显示字符串。
@REM See color command.
@REM 0a "blue"
@REM 0C "green"
@REM 0b "red"
@REM 19 "yellow"
@REM 2F "black"
@REM 4e "white"
@REM 调用示例 <Batfile.bat> <HexColorValue> <String>
@REM 注意：字符串中有特殊符号，打印不正确。字符串结尾含有"."。
@REM       只支持普通的字符串。
@REM       字符串请用引号括起来。

@echo off
SETLOCAL EnableDelayedExpansion

for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
set "DEL=%%a"
)
@REM echo say the name of the colors, don't read

set colorString=%~1
IF NOT %colorString:~0,2% == 0x (
    echo "Parameter 1 error."
    echo "Usage: <batFile> <color> <string>. Color like 0x01, see color command."
    exit /b 1
)

set /a colorValue=%colorString%

IF %colorValue% GTR 0xFF (
    echo "Parameter 1 value error. See color command."
    exit /b 2 
)

set colorString=%colorString:~2%
call :ColorText %colorString% %2
goto :eof

:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" >nul 2>&1
goto :eof


ENDLOCAL