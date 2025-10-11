# chrt

## 编译

准备：

- msys2
- util-linux-2.40.4.tar.gz
- 工具链：i686-pc-linux-gnu-gcc.exe

设置工具链环境变量：

```shell
pxy@pxy-notebook MSYS /d/GitLab/Leetro/LtI7ConSys/I7aLinux/LxWinLinuxSdkWorkspace/lxwin_linux_sdk/MinGw/bin
$ pwd
/d/GitLab/Leetro/LtI7ConSys/I7aLinux/LxWinLinuxSdkWorkspace/lxwin_linux_sdk/MinGw/bin

pxy@pxy-notebook MSYS /d/GitLab/Leetro/LtI7ConSys/I7aLinux/LxWinLinuxSdkWorkspace/lxwin_linux_sdk/MinGw/bin
$ export PATH=`pwd`:$PATH

pxy@pxy-notebook MSYS ~/workspace/lxwin/util-linux-2.40.4
$ i686-pc-linux-gnu-gcc --version
i686-pc-linux-gnu-gcc.exe (crosstool-NG crosstool-ng-1.23.0) 7.3.0
Copyright (C) 2017 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

```

安装依赖、配置和编译：

```shell
pacman -S flex
pacman -S bison
pacman -S gettext-devel
./autogen.sh
./configure --host=i686-pc-linux-gnu --disable-all-programs --enable-schedutils --disable-year2038
make
```

## 查看任务的参数

```shell
chrt -p pid
```

## 更改任务的优先级

```shell
chrt -f -p priority pid
```

设置任务的优先级，并设置调度策略位 `SCHED_FIFO` 。

