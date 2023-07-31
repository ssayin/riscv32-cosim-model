#!/bin/sh

# For synthesizing on Quartus Lite Software
# Quartus Lite does not support incremental flow,
# thus I had to run these programs in succession.
quartus_sh -t tools/top_level.tcl compile top_level rev_1
quartus_map top_level
quartus_fit top_level
quartus_sta -t tools/sta.tcl top_level rev_1
# quartus_sim top_level
