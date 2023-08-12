#!/bin/sh
vcs -sverilog +acc +vpi -timescale=1ns/1ps -ntb_opts uvm-1.2 \
+incdir+../tb/include \
+incdir+../tb/axi4ar/sv \
+incdir+../tb/axi4aw/sv \
+incdir+../tb/axi4b/sv \
+incdir+../tb/axi4r/sv \
+incdir+../tb/axi4w/sv \
+incdir+../tb/bfm/sv \
+incdir+../tb/bfm_test/sv \
+incdir+../tb/bfm_tb/sv \
-F ../dut/files.f \
../tb/axi4ar/sv/axi4ar_pkg.sv \
../tb/axi4ar/sv/axi4ar_if.sv \
../tb/axi4aw/sv/axi4aw_pkg.sv \
../tb/axi4aw/sv/axi4aw_if.sv \
../tb/axi4b/sv/axi4b_pkg.sv \
../tb/axi4b/sv/axi4b_if.sv \
../tb/axi4r/sv/axi4r_pkg.sv \
../tb/axi4r/sv/axi4r_if.sv \
../tb/axi4w/sv/axi4w_pkg.sv \
../tb/axi4w/sv/axi4w_if.sv \
../tb/axi4ar/sv/axi4ar_bfm.sv \
../tb/axi4aw/sv/axi4aw_bfm.sv \
../tb/axi4b/sv/axi4b_bfm.sv \
../tb/axi4r/sv/axi4r_bfm.sv \
../tb/axi4w/sv/axi4w_bfm.sv \
../tb/bfm/sv/bfm_pkg.sv \
../tb/bfm_test/sv/bfm_test_pkg.sv \
../tb/bfm_tb/sv/bfm_th.sv \
../tb/bfm_tb/sv/bfm_tb.sv \
-R +UVM_TESTNAME=bfm_test  $* 
