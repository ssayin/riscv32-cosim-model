// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4r_pkg.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 20:27:19 2023
//=============================================================================
// Description: Package for agent axi4r
//=============================================================================

package axi4r_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;


  `include "axi4r_axi4r_tx.sv"
  `include "axi4r_config.sv"
  `include "axi4r_driver.sv"
  `include "axi4r_monitor.sv"
  `include "axi4r_sequencer.sv"
  `include "axi4r_coverage.sv"
  `include "axi4r_agent.sv"
  `include "axi4r_seq_lib.sv"

endpackage : axi4r_pkg
