// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : ../tb/uvm_top
//
// File Name: busf_pkg.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Wed Jul 26 23:05:54 2023
//=============================================================================
// Description: Package for agent busf
//=============================================================================

package busf_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;


  `include "busf_axi4_tx.sv"
  `include "busf_config.sv"
  `include "busf_driver.sv"
  `include "busf_monitor.sv"
  `include "busf_sequencer.sv"
  `include "busf_coverage.sv"
  `include "busf_agent.sv"
  `include "busf_seq_lib.sv"

endpackage : busf_pkg
