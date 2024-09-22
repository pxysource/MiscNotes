# Variable

## 变量取值

参考《GNU make中文手册.pdf》 **2.9.1** 变量取值。

变量定义解析的规则如下：

**IMMEDIATE = DEFERRED** 

**IMMEDIATE ?= DEFERRED** 

**IMMEDIATE := IMMEDIATE** 

**IMMEDIATE += DEFERRED or IMMEDIATE** 

**define IMMEDIATE** 

​	**DEFERRED** 

**Endef** 

当变量使用追加符（+=）时，如果此前这个变量是一个简单变量（使用 :=定义的）则认为它

是立即展开的，其它情况时都被认为是“延后”展开的变量。

### =

变量解析规则：**IMMEDIATE = DEFERRED**

`Makefile`:

```makefile
VARA = A
VARB = $(VARA) B
VARA = AA

all:
    @echo "VARB = $(VARB)"
```
执行`make`
```shell
linux@ubuntu:~/linux_learn/makefile_make/test$ make
VARB = AA B
```

`=`在`Makefile`中是延后展开的：将变量A赋值给变量B，假如变量A经过多次赋值，赋值给变量B的值是对变量A的最后一次赋值（即会将变量A的值全部展开）。

### :=

变量解析规则：**IMMEDIATE = IMMEDIATE **

`Makefile`:

```makefile
VARA = A
VARB := $(VARA) B
VARA = AA

all:
    @echo "VARB = $(VARB)"
```

执行`make`

```shell
linux@ubuntu:~/linux_learn/makefile_make/test$ make
VARB = A B
```

`:=`在`Makefile`中是立即展开的：将变量A赋值给变量B，赋值给变量B的值是当前语句之前对变量A的最后一次赋值（即不会将变量A的值全部展开）。

### ?=

变量解析规则：**IMMEDIATE ?= DEFERRED**

`Makefile`:

```makefile
VARA = A
VARB ?= $(VARA) B
VARC = C
VARA = AA
VARC ?= CC

all:
    @echo "VARB = $(VARB)"
    @echo "VARC = $(VARC)"
```

执行`make`

```shell
linux@ubuntu:~/linux_learn/makefile_make/test$ make
VARB = AA B
VARC = C
```

`?=`在`Makefile`中是延迟展开的：

- 如果没有定义变量，才会定义变量并为变量赋值。
- 将变量A赋值给变量B，假如变量A经过多次赋值，赋值给变量B的值是对变量A的最后一次赋值（即会将变量A的值全部展开）。

### +=

变量解析规则：**IMMEDIATE += DEFERRED or IMMEDIATE**

`Makefile`:

```makefile
VARA = A
VARB := $(VARA) B
VARC := C
VARC += $(VARA) + $(VARB)
VARD = D
VARD += $(VARA) + $(VARB)
VARA = AA
VARB = BB

all:
    @echo "VARC = $(VARC)"
    @echo "VARD = $(VARD)"
```

执行`make`

```shell
linux@ubuntu:~/linux_learn/makefile_make/test$ make
VARC = C A + A B
VARD = D AA + BB
```

当变量使用追加符（+=）时，如果此前这个变量是一个简单变量（使用 :=定义的）则认为它

是立即展开的，其它情况时都被认为是“延后”展开的变量。

# Function

## origin

参考《GNU make中文手册.pdf》 **7.9 origin**函数。

获取和此变量（参数）相关的信息，告诉我们这个变量的出处（定义方式）。

函数的返回情况`command line`和`file`测试：

`Makefile`:

```makefile

ifdef O
ifeq ("$(origin O)", "command line")
BUILD_DIR := $(O)
endif
endif

VARA = A
ifdef VARA
ifeq ("$(origin VARA)", "file")
VARB := $(VARA) B
endif
endif

all:
    @echo "BUILD_DIR = $(BUILD_DIR)"
    @echo "VARB = $(VARB)"
```

执行`make`

```shell
linux@ubuntu:~/linux_learn/makefile_make/function/origin$ make O=`pwd`
BUILD_DIR = /home/linux/linux_learn/makefile_make/function/origin
VARB = A B
```





