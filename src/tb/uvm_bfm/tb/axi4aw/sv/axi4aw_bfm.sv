// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4aw_bfm.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 07:56:24 2023
//=============================================================================
// Description: Synthesizable BFM for agent axi4aw
//=============================================================================

`ifndef AXI4AW_BFM_SV
`define AXI4AW_BFM_SV

interface axi4aw_bfm(axi4aw_if if_port); 

  timeunit      1ns;
  timeprecision 1ps;

  import axi4aw_pkg::*;

  // Start of inlined include file src/tb/uvm_bfm/tb/include/axi4/aw/axi4aw_inc_inside_bfm.sv
  task drive(axi4aw_tx_s req_s);
    if_port.awid     <= req_s.awid;
    if_port.awaddr   <= req_s.awaddr;
    if_port.awlen    <= req_s.awlen;
    if_port.awsize   <= req_s.awsize;
    if_port.awburst  <= req_s.awburst;
    if_port.awlock   <= req_s.awlock;
    if_port.awcache  <= req_s.awcache;
    if_port.awprot   <= req_s.awprot;
    if_port.awvalid  <= req_s.awvalid;
    if_port.awregion <= req_s.awregion;
    if_port.awqos    <= req_s.awqos;
    if_port.awready  <= req_s.awready;
  
     @(posedge if_port.clk);
  endtask
  
  import axi4aw_pkg::axi4aw_monitor;
  axi4aw_monitor proxy_back_ptr;
  
  task run;
    forever begin
      axi4aw_tx_s req_s;
      @(posedge if_port.clk);
  
      req_s.awid     = if_port.awid;
      req_s.awaddr   = if_port.awaddr;
      req_s.awlen    = if_port.awlen;
      req_s.awsize   = if_port.awsize;
      req_s.awburst  = if_port.awburst;
      req_s.awlock   = if_port.awlock;
      req_s.awcache  = if_port.awcache;
      req_s.awprot   = if_port.awprot;
      req_s.awvalid  = if_port.awvalid;
      req_s.awregion = if_port.awregion;
      req_s.awqos    = if_port.awqos;
      req_s.awready  = if_port.awready;
  
      proxy_back_ptr.write(req_s);
    end
  endtask
  // End of inlined include file

endinterface : axi4aw_bfm

`endif // AXI4AW_BFM_SV

