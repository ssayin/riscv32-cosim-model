#!/bin/sh

# For synthesizing on Quartus Lite Software

# Exit immediately after failure
set -e

# Specify the project name and revision
project_name="fpga_top"
revision="rev_1"

# Compile using Quartus tools
quartus_sh -t tools/fpga_top.tcl compile "$project_name" "$revision"

for stage in map fit asm; do
    quartus_"$stage" "$project_name"
done
quartus_sta -t tools/sta.tcl "$project_name" "$revision"
