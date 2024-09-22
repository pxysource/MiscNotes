# cut

- **remove sections from each line of files**.

> SYNOPSIS
>
> ​       cut OPTION... [FILE]...
>
> DESCRIPTION
>
> ​       Print selected parts of lines from each FILE to standard output.
>
> ​       With no FILE, or when FILE is -, read standard input.
>
> ​       Mandatory  arguments  to  long  options are mandatory for short options too.

## -b

>  -b, --bytes=LIST
>
> ​              select only these bytes

```shell
linux@ubuntu:~$ cat test.txt 
hello
how
are
you
linux@ubuntu:~$ cut -b 1-3,5 test.txt 
helo
how
are
you

linux@ubuntu:~$ cut -b 3 test.txt 
l
w
e
u

linux@ubuntu:~$ cut -b 3- test.txt 
llo
w
e
u

```

## -c

> ​       -c, --characters=LIST
>
> ​              select only these characters

```shell
linux@ubuntu:~$ cat test.txt
hello
how
are
you
linux@ubuntu:~$ cut -c 3 test.txt 
l
w
e
u

```

## -d & -f

> -d, --delimiter=DELIM
>
> - use DELIM instead of TAB for field delimiter
>
> -f, --fields=LIST
>
> - select only these fields;  also print any line that contains  no delimiter character, unless the -s  option is specified

```shell
linux@ubuntu:~$ cat passwd 
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin

linux@ubuntu:~$ cut -d : -f 1,2,5 passwd 
root:x:root
daemon:x:daemon
bin:x:bin
sys:x:sys
sync:x:sync
games:x:games
man:x:man
```



## Bugs

### -b和-c对中文字符等多字符可能会乱码

```shell
linux@ubuntu:~$ cat test_differ.c 
星期一
星期二
星期三
星期四
星期五

linux@ubuntu:~$ cut -b 3 test_differ.c 
�
�
�
�
�

linux@ubuntu:~$ cut -b 3 test_differ.c
�
�
�
�
�

linux@ubuntu:~$ cut -n -b 1,2,3 test_differ.c
星
星
星
星
星
```

# wc

- print newline, word, and byte counts for each file.

> SYNOPSIS
>
> ​       wc [OPTION]... [FILE]...
>
> ​       wc [OPTION]... --files0-from=F
>
> DESCRIPTION
>
> Print newline, word, and byte counts for each FILE, and a total line if more than one FILE is specified.  A word is a non-zero-length  sequence
>
> of characters delimited by white space.
>
> ​       With no FILE, or when FILE is -, read standard input.

## Read Standard Input

```shell
linux@ubuntu:~$ echo "hello" | wc
      1       1       6
      lines   words   bytes
linux@ubuntu:~$ echo "hello" | wc -
      1       1       6 -
```

# diff

- 直接输出文件的不同

```bash
linux@ubuntu:~$ cat 1.txt 
1
2
3
4
5
linux@ubuntu:~$ cat 2.txt 
1
2
3
4
5
6
7
8
9
linux@ubuntu:~$ diff 1.txt 2.txt 
5a6,9
> 6
> 7
> 8
> 9
linux@ubuntu:~$ 

```

- 将问价的不同输出到问价中

```bash
linux@ubuntu:~$ diff 1.txt 2.txt >test.patch
linux@ubuntu:~$ cat test.patch 
5a6,9
> 6
> 7
> 8
> 9
linux@ubuntu:~$ 
```

# patch

- 升级文件

```bash
linux@ubuntu:~$ cat 1.txt 
1
2
3
4
5
linux@ubuntu:~$ cat 2.txt 
1
2
3
4
5
6
7
8
9
linux@ubuntu:~$ cat test.patch 
5a6,9
> 6
> 7
> 8
> 9
linux@ubuntu:~$ patch -p0 1.txt test.patch 
patching file 1.txt
linux@ubuntu:~$ cat 1.txt 
1
2
3
4
5
6
7
8
9
linux@ubuntu:~$ 

```

- 回退文件

```bash
linux@ubuntu:~$ cat 2.txt 
1
2
3
4
5
6
7
8
9
linux@ubuntu:~$ cat test.patch 
5a6,9
> 6
> 7
> 8
> 9
linux@ubuntu:~$ patch -R 2.txt test.patch 
patching file 2.txt
linux@ubuntu:~$ cat 2.txt 
1
2
3
4
5
linux@ubuntu:~$ ls

```

# curl

# wget

- 下载网址链接的资源。

# mount

mount a filesystem



