# 准备

硬件：

- SD，从SD卡启动系统，所有的文件都打包到SD中。

软件：

- host系统：`Ubuntu 16.04`

- 交叉编译工具链：来自xilinx的SDK 2013.1(Xilinx_SDK_2013.1_0411_1.tar)[^1]套件

  >$ arm-xilinx-linux-gnueabi-gcc --version
  >arm-xilinx-linux-gnueabi-gcc (Sourcery CodeBench Lite 2012.09-104) 4.7.2
  >Copyright (C) 2012 Free Software Foundation, Inc.
  >This is free software; see the source for copying conditions.  There is NO
  >warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

- u-boot源码：`u-boot-xlnx-xilinx-v14.5`[^2]

- linux内核源码：`linux-xlnx-xilinx-v14.5`[^3]

- xenomai：`xenomai-2.6.3`[^4]

- ipipe：`ipipe-core-3.8-arm-1.patch`[^5]

- rootfs：`arm_ramdisk.image.gz`[^6]

```shell
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/bkup$ ls -l
total 21768
-rwxrwxr-x 1 linux linux 22289867 9月  29 02:44 xenomai-2.6.3.tar.bz2

linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/bkup$ ls -l
total 156460
-rwxrwxr-x 1 linux linux   5309954 11月 11 23:28 arm_ramdisk.image.gz
-rwxrwxr-x 1 linux linux    602842 11月 11 22:10 ipipe-core-3.8-arm-1.patch
-rwxrwxrwx 1 linux linux 135317953 2月  22  2023 linux-xlnx-xilinx-v14.5.zip
-rwxrwxrwx 1 linux linux  18973653 4月  13  2023 u-boot-xlnx-xilinx-v14.5.zip

```

## 解压

```shell
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/bkup$ ls
xenomai-2.6.3.tar.bz2
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/bkup$ tar xjf xenomai-2.6.3.tar.bz2 -C ../xilinx_zynq7020_zdyz/
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ ls
bkup  xenomai-2.6.3

linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/bkup$ unzip linux-xlnx-xilinx-v14.5.zip -d ..
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ unzip u-boot-xlnx-xilinx-v14.5.zip -d ..
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ ls
bkup  linux-xlnx-xilinx-v14.5  u-boot-xlnx-xilinx-v14.5  xenomai-2.6.3

```

## 准备ipipe补丁

```shell
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ mkdir ipipe
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ ls
bkup  ipipe  linux-xlnx-xilinx-v14.5  u-boot-xlnx-xilinx-v14.5  xenomai-2.6.3
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/ipipe$ cp ../bkup/ipipe-core-3.8-arm-1.patch .
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/ipipe$ ls
ipipe-core-3.8-arm-1.patch

```

## 创建build目录

```shell
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ mkdir build
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ ls
bkup  build  ipipe  linux-xlnx-xilinx-v14.5  u-boot-xlnx-xilinx-v14.5  xenomai-2.6.3

```

## 准备rootfs

```shell
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ cp bkup/arm_ramdisk.image.gz .
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ ls
arm_ramdisk.image.gz  bkup  build  ipipe  linux-xlnx-xilinx-v14.5  u-boot-xlnx-xilinx-v14.5  xenomai-2.6.3

```

# 编译u-boot

## 修改

```diff
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ diff bkup/u-boot-xlnx-xilinx-v14.5 u-boot-xlnx-xilinx-v14.5  -ur
diff -ur bkup/u-boot-xlnx-xilinx-v14.5/include/configs/zynq_common.h u-boot-xlnx-xilinx-v14.5/include/configs/zynq_common.h
--- bkup/u-boot-xlnx-xilinx-v14.5/include/configs/zynq_common.h	2013-04-03 21:03:26.000000000 +0800
+++ u-boot-xlnx-xilinx-v14.5/include/configs/zynq_common.h	2023-11-12 17:32:48.782925962 +0800
@@ -45,7 +45,7 @@
 #ifdef CONFIG_ZYNQ_SERIAL_UART0
 # define CONFIG_ZYNQ_SERIAL_BASEADDR0	0xE0000000
 # define CONFIG_ZYNQ_SERIAL_BAUDRATE0	CONFIG_BAUDRATE
-# define CONFIG_ZYNQ_SERIAL_CLOCK0	50000000
+# define CONFIG_ZYNQ_SERIAL_CLOCK0	100000000
 #endif
 
 #ifdef CONFIG_ZYNQ_SERIAL_UART1
diff -ur bkup/u-boot-xlnx-xilinx-v14.5/include/configs/zynq_zc70x.h u-boot-xlnx-xilinx-v14.5/include/configs/zynq_zc70x.h
--- bkup/u-boot-xlnx-xilinx-v14.5/include/configs/zynq_zc70x.h	2013-04-03 21:03:26.000000000 +0800
+++ u-boot-xlnx-xilinx-v14.5/include/configs/zynq_zc70x.h	2023-11-12 17:28:52.876513121 +0800
@@ -20,7 +20,7 @@
 
 #define PHYS_SDRAM_1_SIZE (1024 * 1024 * 1024)
 
-#define CONFIG_ZYNQ_SERIAL_UART1
+#define CONFIG_ZYNQ_SERIAL_UART0
 #define CONFIG_ZYNQ_GEM0
 #define CONFIG_PHY_ADDR	7

```

## 编译

```shell
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build$ mkdir u-boot
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build$ ls
u-boot

linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/u-boot-xlnx-xilinx-v14.5$ make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- O=../build/u-boot/ zynq_zc70x
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/u-boot-xlnx-xilinx-v14.5$ make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- O=../build/u-boot/

linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build/u-boot$ ls -l
total 2560
drwxrwxr-x  2 linux linux    4096 11月 12 17:38 api
drwxrwxr-x  3 linux linux    4096 11月 12 17:37 arch
drwxrwxr-x  3 linux linux    4096 11月 12 17:38 board
drwxrwxr-x  2 linux linux    4096 11月 12 17:38 common
drwxrwxr-x  2 linux linux    4096 11月 12 17:38 disk
drwxrwxr-x 26 linux linux    4096 11月 12 17:38 drivers
drwxrwxr-x  4 linux linux    4096 11月 12 17:37 examples
drwxrwxr-x 12 linux linux    4096 11月 12 17:38 fs
drwxrwxr-x  4 linux linux    4096 11月 12 17:38 include
drwxrwxr-x  2 linux linux    4096 11月 12 17:37 include2
drwxrwxr-x  6 linux linux    4096 11月 12 17:38 lib
drwxrwxr-x  2 linux linux    4096 11月 12 17:38 net
drwxrwxr-x  2 linux linux    4096 11月 12 17:38 post
-rw-rw-r--  1 linux linux   39627 11月 12 17:38 System.map
drwxrwxr-x  2 linux linux    4096 11月 12 17:38 test
drwxrwxr-x  3 linux linux    4096 11月 12 17:38 tools
-rwxrwxr-x  1 linux linux 1374821 11月 12 17:38 u-boot
-rw-rw-r--  1 linux linux  263664 11月 12 17:38 u-boot.bin
-rw-rw-r--  1 linux linux    1139 11月 12 17:38 u-boot.lds
-rw-rw-r--  1 linux linux  106272 11月 12 17:38 u-boot.map
-rw-rw-r--  1 linux linux  791146 11月 12 17:38 u-boot.srec

```

# 编译linux_xenomai内核

## 打ipipe补丁

```shell
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/linux-xlnx-xilinx-v14.5$ patch -p1 < ../xenomai-2.6.3/ksrc/arch/arm/patches/zynq/ipipe-core-3.8-zynq-pre.patch 
patching file arch/arm/common/gic.c
patching file arch/arm/kernel/smp.c
patching file arch/powerpc/kernel/fpu.S
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/linux-xlnx-xilinx-v14.5$ patch -p1 < ../ipipe/ipipe-core-3.8-arm-1.patch 
patching file arch/arm/Kconfig
patching file arch/arm/boot/compressed/decompress.c
patching file arch/arm/boot/compressed/head.S
patching file arch/arm/boot/compressed/string.c
patching file arch/arm/common/gic.c
patching file arch/arm/common/it8152.c
patching file arch/arm/common/timer-sp.c
patching file arch/arm/common/vic.c
patching file arch/arm/include/asm/Kbuild
patching file arch/arm/include/asm/assembler.h
patching file arch/arm/include/asm/atomic.h
patching file arch/arm/include/asm/bitops.h
patching file arch/arm/include/asm/bug.h
patching file arch/arm/include/asm/cacheflush.h
patching file arch/arm/include/asm/cmpxchg.h
patching file arch/arm/include/asm/entry-macro-multi.S
patching file arch/arm/include/asm/fcse.h
patching file arch/arm/include/asm/hardware/timer-sp.h
patching file arch/arm/include/asm/ipipe.h
patching file arch/arm/include/asm/ipipe_base.h
patching file arch/arm/include/asm/ipipe_hwirq.h
patching file arch/arm/include/asm/irq.h
patching file arch/arm/include/asm/irqflags.h
patching file arch/arm/include/asm/memory.h
patching file arch/arm/include/asm/mmu.h
patching file arch/arm/include/asm/mmu_context.h
patching file arch/arm/include/asm/percpu.h
patching file arch/arm/include/asm/pgtable.h
patching file arch/arm/include/asm/proc-fns.h
patching file arch/arm/include/asm/processor.h
patching file arch/arm/include/asm/resource.h
patching file arch/arm/include/asm/switch_to.h
patching file arch/arm/include/asm/thread_info.h
patching file arch/arm/include/asm/tlbflush.h
patching file arch/arm/include/asm/uaccess.h
patching file arch/arm/include/uapi/asm/mman.h
patching file arch/arm/kernel/Makefile
patching file arch/arm/kernel/arch_timer.c
patching file arch/arm/kernel/entry-armv.S
patching file arch/arm/kernel/entry-common.S
patching file arch/arm/kernel/entry-header.S
patching file arch/arm/kernel/ipipe.c
patching file arch/arm/kernel/ipipe_tsc.c
patching file arch/arm/kernel/ipipe_tsc_asm.S
patching file arch/arm/kernel/process.c
patching file arch/arm/kernel/ptrace.c
patching file arch/arm/kernel/setup.c
patching file arch/arm/kernel/signal.c
patching file arch/arm/kernel/smp.c
patching file arch/arm/kernel/smp_twd.c
patching file arch/arm/kernel/suspend.c
patching file arch/arm/kernel/traps.c
patching file arch/arm/mach-at91/Kconfig
patching file arch/arm/mach-at91/Makefile
patching file arch/arm/mach-at91/at91_ipipe.c
patching file arch/arm/mach-at91/at91_ipipe.h
patching file arch/arm/mach-at91/at91rm9200.c
patching file arch/arm/mach-at91/at91rm9200_time.c
patching file arch/arm/mach-at91/at91sam9260.c
patching file arch/arm/mach-at91/at91sam9261.c
patching file arch/arm/mach-at91/at91sam9263.c
patching file arch/arm/mach-at91/at91sam926x_time.c
patching file arch/arm/mach-at91/at91sam9g45.c
patching file arch/arm/mach-at91/at91sam9rl.c
patching file arch/arm/mach-at91/at91x40.c
patching file arch/arm/mach-at91/at91x40_time.c
patching file arch/arm/mach-at91/clock.c
patching file arch/arm/mach-at91/gpio.c
patching file arch/arm/mach-at91/include/mach/hardware.h
patching file arch/arm/mach-at91/irq.c
patching file arch/arm/mach-highbank/highbank.c
patching file arch/arm/mach-imx/3ds_debugboard.c
patching file arch/arm/mach-imx/Kconfig
patching file arch/arm/mach-imx/avic.c
patching file arch/arm/mach-imx/clk-imx1.c
patching file arch/arm/mach-imx/clk-imx21.c
patching file arch/arm/mach-imx/clk-imx25.c
patching file arch/arm/mach-imx/clk-imx27.c
patching file arch/arm/mach-imx/clk-imx31.c
patching file arch/arm/mach-imx/clk-imx35.c
patching file arch/arm/mach-imx/clk-imx51-imx53.c
patching file arch/arm/mach-imx/clk-imx6q.c
patching file arch/arm/mach-imx/common.h
patching file arch/arm/mach-imx/cpu.c
patching file arch/arm/mach-imx/mach-imx6q.c
patching file arch/arm/mach-imx/mach-mx31_3ds.c
patching file arch/arm/mach-imx/mach-mx31ads.c
patching file arch/arm/mach-imx/mm-imx1.c
patching file arch/arm/mach-imx/mm-imx25.c
patching file arch/arm/mach-imx/mm-imx27.c
patching file arch/arm/mach-imx/mm-imx3.c
patching file arch/arm/mach-imx/mm-imx5.c
patching file arch/arm/mach-imx/time.c
patching file arch/arm/mach-imx/tzic.c
patching file arch/arm/mach-integrator/common.h
patching file arch/arm/mach-integrator/core.c
patching file arch/arm/mach-integrator/include/mach/platform.h
patching file arch/arm/mach-integrator/include/mach/timex.h
patching file arch/arm/mach-integrator/integrator_cp.c
patching file arch/arm/mach-ixp4xx/common.c
patching file arch/arm/mach-ixp4xx/include/mach/platform.h
patching file arch/arm/mach-mxs/Kconfig
patching file arch/arm/mach-mxs/icoll.c
patching file arch/arm/mach-mxs/timer.c
patching file arch/arm/mach-omap2/gpmc.c
patching file arch/arm/mach-omap2/io.c
patching file arch/arm/mach-omap2/irq.c
patching file arch/arm/mach-omap2/mux.c
patching file arch/arm/mach-omap2/omap-wakeupgen.c
patching file arch/arm/mach-omap2/pm34xx.c
patching file arch/arm/mach-omap2/pm44xx.c
patching file arch/arm/mach-omap2/prm_common.c
patching file arch/arm/mach-omap2/timer.c
patching file arch/arm/mach-pxa/irq.c
patching file arch/arm/mach-pxa/lpd270.c
patching file arch/arm/mach-pxa/lubbock.c
patching file arch/arm/mach-pxa/mainstone.c
patching file arch/arm/mach-pxa/pcm990-baseboard.c
patching file arch/arm/mach-pxa/time.c
patching file arch/arm/mach-pxa/viper.c
patching file arch/arm/mach-realview/core.c
patching file arch/arm/mach-realview/core.h
patching file arch/arm/mach-realview/realview_eb.c
patching file arch/arm/mach-realview/realview_pb1176.c
patching file arch/arm/mach-realview/realview_pb11mp.c
patching file arch/arm/mach-realview/realview_pba8.c
patching file arch/arm/mach-realview/realview_pbx.c
patching file arch/arm/mach-s3c24xx/bast-irq.c
patching file arch/arm/mach-s3c24xx/irq-s3c2412.c
patching file arch/arm/mach-s3c24xx/irq-s3c2416.c
patching file arch/arm/mach-s3c24xx/irq-s3c2440.c
patching file arch/arm/mach-s3c24xx/irq-s3c2443.c
patching file arch/arm/mach-s3c24xx/irq-s3c244x.c
patching file arch/arm/mach-sa1100/irq.c
patching file arch/arm/mach-sa1100/time.c
patching file arch/arm/mach-versatile/core.c
patching file arch/arm/mach-vexpress/v2m.c
patching file arch/arm/mm/Kconfig
patching file arch/arm/mm/Makefile
patching file arch/arm/mm/alignment.c
patching file arch/arm/mm/cache-l2x0.c
patching file arch/arm/mm/context.c
patching file arch/arm/mm/copypage-v4mc.c
patching file arch/arm/mm/copypage-xscale.c
patching file arch/arm/mm/fault-armv.c
patching file arch/arm/mm/fault.c
patching file arch/arm/mm/fcse.c
patching file arch/arm/mm/flush.c
patching file arch/arm/mm/idmap.c
patching file arch/arm/mm/ioremap.c
patching file arch/arm/mm/mmap.c
patching file arch/arm/mm/pgd.c
patching file arch/arm/mm/proc-arm920.S
patching file arch/arm/mm/proc-arm926.S
patching file arch/arm/mm/proc-feroceon.S
patching file arch/arm/mm/proc-xscale.S
patching file arch/arm/plat-omap/dmtimer.c
patching file arch/arm/plat-omap/include/plat/dmtimer.h
patching file arch/arm/plat-s3c24xx/irq.c
patching file arch/arm/plat-samsung/include/plat/gpio-core.h
patching file arch/arm/plat-samsung/time.c
patching file arch/arm/plat-spear/time.c
patching file arch/arm/vfp/entry.S
patching file arch/arm/vfp/vfphw.S
patching file arch/arm/vfp/vfpmodule.c
patching file drivers/clk/mxs/clk-imx28.c
patching file drivers/gpio/gpio-mxc.c
patching file drivers/gpio/gpio-omap.c
patching file drivers/gpio/gpio-pxa.c
patching file drivers/gpio/gpio-sa1100.c
patching file drivers/irqchip/irq-versatile-fpga.c
patching file drivers/irqchip/spear-shirq.c
patching file drivers/mfd/twl4030-irq.c
patching file drivers/mfd/twl6030-irq.c
patching file drivers/misc/Kconfig
patching file drivers/staging/imx-drm/ipu-v3/ipu-common.c
patching file drivers/staging/imx-drm/ipu-v3/ipu-prv.h
patching file drivers/cpuidle/Kconfig
patching file drivers/tty/serial/8250/8250.c
patching file fs/exec.c
patching file fs/proc/array.c
patching file include/asm-generic/atomic.h
patching file include/asm-generic/bitops/atomic.h
patching file include/asm-generic/cmpxchg-local.h
patching file include/asm-generic/percpu.h
patching file include/ipipe/setup.h
patching file include/ipipe/thread_info.h
patching file include/linux/clockchips.h
patching file include/linux/clocksource.h
patching file include/linux/ftrace.h
patching file include/linux/hardirq.h
patching file include/linux/i8253.h
patching file include/linux/ipipe.h
patching file include/linux/ipipe_base.h
patching file include/linux/ipipe_compat.h
patching file include/linux/ipipe_debug.h
patching file include/linux/ipipe_domain.h
patching file include/linux/ipipe_lock.h
patching file include/linux/ipipe_tickdev.h
patching file include/linux/ipipe_trace.h
patching file include/linux/irq.h
patching file include/linux/irqdesc.h
patching file include/linux/irqnr.h
patching file include/linux/kernel.h
patching file include/linux/kvm_host.h
patching file include/linux/preempt.h
patching file include/linux/rwlock.h
patching file include/linux/rwlock_api_smp.h
patching file include/linux/sched.h
patching file include/linux/spinlock.h
patching file include/linux/spinlock_api_smp.h
patching file include/linux/spinlock_up.h
patching file include/uapi/asm-generic/mman-common.h
patching file include/uapi/asm-generic/resource.h
patching file include/uapi/linux/resource.h
patching file init/Kconfig
patching file init/main.c
patching file kernel/Makefile
patching file kernel/debug/debug_core.c
patching file kernel/debug/gdbstub.c
patching file kernel/exit.c
patching file kernel/fork.c
patching file kernel/ipipe/Kconfig
patching file kernel/ipipe/Kconfig.debug
patching file kernel/ipipe/Makefile
patching file kernel/ipipe/compat.c
patching file kernel/ipipe/core.c
patching file kernel/ipipe/timer.c
patching file kernel/ipipe/tracer.c
patching file kernel/irq/chip.c
patching file kernel/irq/generic-chip.c
patching file kernel/irq/irqdesc.c
patching file kernel/irq/manage.c
patching file kernel/lockdep.c
patching file kernel/panic.c
patching file kernel/power/hibernate.c
patching file kernel/printk.c
patching file kernel/sched/clock.c
patching file kernel/sched/core.c
patching file kernel/signal.c
patching file kernel/spinlock.c
patching file kernel/time/clockevents.c
patching file kernel/time/clocksource.c
patching file kernel/time/tick-common.c
patching file kernel/time/tick-sched.c
patching file kernel/timer.c
patching file kernel/trace/Kconfig
patching file kernel/trace/ftrace.c
patching file kernel/trace/trace.c
patching file kernel/trace/trace_clock.c
patching file kernel/trace/trace_functions.c
patching file kernel/trace/trace_functions_graph.c
patching file lib/Kconfig.debug
patching file lib/atomic64.c
patching file lib/bust_spinlocks.c
patching file lib/ioremap.c
patching file lib/smp_processor_id.c
patching file mm/Kconfig
patching file mm/memory.c
patching file mm/mlock.c
patching file mm/mmap.c
patching file mm/mmu_context.c
patching file mm/mprotect.c
patching file mm/vmalloc.c
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/linux-xlnx-xilinx-v14.5$ patch -p1 < ../xenomai-2.6.3/ksrc/arch/arm/patches/zynq/ipipe-core-3.8-zynq-post.patch 
patching file arch/arm/common/gic.c
patching file arch/arm/mach-zynq/Kconfig
patching file arch/arm/mach-zynq/timer.c
patching file drivers/gpio/gpio-xilinxps.c

```

## 合并xenomai内核代码到linux内核

```shell
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/xenomai-2.6.3$ ./scripts/prepare-kernel.sh --arch=arm --linux=/home/linux/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/linux-xlnx-xilinx-v14.5
```

## 修改

### 编译错误修改

linux-xlnx-xilinx-v14.5/kernel/timeconst.pl，此文件不过，所以需要修改：

```shell
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ diff bkup/linux-xlnx-xilinx-v14.5/kernel/timeconst.pl linux-xlnx-xilinx-v14.5/kernel/timeconst.pl  -ur
--- bkup/linux-xlnx-xilinx-v14.5/kernel/timeconst.pl	2013-04-04 13:48:14.000000000 +0800
+++ linux-xlnx-xilinx-v14.5/kernel/timeconst.pl	2023-11-12 17:51:05.351827690 +0800
@@ -370,7 +370,7 @@
 	}
 
 	@val = @{$canned_values{$hz}};
-	if (!defined(@val)) {
+	if (!(@val)) {
 		@val = compute_values($hz);
 	}
 	output($hz, @val);

```

### 设备树

linux-xlnx-xilinx-v14.5/arch/arm/boot/dts/zynq-zc702.dts：

```diff
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ diff bkup/linux-xlnx-xilinx-v14.5/arch/arm/boot/dts/zynq-zc702.dts linux-xlnx-xilinx-v14.5/arch/arm/boot/dts/zynq-zc702.dts -ur
--- bkup/linux-xlnx-xilinx-v14.5/arch/arm/boot/dts/zynq-zc702.dts	2013-04-04 13:48:14.000000000 +0800
+++ linux-xlnx-xilinx-v14.5/arch/arm/boot/dts/zynq-zc702.dts	2023-11-17 23:15:03.567582464 +0800
@@ -12,8 +12,9 @@
 		reg = <0x00000000 0x40000000>;
 	};
 	chosen {
-		bootargs = "console=ttyPS0,115200 root=/dev/ram rw ip=:::::eth0:dhcp earlyprintk";
-		linux,stdout-path = "/amba@0/uart@E0001000";
+		//bootargs = "console=ttyPS0,115200 root=/dev/ram rw ip=:::::eth0:dhcp earlyprintk";
+		bootargs = "console=ttyPS0,115200 root=/dev/ram rw ip=:::::eth0:192.168.1.10 earlyprintk";
+		linux,stdout-path = "/amba@0/uart@E0000000";
 	};
 
 	pmu {
@@ -56,6 +57,13 @@
 			reg = <0xfffc0000 0x40000>; /* 256k */
 		};
 
+        uart@e0000000 {
+            compatible = "xlnx,ps7-uart-1.00.a";
+            reg = <0xE0000000 0x1000>;
+            interrupts = <0 27 4>;
+			interrupt-parent = <&gic>;
+            clock = <50000000>;
+        };
 		uart@e0001000 {
 			compatible = "xlnx,ps7-uart-1.00.a";
 			reg = <0xe0001000 0x1000>;

```

## 编译

```shell
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build$ mkdir linux
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build$ ls
linux  u-boot

```

设置`mkimage`路径：

```shell
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build/u-boot/tools$ export PATH=`pwd`:$PATH
```

```shell
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/linux-xlnx-xilinx-v14.5$ make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- O=../build/linux/ xilinx_zynq_defconfig
  HOSTCC  scripts/basic/fixdep
  GEN     /home/linux/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build/linux/Makefile
  HOSTCC  scripts/kconfig/conf.o
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/zconf.lex.c
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
In file included from scripts/kconfig/zconf.tab.c:2503:0:
/home/linux/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/linux-xlnx-xilinx-v14.5/scripts/kconfig/menu.c: In function ‘get_symbol_str’:
/home/linux/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/linux-xlnx-xilinx-v14.5/scripts/kconfig/menu.c:561:18: warning: ‘jump’ may be used uninitialized in this function [-Wmaybe-uninitialized]
     jump->offset = r->len - 1;
                  ^
/home/linux/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/linux-xlnx-xilinx-v14.5/scripts/kconfig/menu.c:515:19: note: ‘jump’ was declared here
  struct jump_key *jump;
                   ^
  HOSTLD  scripts/kconfig/conf
#
# configuration written to .config
#

linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/linux-xlnx-xilinx-v14.5$ make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- O=../build/linux/ menuconfig
  GEN     /home/linux/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build/linux/Makefile
  HOSTCC  scripts/kconfig/lxdialog/checklist.o
  HOSTCC  scripts/kconfig/lxdialog/inputbox.o
  HOSTCC  scripts/kconfig/lxdialog/menubox.o
  HOSTCC  scripts/kconfig/lxdialog/textbox.o
  HOSTCC  scripts/kconfig/lxdialog/util.o
  HOSTCC  scripts/kconfig/lxdialog/yesno.o
  HOSTCC  scripts/kconfig/mconf.o
  HOSTLD  scripts/kconfig/mconf
scripts/kconfig/mconf Kconfig
#
# configuration written to .config
#


*** End of the configuration.
*** Execute 'make' to start the build or try 'make help'.

```

`menuconfig`选择如下：

```
    General setup  --->
        Timers subsystem  --->
            [ ] Tickless System (Dynamic Ticks)
    Kernel hacking  --->
        [*] Kernel low-level debugging functions (read help!)
                Kernel low-level debugging port (Kernel low-level debugging on Xilinx Zynq using UART0)  --->
    Kernel Features  --->
        Preemption Model (Preemptible Kernel (Low-Latency Desktop))  --->
    CPU Power Management  --->
        CPU Frequency scaling  --->
            [ ] CPU Frequency scaling
    Device Drivers  --->
        [*] DMA Engine support  --->
            < >   DMA Test client
```

```shell
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/linux-xlnx-xilinx-v14.5$ make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- O=../build/linux/ uImage UIMAGE_LOADADDR=0x8000
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/linux-xlnx-xilinx-v14.5$ make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- O=../build/linux/ dtbs

```

# 编译xenomai

```shell
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build$ mkdir xenomai-2.6.3
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/xenomai-2.6.3$ ./configure --prefix=~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build/xenomai-2.6.3 CFLAGS="-march=armv7-a -mfpu=vfp3" LDFLAGS="-march=armv7-a -mfpu=vfp3" --host=arm-xilinx-linux-gnueabi --enable-smp
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/xenomai-2.6.3$ make
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/xenomai-2.6.3$ make install

```

# 打包

## 生成BOOT.bin

略。。。

## 打包到SD卡

插入SD卡：

```shell
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build$ df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            3.9G     0  3.9G   0% /dev
tmpfs           796M   66M  731M   9% /run
/dev/sda1        95G   44G   47G  49% /
tmpfs           3.9G  172K  3.9G   1% /dev/shm
tmpfs           5.0M  4.0K  5.0M   1% /run/lock
tmpfs           3.9G     0  3.9G   0% /sys/fs/cgroup
/dev/loop0       74M   74M     0 100% /snap/core22/858
/dev/loop2       23M   23M     0 100% /snap/nvim/2809
/dev/loop3      304M  304M     0 100% /snap/code/144
/dev/loop4       21M   21M     0 100% /snap/nvim/2797
/dev/loop5       41M   41M     0 100% /snap/snapd/20290
/dev/loop6       64M   64M     0 100% /snap/core20/2015
/dev/loop7       74M   74M     0 100% /snap/core22/864
/dev/loop8       41M   41M     0 100% /snap/snapd/20092
tmpfs           796M   68K  796M   1% /run/user/1000
/dev/loop9      304M  304M     0 100% /snap/code/146
vmhgfs-fuse     932G  377G  555G  41% /mnt/hgfs
/dev/sdb1        99M   25M   75M  25% /media/linux/boot
/dev/sdb2        29G  298M   27G   2% /media/linux/rootfs

```

```shell
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build$ cp BOOT-xenomai.bin /media/linux/boot/BOOT.BIN
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build$ cp linux/arch/arm/boot/uImage /media/linux/boot/uImage
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build$ cp linux/arch/arm/boot/dts/zynq-zc702.dtb /media/linux/boot/devicetree.dtb

```

### 打包xenomai用户空间库到rootfs

```shell
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ ls
arm_ramdisk.image.gz  bkup  build  ipipe  linux-xlnx-xilinx-v14.5  u-boot-xlnx-xilinx-v14.5  xenomai-2.6.3
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ mv arm_ramdisk.image.gz ramdisk.image.gz
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ ls
bkup  build  ipipe  linux-xlnx-xilinx-v14.5  ramdisk.image.gz  u-boot-xlnx-xilinx-v14.5  xenomai-2.6.3
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ gunzip ramdisk.image.gz
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ ls
bkup  build  ipipe  linux-xlnx-xilinx-v14.5  ramdisk.image  u-boot-xlnx-xilinx-v14.5  xenomai-2.6.3
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ chmod u+rwx ramdisk.image
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ mkdir tmp_mnt/
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ ls
bkup  build  ipipe  linux-xlnx-xilinx-v14.5  ramdisk.image  tmp_mnt  u-boot-xlnx-xilinx-v14.5  xenomai-2.6.3
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ sudo mount -o loop ramdisk.image tmp_mnt/
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ cd tmp_mnt/
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/tmp_mnt$ ls
bin  dev  etc  home  lib  licenses  linuxrc  lost+found  mnt  opt  proc  README  root  sbin  sys  tmp  update_qspi.sh  usr  var
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/tmp_mnt$ cd ..
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ ls
bkup  build  ipipe  linux-xlnx-xilinx-v14.5  ramdisk.image  tmp_mnt  u-boot-xlnx-xilinx-v14.5  xenomai-2.6.3

linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build$ sudo cp xenomai-2.6.3/lib/lib*.so* ../tmp_mnt/lib/ -d

linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ sudo umount tmp_mnt/
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ gzip ramdisk.image
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ mkimage -A arm -T ramdisk -C gzip -d ramdisk.image.gz build/uramdisk.image.gz
Image Name:   
Created:      Fri Nov 17 22:41:53 2023
Image Type:   ARM Linux RAMDisk Image (gzip compressed)
Data Size:    5310030 Bytes = 5185.58 kB = 5.06 MB
Load Address: 00000000
Entry Point:  00000000

linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz$ cd build/
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build$ ls
BOOT-xenomai.bin  linux  u-boot  uramdisk.image.gz  xenomai-2.6.3

```

```shell
linux@linux-virtual-machine:~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build$ cp uramdisk.image.gz /media/linux/boot/uramdisk.image.gz
```

# 在板子运行xeno基准测试

将`~/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build/xenomai-2.6.3/bin`复制到开发版`tmp`目录下：

```shell
zynq> pwd
/tmp
zynq> ls
bin
zynq> cd bin/
zynq> ls
arith                  insn_read              sched-tp
check-vdso             insn_write             switchtest
clocktest              irqloop                wakeup-time
cmd_bits               klatency               wf_generate
cmd_read               latency                wrap-link.sh
cmd_write              mutex-torture-native   xeno
cond-torture-native    mutex-torture-posix    xeno-config
cond-torture-posix     regression             xeno-regression-test
cyclictest             rtcanrecv              xeno-test
dohell                 rtcansend              xeno-test-run
insn_bits              rtdm                   xeno-test-run-wrapper
zynq> chmod +x *

zynq> mkdir -p /home/linux/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build/xenomai-2.6.3
zynq> cd /home/linux/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build/xenomai-2.6.3/
zynq> pwd
/home/linux/workspace/xenomai-2.6.3/xilinx_zynq7020_zdyz/build/xenomai-2.6.3
zynq> ln -s /tmp/bin/ bin
zynq> ./bin/xeno-test latency
```

等待测试运行完成，大概15分钟。

# 附录

[^1]: https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_SDK_2013.1_0411_1.tar "Software Development Kit - 2013.1 Full Product Installation"
[^2]:  https://github.com/Xilinx/u-boot-xlnx/tree/xilinx-v14.5 "Xilinx/u-boot-xlnx at xilinx-v14.5"
[^3]: https://github.com/Xilinx/linux-xlnx/tree/xilinx-v14.5 "Xilinx/linux-xlnx at xilinx-v14.5"
[^4]: https://ftp.denx.de/pub/xenomai/xenomai/stable/ "Index of /pub/xenomai/xenomai/stable/"
[^5]: https://ftp.denx.de/pub/xenomai/ipipe/v3.x/arm/older/ "Index of /pub/xenomai/ipipe/v3.x/arm/older/"
[^6]: https://xilinx-wiki.atlassian.net/wiki/download/attachments/18842473/arm_ramdisk.image.gz?version=1&modificationDate=1536675884034&cacheVersion=1&api=v2 "arm_ramdisk.image.gz"