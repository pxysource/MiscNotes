# 简介

linux内核中arm对于io的处理操作，提供了一些通用函数。

头文件`include/asm-arm/io.h`

# readl

在 Linux 内核中，访问 I/O 端口需要使用一些特殊的指令和数据类型。为了方便访问 I/O 端口，内核提供了一些宏定义，其中包括 `readl`。

`readl` 宏定义的基本形式如下：

```c
#define readl(p)        ({ u32 __v = readl_relaxed(p); __iormb(); __v; })
```

其中，`readl_relaxed` 函数实现了从 I/O 端口中读取 32 位数据的操作。`__iormb()` 函数用于确保读取操作的顺序性，避免编译器对指令进行优化而导致读取顺序错误。

使用 `readl` 宏定义可以方便地从 I/O 端口中读取 32 位数据，例如：

```c
unsigned int value = readl(ioport);
```

其中，`ioport` 是一个 I/O 端口的地址。读取操作会从该地址指向的端口中读取 32 位数据，并将其存储到 `value` 变量中。

## readl优化读取效率

在 Linux 内核中，使用 `readl` 函数读取 I/O 端口的数据时，可以采用以下一些技术来优化读取效率：

1. 使用 `readl_relaxed` 函数

   `readl_relaxed` 函数是一个用于读取 I/O 端口数据的宏定义，与 `readl` 函数相比，它会忽略掉一些内存屏障（memory barrier）操作，从而提高读取效率。如果在代码中不需要使用内存屏障操作，可以考虑使用 `readl_relaxed` 函数。

2. 批量读取

   在读取连续的多个 32 位数据时，可以使用 `ioread32_rep` 函数批量读取，这样可以减少函数调用的开销，并提高读取效率。

3. 使用预读取技术

   在某些情况下，内核可以使用预读取技术来提高读取效率。预读取技术会在读取数据时，提前将下一个数据读取到缓存中，从而避免在下一次读取时需要等待数据从 I/O 端口中传输。预读取技术需要根据具体的硬件平台和应用场景来选择。

4. 使用 DMA

   如果需要读取大量的数据，可以使用 DMA（Direct Memory Access，直接内存访问）技术，将数据直接传输到内存中。这样可以减少 CPU 的负载，提高读取效率。

需要注意的是，优化读取效率需要根据具体的应用场景和硬件平台来选择适当的技术，不同的技术之间可能存在一定的兼容性和性能差异。因此，需要对具体的问题进行综合分析和测试，以确定最优的解决方案。

# ioread32_rep

在 Linux 内核中，ioread32_rep() 是一个 I/O 操作函数，用于从指定的 I/O 端口读取指定数量的 32 位数据。该函数的原型定义如下：

```c
void ioread32_rep(void *addr, void *buffer, unsigned long count);
```

其中，addr 是指定的 I/O 端口地址，buffer 是指向数据缓冲区的指针，count 是要读取的数据数量。该函数会从指定的 I/O 端口地址开始，连续读取 count 个 32 位数据，并将它们存储到指定的数据缓冲区中。

ioread32_rep() 函数是通过内联汇编语句实现的，可以保证读取操作的原子性和可靠性。例如，下面是 ioread32_rep() 函数的汇编代码实现：

```c
static __inline__ void ioread32_rep(void *addr, void *buffer, unsigned long count)
{
    __asm__ __volatile__("rep; insl"
                         : "=D" (buffer), "=c" (count)
                         : "d" (addr), "0" (buffer), "1" (count)
                         : "memory");
}
```

在上述代码中，`rep`指令是重复执行指令的汇编指令，`insl`指令是从指定的 I/O 端口读取一个 32 位数据的汇编指令。该函数使用 rep 指令将 insl 指令重复执行 count 次，从而读取指定数量的 32 位数据。

ioread32_rep() 函数通常用于驱动程序中，用于从硬件设备的寄存器中读取数据。例如，可以使用 ioread32_rep() 函数从设备的 DMA 控制器中读取 DMA 描述符，或从设备的状态寄存器中读取设备状态等。

除了 ioread32_rep() 函数外，还有一些其他的 I/O 操作函数，如 ioread8()、ioread16()、iowrite8()、iowrite16() 等。这些函数可以用于读写不同大小和类型的数据，满足不同的应用需求和场景。需要注意的是，在使用这些函数时，需要保证对 I/O 端口的访问权限和正确的地址、数据类型等。

## linux-xlnx-xilinx-v14.5(linux-3.8.0,arm)

`arch/arm/include/asm` -> `arch/arm/lib/io-readsl.S`

# iowrite32_rep

在 Linux 内核中，iowrite32_rep() 是一个 I/O 操作函数，用于向指定的 I/O 端口写入指定数量的 32 位数据。该函数的原型定义如下：

```c
void iowrite32_rep(void *addr, const void *buffer, unsigned long count);
```

其中，addr 是指定的 I/O 端口地址，buffer 是指向数据缓冲区的指针，count 是要写入的数据数量。该函数会将指定数量的 32 位数据从指定的数据缓冲区中连续写入到指定的 I/O 端口地址中。

iowrite32_rep() 函数同样是通过内联汇编语句实现的，可以保证写入操作的原子性和可靠性。例如，下面是 iowrite32_rep() 函数的汇编代码实现：

```c
static __inline__ void iowrite32_rep(void *addr, const void *buffer, unsigned long count)
{
    __asm__ __volatile__("rep; outsl"
                         : "=S" (buffer), "=c" (count)
                         : "d" (addr), "0" (buffer), "1" (count)
                         : "memory");
}
```

在上述代码中，rep 指令是重复执行指令的汇编指令，outsl 指令是向指定的 I/O 端口写入一个 32 位数据的汇编指令。该函数使用 rep 指令将 outsl 指令重复执行 count 次，从而将指定数量的 32 位数据写入到指定的 I/O 端口地址中。

iowrite32_rep() 函数通常用于驱动程序中，用于向硬件设备的寄存器中写入数据。例如，可以使用 iowrite32_rep() 函数向设备的 DMA 控制器中写入 DMA 描述符，或向设备的控制寄存器中写入控制命令等。

除了 iowrite32_rep() 函数外，还有一些其他的 I/O 操作函数，如 iowrite8()、iowrite16()、ioread8()、ioread16() 等。这些函数可以用于读写不同大小和类型的数据，满足不同的应用需求和场景。需要注意的是，在使用这些函数时，需要保证对 I/O 端口的访问权限和正确的地址、数据类型等。