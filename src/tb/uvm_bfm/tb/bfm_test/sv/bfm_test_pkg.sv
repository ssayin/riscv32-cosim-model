// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: bfm_test_pkg.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Fri Aug 11 07:29:11 2023
//=============================================================================
// Description: Test package for bfm
//=============================================================================

`ifndef BFM_TEST_PKG_SV
`define BFM_TEST_PKG_SV

package bfm_test_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  import axi4_pkg::*;
  import bfm_pkg::*;

  `include "bfm_test.sv"

endpackage : bfm_test_pkg

`endif // BFM_TEST_PKG_SV

