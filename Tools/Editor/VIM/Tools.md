# 简介

配合VIM一起使用的工具

# cscope

[cscope](https://cscope.sourceforge.net/)

## 应用场景

复杂多文件的工程代码

## 配置cscope数据库文件

1. 在项目定成目录，执行`cscope -Rbq`

2. vim打开为cscope关联数据库文件`cscope add cscope.out`

## 命令

> cscope commands:
> add  : Add a new database             (Usage: add file|dir [pre-path] [flags])
> find : Query for a pattern            (Usage: find a|c|d|e|f|g|i|s|t name)
>        a: Find assignments to this symbol
>        c: Find functions calling this function
>        d: Find functions called by this function
>        e: Find this egrep pattern
>        f: Find this file
>        g: Find this definition
>        i: Find files #including this file
>        s: Find this C symbol
>        t: Find this text string
> help : Show this message              (Usage: help)
> kill : Kill a connection              (Usage: kill #)
> reset: Reinit all connections         (Usage: reset)
> show : Show connections               (Usage: show)

|查询选项|	效果|
|:---|:---|
|s|	查找C语言符号，即查找函数名、宏、枚举值等出现的地方|
|g|查找函数、宏、枚举等定义的位置，类似ctags所提供的功能|
|d|查找本函数调用的函数|
|c|查找调用本函数的函数|
|t|查找指定的字符串|
|e|查找egrep模式，相当于egrep功能，但查找速度快多了|
|f|查找并打开文件，类似vim的find功能|
|i|查找包含本文件的文件|

# ctags

[universal-ctags](https://github.com/universal-ctags)/**[ctags](https://github.com/universal-ctags/ctags)**

## 应用场景

简单的工程代码

## 配置tags

1. 建立tags：在顶层目录`ctags -R *`
2. vim打开读取tags
   - 打开vim后，手动设置，`set tags=tags文件的路径`
   - 自动查找，配置到`.vimrc`中，`set tags=./tags;,tags`

## 命令

| 命令 | 作用 |
| :--- | :--- |
| ctrl + ] | 使光标在函数或变量上，即可跳转到其定义处 |
| ctrl + t | 回到跳转之前的位置 |

