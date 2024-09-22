# 1 启动文件

## 1.1 启动文件链接

- 启动文件在链接的时候，要第一个链接，否则程序启动不了。



- head.o为启动文件head.S编译生成的*.o文件。

```shell
/home/linux/s3c2440/gcc-3.4.5-glibc-2.3.6/bin/arm-linux-ld -Ttext 0x30000000 head.o leds.o -o sdram.elf
```

