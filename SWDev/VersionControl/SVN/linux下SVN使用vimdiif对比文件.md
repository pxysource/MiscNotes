# diffwrap脚本

```shell
linux@linux-virtual-machine:/usr/local/bin$ cat diffwrap.sh 
#!/bin/sh

DIFF=/usr/bin/vimdiff

LEFT=${6}
RIGHT=${7}

$DIFF $LEFT $RIGHT
```

# svn diff使用

当前位于文件的目录中。

```shell
svn diff --diff-cmd=/home/linux/linux_learn/shell/diffwrap.sh --old=master.c@2242 --new=master.c@2465
```

选项：

- `--diff-cmd`，指定diff程序。
- `--old`，旧版本。
- `--new`，新版本。