# 简介

`inittab`文件的详细内容可以参考`busybox`源代码下的`examples/inittab`文件。

`busybox`的`init`程序会读取`/etc/inittab`文件。

# inittab中的指令

`inittab`由指令组成，指令的格式如下：

```
<id>:<runlevels>:<action>:<procss>
```

## id

每条指令的标识符，不能重复。

:warning: 对于`busybox`的`init`来说，`<id`>有着特殊的意义。

对于`busybox`而言`<id>`用来指定启动进程的控制`tty`，一般将串口或者LCD屏幕设置为`tty`。

## runlevels

对于`busybox`来说无用，设置为空即可。

## action

用于指定`<process>`可能用到的动作。

`busybox`支持的动作如下表所示：

| 动作       | 描述                                                         |
| ---------- | ------------------------------------------------------------ |
| sysinit    | 系统初始化的时候执行一次process                              |
| respawn    | process终止后立即启动一个新的process                         |
| askfirst   | 和respawn类似，在运行process之前在控制台上显示"Please press Enter to activate this console."。用户按下`Enter`键后才会执行process |
| wait       | 通知`init`，等待相应的进程执行完以后才能继续执行             |
| once       | 仅执行一次，并且不会等待process执行完成                      |
| restart    | 当`init`重启的时候才会执行process                            |
| ctrlaltdel | 当按下`ctrl+alt+del`组合键才会执行process                    |
| shutdown   | 关机的时候执行process                                        |

## process

执行程序，如程序、脚本或则命令等。

