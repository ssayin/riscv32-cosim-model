// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4b_if.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 04:22:47 2023
//=============================================================================
// Description: Signal interface for agent axi4b
//=============================================================================

`ifndef AXI4B_IF_SV
`define AXI4B_IF_SV

interface axi4b_if(); 

  timeunit      1ns;
  timeprecision 1ps;

  import axi4b_pkg::*;

  logic       clk;
  logic       rst_n;
  logic       bid;
  logic [1:0] bresp;
  logic       bvalid;
  logic       bready;

  // You can insert properties and assertions here

endinterface : axi4b_if

`endif // AXI4B_IF_SV

