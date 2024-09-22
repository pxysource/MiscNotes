# 源代码

`rtprint.c`

```c
#include <stdio.h>                                                                                                 
#include <sys/mman.h>
#include <native/task.h>
#include <rtdk.h>

void task2_func(void *arg)
{
    int i = 0;

    // 任务中第一次调用会自动进行`rtprint`初始化。
    rt_printf("This triggers auto-init of rt_print for the "
          "calling thread.\n"
          "A last switch to secondary mode can occure here, "
          "but future invocations of rt_printf are safe.\n");

    // 当前实时任务切换到linux域（发起linux系统调用）中时，xenomai内核会发起SIGDEBUG（SIGXCPU）信号。
    rt_task_set_mode(0, T_WARNSW, NULL);

    while (1) {
        rt_task_sleep(3333333LL);
        rt_fprintf(stderr, "%s: #%d Yet another RT printer - "
               "but to stderr.\n", rt_print_buffer_name(), ++i);
    }   
}

int main(int argc, char **argv)
{
    RT_TASK task1, task2;
    int i = 0;

    mlockall(MCL_CURRENT|MCL_FUTURE);

    /* Perform auto-init of rt_print buffers if the task doesn't do so */
    rt_print_auto_init(1);

    /* Initialise the rt_print buffer for this task explicitly */
    rt_print_init(4096, "Task 1");

    rt_task_shadow(&task1, "Task 1", 10, 0);
    rt_task_spawn(&task2, "Task 2", 0, 11, 0, task2_func, NULL);

    /* To demonstrate that rt_printf is safe */
    rt_task_set_mode(0, T_WARNSW, NULL);

    while (1) {
        rt_task_sleep(5000000LL);
        rt_printf("%s: #%d Hello RT world!\n",
              rt_print_buffer_name(), ++i);
    }
}
```
:information_source: `rtprint`使用方法：

1. 非实时代码，调用`rt_print_auto_init(1)`进行初始化。
2. 在实时任务中，进入核心实时代码部分（必须实时）前调用`rt_printf()`进行自动初始化。
3. 核心核心实时代码部分（必须实时）调用`rt_printf()`进行打印。

# Makefile

```makefile
###### CONFIGURATION ######

### List of applications to be build
APPLICATIONS = rtprint

### Note: to override the search path for the xeno-config script, use "make XENO=..."


### List of modules to be build
MODULES =

### Note: to override the kernel source path, use "make KSRC=..."



###### USER SPACE BUILD (no change required normally) ######
ifeq ($(KERNELRELEASE),)
ifneq ($(APPLICATIONS),)

### Default Xenomai installation path
XENO ?= /usr/xenomai

XENOCONFIG=$(shell PATH=$(XENO):$(XENO)/bin:$(PATH) which xeno-config 2>/dev/null)

### Sanity check
ifeq ($(XENOCONFIG),)
all::
	@echo ">>> Invoke make like this: \"make XENO=/path/to/xeno-config\" <<<"
	@echo
endif


CC=$(shell $(XENOCONFIG) --cc)

CPPFLAGS=$(shell $(XENOCONFIG) --skin=native --cflags) $(MY_CFLAGS)

LDFLAGS=$(MY_LDFLAGS)
LDLIBS=$(shell $(XENOCONFIG) --skin=native --ldflags)

# This includes the library path of given Xenomai into the binary to make live
# easier for beginners if Xenomai's libs are not in any default search path.
LOADLIBES+=-Xlinker -rpath -Xlinker $(shell $(XENOCONFIG) --libdir)

all:: $(APPLICATIONS)

clean::
	$(RM) $(APPLICATIONS) *.o

endif
endif



###### KERNEL MODULE BUILD (no change required normally) ######
ifneq ($(MODULES),)

### Default to sources of currently running kernel
KSRC ?= /lib/modules/$(shell uname -r)/build

OBJS     := ${patsubst %, %.o, $(MODULES)}
CLEANMOD := ${patsubst %, .%*, $(MODULES)}
PWD      := $(shell if [ "$$PWD" != "" ]; then echo $$PWD; else pwd; fi)

### Kernel 2.6 or 3.0
PATCHLEVEL:=$(shell sed 's/PATCHLEVEL = \(.*\)/\1/;t;d' $(KSRC)/Makefile)
VERSION:=$(shell sed 's/VERSION = \(.*\)/\1/;t;d' $(KSRC)/Makefile)
ifneq ($(VERSION).$(PATCHLEVEL),2.4)

obj-m        := $(OBJS)
EXTRA_CFLAGS := -I$(KSRC)/include/xenomai -I$(KSRC)/include/xenomai/posix $(ADD_CFLAGS)

all::
	$(MAKE) -C $(KSRC) SUBDIRS=$(PWD) modules

### Kernel 2.4
else

ARCH    ?= $(shell uname -i)
INCLUDE := -I$(KSRC)/include/xenomai -I$(KSRC)/include/xenomai/compat -I$(KSRC)/include/xenomai/posix
CFLAGS  += $(shell $(MAKE) -s -C $(KSRC) CC=$(CC) ARCH=$(ARCH) SUBDIRS=$(PWD) modules) $(INCLUDE)

all:: $(OBJS)

endif

## Target for capturing 2.4 module CFLAGS
modules:
	@echo "$(CFLAGS)"

clean::
	$(RM) $(CLEANMOD) *.o *.ko *.mod.c Module*.symvers Module.markers modules.order
	$(RM) -R .tmp*

endif

```

# 编译

```shell
make XENO=/usr/xenomai
```

# 运行

```shell
zynq> ./rtprint 
This triggers auto-init of rt_print for the calling thread.
A last switch to secondary mode can occure here, but future invocations of rt_printf are safe.
b6d44470: #1 Yet another RT printer - but to stderr.
b6f33000 Task 1: #1 Hello RT world!
b6d44470: #2 Yet another RT printer - but to stderr.
b6d44470: #3 Yet another RT printer - but to stderr.
b6f33000 Task 1: #2 Hello RT world!
b6d44470: #4 Yet another RT printer - but to stderr.
b6f33000 Task 1: #3 Hello RT world!
b6d44470: #5 Yet another RT printer - but to stderr.
b6d44470: #6 Yet another RT printer - but to stderr.
b6f33000 Task 1: #4 Hello RT world!
b6d44470: #7 Yet another RT printer - but to stderr.
b6f33000 Task 1: #5 Hello RT world!
b6d44470: #8 Yet another RT printer - but to stderr.
b6d44470: #9 Yet another RT printer - but to stderr.
b6f33000 Task 1: #6 Hello RT world!
b6d44470: #10 Yet another RT printer - but to stderr.
b6f33000 Task 1: #7 Hello RT world!
b6d44470: #11 Yet another RT printer - but to stderr.
b6d44470: #12 Yet another RT printer - but to stderr.
b6f33000 Task 1: #8 Hello RT world!
b6d44470: #13 Yet another RT printer - but to stderr.
b6f33000 Task 1: #9 Hello RT world!
b6d44470: #14 Yet another RT printer - but to stderr.
b6d44470: #15 Yet another RT printer - but to stderr.
b6f33000 Task 1: #10 Hello RT world!
b6d44470: #16 Yet another RT printer - but to stderr.
b6f33000 Task 1: #11 Hello RT world!
b6d44470: #17 Yet another RT printer - but to stderr.
b6d44470: #18 Yet another RT printer - but to stderr.
b6f33000 Task 1: #12 Hello RT world!
b6d44470: #19 Yet another RT printer - but to stderr.
b6f33000 Task 1: #13 Hello RT world!
b6d44470: #20 Yet another RT printer - but to stderr.
b6d44470: #21 Yet another RT printer - but to stderr.
b6f33000 Task 1: #14 Hello RT world!
b6d44470: #22 Yet another RT printer - but to stderr.
b6f33000 Task 1: #15 Hello RT world!
b6d44470: #23 Yet another RT printer - but to stderr.
b6d44470: #24 Yet another RT printer - but to stderr.
b6f33000 Task 1: #16 Hello RT world!
```

检查实时任务执行情况，`rt_printf()`没有导致实时任务切换到linux域（`MSW`值正常）中，运行正常。

```shell
/tmp # cat /proc/xenomai/stat 
CPU  PID    MSW        CSW        PF    STAT       %CPU  NAME
  0  0      0          1871680    0     00500080   99.8  ROOT/0
  1  0      0          0          0     00500080   99.8  ROOT/1
  0  920    1          841        0     00340184    0.0  Task 1
  0  922    0          1259       0     00340184    0.0  Task 2
  1  0      0          42207427   0     00000000    0.2  IRQ29: [timer]
```



