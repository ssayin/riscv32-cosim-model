// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : ../tb/uvm_top
//
// File Name: riscv_core_if.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Fri Jul 21 13:05:27 2023
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
  logic [31:0] mem_data_in [2];
  logic mem_ready;
  logic irq_external;
  logic irq_timer;
  logic irq_software;
  logic [31:0] mem_data_out[2];
  logic [3:0] mem_wr_en [2];
  logic mem_rd_en [2];
  logic mem_clk_en;
  logic [31:0] mem_addr [2];

  // You can insert properties and assertions here

  // You can insert code here by setting if_inc_inside_interface in file riscv_core.tpl

endinterface : riscv_core_if

`endif // RISCV_CORE_IF_SV

