// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4_agent.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 06:57:02 2023
//=============================================================================
// Description: Agent for axi4
//=============================================================================

`ifndef AXI4_AGENT_SV
`define AXI4_AGENT_SV

class axi4_agent extends uvm_agent;

  `uvm_component_utils(axi4_agent)

  uvm_analysis_port #(axi4_tx) analysis_port;

  axi4_config       m_config;
  axi4_sequencer_t  m_sequencer;
  axi4_driver       m_driver;
  axi4_monitor      m_monitor;

  local int m_is_active = -1;

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function uvm_active_passive_enum get_is_active();

endclass : axi4_agent 


function  axi4_agent::new(string name, uvm_component parent);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new


function void axi4_agent::build_phase(uvm_phase phase);

  if (!uvm_config_db #(axi4_config)::get(this, "", "config", m_config))
    `uvm_error(get_type_name(), "axi4 config not found")

  m_monitor     = axi4_monitor    ::type_id::create("m_monitor", this);

  if (get_is_active() == UVM_ACTIVE)
  begin
    m_driver    = axi4_driver     ::type_id::create("m_driver", this);
    m_sequencer = axi4_sequencer_t::type_id::create("m_sequencer", this);
  end

endfunction : build_phase


function void axi4_agent::connect_phase(uvm_phase phase);
  if (m_config.vif == null)
    `uvm_warning(get_type_name(), "axi4 virtual interface is not set!")

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


function uvm_active_passive_enum axi4_agent::get_is_active();
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


`endif // AXI4_AGENT_SV
