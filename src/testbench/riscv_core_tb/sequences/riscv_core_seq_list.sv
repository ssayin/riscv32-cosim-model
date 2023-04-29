`ifndef RISCV_CORE_SEQ_LIST
`define RISCV_CORE_SEQ_LIST

package riscv_core_seq_list;

  import uvm_pkg::*;

  `include "uvm_macros.svh"

  import riscv_core_agent_pkg::*;
  import riscv_core_ref_model_pkg::*;
  import riscv_core_env_pkg::*;

  `include "riscv_core_basic_seq.sv"
  `include "riscv_core_instr_seq_from_file.sv"

endpackage : riscv_core_seq_list

`endif
