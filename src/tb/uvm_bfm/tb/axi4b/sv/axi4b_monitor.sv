// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4b_monitor.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 03:07:16 2023
//=============================================================================
// Description: Monitor for axi4b
//=============================================================================

`ifndef AXI4B_MONITOR_SV
`define AXI4B_MONITOR_SV

class axi4b_monitor extends uvm_monitor;

  `uvm_component_utils(axi4b_monitor)

  virtual axi4b_bfm vif;

  axi4b_config     m_config;

  uvm_analysis_port #(axi4b_tx) analysis_port;

  extern function new(string name, uvm_component parent);

  // Start of inlined include file src/tb/uvm_bfm/tb/include/axi4/b/axi4b_monitor_inc_inside_class.sv
  task run_phase(uvm_phase phase);
    vif.proxy_back_ptr = this;
    vif.run();
  endtask
  
  function void write(axi4b_tx_s req_s);
    axi4b_tx tx;
    tx          = axi4b_tx::type_id::create("tx");
  
    tx.bid      = req_s.bid;
    tx.bresp    = req_s.bresp;
    tx.bvalid   = req_s.bvalid;
    tx.bready   = req_s.bready;
  
     analysis_port.write(tx);
  endfunction
  // End of inlined include file

endclass : axi4b_monitor 


function axi4b_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new


`endif // AXI4B_MONITOR_SV

