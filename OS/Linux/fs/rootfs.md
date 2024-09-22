# Linux文件系统常用目录

## /bin

- 该目录下存放`所有用户`都可以使用的`基本命令`，这些命令在**挂接其它文件系统之前就可以使用**，所以/bin目录必须和根文件系统在同一个分区中。

- bin目录下常用的命令有：cat，chgrp，chmod，cp，ls，sh，kill，mount，umount，mkdir，mknod，test等，利用Busybox制作根文件系统时，在生成的bin目录下，可以看到一些可执行的文件，也就是可用的一些命令。

## /sbin

- 该目录下存放`系统命令`，即只有`管理员`能够使用的命令，系统命令还可以存放在/usr/sbin,/usr/local/sbin目录下，/sbin目录中存放的是基本的系统命令，它们用于启动系统，修复系统等，与/bin目录相似，在**挂接其他文件系统之前就可以使用/sbin**，所以/sbin目录必须和根文件系统在同一个分区中。
- /sbin目录下常用的命令有：shutdown，reboot，fdisk，fsck等，本地用户自己安装的系统命令放在/usr/local/sbin目录下。

## /dev

- 该目录下存放的是设备文件。

## /ect

- 该目录下存放着各种配置文件，对于PC上的Linux系统，/etc目录下的文件和目录非常多，这些目录文件是可选的，它们依赖于系统中所拥有的应用程序，依赖于这些程序是否需要配置文件。在嵌入式系统中，这些内容可以大为精减。

## /lib

- 该目录下存放共享库和可加载(驱动程序)，共享库用于启动系统。

## /home

- 用户目录，它是可选的，对于每个普通用户，在/home目录下都有一个以用户名命名的子目录，里面存放用户相关的配置文件。

## /root

- 根用户的目录

## /usr

- /usr目录的内容***可以存在另一个分区中***，在系统启动后再挂接到根文件系统中的/usr目录下。里面存放的是共享、只读的程序和数据，这表明/usr目录下的内容可以在多个主机间共享，这些主要也符合FHS标准的。/usr中的文件应该是只读的，其他主机相关的，可变的文件应该保存在其他目录下，比如/var。/usr目录在嵌入式中可以精减。

## /var

- 与/usr目录相反，/var目录中存放可变的数据，比如spool目录(mail,news)，log文件，临时文件。

## /proc

- 这是一个空目录，常作为proc文件系统的挂接点，proc文件系统是个虚拟的文件系统，它没有实际的存储设备，里面的目录，文件都是由内核临时生成的，用来表示系统的运行状态，也可以操作其中的文件控制系统。

## /mnt

- 用于临时挂载某个文件系统的挂接点，通常是空目录，也可以在里面创建一引起空的子目录，比如/mnt/cdram /mnt/hda1 。用来临时挂载光盘、硬盘。

## /tmp

- 用于存放`临时文件`，通常是空目录，一些需要生成临时文件的程序用到的/tmp目录下，所以/tmp目录必须存在并可以访问。
