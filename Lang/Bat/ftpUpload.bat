@REM Encode: UTF-8
@REM 从ftp服务器上传文件到本地

@echo off
setlocal

@REM 设置为UTF-8编码.
chcp 65001
title FtpUpload

set ip=192.168.1.88
set user=user root
set password=root
set mode=bin
set targetDir=/mmc1:2
set localDir=C:\Users\pc-2020-4-20\Desktop
set file=%*

IF "%file%" == "" (
    echo "Usage: %0 file1 file2 ... filen!"
    goto Error:
)

echo open %ip%> ftpUpload
echo %user%>> ftpUpload
echo %password%>> ftpUpload
echo %mode%>> ftpUpload
echo prompt>> ftpUpload
echo cd %targetDir%>> ftpUpload
echo pwd>> ftpUpload
echo lcd %localDir%>> ftpUpload
echo mget %file%>> ftpUpload
echo bye>> ftpUpload

ftp -n -s:ftpUpload

endlocal
exit

:Error
pause
