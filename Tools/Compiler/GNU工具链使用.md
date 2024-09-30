# 用法

## 反编译ELF文件：objdump

```shell
arm-xilinx-linux-gnueabi-objdump LINUX.elf -D -S -l > LINUX.disa
```

- `-D`: `Display assembler contents of all sections`
- `-S`: `Intermix source code with disassembly`
- `-l`: `Include line numbers and filenames in output`

## 查看动态库的依赖

### objdump

```bash
objdump -x xxx.so | grep NEEDED
```

- `-x`: `Display the contents of all headers`

### readelf

```bash
readelf -a xxx.so | grep "Shared"

# or

readelf -d xxx.so
```

- `-a`: `Equivalent to: -h -l -S -s -r -d -V -A -I`
- `-d`: `Display the dynamic section (if present)`

### ldd

print shared object dependencies.

```bash
ldd xxx.so
```

:information_source: 嵌入式工具链一般没有这个工具。
