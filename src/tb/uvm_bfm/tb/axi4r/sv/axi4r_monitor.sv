// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4r_monitor.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 18:56:08 2023
//=============================================================================
// Description: Monitor for axi4r
//=============================================================================

`ifndef AXI4R_MONITOR_SV
`define AXI4R_MONITOR_SV

class axi4r_monitor extends uvm_monitor;

  `uvm_component_utils(axi4r_monitor)

  virtual axi4r_bfm vif;

  axi4r_config     m_config;

  uvm_analysis_port #(axi4r_tx) analysis_port;

  extern function new(string name, uvm_component parent);

  // Start of inlined include file src/tb/uvm_bfm/tb/include/axi4/r/axi4r_monitor_inc_inside_class.sv
  task run_phase(uvm_phase phase);
    vif.proxy_back_ptr = this;
    vif.run();
  endtask
  
  function void write(axi4r_tx_s req_s);
    axi4r_tx tx;
    tx          = axi4r_tx::type_id::create("tx");
    tx.rid      = req_s.rid;
    tx.rdata    = req_s.rdata;
    tx.rresp    = req_s.rresp;
    tx.rlast    = req_s.rlast;
    tx.rvalid   = req_s.rvalid;
    tx.rready   = req_s.rready;
    analysis_port.write(tx);
  endfunction
  // End of inlined include file

endclass : axi4r_monitor 


function axi4r_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new


`endif // AXI4R_MONITOR_SV

