// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4aw_pkg.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Jan 15 11:27:06 2024
//=============================================================================
// Description: Package for agent axi4aw
//=============================================================================

package axi4aw_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;


  `include "axi4aw_axi4aw_tx.sv"
  `include "axi4aw_config.sv"
  `include "axi4aw_driver.sv"
  `include "axi4aw_monitor.sv"
  `include "axi4aw_sequencer.sv"
  `include "axi4aw_coverage.sv"
  `include "axi4aw_agent.sv"
  `include "axi4aw_seq_lib.sv"

endpackage : axi4aw_pkg
