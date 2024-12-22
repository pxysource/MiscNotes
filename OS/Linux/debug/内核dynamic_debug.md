# 1 简介

内核文档[Documentation/admin-guide/dynamic-debug-howto.rst](https://github.com/torvalds/linux/blob/master/Documentation/admin-guide/dynamic-debug-howto.rst)

# 2 使用

## 2.1 内核配置`dynamic debug`功能

### 2.1.1 menuconfig配置

搜索`DYNAMIC_DEBUG`：

```
.config - Linux/arm 3.8.0 Kernel Configuration
 ─────────────────── Search Results ───────────────────────────
 
  Symbol: DYNAMIC_DEBUG [=y]                                                                                   Type  : boolean                                                                                             Prompt: Enable dynamic printk() support                                                                       Defined at lib/Kconfig.debug:1358                                                                           Depends on: PRINTK [=y] && DEBUG_FS [=y]                                                                     Location:                                                                                                 (1) -> Kernel hacking 
```

设置`DYNAMIC_DEBUG`：

```
.config - Linux/arm 3.8.0 Kernel Configuration
 ─────────────────── Kernel hacking ───────────────────────────
 
 [*] Enable dynamic printk() support
```

内核启动后检查`DYNAMIC_DEBUG`设置：

```shell
zynq> zcat /proc/config.gz | grep DYNAMIC
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_DEBUG=y
```

## 2.2 开启调试

### 2.2.1 linux内核已启动

1. 修改`printk`打印等级，打印debug信息：

   ```shell
   echo 8 4 1 7 > /proc/sys/kernel/printk
   ```

2. 挂载`debugfs`文件系统：

   ```shell
   mount -t debugfs none /sys/kernel/debug
   ```

3. 设置需要开启调试的文件：

   ```shell
   echo -n "file drivers/spi/spi-xilinx-qps.c +p" > /sys/kernel/debug/dynamic_debug/control
   echo -n "file drivers/spi/spi.c +p" > /sys/kernel/debug/dynamic_debug/control
   echo -n "file drivers/mtd/devices/m25p80.c +p" > /sys/kernel/debug/dynamic_debug/control
   ```

调试`spi-xilinx-qps`驱动的例子：`dynamic_debug_add_files.sh`。

### 2.2.2 linux boot阶段

启动参数bootargs设置`loglevel=8`。

#### 方法1 在需要打印的源码开头定义DEBUG宏

在需要调试的源文件文件开头定义，注意一定要在`#include`之前定义才能生效。

:information_source: 需要重新编译内核或则驱动。

#### 方法2 启动参数设置dyndbg

调试`spi-xilinx-qps`驱动文件，如：

```shell
setenv bootargs console=ttyPS0,115200 root=/dev/ram rw earlyprintk loglevel=8 dyndbg=\"file drivers/spi/spi-xilinx-qps.c +p\"
```

在SecureCRT的脚本（VBScript）中应该进行如下设置：

```vbscript
' linux内核动态调试
' ""为vbs中"的转义
crt.Screen.Send "setenv bootargs console=ttyPS0,115200 root=/dev/ram rw earlyprintk loglevel=8 dyndbg=\""file drivers/spi/spi-xilinx-qps.c +p\; file drivers/spi/spi.c +p\; file drivers/mtd/devices/m25p80.c +p\"" " & chr(13)
```

:warning: 注意`bootargs`不能太长！