# bootargs

## nfs挂载rootfs启动

linux使用nfs挂载rootfs，详细内容参考linux内核源代码中的`/Documentation/filesystems/nfs/nfsroot.txt`文件，格式如下：

```
root=/dev/nfs nfsroot=[<server-ip>:]<root-dir>[,<nfs-options>] ip=<client-ip>:<server-ip>:<gw-ip>:<netmask>:<hostname>:<device>:<autoconf>:<dns0-ip>:<dns1-ip>
```

参数说明：

- `<server-ip>`：服务器ip地址，即存放rootfs的主机的ip地址。
- `<root-dit>`：rootfs在主机上存放路径。
- `<nfs-options>`：nfs的其他可选选项，一般无需设置。
- `<client-ip>`：客户端ip地址，也即开发本的ip地址。
- `<gw-ip>`：网关地址。
- `<netmask>`：子网掩码。
- `<hostname>`：客户机的名字，一般不设置，为空即可。
- `<device>`：网卡设备名称，如`eth0`、`eth1`等。
- `<autoconf>`：自动配置，一般使用，设置为`off`。
- `<dns0-ip>`：dns0服务器ip地址，不使用。
- `<dns1-ip>`：dns1服务器ip地址，不适用。

----------------

例子，nfs挂载rootfs启动的`bootargs`设置如下：

```
console=ttyPS0,115200 root=/dev/nfs rw nfsroot=192.168.1.10:/home/linux/workspace/nfsdir/rootfs_busybox-1.29.0 ip=192.168.1.4:192.168.1.10:192.168.1.255:255.255.255.0::eth0:off
```

