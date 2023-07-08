// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Project  : generated_tb
//
// File Name: riscv_core_pkg.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sun Jul  9 00:13:28 2023
//=============================================================================
// Description: Package for agent riscv_core
//=============================================================================

package riscv_core_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;


  `include "riscv_core_riscv_core_tx.sv"
  `include "riscv_core_config.sv"
  `include "riscv_core_driver.sv"
  `include "riscv_core_monitor.sv"
  `include "riscv_core_sequencer.sv"
  `include "riscv_core_coverage.sv"
  `include "riscv_core_agent.sv"
  `include "riscv_core_seq_lib.sv"

endpackage : riscv_core_pkg
