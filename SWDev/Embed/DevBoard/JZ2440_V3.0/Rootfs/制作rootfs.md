# 简介

# 制作最小rootfs

创建一个目录`rootfs_mini`，作为`rootfs`根目录。

## 1 创建设备文件

### `/dev/console`

查看pc上的`/dev/console`的设备文件信息

```shell
linux@ubuntu:~/workspace/s3c2440/my-s3c2440/build_root/rootfs_mini/dev$ ls -l /dev/console 
crw------- 1 root root 5, 1 May 29 15:20 /dev/console
```

创建

```shell
linux@ubuntu:~/workspace/s3c2440/my-s3c2440/build_root/rootfs_mini/dev$ sudo mknod console c 5 1
linux@ubuntu:~/workspace/s3c2440/my-s3c2440/build_root/rootfs_mini/dev$ ls -l
total 0
crw-r--r-- 1 root root 5, 1 Jun 11 18:07 console
```

### `/dev/null`

查看pc上的`/dev/null`的设备文件信息

```shell
linux@ubuntu:~/workspace/s3c2440/my-s3c2440/build_root/rootfs_mini/dev$ ls -l /dev/null 
crw-rw-rw- 1 root root 1, 3 May 29 15:20 /dev/null
```

创建

```shell
linux@ubuntu:~/workspace/s3c2440/my-s3c2440/build_root/rootfs_mini/dev$ sudo mknod null c 1 3
linux@ubuntu:~/workspace/s3c2440/my-s3c2440/build_root/rootfs_mini/dev$ ls -l null 
crw-r--r-- 1 root root 1, 3 Jun 11 18:10 null
```

## 2 编译busybox

busybox版本：`1.7.0`

`meke menuconfig`：

```shell
linux@ubuntu:~/workspace/s3c2440/my-s3c2440/busybox-1.7.0$ make ARCH=arm CROSS_COMPILE=arm-linux- menuconfig
Makefile:405: *** mixed implicit and normal rules: deprecated syntax
Makefile:1242: *** mixed implicit and normal rules: deprecated syntax
make: *** No rule to make target 'menuconfig'. Stop.
```

分析原因：

新版Makefile不支持这样的组合目标：config %config(一个有通配符，另一个没有通配符)

解决方法:

要么把config %config拆成2个规则，要么把其中一个目标去掉。

修改顶层`Makefile`文件：

1. 修改busybox-1.7.0 顶层Makefile 405行:

   ```makefile
   config %config: scripts_basic outputmakefile FORCE
   ```

   改为:

   ```makefile
   %config:scripts_basic outputmakefile FORCE
   ```

2. 修改busybox-1.7.0 顶层Makefile 1242行:

   ```Makefile
   / %/: prepare scripts FORCE
   ```
   
   改为:
   
   ```Makefile
   %/: prepare scripts FORCE
   ```

修改后重新`meke menuconfig`，根据需要进行配置。

`make`：

```shell
make ARCH=arm CROSS_COMPILE=arm-linux-
```

`make install`：

```shell
make ARCH=arm CROSS_COMPILE=arm-linux- install CONFIG_PREFIX=/home/linux/workspace/s3c2440/my-s3c2440/build_root/rootfs_mini
```

## 3 创建`/etc/inittab`

```
console::askfirst:-/bin/sh                                                                                   ::sysinit:/etc/init.d/rcS
```

## 4 创建`/etc/init.d/rcS`

```shell
#!/bin/sh

#mount -t proc none /proc
mount -a
mkdir /dev/pts
mount -t devpts devpts /dev/pts
echo /sbin/mdev > /proc/sys/kernel/hotplug
mdev -s

```

## 5 创建`/etc/fstab`

`mount -a`命令依赖配置文件`/etc/fstab`

```
# device    mount-point    type    options    dump    fsck    order
proc        /proc          proc    defaults   0       0
sysfs       /sys           sysfs   defaults   0       0
tmpfs       /dev           tmpfs   defaults   0       0
tmpfs       /tmp           tmpfs   defaults   0       0

```

创建文件夹：

```shell
linux@ubuntu:~/workspace/s3c2440/my-s3c2440/build_root/rootfs_mini$ mkdir proc
linux@ubuntu:~/workspace/s3c2440/my-s3c2440/build_root/rootfs_mini$ mkdir tmp
linux@ubuntu:~/workspace/s3c2440/my-s3c2440/build_root/rootfs_mini$ mkdir sys
```

## 6 打包c库

复制c库，当前直接使用的`glibc`：

```shell
cp *.so* /home/linux/workspace/s3c2440/my-s3c2440/build_root/rootfs_mini/lib -d
```

:point_right: `cp -d`，复制链接文件，保持链接。

```shell
linux@ubuntu:~/workspace/s3c2440/my-s3c2440/build_root/rootfs_mini/lib$ ls -l
total 6900
-rwxr-xr-x 1 linux linux  112886 Jun 11 19:35 ld-2.3.6.so
lrwxrwxrwx 1 linux linux      11 Jun 11 19:35 ld-linux.so.2 -> ld-2.3.6.so
-rwxr-xr-x 1 linux linux   17586 Jun 11 19:35 libanl-2.3.6.so
lrwxrwxrwx 1 linux linux      11 Jun 11 19:35 libanl.so -> libanl.so.1
lrwxrwxrwx 1 linux linux      15 Jun 11 19:35 libanl.so.1 -> libanl-2.3.6.so
-rwxr-xr-x 1 linux linux    8750 Jun 11 19:35 libBrokenLocale-2.3.6.so
lrwxrwxrwx 1 linux linux      20 Jun 11 19:35 libBrokenLocale.so -> libBrokenLocale.so.1
lrwxrwxrwx 1 linux linux      24 Jun 11 19:35 libBrokenLocale.so.1 -> libBrokenLocale-2.3.6.so
-rwxr-xr-x 1 linux linux 1435660 Jun 11 19:35 libc-2.3.6.so
-rwxr-xr-x 1 linux linux   30700 Jun 11 19:35 libcrypt-2.3.6.so
lrwxrwxrwx 1 linux linux      13 Jun 11 19:35 libcrypt.so -> libcrypt.so.1
lrwxrwxrwx 1 linux linux      17 Jun 11 19:35 libcrypt.so.1 -> libcrypt-2.3.6.so
-rw-r--r-- 1 linux linux     195 Jun 11 19:35 libc.so
lrwxrwxrwx 1 linux linux      13 Jun 11 19:35 libc.so.6 -> libc-2.3.6.so
-rw-r--r-- 1 linux linux     205 Jun 11 19:35 libc.so_orig
-rwxr-xr-x 1 linux linux   16665 Jun 11 19:35 libdl-2.3.6.so
lrwxrwxrwx 1 linux linux      10 Jun 11 19:35 libdl.so -> libdl.so.2
lrwxrwxrwx 1 linux linux      14 Jun 11 19:35 libdl.so.2 -> libdl-2.3.6.so
lrwxrwxrwx 1 linux linux      13 Jun 11 19:35 libgcc_s.so -> libgcc_s.so.1
-rw-r--r-- 1 linux linux   63973 Jun 11 19:35 libgcc_s.so.1
-rwxr-xr-x 1 linux linux  779096 Jun 11 19:35 libm-2.3.6.so
-rwxr-xr-x 1 linux linux   23010 Jun 11 19:35 libmemusage.so
lrwxrwxrwx 1 linux linux       9 Jun 11 19:35 libm.so -> libm.so.6
lrwxrwxrwx 1 linux linux      13 Jun 11 19:35 libm.so.6 -> libm-2.3.6.so
-rwxr-xr-x 1 linux linux   94450 Jun 11 19:35 libnsl-2.3.6.so
lrwxrwxrwx 1 linux linux      11 Jun 11 19:35 libnsl.so -> libnsl.so.1
lrwxrwxrwx 1 linux linux      15 Jun 11 19:35 libnsl.so.1 -> libnsl-2.3.6.so
-rwxr-xr-x 1 linux linux   37812 Jun 11 19:35 libnss_compat-2.3.6.so
lrwxrwxrwx 1 linux linux      18 Jun 11 19:35 libnss_compat.so -> libnss_compat.so.2
lrwxrwxrwx 1 linux linux      22 Jun 11 19:35 libnss_compat.so.2 -> libnss_compat-2.3.6.so
-rwxr-xr-x 1 linux linux   21467 Jun 11 19:35 libnss_dns-2.3.6.so
lrwxrwxrwx 1 linux linux      15 Jun 11 19:35 libnss_dns.so -> libnss_dns.so.2
lrwxrwxrwx 1 linux linux      19 Jun 11 19:35 libnss_dns.so.2 -> libnss_dns-2.3.6.so
-rwxr-xr-x 1 linux linux   52833 Jun 11 19:35 libnss_files-2.3.6.so
lrwxrwxrwx 1 linux linux      17 Jun 11 19:35 libnss_files.so -> libnss_files.so.2
lrwxrwxrwx 1 linux linux      21 Jun 11 19:35 libnss_files.so.2 -> libnss_files-2.3.6.so
-rwxr-xr-x 1 linux linux   22938 Jun 11 19:35 libnss_hesiod-2.3.6.so
lrwxrwxrwx 1 linux linux      18 Jun 11 19:35 libnss_hesiod.so -> libnss_hesiod.so.2
lrwxrwxrwx 1 linux linux      22 Jun 11 19:35 libnss_hesiod.so.2 -> libnss_hesiod-2.3.6.so
-rwxr-xr-x 1 linux linux   50291 Jun 11 19:35 libnss_nis-2.3.6.so
-rwxr-xr-x 1 linux linux   56909 Jun 11 19:35 libnss_nisplus-2.3.6.so
lrwxrwxrwx 1 linux linux      19 Jun 11 19:35 libnss_nisplus.so -> libnss_nisplus.so.2
lrwxrwxrwx 1 linux linux      23 Jun 11 19:35 libnss_nisplus.so.2 -> libnss_nisplus-2.3.6.so
lrwxrwxrwx 1 linux linux      15 Jun 11 19:35 libnss_nis.so -> libnss_nis.so.2
lrwxrwxrwx 1 linux linux      19 Jun 11 19:35 libnss_nis.so.2 -> libnss_nis-2.3.6.so
-rwxr-xr-x 1 linux linux   10046 Jun 11 19:35 libpcprofile.so
-rwxr-xr-x 1 linux linux  102457 Jun 11 19:35 libpthread-0.10.so
-rw-r--r-- 1 linux linux     207 Jun 11 19:35 libpthread.so
lrwxrwxrwx 1 linux linux      18 Jun 11 19:35 libpthread.so.0 -> libpthread-0.10.so
-rw-r--r-- 1 linux linux     217 Jun 11 19:35 libpthread.so_orig
-rwxr-xr-x 1 linux linux   83645 Jun 11 19:35 libresolv-2.3.6.so
lrwxrwxrwx 1 linux linux      14 Jun 11 19:35 libresolv.so -> libresolv.so.2
lrwxrwxrwx 1 linux linux      18 Jun 11 19:35 libresolv.so.2 -> libresolv-2.3.6.so
-rwxr-xr-x 1 linux linux   47920 Jun 11 19:35 librt-2.3.6.so
lrwxrwxrwx 1 linux linux      10 Jun 11 19:35 librt.so -> librt.so.1
lrwxrwxrwx 1 linux linux      14 Jun 11 19:35 librt.so.1 -> librt-2.3.6.so
-rwxr-xr-x 1 linux linux   18959 Jun 11 19:35 libSegFault.so
lrwxrwxrwx 1 linux linux      18 Jun 11 19:35 libstdc++.so -> libstdc++.so.6.0.3
lrwxrwxrwx 1 linux linux      18 Jun 11 19:35 libstdc++.so.6 -> libstdc++.so.6.0.3
-rwxr-xr-x 1 linux linux 3862070 Jun 11 19:35 libstdc++.so.6.0.3
-rwxr-xr-x 1 linux linux   30636 Jun 11 19:35 libthread_db-1.0.so
lrwxrwxrwx 1 linux linux      17 Jun 11 19:35 libthread_db.so -> libthread_db.so.1
lrwxrwxrwx 1 linux linux      19 Jun 11 19:35 libthread_db.so.1 -> libthread_db-1.0.so
-rwxr-xr-x 1 linux linux   14213 Jun 11 19:35 libutil-2.3.6.so
lrwxrwxrwx 1 linux linux      12 Jun 11 19:35 libutil.so -> libutil.so.1
lrwxrwxrwx 1 linux linux      16 Jun 11 19:35 libutil.so.1 -> libutil-2.3.6.so
```

# 创建镜像文件

## yaffs

### yaffs

### yaffs2

## jffs

一种压缩的文件系统格式。

### jffs

### jffs2

# nfs挂载rootfs

设置内核启动参数：

```
setenv bootargs noinitrd console=ttySAC0 root=/dev/nfs nfsroot=192.168.1.2:/home/linux/workspace/s3c2440/my-s3c2440/build_root/rootfs_mini,v3 ip=192.168.1.17:192.168.1.2:192.168.1.1:255.255.255.0::eth0:off init=/linuxrc
```

将rootfs所在文件夹设置到nfs服务端，即在`/etc/exports`文件中添加如下设置

```
/home/linux/workspace/s3c2440/my-s3c2440/build_root/rootfs_mini *(rw,sync,no_root_squash,no_subtree_check)
```

