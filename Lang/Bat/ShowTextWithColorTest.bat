@REM call ShowTextWithColor.bat ShowTextWithColor.bat Test.

@echo off
SETLOCAL EnableDelayedExpansion

call ShowTextWithColor.bat 0x0a "blue"
echo.
call ShowTextWithColor.bat 0x0C "green"
echo.
call ShowTextWithColor.bat 0x0b "red"
echo.
call ShowTextWithColor.bat 0x19 "yellow"
echo.
call ShowTextWithColor.bat 0x2F "black"
echo.
call ShowTextWithColor.bat 0x4e "white"
echo.

ENDLOCAL