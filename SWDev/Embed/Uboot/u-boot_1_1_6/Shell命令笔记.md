# uname

## uname -m

> print the machine hardware name

```shell
linux@ubuntu:~/linux_learn/shell_script/test$ uname -m
x86_64
```

## uname -s

>print the kernel name

```shell
linux@ubuntu:~/linux_learn/shell_command/test$ uname -s
Linux
```

# sed

功能强大的流式文本编辑器

## sed -e 's/regexp/replacement/'

替换字符串

>  Attempt  to  match  regexp  against the pattern space.  If successful, replace that portion matched with replacement.
>  The replacement may contain the special character & to refer to that portion of the pattern space which matched,  and
>  the special escapes \1 through \9 to refer to the corresponding matching sub-expressions in the regexp.

```shell
#!/bin/bash
#File Name   : basic.sh
#Author      : panxingyuan
#Email       : panxingyuan1@163.com
#Create Time : 2023-01-08 14:12:10
#Description : Basic usage of the sed.

HOSTARCH1=`echo i.86 | sed -e 's/i.86/i386/'`
HOSTARCH2=`echo 86 | sed -e 's/i.86/i386/'`

echo "HOSTARCH1 = $HOSTARCH1"
echo "HOSTARCH2 = $HOSTARCH2"
```
运行脚本：
```shell
linux@ubuntu:~/linux_learn/shell_command/sed_learn$ ./basic.sh
HOSTARCH1 = i386
HOSTARCH2 = 86
```

# tr

将字符进行替换压缩和删除

## tr '[:upper:]' '[:lower:]'

转换字符串的大小写

```shell
linux@ubuntu:~/linux_learn/shell_command/test$ echo `uname -s | tr [:upper:] [:lower:]`
linux
```



