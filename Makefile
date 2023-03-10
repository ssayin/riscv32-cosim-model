#VIVADO_INC := /opt/Xilinx/Vivado/2022.2/data/xsim/include/

DECODER_SRC := decoder/decoder/src
DECODER_INC := -Idecoder/decoder/include
COMMON_INC  := -Icommon/include

CXX := g++
CXX_FLAGS := -std=c++20 -O2

all: libdpi.so
	#ln -sf libdpi.so xsim.dir/work.test/libdpi.so
	#LD_LIBRARY_PATH=. xelab -svlog test.sv -sv_lib libdpi -R

	#xsc  -compile decoder.c -work work 
	#xsc -shared xsim.dir/work/xsc/decoder.lnx64.o -work work 

	#xsc decoder.cpp
	LD_LIBRARY_PATH=. xelab -svlog test.sv -sv_lib libdpi -R

#decoder.o:
#	g++ -c -fPIC decoder.cpp -I. #-I${VIVADO_INC}

decoder.o:
	${CXX} -fPIC ${CXX_FLAGS} ${COMMON_INC} ${DECODER_INC} -I. -c ${DECODER_SRC}/decoder.cpp  ${DECODER_SRC}/decoder16.cpp decodesv.cpp

libdpi.so: decoder.o
	${CXX} ${CXX_FLAGS} -shared -Wl,-soname,libdpi.so -o libdpi.so decoder.o decoder16.o decodesv.o


.PHONY clean:
	${RM} libdpi.so
	${RM} decoder.o
