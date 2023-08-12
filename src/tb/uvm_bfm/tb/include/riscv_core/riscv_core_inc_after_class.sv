// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_CORE_REF_MODEL
`define RISCV_CORE_REF_MODEL

class riscv_core_ref_model extends uvm_component;
  `uvm_component_utils(riscv_core_ref_model)

  uvm_analysis_export #(riscv_core_tx)   rm_export;
  uvm_analysis_port #(riscv_core_tx)     rm2sb_port;
  riscv_core_tx                          exp_trans,   rm_trans;
  uvm_tlm_analysis_fifo #(riscv_core_tx) rm_exp_fifo;

  function new(string name = "riscv_core_ref_model", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rm_export   = new("rm_export", this);
    rm2sb_port  = new("rm2sb_port", this);
    rm_exp_fifo = new("rm_exp_fifo", this);
  endfunction : build_phase


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    rm_export.connect(rm_exp_fifo.analysis_export);
  endfunction : connect_phase

  task run_phase(uvm_phase phase);
    forever begin
      rm_exp_fifo.get(rm_trans);
      get_expected_transaction(rm_trans);
    end
  endtask : run_phase

  task get_expected_transaction(riscv_core_tx rm_trans);
    this.exp_trans = rm_trans;

    // Get decoded instruction
    // from the riscv32-decoder
    //dpi_decoder_process(exp_trans.dec_in, exp_trans.dec_out);

    `uvm_info(get_full_name(), $sformatf("EXPECTED TRANSACTION FROM REF MODEL"), UVM_HIGH);

    // exp_trans.print();

    rm2sb_port.write(exp_trans);

  endtask : get_expected_transaction


endclass : riscv_core_ref_model

class riscv_core_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(riscv_core_scoreboard)

  uvm_analysis_export #(riscv_core_tx)   rm2sb_export,          mon2sb_export;
  uvm_tlm_analysis_fifo #(riscv_core_tx) rm2sb_export_fifo,     mon2sb_export_fifo;
  riscv_core_tx                          exp_trans,             act_trans;
  riscv_core_tx                          exp_trans_fifo    [$], act_trans_fifo     [$];
  bit                                    error;

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
    riscv_core_tx exp_trans, act_trans;

    if ((exp_trans_fifo.size == 0) || (act_trans_fifo.size == 0)) return;

    exp_trans = exp_trans_fifo.pop_front();
    act_trans = act_trans_fifo.pop_front();

    if (exp_trans.compare(act_trans)) begin
      `uvm_info(get_full_name(), $sformatf("MATCH SUCCEEDED"), UVM_LOW);
    end else begin
      // disas(exp_trans.dec_in);
      act_trans.print();
      exp_trans.print();
      error = 1;
      $finish;
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
