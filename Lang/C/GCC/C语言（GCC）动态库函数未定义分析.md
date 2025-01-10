# 简介

动态库函数只进行声明，而不进行定义，在动态库链接动态库这种情形下，不会报编译错误，本片笔记描述如何对这种情况加以使用。

# 2 so+so（允许编译未定义）

依赖关系：`libso1.so`依赖`libso2.so`。

## 2.1 so2库

`so2.h`：

```c
#ifndef SO2_H_
#define SO2_H_

int so2_func1();

// 未定义
int so1_func2();

#endif  // SO2_H_
```

`so2.c`：

```c
#include <stdio.h>
#include "so2.h"

int so2_func1()
{
    printf("%s:%s:%d\n", __FILE__, __FUNCTION__, __LINE__);
    return 0;
}
```

## 2.2 so1库

`so1.h`：

```shell
#ifndef SO1_H_
#define SO1_H_

int so1_func1();
int so2_func2();

#endif  // So1_H_
```

`so1.c`：

```shell
#include <stdio.h>
#include "so1.h"
#include "so2.h"

int so1_func1()
{
    so2_func1();
    printf("%s:%s:%d\n", __FILE__, __FUNCTION__, __LINE__);
    return 0;
}

int so1_func2()
{
    so1_func2();
    printf("%s:%s:%d\n", __FILE__, __FUNCTION__, __LINE__);
    return 0;
}
```

## 2.3 编译

编译so2库：

```shell
linux@linux-virtual-machine:~/c/lib/so/undef_func$ gcc --shared -fPIC  -o libso2.so so2.h so2.c -Wall
```

编译`so1`库：

```shell
linux@linux-virtual-machine:~/c/lib/so/undef_func$ gcc --shared -fPIC  -o libso1.so so1.h so1.c -Wall -L. -lso2 -Wl,-rpath=.
so1.c: In function ‘so1_func2’:
so1.c:14:5: warning: implicit declaration of function ‘so2_func2’ [-Wimplicit-function-declaration]
     so2_func2();
     ^
```

编译提示`so2_func2()`未定义，检查`libso1.so`的依赖：

```shell
linux@linux-virtual-machine:~/c/lib/so/undef_func$ ldd libso1.so 
        linux-vdso.so.1 =>  (0x00007fff15bdf000)
        libso2.so => ./libso2.so (0x00007f19c72e7000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f19c6f1d000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f19c76eb000)
```

## 2.4 结论

编译通过

# 3 elf+so+so（不允许编译未定义）

依赖关系：`elf`依赖`libso1.so`依赖`libso2.so`。

库的代码如第二章所示。

## 3.1 elf

elf代码：main.c

```c
#include <stdio.h>
#include "so1.h"

int main()
{
    so1_func1();
    so2_func2();
    printf("%s:%s:%d\n", __FILE__, __FUNCTION__, __LINE__);
    return 0;
}
```

## 3.2 编译

```shell
linux@linux-virtual-machine:~/c/lib/so/undef_func$ gcc -o main main.c -Wall -L. -lso1 -Wl,-rpath=.
./libso1.so: undefined reference to `so2_func2'
collect2: error: ld returned 1 exit status
```

编译直接报错，找不到函数`so2_func2()`。

## 3.3 结论

编译不通过

# 4 elf+dl+so+so（绕过编译未定义）

依赖关系：

- `elf`依赖`libdl.so`
- `libso1.so`依赖`libso2.so`
- `elf`简介依赖`libso1.so`

库的代码如第二章所示。

## 4.1 elf

```c
#include <stdio.h>
#include <stdlib.h>
#ifdef __linux__
# ifndef __USE_GNU
#  define __USE_GNU
# endif
# include <dlfcn.h>
#endif

typedef int (*func_t)();

int main()
{
    func_t so1_func1 = NULL;
    func_t so1_func2 = NULL;

    void *handle = dlopen("libso1.so", RTLD_NOW | RTLD_GLOBAL);
    if (!handle)
    {
        fprintf(stderr, "Err: %s:%s:%d, 1, %s!\n", __FILE__, __FUNCTION__, __LINE__, dlerror());
        return -EXIT_FAILURE;
    }

    dlerror();
    so1_func1 = (func_t)dlsym(handle, "so1_func1");
    if (!so1_func1)
    {
        fprintf(stderr, "ERR: %s:%s:%d, 2, %s!\n", __FILE__, __FUNCTION__, __LINE__,  dlerror());
        return -EXIT_FAILURE;
    }

    dlerror();
    so1_func2 = (func_t)dlsym(handle, "so1_func2");
    if (!so1_func2)
    {
        fprintf(stderr, "ERR: %s:%s:%d, 3, %s!\n", __FILE__, __FUNCTION__, __LINE__,  dlerror());
        return -EXIT_FAILURE;
    }

    so1_func1();
    so1_func2();

    printf("%s:%s:%d\n", __FILE__, __FUNCTION__, __LINE__);
    return 0;
}
```

## 4.2 编译

```shell
linux@linux-virtual-machine:~/c/lib/so/undef_func$ gcc -o main main.c -Wall -ldl -Wl,-rpath=.
```

编译通过，查看依赖：

```shell
linux@linux-virtual-machine:~/c/lib/so/undef_func$ ldd ./main
        linux-vdso.so.1 =>  (0x00007fff7529b000)
        libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f99699bf000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f99695f5000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f9969bc3000)
```

## 4.3 运行

```shell
linux@linux-virtual-machine:~/c/lib/so/undef_func$ ./main 
Err: main.c:main:20, 1, ./libso1.so: undefined symbol: so2_func2!
```

加载动态库的时候，就会报错找不到函数`so2_func2()`。

## 4.3 结论

编译通过，运行错误，加载动态库时，就会报错提示找不到未定义的函数。



