// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_top
//
// File Name: riscv_core_agent.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Thu Mar 21 22:59:05 2024
//=============================================================================
// Description: Agent for riscv_core
//=============================================================================

`ifndef RISCV_CORE_AGENT_SV
`define RISCV_CORE_AGENT_SV

class riscv_core_agent extends uvm_agent;

  `uvm_component_utils(riscv_core_agent)

  uvm_analysis_port #(riscv_core_tx) analysis_port;

  riscv_core_config       m_config;
  riscv_core_sequencer_t  m_sequencer;
  riscv_core_driver       m_driver;
  riscv_core_monitor      m_monitor;

  local int m_is_active = -1;

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function uvm_active_passive_enum get_is_active();

endclass : riscv_core_agent 


function  riscv_core_agent::new(string name, uvm_component parent);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new


function void riscv_core_agent::build_phase(uvm_phase phase);

  if (!uvm_config_db #(riscv_core_config)::get(this, "", "config", m_config))
    `uvm_error(get_type_name(), "riscv_core config not found")

  m_monitor     = riscv_core_monitor    ::type_id::create("m_monitor", this);

  if (get_is_active() == UVM_ACTIVE)
  begin
    m_driver    = riscv_core_driver     ::type_id::create("m_driver", this);
    m_sequencer = riscv_core_sequencer_t::type_id::create("m_sequencer", this);
  end

endfunction : build_phase


function void riscv_core_agent::connect_phase(uvm_phase phase);
  if (m_config.vif == null)
    `uvm_warning(get_type_name(), "riscv_core virtual interface is not set!")

  m_monitor.vif      = m_config.vif;
  m_monitor.m_config = m_config;
  m_monitor.analysis_port.connect(analysis_port);

  if (get_is_active() == UVM_ACTIVE)
  begin
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
    m_driver.vif      = m_config.vif;
    m_driver.m_config = m_config;
  end

endfunction : connect_phase


function uvm_active_passive_enum riscv_core_agent::get_is_active();
  if (m_is_active == -1)
  begin
    if (uvm_config_db#(uvm_bitstream_t)::get(this, "", "is_active", m_is_active))
    begin
      if (m_is_active != m_config.is_active)
        `uvm_warning(get_type_name(), "is_active field in config_db conflicts with config object")
    end
    else 
      m_is_active = m_config.is_active;
  end
  return uvm_active_passive_enum'(m_is_active);
endfunction : get_is_active


// Start of inlined include file src/tb/uvm_top/tb/include/riscv_core/riscv_core_inc_after_class.sv
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
// End of inlined include file

`endif // RISCV_CORE_AGENT_SV

