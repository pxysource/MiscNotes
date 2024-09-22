# no OS development Makefile

CROSS_COMPILE   ?= /home/linux/s3c2440/gcc-3.4.5-glibc-2.3.6/bin/arm-linux-
CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump
BIN=sdram.bin
ELF=sdram.elf
DIS=sdram.dis
SRC=$(wildcard *.c)
# 注意：head.S是启动文件，链接的时候要放在最前面
OBJ=head.o $(patsubst %.c,%.o,$(SRC))

all:$(BIN)

# 生成bin文件
$(BIN):$(ELF)
	$(OBJCOPY) -O binary -S $^ $@

disassemble:$(DIS)

# 反汇编
$(DIS):$(ELF)
	$(OBJDUMP) -D -m arm $^ > $@


# 生成ELF文件
$(ELF):$(OBJ)
	$(LD) -Ttext 0x30000000 $^ -o $@

.PHONY:clean
clean:
	$(RM) *.dis *.o *.elf

