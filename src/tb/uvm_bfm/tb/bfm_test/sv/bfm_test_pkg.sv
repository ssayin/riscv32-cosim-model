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
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 20:27:19 2023
//=============================================================================
// Description: Test package for bfm
//=============================================================================

`ifndef BFM_TEST_PKG_SV
`define BFM_TEST_PKG_SV

package bfm_test_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  import axi4ar_pkg::*;
  import axi4aw_pkg::*;
  import axi4b_pkg::*;
  import axi4r_pkg::*;
  import axi4w_pkg::*;
  import bfm_pkg::*;

  `include "bfm_test.sv"

endpackage : bfm_test_pkg

`endif // BFM_TEST_PKG_SV

