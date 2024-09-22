# IDE

## Visual Studio（Windows）

## CLion

## Eclipse

## Qt Creator

# 编译器

## MSVC（windows）

- Windows。

## GCC（linux）

- Linux。

## Cygwin

- 交叉编译器，编译生成的文件适用于windows。
- 是一种编译环境，核心是gcc。

## MingW（交叉编译）

- 交叉编译器，编译生成的文件适用于windows。
- 是一种编译环境，核心是gcc。

## Clang（新特性）

- LLVM架构，需要配合LLVM一起使用。

# 代码调试工具

## gdb（Linux）

GDB, the GNU Project debugger, allows you to see what is going on `inside' another program while it executes -- or what another program was doing at the moment it crashed.

GDB can do four main kinds of things (plus other things in support of these) to help you catch bugs in the act:

- Start your program, specifying anything that might affect its behavior.
- Make your program stop on specified conditions.
- Examine what has happened, when your program has stopped.
- Change things in your program, so you can experiment with correcting the effects of one bug and go on to learn about another.

Those programs might be executing on the same machine as GDB (native), on another machine (remote), or on a simulator. GDB can run on most popular UNIX and Microsoft Windows variants, as well as on Mac OS X.

## lldb（LLVM）

## Valgrind

Valgrind is an instrumentation framework for building dynamic analysis tools. 

# 构建系统

## make（Linux）

## CMake（推荐）

## Bazel

## Ninja

# 静态分析工具

## cppcheck

## Clang-Tidy（推荐）

- **clang-tidy** is a clang-based C++ “linter” tool. Its purpose is to provide an extensible framework for diagnosing and fixing typical programming errors, like style violations, interface misuse, or bugs that can be deduced via static analysis. **clang-tidy** is modular and provides a convenient interface for writing new checks.

## PC-lint

## Clang Static Analyzer

# 内存泄漏检查工具

- valgrind
- ASan
- mtrace
- ccmalloc
- debug_new

# profiling工具

- gperftools
- perf
- intelVTune
- AMD CodeAnalyst
- gnu prof
- Quanlify

# 网络I/O

- dstat
- tcpdump（推荐）
- sar

# 磁盘I/O

- iostat（推荐）
- dstat
- sar

# 文件系统空间

- df

# 内存容量

- free
- vmstat（推荐）
- sar

# 进程内存分布

- pmap

# 系统调用追踪

- strace

# 网络吞吐量

- iftop
- nethogs
- sar

# 网络延迟

- ping

# CPU使用率

- pidstat（推荐）
- vmstat
- mpstat
- top
- sar
- time

# 上下文切换

- pidstat（推荐）
- vmstat
- perf

