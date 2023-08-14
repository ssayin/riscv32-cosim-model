// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4ar_monitor.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 03:07:16 2023
//=============================================================================
// Description: Monitor for axi4ar
//=============================================================================

`ifndef AXI4AR_MONITOR_SV
`define AXI4AR_MONITOR_SV

class axi4ar_monitor extends uvm_monitor;

  `uvm_component_utils(axi4ar_monitor)

  virtual axi4ar_bfm vif;

  axi4ar_config     m_config;

  uvm_analysis_port #(axi4ar_tx) analysis_port;

  extern function new(string name, uvm_component parent);

  // Start of inlined include file src/tb/uvm_bfm/tb/include/axi4/ar/axi4ar_monitor_inc_inside_class.sv
  task run_phase(uvm_phase phase);
    vif.proxy_back_ptr = this;
    vif.run();
  endtask
  
  function void write(axi4ar_tx_s req_s);
    axi4ar_tx tx;
    tx          = axi4ar_tx::type_id::create("tx");
  
    tx.arid     = req_s.arid;
    tx.araddr   = req_s.araddr;
    tx.arlen    = req_s.arlen;
    tx.arsize   = req_s.arsize;
    tx.arburst  = req_s.arburst;
    tx.arlock   = req_s.arlock;
    tx.arcache  = req_s.arcache;
    tx.arprot   = req_s.arprot;
    tx.arvalid  = req_s.arvalid;
    tx.arqos    = req_s.arqos;
    tx.arregion = req_s.arregion;
    tx.arready  = req_s.arready;
  
     analysis_port.write(tx);
  endfunction
  // End of inlined include file

endclass : axi4ar_monitor 


function axi4ar_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new


`endif // AXI4AR_MONITOR_SV

