# 简介

## 硬件

- SOC：zynq 7020
- 开发板：正点原子领航者ZYNQ 7020

## 工具

- busybox：busybox-1.29.0[^1]
- 编译工具链：安装Xilinx petalinux 2018.3

# 制作基础rootfs

## 配置busybox

- `defconfig`：默认配置选项
- `allyesconfig`：选中busybox的所有功能
- `allnoconfig`：最小配置

```shell
linux@linux-virtual-machine:~/workspace/busybox/busybox-1.29.0$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- defconfig
linux@linux-virtual-machine:~/workspace/busybox/busybox-1.29.0$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
```

配置主界面如下：

```
    Settings  --->
--- Applets
    Archival Utilities  --->
    Coreutils  --->
    Console Utilities  --->
    Debian Utilities  --->
    klibc-utils  --->
    Editors  --->
    Finding Utilities  --->
    Init Utilities  --->
    Login/Password Management Utilities  --->
    Linux Ext2 FS Progs  --->
    Linux Module Utilities  --->
    Linux System Utilities  --->
    Miscellaneous Utilities  --->
    Networking Utilities  --->
    Print Utilities  --->
    Mail Utilities  --->
    Process Utilities  --->
    Runit Utilities  --->
    Shells  --->
    System Logging Utilities  --->
---
    Load an Alternate Configuration File
    Save Configuration to an Alternate File
```

### Settings

```
[ ] Build static binary (no shared libs)
[*] Command line editing
(1024) Maximum length of input
[*]   vi-style line editing commands
[*] Support Unicode
[*]   Check $LC_ALL, $LC_CTYPE and $LANG environment variables
```

### Linux Module Utilities

```
[ ] Simplified modutils

```

### Linux System Utilities

```
[*] mdev (16 kb)
[*]   Support /etc/mdev.conf
[*]     Support subdirs/symlinks
[*]       Support regular expressions substitutions when renaming device
[*]     Support command execution at device addition/removal
[*]   Support loading of firmware

```

## 编译busybox

```shell
linux@linux-virtual-machine:~/workspace/busybox/busybox-1.29.0$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- install CONFIG_PREFIX=/home/linux/workspace/nfsdir/rootfs_busybox-1.29.0
```

rootfs目录：

```shell
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0$ ls -l
total 12
drwxrwxr-x 2 linux linux 4096 1月  20 17:52 bin
lrwxrwxrwx 1 linux linux   11 1月  20 17:52 linuxrc -> bin/busybox
drwxrwxr-x 2 linux linux 4096 1月  20 17:52 sbin
drwxrwxr-x 4 linux linux 4096 1月  20 17:52 usr

```

## rootfs添加`/lib`

### 创建`/lib`目录

```shell
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0$ mkdir lib
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0$ ls -l
total 16
drwxrwxr-x 2 linux linux 4096 1月  20 17:52 bin
drwxrwxr-x 2 linux linux 4096 1月  20 17:55 lib
lrwxrwxrwx 1 linux linux   11 1月  20 17:52 linuxrc -> bin/busybox
drwxrwxr-x 2 linux linux 4096 1月  20 17:52 sbin
drwxrwxr-x 4 linux linux 4096 1月  20 17:52 usr

```

### 打包库到`/lib`

```shell
linux@linux-virtual-machine:/opt/pkg/petalinux/2018.3/tools/linux-i386/gcc-arm-linux-gnueabi/arm-linux-gnueabihf/libc/lib$ cp *so* /home/linux/workspace/nfsdir/rootfs_busybox-1.29.0/lib/ -d
```

## rootfs添加`/usr/lib`

### `/usr`下创建`lib`目录

```shell
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0$ cd usr/
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0/usr$ ls
bin  sbin
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0/usr$ mkdir lib
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0/usr$ ls
bin  lib  sbin

```

### 打包库打rootfs的`/usr/lib`目录

```shell
linux@linux-virtual-machine:/opt/pkg/petalinux/2018.3/tools/linux-i386/gcc-arm-linux-gnueabi/arm-linux-gnueabihf/libc/usr/lib$ cp *so* /home/linux/workspace/nfsdir/rootfs_busybox-1.29.0/usr/lib/ -d
```

## rootfs添加其他目录

- `/dev`
- `/proc`
- `/mnt`
- `/sys`
- `/tmp`
- `/root`
- `/home`
- `/etc`

```shell
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0$ ls
bin  lib  linuxrc  sbin  usr
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0$ mkdir dev proc mnt sys tmp root home
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0$ ls
bin  dev  home  lib  linuxrc  mnt  proc  root  sbin  sys  tmp  usr

```

## rootfs中添加`/etc`

### 创建`/etc`及`/etc/init.d`目录

```shell
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0$ ls
bin  dev  home  lib  linuxrc  mnt  proc  root  sbin  sys  tmp  usr
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0$ mkdir etc
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0$ mkdir etc/init.d
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0$ ls
bin  dev  etc  home  lib  linuxrc  mnt  proc  root  sbin  sys  tmp  usr
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0$ cd etc/
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0/etc$ ls
init.d

```

### 创建`/etc/init.d/rcS`文件

```shell
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0/etc/init.d$ vi rcS
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0/etc/init.d$ ls
rcS
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0/etc/init.d$ chmod +x rcS 
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0/etc/init.d$ ls -l
total 4
-rwxrwxr-x 1 linux linux 240 1月  20 21:35 rcS

```

文件内容如下：

```shell
#!/bin/sh

PATH=/sbin/:/bin:/usr/sbin:/usr/bin
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib:/usr/lib
export PATH LD_LIBRARY_PATH runlevel

mount -a
mkdir /dev/pts
mount -t devpts devpts /dev/pts

echo /sbin/mdev > /proc/sys/kernel/hotplug
mdev -s
```

### 创建`/etc/fstab`文件

```shell
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0/etc$ ls
init.d
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0/etc$ touch fstab
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0/etc$ vi fstab 
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0/etc$ ls
fstab  init.d

```

文件内容如下：

```
# <file system> <mount point> <type> <options> <dump> <pass>
proc            /proc         proc   defaults  0      0
tmpfs           /tmp          tmpfs  defaults  0      0
sysfs           /sys          sysfs  defaults  0      0
```

### 创建`/etc/inittab`文件

```shell
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0/etc$ ls
fstab  init.d
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0/etc$ touch inittab
linux@linux-virtual-machine:~/workspace/nfsdir/rootfs_busybox-1.29.0/etc$ ls
fstab  init.d  inittab
```

文件内容：

```
# <id>:<runlevels>:<action>:<process>
::sysinit:/etc/init.d/rcS

console::askfirst:-/bin/sh

::restart:/sbin/init
::ctrlaltdel:/sbin/reboot
::shutdown:/bin/umount -a -r
::shutdown:/sbin/swapoff -a
```



# 附录

[^1]: https://www.busybox.net/downloads/ "Index of /downloads"