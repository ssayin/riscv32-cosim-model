// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : ../tb/uvm_top
//
// File Name: riscv_core_agent.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Fri Jul 21 13:05:27 2023
//=============================================================================
// Description: Agent for riscv_core
//=============================================================================

`ifndef RISCV_CORE_AGENT_SV
`define RISCV_CORE_AGENT_SV

// You can insert code here by setting agent_inc_before_class in file riscv_core.tpl

class riscv_core_agent extends uvm_agent;

  `uvm_component_utils(riscv_core_agent)

  uvm_analysis_port #(riscv_core_tx) analysis_port;

  riscv_core_config       m_config;
  riscv_core_sequencer_t  m_sequencer;
  riscv_core_driver       m_driver;
  riscv_core_monitor      m_monitor;

  local int m_is_active = -1;

  extern function new(string name, uvm_component parent);

  // You can remove build/connect_phase and get_is_active by setting agent_generate_methods_inside_class = no in file riscv_core.tpl

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function uvm_active_passive_enum get_is_active();

  // You can insert code here by setting agent_inc_inside_class in file riscv_core.tpl

endclass : riscv_core_agent 


function  riscv_core_agent::new(string name, uvm_component parent);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new


// You can remove build/connect_phase and get_is_active by setting agent_generate_methods_after_class = no in file riscv_core.tpl

function void riscv_core_agent::build_phase(uvm_phase phase);

  // You can insert code here by setting agent_prepend_to_build_phase in file riscv_core.tpl

  if (!uvm_config_db #(riscv_core_config)::get(this, "", "config", m_config))
    `uvm_error(get_type_name(), "riscv_core config not found")

  m_monitor     = riscv_core_monitor    ::type_id::create("m_monitor", this);

  if (get_is_active() == UVM_ACTIVE)
  begin
    m_driver    = riscv_core_driver     ::type_id::create("m_driver", this);
    m_sequencer = riscv_core_sequencer_t::type_id::create("m_sequencer", this);
  end

  // You can insert code here by setting agent_append_to_build_phase in file riscv_core.tpl

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

  // You can insert code here by setting agent_append_to_connect_phase in file riscv_core.tpl

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


// You can insert code here by setting agent_inc_after_class in file riscv_core.tpl

`endif // RISCV_CORE_AGENT_SV

