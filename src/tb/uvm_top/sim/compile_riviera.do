
file delete -force work

alib work

# Compile the dut code
#set cmd "alog -uvm -F ../dut/files.f"  # Previous version using UVM 1.1d
set cmd "alog +incdir+$aldec/vlib/uvm-1.2/src -l uvm_1_2 -err VCP5417 W9 -err VCP3003 W9 -err VCP2129 W9 -F ../dut/files.f"
eval $cmd

#set cmd "alog -uvm "  # Previous version using UVM 1.1d
set cmd "alog +incdir+$aldec/vlib/uvm-1.2/src -l uvm_1_2 -err VCP5417 W9 -err VCP3003 W9 -err VCP2129 W9 "

set tb_name top
append cmd " +incdir+../tb/include "

# Compile the agents
set agent_list {\ 
    riscv_core \
}
foreach  ele $agent_list {
  if {$ele != " "} {
    append cmd " +incdir+../tb/" $ele "/sv ../tb/" $ele "/sv/" $ele "_pkg.sv ../tb/" $ele "/sv/" $ele "_if.sv"
  }
}

# Compile the test and the modules
append cmd " +incdir+../tb/" $tb_name "/sv"
append cmd " ../tb/" $tb_name "/sv/" $tb_name "_pkg.sv"
append cmd " ../tb/" $tb_name "_test/sv/" $tb_name "_test_pkg.sv"
append cmd " ../tb/" $tb_name "_tb/sv/" $tb_name "_th.sv"
append cmd " ../tb/" $tb_name "_tb/sv/" $tb_name "_tb.sv"
eval $cmd

asim top_tb +UVM_TESTNAME=top_test  -voptargs=+acc -solvefaildebug -uvmcontrol=all -classdebug
run -all
quit
