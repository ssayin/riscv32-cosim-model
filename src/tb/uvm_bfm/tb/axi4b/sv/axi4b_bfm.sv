// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4b_bfm.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 03:07:16 2023
//=============================================================================
// Description: Synthesizable BFM for agent axi4b
//=============================================================================

`ifndef AXI4B_BFM_SV
`define AXI4B_BFM_SV

interface axi4b_bfm(axi4b_if if_port); 

  timeunit      1ns;
  timeprecision 1ps;

  import axi4b_pkg::*;

  // Start of inlined include file src/tb/uvm_bfm/tb/include/axi4/b/axi4b_inc_inside_bfm.sv
  task drive(axi4b_tx_s req_s);
  
    if_port.bid      <= req_s.bid;
    if_port.bresp    <= req_s.bresp;
    if_port.bvalid   <= req_s.bvalid;
    if_port.bready   <= req_s.bready;
  
    @(posedge if_port.clk);
  endtask
  
  import axi4b_pkg::axi4b_monitor;
  axi4b_monitor proxy_back_ptr;
  
  task run;
    forever begin
      axi4b_tx_s req_s;
      @(posedge if_port.clk);
    
      req_s.bid      = if_port.bid;
      req_s.bresp    = if_port.bresp;
      req_s.bvalid   = if_port.bvalid;
      req_s.bready   = if_port.bready;
  
      proxy_back_ptr.write(req_s);
    end
  endtask
  // End of inlined include file

endinterface : axi4b_bfm

`endif // AXI4B_BFM_SV

