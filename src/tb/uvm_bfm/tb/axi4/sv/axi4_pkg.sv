// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4_pkg.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 06:44:54 2023
//=============================================================================
// Description: Package for agent axi4
//=============================================================================

package axi4_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;


  `include "axi4_axi4_tx.sv"
  `include "axi4_config.sv"
  `include "axi4_driver.sv"
  `include "axi4_monitor.sv"
  `include "axi4_sequencer.sv"
  `include "axi4_coverage.sv"
  `include "axi4_agent.sv"
  `include "axi4_seq_lib.sv"

endpackage : axi4_pkg
