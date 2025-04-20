# 1. linux sdk安装

## 1.1. 安装依赖软件

:information_source: 如果有`VPN`，建议开启`VPN`。

### 1.1.1. 在线安装

```shell
sudo apt-get install -y git ssh make gcc libssl-dev \
liblz4-tool expect expect-dev g++ patchelf chrpath gawk texinfo \
diffstat binfmt-support qemu-user-static live-build bison flex fakeroot \
cmake gcc-multilib g++-multilib unzip device-tree-compiler ncurses-dev \
libgucharmap-2-90-dev bzip2 expat gpgv2 cpp-aarch64-linux-gnu libgmp-dev \
libmpc-dev libmpfr-dev
```

软件介绍如下表所示：

| 名称                  | 描述                                                         |
| --------------------- | ------------------------------------------------------------ |
| git                   | 版本管理软件                                                 |
| ssh                   | 远程登录软件                                                 |
| make                  | 编译套件                                                     |
| gcc                   | 编译器                                                       |
| libssl-dev            | ssl开发包                                                    |
| liblz4-tool           |                                                              |
| expect,expect-dev     |                                                              |
| g++                   | 编译器                                                       |
| patchelf              | Modify ELF files                                             |
| chrpath               | Change the rpath of runpath in binaries                      |
| gawk                  | Pattern scanning and processing language                     |
| texinfo               | software documentation system                                |
| diffstat              | make histogram from diff-output                              |
| binfmt-support        |                                                              |
| qemu-user-static      | QEMU User Emulator (static version)                          |
| live-build            | The `Debian Live` tool suite                                 |
| bison                 | GNU Project parser generator (yacc replacement)              |
| flex                  | The fast lexical analyser generator                          |
| fakeroot              | Run a command in an environment faking root privileges for file manipulation |
| cmake                 | 编译套件                                                     |
| gcc-multilib          |                                                              |
| g++-multilib          |                                                              |
| unzip                 | zip解压                                                      |
| device-tree-compiler  | 设备树编译器                                                 |
| ncurses-dev           |                                                              |
| libgucharmap-2-90-dev |                                                              |
| bzip2                 | bz2压缩                                                      |
| cpp-aarch64-linux-gnu |                                                              |
| libgmp-dev            |                                                              |
| libmpc-dev            |                                                              |
| libmpfr-dev           |                                                              |

### 1.1.2. 设置python环境

检查`python`环境：

```shell
ls -al /usr/bin/python*
lrwxrwxrwx 1 root root       7 10月 11  2021 /usr/bin/python -> python3
lrwxrwxrwx 1 root root       9  7月 28  2021 /usr/bin/python2 -> python2.7
-rwxr-xr-x 1 root root 3592536 12月 10 02:47 /usr/bin/python2.7
lrwxrwxrwx 1 root root      10  8月  8  2024 /usr/bin/python3 -> python3.10
-rwxr-xr-x 1 root root 5937800  2月  4 22:57 /usr/bin/python3.10
-rwxr-xr-x 1 root root     960  1月 25  2023 /usr/bin/python3-futurize
-rwxr-xr-x 1 root root     964  1月 25  2023 /usr/bin/python3-pasteurize
```

如果不正确，如下所示创建软连接：

```shell
sudo ln -s /usr/bin/python3 /usr/bin/python
```

python版本需要`3.8`以上，如果低于此版本，需要进行更新。

```shell
python --version
Python 3.10.12
```

### 1.1.3. 安装live-build

编译Debian时需要。（如果不安装，编译出现`live-build错误`）

#### 1.1.3.1. 在线安装（VPN）

```shell
linux@linux-virtual-machine:~/Downloads$ sudo apt-get remove live-build
linux@linux-virtual-machine:~/Downloads$ sudo git clone https://salsa.debian.org/live-team/live-build.git --depth 1 -b debian/1%20230131
linux@linux-virtual-machine:~/Downloads$ sudo cd live-build
linux@linux-virtual-machine:~/Downloads/live-build$ rm -rf manpages/po/
linux@linux-virtual-machine:~/Downloads/live-build$ sudo make install -j8
```

#### 1.1.3.2. 离线安装

复制`4-软件资料/Debian/Tools/live-build-master.zip`到`ubuntu`。

```shell
linux@linux-virtual-machine:~/Downloads$ ls live-build-master.zip -l
-rwxrwxrwx 1 linux linux 504367  9月 30  2024 live-build-master.zip
linux@linux-virtual-machine:~/Downloads$ unzip live-build-master.zip
linux@linux-virtual-machine:~/Downloads$ cd live-build-master/
linux@linux-virtual-machine:~/Downloads/live-build-master$ sudo apt-get remove live-build
linux@linux-virtual-machine:~/Downloads/live-build-master$ rm -rf manpages/po/
linux@linux-virtual-machine:~/Downloads/live-build-master$ sudo make install -j8
```

## 1.2. 安装linux sdk

复制`4-软件资料/Debian/LinuxSDK/LinuxSDK-v2.5.tar.gz到`ubuntu`，然后解压。

挤压后的文件：

```shell
linux@linux-virtual-machine:~/workspace/rockchip/TL3588-EVM$ cd rk3588_linux_release_v1.2.1/
linux@linux-virtual-machine:~/workspace/rockchip/TL3588-EVM/rk3588_linux_release_v1.2.1$ ls -l
total 60
drwxrwxr-x  9 linux linux 4096  9月 30  2024 app
drwxrwxr-x 18 linux linux 4096  4月 19 20:39 buildroot
lrwxrwxrwx  1 linux linux   39  9月 30  2024 build.sh -> device/rockchip/common/scripts/build.sh
drwxrwxr-x 11 linux linux 4096  4月 19 22:16 debian
drwxrwxr-x  3 linux linux 4096  9月 30  2024 device
drwxrwxr-x  5 linux linux 4096  9月 30  2024 docs
drwxrwxr-x 24 linux linux 4096  9月 30  2024 external
drwxrwxr-x  3 linux linux 4096  9月 30  2024 extra-tools
drwxrwxr-x 27 linux linux 4096  4月 19 23:47 kernel
lrwxrwxrwx  1 linux linux   31  9月 30  2024 Makefile -> device/rockchip/common/Makefile
drwxrwxr-x  3 linux linux 4096  9月 30  2024 prebuilts
lrwxrwxrwx  1 linux linux   32  4月 17 13:29 README.md -> device/rockchip/common/README.md
drwxrwxr-x  9 linux linux 4096  9月 30  2024 rkbin
lrwxrwxrwx  1 linux linux   41  9月 30  2024 rkflash.sh -> device/rockchip/common/scripts/rkflash.sh
lrwxrwxrwx  1 linux linux   15  4月 19 23:40 rockdev -> output/firmware
drwxrwxr-x  5 linux linux 4096  9月 30  2024 tools
drwxrwxr-x 28 linux linux 4096  4月 19 23:40 u-boot
drwxrwxr-x  5 linux linux 4096  9月 30  2024 uefi
drwxrwxr-x  9 linux linux 4096  9月 30  2024 yocto
```

linux sdk目录：

| 名称            | 描述                                                     |
| --------------- | -------------------------------------------------------- |
| app             | 应用程序                                                 |
| buildroot       | Buildroot rootfs                                         |
| build.sh        | linux sdk编译脚本                                        |
| debian          | Debian rootfs                                            |
| device/rockchip | 芯片板级配置以及一些编译和打包固件的脚本和文件           |
| docs            | 通用开发指导文档、Linux 系统开发指南、芯片平台相关文档等 |
| external        | 第三方相关仓库，包括显示、音视频、摄像头、网络、安全等   |
| extra-tools     | 存放用于 Debian 交叉编译工具链                           |
| kernel          | linux kernel源代码                                       |
| Makefile        | linux sdk顶层Makefile                                    |
| prebuilts       | 交叉编译工具链                                           |
| rkbin           | Rockchip 相关二进制和工具                                |
| rkflash.sh      |                                                          |
| rockdev         |                                                          |
| tools           | linux 和 windows 操作系统环境下常用工具                  |
| u-boot          | u-boot源代码                                             |
| uefi            | 有关 UEFI 启动的文件                                     |
| yocto           | Yocto rootfs                                             |

## 1.3. 安装Debian dl

dl.tar.gz 压缩包用于存放从官网下载的开源软件包。（但是好像没有使用）

复制`4-软件资料/Debian/LinuxSDK/LinuxSDK-v2.5.tar.gz到`ubuntu`，然后解压。

```shell
linux@linux-virtual-machine:~/workspace/rockchip/TL3588-EVM/rk3588_linux_release_v1.2.1/buildroot$ ls -l dl.tar.gz 
-rwxrwxrwx 1 linux linux 374704543  9月 30  2024 dl.tar.gz
linux@linux-virtual-machine:~/workspace/rockchip/TL3588-EVM/rk3588_linux_release_v1.2.1/buildroot$ tar xvf dl.tar.gz
```

# 2. linux sdk编译

# 3. rootfs修改

# 4. 系统烧写



# Q && A

# Debian编译

## live-build错误

```
Your live-build doesn't support bullseye
Please replace it:
sudo apt-get remove live-build
git clone https://salsa.debian.org/live-team/live-build.git --depth 1 -b debian/1%20230131
cd live-build
rm -rf manpages/po/
sudo make install -j8
```

