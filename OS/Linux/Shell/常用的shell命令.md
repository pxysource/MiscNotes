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

# pgrep

根据程序的名称，获取程序的`pid`

```shell
zynq> pgrep Lti6
1476
```

# 使用示例

## 根据应用名称kill应用程序

```shell
zynq> pgrep Lti6 | xargs kill -9
```

# cut

- **remove sections from each line of files**.

> SYNOPSIS
>
> ​       cut OPTION... [FILE]...
>
> DESCRIPTION
>
> ​       Print selected parts of lines from each FILE to standard output.
>
> ​       With no FILE, or when FILE is -, read standard input.
>
> ​       Mandatory  arguments  to  long  options are mandatory for short options too.

## -b

>  -b, --bytes=LIST
>
>  ​              select only these bytes

```shell
linux@ubuntu:~$ cat test.txt 
hello
how
are
you
linux@ubuntu:~$ cut -b 1-3,5 test.txt 
helo
how
are
you

linux@ubuntu:~$ cut -b 3 test.txt 
l
w
e
u

linux@ubuntu:~$ cut -b 3- test.txt 
llo
w
e
u

```

## -c

> ​       -c, --characters=LIST
>
> ​              select only these characters

```shell
linux@ubuntu:~$ cat test.txt
hello
how
are
you
linux@ubuntu:~$ cut -c 3 test.txt 
l
w
e
u

```

## -d & -f

> -d, --delimiter=DELIM
>
> - use DELIM instead of TAB for field delimiter
>
> -f, --fields=LIST
>
> - select only these fields;  also print any line that contains  no delimiter character, unless the -s  option is specified

```shell
linux@ubuntu:~$ cat passwd 
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin

linux@ubuntu:~$ cut -d : -f 1,2,5 passwd 
root:x:root
daemon:x:daemon
bin:x:bin
sys:x:sys
sync:x:sync
games:x:games
man:x:man
```



## Bugs

### -b和-c对中文字符等多字符可能会乱码

```shell
linux@ubuntu:~$ cat test_differ.c 
星期一
星期二
星期三
星期四
星期五

linux@ubuntu:~$ cut -b 3 test_differ.c 
�
�
�
�
�

linux@ubuntu:~$ cut -b 3 test_differ.c
�
�
�
�
�

linux@ubuntu:~$ cut -n -b 1,2,3 test_differ.c
星
星
星
星
星
```

# wc

- print newline, word, and byte counts for each file.

> SYNOPSIS
>
> ​       wc [OPTION]... [FILE]...
>
> ​       wc [OPTION]... --files0-from=F
>
> DESCRIPTION
>
> Print newline, word, and byte counts for each FILE, and a total line if more than one FILE is specified.  A word is a non-zero-length  sequence
>
> of characters delimited by white space.
>
> ​       With no FILE, or when FILE is -, read standard input.

## Read Standard Input

```shell
linux@ubuntu:~$ echo "hello" | wc
      1       1       6
      lines   words   bytes
linux@ubuntu:~$ echo "hello" | wc -
      1       1       6 -
```

# diff

```shell
linux@ubuntu:~$ cat 1.txt 
1
2
3
4
5
linux@ubuntu:~$ cat 2.txt 
1
2
3
4
5
6
7
8
9
```

## 1. 直接输出文件的不同

```bash
linux@ubuntu:~$ diff 1.txt 2.txt 
5a6,9
> 6
> 7
> 8
> 9
linux@ubuntu:~$ 

```

## 2. 将文件的不同输出到新的文件

```bash
linux@ubuntu:~$ diff 1.txt 2.txt >test.patch
linux@ubuntu:~$ cat test.patch 
5a6,9
> 6
> 7
> 8
> 9
linux@ubuntu:~$ 
```

## 3. 以"-/+"形式显示不同的内容

```shell
linux@linux-virtual-machine:/tmp/diff_test$ diff 1.txt 2.txt -u
--- 1.txt       2025-06-03 14:02:09.593636945 +0800
+++ 2.txt       2025-06-03 14:02:28.241024010 +0800
@@ -3,3 +3,7 @@
 3
 4
 5
+6
+7
+8
+9
```

## 4. 递归对比文件夹，如果某个文件不存在，不显示内容

```shell
linux@linux-virtual-machine:~/workspace/svn/ZhaoYang/branches/FmwOS/SysInstall$ sudo diff rootfs/tmp_mount/ /tmp/rootfs/tmp_mount/ -rq
Only in /tmp/rootfs/tmp_mount/home: I7pProduceApp.elf
Files rootfs/tmp_mount/home/installer.sh and /tmp/rootfs/tmp_mount/home/installer.sh differ
```

# patch

- 升级文件

```bash
linux@ubuntu:~$ cat 1.txt 
1
2
3
4
5
linux@ubuntu:~$ cat 2.txt 
1
2
3
4
5
6
7
8
9
linux@ubuntu:~$ cat test.patch 
5a6,9
> 6
> 7
> 8
> 9
linux@ubuntu:~$ patch -p0 1.txt test.patch 
patching file 1.txt
linux@ubuntu:~$ cat 1.txt 
1
2
3
4
5
6
7
8
9
linux@ubuntu:~$ 

```

- 回退文件

```bash
linux@ubuntu:~$ cat 2.txt 
1
2
3
4
5
6
7
8
9
linux@ubuntu:~$ cat test.patch 
5a6,9
> 6
> 7
> 8
> 9
linux@ubuntu:~$ patch -R 2.txt test.patch 
patching file 2.txt
linux@ubuntu:~$ cat 2.txt 
1
2
3
4
5
linux@ubuntu:~$ ls

```

# curl

# wget

- 下载网址链接的资源。

# mount

mount a filesystem

# 文件

## 路径

### `basename` - 从文件名中删除目录和后缀

从文件名中删除目录：

```shell
linux@linux-virtual-machine:~$ basename /usr/bin/sort 
sort
```

从文件名中删除目录和后缀：

```shell
linux@linux-virtual-machine:~$ basename /usr/include/stdio.h .h
stdio
```

移除文件名后缀：

```shell
linux@linux-virtual-machine:~$ basename -s .h /usr/include/stdio.h
stdio
```

### `readlink` - 打印已解析的符号链接或规范文件名

打印完整路径：

```shell
linux@linux-virtual-machine:~$ readlink -f .
/home/linux
```

# date: 打印/设置系统日期时间

获取当前系统日期时间：

```shell
zynq> date
Tue Jan  6 00:27:23 UTC 1970
```

## 格式化输出

获取当前系统日期：

```shell
zynq> date +"%Y-%m-%d"
1970-01-06
```

获取当前系统时间：

```shell
zynq> date +"%H:%M:%S"
14:44:07
```

获取当前系统日期时间：

```shell
zynq> date +"%Y-%m-%d %H:%M:%S"
1970-01-06 00:49:58
```

## 设置系统日期时间

```shell
zynq> date -s "2025-06-09 14:38:00"
Mon Jun  9 14:38:00 UTC 2025
zynq> date +"%Y-%m-%d %H:%M:%S"
2025-06-09 14:38:04
zynq> 
```

## 检查命令的耗时

```shell
#!/bin/sh

start=$(date +%s)
sleep 2
end=$(date +%s)
diff=$((end-start))
echo $diff seconds.
```

