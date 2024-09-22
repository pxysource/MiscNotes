# C++形式导出

默认为这种形式

```cpp
int func1()            
{
    return 0;
}
```

```shell
linux@linux-virtual-machine:~/c/lib/so/func_export$ g++ test.cpp -shared -fPIC -o libtest.so
linux@linux-virtual-machine:~/c/lib/so/func_export$ nm libtest.so 
0000000000201020 B __bss_start
0000000000201020 b completed.7594
                 w __cxa_finalize
0000000000000500 t deregister_tm_clones
0000000000000590 t __do_global_dtors_aux
0000000000200e78 t __do_global_dtors_aux_fini_array_entry
0000000000201018 d __dso_handle
0000000000200e88 d _DYNAMIC
0000000000201020 D _edata
0000000000201028 B _end
000000000000060c T _fini
00000000000005d0 t frame_dummy
0000000000200e70 t __frame_dummy_init_array_entry
0000000000000698 r __FRAME_END__
0000000000201000 d _GLOBAL_OFFSET_TABLE_
                 w __gmon_start__
0000000000000618 r __GNU_EH_FRAME_HDR
00000000000004c0 T _init
                 w _ITM_deregisterTMCloneTable
                 w _ITM_registerTMCloneTable
0000000000200e80 d __JCR_END__
0000000000200e80 d __JCR_LIST__
                 w _Jv_RegisterClasses
0000000000000540 t register_tm_clones
0000000000201020 d __TMC_END__
0000000000000600 T _Z5func1v
```

`func1` => `_Z5func1v`

# C形式导出

需要为函数加上`extern "C"`

- 可以直接在函数定义处加
- 函数声明和函数定义在一个文件，可以在函数声明处加
- 函数声明和函数定义不在同一个文件，在`.cpp`文件`.h`文件，则需要`.cpp`文件包含`.h`

```cpp
#ifdef __cplusplus
extern "C" {
#endif

int func1();

#ifdef __cplusplus
}                                                                                          
#endif

int func1()
{
    return 0;
}

```

```shell
linux@linux-virtual-machine:~/c/lib/so/func_export$ g++ test.cpp -shared -fPIC -o libtest.so
linux@linux-virtual-machine:~/c/lib/so/func_export$ nm libtest.so 
0000000000201020 B __bss_start
0000000000201020 b completed.7594
                 w __cxa_finalize
0000000000000500 t deregister_tm_clones
0000000000000590 t __do_global_dtors_aux
0000000000200e78 t __do_global_dtors_aux_fini_array_entry
0000000000201018 d __dso_handle
0000000000200e88 d _DYNAMIC
0000000000201020 D _edata
0000000000201028 B _end
000000000000060c T _fini
00000000000005d0 t frame_dummy
0000000000200e70 t __frame_dummy_init_array_entry
0000000000000698 r __FRAME_END__
0000000000000600 T func1
0000000000201000 d _GLOBAL_OFFSET_TABLE_
                 w __gmon_start__
0000000000000618 r __GNU_EH_FRAME_HDR
00000000000004c0 T _init
                 w _ITM_deregisterTMCloneTable
                 w _ITM_registerTMCloneTable
0000000000200e80 d __JCR_END__
0000000000200e80 d __JCR_LIST__
                 w _Jv_RegisterClasses
0000000000000540 t register_tm_clones
0000000000201020 d __TMC_END__

```

`func1` => `func1`

