// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4w_if.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Thu Mar 21 22:59:05 2024
//=============================================================================
// Description: Signal interface for agent axi4w
//=============================================================================

`ifndef AXI4W_IF_SV
`define AXI4W_IF_SV

interface axi4w_if(); 

  timeunit      1ns;
  timeprecision 1ps;

  import axi4w_pkg::*;

  logic        clk;
  logic        rst_n;
  logic [63:0] wdata;
  logic [ 7:0] wstrb;
  logic        wlast;
  logic        wvalid;
  logic        wready;

  // You can insert properties and assertions here

endinterface : axi4w_if

`endif // AXI4W_IF_SV

