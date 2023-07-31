# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: MIT

CXX           := g++
CXX_FLAGS     := -std=c++20 -O2

DECODER_ROOT  := $(PROJECT_ROOT)src/decoder/
DISAS_ROOT    := $(PROJECT_ROOT)third_party/riscv-disas/
DPI_ROOT      := $(PROJECT_ROOT)src/dpi/

DECODER_SRC   := $(DECODER_ROOT)src/
EXPORTER_SRC  := $(DPI_ROOT)
DISAS_SRC     := $(DISAS_ROOT)

DECODER_INC   := -I$(DECODER_ROOT)include/
COMMON_INC    := -I$(DECODER_ROOT)include/
DISAS_INC     := -I$(DISAS_ROOT)
EXPORTER_INC  := -I$(EXPORTER_SRC)include/

DECODER_SRCS  := $(wildcard $(DECODER_SRC)*.cpp)
EXPORTER_SRCS := $(wildcard $(EXPORTER_SRC)*.cpp)
DISAS_SRCS    := $(wildcard $(DISAS_SRC)*.c)

DECODER_OBJS  := $(patsubst $(DECODER_SRC)%.cpp,$(BUILD_DIR)%.o,$(DECODER_SRCS))
EXPORTER_OBJS := $(patsubst $(EXPORTER_SRC)%.cpp,$(BUILD_DIR)%.o,$(EXPORTER_SRCS))
DISAS_OBJ     := $(patsubst $(DISAS_SRC)%.cpp,$(BUILD_DIR)%.o,$(DISAS_SRCS))

OBJS          := $(DECODER_OBJS) $(EXPORTER_OBJS) $(DISAS_OBJ)

LIB           := libdpi.so

$(LIB): $(OBJS)
	$(CXX) $(CXX_FLAGS) -shared -Wl,-soname,$@ -o $@ $^

$(BUILD_DIR)%.o: $(DECODER_SRC)%.cpp | $(BUILD_DIR)
	$(CXX) -fPIC $(CXX_FLAGS) $(COMMON_INC) $(DECODER_INC) -I. -c $< -o $@

$(BUILD_DIR)%.o: $(EXPORTER_SRC)%.cpp | $(BUILD_DIR)
	$(CXX) -fPIC $(CXX_FLAGS) $(COMMON_INC) $(DECODER_INC) $(DISAS_INC) $(EXPORTER_INC) -I. -c $< -o $@

$(DISAS_OBJ): $(DISAS_SRCS) | $(BUILD_DIR)
	$(CXX) -fPIC $(CXX_FLAGS) $(DISAS_INC) -I. -c $< -o $@
