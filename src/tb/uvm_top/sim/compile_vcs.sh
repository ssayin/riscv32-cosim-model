#!/bin/sh
vcs -sverilog +acc +vpi -timescale=1ns/1ps -ntb_opts uvm-1.2 \
+incdir+../tb/include \
+incdir+../tb/axi4master/sv \
+incdir+../../../../third_party/syoscb-1.0.2.4/src\
+incdir+../tb/top/sv \
+incdir+../tb/top_test/sv \
+incdir+../tb/top_tb/sv \
-F ../dut/files.f \
../tb/axi4master/sv/axi4master_pkg.sv \
../tb/axi4master/sv/axi4master_if.sv \
../tb/axi4master/sv/axi4master_bfm.sv \
../../../../third_party/syoscb-1.0.2.4/src/pk_syoscb.sv \
../tb/top/sv/top_pkg.sv \
../tb/top_test/sv/top_test_pkg.sv \
../tb/top_tb/sv/top_th.sv \
../tb/top_tb/sv/top_tb.sv \
-R +UVM_TESTNAME=top_test  $* 
