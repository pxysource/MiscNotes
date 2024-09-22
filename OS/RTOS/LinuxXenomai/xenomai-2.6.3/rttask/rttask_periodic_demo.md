# 源代码

`trivial-periodic.c`

```c
#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <sys/mman.h>

#include <native/task.h>
#include <native/timer.h>

RT_TASK demo_task;

/* NOTE: error handling omitted. */

void demo(void *arg)
{
	RTIME now, previous;

	/*
	 * Arguments: &task (NULL=self),
	 *            start time,
	 *            period (here: 1 s)
	 */
	rt_task_set_periodic(NULL, TM_NOW, 1000000000);
	previous = rt_timer_read();

	while (1) {
		rt_task_wait_period(NULL);
		now = rt_timer_read();

		/*
		 * NOTE: printf may have unexpected impact on the timing of
		 *       your program. It is used here in the critical loop
		 *       only for demonstration purposes.
		 */
		printf("Time since last turn: %ld.%06ld ms\n",
		       (long)(now - previous) / 1000000,
		       (long)(now - previous) % 1000000);
		       previous = now;
	}
}

void catch_signal(int sig)
{
}

int main(int argc, char* argv[])
{
	signal(SIGTERM, catch_signal);
	signal(SIGINT, catch_signal);

	/* Avoids memory swapping for this program */
	mlockall(MCL_CURRENT|MCL_FUTURE);

	/*
	 * Arguments: &task,
	 *            name,
	 *            stack size (0=default),
	 *            priority,
	 *            mode (FPU, start suspended, ...)
	 */
	rt_task_create(&demo_task, "trivial", 0, 99, 0);

	/*
	 * Arguments: &task,
	 *            task function,
	 *            function argument
	 */
	rt_task_start(&demo_task, &demo, NULL);

	pause();

	rt_task_delete(&demo_task);

	return 0;
}

```

# Makefile

```makefile
###### CONFIGURATION ######

### List of applications to be build
APPLICATIONS = trivial-periodic

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
zynq> ./trivial-periodic 
Time since last turn: 999.998587 ms
Time since last turn: 999.996721 ms
Time since last turn: 1000.001068 ms
Time since last turn: 999.997576 ms
Time since last turn: 1000.000911 ms
Time since last turn: 1000.000072 ms
Time since last turn: 1000.001260 ms
Time since last turn: 999.998065 ms
Time since last turn: 1000.000888 ms
Time since last turn: 999.998755 ms
Time since last turn: 1000.001056 ms
Time since last turn: 999.998809 ms
Time since last turn: 1000.000666 ms
Time since last turn: 999.999340 ms
Time since last turn: 1000.000069 ms
Time since last turn: 1000.005322 ms
Time since last turn: 1000.004953 ms
Time since last turn: 999.995716 ms
Time since last turn: 999.999169 ms
Time since last turn: 1000.000249 ms
Time since last turn: 1000.002222 ms
Time since last turn: 999.999238 ms
Time since last turn: 1000.006327 ms
Time since last turn: 999.993757 ms
Time since last turn: 1000.006129 ms
Time since last turn: 1000.000504 ms
Time since last turn: 999.988639 ms
Time since last turn: 999.999865 ms
```

查看实时任务的状态，`MSW`一直在增加，说明实时任务切换到linux域（实时任务中调用了`printf()`函数）。

```shell
/ # cat /proc/xenomai/stat 
CPU  PID    MSW        CSW        PF    STAT       %CPU  NAME
  0  0      0          3402       0     00500080   99.8  ROOT/0
  1  0      0          0          0     00500080   99.8  ROOT/1
  0  782    22         45         0     00300184    0.0  trivial
  1  0      0          6888635    0     00000000    0.2  IRQ29: [timer]
/ # cat /proc/xenomai/stat 
CPU  PID    MSW        CSW        PF    STAT       %CPU  NAME
  0  0      0          3406       0     00500080   99.8  ROOT/0
  1  0      0          0          0     00500080   99.8  ROOT/1
  0  782    24         49         0     00300184    0.0  trivial
  1  0      0          6892854    0     00000000    0.2  IRQ29: [timer]
/ # cat /proc/xenomai/stat 
CPU  PID    MSW        CSW        PF    STAT       %CPU  NAME
  0  0      0          3408       0     00500080   99.8  ROOT/0
  1  0      0          0          0     00500080   99.8  ROOT/1
  0  782    25         51         0     00300184    0.0  trivial
  1  0      0          6895121    0     00000000    0.2  IRQ29: [timer]
```

