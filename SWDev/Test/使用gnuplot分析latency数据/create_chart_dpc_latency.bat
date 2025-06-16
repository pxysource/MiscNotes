@echo off
gnuplot.exe -e "input_file=\"dpc_latency.log\";output_file=\"dpc_latency.png\";graph_title=\"Cycle time: 1000us\"" dpc_latency.gp