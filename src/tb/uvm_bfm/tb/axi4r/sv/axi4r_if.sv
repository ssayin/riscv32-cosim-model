// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4r_if.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 03:07:16 2023
//=============================================================================
// Description: Signal interface for agent axi4r
//=============================================================================

`ifndef AXI4R_IF_SV
`define AXI4R_IF_SV

interface axi4r_if(); 

  timeunit      1ns;
  timeprecision 1ps;

  import axi4r_pkg::*;

  logic        clk;
  logic        rst_n;
  logic        rid;
  logic [63:0] rdata;
  logic [ 1:0] rresp;
  logic        rlast;
  logic        rvalid;
  logic        rready;

  // You can insert properties and assertions here

endinterface : axi4r_if

`endif // AXI4R_IF_SV

