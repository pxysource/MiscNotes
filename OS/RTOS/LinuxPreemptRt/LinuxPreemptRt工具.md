# chrt

## 编译

准备：

- msys2
- util-linux-2.40.4.tar.gz
- 工具链：i686-pc-linux-gnu-gcc.exe



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

