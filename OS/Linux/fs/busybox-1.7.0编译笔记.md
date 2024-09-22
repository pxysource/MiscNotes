# `make menuconfig`

错误信息：

```
linux@ubuntu:~/workspace/s3c2440/my-s3c2440/busybox-1.7.0$ make menuconfig
Makefile:405: *** mixed implicit and normal rules: deprecated syntax
Makefile:1242: *** mixed implicit and normal rules: deprecated syntax
make: *** No rule to make target 'menuconfig'. Stop.
```

分析原因：

新版Makefile不支持这样的组合目标：config %config(一个有通配符，另一个没有通配符)

解决方法:

要么把config %config拆成2个规则，要么把其中一个目标去掉。

解决：

1. 修改busybox-1.7.0 顶层Makefile 405行:

   ```makefile
   config %config: scripts_basic outputmakefile FORCE
   ```

   改为:

   ```makefile
   %config:scripts_basic outputmakefile FORCE
   ```

2. 修改busybox-1.7.0 顶层Makefile 1242行:

   ```Makefile
   / %/: prepare scripts FORCE
   ```
   
   改为:
   
   ```Makefile
   %/: prepare scripts FORCE
   ```