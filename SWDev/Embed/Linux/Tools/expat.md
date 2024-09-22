# 交叉编译

```shell
linux@linux-virtual-machine:/mnt/hgfs/share/expat-2.4.1$ ./configure --prefix=/home/linux/workspace/expat --host=arm-xilinx-linux-gnueabli CC=arm-xilinx-linux-gnueabi-gcc CXX=arm-xilinx-linux-gnueabi-g++
```

- –prefix：指定安装目录
- –host：指定目标主机类型
- CC/CXX：指定交叉编译工具
- –enable-shared：编译生成.so动态库
- –enable-static：编译生成.a静态库



注意：交叉编译时既要指定host也要指定编译器(CC和CXX)。