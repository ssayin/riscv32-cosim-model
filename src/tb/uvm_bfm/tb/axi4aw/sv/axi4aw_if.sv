// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4aw_if.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 18:56:08 2023
//=============================================================================
// Description: Signal interface for agent axi4aw
//=============================================================================

`ifndef AXI4AW_IF_SV
`define AXI4AW_IF_SV

interface axi4aw_if(); 

  timeunit      1ns;
  timeprecision 1ps;

  import axi4aw_pkg::*;

  logic        clk;
  logic        rst_n;
  logic        awid;
  logic [31:0] awaddr;
  logic [ 7:0] awlen;
  logic [ 2:0] awsize;
  logic [ 1:0] awburst;
  logic        awlock;
  logic [ 3:0] awcache;
  logic [ 2:0] awprot;
  logic        awvalid;
  logic [ 3:0] awregion;
  logic [ 3:0] awqos;
  logic        awready;

  // You can insert properties and assertions here

endinterface : axi4aw_if

`endif // AXI4AW_IF_SV

