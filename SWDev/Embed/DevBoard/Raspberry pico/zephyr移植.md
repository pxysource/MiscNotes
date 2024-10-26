# 简介

Raspberry Pi Pico使用zephyr。

- 硬件：`Raspberry Pi Pico WH`

# 安装依赖工具

安装`msys2`，之后通过`msys2`安装以下工具：

- `cmake`

- `ninja`
- `gperf`
- `python`
- `git`
- `dtc`
- `wget`
- `unzip`

# 搭建开发环境

创建工作目录：`D:\User\Documents\PicoWorkspace\ZephyrProject`

## 1. 创建`python`虚拟环境

```bat
python -m venv .venv
```

## 2. 切换到`python`虚拟环境

```bat
.venv\Scripts\activate.bat
```

## 3. 安装`west`：

```bat
pip install west
```

## 4. 使用`west`初始化`zephyr`

当前目录：`D:\User\Documents\PicoWorkspace`

```bat
west init .\ZephyrProject\
```

## 5. 使用`west`进行更新

当前目录：`D:\User\Documents\PicoWorkspace\ZephyrProject`

```bat
west update
```

## 6. 导出`cmake`：

```bat
west zephyr-export
```

## 7. 使用`pip`安裝`zephry`的`requirements`：

```bat
pip install -r .\zephyr\scripts\requirements.txt
```

## 8. 安裝Zephyr SDK

1. 下载最新的`zephyr` SDK，当前使用的是`zephyr-sdk-0.16.8_windows-x86_64.7z`
2. 解压缩

## 9. 配置Zephyr SDK的环境：

当前路径：`D:\User\Documents\PicoWorkspace\ZephyrProject\zephyr-sdk-0.16.8_windows-x86_64`

```bat
.\setup.cmd
```

# 快速构建Blinky

当前目录：`D:\User\Documents\PicoWorkspace\ZephyrProject\zephyr`

```bat
west build -b rpi_pico samples/basic/blinky
```

如果需要重新构建：

```bat
west build -b rpi_picow samples/basic/blinky -p always
```

将生成文件`zephyr.uf2`烧到板子上运行。

