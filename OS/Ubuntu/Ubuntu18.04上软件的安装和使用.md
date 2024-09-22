# 切换软件源，如“清华”

# 1 安装update

```shell
sudo apt update
```

# 2 安装net-tools工具包

```shell
sudo apt install net-tools
```

# 3 安装ifconfig

```shell
sudo apt install ifconfig
```

# 4 安装vim编辑器

- 选择一种进行安装

```shell
sudo apt install vim
sudo apt install vim-gtk3
sudo apt install vim-tiny
sudo apt install neovim
sudo apt install vim-athena
sudo apt install vim-gtk
sudo apt install vim-nox
```

# 5 安装gcc

```shell
sudo apt install gcc
```

# 6 安装VMware tools

​	https://blog.csdn.net/zxf1242652895/article/details/78203473

1. 先打开ubuntu

2. 在VMware的查看栏目中，选择安装VMware tools(T)....

3. 选择好安装后，弹出是否"确实要断开连接并覆盖锁定设置吗？"的对话框，选择"是"。

4. 在Ubuntu中打开工具，会发现虚拟机设备下多了VMware Tools这一项，点击它，其里面有一个VMwareTools…tar.gz文件：
5. 接下来我们把VMwareTools…tar.gz文件提取到某个目录下，如桌面刚刚新建myfile目录下。

6. 提取完成后会发现桌面的myfile里面多了一个vmware-tools-distrib文件夹，这个正是我们待会安装需要用到的。

7. 然后进入到刚刚提取到的vmware-tools-distrib文件夹下，然后输入命令

   ```shell
   sudo ./vmware-install.pl
   ```

8. 上面的操作后就开始安装VMware Tools了，根据其提示输入yes/no，

   直到出现Enjoy, –the VMware team，就表示安装成功了，然后手动重启虚拟机。

9. 安装了VMware Tools后，虚拟机与主机可以通过“拖拽”来对传文件等；