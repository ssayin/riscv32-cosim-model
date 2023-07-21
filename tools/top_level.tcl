# Copyright (C) 2023  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and any partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the applicable agreement for further details, at
# https://fpgasoftware.intel.com/eula.

# Quartus Prime: Generate Tcl File for Project
# File: top_level.tcl
# Generated on: Fri Jul 21 20:21:55 2023

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "top_level"]} {
		puts "Project top_level is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists top_level]} {
		project_open -revision top_level top_level
	} else {
		project_new -revision top_level top_level
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Cyclone IV E"
	set_global_assignment -name DEVICE EP4CE6E22C8
	set_global_assignment -name TOP_LEVEL_ENTITY platform
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 22.1STD.1
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "20:00:17  JULY 21, 2023"
	set_global_assignment -name LAST_QUARTUS_VERSION "22.1std.1 Lite Edition"
	set_global_assignment -name SEARCH_PATH ./src/rtl/include
	set_global_assignment -name QIP_FILE ./ip/platform/synthesis/platform.qip
	set_global_assignment -name SYSTEMVERILOG_FILE ./src/rtl/core/id_stage_1.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ./src/rtl/core/reg_file.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ./src/rtl/core/mem_stage.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ./src/rtl/core/riscv_core.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ./src/rtl/core/id_stage_0.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ./src/rtl/core/ex_stage.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ./src/rtl/core/arith/alu.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ./src/rtl/core/decoder/riscv_decoder.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ./src/rtl/core/decoder/riscv_decoder_j.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ./src/rtl/core/decoder/riscv_decoder_j_no_rr.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ./src/rtl/core/decoder/riscv_decoder_ctl_imm.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ./src/rtl/core/decoder/riscv_decoder_j_no_rr_imm.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ./src/rtl/core/decoder/riscv_decoder_br.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ./src/rtl/core/decoder/riscv_decoder_gpr.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ./src/rtl/core/ifu/if_stage.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ./src/rtl/include/param_defs.sv
	set_global_assignment -name SYSTEMVERILOG_FILE ./src/rtl/include/instr_defs.sv

	# Including default assignments
	set_global_assignment -name TIMING_ANALYZER_MULTICORNER_ANALYSIS ON -family "Cyclone IV E"
	set_global_assignment -name TIMING_ANALYZER_REPORT_WORST_CASE_TIMING_PATHS ON -family "Cyclone IV E"
	set_global_assignment -name TIMING_ANALYZER_CCPP_TRADEOFF_TOLERANCE 0 -family "Cyclone IV E"
	set_global_assignment -name TDC_CCPP_TRADEOFF_TOLERANCE 0 -family "Cyclone IV E"
	set_global_assignment -name TIMING_ANALYZER_DO_CCPP_REMOVAL ON -family "Cyclone IV E"
	set_global_assignment -name DISABLE_LEGACY_TIMING_ANALYZER OFF -family "Cyclone IV E"
	set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS ON -family "Cyclone IV E"
	set_global_assignment -name SYNCHRONIZATION_REGISTER_CHAIN_LENGTH 2 -family "Cyclone IV E"
	set_global_assignment -name SYNTH_RESOURCE_AWARE_INFERENCE_FOR_BLOCK_RAM ON -family "Cyclone IV E"
	set_global_assignment -name OPTIMIZE_HOLD_TIMING "ALL PATHS" -family "Cyclone IV E"
	set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON -family "Cyclone IV E"
	set_global_assignment -name AUTO_DELAY_CHAINS ON -family "Cyclone IV E"
	set_global_assignment -name CRC_ERROR_OPEN_DRAIN OFF -family "Cyclone IV E"
	set_global_assignment -name USE_CONFIGURATION_DEVICE OFF -family "Cyclone IV E"
	set_global_assignment -name ENABLE_OCT_DONE OFF -family "Cyclone IV E"

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
