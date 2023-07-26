#!/bin/sh
vcs -sverilog +acc +vpi -timescale=1ns/1ps -ntb_opts uvm-1.2 \
+incdir+../tb/include \
+incdir+../tb/busf/sv \
+incdir+../tb/busm/sv \
+incdir+../../../../third_party/syoscb-1.0.2.4/src\
+incdir+../tb/top/sv \
+incdir+../tb/top_test/sv \
+incdir+../tb/top_tb/sv \
-F ../dut/files.f \
../tb/busf/sv/busf_pkg.sv \
../tb/busf/sv/busf_if.sv \
../tb/busm/sv/busm_pkg.sv \
../tb/busm/sv/busm_if.sv \
../tb/busf/sv/busf_bfm.sv \
../tb/busm/sv/busm_bfm.sv \
../../../../third_party/syoscb-1.0.2.4/src/pk_syoscb.sv \
../tb/top/sv/top_pkg.sv \
../tb/top_test/sv/top_test_pkg.sv \
../tb/top_tb/sv/top_th.sv \
../tb/top_tb/sv/top_tb.sv \
-R +UVM_TESTNAME=top_test  $* 
