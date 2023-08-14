// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4w_pkg.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 18:56:08 2023
//=============================================================================
// Description: Package for agent axi4w
//=============================================================================

package axi4w_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;


  `include "axi4w_axi4w_tx.sv"
  `include "axi4w_config.sv"
  `include "axi4w_driver.sv"
  `include "axi4w_monitor.sv"
  `include "axi4w_sequencer.sv"
  `include "axi4w_coverage.sv"
  `include "axi4w_agent.sv"
  `include "axi4w_seq_lib.sv"

endpackage : axi4w_pkg
