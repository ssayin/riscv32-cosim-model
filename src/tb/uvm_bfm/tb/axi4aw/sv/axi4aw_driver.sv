// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4aw_driver.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 16:23:52 2023
//=============================================================================
// Description: Driver for axi4aw
//=============================================================================

`ifndef AXI4AW_DRIVER_SV
`define AXI4AW_DRIVER_SV

class axi4aw_driver extends uvm_driver #(axi4aw_tx);

  `uvm_component_utils(axi4aw_driver)

  virtual axi4aw_bfm vif;

  axi4aw_config     m_config;

  extern function new(string name, uvm_component parent);

  // Start of inlined include file src/tb/uvm_bfm/tb/include/axi4/aw/axi4aw_driver_inc_inside_class.sv
  task run_phase(uvm_phase phase);
    forever begin
      axi4aw_tx_s req_s;
      seq_item_port.get_next_item(req);
  
      req_s.awid     = req.awid;
      req_s.awaddr   = req.awaddr;
      req_s.awlen    = req.awlen;
      req_s.awsize   = req.awsize;
      req_s.awburst  = req.awburst;
      req_s.awlock   = req.awlock;
      req_s.awcache  = req.awcache;
      req_s.awprot   = req.awprot;
      req_s.awvalid  = req.awvalid;
      req_s.awregion = req.awregion;
      req_s.awqos    = req.awqos;
      req_s.awready  = req.awready;
  
      vif.drive(req_s);
  
      seq_item_port.item_done();
    end
  endtask : run_phase
  // End of inlined include file

endclass : axi4aw_driver 


function axi4aw_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


`endif // AXI4AW_DRIVER_SV

