#!/bin/sh

# For synthesizing on Quartus Lite Software
# Quartus Lite does not support incremental flow,
# thus I had to run these programs in succession.
quartus_sh -t tools/fpga_top.tcl compile fpga_top rev_1
quartus_map fpga_top 
quartus_fit fpga_top
quartus_sta -t tools/sta.tcl fpga_top rev_1
# quartus_sim fpga_top
