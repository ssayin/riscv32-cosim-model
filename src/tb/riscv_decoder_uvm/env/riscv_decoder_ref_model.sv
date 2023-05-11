// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_DECODER_REF_MODEL
`define RISCV_DECODER_REF_MODEL

class riscv_decoder_ref_model extends uvm_component;
  import svdpi_pkg::*;

  `uvm_component_utils(riscv_decoder_ref_model)

  uvm_analysis_export #(riscv_decoder_transaction) rm_export;
  uvm_analysis_port #(riscv_decoder_transaction) rm2sb_port;
  riscv_decoder_transaction exp_trans, rm_trans;
  uvm_tlm_analysis_fifo #(riscv_decoder_transaction) rm_exp_fifo;

  function new(string name = "riscv_decoder_ref_model", uvm_component parent);
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

  task get_expected_transaction(riscv_decoder_transaction rm_trans);
    this.exp_trans = rm_trans;

    // Get decoded instruction
    // from the riscv32-decoder
    dpi_decoder_process(exp_trans.dec_in, exp_trans.dec_out);

    `uvm_info(get_full_name(), $sformatf("EXPECTED TRANSACTION FROM REF MODEL"), UVM_HIGH);

    // exp_trans.print();

    rm2sb_port.write(exp_trans);

  endtask : get_expected_transaction


endclass : riscv_decoder_ref_model

`endif
