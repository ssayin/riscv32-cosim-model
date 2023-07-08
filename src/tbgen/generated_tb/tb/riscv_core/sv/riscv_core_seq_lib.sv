// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Project  : generated_tb
//
// File Name: riscv_core_seq_lib.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sun Jul  9 00:13:28 2023
//=============================================================================
// Description: Sequence for agent riscv_core
//=============================================================================

`ifndef RISCV_CORE_SEQ_LIB_SV
`define RISCV_CORE_SEQ_LIB_SV

class riscv_core_default_seq extends uvm_sequence #(riscv_core_tx);

  `uvm_object_utils(riscv_core_default_seq)

  riscv_core_config  m_config;

  extern function new(string name = "");
  extern task body();

`ifndef UVM_POST_VERSION_1_1
  // Functions to support UVM 1.2 objection API in UVM 1.1
  extern function uvm_phase get_starting_phase();
  extern function void set_starting_phase(uvm_phase phase);
`endif

endclass : riscv_core_default_seq


function riscv_core_default_seq::new(string name = "");
  super.new(name);
endfunction : new


task riscv_core_default_seq::body();
  `uvm_info(get_type_name(), "Default sequence starting", UVM_HIGH)

  req = riscv_core_tx::type_id::create("req");
  start_item(req); 
  if ( !req.randomize() )
    `uvm_error(get_type_name(), "Failed to randomize transaction")
  finish_item(req); 

  `uvm_info(get_type_name(), "Default sequence completed", UVM_HIGH)
endtask : body


`ifndef UVM_POST_VERSION_1_1
function uvm_phase riscv_core_default_seq::get_starting_phase();
  return starting_phase;
endfunction: get_starting_phase


function void riscv_core_default_seq::set_starting_phase(uvm_phase phase);
  starting_phase = phase;
endfunction: set_starting_phase
`endif


// Start of inlined include file generated_tb/tb/include/my_riscv_core_seq.sv
`ifndef MY_RISCV_CORE_SEQ_SV
`define MY_RISCV_CORE_SEQ_SV

class my_riscv_core_seq extends riscv_core_default_seq;

  `uvm_object_utils(my_riscv_core_seq)

  logic [31:0] mem_data_in  [2];
  logic        mem_ready;
  logic        irq_external;
  logic        irq_timer;
  logic        irq_software;

  function new(string name = "");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "my_riscv_core_seq seq starting", UVM_HIGH)
    req = riscv_core_tx::type_id::create("req");
    start_item(req);
    if (!req.randomize()) `uvm_error(get_type_name(), "randomization failed")
    finish_item(req);
    `uvm_info(get_type_name(), "my_riscv_core_seq seq completed", UVM_HIGH)
  endtask : body

endclass : my_riscv_core_seq


`endif



// End of inlined include file

`endif // RISCV_CORE_SEQ_LIB_SV

