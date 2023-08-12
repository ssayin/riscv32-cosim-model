# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: Apache-2.0

all: sim

include $(CONFIG_DIR)data.mk
include $(CONFIG_DIR)svdpi.mk
include $(CONFIG_DIR)uvm/config.mk

RTL_FLIST_DIR         := $(RTL_DIR)
TB_FLIST_DIR          := $(TB_DIR)

RTL_FLIST             := $(RTL_FLIST_DIR)flist.xsim
TB_FLIST              := $(TB_FLIST_DIR)flist.xsim
UVM_BFM_FLIST         := $(BFM_CONFIG_ROOT)flist.xsim
UVM_TOP_FLIST         := $(TOP_CONFIG_ROOT)flist.xsim

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

COMPILE_OPTIONS := -define DEBUG_INIT_FILE='"$(shell readlink -f "./src/firmware/boot.hex")"' \
									 -define HEX_FILENAME='"$(shell readlink -f "./src/firmware/boot.hex")"'

sim: uvm_top uvm_bfm tb_top_level riscv_decoder

#lib_vivado: $(DECODER_SRCS) $(EXPORTER_SRCS) $(DISAS_SRCS)
#	xsc $(DECODER_SRCS) $(EXPORTER_SRCS) $(DISAS_SRCS) --gcc_compile_options $(DECODER_INC) --gcc_compile_options $(COMMON_INC) --gcc_compile_options $(DISAS_INC) -cppversion 20

riscv_decoder: $(SOLIB_STDCXX) $(SVDPI) compile_riscv_decoder
	LD_PRELOAD=$(SOLIB_STDCXX) xelab tb_riscv_decoder -relax -s decoder -sv_lib $(basename $(notdir $(SVDPI)))
	LD_PRELOAD=$(SOLIB_STDCXX) LD_LIBRARY_PATH=$(PROJECT_ROOT) xsim decoder -testplusarg UVM_TESTNAME=riscv_decoder_from_file_test -testplusarg UVM_VERBOSITY=UVM_LOW -R

uvm_bfm: compile_bfm
	xelab bfm_untimed_tb bfm_hdl_th -relax -s bfm_tb
	xsim bfm_tb -testplusarg UVM_TESTNAME=bfm_test -testplusarg UVM_VERBOSITY=UVM_HIGH -R

uvm_top: compile_top
	xelab top_tb top_th -relax -s top_tb
	xsim top_tb -testplusarg UVM_TESTNAME=top_test -testplusarg UVM_VERBOSITY=UVM_HIGH -R

tb_top_level: compile_rtl
	xelab tb_top_level -relax -s tb_top_level
	xsim tb_top_level -R

# Compile SystemVerilog files on Xilinx Vivado Suite

compile_rtl: $(RTL_FLIST)
	xvlog -sv -f $^ -L uvm

compile_riscv_decoder: compile_rtl $(TB_FLIST) $(INSTR_FEED)
	xvlog -sv -f $(TB_FLIST) -L uvm -define INSTR_SEQ_FILENAME='"$(INSTR_FEED)"' -define INSTR_SEQ_LINECOUNT=$(shell cat $(INSTR_FEED) | wc -l)

compile_bfm: compile_rtl $(UVM_BFM_FLIST) $(UVM_BFM_DIR)
	xvlog -sv -f $(UVM_BFM_FLIST) -L uvm $(COMPILE_OPTIONS) -define INSTR_SEQ_FILENAME='"$(INSTR_FEED)"' -define INSTR_SEQ_LINECOUNT=$(shell cat $(INSTR_FEED) | wc -l)


compile_top: compile_rtl $(UVM_TOP_FLIST) $(UVM_TOP_DIR)
	xvlog -sv -f $(UVM_TOP_FLIST) -L uvm $(COMPILE_OPTIONS) -define INSTR_SEQ_FILENAME='"$(INSTR_FEED)"' -define INSTR_SEQ_LINECOUNT=$(shell cat $(INSTR_FEED) | wc -l)

