// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4w_seq_lib.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 16:23:52 2023
//=============================================================================
// Description: Sequence for agent axi4w
//=============================================================================

`ifndef AXI4W_SEQ_LIB_SV
`define AXI4W_SEQ_LIB_SV

class axi4w_default_seq extends uvm_sequence #(axi4w_tx);

  `uvm_object_utils(axi4w_default_seq)

  axi4w_config  m_config;

  extern function new(string name = "");
  extern task body();

`ifndef UVM_POST_VERSION_1_1
  // Functions to support UVM 1.2 objection API in UVM 1.1
  extern function uvm_phase get_starting_phase();
  extern function void set_starting_phase(uvm_phase phase);
`endif

endclass : axi4w_default_seq


function axi4w_default_seq::new(string name = "");
  super.new(name);
endfunction : new


task axi4w_default_seq::body();
  `uvm_info(get_type_name(), "Default sequence starting", UVM_HIGH)

  req = axi4w_tx::type_id::create("req");
  start_item(req); 
  if ( !req.randomize() )
    `uvm_error(get_type_name(), "Failed to randomize transaction")
  finish_item(req); 

  `uvm_info(get_type_name(), "Default sequence completed", UVM_HIGH)
endtask : body


`ifndef UVM_POST_VERSION_1_1
function uvm_phase axi4w_default_seq::get_starting_phase();
  return starting_phase;
endfunction: get_starting_phase


function void axi4w_default_seq::set_starting_phase(uvm_phase phase);
  starting_phase = phase;
endfunction: set_starting_phase
`endif


`endif // AXI4W_SEQ_LIB_SV

