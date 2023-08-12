// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_top
//
// File Name: riscv_core_if.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 16:23:52 2023
//=============================================================================
// Description: Signal interface for agent riscv_core
//=============================================================================

`ifndef RISCV_CORE_IF_SV
`define RISCV_CORE_IF_SV

interface riscv_core_if(); 

  timeunit      1ns;
  timeprecision 1ps;

  import riscv_core_pkg::*;

  logic clk;
  logic rst_n;
  logic awid;
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
  logic [63:0] wdata;
  logic [ 7:0] wstrb;
  logic        wlast;
  logic        wvalid;
  logic        wready;
  logic       bid;
  logic [1:0] bresp;
  logic       bvalid;
  logic       bready;
  logic        arid;
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
  logic        rid;
  logic [63:0] rdata;
  logic [ 1:0] rresp;
  logic        rlast;
  logic        rvalid;
  logic        rready;

  // You can insert properties and assertions here

endinterface : riscv_core_if

`endif // RISCV_CORE_IF_SV

