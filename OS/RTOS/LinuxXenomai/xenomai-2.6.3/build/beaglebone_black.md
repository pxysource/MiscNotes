# 1 准备

- 系统：`Ubuntu 16.04`
- 交叉编译工具链：`gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf.tar.xz`[^1]
- linux内核源码：`linux-3.8.13-bone86`[^2]
- xenomai：`xenomai-2.6.3`[^3]

- BeagleBone Black SD卡固件：`Debian 7.11 2016-06-15 4GB SD LXDE`[^4]

```shell
linux@linux-virtual-machine:~/workspace/beaglebone_black/xenomai_2.6.3_project$ ls -l
total 233784
-rwxrwxrwx 1 linux linux  80881572 9月  21 00:06 gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf.tar.xz
-rwxrwxrwx 1 linux linux 136213054 9月  20 23:03 linux-3.8.13-bone86.zip
-rwxrwxrwx 1 linux linux  22289867 9月  20 23:03 xenomai-2.6.3.tar.bz2

```

# 2 准备linux+xenomai

## 2.1 linux内核打ipipe补丁

如何打补丁可参考`xenomai-2.6.3/ksrc/arch/arm/patches/README`

```shell
linux@linux-virtual-machine:~/workspace/beaglebone_black/xenomai_2.6.3_project$ cd linux-3.8.13-bone86/
```

-----------------------------------

`patch -p1 < ../xenomai-2.6.3/ksrc/arch/arm/patches/beaglebone/ipipe-core-3.8.13-beaglebone-pre.patch`：

```shell
linux@linux-virtual-machine:~/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86$ patch -p1 < ../xenomai-2.6.3/ksrc/arch/arm/patches/beaglebone/ipipe-core-3.8.13-beaglebone-pre.patch 
patching file arch/arm/mach-omap2/gpmc.c

```

----------------------------------------------

`patch -p1 < ../xenomai-2.6.3/ksrc/arch/arm/patches/ipipe-core-3.8.13-arm-3.patch`

```shell
linux@linux-virtual-machine:~/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86$ patch -p1 < ../xenomai-2.6.3/ksrc/arch/arm/patches/ipipe-core-3.8.13-arm-3.patch 
patching file arch/arm/Kconfig
Hunk #4 succeeded at 961 (offset 1 line).
Hunk #5 succeeded at 1172 (offset 1 line).
Hunk #6 succeeded at 1661 (offset 1 line).
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
Hunk #2 succeeded at 1711 (offset 471 lines).
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
Hunk #1 succeeded at 286 with fuzz 2 (offset 40 lines).
Hunk #2 succeeded at 351 (offset 19 lines).
Hunk #3 succeeded at 574 (offset 19 lines).
Hunk #4 succeeded at 838 (offset 19 lines).
patching file arch/arm/plat-omap/include/plat/dmtimer.h
Hunk #2 succeeded at 413 (offset 1 line).
patching file arch/arm/plat-s3c24xx/irq.c
patching file arch/arm/plat-samsung/include/plat/gpio-core.h
patching file arch/arm/plat-samsung/time.c
patching file arch/arm/plat-spear/time.c
patching file arch/arm/vfp/entry.S
patching file arch/arm/vfp/vfphw.S
patching file arch/arm/vfp/vfpmodule.c
patching file drivers/clk/mxs/clk-imx28.c
patching file drivers/gpio/gpio-mxc.c
patching file drivers/gpio/gpio-mxs.c
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
Hunk #4 succeeded at 2492 (offset 7 lines).
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

```

----------------------

`patch -p1 < ../xenomai-2.6.3/ksrc/arch/arm/patches/beaglebone/ipipe-core-3.8.13-beaglebone-post.patch`：

```shell
linux@linux-virtual-machine:~/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86$ patch -p1 < ../xenomai-2.6.3/ksrc/arch/arm/patches/beaglebone/ipipe-core-3.8.13-beaglebone-post.patch 
patching file arch/arm/mach-omap2/gpmc.c

```

## 2.2 xenomai内核代码合并到linux内核

```shell
linux@linux-virtual-machine:~/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86$ cd ../xenomai-2.6.3/
linux@linux-virtual-machine:~/workspace/beaglebone_black/xenomai_2.6.3_project/xenomai-2.6.3$ ./scripts/prepare-kernel.sh --arch=arm --linux=/home/linux/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86
```

# 3 编译linux内核

```shell
linux@linux-virtual-machine:~/workspace/beaglebone_black/xenomai_2.6.3_project/xenomai-2.6.3$ cd ../linux-3.8.13-bone86/
```
##  3.1 配置

修改`arch/arm/configs/bb.org_defconfig`：

- 禁用`CONFIG_NO_HZ`

  ```shell
  linux@linux-virtual-machine:~/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86$ vi arch/arm/configs/bb.org_defconfig
  ```
  `bb.org_defconfig`文件中，`CONFIG_NO_HZ=y`改为`# CONFIG_NO_HZ is not set`：
  
  ```shell
  # CONFIG_NO_HZ is not set
  ```
  

`make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bb.org_defconfig`：

```shell
linux@linux-virtual-machine:~/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bb.org_defconfig
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/kconfig/conf.o
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/zconf.lex.c
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
In file included from scripts/kconfig/zconf.tab.c:2503:0:
scripts/kconfig/menu.c: In function ‘get_symbol_str’:
scripts/kconfig/menu.c:561:18: warning: ‘jump’ may be used uninitialized in this function [-Wmaybe-uninitialized]
     jump->offset = r->len - 1;
                  ^
scripts/kconfig/menu.c:515:19: note: ‘jump’ was declared here
  struct jump_key *jump;
                   ^
  HOSTLD  scripts/kconfig/conf
drivers/video/Kconfig:60:error: recursive dependency detected!
drivers/video/Kconfig:60:	symbol FB is selected by DRM_KMS_HELPER
drivers/gpu/drm/Kconfig:28:	symbol DRM_KMS_HELPER is selected by DRM_TILCDC
drivers/gpu/drm/tilcdc/Kconfig:1:	symbol DRM_TILCDC depends on BACKLIGHT_LCD_SUPPORT
drivers/video/backlight/Kconfig:5:	symbol BACKLIGHT_LCD_SUPPORT is selected by FB_BACKLIGHT
drivers/video/Kconfig:247:	symbol FB_BACKLIGHT is selected by PMAC_BACKLIGHT
drivers/macintosh/Kconfig:134:	symbol PMAC_BACKLIGHT depends on FB
warning: (USB_MUSB_HDRC) selects TWL6030_USB which has unmet direct dependencies (USB_SUPPORT && (USB || USB_GADGET) && TWL4030_CORE && OMAP_USB2 && USB_MUSB_OMAP2PLUS)
warning: (DVB_USB_PCTV452E) selects TTPCI_EEPROM which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_PCI_SUPPORT && MEDIA_DIGITAL_TV_SUPPORT && I2C)
warning: (USB_MUSB_HDRC) selects TWL6030_USB which has unmet direct dependencies (USB_SUPPORT && (USB || USB_GADGET) && TWL4030_CORE && OMAP_USB2 && USB_MUSB_OMAP2PLUS)
warning: (DVB_USB_PCTV452E) selects TTPCI_EEPROM which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_PCI_SUPPORT && MEDIA_DIGITAL_TV_SUPPORT && I2C)
#
# configuration written to .config
#

```

--------------------

`make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig`：

```shell
linux@linux-virtual-machine:~/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
```

由menuconfig配置内容如下：

```
Real-time sub-system  ---> 
    Drivers  ---> 
        Testing drivers  ---> 
            <*> Timer benchmark driver 
            <M>   Kernel-only latency measurement module
            <*> IRQ benchmark driver
            <*> Context switch unit testing driver 
            <M> RTDM unit tests driver
Kernel Features  --->
    - Preemption Model : select "Preemptible Kernel (Low-Latency Desktop)"
CPU Power Management  --->
    - [] CPU Frequency scaling : Disable
```

## 3.2 编译zImage与设备树

`make -j8 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage dtbs`：

```shell
linux@linux-virtual-machine:~/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86$ make -j8 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage dtbs

# ...

WARNING: modpost: Found 2 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  KSYM    .tmp_kallsyms1.o
  KSYM    .tmp_kallsyms2.o
  LD      vmlinux
  SORTEX  vmlinux
sort done marker at 8f8b40
  SYSMAP  System.map
  OBJCOPY arch/arm/boot/Image
  Kernel: arch/arm/boot/Image is ready
  AS      arch/arm/boot/compressed/head.o
  LZO     arch/arm/boot/compressed/piggy.lzo
  CC      arch/arm/boot/compressed/misc.o
  CC      arch/arm/boot/compressed/decompress.o
  CC      arch/arm/boot/compressed/string.o
  SHIPPED arch/arm/boot/compressed/lib1funcs.S
  SHIPPED arch/arm/boot/compressed/ashldi3.S
  AS      arch/arm/boot/compressed/lib1funcs.o
  AS      arch/arm/boot/compressed/ashldi3.o
  AS      arch/arm/boot/compressed/piggy.lzo.o
  LD      arch/arm/boot/compressed/vmlinux
  OBJCOPY arch/arm/boot/zImage
  Kernel: arch/arm/boot/zImage is ready

```

## 3.3 编译模块

`make -j8 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules`

```shell
linux@linux-virtual-machine:~/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86$ make -j8 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules

# ...

  IHEX2FW firmware/emi26/loader.fw
  IHEX2FW firmware/emi62/spdif.fw
  IHEX2FW firmware/emi26/firmware.fw
  IHEX2FW firmware/emi62/bitstream.fw
  IHEX    firmware/kaweth/new_code.bin
  IHEX2FW firmware/emi62/midi.fw
  IHEX2FW firmware/emi62/loader.fw
  IHEX2FW firmware/emi26/bitstream.fw
  IHEX    firmware/kaweth/trigger_code.bin
  IHEX    firmware/kaweth/new_code_fix.bin
  IHEX    firmware/kaweth/trigger_code_fix.bin
  IHEX    firmware/ti_3410.fw
  IHEX    firmware/ti_5052.fw
  H16TOFW firmware/edgeport/boot.fw
  H16TOFW firmware/edgeport/boot2.fw
  IHEX    firmware/mts_edge.fw
  IHEX    firmware/mts_gsm.fw
  IHEX    firmware/mts_cdma.fw
  H16TOFW firmware/edgeport/down.fw
  H16TOFW firmware/edgeport/down2.fw
  IHEX    firmware/edgeport/down3.bin
  IHEX2FW firmware/whiteheat_loader.fw
  IHEX2FW firmware/keyspan_pda/keyspan_pda.fw
  IHEX2FW firmware/keyspan_pda/xircom_pgs.fw
  IHEX2FW firmware/whiteheat.fw
  IHEX    firmware/yam/1200.bin
  IHEX    firmware/cpia2/stv0672_vp4.bin
  IHEX    firmware/yam/9600.bin

```

# 4 打包固件到SD卡

## 4.1 写入原始固件

将BeagleBone Black SD卡固件写入SD中，参考[SD卡启动系统](SD卡启动系统.md)。

将SD插入PC，并连接到开发系统（虚拟机Ubuntu），此时，在`/media/linux/rootfs`下可以看到根文件系统已经挂载。由于写入的根文件大小就是3.2G，所以即使SD卡是32GB的也不会显示32GB。

```shell
linux@linux-virtual-machine:~/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86$ df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            3.9G     0  3.9G   0% /dev
tmpfs           796M   82M  714M  11% /run
/dev/sda1        95G   63G   28G  70% /
tmpfs           3.9G  184K  3.9G   1% /dev/shm
tmpfs           5.0M  4.0K  5.0M   1% /run/lock
tmpfs           3.9G     0  3.9G   0% /sys/fs/cgroup
/dev/loop0       74M   74M     0 100% /snap/core22/858
/dev/loop1       41M   41M     0 100% /snap/snapd/20092
/dev/loop3       23M   23M     0 100% /snap/nvim/2809
/dev/loop2       41M   41M     0 100% /snap/snapd/19993
/dev/loop4      304M  304M     0 100% /snap/code/140
/dev/loop5       74M   74M     0 100% /snap/core22/864
/dev/loop6       64M   64M     0 100% /snap/core20/2015
/dev/loop7       21M   21M     0 100% /snap/nvim/2797
tmpfs           796M   84K  796M   1% /run/user/1000
vmhgfs-fuse     932G  386G  546G  42% /mnt/hgfs/Ubuntu_64_16_4_Share
/dev/sdb1       3.3G  2.0G  1.1G  64% /media/linux/rootfs

```

## 4.2 复制zImage和dtb到SD卡rootfs

`sudo cp -v ./arch/arm/boot/zImage /media/linux/rootfs/boot/vmlinuz-3.8.13-bone80`：

```shell
linux@linux-virtual-machine:~/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86$ sudo cp -v ./arch/arm/boot/zImage /media/linux/rootfs/boot/vmlinuz-3.8.13-bone80
[sudo] password for linux: 
'./arch/arm/boot/zImage' -> '/media/linux/rootfs/boot/vmlinuz-3.8.13-bone80'

```

`sudo cp -v ./arch/arm/boot/dts/am335x* /media/linux/rootfs/boot/dtbs/3.8.13-bone80/`：

```shell
linux@linux-virtual-machine:~/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86$ sudo cp -v ./arch/arm/boot/dts/am335x* /media/linux/rootfs/boot/dtbs/3.8.13-bone80/
'./arch/arm/boot/dts/am335x-boneblack.dtb' -> '/media/linux/rootfs/boot/dtbs/3.8.13-bone80/am335x-boneblack.dtb'
'./arch/arm/boot/dts/am335x-boneblack.dts' -> '/media/linux/rootfs/boot/dtbs/3.8.13-bone80/am335x-boneblack.dts'
'./arch/arm/boot/dts/am335x-boneblack-wireless.dtb' -> '/media/linux/rootfs/boot/dtbs/3.8.13-bone80/am335x-boneblack-wireless.dtb'
'./arch/arm/boot/dts/am335x-boneblack-wireless.dts' -> '/media/linux/rootfs/boot/dtbs/3.8.13-bone80/am335x-boneblack-wireless.dts'
'./arch/arm/boot/dts/am335x-bone-common.dtsi' -> '/media/linux/rootfs/boot/dtbs/3.8.13-bone80/am335x-bone-common.dtsi'
'./arch/arm/boot/dts/am335x-bone.dtb' -> '/media/linux/rootfs/boot/dtbs/3.8.13-bone80/am335x-bone.dtb'
'./arch/arm/boot/dts/am335x-bone.dts' -> '/media/linux/rootfs/boot/dtbs/3.8.13-bone80/am335x-bone.dts'
'./arch/arm/boot/dts/am335x-bonegreen.dtb' -> '/media/linux/rootfs/boot/dtbs/3.8.13-bone80/am335x-bonegreen.dtb'
'./arch/arm/boot/dts/am335x-bonegreen.dts' -> '/media/linux/rootfs/boot/dtbs/3.8.13-bone80/am335x-bonegreen.dts'
'./arch/arm/boot/dts/am335x-bonegreen-wireless.dtb' -> '/media/linux/rootfs/boot/dtbs/3.8.13-bone80/am335x-bonegreen-wireless.dtb'
'./arch/arm/boot/dts/am335x-bonegreen-wireless.dts' -> '/media/linux/rootfs/boot/dtbs/3.8.13-bone80/am335x-bonegreen-wireless.dts'
'./arch/arm/boot/dts/am335x-evm.dtb' -> '/media/linux/rootfs/boot/dtbs/3.8.13-bone80/am335x-evm.dtb'
'./arch/arm/boot/dts/am335x-evm.dts' -> '/media/linux/rootfs/boot/dtbs/3.8.13-bone80/am335x-evm.dts'
'./arch/arm/boot/dts/am335x-evmsk.dtb' -> '/media/linux/rootfs/boot/dtbs/3.8.13-bone80/am335x-evmsk.dtb'
'./arch/arm/boot/dts/am335x-evmsk.dts' -> '/media/linux/rootfs/boot/dtbs/3.8.13-bone80/am335x-evmsk.dts'
'./arch/arm/boot/dts/am335x-siriusDEB.dtb' -> '/media/linux/rootfs/boot/dtbs/3.8.13-bone80/am335x-siriusDEB.dtb'
'./arch/arm/boot/dts/am335x-siriusDEB.dts' -> '/media/linux/rootfs/boot/dtbs/3.8.13-bone80/am335x-siriusDEB.dts'
'./arch/arm/boot/dts/am335x-tester.dtb' -> '/media/linux/rootfs/boot/dtbs/3.8.13-bone80/am335x-tester.dtb'
'./arch/arm/boot/dts/am335x-tester.dts' -> '/media/linux/rootfs/boot/dtbs/3.8.13-bone80/am335x-tester.dts'

```

## 4.3 安装headers

```shell
linux@linux-virtual-machine:~/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86$ sudo -i
root@linux-virtual-machine:~# cd /home/linux/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86/

```

`make -j8 ARCH=arm headers_check`：

```shell
root@linux-virtual-machine:/home/linux/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86# make -j8 ARCH=arm headers_check
  CHK     include/generated/uapi/linux/version.h
  HOSTCC  scripts/unifdef
  INSTALL include/asm-generic (35 files)
  INSTALL include/rdma (6 files)
  INSTALL include/mtd (5 files)
  INSTALL include/scsi/fc (4 files)
  INSTALL include/drm (15 files)
  INSTALL include/sound (10 files)
  INSTALL include/video (3 files)
  INSTALL include/linux/byteorder (2 files)
  INSTALL include/xen (2 files)
  INSTALL include/uapi (0 file)
  INSTALL include/linux/caif (2 files)
  INSTALL include/scsi (3 files)
  INSTALL include/linux/can (5 files)
  INSTALL include/linux/dvb (8 files)
  INSTALL include/linux/hdlc (1 file)
  INSTALL include/linux/hsi (1 file)
  INSTALL include/linux/isdn (1 file)
  INSTALL include/linux/mmc (1 file)
  INSTALL include/linux/netfilter/ipset (4 files)
  INSTALL include/linux/netfilter_bridge (18 files)
  INSTALL include/linux/netfilter_arp (2 files)
  INSTALL include/linux/netfilter_ipv4 (10 files)
  INSTALL include/linux/netfilter_ipv6 (12 files)
  INSTALL include/linux/nfsd (5 files)
  INSTALL include/linux/netfilter (76 files)
  INSTALL include/linux/raid (2 files)
  INSTALL include/linux/spi (1 file)
  INSTALL include/linux/sunrpc (1 file)
  INSTALL include/linux/tc_act (7 files)
  INSTALL include/linux/usb (10 files)
  INSTALL include/linux/wimax (1 file)
  INSTALL include/linux/tc_ematch (4 files)
  INSTALL include/linux (380 files)
  INSTALL include/asm (33 files)
  CHECK   include/asm-generic (35 files)
  CHECK   include/video (3 files)
  CHECK   include/drm (15 files)
  CHECK   include/mtd (5 files)
  CHECK   include/rdma (6 files)
  CHECK   include/sound (10 files)
  CHECK   include/linux/byteorder (2 files)
  CHECK   include/scsi/fc (4 files)
  CHECK   include/uapi (0 files)
  CHECK   include/xen (2 files)
  CHECK   include/linux/caif (2 files)
  CHECK   include/linux/can (5 files)
  CHECK   include/scsi (3 files)
  CHECK   include/linux/dvb (8 files)
  CHECK   include/linux/hdlc (1 files)
  CHECK   include/linux/hsi (1 files)
  CHECK   include/linux/isdn (1 files)
  CHECK   include/linux/netfilter/ipset (4 files)
  CHECK   include/linux/netfilter_arp (2 files)
  CHECK   include/linux/netfilter_bridge (18 files)
  CHECK   include/linux/mmc (1 files)
  CHECK   include/linux/netfilter_ipv6 (12 files)
  CHECK   include/linux/netfilter_ipv4 (10 files)
  CHECK   include/linux/raid (2 files)
  CHECK   include/linux/spi (1 files)
  CHECK   include/linux/nfsd (5 files)
  CHECK   include/linux/netfilter (76 files)
  CHECK   include/linux/sunrpc (1 files)
  CHECK   include/linux/tc_act (7 files)
  CHECK   include/linux/tc_ematch (4 files)
  CHECK   include/linux/usb (10 files)
  CHECK   include/linux (380 files)
  CHECK   include/linux/wimax (1 files)
/home/linux/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86/usr/include/linux/kexec.h:49: userspace cannot reference function or variable defined in the kernel
/home/linux/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86/usr/include/linux/soundcard.h:1054: userspace cannot reference function or variable defined in the kernel
  CHECK   include/asm (33 files)

```

`make -j8 ARCH=arm INSTALL_HDR_PATH=/media/linux/rootfs/ headers_install`：

```shell
root@linux-virtual-machine:/home/linux/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86# make -j8 ARCH=arm INSTALL_HDR_PATH=/media/linux/rootfs/ headers_install
  CHK     include/generated/uapi/linux/version.h
  INSTALL include/mtd (5 files)
  INSTALL include/rdma (6 files)
  INSTALL include/sound (10 files)
  INSTALL include/xen (2 files)
  INSTALL include/scsi (3 files)
  INSTALL include/scsi/fc (4 files)
  INSTALL include/drm (15 files)
  INSTALL include/asm-generic (35 files)
  INSTALL include/video (3 files)
  INSTALL include/linux/can (5 files)
  INSTALL include/linux/caif (2 files)
  INSTALL include/linux/byteorder (2 files)
  INSTALL include/linux/isdn (1 file)
  INSTALL include/linux/hdlc (1 file)
  INSTALL include/linux/hsi (1 file)
  INSTALL include/linux/dvb (8 files)
  INSTALL include/linux/mmc (1 file)
  INSTALL include/linux/netfilter_ipv6 (12 files)
  INSTALL include/linux/netfilter_ipv4 (10 files)
  INSTALL include/linux/nfsd (5 files)
  INSTALL include/linux/netfilter_bridge (18 files)
  INSTALL include/linux/netfilter_arp (2 files)
  INSTALL include/linux/spi (1 file)
  INSTALL include/linux/raid (2 files)
  INSTALL include/linux/netfilter/ipset (4 files)
  INSTALL include/linux/sunrpc (1 file)
  INSTALL include/linux/tc_act (7 files)
  INSTALL include/linux/tc_ematch (4 files)
  INSTALL include/linux/wimax (1 file)
  INSTALL include/linux/usb (10 files)
  INSTALL include/linux/netfilter (76 files)
  INSTALL include/linux (380 files)
  INSTALL include/asm (33 files)

```

## 4.4 安装modules and firmware

`make -j8 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules_install INSTALL_MOD_PATH=/media/linux/rootfs/`：

```shell
root@linux-virtual-machine:/home/linux/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86# make -j8 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules_install INSTALL_MOD_PATH=/media/linux/rootfs/

```

`make -j8 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- firmware_install INSTALL_MOD_PATH=/media/linux/rootfs/`：

```shell
root@linux-virtual-machine:/home/linux/workspace/beaglebone_black/xenomai_2.6.3_project/linux-3.8.13-bone86# make -j8 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- firmware_install INSTALL_MOD_PATH=/media/linux/rootfs/

```

## 4.5 安装xenomai

`./configure CFLAGS="-march=armv7-a -mfpu=vfp3" LDFLAGS="-march=armv7-a -mfpu=vfp3" --host=arm-linux-gnueabihf --enable-smp`：

```shell
linux@linux-virtual-machine:~/workspace/beaglebone_black/xenomai_2.6.3_project/xenomai-2.6.3$ ./configure CFLAGS="-march=armv7-a -mfpu=vfp3" LDFLAGS="-march=armv7-a -mfpu=vfp3" --host=arm-linux-gnueabihf --enable-smp
linux@linux-virtual-machine:~/workspace/beaglebone_black/xenomai_2.6.3_project/xenomai-2.6.3$ make
root@linux-virtual-machine:/home/linux/workspace/beaglebone_black/xenomai_2.6.3_project/xenomai-2.6.3# make DESTDIR=/media/linux/rootfs/ install
```

# 5 启动BeagleBone Black开发板

xenomai内核启动信息：

```shell
[    0.527489] I-pipe: head domain Xenomai registered.
[    0.527520] Xenomai: hal/arm started.
[    0.528591] Xenomai: scheduling class idle registered.
[    0.528613] Xenomai: scheduling class rt registered.
[    0.533320] Xenomai: real-time nucleus v2.6.3 (Lies and Truths) loaded.
[    0.533329] Xenomai: debug mode enabled.
[    0.533744] Xenomai: starting native API services.
[    0.533755] Xenomai: starting POSIX services.
[    0.533892] Xenomai: starting RTDM services.
```

内核版本：

```shell
root@beaglebone:~# uname -a
Linux beaglebone 3.8.13-ipipe #1 SMP PREEMPT Mon Oct 2 12:10:53 CST 2023 armv7l GNU/Linux
```

## 5.1 xenomai基准测试

```shell
root@beaglebone:/usr/xenomai/bin# ./xeno-test latency 
Started child 1395: /bin/bash /usr/xenomai/bin/xeno-test-run-wrapper ./xeno-test latency
++ echo 0
++ /usr/xenomai/bin/arith
mul: 0x79364d93, shft: 26
integ: 30, frac: 0x4d9364d9364d9364

signed positive operation: 0x03ffffffffffffff * 1000000000 / 33000000
inline calibration: 0x0000000000000000: 194.770 ns, rejected 4/10000
inlined llimd: 0x79364d9364d9362f: 766.558 ns, rejected 11/10000
inlined llmulshft: 0x79364d92ffffffe1: 35.320 ns, rejected 4/10000
inlined nodiv_llimd: 0x79364d9364d9362f: 44.787 ns, rejected 1/10000
out of line calibration: 0x0000000000000000: 200.916 ns, rejected 0/10000
out of line llimd: 0x79364d9364d9362f: 788.183 ns, rejected 8/10000
out of line llmulshft: 0x79364d92ffffffe1: 29.025 ns, rejected 3/10000
out of line nodiv_llimd: 0x79364d9364d9362f: 49.112 ns, rejected 1/10000

signed negative operation: 0xfc00000000000001 * 1000000000 / 33000000
inline calibration: 0x0000000000000000: 192.187 ns, rejected 3/10000
inlined llimd: 0x86c9b26c9b26c9d1: 771.554 ns, rejected 14/10000
inlined llmulshft: 0x86c9b26d0000001e: 37.995 ns, rejected 1/10000
inlined nodiv_llimd: 0x86c9b26c9b26c9d1: 57.733 ns, rejected 4/10000
out of line calibration: 0x0000000000000000: 200.016 ns, rejected 5/10000
out of line llimd: 0x86c9b26c9b26c9d1: 792.070 ns, rejected 11/10000
out of line llmulshft: 0x86c9b26d0000001e: 30.054 ns, rejected 2/10000
out of line nodiv_llimd: 0x86c9b26c9b26c9d1: 60.091 ns, rejected 2/10000

unsigned operation: 0x03ffffffffffffff * 1000000000 / 33000000
inline calibration: 0x0000000000000000: 200.987 ns, rejected 2/10000
inlined nodiv_ullimd: 0x79364d9364d9362f: 37.733 ns, rejected 4/10000
out of line calibration: 0x0000000000000000: 197.974 ns, rejected 4/10000
out of line nodiv_ullimd: 0x79364d9364d9362f: 52.145 ns, rejected 3/10000
++ /usr/xenomai/bin/clocktest -C 42 -T 30
== Tested clock: 42 (CLOCK_HOST_REALTIME)
CPU      ToD offset [us] ToD drift [us/s]      warps max delta [us]
--- -------------------- ---------------- ---------- --------------
  0                  1.5            0.006          0            0.0
++ /usr/xenomai/bin/switchtest -T 30
== Testing FPU check routines...
d0: 1 != 2
d1: 1 != 2
d2: 1 != 2
d3: 1 != 2
d4: 1 != 2
d5: 1 != 2
d6: 1 != 2
d7: 1 != 2
d8: 1 != 2
d9: 1 != 2
d10: 1 != 2
d11: 1 != 2
d12: 1 != 2
d13: 1 != 2
d14: 1 != 2
d15: 1 != 2
== FPU check routines: OK.
== Threads: sleeper_ufps0-0 rtk0-1 rtk0-2 rtk_fp0-3 rtk_fp0-4 rtk_fp_ufpp0-5 rtk_fp_ufpp0-6 rtup0-7 rtup0-8 rtup_ufpp0-9 rtup_ufpp0-10 rtus0-11 rtus0-12 rtus_ufps0-13 rtus_ufps0-14 rtuo0-15 rtuo0-16 rtuo_ufpp0-17 rtuo_ufpp0-18 rtuo_ufps0-19 rtuo_ufps0-20 rtuo_ufpp_ufps0-21 rtuo_ufpp_ufps0-22
RTT|  00:00:01
RTH|---------cpu|ctx switches|-------total
RTD|           0|       16558|       16558
RTD|           0|       16560|       33118
RTD|           0|       16357|       49475
RTD|           0|       16625|       66100
RTD|           0|       16560|       82660
RTD|           0|       16629|       99289
RTD|           0|       16562|      115851
RTD|           0|       16355|      132206
RTD|           0|       16627|      148833
RTD|           0|       16562|      165395
RTD|           0|       16625|      182020
RTD|           0|       16629|      198649
RTD|           0|       16353|      215002
RTD|           0|       16560|      231562
RTD|           0|       16629|      248191
RTD|           0|       16562|      264753
RTD|           0|       16562|      281315
RTD|           0|       16420|      297735
RTD|           0|       16562|      314297
RTD|           0|       16625|      330922
RTD|           0|       16629|      347551
RTT|  00:00:22
RTH|---------cpu|ctx switches|-------total
RTD|           0|       16562|      364113
RTD|           0|       16351|      380464
RTD|           0|       16629|      397093
RTD|           0|       16560|      413653
RTD|           0|       16564|      430217
RTD|           0|       16629|      446846
RTD|           0|       16353|      463199
RTD|           0|       16625|      479824
RTD|           0|       15870|      495694
++ /usr/xenomai/bin/cond-torture-native
simple_condwait
relative_condwait
absolute_condwait
sig_norestart_condwait
sig_restart_condwait
sig_norestart_condwait_mutex
sig_restart_condwait_mutex
sig_norestart_double
sig_restart_double
cond_destroy_whilewait
Test OK
++ /usr/xenomai/bin/cond-torture-posix
simple_condwait
relative_condwait
absolute_condwait
sig_norestart_condwait
sig_restart_condwait
sig_norestart_condwait_mutex
sig_restart_condwait_mutex
sig_norestart_double
sig_restart_double
cond_destroy_whilewait
Test OK
++ /usr/xenomai/bin/mutex-torture-native
simple_wait
recursive_wait
timed_mutex
mode_switch
pi_wait
lock_stealing
NOTE: lock_stealing mutex_trylock: not supported
deny_stealing
simple_condwait
recursive_condwait
auto_switchback
Test OK
++ /usr/xenomai/bin/mutex-torture-posix
simple_wait
recursive_wait
errorcheck_wait
timed_mutex
mode_switch
pi_wait
lock_stealing
NOTE: lock_stealing mutex_trylock: not supported
deny_stealing
simple_condwait
recursive_condwait
auto_switchback
Test OK
++ start_load
++ echo start_load
++ check_alive /usr/xenomai/bin/latency latency
++ echo check_alive /usr/xenomai/bin/latency latency
++ wait_load
++ read rc
Started child 1474: dohell 900
Started child 1475: /usr/xenomai/bin/latency latency
== Sampling period: 1000 us
== Test mode: periodic user-mode task
== All results in microseconds
warming up...
RTT|  00:00:01  (periodic user-mode task, 1000 us period, priority 99)
RTH|----lat min|----lat avg|----lat max|-overrun|---msw|---lat best|--lat worst
RTD|      8.458|     26.583|     44.958|       0|     0|      8.458|     44.958
RTD|      6.624|     25.291|     43.541|       0|     0|      6.624|     44.958
RTD|      7.833|     26.374|     44.249|       0|     0|      6.624|     44.958
RTD|     10.208|     26.874|     42.833|       0|     0|      6.624|     44.958
RTD|      7.666|     25.874|     43.791|       0|     0|      6.624|     44.958
RTD|      9.874|     25.291|     42.458|       0|     0|      6.624|     44.958
RTD|      7.708|     26.291|     42.124|       0|     0|      6.624|     44.958
RTD|      7.374|     26.749|     44.458|       0|     0|      6.624|     44.958
RTD|      7.583|     27.083|     42.749|       0|     0|      6.624|     44.958
RTD|      7.666|     27.458|     45.999|       0|     0|      6.624|     45.999
RTD|      9.083|     26.458|     43.249|       0|     0|      6.624|     45.999
RTD|      8.749|     25.999|     43.333|       0|     0|      6.624|     45.999
RTD|      7.916|     27.083|     42.791|       0|     0|      6.624|     45.999
RTD|      7.083|     24.791|     44.374|       0|     0|      6.624|     45.999
RTD|      7.416|     25.374|     44.458|       0|     0|      6.624|     45.999
RTD|      6.916|     24.833|     44.624|       0|     0|      6.624|     45.999
RTD|      6.708|     24.749|     42.916|       0|     0|      6.624|     45.999
RTD|      6.708|     24.624|     43.249|       0|     0|      6.624|     45.999
RTD|      7.083|     24.791|     43.124|       0|     0|      6.624|     45.999
RTD|     10.249|     25.499|     46.374|       0|     0|      6.624|     46.374
RTD|      6.666|     25.041|     43.124|       0|     0|      6.624|     46.374
RTT|  00:00:22  (periodic user-mode task, 1000 us period, priority 99)
RTH|----lat min|----lat avg|----lat max|-overrun|---msw|---lat best|--lat worst
RTD|      6.458|     24.749|     42.999|       0|     0|      6.458|     46.374
RTD|      7.208|     24.916|     42.916|       0|     0|      6.458|     46.374
RTD|      6.749|     24.958|     44.666|       0|     0|      6.458|     46.374
RTD|      9.874|     25.499|     47.333|       0|     0|      6.458|     47.333
RTD|      7.708|     24.791|     42.958|       0|     0|      6.458|     47.333
RTD|      9.999|     24.666|     45.374|       0|     0|      6.458|     47.333
RTD|      7.666|     24.499|     42.083|       0|     0|      6.458|     47.333
RTD|      6.749|     24.541|     44.249|       0|     0|      6.458|     47.333
RTD|      6.124|     25.541|     45.624|       0|     0|      6.124|     47.333
RTD|      6.374|     24.791|     43.666|       0|     0|      6.124|     47.333
RTD|      6.458|     24.874|     45.166|       0|     0|      6.124|     47.333
RTD|      6.374|     24.791|     42.958|       0|     0|      6.124|     47.333
RTD|      7.291|     24.791|     43.624|       0|     0|      6.124|     47.333
RTD|      7.249|     25.166|     45.708|       0|     0|      6.124|     47.333
RTD|      7.291|     24.916|     42.624|       0|     0|      6.124|     47.333
RTD|      7.374|     25.333|     45.291|       0|     0|      6.124|     47.333
RTD|      6.999|     25.749|     43.416|       0|     0|      6.124|     47.333
RTD|      7.041|     24.791|     43.874|       0|     0|      6.124|     47.333
RTD|      9.791|     25.291|     44.666|       0|     0|      6.124|     47.333
RTD|      7.374|     24.333|     43.916|       0|     0|      6.124|     47.333
RTD|      7.041|     24.999|     43.249|       0|     0|      6.124|     47.333
RTT|  00:00:43  (periodic user-mode task, 1000 us period, priority 99)
RTH|----lat min|----lat avg|----lat max|-overrun|---msw|---lat best|--lat worst
RTD|      6.833|     24.874|     42.249|       0|     0|      6.124|     47.333
RTD|      7.583|     25.083|     44.166|       0|     0|      6.124|     47.333
RTD|      7.374|     25.624|     44.333|       0|     0|      6.124|     47.333
^C---|-----------|-----------|-----------|--------|------|-------------------------
RTS|      6.124|     25.374|     47.333|       0|     0|    00:00:46/00:00:46

```

## 5.2 latency测试（无负载）

```shell
root@beaglebone:/usr/xenomai/bin# ./latency 
== Sampling period: 1000 us
== Test mode: periodic user-mode task
== All results in microseconds
warming up...
RTT|  00:00:01  (periodic user-mode task, 1000 us period, priority 99)
RTH|----lat min|----lat avg|----lat max|-overrun|---msw|---lat best|--lat worst
RTD|      3.624|      4.541|     17.333|       0|     0|      3.624|     17.333
RTD|      1.999|      4.708|     38.499|       0|     0|      1.999|     38.499
RTD|      3.708|      4.708|     38.874|       0|     0|      1.999|     38.874
RTD|      3.791|      5.833|     40.958|       0|     0|      1.999|     40.958
RTD|      2.999|      4.624|     40.833|       0|     0|      1.999|     40.958
RTD|      3.708|      4.624|     33.916|       0|     0|      1.999|     40.958
RTD|      0.666|      4.541|     18.208|       0|     0|      0.666|     40.958
RTD|      2.916|      4.624|     37.458|       0|     0|      0.666|     40.958
RTD|      3.708|      5.833|     41.708|       0|     0|      0.666|     41.708
RTD|      3.458|      4.541|     12.749|       0|     0|      0.666|     41.708
RTD|      1.999|      4.666|     36.791|       0|     0|      0.666|     41.708
RTD|      2.999|      4.624|     37.624|       0|     0|      0.666|     41.708
RTD|      3.749|      4.583|     16.958|       0|     0|      0.666|     41.708
RTD|      2.624|      5.874|     40.666|       0|     0|      0.666|     41.708
RTD|      3.583|      4.666|     37.541|       0|     0|      0.666|     41.708
RTD|      3.708|      4.583|     11.374|       0|     0|      0.666|     41.708
RTD|      3.041|      4.666|     36.583|       0|     0|      0.666|     41.708
RTD|      3.083|      4.583|     33.374|       0|     0|      0.666|     41.708
RTD|      2.999|      6.833|     40.624|       0|     0|      0.666|     41.708
RTD|      3.708|      4.624|     37.749|       0|     0|      0.666|     41.708
RTD|      0.958|      4.666|     34.333|       0|     0|      0.666|     41.708
```

## 5.3 klatency测试

```shell
root@beaglebone:/usr/xenomai/bin# modprobe xeno_klat
root@beaglebone:/usr/xenomai/bin# lsmod 
Module                  Size  Used by
xeno_klat               4488  0 
binfmt_misc             5675  1 
g_multi                50783  2 
libcomposite           15103  1 g_multi
omap_rng                4250  0 
musb_dsps               7086  0 
root@beaglebone:/usr/xenomai/bin# ./klatency 
== Sampling period: 100 us
== Test mode: in-kernel periodic task
== All results in microseconds
warming up...
RTT|  00:00:00  (in-kernel periodic task, 100 us period, priority 99)
RTH|-----lat min|-----lat avg|-----lat max|-overrun|----lat best|---lat worst
RTD|      -0.542|       4.182|       9.375|       0|      -0.542|       9.375
RTD|      -0.501|       4.231|      10.041|       0|      -0.542|      10.041
RTD|      -0.459|       4.266|       9.457|       0|      -0.542|      10.041
RTD|      -0.668|       4.229|      10.999|       0|      -0.668|      10.999
RTD|      -0.251|       4.207|       8.790|       0|      -0.668|      10.999
RTD|      -0.793|       4.148|       9.040|       0|      -0.793|      10.999
RTD|      -0.418|       4.178|       9.165|       0|      -0.793|      10.999
RTD|      -0.752|       4.154|       8.706|       0|      -0.793|      10.999
RTD|      -0.669|       4.187|       9.956|       0|      -0.793|      10.999
RTD|      -0.419|       4.195|       9.122|       0|      -0.793|      10.999
RTD|      -0.669|       4.182|       9.081|       0|      -0.793|      10.999
RTD|      -0.836|       4.191|       9.789|       0|      -0.836|      10.999
RTD|      -0.628|       4.202|       9.330|       0|      -0.836|      10.999
RTD|      -0.712|       4.218|       9.205|       0|      -0.836|      10.999
RTD|      -0.629|       4.192|       9.329|       0|      -0.836|      10.999
RTD|      -0.837|       4.165|      10.413|       0|      -0.837|      10.999
RTD|      -0.671|       4.147|      10.829|       0|      -0.837|      10.999
RTD|      -0.671|       4.194|       8.329|       0|      -0.837|      10.999
RTD|      -0.755|       4.219|      10.037|       0|      -0.837|      10.999
RTD|      -0.755|       4.209|       9.287|       0|      -0.837|      10.999
RTD|      -0.672|       4.160|       9.995|       0|      -0.837|      10.999
RTT|  00:00:16  (in-kernel periodic task, 100 us period, priority 99)
RTH|-----lat min|-----lat avg|-----lat max|-overrun|----lat best|---lat worst
RTD|      -0.714|       4.174|       8.786|       0|      -0.837|      10.999
RTD|      -0.589|       4.207|       9.411|       0|      -0.837|      10.999
^CRTD|      -0.714|       4.238|      10.952|       0|      -0.837|      10.999
---|------------|------------|------------|--------|-------------------------
RTS|      -0.837|       4.033|      10.999|       0|    00:00:18/00:00:18
```

# 附录

[^1]: https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-linux-gnueabihf/	"交叉编译工具链"

[^2]: https://github.com/beagleboard/linux/tree/v3.8.13-bone86 "GitHub - beagleboard/linux at v3.8.13-bone86"
[^3]: https://ftp.denx.de/pub/xenomai/xenomai/stable/ "Index of /pub/xenomai/xenomai/stable/"
[^4]: https://www.beagleboard.org/distros "Latest Software Images - BeagleBoard"
