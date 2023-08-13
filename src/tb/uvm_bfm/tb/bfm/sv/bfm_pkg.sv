// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: bfm_pkg.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 01:57:09 2023
//=============================================================================
// Description: Package for bfm
//=============================================================================

package bfm_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  import axi4ar_pkg::*;
  import axi4aw_pkg::*;
  import axi4b_pkg::*;
  import axi4r_pkg::*;
  import axi4w_pkg::*;

  `include "bfm_config.sv"
  `include "bfm_seq_lib.sv"
  `include "bfm_env.sv"

endpackage : bfm_pkg

