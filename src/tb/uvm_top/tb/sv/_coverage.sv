// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_top
//
// File Name: _coverage.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 02:59:40 2023
//=============================================================================
// Description: Coverage for agent 
//=============================================================================

`ifndef _COVERAGE_SV
`define _COVERAGE_SV

class _coverage extends uvm_subscriber #();

  `uvm_component_utils(_coverage)

  _config m_config;    
  bit     m_is_covered;
          m_item;
     
  covergroup m_cov;
    option.per_instance = 1;
    // You may insert additional coverpoints here ...

  endgroup

  extern function new(string name, uvm_component parent);
  extern function void write(input  t);
  extern function void build_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);

endclass : _coverage 


function _coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  m_is_covered = 0;
  m_cov = new();
endfunction : new


function void _coverage::write(input  t);
  if (m_config.coverage_enable)
  begin
    m_item = t;
    m_cov.sample();
    // Check coverage - could use m_cov.option.goal instead of 100 if your simulator supports it
    if (m_cov.get_inst_coverage() >= 100) m_is_covered = 1;
  end
endfunction : write


function void _coverage::build_phase(uvm_phase phase);
  if (!uvm_config_db #(_config)::get(this, "", "config", m_config))
    `uvm_error(get_type_name(), " config not found")
endfunction : build_phase


function void _coverage::report_phase(uvm_phase phase);
  if (m_config.coverage_enable)
    `uvm_info(get_type_name(), $sformatf("Coverage score = %3.1f%%", m_cov.get_inst_coverage()), UVM_MEDIUM)
  else
    `uvm_info(get_type_name(), "Coverage disabled for this agent", UVM_MEDIUM)
endfunction : report_phase


`endif // _COVERAGE_SV

