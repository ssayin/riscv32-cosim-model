// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : ../tb/uvm_top
//
// File Name: axi4master_monitor.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sun Aug  6 19:10:43 2023
//=============================================================================
// Description: Monitor for axi4master
//=============================================================================

`ifndef AXI4MASTER_MONITOR_SV
`define AXI4MASTER_MONITOR_SV

// You can insert code here by setting monitor_inc_before_class in file axi4master.tpl

class axi4master_monitor extends uvm_monitor;

  `uvm_component_utils(axi4master_monitor)

  virtual axi4master_bfm vif;

  axi4master_config     m_config;

  uvm_analysis_port #(axi4_tx) analysis_port;

  extern function new(string name, uvm_component parent);

  // Start of inlined include file ../tb/uvm_top/tb/include/axi4master_monitor_inc_inside_class.sv
  task run_phase(uvm_phase phase);
    vif.proxy_back_ptr = this;
    vif.run();
  endtask
  
  function void write(axi4_tx_s req_s);
    axi4_tx tx;
    tx          = axi4_tx::type_id::create("tx");
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
  
    tx.wdata    = req_s.wdata;
    tx.wstrb    = req_s.wstrb;
    tx.wlast    = req_s.wlast;
    tx.wvalid   = req_s.wvalid;
    tx.wready   = req_s.wready;
  
    tx.bid      = req_s.bid;
    tx.bresp    = req_s.bresp;
    tx.bvalid   = req_s.bvalid;
    tx.bready   = req_s.bready;
  
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
  
    tx.rid      = req_s.rid;
    tx.rdata    = req_s.rdata;
    tx.rresp    = req_s.rresp;
    tx.rlast    = req_s.rlast;
    tx.rvalid   = req_s.rvalid;
    tx.rready   = req_s.rready;
    analysis_port.write(tx);
  endfunction
  // End of inlined include file

endclass : axi4master_monitor 


function axi4master_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new


// You can insert code here by setting monitor_inc_after_class in file axi4master.tpl

`endif // AXI4MASTER_MONITOR_SV

