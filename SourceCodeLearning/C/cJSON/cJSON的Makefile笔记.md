# fstack-protector-strong

- -fstack-protector

> -fstack-protector
>
> Emit extra code to check for buffer overflows, such as stack
>
> smashing attacks.  This is done by adding a guard variable to
>
> functions with vulnerable objects.  This includes functions that
>
> call "alloca", and functions with buffers larger than 8 bytes.  The
>
> guards are initialized when a function is entered and then checked
>
> when the function exits.  If a guard check fails, an error message
>
> is printed and the program exits.
>
> 
>
> 发出额外的代码检查缓冲区溢出，例如堆栈粉碎攻击。这
> 是通过向具有易受攻击对象的函数添加一个保护变量来完成的。 这包括调用“ alloca”的函数以及缓冲区大于8个字节的函数。当进入函数时，将初始化防护，然后在函数退出时进行检查。如果防护检查失败，则会显示一条错误消息，并退出程序。



- -fstack-protector-all

> -fstack-protector-all
>
> Like -fstack-protector except that all functions are protected.
>
> 
>
> 与-fstack-protector相似，除了所有函数均受保护。



- -fstack-protector-strong

> -fstack-protector-strong
>
> Like -fstack-protector but includes additional functions to be
>
> protected --- those that have local array definitions, or have
>
> references to local frame addresses.
>
> 
>
> 与-fstack-protector类似，但包括要保护的其他函数---具有本地数组定义或引用本地帧地址的函数。





# gcc -dumpversion

> -dumpversion
>
> Print the compiler version (for example, 3.0, 6.3.0 or 7)---and
>
> don't do anything else.  This is the compiler version used in
>
> filesystem paths, specs, can be depending on how the compiler has
>
> been configured just a single number (major version), two numbers
>
> separated by dot (major and minor version) or three numbers
>
> separated by dots (major, minor and patchlevel version).

-  打印gcc的版本号

```shell
linux@ubuntu:~$ gcc -dumpversion
7
```





