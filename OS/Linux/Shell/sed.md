# 简介

功能强大的流式文本编辑器

# 替换字符串

```shell
linux@ubuntu:~/s3c2440/u-boot-1.1.6$ echo `echo i.86 | sed -e 's/i.86/i386/'`
i386
linux@ubuntu:~/s3c2440/u-boot-1.1.6$ echo `echo 86 | sed -e 's/i.86/i386/'`
86
```



