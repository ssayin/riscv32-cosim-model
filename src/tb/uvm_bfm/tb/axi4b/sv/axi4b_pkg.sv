// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4b_pkg.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 18:56:08 2023
//=============================================================================
// Description: Package for agent axi4b
//=============================================================================

package axi4b_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;


  `include "axi4b_axi4b_tx.sv"
  `include "axi4b_config.sv"
  `include "axi4b_driver.sv"
  `include "axi4b_monitor.sv"
  `include "axi4b_sequencer.sv"
  `include "axi4b_coverage.sv"
  `include "axi4b_agent.sv"
  `include "axi4b_seq_lib.sv"

endpackage : axi4b_pkg
