# 搭建git环境

## 安装

```shell
sudo apt-get install git
```
## 配置用户名和邮箱

配置用户名：

```shell
git config --global user.name "pxysource"
```
配置邮箱：
```shell
git config --global user.email "panxingyuan1@163.com"
```

`git config --list`查看用户名和邮箱是否设置成功：

```shell
linux@linux-virtual-machine:~/github$ git config --list
user.name=pxysource
user.email=panxingyuan1@163.com
```

## 配置SSH key

### rsa key（可能报错）

`ssh-keygen -t rsa -C "panxingyuan1@163.com"`配置SSH key：

```shell
linux@linux-virtual-machine:~/github$ ssh-keygen -t rsa -C "panxingyuan1@163.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/home/linux/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/linux/.ssh/id_rsa.
Your public key has been saved in /home/linux/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:jYRHan4hbx310Yan5qiDP8+vR3SOPAi/jiK5Zc7s7uk panxingyuan1@163.com
The key's randomart image is:
+---[RSA 2048]----+
|        .   . .o |
|       +   . ...+|
|      = + .   .+ |
|     o = =..  + .|
|      . S oo B + |
|       o    + * .|
|       .o. . o . |
|      o*o.+o. .  |
|      .BEoo==+.  |
+----[SHA256]-----+

```

一直空格知道结束，密钥默认位置`~/.ssh/`：

- id_rsa，私钥
- id_rsa.pub，公钥

```shell
linux@linux-virtual-machine:~/github$ vi ~/.ssh/
id_rsa       id_rsa.pub   known_hosts  
```

复制公钥文件的内容，添加到github。

:warning: 此种加密clone项目会报错。如下：

> linux@linux-virtual-machine:~/github$ git clone git@github.com:pxysource/linux_dev.git
> Cloning into 'linux_dev'...
> ERROR: You're using an RSA key with SHA-1, which is no longer allowed.
> Please use a newer client or a different key type.
> Please see https://github.blog/2021-09-01-improving-git-protocol-security-github/ for more information.
>
> fatal: Could not read from remote repository.
>
> Please make sure you have the correct access rights
> and the repository exists.

### ecdsa key（推荐）

`ssh-keygen -t ecdsa -C "panxingyuan1@163.com"`配置SSH key：

```shell
linux@linux-virtual-machine:~/github$ ssh-keygen -t ecdsa -C "panxingyuan1@163.com"
Generating public/private ecdsa key pair.
Enter file in which to save the key (/home/linux/.ssh/id_ecdsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/linux/.ssh/id_ecdsa.
Your public key has been saved in /home/linux/.ssh/id_ecdsa.pub.
The key fingerprint is:
SHA256:OJxl/jbUKbXVbf/1/jTxGOg7V5Jf5OvLiNEqq1Cggy0 panxingyuan1@163.com
The key's randomart image is:
+---[ECDSA 256]---+
|                 |
|               ..|
|     .  o   . . +|
|  o ...*   o = .o|
| E +  =.S o = .=o|
|  . . .. o o. ooX|
|     .    +....=B|
|      .  o .=.++o|
|       ...oo.+.+=|
+----[SHA256]-----+
```

一直空格知道结束，密钥默认位置`~/.ssh/`：

- id_ecdsa，私钥
- id_ecdsa.pub，公钥

```shell
linux@linux-virtual-machine:~/.ssh$ ls
id_ecdsa  id_ecdsa.pub  id_rsa  id_rsa.pub  known_hosts
```

复制公钥文件的内容，添加到github。
