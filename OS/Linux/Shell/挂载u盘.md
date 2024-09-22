# 查看U盘设备

```shell
# fdisk -l

Disk /dev/sda: 16.2 GB, 16257318912 bytes
255 heads, 63 sectors/track, 1976 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks  Id System
/dev/sda1   *           1         731     5871726   b Win95 FAT32
/dev/sda2             732        1976    10000462+  f Win95 Ext'd (LBA)
/dev/sda5             732         980     2000061   c Win95 FAT32 (LBA)
/dev/sda6             981        1229     2000061   e Win95 FAT16 (LBA)
/dev/sda7            1230        1478     2000061   e Win95 FAT16 (LBA)
/dev/sda8            1479        1727     2000061   e Win95 FAT16 (LBA)
/dev/sda9            1728        1976     2000061   e Win95 FAT16 (LBA)
# 

```

已检测到u盘设备。

# 挂载U盘

检测到u盘中有多个分区，挂载其中的`/dev/sda5`到`/mnt/usb`

```shell
# mount -t vfat /dev/sda5 /mnt/usb/
# 
# cd /mnt/usb/
# ls
System Volume Information  lsz
lrz
# 
```

可通过`-o iocharset=utf8`设置编码格式，其他格式请参考`man mount`

```shell
# mount -t vfat -o iocharset=utf8 /dev/sda5 /mnt/usb/
FAT: utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
Unable to load NLS charset utf8
FAT: IO charset utf8 not found
mount: mounting /dev/sda5 on /mnt/usb/ failed: Invalid argument
# 

```

## 取消挂载

1. 退出挂载的目录

2. 取消挂载

   ```shell
   # umount /dev/sda5
   # ls /mnt/usb/
   # 
   # 
   
   ```

# 注意

1. Linux不支持挂载NTFS格式的磁盘
2. FAT32的磁盘文件大多不是utf8格式，所以挂载后，有可能出现文件名乱码

# 附录

## 使用dmesg可查看USB设备插拔信息

```shell
# dmesg
usb 1-1: new full speed USB device using s3c2410-ohci and address 2
usb 1-1: configuration #1 chosen from 1 choice
scsi0 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
scsi 0:0:0:0: Direct-Access     PNY      Lovely Attache   1100 PQ: 0 ANSI: 4
sd 0:0:0:0: [sda] 31752576 512-byte hardware sectors (16257 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 43 00 00 00
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] 31752576 512-byte hardware sectors (16257 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 43 00 00 00
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
sd 0:0:0:0: [sda] Attached SCSI removable disk
usb-storage: device scan complete
# 

```

