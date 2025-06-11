# 参数

## `getopt`/`getopts`：解析命令行参数

`getopt` 与 `getopts` 都是 `bash` 中用来获取与分析命令行参数的工具，常用在 `shell` 脚本中被用来分析脚本参数。

两者的比较：

- `getopts` 是 `shell` 内建命令，`getopt` 是一个独立外部工具。
- `getopts` 使用语法简单，`getopt` 使用语法较复杂。
- `getopts` 不支持长选项，`getopt` 支持。
- `getopts` 不会重排所有选项的顺序，`getopt` 会重排选项顺序。
- `getopts` 出现的目的是为了代替 `getopt` 较快捷的执行参数分析工作。




> [!TIP]
> 短选项：`-a`，长选项：`--all`。

### `getopts`

示例脚本：`demo_getopts.sh`。

运行输出：

```shell
linux@linux-virtual-machine:/tmp$ ./demo_getopts.sh -d 3 -D -f dir1 -m dir2 -t dir3 test -o -a
del_days=3
del_original=yes
dir_from=dir1
maildir_name=dir2
dir_to=dir3
OPTIND=10
Other arguments: test -o -a
```

>  [!IMPORTANT]
>
> 1. 选项参数的格式必须是 `-d val`，而不能是中间没有空格的 `-dval`。
> 2. 所有选项参数必须写在其它参数的前面，因为 `getopts` 是从命令行前面开始处理，遇到非 `-` 开头的参数，或者选项参数结束标记 `--` 就中止了，如果中间遇到非选项的命令行参数，后面的选项参数就都取不到了。
> 3. 不支持长选项。

#### 内置变量

`OPTARG`：

- `OPTARG` 表示 **当前选项的参数**（argument）。

- 只有当当前选项**要求参数**（比如 `-f filename`）时，`OPTARG` 才会被设置。

`OPTIND`：

- `OPTIND` 是 **getopts 处理到的下一个位置参数的索引**（Index）。

- 初始值为 `1`，每处理一个选项就会加 `1`。

#### 选项

无参数选项：如 `abcd` 。

有参数选项：如 `a:b:c:d:` 。

#### 错误处理

**1. 用户没有输入选项的情况**：`getopts` 无法处理没有选项的情况，需要根据脚本参数的数量进行检查。

```shell
if [ $# -eq 0 ]; then
    usage
    exit 1
fi
```



**2. 选项的参数不存在**：可以使用 `getopts` 的普通模式（默认），也可以使用 `getopts` 的静默模式。普通模式下，会显示 `getopts` 的错误提示；静默模式下，不会显示 `getopts` 的错误提示。

- 普通模式，`getopts`自动处理错误，`:)`无法捕获错误。`getopts` 默认就为普通模式。如 `demo_getopts.sh` 中所示：
  ```shell
  while getopts "d:Dm:f:t:" opt; do
      case $opt in
  		# ...
          :)
              echo "[ERR] Option -${OPTARG} requires an argument!" >&2
              exit 1
              ;;
          ?)
              echo "[ERR] Invalid option -${OPTARG}!" >&2
              exit 1
              ;;
      esac
  done
  ```
  
  错误提示为：
  
  ```shell
  linux@linux-virtual-machine:/tmp$ ./demo_getopts.sh -f
  ./demo_getopts.sh: option requires an argument -- f
  [ERR] Invalid option -!
  ```
  
- 静默模式，`getopts` 选项字符串以 `:` 开头，使用 `:)` 捕获错误。如 `demo_getopts.sh` 中所示：

  ```shell
  while getopts ":d:Dm:f:t:" opt; do
      case $opt in
  		# ...
          :)
              echo "[ERR] Option -${OPTARG} requires an argument!" >&2
              exit 1
              ;;
  		# ...
      esac
  done
  ```
  错误提示为：
  
  ```shell
  linux@linux-virtual-machine:/tmp$ ./demo_getopts_err_handling.sh -f
  [ERR] Option -f requires an argument!
  ```



**3. 不能识别的参数**：可以使用 `getopts` 的普通模式（默认），也可以使用 `getopts` 的静默模式。并且都能使用 `?)` 捕获错误。普通模式下，会显示 `getopts` 的错误提示；静默模式下，不会显示 `getopts` 的错误提示。

- 普通模式，`getopts` 默认就为普通模式。如`demo_getopts.sh`中所示：

  ```shell
  while getopts "d:Dm:f:t:" opt; do
      case $opt in
  		# ...
          ?)
              echo "[ERR] Invalid option -${OPTARG}!" >&2
              exit 1
              ;;
      esac
  done
  ```
  
  错误提示为：
  
  ```shell
  linux@linux-virtual-machine:/tmp$ ./demo_getopts.sh -s
  ./demo_getopts.sh: illegal option -- s
  [ERR] Invalid option -!
  ```
  
- 静默模式，`getopts` 选项字符串以 `:` 开头，使用 `?)` 捕获错误。如 `demo_getopts.sh` 中所示：

  ```shell
  while getopts ":d:Dm:f:t:" opt; do
  # while getopts "d:Dm:f:t:" opt; do
      case $opt in
  		# ...
          ?)
              echo "[ERR] Invalid option -${OPTARG}!" >&2
              exit 1
              ;;
      esac
  done
  ```

  错误提示为：

  ```shell
  linux@linux-virtual-machine:/tmp$ ./demo_getopts.sh -s
  [ERR] Invalid option -s!
  ```



### `getopt`

`getopt` 是另一个用于解析命令行参数的工具，和 `getopts` 不同，它适合更复杂的参数解析，特别是支持 **长选项（如 `--help`）** 和 **多个选项组合（如 `-abc`）**。

> [!IMPORTANT]
>
> `getopt` 并不是所有系统都支持，各个系统可能有差异，`gnu-getopt` 才支持比较复杂的操作。



示例脚本：`demo_getopt.sh`。

运行输出：

```shell
linux@linux-virtual-machine:/tmp$ ./demo_getopt.sh -p -b -c -r -i dir1 -v test 1 2 3
patch
build
clean
rebuild
install path: dir1
version
Remaining arguments:
    arg -> test
    arg -> 1
    arg -> 2
    arg -> 3
```

#### 选项

如下所示：

```shell
ARGS=`getopt -o "hpbcri:v" -l "help,patch,build,clean,rebuild,install:,version" -n ${PROGRAM} -- "$@"`
```

- `-o` 后面表示短选项。

- `-l` 后面表示长选项。
- `-n` 指定 `getopt` 报告错误时将使用的名称。
- 一个 `:` 表示有参数的选项。两个 `::` 也表示有参数的选项，参数可选，不管参数要紧挨着选项，如`-aXXX`而不能是`-a XXX`。
