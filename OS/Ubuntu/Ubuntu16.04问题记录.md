# 双网卡上网异常

## 现象

`git clone`拉取项目超时。

`ping`百度与服务器都无法成功（会卡住）：

```shell
linux@linux-virtual-machine:~$ ping www.baidu.com
PING www.a.shifen.com (183.2.172.177) 56(84) bytes of data.
```

## 解决

```shell
linux@linux-virtual-machine:~$ ip route show
default via 192.168.1.101 dev ens36  proto static  metric 100 
default via 192.168.245.150 dev ens33  proto static  metric 101 
169.254.0.0/16 dev ens36  scope link  metric 1000 
192.168.1.0/24 dev ens36  proto kernel  scope link  src 192.168.1.199  metric 100 
192.168.245.0/24 dev ens33  proto kernel  scope link  src 192.168.245.227  metric 100 
```

第一个`default`为主，`metric`最小，Linux默认走这个外网。

但是`192.168.245.150`才能上外网。

删除路由`192.168.1.101`：

```shell
linux@linux-virtual-machine:~$ sudo ip route del default via 192.168.1.101 dev ens36
```

查看路由：

```shell
linux@linux-virtual-machine:~$ ip route
default via 192.168.245.150 dev ens33  proto static  metric 101 
169.254.0.0/16 dev ens36  scope link  metric 1000 
192.168.1.0/24 dev ens36  proto kernel  scope link  src 192.168.1.199  metric 100 
192.168.245.0/24 dev ens33  proto kernel  scope link  src 192.168.245.227  metric 100 
```

`ping`百度：

```shell
linux@linux-virtual-machine:~$ ping www.baidu.com
PING www.a.shifen.com (183.2.172.177) 56(84) bytes of data.
64 bytes from 183.2.172.177: icmp_seq=1 ttl=51 time=46.8 ms
```

网络正常。