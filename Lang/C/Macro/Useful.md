# 1. 求两个数的最大值

```c
#define MAX(a, b) ({ \
                     typeof(a) _a = a; \
                     typeof(b) _b = b; \
                     (void)(&_a == &_b);\
                     _a > _b? _a : _b; \
                     })

```

- typeof，获取变量的数据类型
- (void)(&_a == &_b),，这是一条空语句，用于检查a与b的数据类型是否相同（不同类型的指针不能进行比较）

# 2 常用的标准预定义宏

\_\_LINE\_\_  当前程序行的行号，表示为十进制整型常量

\_\_FILE\_\_  当前源文件名，表示字符串型常量

\_\_DATE\_\_  转换的日历日期，表示为Mmm dd yyyy 形式的字符串常量，Mmm是由asctime产生的。

\_\_TIME\_\_  转换的时间，表示"hh:mm:ss"形式的字符串型常量，是有asctime产生的。

\_\_STDC\_\_  编辑器为ISO兼容实现时位十进制整型常量

\_\_STDC_VERSION\_\_ 如何实现复合C89整部1，则这个宏的值为19940SL；如果实现符合C99，则这个宏的值为199901L；否则数值是未定义

\_\_STDC_EOBTED\_\_ (C99)实现为宿主实现时为1,实现为独立实现为0

\_\_STDC_IEC_559\_\_ (C99)浮点数实现复合IBC 60559标准时定义为1，否者数值是未定义

\_\_STDC_IEC_559_COMPLEX\_\_ (C99)复数运算实现复合IBC 60559标准时定义为1，否者数值是未定义

\_\_STDC_ISO_10646\_\_ (C99)定义为长整型常量，yyyymmL表示wchar_t值复合ISO 10646标准及其指定年月的修订补充，否则数值未定义
