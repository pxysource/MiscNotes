@echo off
gnuplot.exe -e "input_file=\"dma_read.log\";output_file=\"dma_read.png\";graph_title=\"Cycle time: 1000us\"" dma_read.gp