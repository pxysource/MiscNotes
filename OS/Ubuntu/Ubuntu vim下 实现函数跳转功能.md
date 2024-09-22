# 1 Ubuntu vim下 实现函数跳转功能

安装exuberant-ctags

```shell
 sudo apt-get install exuberant-ctags       
```

在每次使用时，需要初始化tags，即可生成一个tags文件, 这个文件包含所有函数和变量的索引列表。

　　进入项目的顶级目录，输入

```shell
ctags -R
```

vim编辑时

　　vim中光标位置按“Ctrl + ]”跳转，使用“Crtl + T”返回

  按了多少次“CTRL + ]”，就可以按多少次“CTRL + T”原路返回

　　使用 set mouse=a 时，还可以通过 Ctrl + 鼠标左键 跳转，Crtl + 鼠标右键返回。

**ctags常用用法：**