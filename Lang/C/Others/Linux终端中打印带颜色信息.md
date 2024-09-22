#  1 Linux终端中打印带颜色信息

- 打印不同颜色的核心格式为：<ESC>[{attr};{fg};{bg}m。其中<ESC>，在ascii中也用“^[”表示，在代码中，八进制写作\033。

- attr表示显示字体的属性，如加粗、下划线、闪烁等。值如下：

  | attr值 | 描述                                                         |
  | ------ | ------------------------------------------------------------ |
  | 0      | Reset All Attributes (return to normal mode)（关闭所有属性） |
  | 1      | Bright (Usually turns on BOLD)（高亮）                       |
  | 2      | Dim                                                          |
  | 4      | Underline                                                    |
  | 5      | Blink（闪烁）                                                |
  | 7      | Reverse（反显）                                              |
  | 8      | Hidden（消隐）                                               |

- fg是前景颜色，即字体颜色，如红色、黄色等，值如下：\

  | fg值 | 描述    |
  | ---- | ------- |
  | 30   | Black   |
  | 31   | Red     |
  | 32   | Green   |
  | 33   | Yellow  |
  | 34   | Blue    |
  | 35   | Magenta |
  | 36   | Cyan    |
  | 37   | White   |

- bg是背景颜色，值如下：

  | bg值 | 描述    |
  | ---- | ------- |
  | 40   | Black   |
  | 41   | Red     |
  | 42   | Green   |
  | 43   | Yellow  |
  | 44   | Blue    |
  | 45   | Magenta |
  | 46   | Cyan    |
  | 47   | White   |

## 1.2 光标控制

| 控制命令    | 描述        |
| ----------- | ----------- |
| **\033[nA** | 光标上移n行 |
| **\033[nB** | 光标下移n行 |
| **\033[nC** | 光标右移n行 |
|             |             |
|             |             |
|             |             |
|             |             |

  

​        光标左移n行 **\033[y;xH**       设置光标位置 **\033[2J**         清屏 **\033[K**          清除从光标到行尾的内容 **\033[s**          保存光标位置 **\033[u**          恢复光标位置 **\033[?25l**       隐藏光标 **\033[?25h**       显示光标

控制字符是打开某种样式，输出完成时需要再关闭样式才能使terminal恢复到原来状态，简单例子：

printf("\e[32m%s\e[0m\n", "hello world");

在shell中也可以直接用echo输出，需要加-e选项打开转义字符解释，如输出高亮的绿色字体为：

echo -e "\e[32m\e[1mhello world\e[0m"

用于调试输出打印带颜色的信息：

/************************************************************************* * 设置打印信息的字体颜色，适用于linux终端 * format1: <ESC>[{attr};{fg}此处为打印信息<ESC>[{gb}m * format2: <ESC>[{attr};{fg};{bg}m此处为打印信息<ESC>[RESET;{fg};{bg}m  *  注意: <ESC>[RESET;{fg};{bg}m,此处是复位属性，否则会影响后面的输出信息 * ESC:\033, attr: 字体属性, fg: 前景色, bg: 背景色 *************************************************************************/ #include <stdio.h> #include <stdarg.h> /* attr */ #define RESET           ((unsigned char)0) #define BRIGHT          ((unsigned char)1) #define DIM             ((unsigned char)2) #define UNDERLINE       ((unsigned char)4) #define BLINK           ((unsigned char)5) #define REVERSE         ((unsigned char)7) #define HIDDEN          ((unsigned char)8) /* color index */ #define BLACK           ((unsigned char)0) #define RED             ((unsigned char)1) #define GREEN           ((unsigned char)2) #define YELLOW          ((unsigned char)3) #define BLUE            ((unsigned char)4) #define MAGENTA         ((unsigned char)5) #define CYAN            ((unsigned char)6) #define WHITE           ((unsigned char)7) /* foreground color */ #define FG_BASE         ((unsigned char)30) /* background color */ #define BG_BASE         ((unsigned char)40) void text_show (void) {    printf ("\e[%d;%d;%dm",             BRIGHT, FG_BASE + RED, BG_BASE + GREEN);    printf ("Hello world.");    printf ("\e[%dm\n", RESET); } /* 不使用背景色，使用背景色会影响后续打印信息 */ #define DEBUG_LEN   1024 void print_color (const unsigned char attr, const unsigned char fg_color,        const char *fmt, ...) {    char buf[DEBUG_LEN] = {0};    va_list ap;     va_start (ap, fmt);    snprintf (buf, DEBUG_LEN, "\e[%d;%dm%s\e[0m",             attr, FG_BASE + fg_color, fmt);    vprintf (buf, ap);    va_end (ap); } #define Print_Color(attr, fg_color, fmt, arg...) \    print_color (attr, fg_color, fmt, ##arg) #define Warn_Print(fmt, arg...) \    print_color (BRIGHT, YELLOW, fmt, ##arg) #define Error_Print(fmt, arg...) \    print_color (BRIGHT, RED, fmt, ##arg) int main (void) {    text_show ();     Print_Color(BRIGHT, GREEN, "%s %s.\n", "hello", "world");    Warn_Print("%s %s.\n", "hello", "world");    Error_Print("%s %s.\n", "hello", "world");     return 0; }