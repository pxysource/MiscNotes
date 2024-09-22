# 1 查看磁盘挂载点

```shell
linux@ubuntu:~$ sudo /usr/bin/vmware-toolbox-cmd disk list
[sudo] password for linux: 
/
```

# 2 根据磁盘挂载点，进行压缩

```shell
linux@ubuntu:~$ sudo /usr/bin/vmware-toolbox-cmd disk shrink / 
Please disregard any warnings about disk space for the duration of shrink process.
Progress: 100 [===========>]

Disk shrinking complete.
```

