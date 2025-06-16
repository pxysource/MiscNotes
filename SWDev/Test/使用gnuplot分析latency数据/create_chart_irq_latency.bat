@echo off
gnuplot.exe -e "input_file=\"irq_latency.log\";output_file=\"irq_latency.png\";graph_title=\"Cycle time: 1000us\"" irq_latency.gp