
file delete -force work

vlib work

#compile the dut code
set cmd "vlog -F ../dut/files.f"
eval $cmd

set tb_name top
set agent_list {\ 
    axi4master \
}
foreach  ele $agent_list {
  if {$ele != " "} {
    set cmd  "vlog -sv +incdir+../tb/include +incdir+../tb/"
    append cmd $ele "/sv ../tb/" $ele "/sv/" $ele "_pkg.sv ../tb/" $ele "/sv/" $ele "_if.sv"
    append cmd " ../tb/" $ele "/sv/" $ele "_bfm.sv"
    eval $cmd
  }
}

set cmd  "vlog -sv +incdir+../../../../third_party/syoscb-1.0.2.4/src ../../../../third_party/syoscb-1.0.2.4/src/pk_syoscb.sv"
eval $cmd

set cmd  "vlog -sv +incdir+../tb/include +incdir+../tb/"
append cmd $tb_name "/sv ../tb/" $tb_name "/sv/" $tb_name "_pkg.sv"
eval $cmd

set cmd  "vlog -sv +incdir+../tb/include +incdir+../tb/"
append cmd $tb_name "_test/sv ../tb/" $tb_name "_test/sv/" $tb_name "_test_pkg.sv"
eval $cmd

set cmd  "vlog -sv -timescale 1ns/1ps +incdir+../tb/include +incdir+../tb/"
append cmd $tb_name "_tb/sv ../tb/" $tb_name "_tb/sv/" $tb_name "_th.sv"
eval $cmd

set cmd  "vlog -sv -timescale 1ns/1ps +incdir+../tb/include +incdir+../tb/"
append cmd $tb_name "_tb/sv ../tb/" $tb_name "_tb/sv/" $tb_name "_tb.sv"
eval $cmd

vsim top_untimed_tb top_hdl_th +UVM_TESTNAME=top_test  -voptargs=+acc -solvefaildebug -uvmcontrol=all -classdebug
run 0
#do wave.do
