使用 `gnuplot` 分析测试的 latency 的数据。

# 数据格式

```
5 166
6 40331
7 27186
8 212267
9 95918
```

第一个数值为时间，如5ms、6ms与7ms等。

第二个数值为时间时间出现的次数，如5ms出现166次，6ms出现40331次。

# Windows

下载 `gnuplot` Windows版本。

运行 `create_all_charts.bat` 绘制所有折线图。也可只运行 `create_chart_dma_read.bat` 绘制单个折线图。