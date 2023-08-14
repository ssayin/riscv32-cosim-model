// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4b_driver.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 03:07:16 2023
//=============================================================================
// Description: Driver for axi4b
//=============================================================================

`ifndef AXI4B_DRIVER_SV
`define AXI4B_DRIVER_SV

class axi4b_driver extends uvm_driver #(axi4b_tx);

  `uvm_component_utils(axi4b_driver)

  virtual axi4b_bfm vif;

  axi4b_config     m_config;

  extern function new(string name, uvm_component parent);

  // Start of inlined include file src/tb/uvm_bfm/tb/include/axi4/b/axi4b_driver_inc_inside_class.sv
  task run_phase(uvm_phase phase);
    forever begin
      axi4b_tx_s req_s;
      seq_item_port.get_next_item(req);
  
      req_s.bid      = req.bid;
      req_s.bresp    = req.bresp;
      req_s.bvalid   = req.bvalid;
      req_s.bready   = req.bready;
  
      vif.drive(req_s);
  
      seq_item_port.item_done();
    end
  endtask : run_phase
  // End of inlined include file

endclass : axi4b_driver 


function axi4b_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


`endif // AXI4B_DRIVER_SV

