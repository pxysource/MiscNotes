#$language = "VBScript"
#$interface = "1.0"

crt.Screen.Synchronous = True

' This automatically generated script may need to be
' edited in order to work correctly.

Sub Main
	crt.Screen.WaitForString "Hit any key to stop autoboot:"
	crt.Screen.Send " " & chr(13)
	crt.Screen.WaitForString "zynq-uboot>"
	crt.Screen.Send "setenv kernel_image uImage" & chr(13)
	crt.Screen.WaitForString "zynq-uboot>"
	crt.Screen.Send "setenv serverip 192.168.1.3" & chr(13)
	crt.Screen.WaitForString "zynq-uboot>"
	crt.Screen.Send "setenv ipaddr 192.168.1.4" & chr(13)
	crt.Screen.WaitForString "zynq-uboot>"
	
	' linux内核动态调试
	' ""为vbs中"的转义
	' 命令行：setenv bootargs console=ttyPS0,115200 root=/dev/ram rw earlyprintk loglevel=8 dyndbg=\"file drivers/spi/spi-xilinx-qps.c +p\"
	' crt.Screen.Send "setenv bootargs console=ttyPS0,115200 root=/dev/ram rw earlyprintk loglevel=8 dyndbg=\""file drivers/spi/spi-xilinx-qps.c +p\; file drivers/spi/spi.c +p\; file drivers/spi/spidev.c +p\; file drivers/mtd/devices/m25p80.c +p\"" " & chr(13)
	' crt.Screen.Send "setenv bootargs console=ttyPS0,115200 root=/dev/ram rw earlyprintk loglevel=8 dyndbg=\""file drivers/spi/spi-xilinx-qps.c +p\; file drivers/spi/spi.c +p\; file drivers/mtd/devices/m25p80.c +p\"" " & chr(13)
	crt.Screen.Send "setenv bootargs console=ttyPS0,115200 root=/dev/ram rw earlyprintk" & chr(13)
	crt.Screen.WaitForString "zynq-uboot>"
	
	crt.Screen.Send "run jtagboot" & chr(13)
End Sub
