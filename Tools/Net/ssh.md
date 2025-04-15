# 生成SSH key：ssh-kengen

## RSA

```shell
ssh-keygen -o -t rsa -C "example@163.com"
```

默认即可。

linux下，生成的文件保存在`~/.ssh`目录中：

```shell
ls ~/.ssh -l
total 8
-rw------- 1 linux linux 2610  4月 14 15:55 id_rsa
-rw-r--r-- 1 linux linux  576  4月 14 15:55 id_rsa.pub
```

