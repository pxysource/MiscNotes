# 简介

在嵌入式开发中，进行c++开发，需要进行交叉编译。如果运行环境的c++库与编译环境的c++库不同，可能会存在问题。但是一般来说，如果编译环境的c++库版本低于运行环境的c++库，可以运行；但是如果编译环境的c++库版本高于运行环境的c++库，则有可能可以运行，也可能无法运行。

我的问题为编译环境的c++库版本高于运行环境的c++库，但是不希望升级运行环境的c++库，并且希望程序能正常运行。

## 工具链

gnu交叉编译工具链

## 环境

arm linux

# 现象描述

## c++库版本对比

编译环境的c++库版本：

```shell
strings libstdc++.so.6.0.20 | grep "GLIBCXX"
GLIBCXX_3.4
GLIBCXX_3.4.1
GLIBCXX_3.4.2
GLIBCXX_3.4.3
GLIBCXX_3.4.4
GLIBCXX_3.4.5
GLIBCXX_3.4.6
GLIBCXX_3.4.7
GLIBCXX_3.4.8
GLIBCXX_3.4.9
GLIBCXX_3.4.10
GLIBCXX_3.4.11
GLIBCXX_3.4.12
GLIBCXX_3.4.13
GLIBCXX_3.4.14
GLIBCXX_3.4.15
GLIBCXX_3.4.16
GLIBCXX_3.4.17
GLIBCXX_3.4.18
GLIBCXX_3.4.19
GLIBCXX_3.4.20
GLIBCXX_DEBUG_MESSAGE_LENGTH
```

运行环境的c++版本：

```shell
strings libstdc\+\+.so.6.0.16 | grep "GLIBCXX"
GLIBCXX_3.4
GLIBCXX_3.4.1
GLIBCXX_3.4.2
GLIBCXX_3.4.3
GLIBCXX_3.4.4
GLIBCXX_3.4.5
GLIBCXX_3.4.6
GLIBCXX_3.4.7
GLIBCXX_3.4.8
GLIBCXX_3.4.9
GLIBCXX_3.4.10
GLIBCXX_3.4.11
GLIBCXX_3.4.12
GLIBCXX_3.4.13
GLIBCXX_3.4.14
GLIBCXX_3.4.15
GLIBCXX_3.4.16
GLIBCXX_FORCE_NEW
GLIBCXX_DEBUG_MESSAGE_LENGTH
```

对比发现编译环境的c++库版本更高。

## 现象描述

运行信息：

```shell
Failed to load module(Lti6LiEventLog.so)! /usr/lib/libstdc++.so.6: version `GLIBCXX_3.4.20' not found (required by ./Lti6LiEventLog.so)
```

如果程序编译使用了较高版本的c++库中的特性，运行环境中的c++库没有这些特性，会导致编译可以通过，无法运行的问题。

# 解决办法

1. 查找使用`GLIBCXX_3.4.20`版本的哪些特性

   ```shell
   arm-xilinx-linux-gnueabi-nm E:/SVN/ZhaoYang/branches/FmwUserLib/EventLog/Prj/Release/Lti6LiEventLog.so | grep "GLIBCXX"
            U _ZdlPv@@GLIBCXX_3.4
            U _Znaj@@GLIBCXX_3.4
            U _ZNKSs4findEPKcjj@@GLIBCXX_3.4
            U _ZNKSs7compareEPKc@@GLIBCXX_3.4
            U _ZNKSt5ctypeIcE13_M_widen_initEv@@GLIBCXX_3.4.11
            U _ZNSo3putEc@@GLIBCXX_3.4
            U _ZNSo5flushEv@@GLIBCXX_3.4
            U _ZNSo9_M_insertImEERSoT_@@GLIBCXX_3.4.9
            U _ZNSs4_Rep10_M_destroyERKSaIcE@@GLIBCXX_3.4
            U _ZNSs4_Rep20_S_empty_rep_storageE@@GLIBCXX_3.4
            U _ZNSs4swapERSs@@GLIBCXX_3.4
            U _ZNSs6appendEPKcj@@GLIBCXX_3.4
            U _ZNSs6assignERKSs@@GLIBCXX_3.4
            U _ZNSsC1EPKcRKSaIcE@@GLIBCXX_3.4
            U _ZNSsC1ERKSs@@GLIBCXX_3.4
            U _ZNSsC1ERKSsjj@@GLIBCXX_3.4
            U _ZNSt8__detail15_List_node_base7_M_hookEPS0_@@GLIBCXX_3.4.15
            U _ZNSt8ios_base4InitC1Ev@@GLIBCXX_3.4
            U _ZNSt8ios_base4InitD1Ev@@GLIBCXX_3.4
            U _Znwj@@GLIBCXX_3.4
            U _ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_i@@GLIBCXX_3.4.9
            U _ZSt16__throw_bad_castv@@GLIBCXX_3.4
            U _ZSt24__throw_out_of_range_fmtPKcz@@GLIBCXX_3.4.20
            U _ZSt4cout@@GLIBCXX_3.4
   ```

   发现`_ZSt24__throw_out_of_range_fmtPKcz`这个符号为`GLIBCXX_3.4.20`中的特性。
   
2. 定位`_ZSt24__throw_out_of_range_fmtPKcz`在哪些.o文件中被使用

   在编译器（链接程序）中指定选项`-Wl,-y,_ZSt24__throw_out_of_range_fmtPKcz`

   进行编译：

   ```
   arm-xilinx-linux-gnueabi-g++ -L"E:\XilinxWorkspace\I6/FmwApp" -shared -Wl,-y,_ZSt24__throw_out_of_range_fmtPKcz -o "Lti6LiEventLog.so"  ./Src/src/DBG_ShowInfo.o ./Src/src/ERR_Interface.o ./Src/src/ERR_Main.o ./Src/src/LOG_Interface.o ./Src/src/LOG_ModuleInfo.o  ./Src/LtSysVar/Test/SVAR_TestMain.o ./Src/LtSysVar/Test/TestCaseBase.o  ./Src/LtSysVar/SVAR_Interface.o ./Src/LtSysVar/SVAR_SystemVariables.o ./Src/LtSysVar/SVAR_VarsDataBuffer.o ./Src/LtSysVar/SVAR_VarsGroupBuffer.o   -ldl -lexpat
   ./Src/LtSysVar/SVAR_SystemVariables.o: reference to _ZSt24__throw_out_of_range_fmtPKcz
   c:/xilinx/sdk/2018.2/gnu/arm/nt/bin/../arm-xilinx-linux-gnueabi/libc/usr/lib/libstdc++.so: definition of _ZSt24__throw_out_of_range_fmtPKcz
   ```
   
   发现在`SVAR_SystemVariables.o`文件中使用了符号`_ZSt24__throw_out_of_range_fmtPKcz`
   
3. 定位源代码
   
   利用`objdump`反编译文件`SVAR_SystemVariables.o`：
   
   ```shell
   arm-xilinx-linux-gnueabi-objdump -dr E:/SVN/ZhaoYang/branches/FmwUserLib/EventLog/Prj/Release/Src/LtSysVar/SVAR_SystemVariables.o > E:/SVN/ZhaoYang/branches/FmwUserLib/EventLog/Prj/Release/Src/LtSysVar/SVAR_SystemVariables.disa
   ```
   
   在反汇编`SVAR_SystemVariables.disa`文件中定位符号`_ZSt24__throw_out_of_range_fmtPKcz`，可以找到源代码中可能使用这个符号的地方。
   
   ```assembly
   00001338 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs>:
       1338:	e92d41f0 	push	{r4, r5, r6, r7, r8, lr}
       133c:	e3a05000 	mov	r5, #0
       1340:	e5c05012 	strb	r5, [r0, #18]
       1344:	e24dd010 	sub	sp, sp, #16
       1348:	e5913000 	ldr	r3, [r1]
       134c:	e59f73e0 	ldr	r7, [pc, #992]	; 1734 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x3fc>
       1350:	e1c051b0 	strh	r5, [r0, #16]
       1354:	e513300c 	ldr	r3, [r3, #-12]
       1358:	e08f7007 	add	r7, pc, r7
       135c:	e1530005 	cmp	r3, r5
       1360:	1a000001 	bne	136c <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x34>
       1364:	e28dd010 	add	sp, sp, #16
       1368:	e8bd81f0 	pop	{r4, r5, r6, r7, r8, pc}
       136c:	e1a06001 	mov	r6, r1
       1370:	e1a04000 	mov	r4, r0
       1374:	e1a00001 	mov	r0, r1
       1378:	e59f13b8 	ldr	r1, [pc, #952]	; 1738 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x400>
       137c:	e1a02005 	mov	r2, r5
       1380:	e3a03002 	mov	r3, #2
       1384:	e08f1001 	add	r1, pc, r1
       1388:	ebfffffe 	bl	0 <_ZNKSs4findEPKcjj>
   			1388: R_ARM_CALL	_ZNKSs4findEPKcjj
       138c:	e2502000 	subs	r2, r0, #0
       1390:	bafffff3 	blt	1364 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x2c>
       1394:	e5963000 	ldr	r3, [r6]
       1398:	e513300c 	ldr	r3, [r3, #-12]
       139c:	e1520003 	cmp	r2, r3
       13a0:	8a0000c7 	bhi	16c4 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x38c>
       13a4:	e28d8004 	add	r8, sp, #4
       13a8:	e1a01006 	mov	r1, r6
       13ac:	e3e03000 	mvn	r3, #0
       13b0:	e1a00008 	mov	r0, r8
       13b4:	ebfffffe 	bl	0 <_ZNSsC1ERKSsjj>
   			13b4: R_ARM_CALL	_ZNSsC1ERKSsjj
       13b8:	e59f137c 	ldr	r1, [pc, #892]	; 173c <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x404>
       13bc:	e1a00008 	mov	r0, r8
       13c0:	e1a02005 	mov	r2, r5
       13c4:	e08f1001 	add	r1, pc, r1
       13c8:	e3a03001 	mov	r3, #1
       13cc:	ebfffffe 	bl	0 <_ZNKSs4findEPKcjj>
   			13cc: R_ARM_CALL	_ZNKSs4findEPKcjj
       13d0:	e2505000 	subs	r5, r0, #0
       13d4:	ba00003b 	blt	14c8 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x190>
       13d8:	e28d0008 	add	r0, sp, #8
       13dc:	e1a01008 	mov	r1, r8
       13e0:	e3a02000 	mov	r2, #0
       13e4:	e1a03005 	mov	r3, r5
       13e8:	ebfffffe 	bl	0 <_ZNSsC1ERKSsjj>
   			13e8: R_ARM_CALL	_ZNSsC1ERKSsjj
       13ec:	e3a01000 	mov	r1, #0
       13f0:	e59d0008 	ldr	r0, [sp, #8]
       13f4:	e1a02001 	mov	r2, r1
       13f8:	ebfffffe 	bl	0 <strtoul>
   			13f8: R_ARM_CALL	strtoul
       13fc:	e59d3004 	ldr	r3, [sp, #4]
       1400:	e2852001 	add	r2, r5, #1
       1404:	e513300c 	ldr	r3, [r3, #-12]
       1408:	e1520003 	cmp	r2, r3
       140c:	e1c401b0 	strh	r0, [r4, #16]
       1410:	8a0000c2 	bhi	1720 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x3e8>
       1414:	e28d500c 	add	r5, sp, #12
       1418:	e1a01008 	mov	r1, r8
       141c:	e3e03000 	mvn	r3, #0
       1420:	e1a00005 	mov	r0, r5
       1424:	ebfffffe 	bl	0 <_ZNSsC1ERKSsjj>
   			1424: R_ARM_CALL	_ZNSsC1ERKSsjj
       1428:	e59d200c 	ldr	r2, [sp, #12]
       142c:	e512300c 	ldr	r3, [r2, #-12]
       1430:	e3530000 	cmp	r3, #0
       1434:	0a00003a 	beq	1524 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x1ec>
       1438:	e3a01000 	mov	r1, #0
       143c:	e1a00002 	mov	r0, r2
       1440:	e1a02001 	mov	r2, r1
       1444:	ebfffffe 	bl	0 <strtoul>
   			1444: R_ARM_CALL	strtoul
       1448:	e59f32f0 	ldr	r3, [pc, #752]	; 1740 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x408>
       144c:	e59d200c 	ldr	r2, [sp, #12]
       1450:	e242100c 	sub	r1, r2, #12
       1454:	e5c40012 	strb	r0, [r4, #18]
       1458:	e7974003 	ldr	r4, [r7, r3]
       145c:	e1510004 	cmp	r1, r4
       1460:	1a00006d 	bne	161c <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x2e4>
       1464:	e59d3008 	ldr	r3, [sp, #8]
       1468:	e243000c 	sub	r0, r3, #12
       146c:	e1500004 	cmp	r0, r4
       1470:	1a000047 	bne	1594 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x25c>
       1474:	e59d3004 	ldr	r3, [sp, #4]
       1478:	e243000c 	sub	r0, r3, #12
       147c:	e1500004 	cmp	r0, r4
       1480:	0affffb7 	beq	1364 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x2c>
       1484:	e59f22b8 	ldr	r2, [pc, #696]	; 1744 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x40c>
       1488:	e7972002 	ldr	r2, [r7, r2]
       148c:	e3520000 	cmp	r2, #0
       1490:	0a000077 	beq	1674 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x33c>
       1494:	e2433004 	sub	r3, r3, #4
       1498:	f57ff05f 	dmb	sy
       149c:	e1932f9f 	ldrex	r2, [r3]
       14a0:	e2421001 	sub	r1, r2, #1
       14a4:	e183cf91 	strex	ip, r1, [r3]
       14a8:	e35c0000 	cmp	ip, #0
       14ac:	1afffffa 	bne	149c <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x164>
       14b0:	f57ff05f 	dmb	sy
       14b4:	e3520000 	cmp	r2, #0
       14b8:	caffffa9 	bgt	1364 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x2c>
       14bc:	e1a01005 	mov	r1, r5
       14c0:	ebfffffe 	bl	0 <_ZNSs4_Rep10_M_destroyERKSaIcE>
   			14c0: R_ARM_CALL	_ZNSs4_Rep10_M_destroyERKSaIcE
       14c4:	eaffffa6 	b	1364 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x2c>
       14c8:	e59f3270 	ldr	r3, [pc, #624]	; 1740 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x408>
       14cc:	e7974003 	ldr	r4, [r7, r3]
       14d0:	e59d3004 	ldr	r3, [sp, #4]
       14d4:	e243000c 	sub	r0, r3, #12
       14d8:	e1500004 	cmp	r0, r4
       14dc:	0affffa0 	beq	1364 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x2c>
       14e0:	e59f225c 	ldr	r2, [pc, #604]	; 1744 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x40c>
       14e4:	e7972002 	ldr	r2, [r7, r2]
       14e8:	e3520000 	cmp	r2, #0
       14ec:	0a00005c 	beq	1664 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x32c>
       14f0:	e2433004 	sub	r3, r3, #4
       14f4:	f57ff05f 	dmb	sy
       14f8:	e1932f9f 	ldrex	r2, [r3]
       14fc:	e2421001 	sub	r1, r2, #1
       1500:	e183cf91 	strex	ip, r1, [r3]
       1504:	e35c0000 	cmp	ip, #0
       1508:	1afffffa 	bne	14f8 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x1c0>
       150c:	f57ff05f 	dmb	sy
       1510:	e3520000 	cmp	r2, #0
       1514:	caffff92 	bgt	1364 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x2c>
       1518:	e28d100c 	add	r1, sp, #12
       151c:	ebfffffe 	bl	0 <_ZNSs4_Rep10_M_destroyERKSaIcE>
   			151c: R_ARM_CALL	_ZNSs4_Rep10_M_destroyERKSaIcE
       1520:	eaffff8f 	b	1364 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x2c>
       1524:	e59f1214 	ldr	r1, [pc, #532]	; 1740 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x408>
       1528:	e242000c 	sub	r0, r2, #12
       152c:	e1c431b0 	strh	r3, [r4, #16]
       1530:	e5c43012 	strb	r3, [r4, #18]
       1534:	e7974001 	ldr	r4, [r7, r1]
       1538:	e1500004 	cmp	r0, r4
       153c:	1a000025 	bne	15d8 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x2a0>
       1540:	e59d3008 	ldr	r3, [sp, #8]
       1544:	e243000c 	sub	r0, r3, #12
       1548:	e1500004 	cmp	r0, r4
       154c:	0affffdf 	beq	14d0 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x198>
       1550:	e59f21ec 	ldr	r2, [pc, #492]	; 1744 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x40c>
       1554:	e7972002 	ldr	r2, [r7, r2]
       1558:	e3520000 	cmp	r2, #0
       155c:	0a000048 	beq	1684 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x34c>
       1560:	e2433004 	sub	r3, r3, #4
       1564:	f57ff05f 	dmb	sy
       1568:	e1932f9f 	ldrex	r2, [r3]
       156c:	e2421001 	sub	r1, r2, #1
       1570:	e183cf91 	strex	ip, r1, [r3]
       1574:	e35c0000 	cmp	ip, #0
       1578:	1afffffa 	bne	1568 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x230>
       157c:	f57ff05f 	dmb	sy
       1580:	e3520000 	cmp	r2, #0
       1584:	caffffd1 	bgt	14d0 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x198>
       1588:	e1a01005 	mov	r1, r5
       158c:	ebfffffe 	bl	0 <_ZNSs4_Rep10_M_destroyERKSaIcE>
   			158c: R_ARM_CALL	_ZNSs4_Rep10_M_destroyERKSaIcE
       1590:	eaffffce 	b	14d0 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x198>
       1594:	e59f21a8 	ldr	r2, [pc, #424]	; 1744 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x40c>
       1598:	e7972002 	ldr	r2, [r7, r2]
       159c:	e3520000 	cmp	r2, #0
       15a0:	0a00003b 	beq	1694 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x35c>
       15a4:	e2433004 	sub	r3, r3, #4
       15a8:	f57ff05f 	dmb	sy
       15ac:	e1932f9f 	ldrex	r2, [r3]
       15b0:	e2421001 	sub	r1, r2, #1
       15b4:	e183cf91 	strex	ip, r1, [r3]
       15b8:	e35c0000 	cmp	ip, #0
       15bc:	1afffffa 	bne	15ac <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x274>
       15c0:	f57ff05f 	dmb	sy
       15c4:	e3520000 	cmp	r2, #0
       15c8:	caffffa9 	bgt	1474 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x13c>
       15cc:	e1a01005 	mov	r1, r5
       15d0:	ebfffffe 	bl	0 <_ZNSs4_Rep10_M_destroyERKSaIcE>
   			15d0: R_ARM_CALL	_ZNSs4_Rep10_M_destroyERKSaIcE
       15d4:	eaffffa6 	b	1474 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x13c>
       15d8:	e59f3164 	ldr	r3, [pc, #356]	; 1744 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x40c>
       15dc:	e7973003 	ldr	r3, [r7, r3]
       15e0:	e3530000 	cmp	r3, #0
       15e4:	0a00002e 	beq	16a4 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x36c>
       15e8:	e2422004 	sub	r2, r2, #4
       15ec:	f57ff05f 	dmb	sy
       15f0:	e1923f9f 	ldrex	r3, [r2]
       15f4:	e2431001 	sub	r1, r3, #1
       15f8:	e182cf91 	strex	ip, r1, [r2]
       15fc:	e35c0000 	cmp	ip, #0
       1600:	1afffffa 	bne	15f0 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x2b8>
       1604:	f57ff05f 	dmb	sy
       1608:	e3530000 	cmp	r3, #0
       160c:	caffffcb 	bgt	1540 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x208>
       1610:	e1a0100d 	mov	r1, sp
       1614:	ebfffffe 	bl	0 <_ZNSs4_Rep10_M_destroyERKSaIcE>
   			1614: R_ARM_CALL	_ZNSs4_Rep10_M_destroyERKSaIcE
       1618:	eaffffc8 	b	1540 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x208>
       161c:	e59f3120 	ldr	r3, [pc, #288]	; 1744 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x40c>
       1620:	e7973003 	ldr	r3, [r7, r3]
       1624:	e3530000 	cmp	r3, #0
       1628:	0a000021 	beq	16b4 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x37c>
       162c:	e2422004 	sub	r2, r2, #4
       1630:	f57ff05f 	dmb	sy
       1634:	e1923f9f 	ldrex	r3, [r2]
       1638:	e2430001 	sub	r0, r3, #1
       163c:	e182cf90 	strex	ip, r0, [r2]
       1640:	e35c0000 	cmp	ip, #0
       1644:	1afffffa 	bne	1634 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x2fc>
       1648:	f57ff05f 	dmb	sy
       164c:	e3530000 	cmp	r3, #0
       1650:	caffff83 	bgt	1464 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x12c>
       1654:	e1a00001 	mov	r0, r1
       1658:	e1a0100d 	mov	r1, sp
       165c:	ebfffffe 	bl	0 <_ZNSs4_Rep10_M_destroyERKSaIcE>
   			165c: R_ARM_CALL	_ZNSs4_Rep10_M_destroyERKSaIcE
       1660:	eaffff7f 	b	1464 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x12c>
       1664:	e5132004 	ldr	r2, [r3, #-4]
       1668:	e2421001 	sub	r1, r2, #1
       166c:	e5031004 	str	r1, [r3, #-4]
       1670:	eaffffa6 	b	1510 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x1d8>
       1674:	e5132004 	ldr	r2, [r3, #-4]
       1678:	e2421001 	sub	r1, r2, #1
       167c:	e5031004 	str	r1, [r3, #-4]
       1680:	eaffff8b 	b	14b4 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x17c>
       1684:	e5132004 	ldr	r2, [r3, #-4]
       1688:	e2421001 	sub	r1, r2, #1
       168c:	e5031004 	str	r1, [r3, #-4]
       1690:	eaffffba 	b	1580 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x248>
       1694:	e5132004 	ldr	r2, [r3, #-4]
       1698:	e2421001 	sub	r1, r2, #1
       169c:	e5031004 	str	r1, [r3, #-4]
       16a0:	eaffffc7 	b	15c4 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x28c>
       16a4:	e5123004 	ldr	r3, [r2, #-4]
       16a8:	e2431001 	sub	r1, r3, #1
       16ac:	e5021004 	str	r1, [r2, #-4]
       16b0:	eaffffd4 	b	1608 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x2d0>
       16b4:	e5123004 	ldr	r3, [r2, #-4]
       16b8:	e2430001 	sub	r0, r3, #1
       16bc:	e5020004 	str	r0, [r2, #-4]
       16c0:	eaffffe1 	b	164c <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x314>
       16c4:	e59f007c 	ldr	r0, [pc, #124]	; 1748 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x410>
       16c8:	e59f107c 	ldr	r1, [pc, #124]	; 174c <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x414>
       16cc:	e08f0000 	add	r0, pc, r0
       16d0:	e08f1001 	add	r1, pc, r1
       16d4:	ebfffffe 	bl	0 <_ZSt24__throw_out_of_range_fmtPKcz>
   			16d4: R_ARM_CALL	_ZSt24__throw_out_of_range_fmtPKcz
       16d8:	e59f3060 	ldr	r3, [pc, #96]	; 1740 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x408>
       16dc:	e7974003 	ldr	r4, [r7, r3]
       16e0:	e59d0004 	ldr	r0, [sp, #4]
       16e4:	e240000c 	sub	r0, r0, #12
       16e8:	e1500004 	cmp	r0, r4
       16ec:	0a000001 	beq	16f8 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x3c0>
       16f0:	e1a0100d 	mov	r1, sp
       16f4:	ebfffffe 	bl	0 <_ZN4SVAR15SystemVariables17ElementEndHandlerEPvPKc>
   			16f4: R_ARM_CALL	_ZNSs4_Rep10_M_disposeERKSaIcE.part.1
       16f8:	ebfffffe 	bl	0 <__cxa_end_cleanup>
   			16f8: R_ARM_CALL	__cxa_end_cleanup
       16fc:	e59f303c 	ldr	r3, [pc, #60]	; 1740 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x408>
       1700:	e59d0008 	ldr	r0, [sp, #8]
       1704:	e7974003 	ldr	r4, [r7, r3]
       1708:	e240000c 	sub	r0, r0, #12
       170c:	e1500004 	cmp	r0, r4
       1710:	0afffff2 	beq	16e0 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x3a8>
       1714:	e1a0100d 	mov	r1, sp
       1718:	ebfffffe 	bl	0 <_ZN4SVAR15SystemVariables17ElementEndHandlerEPvPKc>
   			1718: R_ARM_CALL	_ZNSs4_Rep10_M_disposeERKSaIcE.part.1
       171c:	eaffffef 	b	16e0 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x3a8>
       1720:	e59f0028 	ldr	r0, [pc, #40]	; 1750 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x418>
       1724:	e59f1028 	ldr	r1, [pc, #40]	; 1754 <_ZN4SVAR8Variable19SetIndexAndSubIndexESs+0x41c>
       1728:	e08f0000 	add	r0, pc, r0
       172c:	e08f1001 	add	r1, pc, r1
       1730:	ebfffffe 	bl	0 <_ZSt24__throw_out_of_range_fmtPKcz>
   			1730: R_ARM_CALL	_ZSt24__throw_out_of_range_fmtPKcz
       1734:	000003d4 	.word	0x000003d4
   			1734: R_ARM_GOTPC	_GLOBAL_OFFSET_TABLE_
       1738:	000003ac 	.word	0x000003ac
   			1738: R_ARM_REL32	.LC40
       173c:	00000370 	.word	0x00000370
   			173c: R_ARM_REL32	.LC43
   	...
   			1740: R_ARM_GOT32	_ZNSs4_Rep20_S_empty_rep_storageE
   			1744: R_ARM_GOT32	__pthread_key_create
       1748:	00000074 	.word	0x00000074
   			1748: R_ARM_REL32	.LC41
       174c:	00000074 	.word	0x00000074
   			174c: R_ARM_REL32	.LC42
       1750:	00000020 	.word	0x00000020
   			1750: R_ARM_REL32	.LC41
       1754:	00000020 	.word	0x00000020
   			1754: R_ARM_REL32	.LC42
   ```
   
   发现在函数`_ZN4SVAR8Variable19SetIndexAndSubIndexESs`使用了符号`_ZSt24__throw_out_of_range_fmtPKcz`，并且可以发现这个符号应该是和异常相关的处理。
   
   找到源代码`SVAR_SystemVariables.cpp`文件中的`SetIndexAndSubIndex`函数：
   
   ```cpp
   void Variable::SetIndexAndSubIndex(std::string comment)
   {
       _index = 0;
       _subIndex = 0;
   
       if (comment.empty())
       {
           DBGPRINT0D("[SVAR] comment is empty!");
           return;
       }
   
       size_t dwPos0x = comment.find("0x", 0);
       if ((ssize_t)dwPos0x < 0)
       {
           DBGPRINT1D("[SVAR] Failed to find \"0x\" from comment(%s)!", comment.c_str());
           return;
       }
   
       std::string subString = comment.substr(dwPos0x);
       size_t dwPosDelim = subString.find(":", 0);
       if ((ssize_t)dwPosDelim < 0)
       {
           DBGPRINT1D("[SVAR] Failed to find \":\" from comment(%s)!", comment.c_str());
           return;
       }         
   
       std::string indexStr = subString.substr(0, dwPosDelim);
       _index = strtoul(indexStr.c_str(), nullptr, 0);
   
       std::string subIndexStr = subString.substr(dwPosDelim + 1);
       if (subIndexStr.empty())
       {
           DBGPRINT1D("[SVAR] Failed to find subindex from comment(%s)!", comment.c_str());
           _index = 0;
           _subIndex = 0;
           return;
       }
       else
       {
           if (subIndexStr.length() > 0)
           {
               _subIndex = strtoul(subIndexStr.c_str(), nullptr, 0);
           }
       }
   }
   ```
   
   分析源代码与`_ZSt24__throw_out_of_range_fmtPKcz`符号，推测可能时某些地方可能抛出超出范围的异常（也可挨个函数进行尝试，但没必要），string::substr函数应该会检查字符串长度，从这里着手分析。起始解决版本也很明了，就是进行字符串的长度检查。
   
   修正后的代码如下：
   
   ```cpp
   void Variable::SetIndexAndSubIndex(std::string comment)
   {
       _index = 0;
       _subIndex = 0;
   
       if (comment.empty())
       {
           DBGPRINT0D("[SVAR] comment is empty!");
           return;
       }
   
       size_t dwPos0x = comment.find("0x", 0);
       if ((ssize_t)dwPos0x < 0)
       {
           DBGPRINT1D("[SVAR] Failed to find \"0x\" from comment(%s)!", comment.c_str());
           return;
       }
   
       if (dwPos0x >= comment.length())
       {
           return;
       }
   
       std::string subString = comment.substr(dwPos0x);
       size_t dwPosDelim = subString.find(":", 0);
       if ((ssize_t)dwPosDelim < 0)
       {
           DBGPRINT1D("[SVAR] Failed to find \":\" from comment(%s)!", comment.c_str());
           return;
       }
   
       if (dwPosDelim >= subString.length())
       {
           return;
       }            
   
       std::string indexStr = subString.substr(0, dwPosDelim);
       _index = strtoul(indexStr.c_str(), nullptr, 0);
   
       if ((dwPosDelim + 1) >= subString.length())
       {
           _index = 0;
           _subIndex = 0;
           return;
       }
   
       std::string subIndexStr = subString.substr(dwPosDelim + 1);
       if (subIndexStr.empty())
       {
           DBGPRINT1D("[SVAR] Failed to find subindex from comment(%s)!", comment.c_str());
           _index = 0;
           _subIndex = 0;
           return;
       }
       else
       {
           if (subIndexStr.length() > 0)
           {
               _subIndex = strtoul(subIndexStr.c_str(), nullptr, 0);
           }
       }
   }
   ```
   
   修改之后进行编译，发现未找到`_ZSt24__throw_out_of_range_fmtPKcz`符号。
   
   运行程序，未报错。
   
# 总结

不使用高版本c++特性即可使高版本编译的程序运行在低版本库环境中。

   

   

   

   