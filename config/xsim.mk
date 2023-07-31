# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: MIT

all: sim

include $(CONFIG_DIR)common.mk
include $(CONFIG_DIR)lib.mk

#VIVADO_INC := /opt/Xilinx/Vivado/2022.2/data/xsim/include/

# Set full path to the shared obj that ld links against as default.
# I am not planning to rewrite ISS parts to support old libstdc++ versions.
# Other solutions seemed to be convoluted.
# You may also choose to link against the one distributed with Vivado Suite. 
# CXX 20 is required.
SOLIB_STDCXX  := $(shell /sbin/ldconfig -p | perl -ne 'if (/stdc\+\+/) { @columns = split; print $$columns[3]; exit }')

# My version string is as follows:
# Vivado v2022.2 (64-bit)
# SW Build 3671981 on Fri Oct 14 04:59:54 MDT 2022
# IP Build 3669848 on Fri Oct 14 08:30:02 MDT 2022
# Tool Version Limit: 2022.10

# Vivado FPGA flow
# I do not own a Xilinx board, so I am moving from Vivado.
# Vivado XSIM support will be continued.
#synth: tools/vivado.tcl
#	vivado -mode batch -source tools/vivado.tcl

sim: gentb tb_toplevel riscv_decoder

#lib_vivado: $(DECODER_SRCS) $(EXPORTER_SRCS) $(DISAS_SRCS)
#	xsc $(DECODER_SRCS) $(EXPORTER_SRCS) $(DISAS_SRCS) --gcc_compile_options $(DECODER_INC) --gcc_compile_options $(COMMON_INC) --gcc_compile_options $(DISAS_INC) -cppversion 20

riscv_decoder: $(SOLIB_STDCXX) $(LIB) compile
	LD_PRELOAD=$(SOLIB_STDCXX) xelab tb_riscv_decoder -relax -s decoder -sv_lib $(basename $(notdir $(LIB)))
	LD_PRELOAD=$(SOLIB_STDCXX) LD_LIBRARY_PATH=$(LIB_DIR) xsim decoder -testplusarg UVM_TESTNAME=riscv_decoder_from_file_test -testplusarg UVM_VERBOSITY=UVM_LOW -R

gentb: compile
	xelab top_untimed_tb top_hdl_th -relax -s top_tb
	xsim top_tb -testplusarg UVM_TESTNAME=top_test -testplusarg UVM_VERBOSITY=UVM_HIGH -R

tb_toplevel: compile
	xelab tb_top_level -relax -s tb_toplevel
	xsim tb_toplevel -R

# Compile SystemVerilog files on Xilinx Vivado Suite
compile: $(INSTR_FEED)
	xvlog -sv -f xsim_sv_compile_list -L uvm \
		-define INSTR_SEQ_FILENAME='"$(INSTR_FEED)"' \
		-define INSTR_SEQ_LINECOUNT=$(shell cat $(INSTR_FEED) | wc -l) \
		-define DEBUG_INIT_FILE='"$(shell readlink -f "./src/firmware/boot.hex")"'
