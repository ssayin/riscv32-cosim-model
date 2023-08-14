// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4r_driver.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 18:56:08 2023
//=============================================================================
// Description: Driver for axi4r
//=============================================================================

`ifndef AXI4R_DRIVER_SV
`define AXI4R_DRIVER_SV

class axi4r_driver extends uvm_driver #(axi4r_tx);

  `uvm_component_utils(axi4r_driver)

  virtual axi4r_bfm vif;

  axi4r_config     m_config;

  extern function new(string name, uvm_component parent);

  // Start of inlined include file src/tb/uvm_bfm/tb/include/axi4/r/axi4r_driver_inc_inside_class.sv
  task run_phase(uvm_phase phase);
    forever begin
      axi4r_tx_s req_s;
      seq_item_port.get_next_item(req);
  
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

endclass : axi4r_driver 


function axi4r_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


`endif // AXI4R_DRIVER_SV

