# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: Apache-2.0

DATA_DIR              := $(PROJECT_ROOT)data/
DATA_EXTRACT_DIR      := $(BUILD_DIR)data/
INSTR_FEED            := $(DATA_EXTRACT_DIR)amalgamated.txt

$(INSTR_FEED): $(DATA_EXTRACT_DIR)
	7z e $(DATA_DIR)*.zip -ir!*.json -so | jq -r '.[].instr' | sort | uniq > $@

FULL_EXTRACT: $(DATA_EXTRACT_DIR)
	7z e $(DATA_DIR)*.zip -o$(DATA_EXTRACT_DIR)

$(BUILD_DIR) $(DATA_DIR) $(DATA_EXTRACT_DIR):
	mkdir -p $@
