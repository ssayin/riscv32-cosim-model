#VIVADO_INC := /opt/Xilinx/Vivado/2022.2/data/xsim/include/
BUILD_DIR     := ./build/

DECODER_SRC   := src/decoder/decoder/src/
DECODER_INC   := -Isrc/decoder/decoder/include/
COMMON_INC    := -Isrc/common/include/

EXPORTER_SRC  := ./src/exporter/

DESIGN_DIR    := ./design/

CXX           := g++
CXX_FLAGS     := -std=c++20 -O2

LIB           := libdpi.so
SV_TOP        := $(DESIGN_DIR)test.sv

DECODER_SRCS  := $(wildcard $(DECODER_SRC)*.cpp)
EXPORTER_SRCS := $(wildcard $(EXPORTER_SRC)*.cpp)

DECODER_OBJS  := $(patsubst $(DECODER_SRC)%.cpp,$(BUILD_DIR)%.o,$(DECODER_SRCS))
EXPORTER_OBJS := $(patsubst $(EXPORTER_SRC)%.cpp,$(BUILD_DIR)%.o,$(EXPORTER_SRCS))

OBJS          := $(DECODER_OBJS) $(EXPORTER_OBJS)

all: $(LIB)
	LD_LIBRARY_PATH=. xelab -svlog $(SV_TOP) -sv_lib $(basename $(notdir $(LIB))) -R

$(LIB): $(OBJS)
	$(CXX) $(CXX_FLAGS) -shared -Wl,-soname,$@ -o $@ $^

$(BUILD_DIR)%.o: $(DECODER_SRC)%.cpp | $(BUILD_DIR)
	$(CXX) -fPIC $(CXX_FLAGS) $(COMMON_INC) $(DECODER_INC) -I. -c $< -o $@

$(BUILD_DIR)%.o: $(EXPORTER_SRC)%.cpp | $(BUILD_DIR)
	$(CXX) -fPIC $(CXX_FLAGS) $(COMMON_INC) $(DECODER_INC) -I. -c $< -o $@

$(BUILD_DIR):
	mkdir -p $@

.PHONY clean:
	${RM} -rf $(BUILD_DIR) 
	${RM} $(LIB)
	${RM} *.jou
	${RM} *.log
	${RM} *.pb
