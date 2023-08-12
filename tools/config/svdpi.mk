# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: Apache-2.0

DECODER_ROOT  := $(SRC_DIR)decoder/
DISAS_ROOT    := $(THIRD_PARTY)riscv-disas/
DPI_ROOT      := $(SRC_DIR)svdpi/

DECODER_SRC   := $(DECODER_ROOT)src/
EXPORTER_SRC  := $(DPI_ROOT)
DISAS_SRC     := $(DISAS_ROOT)
VISIBLE_SRC   := $(DPI_ROOT)visible/
TEST_SRC      := $(DPI_ROOT)test/

DECODER_INC   := -I$(DECODER_ROOT)include/
COMMON_INC    := -I$(DECODER_ROOT)include/
DISAS_INC     := -I$(DISAS_ROOT)
EXPORTER_INC  := -I$(EXPORTER_SRC)include/
RAPIDJSON_INC := -I$(THIRD_PARTY)rapidjson/

INC           := $(DECODER_INC) $(COMMON_INC) $(DISAS_INC) \
								 $(EXPORTER_INC) $(RAPIDJSON_INC) \
								 -I$(DPI_ROOT)include -I$(DPI_ROOT)visible

DECODER_SRCS  := $(wildcard $(DECODER_SRC)*.cpp)
EXPORTER_SRCS := $(wildcard $(EXPORTER_SRC)*.cpp)
DISAS_SRCS    := $(wildcard $(DISAS_SRC)*.c)
VISIBLE_SRCS  := $(wildcard $(VISIBLE_SRC)*.cpp)
TEST_SRCS     := $(wildcard $(TEST_SRC)*.cpp)

DECODER_OBJS  := $(patsubst $(DECODER_SRC)%.cpp,$(BUILD_DIR)%.o,$(DECODER_SRCS))
EXPORTER_OBJS := $(patsubst $(EXPORTER_SRC)%.cpp,$(BUILD_DIR)%.o,$(EXPORTER_SRCS))
VISIBLE_OBJS  := $(patsubst $(VISIBLE_SRC)%.cpp,$(BUILD_DIR)%.o, $(VISIBLE_SRCS))
DISAS_OBJ     := $(patsubst $(DISAS_SRC)%.c,$(BUILD_DIR)%.o,$(DISAS_SRCS))
TEST_OBJ      := $(patsubst $(TEST_SRC)%.cpp,$(BUILD_DIR)%.o,$(TEST_SRCS))

OBJS          := $(DECODER_OBJS) $(EXPORTER_OBJS) $(DISAS_OBJ)

SVDPI         := libdpi.so

JSON_TEST     := json_test


$(SVDPI): $(OBJS)
	$(CXX) $(CXXFLAGS) -shared -Wl,-soname,$@ -o $@ $^

$(BUILD_DIR)%.o: $(DECODER_SRC)%.cpp | $(BUILD_DIR)
	$(CXX) -fPIC $(CXXFLAGS) $(INC) -I. -c $< -o $@

$(BUILD_DIR)%.o: $(EXPORTER_SRC)%.cpp | $(BUILD_DIR)
	$(CXX) -fPIC $(CXXFLAGS) $(INC) -I. -c $< -o $@

$(DISAS_OBJ): $(DISAS_SRCS) | $(BUILD_DIR)
	$(CXX) -fPIC $(CXXFLAGS) $(INC) -I. -c $< -o $@

$(JSON_TEST): $(VISIBLE_OBJS) $(TEST_OBJ)
	$(CXX) $(CXXFLAGS) $(INC) - $^ -o $@

$(BUILD_DIR)%.o: $(TEST_SRC)%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $(INC) -c $< -o $@

$(BUILD_DIR)%.o: $(VISIBLE_SRC)%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $(INC) -c $< -o $@
