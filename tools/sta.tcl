set project_name "fpga_top"

project_open $project_name

create_timing_netlist -model fast

create_clock -name "clk" -period 10ns [get_ports {clk}]
derive_pll_clocks
derive_clock_uncertainty

update_timing_netlist

report_timing

delete_timing_netlist
project_close
