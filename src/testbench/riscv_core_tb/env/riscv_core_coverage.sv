`ifndef RISCV_CORE_COVERAGE
`define RISCV_CORE_COVERAGE

class riscv_core_coverage #(
    type T = riscv_core_transaction
) extends uvm_subscriber #(T);

  covergroup riscv_core_cg;
    option.per_instance = 1;
    option.goal = 100;

    riscv_core_instr: coverpoint cov_trans.dec_in.instr {bins instr_values[] = {[0 : 31]};}

    riscv_core_pc_in: coverpoint cov_trans.dec_in.pc_in {bins instr_values[] = {[0 : 31]};}

    riscv_core_alu: coverpoint cov_trans.dec_out.alu {bins low = {0}; bins high = {1};}

    riscv_core_illegal: coverpoint cov_trans.dec_out.illegal {bins low = {0}; bins high = {1};}

  endgroup : riscv_core_cg

  T cov_trans;
  `uvm_component_utils(riscv_core_coverage)

  function new(string name = "riscv_core_coverage", uvm_component parent = null);
    super.new(name, parent);
    riscv_core_cg = new();
  endfunction : new

  function void write(T t);
    cov_trans = t;
    riscv_core_cg.sample();
  endfunction : write

endclass : riscv_core_coverage

`endif
