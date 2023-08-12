// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_top
//
// File Name: _pkg.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 02:59:40 2023
//=============================================================================
// Description: Package for agent 
//=============================================================================

package _pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;


  `include "_.sv"
  `include "_config.sv"
  `include "_driver.sv"
  `include "_monitor.sv"
  `include "_sequencer.sv"
  `include "_coverage.sv"
  `include "_agent.sv"
  `include "_seq_lib.sv"

endpackage : _pkg
