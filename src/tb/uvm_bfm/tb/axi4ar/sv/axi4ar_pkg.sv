// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4ar_pkg.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 01:57:09 2023
//=============================================================================
// Description: Package for agent axi4ar
//=============================================================================

package axi4ar_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;


  `include "axi4ar_axi4ar_tx.sv"
  `include "axi4ar_config.sv"
  `include "axi4ar_driver.sv"
  `include "axi4ar_monitor.sv"
  `include "axi4ar_sequencer.sv"
  `include "axi4ar_coverage.sv"
  `include "axi4ar_agent.sv"
  `include "axi4ar_seq_lib.sv"

endpackage : axi4ar_pkg
