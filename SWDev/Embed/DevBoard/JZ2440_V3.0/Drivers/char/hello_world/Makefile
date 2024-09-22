KERNEL_DIR = /home/linux/s3c2440/linux-2.6.22.6

all:
	make -C $(KERNEL_DIR) M=`pwd` modules

clean:
	make -C $(KERNEL_DIR) M=`pwd` modules clean
	rm -rf modules.order

obj-m += hello_world_drv.o
