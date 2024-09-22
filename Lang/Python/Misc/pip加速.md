# 1 简介

- pip下载加速，主要为换源（更换为国内的源）

# 2 临时加速

- pip下载时临时指定国内的镜像站点，如使用“清华”源

```
python -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple package_name
```



- 国内常用镜像站点

```
清华：https://pypi.tuna.tsinghua.edu.cn/simple
阿里云：http://mirrors.aliyun.com/pypi/simple/
中国科技大学 https://pypi.mirrors.ustc.edu.cn/simple/
华中理工大学：http://pypi.hustunique.com/
山东理工大学：http://pypi.sdutlinux.org/ 
豆瓣：http://pypi.douban.com/simple/
```

# 3 永久加速（配置文件）

## 3.1 Windows

1. 方法1，在%USERPROFILE%路径下创建pip目录，并建立一个pip.ini文件，文件内容如下：

```
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
```

2. 方法2， 命令行

```
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```

## 3.2 Linux

- linux下，修改 ~/.pip/pip.conf (没有就创建一个)， 修改 index-url 至镜像源地址，内容如下：

```shell
cd~
mkdir pip
cd pip
vi pip.conf

# 文件内容
[global]
timeout = 60
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = pypi.douban.com
```

