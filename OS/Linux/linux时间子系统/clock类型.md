# clock id

`CLOCK_REALTIME`：系统实时时间，从Epoch计时，可被设置更改。

----------------------------------------------

后面所有的时间体系都是不可设置的。

`CLOCK_REALTIME_ALARM`：和`CLOCK_REALTIME`相同，在定时器设置时才有用，ALARM代表的是定时设置，如果目标定时时间到了的时候系统在休眠，会唤醒系统。

`CLOCK_REALTIME_COARSE `：和`CLOCK_REALTIME`相同，精度不高但是获取比较快。

`CLOCK_TAI`：和`CLOCK_REALTIME`相同，但是不考虑闰秒问题。

`CLOCK_MONOTONIC`：由于前面几个时间体系都有可能会产生回跳，计算机中需要有一个单调递增的时间体系。此时间体系的时间原点并不重要，在Linux中是以系统启动的时间点作为时间原点，在计算机休眠时会暂停走时，受adjtime和NTP的影响可能会向前跳跃。

`CLOCK_MONOTONIC_COARSE `：同`CLOCK_MONOTONIC`，但是精度降低，访问更快。

`CLOCK_MONOTONIC_RAW `：同`CLOCK_MONOTONIC`，但是不受adjtime和NTP的影响。

`CLOCK_BOOTTIME `：以系统启动时间为时间原点的时间体系，不受其它因素的影响，计算机休眠时依然走时。

`CLOCK_BOOTTIME_ALARM`：同`CLOCK_BOOTTIME `，在定时器设置时才有用，ALARM代表的是定时设置，如果目标定时时间到了的时候系统在休眠，会唤醒系统。

`CLOCK_PROCESS_CPUTIME_ID`：以进程创建时间为时间原点，进程运行时走时，进程休眠时暂停走时。

`CLOCK_THREAD_CPUTIME_ID`：以线程创建时间为时间原点，线程运行时走时，线程休眠时暂停走时。

# 附录

## 名词释义

### NTP

**N**etwork **T**ime **P**rotocol [^1]是一种网络协议，用于通过数据包交换、可变延迟数据网络在计算机系统之间进行时钟同步。

### TAI

**International Atomic Time** (缩写为TAI，来自其法语名称temps atomique international) 是一种高精度原子坐标时间标准，基于地球大地水准面上概念上的本征时间经过。TAI 是全球 80 多个国家实验室的 450 多个原子钟所记录时间的加权平均值。它是一个连续的时间尺度，没有闰秒，是地球时间（具有固定纪元偏移量）的主要实现。 它是协调世界时 (UTC) 的基础，UTC 用于整个地球表面的民用计时，并且具有闰秒。

## 参考

1. [^1]: https://en.wikipedia.org/wiki/Network_Time_Protocol "Network Time Protocol - Wikipedia"

2. 