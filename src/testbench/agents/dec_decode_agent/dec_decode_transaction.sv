`ifndef DEC_DECODE_TRANSACTION
`define DEC_DECODE_TRANSACTION

import svdpi_pkg::*;
class dec_decode_transaction extends uvm_sequence_item;

  decoder_out_t     dec_out;
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

  function void post_randomize();
  endfunction : post_randomize


  function bit compare(uvm_object rhs);

    dec_decode_transaction rhs_trans;

    if (!$cast(rhs_trans, rhs)) begin
      `uvm_error(get_full_name(), "Failed to cast rhs to dec_decode_transaction");
      return 0;
    end
    if (dec_out.illegal != rhs_trans.dec_out.illegal) begin
      return 0;
    end
    if (dec_out.imm != rhs_trans.dec_out.imm) begin
      return 0;
    end
    if (dec_out.rs1_addr != rhs_trans.dec_out.rs1_addr) begin
      return 0;
    end
    if (dec_out.rs2_addr != rhs_trans.dec_out.rs2_addr) begin
      return 0;
    end
    if (dec_out.rd_addr != rhs_trans.dec_out.rd_addr) begin
      return 0;
    end
    if (rhs_trans.dec_out.alu != dec_out.alu) return 0;
    if (rhs_trans.dec_out.lsu != dec_out.lsu) return 0;
    return 1;

  endfunction : compare

endclass : dec_decode_transaction

`endif
