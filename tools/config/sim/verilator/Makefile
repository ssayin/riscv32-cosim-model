# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: Apache-2.0

VERILATOR ?= /usr/bin/verilator
VERILATOR_DIR ?= $(TB_DIR)verilator/
VERILATOR_FLAGS ?= -Wno-fatal --cc --exe --trace --build -j -vpi -x-assign 0 -DDEBUG=1 -DINIT_FILE='"$(shell readlink -f $(INIT_FILE))"' -f $(RTL_DIR)flist.xsim --top-module fpga_top $(VERILATOR_DIR)fpga_top.cpp

all:
	$(VERILATOR) $(VERILATOR_FLAGS)
