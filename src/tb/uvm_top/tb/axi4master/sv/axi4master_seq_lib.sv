// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : ../tb/uvm_top
//
// File Name: axi4master_seq_lib.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug  5 03:57:15 2023
//=============================================================================
// Description: Sequence for agent axi4master
//=============================================================================

`ifndef AXI4MASTER_SEQ_LIB_SV
`define AXI4MASTER_SEQ_LIB_SV

class axi4master_default_seq extends uvm_sequence #(axi4_tx);

  `uvm_object_utils(axi4master_default_seq)

  axi4master_config  m_config;

  extern function new(string name = "");
  extern task body();

`ifndef UVM_POST_VERSION_1_1
  // Functions to support UVM 1.2 objection API in UVM 1.1
  extern function uvm_phase get_starting_phase();
  extern function void set_starting_phase(uvm_phase phase);
`endif

endclass : axi4master_default_seq


function axi4master_default_seq::new(string name = "");
  super.new(name);
endfunction : new


task axi4master_default_seq::body();
  `uvm_info(get_type_name(), "Default sequence starting", UVM_HIGH)

  req = axi4_tx::type_id::create("req");
  start_item(req); 
  if ( !req.randomize() )
    `uvm_error(get_type_name(), "Failed to randomize transaction")
  finish_item(req); 

  `uvm_info(get_type_name(), "Default sequence completed", UVM_HIGH)
endtask : body


`ifndef UVM_POST_VERSION_1_1
function uvm_phase axi4master_default_seq::get_starting_phase();
  return starting_phase;
endfunction: get_starting_phase


function void axi4master_default_seq::set_starting_phase(uvm_phase phase);
  starting_phase = phase;
endfunction: set_starting_phase
`endif


// You can insert code here by setting agent_seq_inc in file axi4master.tpl

`endif // AXI4MASTER_SEQ_LIB_SV

