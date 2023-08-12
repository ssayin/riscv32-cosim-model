// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: bfm_seq_lib.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 06:44:54 2023
//=============================================================================
// Description: Sequence for bfm
//=============================================================================

`ifndef BFM_SEQ_LIB_SV
`define BFM_SEQ_LIB_SV

class bfm_default_seq extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(bfm_default_seq)

  bfm_config  m_config;
   
  axi4_agent  m_axi4_agent;

  // Number of times to repeat child sequences
  int m_seq_count = 300;

  extern function new(string name = "");
  extern task body();
  extern task pre_start();
  extern task post_start();

`ifndef UVM_POST_VERSION_1_1
  // Functions to support UVM 1.2 objection API in UVM 1.1
  extern function uvm_phase get_starting_phase();
  extern function void set_starting_phase(uvm_phase phase);
`endif

endclass : bfm_default_seq


function bfm_default_seq::new(string name = "");
  super.new(name);
endfunction : new


task bfm_default_seq::body();
  `uvm_info(get_type_name(), "Default sequence starting", UVM_HIGH)


  repeat (m_seq_count)
  begin
    fork
      if (m_axi4_agent.m_config.is_active == UVM_ACTIVE)
      begin
        axi4_default_seq seq;
        seq = axi4_default_seq::type_id::create("seq");
        seq.set_item_context(this, m_axi4_agent.m_sequencer);
        if ( !seq.randomize() )
          `uvm_error(get_type_name(), "Failed to randomize sequence")
        seq.m_config = m_axi4_agent.m_config;
        seq.set_starting_phase( get_starting_phase() );
        seq.start(m_axi4_agent.m_sequencer, this);
      end
    join
  end

  `uvm_info(get_type_name(), "Default sequence completed", UVM_HIGH)
endtask : body


task bfm_default_seq::pre_start();
  uvm_phase phase = get_starting_phase();
  if (phase != null)
    phase.raise_objection(this);
endtask: pre_start


task bfm_default_seq::post_start();
  uvm_phase phase = get_starting_phase();
  if (phase != null) 
    phase.drop_objection(this);
endtask: post_start


`ifndef UVM_POST_VERSION_1_1
function uvm_phase bfm_default_seq::get_starting_phase();
  return starting_phase;
endfunction: get_starting_phase


function void bfm_default_seq::set_starting_phase(uvm_phase phase);
  starting_phase = phase;
endfunction: set_starting_phase
`endif


`endif // BFM_SEQ_LIB_SV

