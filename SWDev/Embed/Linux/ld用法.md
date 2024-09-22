# 1 ld用法

**-rpath=dir**

> Add a directory to the runtime library search path.  This is used when linking an ELF executable with shared objects.  All -rpath arguments are concatenated and passed to the runtime linker, which uses them to locate shared objects at runtime.  The -rpath option is also used when locating shared objects which are needed by shared objects explicitly included in the link; see the description of the -rpath-link option.  If -rpath is not used when linking an ELF executable, the contents of the environment variable "LD_RUN_PATH" will be used if it is defined.
>
> The -rpath option may also be used on SunOS.  By default, on SunOS, the linker will form a runtime search path out of all the -L options it is given.  If a -rpath option is used, the runtime search path will be formed exclusively using the -rpath options, ignoring the -L options.  This can be useful when using gcc, which adds many -L options which may be on NFS mounted file systems.
>
> For compatibility with other ELF linkers, if the -R option is
>
> followed by a directory name, rather than a file name, it is
>
> treated as the -rpath option.

rpath链接选项主要有两个功能：

1). 程序运行时，优先到rpath指定的目录去寻找依赖库

2). 程序链接时，在指定的目录中，隐式的链接那些动态库所需要的链接库。