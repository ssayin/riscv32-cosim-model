`ifndef RISCV_CORE_TEST_LIST
`define RISCV_CORE_TEST_LIST

package riscv_core_test_list;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import riscv_core_env_pkg::*;
  import riscv_core_seq_list::*;

  `include "riscv_core_basic_test.sv"
  `include "riscv_core_from_file_test.sv"

endpackage : riscv_core_test_list

`endif



