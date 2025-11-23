# 宏定义

## Detailed boot stage timing

### CONFIG_BOOTSTAGE

定义这个选项，可以获取启动过程每个阶段的详细时间。

### CONFIG_BOOTSTAGE_REPORT

定义这个选项，可以在启动前打印一份报告，类似于下面这样：

```
    Timer summary in microseconds:
           Mark    Elapsed  Stage
          0          0  reset
      3,575,678  3,575,678  board_init_f start
      3,575,695         17  arch_cpu_init A9
      3,575,777         82  arch_cpu_init done
      3,659,598     83,821  board_init_r start
      3,910,375    250,777  main_loop
     29,916,167 26,005,792  bootm_start
     30,361,327    445,160  start_kernel
```

`board_init_f`:

- U-Boot 从启动到 `board_init_f` 点用了 **3,575,678 微秒 **。

- 因为是第一个标记点，所以 `Elapsed == Mark`。

`arch_cpu_init`:

- 到 `arch_cpu_init` 用了 **3,575,695 微秒**。

- 从上一个阶段 `arch_cpu_init` 开始到现在，耗时 **17 微秒**。