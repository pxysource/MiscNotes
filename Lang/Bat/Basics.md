# 解释器：cmd

选项：

- `/A`：将内部命令输出的格式设置为管道或文件(ANSI) 。
- `/Q`：关闭echo。
- `/K`或则`/C`：执行字符串指定的命令然后终止。

# 特殊符号

## &：组合命令

```bat
echo 1 & echo 2
```

# 命令

## puase

此批处理命令提示用户并等待输入一行内容。

```bat
@echo off
pause
```

## rename

重命名

```bat
@echo off

setlocal
set oldname=template.txt
set newname=new.txt
rename %oldname% %newname%
endlocal

echo "Rename file ok."
pause
```

# 文件操作

## 检查文件是否存在 ：exist

```bat
@echo off
if exist Test.txt copy %CD%\Test.txt "C:\Users\pc-2020-4-20\Desktop\"
pause
```

## 复制文件：copy

```bat
@echo off
if exist Test.txt copy %CD%\Test.txt "C:\Users\pc-2020-4-20\Desktop\"
pause
```

## 相对路径转换为绝对路径

脚本所在路径：`C:\Users\pc-2020-4-20\Desktop\test.bat`

```bat
@echo off
set "relativePath=..\xx"
for %%i in ("%relativePath%") do (
    set "absolutePath=%%~fi"
)
echo %absolutePath%
pause
```

输出：

```
C:\Users\pc-2020-4-20\xx
请按任意键继续. . .
```

# 注册表

## 1

注册MultiProgAddIn

```bat
@echo off
setlocal
set Path=C:\Windows\Microsoft.NET\Framework\v4.0.30319
set Dir=C:\Program Files (x86)\PHOENIX CONTACT Software\MULTIPROG 5.51 Express Build 396\
regasm.exe "%Dir%MultiProgAddIn.dll"
endlocal
pause
```

# 字符串

## 移除字符串双引号

`RemoveStringQuotation.bat`

```bat
@echo off

setlocal
echo %0
echo %1
set var=%1
set "var=%var:"=%"
echo %var%

IF %1%=="test" (
echo equal
) ELSE (
echo not
)

endlocal
```

运行`.\\RemoveStringQuotation.bat "test"`：

```
RemoveStringQuotation.bat
"test"
test
equal

```

# 变量

## 预定义变量

### 当前路径：CD

脚本所在路径：`C:\Users\pc-2020-4-20\Desktop\test.bat`

```bat
@echo off
echo %CD%
pause
```

输出：

```
C:\Users\pc-2020-4-20\Desktop
请按任意键继续. . .
```

## 环境变量PATH：PATH

在`cmd`中执行`echo path`：

```cmd
echo %PATH%
```

输出：

```cmd
D:\Program Files (x86)\VMware\VMware Workstation\bin\;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Windows\System32\OpenSSH\;C:\Program Files\Git\cmd;D:\Windows Kits\10\Windows Performance Toolkit\;C:\Program Files\dotnet\;C:\Strawberry\c\bin;C:\Strawberry\perl\site\bin;C:\Strawberry\perl\bin;d:\Program Files\MVTec\HALCON-20.05-Progress\bin\x64-win64;E:\Workspace\Qt\GUI\PaintEditor\bin;C:\Users\pxy\AppData\Local\Microsoft\WindowsApps;;d:\vscode\bin;C:\Users\pxy\.dotnet\tools;d:\Program Files (x86)\Nmap;d:\Program Files\JetBrains\PyCharm Community Edition 2023.2.3\bin;;C:\Users\pxy\AppData\Local\Pandoc\
```

## 局部变量

```bat
@echo off
set var=1
echo %var%

setlocal
set a=1
echo %a%
endlocal

if defined a echo %a%
if not defined a echo "a is not defined"

pause
```

## 查看已设置的变量：set

```cmd
set
```

输出（输出中会包含环境变量）：

```cmd
ALLUSERSPROFILE=C:\ProgramData
APPDATA=C:\Users\pxy\AppData\Roaming
CLIENTNAME=DESKTOP-ETOT0PS
CommonProgramFiles=C:\Program Files\Common Files
CommonProgramFiles(x86)=C:\Program Files (x86)\Common Files
CommonProgramW6432=C:\Program Files\Common Files
COMPUTERNAME=PXY-NOTEBOOK
ComSpec=C:\Windows\system32\cmd.exe
DriverData=C:\Windows\System32\Drivers\DriverData
EFC_13048=1
FPS_BROWSER_APP_PROFILE_STRING=Internet Explorer
FPS_BROWSER_USER_PROFILE_STRING=Default
HALCONARCH=x64-win64
HALCONEXAMPLES=C:\Users\Public\Documents\MVTec\HALCON-20.05-Progress\examples
HALCONIMAGES=C:\Users\Public\Documents\MVTec\HALCON-20.05-Progress\examples\images
HALCONROOT=d:\Program Files\MVTec\HALCON-20.05-Progress
HOMEDRIVE=C:
HOMEPATH=\Users\pxy
https_proxy=http://127.0.0.1:6790
http_proxy=http://127.0.0.1:6790
IGCCSVC_DB=AQAAANCMnd8BFdERjHoAwE/Cl+sBAAAAgeo1Izga002T+YaCMwsaYAQAAAACAAAAAAAQZgAAAAEAACAAAAAhLTKQR1QdRTw2sDHvKDoZ/nNxl+dAQpWcfWVNMV5EzwAAAAAOgAAAAAIAACAAAABUhOxtn+ABZptu0MrS3wr+UnKiDIGxZ85aalQNY5seSmAAAADUPCdJhadBiIAP+4slr6VrbOCNgFNPVp4YhV2M+Gv5Ek6b+cBzOJ987G+NdrkDA+jan2o7Xu61eIzrsd2WO48ssdkgvaLngcz4/NJeasqCSLzpB2B+jZh06z7ekF01zSFAAAAAJ9WPiLdF4YWk69uS4DO93XD7ECRppi+IivPM0vmMOlWlJEgF3yIrGGuNv/Fdm9AhV6HVkvD5VEOeR4y2MG5d2w==
LOCALAPPDATA=C:\Users\pxy\AppData\Local
LOGONSERVER=\\PXY-NOTEBOOK
NUMBER_OF_PROCESSORS=20
OneDrive=C:\Users\pxy\OneDrive
OS=Windows_NT
Path=D:\Program Files (x86)\VMware\VMware Workstation\bin\;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Windows\System32\OpenSSH\;C:\Program Files\Git\cmd;D:\Windows Kits\10\Windows Performance Toolkit\;C:\Program Files\dotnet\;C:\Strawberry\c\bin;C:\Strawberry\perl\site\bin;C:\Strawberry\perl\bin;d:\Program Files\MVTec\HALCON-20.05-Progress\bin\x64-win64;E:\Workspace\Qt\GUI\PaintEditor\bin;C:\Users\pxy\AppData\Local\Microsoft\WindowsApps;;d:\vscode\bin;C:\Users\pxy\.dotnet\tools;d:\Program Files (x86)\Nmap;d:\Program Files\JetBrains\PyCharm Community Edition 2023.2.3\bin;;C:\Users\pxy\AppData\Local\Pandoc\
PATHEXT=.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC
PROCESSOR_ARCHITECTURE=AMD64
PROCESSOR_IDENTIFIER=Intel64 Family 6 Model 186 Stepping 2, GenuineIntel
PROCESSOR_LEVEL=6
PROCESSOR_REVISION=ba02
ProgramData=C:\ProgramData
ProgramFiles=C:\Program Files
ProgramFiles(x86)=C:\Program Files (x86)
ProgramW6432=C:\Program Files
PROMPT=$P$G
PSModulePath=C:\Program Files\WindowsPowerShell\Modules;C:\Windows\system32\WindowsPowerShell\v1.0\Modules
PUBLIC=C:\Users\Public
PyCharm Community Edition=d:\Program Files\JetBrains\PyCharm Community Edition 2023.2.3\bin;
QtMsBuild=C:\Users\pxy\AppData\Local\QtMsBuild
SESSIONNAME=RDP-Tcp#0
SystemDrive=C:
SystemRoot=C:\Windows
TEMP=C:\Users\pxy\AppData\Local\Temp
TMP=C:\Users\pxy\AppData\Local\Temp
USERDOMAIN=pxy-notebook
USERDOMAIN_ROAMINGPROFILE=pxy-notebook
USERNAME=pxy
USERPROFILE=C:\Users\pxy
windir=C:\Windows
ZES_ENABLE_SYSMAN=1
```



