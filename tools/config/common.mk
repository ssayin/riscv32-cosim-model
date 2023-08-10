# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: MIT

DATA_DIR              := $(PROJECT_ROOT)data/
DATA_EXTRACT_DIR      := $(BUILD_DIR)data/
INSTR_FEED            := $(DATA_EXTRACT_DIR)amalgamated.txt

RTL_FLIST_DIR         := $(RTL_DIR)
TB_FLIST_DIR          := $(TB_DIR)
UVM_BFM_FLIST_DIR     := $(TOOLS_DIR)gen/axi4bfm/
UVM_TOP_FLIST_DIR     := $(TOOLS_DIR)gen/riscv_core/

$(INSTR_FEED): $(DATA_EXTRACT_DIR)
	7z e $(DATA_DIR)*.zip -ir!*.json -so | jq -r '.[].instr' | sort | uniq > $@

$(BUILD_DIR) $(DATA_DIR) $(DATA_EXTRACT_DIR):
	mkdir -p $@
