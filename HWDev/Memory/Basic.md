# 1 Flash

## 1.1 NorFlash

当选择存储器解决方案时，设计师必须权衡以下的各项因素：

- NOR读速度比NAND稍快一些。
- NAND的写入速度比NOR快很多。
- NAND的擦除速度远比NOR的5s快。
- 大多数写入操作需要先进行擦除操作。
- NAND的擦除单元更小，NOR的擦除电路更少。
- 此外，NAND的实际应用方式要比NOR复杂的多。

## 1.2 NandFlash

- NAND Flash 在嵌入式系统中的地位与PC机上的硬盘是类似的。用于保存系统运行所必需的操作系统，应用程序，用户数据，运行过程中产生的各类数据，系统掉电后数据不会丢失。

- Nand Flash的几个重要的基本特性:
  - NandFlash的IO接口。对于Norflash、dram 之类的存储设备，CPU 可以直接通过地址总线对其进行访问,而 Nand Flash 没有这类的总线,只有 IO 接口,只能通过复用的 IO接口发送命令和地址,从而实现对 Nand Flash 内部数据进行访问。（端口的复用）
  - NandFlash的读、写、擦除操作。读写是以页为单位的，擦除是以块为单位的。对于Nand的写操作，只能由1变成0，而不能由0变成1。所以必须先对nand执行erase操作，即将0变成1，然后再写（使对应的1变成0）
  - 存储在Nand中的数据容易发生错误，所以采取一定的算法对数据进行编码和解码很有必要。在数据存储到nand flash之前进行编码，连同校验数据一同存储到nand之中；在数据从nand读出之后进行解码，以验证数据是否出错。（BCH）

# 2 SDRAM

同步动态随机存取内存（synchronous dynamic random-access memory，简称SDRAM）是有一个[同步接口](https://baike.baidu.com/item/同步接口)的动态随机存取内存（[DRAM](https://baike.baidu.com/item/DRAM)）。通常DRAM是有一个异步接口的，这样它可以随时响应控制输入的变化。而SDRAM有一个同步接口，在响应控制[输入](https://baike.baidu.com/item/输入)前会等待一个[时钟信号](https://baike.baidu.com/item/时钟信号)，这样就能和计算机的[系统总线](https://baike.baidu.com/item/系统总线)同步。时钟被用来驱动一个有限状态机，对进入的指令进行[管线](https://baike.baidu.com/item/管线)(Pipeline)操作。这使得SDRAM与没有同步接口的异步DRAM(asynchronous DRAM)相比，可以有一个更复杂的操作模式。

SDRAM在计算机中被广泛使用，从起初的SDRAM到之后一代的DDR（或称DDR1），然后是[DDR2](https://baike.baidu.com/item/DDR2)和[DDR3](https://baike.baidu.com/item/DDR3)进入大众市场，2015年开始[DDR4](https://baike.baidu.com/item/DDR4)进入消费市场。

# 3 SRAM

静态随机存取存储器（**S**tatic **R**andom-**A**ccess **M**emory，**SRAM**）是[随机存取存储器](https://baike.baidu.com/item/随机存取存储器/4099402)的一种。所谓的“静态”，是指这种存储器只要保持[通电](https://baike.baidu.com/item/通电/6798720)，里面储存的数据就可以恒常保持。当电力供应停止时，SRAM储存的数据会消失（被称为volatile memory）。