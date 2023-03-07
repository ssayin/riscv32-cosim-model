#VIVADO_INC := /opt/Xilinx/Vivado/2022.2/data/xsim/include/

all: libdpi.so
	#ln -sf libdpi.so xsim.dir/work.test/libdpi.so
	#LD_LIBRARY_PATH=. xelab -svlog test.sv -sv_lib libdpi -R

	#xsc  -compile decoder.c -work work 
	#xsc -shared xsim.dir/work/xsc/decoder.lnx64.o -work work 

	#xsc decoder.cpp
	LD_LIBRARY_PATH=. xelab -svlog test.sv -sv_lib libdpi -R

decoder.o:
	g++ -c -fPIC decoder.cpp -I. #-I${VIVADO_INC}

libdpi.so: decoder.o
	g++ -shared -Wl,-soname,libdpi.so -o libdpi.so decoder.o


.PHONY clean:
	${RM} libdpi.so
	${RM} decoder.o
