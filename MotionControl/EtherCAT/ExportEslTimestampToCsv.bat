@REM %1: pcap文件
@REM %2: csv文件
@echo off

if "%1"=="" (
    echo [ERR] Invalid parameter, please specify the pcap file!
    goto:ERR
)
if "%2"=="" (
    echo [ERR] Invalid parameter, please specify the csv file!
    goto:ERR
)

setlocal
set TSHARK="D:\Program Files\Wireshark\tshark.exe"

if not exist %TSHARK% (
    echo [ERR] File not exist, %TSHARK%!
    goto:ERR
)

if not exist %1 (
    echo [ERR] File not exist, %1!
    goto:ERR
)

%TSHARK% -r %1 -Y "(eth.type == 0x88a4) && (ecat.cnt == 0)" -n -T fields -e esl.timestamp > %2
endlocal

:OK
goto:EOF

:ERR
@REM set ERRORLEVEL=1
goto:EOF