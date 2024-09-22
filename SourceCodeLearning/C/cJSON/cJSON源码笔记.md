# #pragma GCC visibility push(default)

- 将符号标识为default或者hidden的另外一种方法是使用GCC4.0新引入的pragma指令。GCC可见性pragma的优点是可以快速地标识一整块函数，而不需要将可见性属性应用到每个函数中。这个pragma的用法如下：

```c
void f() { }

#pragma GCC visibility push(default)

void g() { }

void h() { }

#pragma GCC visibility pop
```

- 在这个例子中，函数g和h被标识为default，因此无论-fvisibility选项如何设置，都会输出；而函数f则遵循-fvisibility选项设置的任何值。push和pop两个关键字标识这个pragma可以被嵌套。

# \_\_attribute\_\_((visibility("default")))

- “default”：用它定义的符号将被导出，动态库中的函数默认是可见的。

- ”hidden”：用它定义的符号将不被导出，并且不能从其它对象进行使用，动态库中的函数是被隐藏的。

- default意味着该方法对其它模块是可见的。而hidden表示该方法符号不会被放到动态符号表里，所以其它模块(可执行文件或者动态库)不可以通过符号表访问该方法。

# #pragma GCC diagnostic push

使用：

```c
#pragma GCC diagnostic push

//指针类型转换，去掉类型限定符时忽略报错

#pragma GCC diagnostic ignored "-Wcast-qual"

//...代码

#pragma GCC diagnostic pop
```

> -Wcast-qual
>
> Warn whenever a pointer is cast so as to remove a type qualifier from the target type. For example, warn if a const char * is cast to an ordinary char *.
>
> Also warn when making a cast that introduces a type qualifier in an unsafe way. For example, casting char ** to const char ** is unsafe, as in this example:
>
> ```c
>   /* p is char ** value.  */
>   const char **q = (const char **) p;
>   /* Assignment of readonly string to const char * is OK.  */
>   *q = "string";
>   /* Now char** pointer points to read-only memory.  */
>   **p = 'b';
> ```

# C语言中%d与%i的区别

- 在printf格式串中使用时，没有区别

- 在scanf 格式串中使用时，有点区别，如下：
  - 在scanf格式中，%d只与十进制形式的整数相匹配。
  - 而%i 则可以匹配八进制、十进制、十六进制表示的整数。
  - 例如： 如果输入的数字有前缀 0（018、025），%i将会把它当作八进制数来处理，如果有前缀0x (0x54),它将以十六进制来处理。

```shell
linux@ubuntu:~/c/c_base/input_output_format$ cat %i_or_%d.c
#include <stdio.h>

int main (void)
{
    int a;
    int b;
    int c;
    int d;

    scanf ("%d", &a);
    scanf ("%i", &b);
    scanf ("%i", &c);
    scanf ("%i", &d);

    printf ("a = %d\ta = %i\n", a, a);
    printf ("b = %d\tb = %i\n", b, b);
    printf ("c = %d\tc = %i\n", c, c);
    printf ("d = %d\td = %i\n", d, d);

    return 0;
}
```

```shell
linux@ubuntu:~/c/c_base/input_output_format$ ./%i_or_%d 
0x55    #输入0x55直接结束程序了，%d只获取数字，而且是匹配成10进制数
a = 0	a = 0
b = 22035	b = 22035
c = -920755168	c = -920755168
d = 32764	d = 32764
```

```shell
linux@ubuntu:~/c/c_base/input_output_format$ ./%i_or_%d 
55
055
55
0x55
a = 55	a = 55  #打印时%d和%i没有区别
b = 45	b = 45
c = 55	c = 55
d = 85	d = 85
```

