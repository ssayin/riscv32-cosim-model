// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4ar_bfm.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 20:27:19 2023
//=============================================================================
// Description: Synthesizable BFM for agent axi4ar
//=============================================================================

`ifndef AXI4AR_BFM_SV
`define AXI4AR_BFM_SV

interface axi4ar_bfm(axi4ar_if if_port); 

  timeunit      1ns;
  timeprecision 1ps;

  import axi4ar_pkg::*;

  // Start of inlined include file src/tb/uvm_bfm/tb/include/axi4/ar/axi4ar_inc_inside_bfm.sv
  task drive(axi4ar_tx_s req_s);
  
    if_port.arid     <= req_s.arid;
    if_port.araddr   <= req_s.araddr;
    if_port.arlen    <= req_s.arlen;
    if_port.arsize   <= req_s.arsize;
    if_port.arburst  <= req_s.arburst;
    if_port.arlock   <= req_s.arlock;
    if_port.arcache  <= req_s.arcache;
    if_port.arprot   <= req_s.arprot;
    if_port.arvalid  <= req_s.arvalid;
    if_port.arqos    <= req_s.arqos;
    if_port.arregion <= req_s.arregion;
    if_port.arready  <= req_s.arready;
  
    @(posedge if_port.clk);
  endtask
  
  import axi4ar_pkg::axi4ar_monitor;
  axi4ar_monitor proxy_back_ptr;
  
  task run;
    forever begin
      axi4ar_tx_s req_s;
      @(posedge if_port.clk);
  
      req_s.arid     = if_port.arid;
      req_s.araddr   = if_port.araddr;
      req_s.arlen    = if_port.arlen;
      req_s.arsize   = if_port.arsize;
      req_s.arburst  = if_port.arburst;
      req_s.arlock   = if_port.arlock;
      req_s.arcache  = if_port.arcache;
      req_s.arprot   = if_port.arprot;
      req_s.arvalid  = if_port.arvalid;
      req_s.arqos    = if_port.arqos;
      req_s.arregion = if_port.arregion;
      req_s.arready  = if_port.arready;
  
      proxy_back_ptr.write(req_s);
    end
  endtask
  // End of inlined include file

endinterface : axi4ar_bfm

`endif // AXI4AR_BFM_SV

