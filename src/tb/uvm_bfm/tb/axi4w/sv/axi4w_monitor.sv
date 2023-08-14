// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4w_monitor.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 20:27:19 2023
//=============================================================================
// Description: Monitor for axi4w
//=============================================================================

`ifndef AXI4W_MONITOR_SV
`define AXI4W_MONITOR_SV

class axi4w_monitor extends uvm_monitor;

  `uvm_component_utils(axi4w_monitor)

  virtual axi4w_bfm vif;

  axi4w_config     m_config;

  uvm_analysis_port #(axi4w_tx) analysis_port;

  extern function new(string name, uvm_component parent);

  // Start of inlined include file src/tb/uvm_bfm/tb/include/axi4/w/axi4w_monitor_inc_inside_class.sv
  task run_phase(uvm_phase phase);
    vif.proxy_back_ptr = this;
    vif.run();
  endtask
  
  function void write(axi4w_tx_s req_s);
    axi4w_tx tx;
    tx          = axi4w_tx::type_id::create("tx");
  
    tx.wdata    = req_s.wdata;
    tx.wstrb    = req_s.wstrb;
    tx.wlast    = req_s.wlast;
    tx.wvalid   = req_s.wvalid;
    tx.wready   = req_s.wready;
  
    analysis_port.write(tx);
  endfunction
  // End of inlined include file

endclass : axi4w_monitor 


function axi4w_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new


`endif // AXI4W_MONITOR_SV

