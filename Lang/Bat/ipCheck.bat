@REM Encode: UTF-8.
@REM 查看同一网段下使用的IP.

@echo off
setlocal

@REM 设置为utf-8编码.
chcp 65001
@REM 设置终端窗口的名称.
title "IP Search"

set /a Online=0
set /a Offline=0
set /a Total=256
set OutFile=IPSearch.txt

if exist %OutFile% del %OutFile%

set StartTime=%time%

@REM 找到第一个IPV4地址，也可不进行查找，设置为固定IPV4地址。
@REM set IP=192.168.1.28
for /f "delims=: tokens=2" %%i in ('ipconfig ^| find /i "IPv4 Address"') do (set IP=%%i)

if "%IP%"=="" echo "no connection!" & pause & goto :EOF
if "%IP%"=="0.0.0.0" echo "no connection!" & pause & goto :EOF

for /f "delims=. tokens=1,2,3,4" %%i in ("%IP%") do (
    set /a IP1=%%i
    set /a IP2=%%j
    set /a IP3=%%k
    set /a IP4=%%l
)

set /a IP4=0
echo "Online IP:" >> %OutFile%

:RETRY
ping %IP1%.%IP2%.%IP3%.%IP4% -n 1 -w 200 -l 16 >nul && set /a Online+=1 && echo %IP1%.%IP2%.%IP3%.%IP4% >>%OutFile% || set /a Offline+=1

<nul set /p ="#" 
@REM set a=^set /p =#%b%
@REM set /a Scanned=%Online%+%Offline%
@REM set /a Progress=(%Online%+%Offline%)*100/%Total%
@REM <nul set /p =Scaning: %Scanned%/%Total% Scan Progress: %Progress%%%

set /a IP4+=1
if %IP4% lss %Total% goto :RETRY

echo.
echo.

set EndTime=%time%

set /a Seconds = %EndTime:~6,2% - %StartTime:~6,2%
set /a Minutes = %EndTime:~3,2% - %StartTime:~3,2%
if %Seconds% lss 0 set /a Seconds+=60 & set /a Minutes-=1
if %Minutes% lss 0 set /a Minutes+=60

set /a Percent=%Online% * 100 / (%Online% + %Offline%)

echo "Online:" %Online%
echo "Offline:" %Offline%
echo "Online Percent:" %Percent%%%
echo "Cost Time:" %Minutes%minutes%Seconds%seconds
echo "Date:" %date% %time:~0,-3%
echo.>>%OutFile%
echo "Online IP Count:" %Online%>>%OutFile%
echo "Offline IP Count:" %Offline%>>%OutFile%
echo "Online Percent:" %Percent%%%>>%OutFile%
echo "Cost Time:" %Minutes%minutes%Search%secondes>>%OutFile%
echo "Date:" %date% %time:~0,3%>>%OutFile%
echo "Save to file:" %OutFile%
pause

endlocal