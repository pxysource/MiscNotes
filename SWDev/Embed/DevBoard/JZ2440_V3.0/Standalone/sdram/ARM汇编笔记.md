# .equ

`.equ symbol, expression`：

把某一个符号(symbol)定义成某一个值(expression).该指令并不分配空间，相当于c语言中的#define。

例如：

```assembly
.equ aaa,0x20000000
```

# .align

`.align absexpr1,absexpr2`：

以某种对齐方式,在未使用的存储区域填充值. 第一个值表示对齐方式,4, 8,16或32. 第二个表达式值表示填充的值