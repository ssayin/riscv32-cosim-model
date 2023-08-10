#!/bin/sh
IUS_HOME=`ncroot`
irun -vtimescale 1ns/1ps -uvmhome ${IUS_HOME}/tools/methodology/UVM/CDNS-1.2 \
+incdir+../tb/include \
+incdir+../tb/axi4/sv \
+incdir+../../third_party/syoscb-1.0.2.4/src\
+incdir+../tb/bfm/sv \
+incdir+../tb/bfm_test/sv \
+incdir+../tb/bfm_tb/sv \
-F ../dut/files.f \
../tb/axi4/sv/axi4_pkg.sv \
../tb/axi4/sv/axi4_if.sv \
../tb/axi4/sv/axi4_bfm.sv \
../../third_party/syoscb-1.0.2.4/src/pk_syoscb.sv \
../tb/bfm/sv/bfm_pkg.sv \
../tb/bfm_test/sv/bfm_test_pkg.sv \
../tb/bfm_tb/sv/bfm_th.sv \
../tb/bfm_tb/sv/bfm_tb.sv \
+UVM_TESTNAME=bfm_test  $* 
