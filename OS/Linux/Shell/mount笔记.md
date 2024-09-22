# 简介

`mount`命令的笔记。

# `mount -a`与`/etc/fstab`

`mount -a`：挂载所有的文件系统，需要读取`/etc/fstab`文件。

`man mount`的描述：

> Mount all filesystems (of the given types) mentioned in fstab (except for those whose line contains the noauto keyword).  The filesystems are mounted following their order in fstab.

-------------

`fstab`详细内容参考`man fstab`

`/etc/fstab`每一行的格式如下：

```
<file system> <mount point> <type> <options> <dump> <pass>
```

`<file system>`：要挂载的设备。

`<mount point>`：挂载点。

`<type>`：文件系统的类型，如`ext2`、`ext3`、`ext4`、`proc`、`tmpfs`、`sysfs`等。

`<options>`：挂载选项，一般设置为`defaults`即可。`defaults`包含了`rw`、`suid`、`dev`、`exec`、`auto`、`nouser`和`async`。

`<dump>`：`1`表示允许备份，`0`表示不备份，一般设置为不备份`0`。

`<pass>`：磁盘检查设置，`0`表示不检查。根目录`/`设置为`1`，其他的都不能设置为`1`，其他的分区从`2`开始。一般不在`fstab`中挂载根目录，这里一般设置为0`。

----------------

`fstab`文件的示例如下：

```
# <file system> <mount point> <type> <options> <dump> <pass>
proc            /proc         proc   defaults  0      0
tmpfs           /tmp          tmpfs  defaults  0      0
sysfs           /sys          sysfs  defaults  0      0
```

