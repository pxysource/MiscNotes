# 方法1：替换少量函数

测试代码：

```c
#include <stdio.h>
#include <stdlib.h>

void *__wrap_malloc(size_t size)
{
    printf("This is my malloc.\n");
    return __real_malloc(size);
}

int main()
{
    char *ptr = NULL;
    ptr = malloc(20);
    ptr[1] = 'a';
    printf("%c\n", ptr[1]);
    free(ptr);

    return 0;
}                      
```

编译：

```shell
gcc malloc_wrapper_test.c -o malloc_wrapper_test -Wall -Wl,--wrap=malloc
```

运行：

```shell
linux@linux-virtual-machine:~/c/test$ ./malloc_wrapper_test 
This is my malloc.
a
```

# 方法2：替换大量函数

`posxi.wrappers`文件内容：

```
--wrap malloc
```

编译：

```shell
gcc malloc_wrapper_test.c -o malloc_wrapper_test -Wall -Wl,@/home/linux/c/test/posix.wrappers
```

运行：

```shell
linux@linux-virtual-machine:~/c/test$ ./malloc_wrapper_test 
This is my malloc.
a
```

