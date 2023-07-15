// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : ../tb/uvm_top
//
// File Name: riscv_core_seq_lib.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Jul 15 22:09:49 2023
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


// Start of inlined include file ../tb/uvm_top/tb/include/my_riscv_core_seq.sv
`ifndef MY_RISCV_CORE_SEQ_SV
`define MY_RISCV_CORE_SEQ_SV

class my_riscv_core_seq extends riscv_core_default_seq;

  `uvm_object_utils(my_riscv_core_seq)

  function new(string name = "");
    super.new(name);
  endfunction : new

  task body();
    //`uvm_info(get_type_name(), "my_riscv_core_seq seq starting", UVM_HIGH)
    //req = riscv_core_tx::type_id::create("req");
    //start_item(req);
    //req.mem_data_in[0][31:0]  = 32'h13;
    //req.mem_data_in[1][31:0]  = 32'h0;
    //req.mem_ready             = 1;
    //req.irq_timer             = 0;
    //req.irq_external          = 0;
    //req.irq_software          = 0;
    // outputs
    //req.mem_data_out[0][31:0] = 0;
    //req.mem_data_out[1][31:0] = 0;
    //req.mem_wr_en[0]          = 0;
    //req.mem_wr_en[1]          = 0;
    //req.mem_rd_en[0]          = 1;
    //req.mem_rd_en[1]          = 0;
    //req.mem_clk_en            = 1;
    //req.mem_addr[0][31:0]     = 0;
    //req.mem_addr[1][31:0]     = 0;

    //finish_item(req);
    //`uvm_info(get_type_name(), "my_riscv_core_seq seq completed", UVM_HIGH)
  endtask : body

endclass : my_riscv_core_seq


`endif



// End of inlined include file

`endif // RISCV_CORE_SEQ_LIB_SV

