# 符号

## 重定向：`>`

### 输出错误到stderr

```shell
#!/bin/sh

AA=$(ls xxx 2>/dev/null)
if [ ! "$?" = "0" ]; then
    echo "error" 1>&2
fi 
```

# strings 

- 在对象文件或二进制文件中查找可打印的字符串

## 实例
- 列出ls中所有的ASCII文本：

  ```shell
  strings /bin/ls
  ```
  
- 列出ls中所有的ASCII文本：

  ```shell
  cat /bin/ls strings
  ```

- 查找ls中包含libc的字符串，不区分大小写：

  ```shell
  strings /bin/ls | grep -i libc
  ```

# lsusb

- 显示本机的USB设备列表信息

## 实例

- 列出所有USB设备

```shell
linux@ubuntu:~/s3c2440/arm-no-OS/uart$ lsusb
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 006: ID 1457:5118 First International Computer, Inc. OpenMoko Neo1973 Debug board (V2+)
Bus 002 Device 005: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port
Bus 002 Device 004: ID 0e0f:0008 VMware, Inc. VMware Virtual USB Mouse
Bus 002 Device 003: ID 0e0f:0002 VMware, Inc. Virtual USB Hub
Bus 002 Device 002: ID 0e0f:0003 VMware, Inc. Virtual Mouse
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

```

- 解释：
  - Bus 002，表示第2个usb主控制器(机器上总共有2个usb主控制器 -- 可以通过命令lspci | grep USB查看)

# objdump

查看动态库的导出函数

```shell
objdump -tT xxx.so
```

# readelf

# nm

查看动态库的导出函数

```shell
nm -D xxx.so
```



# time

查看应用所花费的时间

```shell
linux@ubuntu:~/linux_learn/shell_script/shell_grammar$ time ls
1.c  case.sh  echo.sh  for.sh  func1.sh  function.sh  if1.sh  if.sh  prac.sh  until.sh  while  while.sh

real    0m0.002s
user    0m0.002s
sys     0m0.000s
```

