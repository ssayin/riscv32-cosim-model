# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: Apache-2.0

PROJECT_ROOT            := $(CURDIR)/
BUILD_DIR               := $(PROJECT_ROOT)build/
TOOLS_DIR               := $(PROJECT_ROOT)tools/
CONFIG_DIR              := $(TOOLS_DIR)config/
SRC_DIR                 := $(PROJECT_ROOT)src/
RTL_DIR                 := $(SRC_DIR)rtl/
TB_DIR                  := $(SRC_DIR)tb/
THIRD_PARTY             := $(PROJECT_ROOT)third_party/

CC                      := gcc
CXX                     := g++
CFLAGS                  := -O2
CXXFLAGS                := -std=gnu++20 $(CFLAGS)

QUARTUS_ROOT            ?= /opt/intelFPGA_lite/22.1std/quartus/
VIVADO_ROOT             ?= /opt/Xilinx/Vivado/2022.2/

VIVADO_INC              := $(VIVADO_ROOT)data/xsim/include/

SIM                     ?= xsim

RTL_FLIST_DIR           := $(RTL_DIR)
RISCV_DECODER_DIR       := $(TB_DIR)/riscv_decoder_uvm/

RTL_FLIST               := $(RTL_FLIST_DIR)flist.$(SIM)
RISCV_DECODER_FLIST     := $(RISCV_DECODER_DIR)flist.$(SIM)
UVM_BFM_FLIST           := $(BFM_CONFIG_ROOT)flist.$(SIM)
UVM_TOP_FLIST           := $(TOP_CONFIG_ROOT)flist.$(SIM)

UVM_TARGETS             := RISCV_DECODER UVM_TOP UVM_BFM
SIM_TARGETS             := uvm_top uvm_bfm riscv_decoder

UVM_GENERATOR           := $(THIRD_PARTY)easier_uvm_gen.pl

GEN_DIR                 := $(patsubst $(abspath %),%,$(CONFIG_DIR)/uvm/)
TPL_DIR                 := $(GEN_DIR)tpl/

TB_DIR                  := $(PROJECT_ROOT)src/tb/
UVM_BFM_DIR             := $(TB_DIR)uvm_bfm/
UVM_TOP_DIR             := $(TB_DIR)uvm_top/

BFM_CONFIG_ROOT         := $(TPL_DIR)bfm/
TOP_CONFIG_ROOT         := $(TPL_DIR)top/

UVM_BFM_FLIST           := $(BFM_CONFIG_ROOT)flist.xsim
UVM_TOP_FLIST           := $(TOP_CONFIG_ROOT)flist.xsim

DATA_DIR                := $(PROJECT_ROOT)data/
DATA_EXTRACT_DIR        := $(BUILD_DIR)data/

ifeq ($(SIM),)
all:
	@echo "Simulator is not specified. Cannot proceed."
	@echo "Specify the simulator as follows:"
	@echo "make SIM=<sim>"
else ifeq ($(SIM),xsim)
	include $(CONFIG_DIR)sim/$(SIM).mk
else
endif

include $(CONFIG_DIR)uart_client.mk

.PHONY: clean cleaner

clean:
	${RM} $(UART_CLIENT)
	${RM} $(SVDPI)
	${RM} $(JSON_TEST)
	${RM} $(UVM_TARGETS) 
	${RM} $(SIM_TARGETS) 
	${RM} -r $(BUILD_DIR) 
	${RM} *.jou *.log *.pb
	${RM} -r ./xsim.dir ./xsim.covdb ./out ./db/ ./incremental_db/ greybox_tmp/
	${RM} *.rpt *.summary *.qpf *.qsf *.bak *.txt *.done
	${RM} *.jdi *.pin *.sld *.sof *.smsg *.qws *.wdb

cleaner: clean
	${RM} -r $(UVM_BFM_DIR)
	${RM} -r $(UVM_TOP_DIR)
