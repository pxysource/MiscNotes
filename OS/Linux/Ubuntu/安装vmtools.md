# open-vm-tools

- 主要vm的工具

# open-vm-tools-desktop

- 拖拽文件，复制粘贴

# open-vm-tools-dkms

- 共享文件夹

注意：不同的源，可能包名称不同。

# 开启共享文件夹

- 确保vm-tools都已经安装。

- sudo vmhgfs-fuse .host:/  /mnt/hgfs，如果报错找不到文件夹，则新建hgfs。

- 开启后，如果普通用户没有权限，则进行一下设置

  ```shell
  sudo vmhgfs-fuse .host:/  /mnt/hgfs -o allow_other -o nonempty
  ```

  