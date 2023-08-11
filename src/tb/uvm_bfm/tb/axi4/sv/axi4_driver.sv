// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4_driver.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Fri Aug 11 07:29:11 2023
//=============================================================================
// Description: Driver for axi4
//=============================================================================

`ifndef AXI4_DRIVER_SV
`define AXI4_DRIVER_SV

// You can insert code here by setting driver_inc_before_class in file tools/gen/axi4bfm/axi4.tpl

class axi4_driver extends uvm_driver #(axi4_tx);

  `uvm_component_utils(axi4_driver)

  virtual axi4_bfm vif;

  axi4_config     m_config;

  extern function new(string name, uvm_component parent);

  // Start of inlined include file src/tb/uvm_bfm/tb/include/axi4_driver_inc_inside_class.sv
  task run_phase(uvm_phase phase);
    forever begin
      axi4_tx_s req_s;
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
  
      req_s.wdata    = req.wdata;
      req_s.wstrb    = req.wstrb;
      req_s.wlast    = req.wlast;
      req_s.wvalid   = req.wvalid;
      req_s.wready   = req.wready;
  
      req_s.bid      = req.bid;
      req_s.bresp    = req.bresp;
      req_s.bvalid   = req.bvalid;
      req_s.bready   = req.bready;
  
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
  
      req_s.rid      = req.rid;
      req_s.rdata    = req.rdata;
      req_s.rresp    = req.rresp;
      req_s.rlast    = req.rlast;
      req_s.rvalid   = req.rvalid;
      req_s.rready   = req.rready;
  
      vif.drive(req_s);
  
      seq_item_port.item_done();
    end
  endtask : run_phase
  // End of inlined include file

endclass : axi4_driver 


function axi4_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


// You can insert code here by setting driver_inc_after_class in file tools/gen/axi4bfm/axi4.tpl

`endif // AXI4_DRIVER_SV

