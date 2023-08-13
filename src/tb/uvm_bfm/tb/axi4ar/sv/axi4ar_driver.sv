// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4ar_driver.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 01:57:09 2023
//=============================================================================
// Description: Driver for axi4ar
//=============================================================================

`ifndef AXI4AR_DRIVER_SV
`define AXI4AR_DRIVER_SV

class axi4ar_driver extends uvm_driver #(axi4ar_tx);

  `uvm_component_utils(axi4ar_driver)

  virtual axi4ar_bfm vif;

  axi4ar_config     m_config;

  extern function new(string name, uvm_component parent);

  // Start of inlined include file src/tb/uvm_bfm/tb/include/axi4/ar/axi4ar_driver_inc_inside_class.sv
  task run_phase(uvm_phase phase);
    forever begin
      axi4ar_tx_s req_s;
      seq_item_port.get_next_item(req);
  
      req_s.arid     = req.arid;
      req_s.araddr   = req.araddr;
      req_s.arlen    = req.arlen;
      req_s.arsize   = req.arsize;
      req_s.arburst  = req.arburst;
      req_s.arlock   = req.arlock;
      req_s.arcache  = req.arcache;
      req_s.arprot   = req.arprot;
      req_s.arvalid  = req.arvalid;
      req_s.arqos    = req.arqos;
      req_s.arregion = req.arregion;
      req_s.arready  = req.arready;
  
      vif.drive(req_s);
  
      seq_item_port.item_done();
    end
  endtask : run_phase
  // End of inlined include file

endclass : axi4ar_driver 


function axi4ar_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


`endif // AXI4AR_DRIVER_SV

