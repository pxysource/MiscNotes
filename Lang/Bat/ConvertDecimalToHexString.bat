@REM Convert decimal value to hexadecimal value.
@REM Param1: Decimal value.
@REM Return value: Hexadecimal value string.
:CrtDecToHexStr
@echo off
@SETLOCAL EnableDelayedExpansion

set /a decimalValue=%~1
set HexNumberString=0123456789abcdef
set tempStr=

:Loop
IF %decimalValue% GEQ 16 (
    set /a quotient=%decimalValue% / 16
    set /a remainder=%decimalValue% %% 16
    set /a decimalValue=!quotient!
    set /a Done=0
) ELSE (
    set /a Done=1
)

@REM IF后边的执行语句为一条语句，注意使用!进行展开。
IF %Done% EQU 0 (
    set tempStr1=!HexNumberString:~%remainder%,1!
    set tempStr=!tempStr1!!tempStr!
    goto :Loop
) ELSE (
    set tempStr1=!HexNumberString:~%decimalValue%,1!
    set tempStr=!tempStr1!!tempStr!
)

<nul set /p ="0x%tempStr%" >CrtDecToHexStrRtnValue.txt
ENDLOCAL

FOR /F "tokens=*" %%i IN (CrtDecToHexStrRtnValue.txt) DO (set CrtDecToHexStrRtnValue=%%~i)
del CrtDecToHexStrRtnValue.txt >nul 2>&1
goto :eof
