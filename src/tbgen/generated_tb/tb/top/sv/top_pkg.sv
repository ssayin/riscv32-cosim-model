// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Project  : generated_tb
//
// File Name: top_pkg.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Thu Jul  6 15:14:09 2023
//=============================================================================
// Description: Package for top
//=============================================================================

package top_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  import riscv_core_pkg::*;

  `include "top_config.sv"
  `include "top_seq_lib.sv"
  `include "top_env.sv"

endpackage : top_pkg

