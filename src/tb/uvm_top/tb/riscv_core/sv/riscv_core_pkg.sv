// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_top
//
// File Name: riscv_core_pkg.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 12:32:06 2023
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
