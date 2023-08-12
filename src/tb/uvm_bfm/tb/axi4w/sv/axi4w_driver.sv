// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4w_driver.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 16:23:52 2023
//=============================================================================
// Description: Driver for axi4w
//=============================================================================

`ifndef AXI4W_DRIVER_SV
`define AXI4W_DRIVER_SV

class axi4w_driver extends uvm_driver #(axi4w_tx);

  `uvm_component_utils(axi4w_driver)

  virtual axi4w_bfm vif;

  axi4w_config     m_config;

  extern function new(string name, uvm_component parent);

  // Start of inlined include file src/tb/uvm_bfm/tb/include/axi4/w/axi4w_driver_inc_inside_class.sv
  task run_phase(uvm_phase phase);
    forever begin
      axi4w_tx_s req_s;
      seq_item_port.get_next_item(req);
  
      req_s.wdata    = req.wdata;
      req_s.wstrb    = req.wstrb;
      req_s.wlast    = req.wlast;
      req_s.wvalid   = req.wvalid;
      req_s.wready   = req.wready;
  
      vif.drive(req_s);
  
      seq_item_port.item_done();
    end
  endtask : run_phase
  // End of inlined include file

endclass : axi4w_driver 


function axi4w_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


`endif // AXI4W_DRIVER_SV

