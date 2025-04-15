# Ubuntu 16.04

1. 安装`gnuplot`

2. 运行xenomai `latency`程序，生成测试数据`latency.log`。

3. 按照`xenomai-2.6.3/scripts/histo.gp`说明，运行`gnuplot`生成图表：

   ```shell
   gnuplot -e 'input_file="/path/to/input";output_file="/path/to/output.png";graph_title="title text"' /path/to/histo.gp
   ```

4. 查看图表，分析xenomai的`latency`。