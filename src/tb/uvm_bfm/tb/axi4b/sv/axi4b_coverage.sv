// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4b_coverage.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 07:56:24 2023
//=============================================================================
// Description: Coverage for agent axi4b
//=============================================================================

`ifndef AXI4B_COVERAGE_SV
`define AXI4B_COVERAGE_SV

class axi4b_coverage extends uvm_subscriber #(axi4b_tx);

  `uvm_component_utils(axi4b_coverage)

  axi4b_config m_config;    
  bit          m_is_covered;
  axi4b_tx     m_item;
     
  covergroup m_cov;
    option.per_instance = 1;
    // You may insert additional coverpoints here ...

    cp_bid: coverpoint m_item.bid;
    //  Add bins here if required

    cp_bresp: coverpoint m_item.bresp;
    //  Add bins here if required

    cp_bvalid: coverpoint m_item.bvalid;
    //  Add bins here if required

    cp_bready: coverpoint m_item.bready;
    //  Add bins here if required

  endgroup

  extern function new(string name, uvm_component parent);
  extern function void write(input axi4b_tx t);
  extern function void build_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);

endclass : axi4b_coverage 


function axi4b_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  m_is_covered = 0;
  m_cov = new();
endfunction : new


function void axi4b_coverage::write(input axi4b_tx t);
  if (m_config.coverage_enable)
  begin
    m_item = t;
    m_cov.sample();
    // Check coverage - could use m_cov.option.goal instead of 100 if your simulator supports it
    if (m_cov.get_inst_coverage() >= 100) m_is_covered = 1;
  end
endfunction : write


function void axi4b_coverage::build_phase(uvm_phase phase);
  if (!uvm_config_db #(axi4b_config)::get(this, "", "config", m_config))
    `uvm_error(get_type_name(), "axi4b config not found")
endfunction : build_phase


function void axi4b_coverage::report_phase(uvm_phase phase);
  if (m_config.coverage_enable)
    `uvm_info(get_type_name(), $sformatf("Coverage score = %3.1f%%", m_cov.get_inst_coverage()), UVM_MEDIUM)
  else
    `uvm_info(get_type_name(), "Coverage disabled for this agent", UVM_MEDIUM)
endfunction : report_phase


`endif // AXI4B_COVERAGE_SV

