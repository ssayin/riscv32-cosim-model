`ifndef RISCV_DECODER_TRANSACTION
`define RISCV_DECODER_TRANSACTION

import svdpi_pkg::*;
class riscv_decoder_transaction extends uvm_sequence_item;

  decoder_out_t     dec_out;
  logic             is_upper_imm;
  rand decoder_in_t dec_in;

  `uvm_object_utils_begin(riscv_decoder_transaction)
    `uvm_field_int(dec_in.instr, UVM_ALL_ON)
    `uvm_field_int(dec_in.pc_in, UVM_ALL_ON)
    `uvm_field_int(dec_out.imm, UVM_ALL_ON)
    `uvm_field_int(dec_out.rd_addr, UVM_ALL_ON)
    `uvm_field_int(dec_out.rs1_addr, UVM_ALL_ON)
    `uvm_field_int(dec_out.rs2_addr, UVM_ALL_ON)
    `uvm_field_int(dec_out.alu, UVM_ALL_ON)
    `uvm_field_int(dec_out.br, UVM_ALL_ON)
    `uvm_field_int(dec_out.lsu, UVM_ALL_ON)
    `uvm_field_int(dec_out.csr, UVM_ALL_ON)
    `uvm_field_int(dec_out.auipc, UVM_ALL_ON)
    `uvm_field_int(dec_out.lui, UVM_ALL_ON)
    `uvm_field_int(dec_out.jal, UVM_ALL_ON)
    `uvm_field_int(dec_out.illegal, UVM_ALL_ON)
    `uvm_field_int(dec_out.use_imm, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "riscv_decoder_transaction");
    super.new(name);
  endfunction : new

  function void post_randomize();
  endfunction : post_randomize


  function bit compare(uvm_object rhs);

    riscv_decoder_transaction rhs_trans;

    if (!$cast(rhs_trans, rhs)) begin
      `uvm_error(get_full_name(), "Failed to cast rhs to riscv_decoder_transaction");
      return 0;
    end
    if (dec_out.illegal != rhs_trans.dec_out.illegal) begin
      `uvm_error(get_full_name(), "Illegal MISMATCH");
      return 0;
    end

    if (rhs_trans.dec_out.alu != dec_out.alu) return 0;
    if (rhs_trans.dec_out.lsu != dec_out.lsu) return 0;
    if (rhs_trans.dec_out.csr != dec_out.csr) return 0;
    if (rhs_trans.dec_out.br != dec_out.br) return 0;
    //if (rhs_trans.dec_out.jal != dec_out.jal) return 0;
    //if (rhs_trans.dec_out.auipc != dec_out.auipc) return 0;
    //if (rhs_trans.dec_out.lui != dec_out.lui) return 0;

    is_upper_imm = (dec_out.lui || dec_out.auipc);

    if (dec_out.imm != rhs_trans.dec_out.imm) begin
      `uvm_error(get_full_name(), "Immediate MISMATCH");
      return 0;
    end
    if (!is_upper_imm && !rhs_trans.dec_out.jal && (dec_out.br || dec_out.alu)) begin
      if (dec_out.rs1_addr != rhs_trans.dec_out.rs1_addr) begin
        `uvm_error(get_full_name(), "RS1 MISMATCH");
        return 0;
      end
    end
    if (!is_upper_imm && !rhs_trans.dec_out.jal &&
        (dec_out.br || (dec_out.alu && !rhs_trans.dec_out.use_imm))) begin
      if (dec_out.rs2_addr != rhs_trans.dec_out.rs2_addr) begin
        `uvm_error(get_full_name(), "RS2 MISMATCH");
        return 0;
      end
    end
    if (dec_out.alu) begin
      if (dec_out.rd_addr != rhs_trans.dec_out.rd_addr) begin
        `uvm_error(get_full_name(), "RD MISMATCH");
        return 0;
      end
    end
    return 1;

  endfunction : compare

endclass : riscv_decoder_transaction

`endif
