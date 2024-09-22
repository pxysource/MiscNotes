---
title: gcc使用
date: 2024-05-25
categories: Compiler
tags: gcc
toc: true
---

gcc使用总结：

- gcc编译器的一些常用的选项。

<!-- more -->

# -fno-builtin

使用此选项可以替换glibc中的函数定义

```c
/**
 * @file main.c
 * @author panxingyuan (panxingyuan1@163.com)
 * @brief Redefine the "printf" function of the glibc.
 * @version 0.1
 * @date 2022-07-10 09:46:44
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <stdio.h>

int printf(const char *fmt, ...)
{
    fprintf(stdout, "This is my printf.\n");
    return 0;
}

int main(void)
{
    printf("xxxxx\n");
    return 0;
}

```

不使用选项`-fno-builtin`

```shell
linux@ubuntu:~/c/test$ gcc main.c -o main -Wall
linux@ubuntu:~/c/test$ ./main 
xxxxx

```

使用选项`-fno-builtin`

```shell
linux@ubuntu:~/c/test$ gcc main.c -o main -Wall -fno-builtin
linux@ubuntu:~/c/test$ ./main 
This is my printf.

```

