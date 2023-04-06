`ifndef DEC_DECODE_TRANSACTION
`define DEC_DECODE_TRANSACTION

`include "dec_decode_def.sv"

class dec_decode_transaction extends uvm_sequence_item;

  decoder_out_t dec_out;
  rand decoder_in_t dec_in;

  `uvm_object_utils_begin(dec_decode_transaction)
    `uvm_field_int(dec_in.instr, UVM_ALL_ON)
    `uvm_field_int(dec_in.pc_in, UVM_ALL_ON)
    `uvm_field_int(dec_out.imm, UVM_ALL_ON)
    `uvm_field_int(dec_out.rd_addr, UVM_ALL_ON)
    `uvm_field_int(dec_out.rs1_addr, UVM_ALL_ON)
    `uvm_field_int(dec_out.rs2_addr, UVM_ALL_ON)
    `uvm_field_int(dec_out.alu, UVM_ALL_ON)
    `uvm_field_int(dec_out.br, UVM_ALL_ON)
    `uvm_field_int(dec_out.lsu, UVM_ALL_ON)
    `uvm_field_int(dec_out.illegal, UVM_ALL_ON)
    `uvm_field_int(dec_out.use_imm, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "dec_decode_transaction");
    super.new(name);
  endfunction : new

  // constraints ..

  // constraint instr_c {instr inside {[32'h0 : 32'hFFFFFFFF]};}

  function void post_randomize();
  endfunction : post_randomize

endclass : dec_decode_transaction

`endif
