# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: Apache-2.0

CC                      := gcc
CXX                     := g++
CFLAGS                  := -O2
CXXFLAGS                := -std=gnu++20 $(CFLAGS)

PROJECT_ROOT            := $(CURDIR)/
BUILD_DIR               := $(PROJECT_ROOT)build/
TOOLS_DIR               := $(PROJECT_ROOT)tools/
CONFIG_DIR              := $(TOOLS_DIR)config/
SRC_DIR                 := $(PROJECT_ROOT)src/
FIRMWARE_DIR            := $(SRC_DIR)firmware/
RTL_DIR                 := $(SRC_DIR)rtl/
TB_DIR                  := $(SRC_DIR)tb/
DATA_DIR                := $(PROJECT_ROOT)data/
DATA_EXTRACT_DIR        := $(BUILD_DIR)data/
BIN_DIR                 := $(PROJECT_ROOT)bin/

SCRIPT_DIR              := $(PROJECT_ROOT)scripts/

THIRD_PARTY             := $(PROJECT_ROOT)third_party/

GEN_DIR                 := $(patsubst $(abspath %),%,$(CONFIG_DIR)/uvm/)
TPL_DIR                 := $(GEN_DIR)tpl/
UVM_BFM_DIR             := $(TB_DIR)uvm_bfm/
UVM_TOP_DIR             := $(TB_DIR)uvm_top/

BFM_CONFIG_ROOT         := $(TPL_DIR)bfm/
TOP_CONFIG_ROOT         := $(TPL_DIR)top/
RTL_FLIST_DIR           := $(RTL_DIR)
RISCV_DECODER_DIR       := $(TB_DIR)/riscv_decoder_uvm/

QUARTUS_ROOT            ?= /opt/intelFPGA_lite/22.1std/quartus/
VIVADO_ROOT             ?= /opt/Xilinx/Vivado/2022.2/

VIVADO_INC              := $(VIVADO_ROOT)data/xsim/include/

SIM                     ?= xsim

UVM_GENERATOR           := $(THIRD_PARTY)easier_uvm_gen.pl

UVM_BFM_FLIST           := $(BFM_CONFIG_ROOT)flist.$(SIM)
UVM_TOP_FLIST           := $(TOP_CONFIG_ROOT)flist.$(SIM)
RTL_FLIST               := $(RTL_FLIST_DIR)flist.$(SIM)
RISCV_DECODER_FLIST     := $(RISCV_DECODER_DIR)flist.$(SIM)

UVM_TARGETS             := RISCV_DECODER UVM_TOP UVM_BFM
SIM_TARGETS             := $(SCRIPT_DIR)uvm_top $(SCRIPT_DIR)uvm_bfm $(SCRIPT_DIR)riscv_decoder $(SCRIPT_DIR)top

DECODER_ROOT            := $(PROJECT_ROOT)decoder/
DISAS_ROOT              := $(THIRD_PARTY)riscv-disas/
DPI_ROOT                := $(SRC_DIR)svdpi/

DECODER_SRC             := $(DECODER_ROOT)src/
EXPORTER_SRC            := $(DPI_ROOT)
DISAS_SRC               := $(DISAS_ROOT)
VISIBLE_SRC             := $(DPI_ROOT)visible/
VISIBLE_TEST_SRC        := $(DPI_ROOT)visible_test/

DECODER_INC             := -I$(DECODER_ROOT)include/
COMMON_INC              := -I$(DECODER_ROOT)include/
DISAS_INC               := -I$(DISAS_ROOT)
EXPORTER_INC            := -I$(EXPORTER_SRC)include/
RAPIDJSON_INC           := -I$(THIRD_PARTY)rapidjson/

INC                     := $(DECODER_INC) $(COMMON_INC) $(DISAS_INC) \
													 $(EXPORTER_INC) $(RAPIDJSON_INC) -I$(DPI_ROOT) \
													 -I$(DPI_ROOT)include -I$(VISIBLE_SRC)

DECODER_SRCS            := $(wildcard $(DECODER_SRC)*.cpp)
EXPORTER_SRCS           := $(wildcard $(EXPORTER_SRC)*.cpp)
DISAS_SRCS              := $(wildcard $(DISAS_SRC)*.c)
VISIBLE_SRCS            := $(wildcard $(VISIBLE_SRC)*.cpp)
VISIBLE_TEST_SRCS       := $(wildcard $(VISIBLE_TEST_SRC)*.cpp)

DECODER_OBJS            := $(patsubst $(DECODER_SRC)%.cpp,$(BUILD_DIR)%.o,$(DECODER_SRCS))
EXPORTER_OBJS           := $(patsubst $(EXPORTER_SRC)%.cpp,$(BUILD_DIR)%.o,$(EXPORTER_SRCS))
VISIBLE_OBJS            := $(patsubst $(VISIBLE_SRC)%.cpp,$(BUILD_DIR)%.o, $(VISIBLE_SRCS))
DISAS_OBJS              := $(patsubst $(DISAS_SRC)%.c,$(BUILD_DIR)%.o,$(DISAS_SRCS))
VISIBLE_TEST_OBJS       := $(patsubst $(VISIBLE_TEST_SRC)%.cpp,$(BUILD_DIR)%.o,$(VISIBLE_TEST_SRCS))

OBJS                    := $(DECODER_OBJS) $(EXPORTER_OBJS) $(DISAS_OBJS) $(VISIBLE_OBJS)

SVDPI                   := libdpi.so

VISIBLE_TEST            := visible_test

DUMPVCD                 ?= 1
INIT_FILE               ?= "./src/firmware/boot.hex"
UVM_VERBOSITY           ?= UVM_LOW

EXTRAPARAMS             = -define DEBUG=1
SOLIB_STDCXX            = $(shell /sbin/ldconfig -p | perl -ne 'if (/stdc\+\+/) { @columns = split; print $$columns[3]; exit }')

ifeq ($(SIM),)
all:
	@echo "Simulator is not specified. Cannot proceed."
	@echo "Specify the simulator as follows:"
	@echo "make SIM=<sim>"
else ifeq ($(SIM),xsim)
	include $(CONFIG_DIR)sim/$(SIM)/Makefile
else ifeq ($(SIM),verilator)
	include $(CONFIG_DIR)sim/$(SIM)/Makefile
else
endif

ifeq ($(DUMPVCD), 1)
	EXTRAPARAMS = -define DUMPVCD=1
endif

ifneq ($(INIT_FILE),)
	EXTRAPARAMS += -define INIT_FILE='"$(shell readlink -f $(INIT_FILE))"'
endif

include $(SRC_DIR)uart/Makefile
include $(TB_DIR)formal/Makefile
include $(SRC_DIR)firmware/Makefile
include $(PROJECT_ROOT)data/Makefile
include $(PROJECT_ROOT)src/svdpi/Makefile
include $(CONFIG_DIR)uvm/Makefile
include $(SRC_DIR)pinst/Makefile

util: $(UART_CLIENT) $(VISIBLE_TEST)

$(BIN_DIR) $(SCRIPT_DIR):
	mkdir -p $@

.PHONY: clean cleaner

clean:
	${RM} $(UART_CLIENT)
	${RM} $(SVDPI)
	${RM} $(VISIBLE_TEST)
	${RM} $(UVM_TARGETS) 
	${RM} $(SIM_TARGETS) 
	${RM} -r $(BUILD_DIR) 
	${RM} -r $(BIN_DIR)
	${RM} *.jou *.log *.pb
	${RM} -r ./xsim.dir ./xsim.covdb ./out ./db/ ./incremental_db/ greybox_tmp/
	${RM} *.rpt *.summary *.qpf *.qsf *.bak *.txt *.done
	${RM} *.jdi *.pin *.sld *.sof *.smsg *.qws *.wdb
	${RM} -r ./slpp_all/
	${RM} $(FIRMWARE_DIR)boot.{elf,map}
	${RM} -r ${SCRIPT_DIR}
	${RM} -r ./obj_dir/

cleaner: clean
	${RM} -r $(UVM_BFM_DIR)
	${RM} -r $(UVM_TOP_DIR)
