# Warning - bad CRC, using default environment

出现这个现象的原因：环境变量存储区没有相应的数据。

首次烧写u-boot启动，出现这个提示，执行`saveenv`指令保存环境变量即可。

