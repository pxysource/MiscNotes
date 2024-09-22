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

## 1

```bat
@echo off
if exist Test.txt copy %CD%\Test.txt "C:\Users\pc-2020-4-20\Desktop\"
pause
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

