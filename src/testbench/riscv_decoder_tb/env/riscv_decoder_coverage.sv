`ifndef RISCV_DECODER_COVERAGE
`define RISCV_DECODER_COVERAGE

class riscv_decoder_coverage #(
    type T = riscv_decoder_transaction
) extends uvm_subscriber #(T);

  covergroup riscv_decoder_cg;
    option.per_instance = 1;
    option.goal = 100;

    riscv_decoder_instr: coverpoint cov_trans.dec_in.instr {bins instr_values[] = {[0 : 31]};}

    riscv_decoder_pc_in: coverpoint cov_trans.dec_in.pc_in {bins instr_values[] = {[0 : 31]};}

    riscv_decoder_alu: coverpoint cov_trans.dec_out.alu {bins low = {0}; bins high = {1};}

    riscv_decoder_illegal: coverpoint cov_trans.dec_out.illegal {bins low = {0}; bins high = {1};}

  endgroup : riscv_decoder_cg

  T cov_trans;
  `uvm_component_utils(riscv_decoder_coverage)

  function new(string name = "riscv_decoder_coverage", uvm_component parent = null);
    super.new(name, parent);
    riscv_decoder_cg = new();
  endfunction : new

  function void write(T t);
    cov_trans = t;
    riscv_decoder_cg.sample();
  endfunction : write

endclass : riscv_decoder_coverage

`endif
