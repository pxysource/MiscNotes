@echo off
gnuplot.exe -e "input_file=\"dma_write.log\";output_file=\"dma_write.png\";graph_title=\"Cycle time: 1000us\"" dma_write.gp