# STEP#1: define the output directory area.
#
set outputDir ./out
file mkdir $outputDir
#
# STEP#2: setup design sources and constraints
#


set rtl_dir     ./src/rtl
set src_dir     $rtl_dir/
set include_dir $rtl_dir/common

read_verilog [ glob -directory $include_dir *.sv *.svh ]
read_verilog [ glob $src_dir/core/*.sv ]
read_verilog [ glob $src_dir/core/ifu/*.sv ]
read_verilog [ glob $src_dir/core/dec/*.sv ]
read_verilog [ glob $src_dir/core/exu/*.sv ]
read_verilog [ glob $src_dir/core/mem/*.sv ]
# read_verilog [ glob $rtl_dir/ssram/*.sv ]
# read_verilog [ glob $src_dir/*.sv ]
# read_verilog $rtl_dir/top_level.sv

#read_xdc ./tools/top_level.xdc
#
# STEP#3: run synthesis, write design checkpoint, report timing,
# and utilization estimates
#
synth_design -top riscv_core -part xc7k70tfbg676-2
write_checkpoint -force $outputDir/post_synth.dcp
report_timing_summary -file $outputDir/post_synth_timing_summary.rpt
report_utilization -file $outputDir/post_synth_util.rpt
#
# Run custom script to report critical timing paths
# reportCriticalPaths $outputDir/post_synth_critpath_report.csv
#
# STEP#4: run logic optimization, placement and physical logic optimization,
# write design checkpoint, report utilization and timing estimates
#
opt_design
# reportCriticalPaths $outputDir/post_opt_critpath_report.csv
#place_design
#report_clock_utilization -file $outputDir/clock_util.rpt
#
# Optionally run optimization if there are timing violations after placement
#if {[get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]] < 0} {
# puts "Found setup timing violations => running physical optimization"
# phys_opt_design
#}
#write_checkpoint -force $outputDir/post_place.dcp
#report_utilization -file $outputDir/post_place_util.rpt
#report_timing_summary -file $outputDir/post_place_timing_summary.rpt

#
# STEP#5: run the router, write the post-route design checkpoint, report the routing
# status, report timing, power, and DRC, and finally save the Verilog netlist.
#
#route_design
#write_checkpoint -force $outputDir/post_route.dcp
#report_route_status -file $outputDir/post_route_status.rpt
#report_timing_summary -file $outputDir/post_route_timing_summary.rpt
#report_power -file $outputDir/post_route_power.rpt
#report_drc -file $outputDir/post_imp_drc.rpt
#write_verilog -force $outputDir/cpu_impl_netlist.v -mode timesim -sdf_anno true
#
# STEP#6: generate a bitstream
#
#write_bitstream -force $outputDir/cpu.bit
