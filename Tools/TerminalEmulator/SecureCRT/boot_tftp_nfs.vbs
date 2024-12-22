#$language = "VBScript"
#$interface = "1.0"

crt.Screen.Synchronous = True

' This automatically generated script may need to be
' edited in order to work correctly.

Sub Main
	crt.Screen.WaitForString "Hit any key to stop autoboot:"
	crt.Screen.Send " " & chr(13)
	crt.Screen.WaitForString "zynq-uboot> "
	crt.Screen.Send "setenv kernel_image uImage" & chr(13)
	crt.Screen.WaitForString "zynq-uboot> "
	crt.Screen.Send "setenv kernel_load_address 0x3000000" & chr(13)
	crt.Screen.WaitForString "zynq-uboot> "
	' crt.Screen.Send "setenv ramdisk_load_address 0x2000000" & chr(13)
	' crt.Screen.WaitForString "zynq-uboot> "
	crt.Screen.Send "setenv devicetree_load_address 0x2A00000" & chr(13)
	crt.Screen.WaitForString "zynq-uboot> "
	crt.Screen.Send "setenv serverip 192.168.1.3" & chr(13)
	crt.Screen.WaitForString "zynq-uboot> "
	crt.Screen.Send "setenv ipaddr 192.168.1.4" & chr(13)
	crt.Screen.WaitForString "zynq-uboot> "

	' 命令行：setenv bootargs console=ttyPS0,115200 root=/dev/nfs rw nfsroot=192.168.1.10:/home/linux/Workspace/zdyz/tmp_mnt ip=192.168.1.3:192.168.1.10:192.168.1.255:255.255.255.0::eth0:off
	' crt.Screen.Send "setenv bootargs console=ttyPS0,115200 root=/dev/nfs rw nfsroot=192.168.1.10:/home/linux/workspace/nfsdir/rootfs ip=192.168.1.4:192.168.1.10:192.168.1.255:255.255.255.0::eth0:off" & chr(13)
	crt.Screen.Send "setenv bootargs console=ttyPS0,115200 root=/dev/nfs rw nfsroot=192.168.1.10:/home/linux/github/XenoDE/build_root/rootfs ip=192.168.1.4:192.168.1.10:192.168.1.255:255.255.255.0::eth0:off" & chr(13)
	crt.Screen.WaitForString "zynq-uboot> "
	crt.Screen.Send "tftpboot ${kernel_load_address} ${kernel_image} && tftpboot ${devicetree_load_address} ${devicetree_image} && bootm ${kernel_load_address} - ${devicetree_load_address}" & chr(13)
End Sub
