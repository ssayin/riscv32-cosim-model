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
// Code created by Easier UVM Code Generator version 2017-01-19 on Fri Aug 11 09:33:51 2023
//=============================================================================
// Description: Package for bfm
//=============================================================================

package bfm_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  import axi4_pkg::*;

  `include "bfm_config.sv"
  `include "bfm_seq_lib.sv"
  `include "bfm_env.sv"

endpackage : bfm_pkg

