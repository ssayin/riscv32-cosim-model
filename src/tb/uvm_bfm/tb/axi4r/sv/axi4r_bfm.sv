// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4r_bfm.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 01:57:09 2023
//=============================================================================
// Description: Synthesizable BFM for agent axi4r
//=============================================================================

`ifndef AXI4R_BFM_SV
`define AXI4R_BFM_SV

interface axi4r_bfm(axi4r_if if_port); 

  timeunit      1ns;
  timeprecision 1ps;

  import axi4r_pkg::*;

  // Start of inlined include file src/tb/uvm_bfm/tb/include/axi4/r/axi4r_inc_inside_bfm.sv
  task drive(axi4r_tx_s req_s);
    if_port.rid      <= req_s.rid;
    if_port.rdata    <= req_s.rdata;
    if_port.rresp    <= req_s.rresp;
    if_port.rlast    <= req_s.rlast;
    if_port.rvalid   <= req_s.rvalid;
    if_port.rready   <= req_s.rready;
    @(posedge if_port.clk);
  endtask
  
  import axi4r_pkg::axi4r_monitor;
  axi4r_monitor proxy_back_ptr;
  
  task run;
    forever begin
      axi4r_tx_s req_s;
      @(posedge if_port.clk);
      req_s.rid      = if_port.rid;
      req_s.rdata    = if_port.rdata;
      req_s.rresp    = if_port.rresp;
      req_s.rlast    = if_port.rlast;
      req_s.rvalid   = if_port.rvalid;
      req_s.rready   = if_port.rready;
      proxy_back_ptr.write(req_s);
    end
  endtask
  // End of inlined include file

endinterface : axi4r_bfm

`endif // AXI4R_BFM_SV

