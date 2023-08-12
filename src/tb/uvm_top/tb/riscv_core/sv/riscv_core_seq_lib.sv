// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_top
//
// File Name: riscv_core_seq_lib.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 06:44:54 2023
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


// Start of inlined include file src/tb/uvm_top/tb/include/riscv_core/my_riscv_core_seq.sv
`ifndef MY_RISCV_CORE_SEQ_SV
`define MY_RISCV_CORE_SEQ_SV

class riscv_core_hex_seq extends riscv_core_default_seq;

  `uvm_object_utils(riscv_core_hex_seq)

  bit [7:0] data[1024];

  function new(string name = "riscv_core_hex_seq");
    super.new(name);
    $readmemh(`HEX_FILENAME, data);
  endfunction : new

  task body();

    for (int i = 0; i < 1024; i = i + 8) begin
      req = riscv_core_tx::type_id::create("req");

      `uvm_info(get_type_name(), "riscv_core_hex_seq sequence starting", UVM_HIGH)
      start_item(req);

      assert (req.randomize());

      req.rdata[63:0] = {{data[i][7:0], data[i+1][7:0], data[i+2][7:0], data[i+3][7:0], data[i+4][7:0], data[i+5][7:0], data[i+6][7:0], data[i+7][7:0]}};

      finish_item(req);
      `uvm_info(get_type_name(), "riscv_core_hex_seq sequence completed", UVM_HIGH)
    end

  endtask : body
endclass : riscv_core_hex_seq

class riscv_core_instr_feed_seq extends riscv_core_default_seq;

  `uvm_object_utils(riscv_core_instr_feed_seq)

  int          fd;
  logic [31:0] data[2];

  function new(string name = "riscv_core_instr_feed_seq");
    super.new(name);
    fd = $fopen(`INSTR_SEQ_FILENAME, "r");
  endfunction : new

  task body();

    for (int i = 0; i < `INSTR_SEQ_LINECOUNT; i = i + 2) begin
      `uvm_info(get_type_name(), "riscv_core_instr_feed_seq sequence starting", UVM_HIGH)
      req = riscv_core_tx::type_id::create("req");

      // TODO: fix endian
      for (int j = 0; j < 2; j++) begin
        $fscanf(fd, "%d", data[j]);
      end

      start_item(req);

      assert (req.randomize());
      for (int j = 0; j < 2; j++) begin
        // TODO: fix endian
        req.rdata[63:32] = data[j];
        req.rdata[31:0]  = data[j+1];
      end

      finish_item(req);
      `uvm_info(get_type_name(), "riscv_core_instr_feed_seq sequence completed", UVM_HIGH)
    end

    $fclose(fd);
  endtask : body

endclass : riscv_core_instr_feed_seq

`endif
// End of inlined include file

`endif // RISCV_CORE_SEQ_LIB_SV

