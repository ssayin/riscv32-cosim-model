# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: MIT

#VIVADO_INC := /opt/Xilinx/Vivado/2022.2/data/xsim/include/
CXX           := g++
CXX_FLAGS     := -std=c++20 -O2

BUILD_DIR     := ./build/
TOOLS_DIR     := ./tools/

DATA_DIR      := $(BUILD_DIR)/data
LIB           := libdpi.so
SV_TOP        := tb_dec_decode

DECODER_INC   := -Isrc/decoder/decoder/include/
COMMON_INC    := -Isrc/common/include/
DISAS_INC     := -Ithird_party/riscv-disas/

DECODER_SRC   := ./src/decoder/decoder/src/
EXPORTER_SRC  := ./src/dpi/
DISAS_SRC     := ./third_party/riscv-disas/

DECODER_SRCS  := $(wildcard $(DECODER_SRC)*.cpp)
EXPORTER_SRCS := $(wildcard $(EXPORTER_SRC)*.cpp)
DISAS_SRCS    := $(DISAS_SRC)/riscv-disas.c

DECODER_OBJS  := $(patsubst $(DECODER_SRC)%.cpp,$(BUILD_DIR)%.o,$(DECODER_SRCS))
EXPORTER_OBJS := $(patsubst $(EXPORTER_SRC)%.cpp,$(BUILD_DIR)%.o,$(EXPORTER_SRCS))
DISAS_OBJ     := $(BUILD_DIR)riscv-disas.o

OBJS          := $(DECODER_OBJS) $(EXPORTER_OBJS) $(DISAS_OBJ)

INSTR_FEED    := $(DATA_DIR)/amalgamated.txt

all: synth sim 

synth: $(TOOLS_DIR)run.tcl
	vivado -mode batch -source $(TOOLS_DIR)run.tcl

$(INSTR_FEED): $(DATA_DIR)
	7z e ./data/*.zip -ir!*.json -so | jq -r '.[].instr' | sort | uniq > $@

sim: $(LIB) compile 
		xelab $(SV_TOP) -relax -s top -sv_lib $(basename $(notdir $(LIB)))
		LD_LIBRARY_PATH=. xsim top -testplusarg UVM_TESTNAME=dec_decode_from_file_test -testplusarg UVM_VERBOSITY=UVM_LOW -R

sim2: compile 
	xelab tb_top_level -relax -s top2
	xsim top2 -R

compile: $(INSTR_FEED)
	xvlog -sv -f $(TOOLS_DIR)sv_compile_list.txt -L uvm \
		-define INSTR_SEQ_FILENAME='"$(INSTR_FEED)"' \
		-define INSTR_SEQ_LINECOUNT=$(shell cat $(INSTR_FEED) | wc -l) \
		-define DEBUG_INIT_FILE='"$(shell readlink -f "./src/firmware/boot.hex")"'

$(LIB): $(OBJS)
	$(CXX) $(CXX_FLAGS) -shared -Wl,-soname,$@ -o $@ $^

$(BUILD_DIR)%.o: $(DECODER_SRC)%.cpp | $(BUILD_DIR)
	$(CXX) -fPIC $(CXX_FLAGS) $(COMMON_INC) $(DECODER_INC) -I. -c $< -o $@

$(BUILD_DIR)%.o: $(EXPORTER_SRC)%.cpp | $(BUILD_DIR)
	$(CXX) -fPIC $(CXX_FLAGS) $(COMMON_INC) $(DECODER_INC) $(DISAS_INC) -I. -I$(EXPORTER_SRC)/include -c $< -o $@

$(DISAS_OBJ): $(DISAS_SRCS) | $(BUILD_DIR)
	$(CXX) -fPIC $(CXX_FLAGS) $(DISAS_INC) -I. -c $< -o $@

$(BUILD_DIR) $(DATA_DIR):
	mkdir -p $@

.PHONY clean:
	${RM} -rf $(BUILD_DIR) 
	${RM} $(LIB)
	${RM} *.jou
	${RM} *.log
	${RM} *.pb
	${RM} -rf ./xsim.dir
	${RM} -rf ./xsim.covdb
	${RM} -rf ./out
