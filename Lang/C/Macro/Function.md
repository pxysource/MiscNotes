# 宏函数写法

没有返回值的宏函数

```c
#define XXX() \
	do {\
	} while(0)
```

有返回值的宏函数

```c
#define XXX() \
	({\
	int ret = 0;\
    (ret);\
	})
```

# 