`ifndef RISCV_CORE_SCOREBOARD
`define RISCV_CORE_SCOREBOARD


import svdpi_pkg::*;

class riscv_core_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(riscv_core_scoreboard)

  uvm_analysis_export #(riscv_core_transaction)   rm2sb_export,          mon2sb_export;
  uvm_tlm_analysis_fifo #(riscv_core_transaction) rm2sb_export_fifo,     mon2sb_export_fifo;
  riscv_core_transaction                          exp_trans,             act_trans;
  riscv_core_transaction                          exp_trans_fifo    [$], act_trans_fifo     [$];
  bit                                             error;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rm2sb_export       = new("rm2sb_export", this);
    mon2sb_export      = new("mon2sb_export", this);
    rm2sb_export_fifo  = new("rm2sb_export_fifo", this);
    mon2sb_export_fifo = new("mon2sb_export_fifo", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    rm2sb_export.connect(rm2sb_export_fifo.analysis_export);
    mon2sb_export.connect(mon2sb_export_fifo.analysis_export);
  endfunction : connect_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      mon2sb_export_fifo.get(act_trans);
      if (act_trans == null) $stop;
      act_trans_fifo.push_back(act_trans);
      rm2sb_export_fifo.get(exp_trans);
      if (exp_trans == null) $stop;
      exp_trans_fifo.push_back(exp_trans);
      compare_trans();
    end
  endtask : run_phase

  task compare_trans();
    riscv_core_transaction exp_trans, act_trans;

    if ((exp_trans_fifo.size == 0) || (act_trans_fifo.size == 0)) return;

    exp_trans = exp_trans_fifo.pop_front();
    act_trans = act_trans_fifo.pop_front();

    if (exp_trans.compare(act_trans)) begin
      `uvm_info(get_full_name(), $sformatf("MATCH SUCCEEDED"), UVM_LOW);
    end else begin
      disas(exp_trans.dec_in);
      `uvm_error(get_full_name(), $sformatf("MISMATCH"));
      act_trans.print();
      exp_trans.print();
      error = 1;
    end

  endtask : compare_trans

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    if (error == 0) begin
      $write("%c[7;32m", 27);
      $display("PASS");
      $write("%c[0m", 27);
    end else begin
      $write("%c[7;31m", 27);
      $display("FAIL");
      $write("%c[0m", 27);
    end
  endfunction : report_phase
endclass : riscv_core_scoreboard

`endif
