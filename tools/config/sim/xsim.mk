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

SVLIB_DEF = -sv_lib $(basename $(notdir $(SVDPI)))

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

define compile_uvm_template
$(BUILD_DIR)COMPILE_$(1): $(BUILD_DIR)COMPILE_RTL $($(1)_FLIST) $($(1)_DIR) $(INSTR_FEED) | $(BUILD_DIR)
	xvlog -sv -f $($(1)_FLIST) -L uvm
	touch $(BUILD_DIR)COMPILE_$(1)
endef

define xelab_uvm_template
$(1): $(BUILD_DIR)COMPILE_$(shell echo '$(1)' | tr '[:lower:]' '[:upper:]') | $(SVDPI)
	$(4) xelab $(2) $(3) -relax -s $(1) $(5) -a
	mv axsim.sh $(1)
endef


run: run_uvm_top run_uvm_bfm run_riscv_decoder

run_uvm_top: sim
	./uvm_top -testplusarg UVM_TESTNAME=top_test \
		-testplusarg UVM_VERBOSITY=UVM_HIGH \
		-testplusarg UVM_CONFIG_DB_TRACE -R

run_uvm_bfm: sim
	./uvm_bfm -testplusarg UVM_TESTNAME=bfm_test \
		-testplusarg UVM_VERBOSITY=UVM_HIGH \
		-testplusarg UVM_CONFIG_DB_TRACE -R

run_riscv_decoder: sim
	LD_PRELOAD=$(SOLIB_STDCXX) LD_LIBRARY_PATH=$(PROJECT_ROOT) ./riscv_decoder \
		-testplusarg UVM_TESTNAME=riscv_decoder_from_file_test \
		-testplusarg UVM_VERBOSITY=UVM_LOW \
		-testplusarg UVM_CONFIG_DB_TRACE -R

sim: $(SIM_TARGETS)

#lib_vivado: $(DECODER_SRCS) $(EXPORTER_SRCS) $(DISAS_SRCS)
#	xsc $(DECODER_SRCS) $(EXPORTER_SRCS) $(DISAS_SRCS) --gcc_compile_options $(DECODER_INC) --gcc_compile_options $(COMMON_INC) --gcc_compile_options $(DISAS_INC) -cppversion 20

$(foreach target,$(UVM_TARGETS),$(eval $(call compile_uvm_template,$(target))))

$(eval $(call xelab_uvm_template,uvm_bfm,bfm_untimed_tb,bfm_hdl_th,,,))
$(eval $(call xelab_uvm_template,uvm_top,top_tb,top_th,,,))
$(eval $(call xelab_uvm_template,riscv_decoder,tb_riscv_decoder,,LD_PRELOAD=$(SOLIB_STDCXX),$(SVLIB_DEF)))

tb_top_level: $(BUILD_DIR)COMPILE_RTL
	xelab tb_top_level -relax -s $@ -a	
	mv axsim.sh $@

$(BUILD_DIR)COMPILE_RTL: $(RTL_FLIST) | $(BUILD_DIR)
	xvlog -sv -f $^ -L uvm
	touch $@


