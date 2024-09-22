Beaglebone black(AM3358)使用SD卡启动系统

# 硬件

- 读卡器
- micro SD卡

# 软件工具

## SD卡烧写工具

Win32DiskImager，:link:[Win32 Disk Imager download | SourceForge.net](https://sourceforge.net/projects/win32diskimager/)

## SD格式化工具

SDFormatter下载地址，:link:[SD Card Formatter - Download SD Memory Card formatter 2022](https://www.sdcardformatter.com/)

# 固件

Beaglebone black固件下载地址：[BeagleBoard.org - latest-images](https://beagleboard.org/latest-images)

下载：

1. 选择开发板型号：`BeagleBone Black`
2. 选择SD卡相关固件：如`Debian 7.11 2016-06-15 4GB SD LXDE`，下载之后得到名为`bone-debian-7.11-lxde-4gb-armhf-2016-06-15-4gb.img.xz`的压缩文件，解压后即可得到写入SD卡里面的镜像文件`bone-debian-7.11-lxde-4gb-armhf-2016-06-15-4gb.img`。

# 写入固件到SD卡

1. 将SD卡放入读卡器，读卡器插入电脑USB口。打开`SDFormatter`应用程序，对SD卡进行格式化。选中SD卡所对应的盘符，`SDFormatter`使用默认的设置就行，点击格式化，等待格式化完成即可。

2. 打开`win32DiskImager`应用程序，映像文件那里选中刚才下载的镜像文件`bone-debian-7.11-lxde-4gb-armhf-2016-06-15-4gb.img`，点击写入，等待写入完成。写入完成后，SD卡就被制作成`linux`支持的`ext4`与`fat32`格式，弹出SD卡即可。此时，系统已经被写入SD卡，可以使用了。

# 启动BeagleBone Black开发板

1. 将SD卡插入beaglebone black开发板的microSD Card口。

2. 接通电源

3. 登录。

   ```shell
   beaglebone login: debian
   
   Password：temppwd
   ```

   
