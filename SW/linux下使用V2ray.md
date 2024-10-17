# 简介

OS: `Ubuntu 16.04`

# 安装v2ray

运行脚本`instal_v2ray.sh`，安装`v2ray`，如果下载很慢，可以手动下载后，将`v2ray-linux-64.zip`放到workspace目录。

- 下载[v2ray-core](https://github.com/v2ray/v2ray-core/releases)，v2ray-linux-64.zip。（如果脚本可以下载成功，则无需进行此操作）

- 使用自己配置的`config.json`文件替换`config.json`文件。（配置文件放到脚本同路径即可）

# 使用v2ray

启动V2ray服务

```shell
sudo systemctl start v2ray.service
```

检查V2ray服务运行状态

```shell
sudo systemctl status v2ray.service
```

设置V2ray服务开机自启动

```shell
sudo systemctl enable v2ray.service
```

# 设置系统代理

## 通过界面设置

`System Settings` --> `Network` --> `Network proxy`，设置代理。

## 命令行设置

```shell
source set_proxy.sh
```

# proxychain使用

## 方法1 apt安装

### 安装

```shell
sudo apt install proxychains
```

### 修改配置文件

```shell
sudo vi /etc/proxychains.conf
```

在文件最后删除其他代理方式（如`socks4`，`http`），并添加如下配置。

```
socks5 127.0.0.1 6789
```

端口号改为自己使用的代理软件设置的端口。

### 测试

```shell
proxychains wget https://example.com/index.html
```

:warning: 使用失败！

## 方法2 源代码编译安装

### 安装及配置

运行v2ray服务后，运行`install_proxychains.sh`

### 测试

```shell
linux@ubuntu16-virtual-machine:~/Downloads$ proxychains wget https://example.com/index.html
ProxyChains-4.0 (https://github.com/haad/proxychains)
Proxified environment setup
PROXYCHAINS_CONF_FILE = 
LD_PRELOAD = 
[proxychains] DLL init
--2024-10-17 16:53:26--  https://example.com/index.html
Connecting to 127.0.0.1:6790... connected.
Proxy request sent, awaiting response... 200 OK
Length: 1256 (1.2K) [text/html]
Saving to: ‘index.html’

index.html                                        100%[=============================================================================================================>]   1.23K  --.-KB/s    in 0s      

2024-10-17 16:53:29 (34.3 MB/s) - ‘index.html’ saved [1256/1256]


```



