// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4ar_if.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Thu Mar 21 22:59:05 2024
//=============================================================================
// Description: Signal interface for agent axi4ar
//=============================================================================

`ifndef AXI4AR_IF_SV
`define AXI4AR_IF_SV

interface axi4ar_if(); 

  timeunit      1ns;
  timeprecision 1ps;

  import axi4ar_pkg::*;

  logic        clk;
  logic        rst_n;
  logic [ 1:0] arid;
  logic [31:0] araddr;
  logic [ 7:0] arlen;
  logic [ 2:0] arsize;
  logic [ 1:0] arburst;
  logic        arlock;
  logic [ 3:0] arcache;
  logic [ 2:0] arprot;
  logic        arvalid;
  logic [ 3:0] arqos;
  logic [ 3:0] arregion;
  logic        arready;

  // You can insert properties and assertions here

endinterface : axi4ar_if

`endif // AXI4AR_IF_SV

