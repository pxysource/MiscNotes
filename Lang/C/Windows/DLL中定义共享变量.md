在Windows中创建DLL工程，发现DLL工程中的全局变量不能在多个进程之间共享，即他们存在于不同的内存中，虽然变量的地址相同。

DLL中定义共享的变量：

```c
#pragma data_seg("KookNut")
int a = 1;
int b = 1;
#pragma data_seg()

#pragma comment(linker, "/SECTION:KootNut,RWS")
```

