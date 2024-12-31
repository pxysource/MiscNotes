# 简介

`rt-tests` 是一组用于测试 Linux 实时性能的工具集，包含多个测试程序，用于评估系统在实时任务处理方面的能力。

# 交叉编译

## 交叉编译环境

目标平台：`Linux 4.9.255-rt170-yocto-preempt-rt`

编译平台：`Windows`

工具链：`i686-pc-linux-gnu-gcc.exe (crosstool-NG crosstool-ng-1.23.0) 7.3.0`

> $ i686-pc-linux-gnu-gcc --version
> i686-pc-linux-gnu-gcc.exe (crosstool-NG crosstool-ng-1.23.0) 7.3.0
> Copyright (C) 2017 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

## 安装msys2

:information_source: 为什么安装`msys2`？因为`rt-tests`依赖`autotools`，并且`autotools`的版本较新，`GnuWin32`中的工具不能满足要求。并且`msys2`使用更方便。

下载[msys2][1]安装包安装即可。

运行`msys2`，安装以下应用：

### 安装autotools

```shell
$ pacman -S autotools
$ pacman -S automake
$ pacman -S autoconf

```

### 安装python3

```shell
$ pacman -S python3
```

## 配置工具链

```shell
$ export PATH=/D/leetro/I7A/MinGw/bin:$PATH
```

## 编译libnuma

下载[numactl-2.0.19][2]，编译：

```shell
$ ./autogen.sh
$ ./configure --host=i686-pc-linux-gnu --prefix=/D/leetro/I7A/numactl-2.0.19/output
$ make
$ make install
```

为了编译方便，将生成的库复制到工具链c库目录下。

## 编译rt-tests-2.8

下载[rt-tests-2.8][3]，编译：

- no_libcpupower=1，不使用libcpupower库。（linux发行版才有这个开发库？）

```shell
$ make CROSS_COMPILE=i686-pc-linux-gnu- no_libcpupower=1
Makefile:52: libcpupower disabled, building without --deepest-idle-state support.
i686-pc-linux-gnu-gcc -Wall -Wno-nonnull -Wextra -Wno-sign-compare -O2 -g  -o cyclictest bld/cyclictest.o -lrt -lpthread -lrttest -Lbld -lrttestnuma -lnuma
i686-pc-linux-gnu-gcc -D VERSION=2.8 -c src/hackbench/hackbench.c -Wall -Wno-nonnull -Wextra -Wno-sign-compare -O2 -g -D_GNU_SOURCE -Isrc/include -o bld/hackbench.o
i686-pc-linux-gnu-gcc -Wall -Wno-nonnull -Wextra -Wno-sign-compare -O2 -g  -o hackbench bld/hackbench.o -lrt -lpthread
i686-pc-linux-gnu-gcc -D VERSION=2.8 -c src/pi_tests/pip_stress.c -Wall -Wno-nonnull -Wextra -Wno-sign-compare -O2 -g -D_GNU_SOURCE -Isrc/include -o bld/pip_stress.o
i686-pc-linux-gnu-gcc -Wall -Wno-nonnull -Wextra -Wno-sign-compare -O2 -g  -o pip_stress bld/pip_stress.o -lrt -lpthread -lrttest -Lbld
i686-pc-linux-gnu-gcc -D VERSION=2.8 -c src/pi_tests/pi_stress.c -Wall -Wno-nonnull -Wextra -Wno-sign-compare -O2 -g -D_GNU_SOURCE -Isrc/include -o bld/pi_stress.o
i686-pc-linux-gnu-gcc -Wall -Wno-nonnull -Wextra -Wno-sign-compare -O2 -g  -o pi_stress bld/pi_stress.o -lrt -lpthread -lrttest -Lbld
i686-pc-linux-gnu-gcc -D VERSION=2.8 -c src/pmqtest/pmqtest.c -Wall -Wno-nonnull -Wextra -Wno-sign-compare -O2 -g -D_GNU_SOURCE -Isrc/include -o bld/pmqtest.o
i686-pc-linux-gnu-gcc -Wall -Wno-nonnull -Wextra -Wno-sign-compare -O2 -g  -o pmqtest bld/pmqtest.o -lrt -lpthread -lrttest -Lbld -ldl
i686-pc-linux-gnu-gcc -D VERSION=2.8 -c src/ptsematest/ptsematest.c -Wall -Wno-nonnull -Wextra -Wno-sign-compare -O2 -g -D_GNU_SOURCE -Isrc/include -o bld/ptsematest.o
i686-pc-linux-gnu-gcc -Wall -Wno-nonnull -Wextra -Wno-sign-compare -O2 -g  -o ptsematest bld/ptsematest.o -lrt -lpthread -lrttest -Lbld -ldl
i686-pc-linux-gnu-gcc -D VERSION=2.8 -c src/rt-migrate-test/rt-migrate-test.c -Wall -Wno-nonnull -Wextra -Wno-sign-compare -O2 -g -D_GNU_SOURCE -Isrc/include -o bld/rt-migrate-test.o
i686-pc-linux-gnu-gcc -Wall -Wno-nonnull -Wextra -Wno-sign-compare -O2 -g  -o rt-migrate-test bld/rt-migrate-test.o -lrt -lpthread -lrttest -Lbld
i686-pc-linux-gnu-gcc -D VERSION=2.8 -c src/signaltest/signaltest.c -Wall -Wno-nonnull -Wextra -Wno-sign-compare -O2 -g -D_GNU_SOURCE -Isrc/include -o bld/signaltest.o
i686-pc-linux-gnu-gcc -Wall -Wno-nonnull -Wextra -Wno-sign-compare -O2 -g  -o signaltest bld/signaltest.o -lrt -lpthread -lrttest -Lbld -lrttestnuma -lnuma
i686-pc-linux-gnu-gcc -D VERSION=2.8 -c src/sigwaittest/sigwaittest.c -Wall -Wno-nonnull -Wextra -Wno-sign-compare -O2 -g -D_GNU_SOURCE -Isrc/include -o bld/sigwaittest.o
i686-pc-linux-gnu-gcc -Wall -Wno-nonnull -Wextra -Wno-sign-compare -O2 -g  -o sigwaittest bld/sigwaittest.o -lrt -lpthread -lrttest -Lbld -ldl
i686-pc-linux-gnu-gcc -D VERSION=2.8 -c src/svsematest/svsematest.c -Wall -Wno-nonnull -Wextra -Wno-sign-compare -O2 -g -D_GNU_SOURCE -Isrc/include -o bld/svsematest.o
i686-pc-linux-gnu-gcc -Wall -Wno-nonnull -Wextra -Wno-sign-compare -O2 -g  -o svsematest bld/svsematest.o -lrt -lpthread -lrttest -Lbld -ldl
i686-pc-linux-gnu-gcc -D VERSION=2.8 -c src/sched_deadline/cyclicdeadline.c -Wall -Wno-nonnull -Wextra -Wno-sign-compare -O2 -g -D_GNU_SOURCE -Isrc/include -o bld/cyclicdeadline.o
src/sched_deadline/cyclicdeadline.c: In function 'cgroup_mounted':
src/sched_deadline/cyclicdeadline.c:388:29: error: 'CGROUP2_SUPER_MAGIC' undeclared (first use in this function); did you mean 'CGROUP_SUPER_MAGIC'?
  ret = mounted(CGROUP_PATH, CGROUP2_SUPER_MAGIC);
                             ^~~~~~~~~~~~~~~~~~~
                             CGROUP_SUPER_MAGIC
src/sched_deadline/cyclicdeadline.c:388:29: note: each undeclared identifier is reported only once for each function it appears in
make: *** [Makefile:122: bld/cyclicdeadline.o] Error 1

```

错误：

```
'CGROUP2_SUPER_MAGIC' undeclared (first use in this function); did you mean 'CGROUP_SUPER_MAGIC'?
```

不编译cyclicdeadline.c与deadline_test.c

修改Makefile：

```makefile
sources = cyclictest.c \
	  hackbench.c \
	  pip_stress.c \
	  pi_stress.c \
	  pmqtest.c \
	  ptsematest.c \
	  rt-migrate-test.c \
	  signaltest.c iii\
	  sigwaittest.c \
	  svsematest.c  \
	  cyclicdeadline.c \
	  deadline_test.c \
	  queuelat.c \
	  ssdd.c \
	  oslat.c
```

改为：

```makefile
sources = cyclictest.c \
	  hackbench.c \
	  pip_stress.c \
	  pi_stress.c \
	  pmqtest.c \
	  ptsematest.c \
	  rt-migrate-test.c \
	  signaltest.c \
	  sigwaittest.c \
	  svsematest.c  \
	  queuelat.c \
	  ssdd.c \
	  oslat.c
```

重新编译

-----------------

安装：

```shell
$ make install DESTDIR=/D/leetro/I7A/rt-tests-2.8/output CROSS_COMPILE=i686-pc-linux-gnu- no_libcpupower=1
Makefile:66: libcpupower disabled, building without --deepest-idle-state support.
mkdir -p "/D/leetro/I7A/rt-tests-2.8/output/usr/local/share/man/man8"
cp src/cyclictest/cyclictest.8 src/pi_tests/pi_stress.8 src/ptsematest/ptsematest.8 src/rt-migrate-test/rt-migrate-test.8 src/sigwaittest/sigwaittest.8 src/svsematest/svsematest.8 src/pmqtest/pmqtest.8 src/hackbench/hackbench.8 src/signaltest/signaltest.8 src/pi_tests/pip_stress.8 src/queuelat/queuelat.8 src/queuelat/determine_maximum_mpps.8 src/sched_deadline/deadline_test.8 src/ssdd/ssdd.8 src/sched_deadline/cyclicdeadline.8 src/oslat/oslat.8 src/cyclictest/get_cyclictest_snapshot.8 src/hwlatdetect/hwlatdetect.8 "/D/leetro/I7A/rt-tests-2.8/output/usr/local/share/man/man8"
if test -n "/usr/lib/python3.12/site-packages" ; then \
        mkdir -p "/D/leetro/I7A/rt-tests-2.8/output/usr/local/bin" ; \
        install -D -m 755 src/hwlatdetect/hwlatdetect.py /D/leetro/I7A/rt-tests-2.8/output/usr/lib/python3.12/site-packages/hwlatdetect.py ; \
        rm -f "/D/leetro/I7A/rt-tests-2.8/output/usr/local/bin/hwlatdetect" ; \
        ln -s /usr/lib/python3.12/site-packages/hwlatdetect.py "/D/leetro/I7A/rt-tests-2.8/output/usr/local/bin/hwlatdetect" ; \
fi
ln: failed to create symbolic link '/D/leetro/I7A/rt-tests-2.8/output/usr/local/bin/hwlatdetect': No such file or directory
make: *** [Makefile:248: install_hwlatdetect] Error 1


```

错误，无法创建连接文件：

```
ln: failed to create symbolic link '/D/leetro/I7A/rt-tests-2.8/output/usr/local/bin/hwlatdetect': No such file or directory
```

修改Makefile，注释需要创建连接文件的代码:

```makefile
.PHONY: install_hwlatdetect
install_hwlatdetect: hwlatdetect
	if test -n "$(PYLIB)" ; then \
		mkdir -p "$(DESTDIR)$(bindir)" ; \
		install -D -m 755 src/hwlatdetect/hwlatdetect.py $(DESTDIR)$(PYLIB)/hwlatdetect.py ; \
		rm -f "$(DESTDIR)$(bindir)/hwlatdetect" ; \
		# ln -s $(PYLIB)/hwlatdetect.py "$(DESTDIR)$(bindir)/hwlatdetect" ; \
	fi

.PHONY: install_get_cyclictest_snapshot
install_get_cyclictest_snapshot: get_cyclictest_snapshot
	if test -n "${PYLIB}" ; then \
		mkdir -p "${DESTDIR}${bindir}" ; \
		install -D -m 755 src/cyclictest/get_cyclictest_snapshot.py ${DESTDIR}${PYLIB}/get_cyclictest_snapshot.py ; \
		rm -f "${DESTDIR}${bindir}/get_cyclictest_snapshot" ; \
		# ln -s ${PYLIB}/get_cyclictest_snapshot.py "${DESTDIR}${bindir}/get_cyclictest_snapshot" ; \
	fi
```

重新安装

# 使用

使用文档参考[rt-tests doc][4]

## cyclictest

LD_LIBRARY_PATH=. ./cyclictest -l 100000000 -m -Sp99 -i200 -h400 -q

- `-l`：

  > [**-l, --loops=LOOPS**](https://man.archlinux.org/man/cyclictest.8.en#l,)
  >
  > 设置循环次数。默认值为 0（无限循环）。此选项对于具有给定测试循环次数的自动测试非常有用。一旦达到计时器间隔次数，循环测试就会停止。

- `-m`:

  > [**-m, --mlockall**](https://man.archlinux.org/man/cyclictest.8.en#m,)
  >
  > 锁定当前和未来的内存分配以防止paged out

- `-S`：

  > [**-S, --smp**](https://man.archlinux.org/man/cyclictest.8.en#S,)
  >
  > 为SMP系统设置标准测试选项。其作用等同于使用选项 `"-t -a"`，同时确保所有线程的指定优先级保持一致。

- `-p`：

  > [**-p, --prio=PRIO**](https://man.archlinux.org/man/cyclictest.8.en#p,)
  >
  > 设置第一个线程的优先级。指定的优先级会应用于第一个测试线程，每个后续线程的优先级会逐渐降低：
  > 优先级（线程 N）= max（优先级（线程 N-1） - 1, 0）。

- `-i`：

  > -i, --interval=INTV
  > 以微秒为单位设置线程的基本间隔（默认值为 1000us）。这将设置第一个线程的间隔。

- `-h`：

  > [**-h, --histogram=US**](https://man.archlinux.org/man/cyclictest.8.en#h,)
  >
  > 运行后将延迟直方图转储到标准输出。US 是要跟踪的最大延迟时间（以微秒为单位）。此选项以相同优先级运行所有线程。

- `-q`：

  > [**-q, --quiet**](https://man.archlinux.org/man/cyclictest.8.en#q,)
  >
  > 仅在退出时打印摘要。对于自动化测试很有用，因为只需要捕获摘要输出。

# 引用

[1]: https://www.msys2.org/	"msys2"
[2]: https://github.com/numactl/numactl "numactl"
[3]: https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git/ "rt-tests"
[4]:https://wiki.linuxfoundation.org/realtime/documentation/howto/tools/rt-tests "rt-tests doc"
