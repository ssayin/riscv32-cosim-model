# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: Apache-2.0

pinst: $(BIN_DIR)pinst

$(BIN_DIR)pinst: $(SRC_DIR)pinst/pinst.cpp | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $^ -o $@
	./bin/pinst 64 16
