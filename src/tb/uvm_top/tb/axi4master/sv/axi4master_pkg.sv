// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : ../tb/uvm_top
//
// File Name: axi4master_pkg.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug  5 16:35:54 2023
//=============================================================================
// Description: Package for agent axi4master
//=============================================================================

package axi4master_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;


  `include "axi4master_axi4_tx.sv"
  `include "axi4master_config.sv"
  `include "axi4master_driver.sv"
  `include "axi4master_monitor.sv"
  `include "axi4master_sequencer.sv"
  `include "axi4master_coverage.sv"
  `include "axi4master_agent.sv"
  `include "axi4master_seq_lib.sv"

endpackage : axi4master_pkg
