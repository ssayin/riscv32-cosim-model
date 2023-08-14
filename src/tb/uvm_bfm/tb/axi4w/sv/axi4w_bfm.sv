// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4w_bfm.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 07:56:24 2023
//=============================================================================
// Description: Synthesizable BFM for agent axi4w
//=============================================================================

`ifndef AXI4W_BFM_SV
`define AXI4W_BFM_SV

interface axi4w_bfm(axi4w_if if_port); 

  timeunit      1ns;
  timeprecision 1ps;

  import axi4w_pkg::*;

  // Start of inlined include file src/tb/uvm_bfm/tb/include/axi4/w/axi4w_inc_inside_bfm.sv
  task drive(axi4w_tx_s req_s);
  
    if_port.wdata    <= req_s.wdata;
    if_port.wstrb    <= req_s.wstrb;
    if_port.wlast    <= req_s.wlast;
    if_port.wvalid   <= req_s.wvalid;
    if_port.wready   <= req_s.wready;
  
    @(posedge if_port.clk);
  endtask
  
  import axi4w_pkg::axi4w_monitor;
  axi4w_monitor proxy_back_ptr;
  
  task run;
    forever begin
      axi4w_tx_s req_s;
      @(posedge if_port.clk);
   
      req_s.wdata    = if_port.wdata;
      req_s.wstrb    = if_port.wstrb;
      req_s.wlast    = if_port.wlast;
      req_s.wvalid   = if_port.wvalid;
      req_s.wready   = if_port.wready;
  
      proxy_back_ptr.write(req_s);
    end
  endtask
  // End of inlined include file

endinterface : axi4w_bfm

`endif // AXI4W_BFM_SV

