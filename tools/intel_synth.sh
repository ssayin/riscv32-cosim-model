#!/bin/sh

# Exit immediately after failure
set -e

# For synthesizing on Quartus Lite Software
quartus_sh -t tools/fpga_top.tcl compile fpga_top rev_1
quartus_map fpga_top 
quartus_fit fpga_top
quartus_asm fpga_top
quartus_sta fpga_top
