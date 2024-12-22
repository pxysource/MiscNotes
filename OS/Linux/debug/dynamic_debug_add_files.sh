#!/bin/sh

echo 8 4 1 7 > /proc/sys/kernel/printk

mount -t debugfs none /sys/kernel/debug
echo -n "file drivers/spi/spi-xilinx-qps.c +p" > /sys/kernel/debug/dynamic_debug/control
echo -n "file drivers/spi/spi.c +p" > /sys/kernel/debug/dynamic_debug/control
echo -n "file drivers/mtd/devices/m25p80.c +p" > /sys/kernel/debug/dynamic_debug/control

insmod /lib/modules/3.8.0-xilinx/kernel/drivers/spi/spi-xilinx-qps.ko
