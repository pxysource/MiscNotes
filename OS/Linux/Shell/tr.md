# 简介

将字符进行替换压缩和删除

# 转换字符串的大小写

```shell
linux@ubuntu:~/s3c2440/u-boot-1.1.6$ uname -s
Linux
linux@ubuntu:~/s3c2440/u-boot-1.1.6$ echo `uname -s | tr '[:lower:]' '[:upper:]'`
LINUX
linux@ubuntu:~/s3c2440/u-boot-1.1.6$ echo `uname -s | tr '[:upper:]' '[:lower:]'`
linux
```

