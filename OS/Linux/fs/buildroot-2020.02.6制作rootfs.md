# 简介

## 硬件

- SOC：zynq 7020
- 开发板：正点原子领航者ZYNQ 7020

## 工具

- buildroot：buildroot-2020.02.6[^1]
- 编译工具链：安装Xilinx petalinux 2018.3

# 制作基础rootfs

## 基础配置

```shell
linux@linux-virtual-machine:~/workspace/buildroot/buildroot-2020.02.6$ make menuconfig
```

进入配置主界面：

```
    Target options  --->
    Build options  --->
    Toolchain  --->
    System configuration  --->
    Kernel  --->
    Target packages  --->
    Filesystem images  --->
    Bootloaders  --->
    Host utilities  --->
    Legacy config options  --->
```

### Target options

```
    Target Architecture (ARM (little endian))  --->
    Target Binary Format (ELF)  --->
    Target Architecture Variant (cortex-A9)  --->
[*] Enable NEON SIMD extension support
[*] Enable VFP extension support
    Target ABI (EABIhf)  --->
    Floating point strategy (NEON)  --->
    ARM instruction set (ARM)  --->
```

### Toolchain

```
    Toolchain type (External toolchain)  --->
    *** Toolchain External Options ***
    Toolchain (Custom toolchain)  --->
    Toolchain origin (Pre-installed toolchain)  --->
(/opt/pkg/petalinux/2018.3/tools/linux-i386/gcc-arm-linux-gnueabi) Toolchain path
($(ARCH)-linux-gnueabihf) Toolchain prefix
    External toolchain gcc version (7.x)  --->
    External toolchain kernel headers series (4.9.x)  --->
    External toolchain C library (glibc/eglibc)  --->
[*] Toolchain has SSP support? (NEW)
[*]   Toolchain has SSP strong support?
[*] Toolchain has RPC support? (NEW)
[*] Toolchain has C++ support?
    *** Toolchain Generic Options ***
[*] Enable MMU support (NEW)
```

----

如何得到toolchain gcc version

```shell
linux@linux-virtual-machine:/opt/pkg/petalinux/2018.3/tools/linux-i386/gcc-arm-linux-gnueabi$ bin/arm-linux-gnueabihf-gcc --version
arm-linux-gnueabihf-gcc (Linaro GCC 7.3-2018.04-rc3) 7.3.1 20180314
Copyright (C) 2017 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

```



----

如何得到toolchain kernel headers series

```shell
linux@linux-virtual-machine:/opt/pkg/petalinux/2018.3/tools/linux-i386/gcc-arm-linux-gnueabi$ vi arm-linux-gnueabihf/libc/usr/include/linux/version.h
```

`version.h`：

```c
#define LINUX_VERSION_CODE 264448                                               
#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))
```

`264448`转换为16进制为`4 0900`

根据`KERNEL_VERSION`宏，版本有3个数字，所以对应的版本为：`4.9.0`

### System configuration

```
(buildroot) System hostname (NEW)
(Welcome to Buildroot) System banner (NEW)
    Init system (BusyBox)  --->
    /dev management (Dynamic using devtmpfs + mdev)  --->
[*] Enable root login with password (NEW)
(123456) Root password
```

### Kernel

```
[ ] Linux Kernel (NEW)
```

不编译linux内核。

### Target packages

```
    System tools  --->
```

- ```
  [*] kmod
  ```

### Filesystem images

```
[*] ext2/3/4 root filesystem
      ext2/3/4 variant (ext4)  --->
(1G)  exact size
```

### Bootloaders

```
[ ] U-Boot (NEW)
```

不编译bootloader，也即不编译u-boot

## 保存buildroot配置

保存到configs目录下：如保存为`configs/rootfs_test_defconfig`

## 配置

```shell
make rootfs_test_defconfig
```

## 编译

```shell
make -j8
```

注意：

- 由于要下载一些软件包，要保证连接到上“外网”。
- 如果某些包下载太慢，可以下载对应的包后，放在`dl`目录

# buildroot下的busybox配置与编译

`make busybox-menuconfig`

`make busybox`

## 使用自己的busybox源码

创建`/configs/local.mk`文件

文件内容格式：`XXXXXX_OVERRIDE_SRCDIR=源码路径`

busybox：`BUSYBOX_OVERRIDE_SRCDIR=/home/linux/workspace/busybox/busybox-1.21.0`

设置buildroot配置：

```
    Build options  --->
```

- ```
  ($(CONFIG_DIR)/local.mk) location of a package override file
  ```

## 选择depmod

```
    Linux Module Utilities  --->
```

- ```
  [*] depmod (27 kb)
  ```



# 安装第三工具

## 查看使用了哪些包

`make show-targets`可以查看使用了哪些包

```shell
linux@linux-virtual-machine:~/workspace/buildroot/buildroot-2020.02.6$ make show-targets
busybox host-acl host-attr host-autoconf host-automake host-e2fsprogs host-fakeroot host-libtool host-libzlib host-m4 host-makedevs host-mkpasswd host-patchelf host-pkgconf host-skeleton host-util-linux host-zlib ifupdown-scripts initscripts kmod skeleton skeleton-init-common skeleton-init-sysv toolchain toolchain-external toolchain-external-custom rootfs-ext2 rootfs-tar
```

## vsftpd服务

```
    Target packages  --->
```

- ```
      Networking applications  --->
  ```
  - ```
    [*] vsftpd
    ```

## ssh服务
```
    Target packages  --->
```

- ```
      Networking applications  --->
  ```
  - ```
    [*] openssh
    ```

# 手动配置

## 创建内核模块目录

根据内核版本创建目录：

`mkdir -p lib/modules/4.14.0-xilinx`

## vsftpd服务配置

编辑`etc/vsftpd.config`文件，使能如下配置

```
local_enable=YES
write_enable=YES
```

修改/etc/vsftpd.conf文件的所属用户，其改为root用户

`chown root:root vsftpd.conf `

```shell
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs/etc$ ls -l vsftpd.conf 
-rw-r--r-- 1 root root 4591 1月  14 11:24 vsftpd.conf

```

开发板上使用adduser命令新建一个用户要来完成FTP登录：

```shell
adduser linux
```

## sshd服务配置

设置`/vat/empty`目录的修所属用户以及用户组：

`chown root:root /var/empty`

## 添加自启动脚本

添加自启动脚本到`/etc/init.d`目录下：

```shell
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs/etc/init.d$ vi Sautorun
```

```shell
#!/bin/sh

echo "Auto run"
```

```shell
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs/etc/init.d$ chmod +x Sautorun 
```

## 修改命令prompt

修改命令prompt，即修改环境变量PS1.

PS1的说明：

```
\!：显示该命令的历史记录编号。
\#：显示当前命令的命令编号。
\$：显示$符作为提示符，如果用户是root的话，则显示#号。
\\：显示反斜杠。
\d：显示当前日期。
\h：显示主机名。
\n：打印新行。
\nnn：显示nnn的八进制值。
\s：显示当前运行的shell的名字。
\t：显示当前时间。
\u：显示当前用户的用户名。
\W：显示当前工作目录的名字。
\w：显示当前工作目录的路径。
```



---------------------

添加自定义配置文件到`/etc/profile.d`目录下：

```shell
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs/etc/profile.d$ vi myprofile.sh
```

```shell
#!/bin/sh

if [ "`id -u`" -eq 0 ]; then
    export PS1='[\u@\h]:\w# '
else
    export PS1='[\u@\h]:\w$ '
fi

export PS1
```

```shell
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs/etc/profile.d$ chmod +x myprofile.sh
```



# 附录

[^1]: https://buildroot.org/ "Buildroot - Making Embedded Linux Easy"