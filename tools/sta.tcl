set project_name "fpga_top"

project_open $project_name

create_timing_netlist

read_sdc ./tools/fpga_top.sdc

read_sdc -hdl

update_timing_netlist

report_timing

delete_timing_netlist
project_close
