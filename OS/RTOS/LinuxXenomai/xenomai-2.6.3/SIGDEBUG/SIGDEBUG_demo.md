# 源代码

`sigdebug.c`

```c
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <signal.h>
#include <getopt.h>
#include <execinfo.h>
#include <sys/mman.h>
#include <native/task.h>

RT_TASK task;

void task_body (void *cookie)
{
    /* Ask Xenomai to warn us upon switches to secondary mode. */
    rt_task_set_mode(0, T_WARNSW, NULL);

    /* A real-time task always starts in primary mode. */

    for (;;) {
	rt_task_sleep(1000000000);
	/* Running in primary mode... */
	printf("Switched to secondary mode\n");
	/* ...printf() => write(2): we have just switched to secondary
	   mode: SIGDEBUG should have been sent to us by now. */
    }
}

static const char *reason_str[] = {
    [SIGDEBUG_UNDEFINED] = "undefined",
    [SIGDEBUG_MIGRATE_SIGNAL] = "received signal",
    [SIGDEBUG_MIGRATE_SYSCALL] = "invoked syscall",
    [SIGDEBUG_MIGRATE_FAULT] = "triggered fault",
    [SIGDEBUG_MIGRATE_PRIOINV] = "affected by priority inversion",
    [SIGDEBUG_NOMLOCK] = "missing mlockall",
    [SIGDEBUG_WATCHDOG] = "runaway thread",
};

void warn_upon_switch(int sig, siginfo_t *si, void *context)
{
    unsigned int reason = si->si_value.sival_int;
    void *bt[32];
    int nentries;

    printf("\nSIGDEBUG received, reason %d: %s\n", reason,
	   reason <= SIGDEBUG_WATCHDOG ? reason_str[reason] : "<unknown>");
    /* Dump a backtrace of the frame which caused the switch to
       secondary mode: */
    nentries = backtrace(bt,sizeof(bt) / sizeof(bt[0]));
    backtrace_symbols_fd(bt,nentries,fileno(stdout));
}

int main (int argc, char **argv)
{
    struct sigaction sa;
    int err;

    mlockall(MCL_CURRENT | MCL_FUTURE);

    sigemptyset(&sa.sa_mask);
    sa.sa_sigaction = warn_upon_switch;
    sa.sa_flags = SA_SIGINFO;
    sigaction(SIGDEBUG, &sa, NULL);

    err = rt_task_create(&task,"mytask",0,1,T_FPU);

    if (err) {
	fprintf(stderr,"failed to create task, code %d\n",err);
	return 0;
    }

    err = rt_task_start(&task,&task_body,NULL);

    if (err) {
	fprintf(stderr,"failed to start task, code %d\n",err);
	return 0;
    }

    pause();

    return 0;
}

```

# Makefile

```makefile
###### CONFIGURATION ######

### List of applications to be build
APPLICATIONS = sigdebug

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
zynq> ./sigdebug 

SIGDEBUG received, reason 2: invoked syscall
./sigdebug[0x89b4]
/lib/libc.so.6(__default_rt_sa_restorer_v2+0x0)[0xb6d63e80]
/lib/libc.so.6(__fxstat64+0x14)[0xb6dfd32c]
/lib/libc.so.6(_IO_file_doallocate+0x28)[0xb6d95aac]
/lib/libc.so.6(_IO_doallocbuf+0x3c)[0xb6da54bc]
/lib/libc.so.6(_IO_file_overflow+0x190)[0xb6da44cc]
/lib/libc.so.6(_IO_file_xsputn+0x54)[0xb6da3320]
/lib/libc.so.6(_IO_puts+0xc0)[0xb6d98c20]
./sigdebug[0x893c]
/lib/libnative.so.3(+0x49ec)[0xb6ee69ec]
/lib/libpthread.so.0(+0x7038)[0xb6ebb038]
/lib/libc.so.6(clone+0x88)[0xb6e0e488]
Switched to secondary mode
Switched to secondary mode

SIGDEBUG received, reason 2: invoked syscall
./sigdebug[0x89b4]
/lib/libc.so.6(__default_rt_sa_restorer_v2+0x0)[0xb6d63e80]
/lib/libc.so.6(__write+0x44)[0xb6dfe684]
/lib/libc.so.6(_IO_file_write+0x4c)[0xb6da2ad8]
/lib/libc.so.6(+0x6f9bc)[0xb6da29bc]
/lib/libc.so.6(_IO_do_write+0x18)[0xb6da400c]
/lib/libc.so.6(_IO_file_overflow+0x8c)[0xb6da43c8]
/lib/libc.so.6(__overflow+0x20)[0xb6da5240]
/lib/libc.so.6(_IO_puts+0x1a8)[0xb6d98d08]
./sigdebug[0x893c]
/lib/libnative.so.3(+0x49ec)[0xb6ee69ec]
/lib/libpthread.so.0(+0x7038)[0xb6ebb038]
/lib/libc.so.6(clone+0x88)[0xb6e0e488]
Switched to secondary mode

SIGDEBUG received, reason 2: invoked syscall
./sigdebug[0x89b4]
/lib/libc.so.6(__default_rt_sa_restorer_v2+0x0)[0xb6d63e80]
/lib/libc.so.6(__write+0x44)[0xb6dfe684]
/lib/libc.so.6(_IO_file_write+0x4c)[0xb6da2ad8]
/lib/libc.so.6(+0x6f9bc)[0xb6da29bc]
/lib/libc.so.6(_IO_do_write+0x18)[0xb6da400c]
/lib/libc.so.6(_IO_file_overflow+0x8c)[0xb6da43c8]
/lib/libc.so.6(__overflow+0x20)[0xb6da5240]
/lib/libc.so.6(_IO_puts+0x1a8)[0xb6d98d08]
./sigdebug[0x893c]
/lib/libnative.so.3(+0x49ec)[0xb6ee69ec]
/lib/libpthread.so.0(+0x7038)[0xb6ebb038]
/lib/libc.so.6(clone+0x88)[0xb6e0e488]
Switched to secondary mode
```

查看实时任务状态，`MSW`在增加，表示实时任务在xenomai域与linux域中反复切换。

```shell
/tmp # cat /proc/xenomai/stat 
CPU  PID    MSW        CSW        PF    STAT       %CPU  NAME
  0  0      0          2046731    0     00500080   99.8  ROOT/0
  1  0      0          0          0     00500080   99.8  ROOT/1
  0  936    10         21         0     00340184    0.0  mytask
  1  0      0          43760035   0     00000000    0.2  IRQ29: [timer]
```

