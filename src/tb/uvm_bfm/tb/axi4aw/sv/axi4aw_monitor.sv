// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4aw_monitor.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Jan 15 11:27:06 2024
//=============================================================================
// Description: Monitor for axi4aw
//=============================================================================

`ifndef AXI4AW_MONITOR_SV
`define AXI4AW_MONITOR_SV

class axi4aw_monitor extends uvm_monitor;

  `uvm_component_utils(axi4aw_monitor)

  virtual axi4aw_bfm vif;

  axi4aw_config     m_config;

  uvm_analysis_port #(axi4aw_tx) analysis_port;

  extern function new(string name, uvm_component parent);

  // Start of inlined include file src/tb/uvm_bfm/tb/include/axi4/aw/axi4aw_monitor_inc_inside_class.sv
  task run_phase(uvm_phase phase);
    vif.proxy_back_ptr = this;
    vif.run();
  endtask
  
  function void write(axi4aw_tx_s req_s);
    axi4aw_tx tx;
  
    tx          = axi4aw_tx::type_id::create("tx");
    tx.awid     = req_s.awid;
    tx.awaddr   = req_s.awaddr;
    tx.awlen    = req_s.awlen;
    tx.awsize   = req_s.awsize;
    tx.awburst  = req_s.awburst;
    tx.awlock   = req_s.awlock;
    tx.awcache  = req_s.awcache;
    tx.awprot   = req_s.awprot;
    tx.awvalid  = req_s.awvalid;
    tx.awregion = req_s.awregion;
    tx.awqos    = req_s.awqos;
    tx.awready  = req_s.awready;
  
    analysis_port.write(tx);
  endfunction
  // End of inlined include file

endclass : axi4aw_monitor 


function axi4aw_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new


`endif // AXI4AW_MONITOR_SV

