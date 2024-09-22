# 简介

u-boot启动过程分析。

## 版本

- u-boot：1.1.6
- cpu：arm920t

# start.S(cpu/arm920t/)

1. 设置cpu为管理模式（SVC32模式）
2. 关看门狗
3. 屏蔽中断
4. 初始化，主要时SDRAM初始化
5. 设置栈
6. 时钟
7. 代码重定位，从flash复制到SDRAM
8. 清除BSS段
9. 调用start_armboot

# board.c(lib_arm/)

1. 一系列初始化
2. flash_init
3. nand_init
4. 调用main_loop

# main_loop(common/)

1. 启动内核：

   ```c
   s = getenv("bootcmd");
   run_command(s);
   ```

2. u-boot界面:

   ```
   读入串口的数据;
   run_command;
   ```

# u-boot命令

