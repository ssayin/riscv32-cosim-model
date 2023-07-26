// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : ../tb/uvm_top
//
// File Name: busm_pkg.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Wed Jul 26 23:05:54 2023
//=============================================================================
// Description: Package for agent busm
//=============================================================================

package busm_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;


  `include "busm_axi4_tx.sv"
  `include "busm_config.sv"
  `include "busm_driver.sv"
  `include "busm_monitor.sv"
  `include "busm_sequencer.sv"
  `include "busm_coverage.sv"
  `include "busm_agent.sv"
  `include "busm_seq_lib.sv"

endpackage : busm_pkg
