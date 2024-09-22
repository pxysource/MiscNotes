# 简介

pc作为nfs服务端，开发板作为客户端去挂载nfs，开发板直接通过nfs访问pc上的文件。

# pc端

## 安装

```shell
sudo apt install nfs-kernel-server
```

## 运行

检查运行状态

```shell
linux@ubuntu:~/s3c2440/drivers/char/hello_world$ /etc/init.d/nfs-kernel-server status
● nfs-server.service - NFS server and services
     Loaded: loaded (/lib/systemd/system/nfs-server.service; enabled; vendor preset: enabled)
    Drop-In: /run/systemd/generator/nfs-server.service.d
             └─order-with-mounts.conf
     Active: active (exited) since Sun 2022-06-26 14:38:23 CST; 8h ago
    Process: 1508 ExecStartPre=/usr/sbin/exportfs -r (code=exited, status=0/SUCCESS)
    Process: 1509 ExecStart=/usr/sbin/rpc.nfsd $RPCNFSDARGS (code=exited, status=0/SUCCESS)
    Process: 5704 ExecReload=/usr/sbin/exportfs -r (code=exited, status=0/SUCCESS)
   Main PID: 1509 (code=exited, status=0/SUCCESS)

Jun 26 14:38:22 ubuntu systemd[1]: Starting NFS server and services...
Jun 26 14:38:23 ubuntu systemd[1]: Finished NFS server and services.
Jun 26 14:48:14 ubuntu systemd[1]: Reloading NFS server and services.
Jun 26 14:48:14 ubuntu systemd[1]: Reloaded NFS server and services.
Jun 26 15:04:22 ubuntu systemd[1]: Reloading NFS server and services.
Jun 26 15:04:22 ubuntu exportfs[5704]: exportfs: /etc/exports [2]: Neither 'subtree_check' or 'no_subtree_check' specified for ex…/drivers".
Jun 26 15:04:22 ubuntu exportfs[5704]:   Assuming default behaviour ('no_subtree_check').
Jun 26 15:04:22 ubuntu exportfs[5704]:   NOTE: this default has changed since nfs-utils version 1.0.x
Jun 26 15:04:22 ubuntu systemd[1]: Reloaded NFS server and services.
Hint: Some lines were ellipsized, use -l to show in full.

```

如果没有运行，则运行

```shell
/etc/init.d/nfs-kernel-server start
```

## 配置

在`/etc/exports`中配置作为nfs的目录。

当前配置`/home/linux/s3c2440/drivers`作为nfs目录。

```shell
# /etc/exports: the access control list for filesyste
#		to NFS clients.  See exports(5).
#
# Example for NFSv2 and NFSv3:
# /srv/homes       hostname1(rw,sync,no_subtree_check
#
# Example for NFSv4:
# /srv/nfs4        gss/krb5i(rw,sync,fsid=0,crossmnt,
# /srv/nfs4/homes  gss/krb5i(rw,sync,no_subtree_check
#
/opt *(rw,sync,no_subtree_check)
/home/linux/s3c2440/drivers *(rw,sync,no_root_squash)

```

# 开发板端

```shell
mount -t nfs -o intr,nolock,rsize=1024,wsize=1024 192.168.1.2:/home/linux/s3c2440/drivers /root/drivers
```

# 注意

1. 在开发板端挂载时，进行如下挂载，在访问文件时会出问题（可能导致开发板终端卡死）

   - 挂载

     ```shell
     mount -t nfs -o nolock 192.168.1.2:/home/linux/s3c2440/drivers /root/drivers
     ```

   - 问题

     ```shell
     nfs: server 192.168.1.2 not responding, still trying
     nfs: server 192.168.1.2 not responding, still trying
     nfs: server 192.168.1.2 not responding, still trying
     ```


# 附录

##  not responding, timed out

### 客户端(s3c2440)

s3c2440挂载nfs的现象

```shell
# mount -t nfs -o nolock 192.168.1.2:/home/linux/nfs /mnt
nfs: server 192.168.1.2 not responding, timed out
mount: mounting 192.168.1.2:/home/linux/nfs on /mnt failed: Input/output error
# 
```

ip设置

```shell
# ifconfig 
eth0      Link encap:Ethernet  HWaddr 00:60:6E:33:44:55  
          inet addr:192.168.1.17  Bcast:192.168.1.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:240 errors:0 dropped:0 overruns:0 frame:0
          TX packets:18 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:22768 (22.2 KiB)  TX bytes:1388 (1.3 KiB)
          Interrupt:51 Base address:0xa000 

# 
```

### 服务端(Ubuntu)

nfs-server状态：

```shell
linux@ubuntu:~$ systemctl status nfs-kernel-server.service 
● nfs-server.service - NFS server and services
     Loaded: loaded (/lib/systemd/system/nfs-server.service; enabled; vendor preset: enabled)
    Drop-In: /run/systemd/generator/nfs-server.service.d
             └─order-with-mounts.conf
     Active: active (exited) since Mon 2023-05-01 14:13:25 CST; 11min ago
    Process: 29829 ExecStartPre=/usr/sbin/exportfs -r (code=exited, status=0/SUCCESS)
    Process: 29830 ExecStart=/usr/sbin/rpc.nfsd (code=exited, status=0/SUCCESS)
   Main PID: 29830 (code=exited, status=0/SUCCESS)
        CPU: 7ms

May 01 14:13:25 ubuntu systemd[1]: Starting NFS server and services...
May 01 14:13:25 ubuntu systemd[1]: Finished NFS server and services.
linux@ubuntu:~$ 
```

nfs-mountd状态

```shell
linux@ubuntu:~$ systemctl status nfs-mountd.service 
● nfs-mountd.service - NFS Mount Daemon
     Loaded: loaded (/lib/systemd/system/nfs-mountd.service; static)
     Active: active (running) since Mon 2023-05-01 14:13:25 CST; 12min ago
    Process: 29826 ExecStart=/usr/sbin/rpc.mountd (code=exited, status=0/SUCCESS)
   Main PID: 29828 (rpc.mountd)
      Tasks: 1 (limit: 4581)
     Memory: 808.0K
        CPU: 7ms
     CGroup: /system.slice/nfs-mountd.service
             └─29828 /usr/sbin/rpc.mountd

May 01 14:13:25 ubuntu systemd[1]: Starting NFS Mount Daemon...
May 01 14:13:25 ubuntu rpc.mountd[29828]: Version 2.6.1 starting
May 01 14:13:25 ubuntu systemd[1]: Started NFS Mount Daemon.
May 01 14:19:25 ubuntu rpc.mountd[29828]: authenticated mount request from 192.168.1.17:950 for /home/linux/nfs (/home/linux/nfs)
```

nfs配置：

- `/etc/nfs.conf`

  ```
  #
  # This is a general configuration for the
  # NFS daemons and tools
  #
  [general]
  pipefs-directory=/run/rpc_pipefs
  #
  [exports]
  # rootdir=/export
  #
  [exportfs]
  # debug=0
  #
  [gssd]
  # verbosity=0
  # rpc-verbosity=0
  # use-memcache=0
  # use-machine-creds=1
  # use-gss-proxy=0
  # avoid-dns=1
  # limit-to-legacy-enctypes=0
  # context-timeout=0
  # rpc-timeout=5
  # keytab-file=/etc/krb5.keytab
  # cred-cache-directory=
  # preferred-realm=
  #
  [lockd]
  # port=0
  # udp-port=0
  #
  [mountd]
  # debug=0
  manage-gids=y
  # descriptors=0
  # port=0
  # threads=1
  # reverse-lookup=n
  # state-directory-path=/var/lib/nfs
  # ha-callout=
  #
  [nfsdcld]
  # debug=0
  # storagedir=/var/lib/nfs/nfsdcld
  #
  [nfsdcltrack]
  # debug=0
  # storagedir=/var/lib/nfs/nfsdcltrack
  #
  [nfsd]
  # debug=0
  # threads=8
  # host=
  # port=0
  # grace-time=90
  # lease-time=90
  # 低版本的nfs使用的是udp.
  #udp=y
  # tcp=y
  # vers2=n
  # vers3=y
  # vers4=y
  # vers4.0=y
  # vers4.1=y
  # vers4.2=y
  # rdma=n
  # rdma-port=20049
  #
  [statd]
  # debug=0
  # port=0
  # outgoing-port=0
  # name=
  # state-directory-path=/var/lib/nfs/statd
  # ha-callout=
  # no-notify=0
  #
  [sm-notify]
  # debug=0
  # force=0
  # retry-time=900
  # outgoing-port=
  # outgoing-addr=
  # lift-grace=y
  #
  [svcgssd]
  # principal=
  
  ```

- `/etc/exports`

  ```
  # /etc/exports: the access control list for filesystems which may be exported
  #		to NFS clients.  See exports(5).
  #
  # Example for NFSv2 and NFSv3:
  # /srv/homes       hostname1(rw,sync,no_subtree_check) hostname2(ro,sync,no_subtree_check)
  #
  # Example for NFSv4:
  # /srv/nfs4        gss/krb5i(rw,sync,fsid=0,crossmnt,no_subtree_check)
  # /srv/nfs4/homes  gss/krb5i(rw,sync,no_subtree_check)
  #
  /opt *(rw,sync,no_subtree_check)
  /home/linux/workspace/s3c2440/my-s3c2440/build_root/first_fs *(rw,sync,no_root_squash,no_subtree_check)
  /home/linux/nfs *(rw,sync,no_root_squash,no_subtree_check)
  
  ```

  ```shell
  linux@ubuntu:~$ showmount -e 192.168.1.2
  Export list for 192.168.1.2:
  /home/linux/nfs                                              *
  /home/linux/workspace/s3c2440/my-s3c2440/build_root/first_fs *
  /opt                                                         *
  ```

portmapper:

```shell
linux@ubuntu:~$ rpcinfo -p
   program vers proto   port  service
    100000    4   tcp    111  portmapper
    100000    3   tcp    111  portmapper
    100000    2   tcp    111  portmapper
    100000    4   udp    111  portmapper
    100000    3   udp    111  portmapper
    100000    2   udp    111  portmapper
    100024    1   udp  46774  status
    100024    1   tcp  43911  status
    100005    1   udp  34362  mountd
    100005    1   tcp  48457  mountd
    100005    2   udp  32895  mountd
    100005    2   tcp  40389  mountd
    100005    3   udp  53378  mountd
    100005    3   tcp  39689  mountd
    100003    3   tcp   2049  nfs
    100003    4   tcp   2049  nfs
    100227    3   tcp   2049
    100021    1   udp  40246  nlockmgr
    100021    3   udp  40246  nlockmgr
    100021    4   udp  40246  nlockmgr
    100021    1   tcp  37175  nlockmgr
    100021    3   tcp  37175  nlockmgr
    100021    4   tcp  37175  nlockmgr
linux@ubuntu:~$ 
```

连接信息：

```shell
linux@ubuntu:~$ rpcinfo -p 192.168.1.17
192.168.1.17: RPC: Remote system error - Connection refused
linux@ubuntu:~$ 
```

### 分析

nfs较早的版本使用的udp，检查端口发现udp的端未开放，怀疑是udp端口没开放的问题

### 修复

1. 修改配置文件`/etc/nfs.conf`，开放udp端口:

   ```
   udp=y
   ```

2. 重启nfs服务

   ```shell
   linux@ubuntu:~$ sudo /etc/init.d/nfs-kernel-server restart 
   Restarting nfs-kernel-server (via systemctl): nfs-kernel-server.service.
   linux@ubuntu:~$ sudo /etc/init.d/nfs-kernel-server status 
   ● nfs-server.service - NFS server and services
        Loaded: loaded (/lib/systemd/system/nfs-server.service; enabled; vendor preset: enabled)
       Drop-In: /run/systemd/generator/nfs-server.service.d
                └─order-with-mounts.conf
        Active: active (exited) since Mon 2023-05-01 15:32:49 CST; 4s ago
       Process: 33022 ExecStartPre=/usr/sbin/exportfs -r (code=exited, status=0/SUCCESS)
       Process: 33023 ExecStart=/usr/sbin/rpc.nfsd (code=exited, status=0/SUCCESS)
      Main PID: 33023 (code=exited, status=0/SUCCESS)
           CPU: 6ms
   
   May 01 15:32:49 ubuntu systemd[1]: Starting NFS server and services...
   May 01 15:32:49 ubuntu systemd[1]: Finished NFS server and services.
   linux@ubuntu:~$ 
   ```

3. 检查端口映射

   ```shell
   linux@ubuntu:~$ rpcinfo -p
      program vers proto   port  service
       100000    4   tcp    111  portmapper
       100000    3   tcp    111  portmapper
       100000    2   tcp    111  portmapper
       100000    4   udp    111  portmapper
       100000    3   udp    111  portmapper
       100000    2   udp    111  portmapper
       100024    1   udp  46774  status
       100024    1   tcp  43911  status
       100005    1   udp  45717  mountd
       100005    1   tcp  36909  mountd
       100005    2   udp  37650  mountd
       100005    2   tcp  51281  mountd
       100005    3   udp  36042  mountd
       100005    3   tcp  37099  mountd
       100003    3   tcp   2049  nfs
       100003    4   tcp   2049  nfs
       100227    3   tcp   2049
       100003    3   udp   2049  nfs
       100227    3   udp   2049
       100021    1   udp  45466  nlockmgr
       100021    3   udp  45466  nlockmgr
       100021    4   udp  45466  nlockmgr
       100021    1   tcp  34257  nlockmgr
       100021    3   tcp  34257  nlockmgr
       100021    4   tcp  34257  nlockmgr
   linux@ubuntu:~$ 
   ```

4. 客户端(s3c2440)重新挂载nfs

   ```shell
   # mount -t nfs -o nolock 192.168.1.2:/home/linux/nfs /mnt
   # cat /proc/mounts 
   rootfs / rootfs rw 0 0
   /dev/root / yaffs2 rw 0 0
   proc /proc proc rw 0 0
   tmpfs /tmp tmpfs rw 0 0
   sysfs /sys sysfs rw 0 0
   tmpfs /dev tmpfs rw 0 0
   devpts /dev/pts devpts rw 0 0
   192.168.1.2:/home/linux/nfs /mnt nfs rw,vers=3,rsize=32768,wsize=32768,hard,nolock,proto=udp,timeo=7,retrans=3,sec=sys,addr=192.168.1.2 0 0
   # 
   ```

## nfs挂载rootfs启动失败

### 客户端(s3c2440)

u-boot中bootargs设置

```
bootargs=noinitrd console=ttySAC0 root=/dev/nfs nfsroot=192.168.1.2:/home/linux/workspace/s3c2440/my-s3c2440/build_root/first_fs ip=192.168.1.17:192.168.1.2:192.168.1.1:255.255.255.0::eth0:off init=/linuxrc
```

启动错误信息

```
IP-Config: Complete:
      device=eth0, addr=192.168.1.17, mask=255.255.255.0, gw=192.168.1.1,
     host=192.168.1.17, domain=, nis-domain=(none),
     bootserver=192.168.1.2, rootserver=192.168.1.2, rootpath=
Looking up port of RPC 100003/2 on 192.168.1.2
Looking up port of RPC 100005/1 on 192.168.1.2
VFS: Unable to mount root fs via NFS, trying floppy.
VFS: Cannot open root device "nfs" or unknown-block(2,0)
Please append a correct "root=" boot option; here are the available partitions:
1f00        256 mtdblock0 (driver?)
1f01        128 mtdblock1 (driver?)
1f02       2048 mtdblock2 (driver?)
1f03     259712 mtdblock3 (driver?)
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(2,0)
```

### 服务端(Ubuntu)

检查nfs服务，nfs服务正常。

连接信息：

```shell
IP-Config: Complete:
      device=eth0, addr=192.168.1.17, mask=255.255.255.0, gw=192.168.1.1,
     host=192.168.1.17, domain=, nis-domain=(none),
     bootserver=192.168.1.2, rootserver=192.168.1.2, rootpath=
Looking up port of RPC 100003/2 on 192.168.1.2
Looking up port of RPC 100005/1 on 192.168.1.2
VFS: Unable to mount root fs via NFS, trying floppy.
VFS: Cannot open root device "nfs" or unknown-block(2,0)
Please append a correct "root=" boot option; here are the available partitions:
1f00        256 mtdblock0 (driver?)
1f01        128 mtdblock1 (driver?)
1f02       2048 mtdblock2 (driver?)
1f03     259712 mtdblock3 (driver?)
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(2,0)
```

检查rpc状态：

```shell
linux@ubuntu:~$ nfsstat 
Server rpc stats:
calls      badcalls   badfmt     badauth    badclnt
3642       5          5          0          0       

Server nfs v3:
null             getattr          setattr          lookup           access           
10        0%     329       9%     0         0%     279       7%     162       4%     
readlink         read             write            create           mkdir            
58        1%     2677     75%     0         0%     0         0%     0         0%     
symlink          mknod            remove           rmdir            rename           
0         0%     0         0%     0         0%     0         0%     0         0%     
link             readdir          readdirplus      fsstat           fsinfo           
0         0%     0         0%     5         0%     0         0%     20        0%     
pathconf         commit           
0         0%     0         0%     

Server nfs v4:
null             compound         
2         2%     90       97%     

Server nfs v4 operations:
op0-unused       op1-unused       op2-future       access           close            
0         0%     0         0%     0         0%     8         3%     0         0%     
commit           create           delegpurge       delegreturn      getattr          
0         0%     0         0%     0         0%     0         0%     75       30%     
getfh            link             lock             lockt            locku            
14        5%     0         0%     0         0%     0         0%     0         0%     
lookup           lookup_root      nverify          open             openattr         
14        5%     0         0%     0         0%     0         0%     0         0%     
open_conf        open_dgrd        putfh            putpubfh         putrootfh        
0         0%     0         0%     77       31%     0         0%     3         1%     
read             readdir          readlink         remove           rename           
0         0%     2         0%     0         0%     0         0%     0         0%     
renew            restorefh        savefh           secinfo          setattr          
0         0%     0         0%     0         0%     0         0%     0         0%     
setcltid         setcltidconf     verify           write            rellockowner     
2         0%     2         0%     0         0%     0         0%     0         0%     
bc_ctl           bind_conn        exchange_id      create_ses       destroy_ses      
0         0%     0         0%     2         0%     1         0%     1         0%     
free_stateid     getdirdeleg      getdevinfo       getdevlist       layoutcommit     
0         0%     0         0%     0         0%     0         0%     0         0%     
layoutget        layoutreturn     secinfononam     sequence         set_ssv          
0         0%     0         0%     1         0%     42       17%     0         0%     
test_stateid     want_deleg       destroy_clid     reclaim_comp     allocate         
0         0%     0         0%     1         0%     1         0%     0         0%     
copy             copy_notify      deallocate       ioadvise         layouterror      
0         0%     0         0%     0         0%     0         0%     0         0%     
layoutstats      offloadcancel    offloadstatus    readplus         seek             
0         0%     0         0%     0         0%     0         0%     0         0%     
write_same       
0         0%     

Client rpc stats:
calls      retrans    authrefrsh
48         0          48      

Client nfs v4:
null             read             write            commit           open             
1         2%     0         0%     0         0%     0         0%     0         0%     
open_conf        open_noat        open_dgrd        close            setattr          
0         0%     0         0%     0         0%     0         0%     0         0%     
fsinfo           renew            setclntid        confirm          lock             
5        10%     0         0%     0         0%     0         0%     0         0%     
lockt            locku            access           getattr          lookup           
0         0%     0         0%     4         8%     6        12%     6        12%     
lookup_root      remove           rename           link             symlink          
1         2%     0         0%     0         0%     0         0%     0         0%     
create           pathconf         statfs           readlink         readdir          
0         0%     4         8%     0         0%     0         0%     1         2%     
server_caps      delegreturn      getacl           setacl           fs_locations     
9        18%     0         0%     0         0%     0         0%     4         8%     
rel_lkowner      secinfo          fsid_present     exchange_id      create_session   
0         0%     0         0%     0         0%     2         4%     1         2%     
destroy_session  sequence         get_lease_time   reclaim_comp     layoutget        
1         2%     0         0%     0         0%     1         2%     0         0%     
getdevinfo       layoutcommit     layoutreturn     secinfo_no       test_stateid     
0         0%     0         0%     0         0%     1         2%     0         0%     
free_stateid     getdevicelist    bind_conn_to_ses destroy_clientid seek             
0         0%     0         0%     0         0%     1         2%     0         0%     
allocate         deallocate       layoutstats      clone            
0         0%     0         0%     0         0%     0         0%     

linux@ubuntu:~$ 
```

发现client nfs有多个版本。

### 分析

怀疑服务端client nfs有多个版本，可能在客户端需要指定版本。

### 修复

1. 修改客户端(s3c2440)u-boot中bootargs设置：

   ```
bootargs=noinitrd console=ttySAC0 root=/dev/nfs nfsroot=192.168.1.2:/home/linux/workspace/s3c2440/my-s3c2440/build_root/first_fs,v3 ip=192.168.1.17:192.168.1.2:192.168.1.1:255.255.255.0::eth0:off init=/linuxrc
   ```

2. 启动信息：

   ```
   IP-Config: Complete:
         device=eth0, addr=192.168.1.17, mask=255.255.255.0, gw=192.168.1.1,
        host=192.168.1.17, domain=, nis-domain=(none),
        bootserver=192.168.1.2, rootserver=192.168.1.2, rootpath=
   Looking up port of RPC 100003/3 on 192.168.1.2
   Looking up port of RPC 100005/3 on 192.168.1.2
   VFS: Mounted root (nfs filesystem).
   Freeing init memory: 140K
   init started: BusyBox v1.7.0 (2023-04-29 15:25:37 CST)
   starting pid 767, tty '': '/etc/init.d/rcS'
   
   Please press Enter to activate this console. 
   ```
   
   
   
   
   
   

