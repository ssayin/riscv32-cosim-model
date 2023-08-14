# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: Apache-2.0

all: sim

include $(CONFIG_DIR)data.mk
include $(CONFIG_DIR)svdpi.mk
include $(CONFIG_DIR)uvm/config.mk

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

run: sim

sim: $(SIM_TARGETS)
	LD_PRELOAD=$(SOLIB_STDCXX) LD_LIBRARY_PATH=$(PROJECT_ROOT) ./riscv_decoder -testplusarg UVM_TESTNAME=riscv_decoder_from_file_test -testplusarg UVM_VERBOSITY=UVM_LOW -testplusarg UVM_CONFIG_DB_TRACE -R
	./uvm_top -testplusarg UVM_TESTNAME=top_test -testplusarg UVM_VERBOSITY=UVM_HIGH -testplusarg UVM_CONFIG_DB_TRACE -R
	./uvm_bfm -testplusarg UVM_TESTNAME=bfm_test -testplusarg UVM_VERBOSITY=UVM_HIGH -testplusarg UVM_CONFIG_DB_TRACE -R

#lib_vivado: $(DECODER_SRCS) $(EXPORTER_SRCS) $(DISAS_SRCS)
#	xsc $(DECODER_SRCS) $(EXPORTER_SRCS) $(DISAS_SRCS) --gcc_compile_options $(DECODER_INC) --gcc_compile_options $(COMMON_INC) --gcc_compile_options $(DISAS_INC) -cppversion 20

riscv_decoder: $(SOLIB_STDCXX) $(SVDPI) $(BUILD_DIR)COMPILE_RISCV_DECODER 
	LD_PRELOAD=$(SOLIB_STDCXX) xelab tb_riscv_decoder -relax -s $@ -sv_lib $(basename $(notdir $(SVDPI))) -a
	mv axsim.sh $@

uvm_bfm: $(BUILD_DIR)COMPILE_UVM_BFM
	xelab bfm_untimed_tb bfm_hdl_th -relax -s $@ -a
	mv axsim.sh $@

uvm_top: $(BUILD_DIR)COMPILE_UVM_TOP
	xelab top_tb top_th -relax -s $@ -a
	mv axsim.sh $@

tb_top_level: $(BUILD_DIR)COMPILE_RTL
	xelab tb_top_level -relax -s $@ -a	
	mv axsim.sh $@

# Compile SystemVerilog files on Xilinx Vivado Suite


$(BUILD_DIR)COMPILE_RTL: $(RTL_FLIST) | $(BUILD_DIR)
	xvlog -sv -f $^ -L uvm
	touch $@

define compile_uvm_template
$(BUILD_DIR)COMPILE_$(1): $(BUILD_DIR)COMPILE_RTL $($(1)_FLIST) $($(1)_DIR) $(INSTR_FEED) | $(BUILD_DIR)
	xvlog -sv -f $($(1)_FLIST) -L uvm \
		-define INSTR_SEQ_FILENAME='"$(INSTR_FEED)"' \
		-define DEBUG_INIT_FILE='"$(shell readlink -f "./src/firmware/boot.hex")"' \
		-define HEX_FILENAME='"$(shell readlink -f "./src/firmware/boot.hex")"'
	touch $(BUILD_DIR)COMPILE_$(1)
endef

$(foreach target,$(UVM_TARGETS),$(eval $(call compile_uvm_template,$(target))))
