# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: Apache-2.0

$(VISIBLE_TEST): $(BIN_DIR)$(VISIBLE_TEST)

$(SVDPI): $(OBJS)
	$(CXX) $(CXXFLAGS) -shared -Wl,-soname,$@ -o $@ $^

$(BUILD_DIR)%.o: $(DECODER_SRC)%.cpp | $(BUILD_DIR)
	$(CXX) -fPIC $(CXXFLAGS) $(INC) -I. -c $< -o $@

$(BUILD_DIR)%.o: $(EXPORTER_SRC)%.cpp | $(BUILD_DIR)
	$(CXX) -fPIC $(CXXFLAGS) $(INC) -I. -c $< -o $@

$(DISAS_OBJS): $(DISAS_SRCS) | $(BUILD_DIR)
	$(CXX) -fPIC $(CXXFLAGS) $(INC) -I. -c $< -o $@

$(BIN_DIR)$(VISIBLE_TEST): $(VISIBLE_OBJS) $(VISIBLE_TEST_OBJS) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $(INC) $^ -o $@

$(BUILD_DIR)%.o: $(VISIBLE_TEST_SRC)%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $(INC) -c $< -o $@

$(BUILD_DIR)%.o: $(VISIBLE_SRC)%.cpp | $(BUILD_DIR)
	$(CXX) -fPIC $(CXXFLAGS) $(INC) -c $< -o $@
