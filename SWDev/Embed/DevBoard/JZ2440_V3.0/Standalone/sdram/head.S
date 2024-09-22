@****************************************************************
@FILE:  head.S
@功能：设置SDRAM，将程序复制到SDRAM，然后跳到SDRAM继续执行
@注意：此文件为启动文件，链接的时候要最先链接
@*****************************************************************

#define WTCON 0x53000000
.equ    MEM_CTL_BASE, 0x48000000    @ s3c2440 memory controller base address.
.equ    SDRAM_BASE, 0x30000000      @ SDRAM base address.

.text
.global _start
_start:
    bl disable_watch_dog            @ 关闭看门狗
    bl memsetup                     @ 设置存储控制器
    bl copy_steppingston_to_sdram   @ 复制代码到SDRAM中
    ldr pc, =on_sdram               @ 跳到SDRAM中继续执行
on_sdram:
    ldr sp, =0x34000000             @ 设置堆栈
    bl main
halt_loop:
    b halt_loop

disable_watch_dog:
    ldr r0, =WTCON
    mov r1, #0x0
    str r1, [r0]
    mov pc, lr          @ 返回

memsetup:
    ldr r0, =MEM_CTL_BASE           @ 存储控制器的13个寄存器的起始地址
    adrl r1, mem_cfg_val            @ 这13个值的起始存储地址
    add r2, r0, #52                 @ 13*4=52

1:
    ldr r3, [r1], #4                @ 读取设置值，并将r1+4
    str r3, [r0], #4                @ 将此值写入寄存器，并将r0+4
    cmp r0, r2                      @ 判断是否完成设置13个寄存器
    bne 1b                          @ 没完成，继续
    mov pc, lr                      @ 返回
    

copy_steppingston_to_sdram:
    @ 将Steppingstone的4K数据全部复制到SDRAM中去
    @ Steppingstone起始地址为0x00000000，SDRAM中起始地址为0x30000000

    mov r1, #0x0
    ldr r2, =SDRAM_BASE
    mov r3, #4*1024         @ 该常数必须对应8位位图，即常数是由一个8位的
                            @ 常数循环移位偶数
1:
    ldr r4, [r1], #4          @ 从Steppingstone中读取4个字节数据，将源地址+4
    str r4, [r2], #4          @ 将此4字节的数据复制到SDRAM中，并让目地地址+4
    cmp r1, r3              
    bne 1b
    mov pc, lr

.align 4
mem_cfg_val:
    .long   0x22011110      @ BWSCON          0010(32bit) 0010(SDRAM 32bit) 0000(Serial 8bit) 0001(DM9000 16) 0001(CS8900A 16) 0001(IDE 16) 0001(IDE 16) 0000(Cannot set, NOR-Flash 16).
    .long   0x00000700      @ BANKCON0        Reset value.
    .long   0x00000700      @ BANKCON1        Reset value.
    .long   0x00000700      @ BANKCON2        Reset value.
    .long   0x00000700      @ BANKCON3        Reset value.
    .long   0x00000700      @ BANKCON4        Reset value.
    .long   0x00000700      @ BANKCON5        Reset value.
    .long   0x00018005      @ BANKCON6        0000 000 11(Sync. DRAM) 00000000000(SDRAM, cannot set) 01(RAS to CAS delay, Recommended value=3 clocks) 01(SDRAM K4S561632, column address number:9)
    .long   0x00018005      @ BANKCON7        Not used. Same as BANKCON6.
    .long   0x008C07A3      @ REFRESH         Bank6/Bank7 connected SDRAM, need to be set. 00000000(Cannot set) 1(SDRAM Refresh Enable) 0(SDRAM Refresh Mode=CBR/Auto Refresh) 00(SDRAM RAS pre-charge Time=2 clocks) 11(Initial state) 
                            @                 0000000(Not used) 11110100011(SDRAM refresh count value = (2^11 + 1 - SDRAM_Clock_frequency * refresh_period, refresh_period = 64ms / 8192 = 7.8125us, => 2^11 + 1 - 12 * 7.8125=1955)
    .long   0x000000B1      @ BANKSIZE        Bank6/Bank7 connected SDRAM, need to be set. 1(ARM core burst operation enable) 0(Not used) 1(SDRAM power down mode enable control by SCKE) 1(Recommanded value) 0(Not used) 001(BANK6/BANK7 64MB)
    .long   0x00000030      @ MRSRB6          Bank6/Bank7 connected SDRAM, need to be set. Only can set bit[6:4], 011(CAS latency=2 or 3 clocks, select 3 clocks)
    .long   0x00000030      @ MRSRB7          Bank6/Bank7 connected SDRAM, need to be set. Not used. Same as MRSRB6.
