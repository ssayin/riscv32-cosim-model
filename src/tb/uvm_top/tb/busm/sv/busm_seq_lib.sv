// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : ../tb/uvm_top
//
// File Name: busm_seq_lib.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sun Jul 30 15:03:49 2023
//=============================================================================
// Description: Sequence for agent busm
//=============================================================================

`ifndef BUSM_SEQ_LIB_SV
`define BUSM_SEQ_LIB_SV

class busm_default_seq extends uvm_sequence #(axi4_tx);

  `uvm_object_utils(busm_default_seq)

  busm_config  m_config;

  extern function new(string name = "");
  extern task body();

`ifndef UVM_POST_VERSION_1_1
  // Functions to support UVM 1.2 objection API in UVM 1.1
  extern function uvm_phase get_starting_phase();
  extern function void set_starting_phase(uvm_phase phase);
`endif

endclass : busm_default_seq


function busm_default_seq::new(string name = "");
  super.new(name);
endfunction : new


task busm_default_seq::body();
  `uvm_info(get_type_name(), "Default sequence starting", UVM_HIGH)

  req = axi4_tx::type_id::create("req");
  start_item(req); 
  if ( !req.randomize() )
    `uvm_error(get_type_name(), "Failed to randomize transaction")
  finish_item(req); 

  `uvm_info(get_type_name(), "Default sequence completed", UVM_HIGH)
endtask : body


`ifndef UVM_POST_VERSION_1_1
function uvm_phase busm_default_seq::get_starting_phase();
  return starting_phase;
endfunction: get_starting_phase


function void busm_default_seq::set_starting_phase(uvm_phase phase);
  starting_phase = phase;
endfunction: set_starting_phase
`endif


// You can insert code here by setting agent_seq_inc in file busm.tpl

`endif // BUSM_SEQ_LIB_SV

