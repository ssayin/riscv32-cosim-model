// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_CORE_REF_MODEL
`define RISCV_CORE_REF_MODEL

class riscv_core_ref_model extends uvm_component;

  `uvm_component_utils(riscv_core_ref_model)

  uvm_analysis_export #(riscv_core_transaction)   rm_export;
  uvm_analysis_port #(riscv_core_transaction)     rm2sb_port;
  riscv_core_transaction                          exp_trans,   rm_trans;
  uvm_tlm_analysis_fifo #(riscv_core_transaction) rm_exp_fifo;

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

  task get_expected_transaction(riscv_core_transaction rm_trans);
    this.exp_trans = rm_trans;


    `uvm_info(get_full_name(), $sformatf("EXPECTED TRANSACTION FROM REF MODEL"), UVM_HIGH);

    // exp_trans.print();

    rm2sb_port.write(exp_trans);

  endtask : get_expected_transaction


endclass : riscv_core_ref_model

`endif
