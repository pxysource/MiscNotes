# 简介

使用`qemu`进行模拟硬件，测试`zephyr`。

开发环境：

- Host：`windows11`

# 安装qemu

先安装`msys2`，然后在`msys2`中安装`qemu`，然后设置windows环境变量。

# x86

```bat
west build -b qemu_x86 samples/hello_world -p always
```

运行：

```bat
west build -t run
```

# cortex-m3

```bat
west build -b qemu_cortex_m3 samples/hello_world -p always
```

运行：

```bat
west build -t run
```


