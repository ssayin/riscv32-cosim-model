// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_top
//
// File Name: riscv_core_coverage.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 16:23:52 2023
//=============================================================================
// Description: Coverage for agent riscv_core
//=============================================================================

`ifndef RISCV_CORE_COVERAGE_SV
`define RISCV_CORE_COVERAGE_SV

class riscv_core_coverage extends uvm_subscriber #(riscv_core_tx);

  `uvm_component_utils(riscv_core_coverage)

  riscv_core_config m_config;    
  bit               m_is_covered;
  riscv_core_tx     m_item;
     
  covergroup m_cov;
    option.per_instance = 1;
    // You may insert additional coverpoints here ...

    cp_rdata: coverpoint m_item.rdata;
    //  Add bins here if required

  endgroup

  extern function new(string name, uvm_component parent);
  extern function void write(input riscv_core_tx t);
  extern function void build_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);

endclass : riscv_core_coverage 


function riscv_core_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  m_is_covered = 0;
  m_cov = new();
endfunction : new


function void riscv_core_coverage::write(input riscv_core_tx t);
  if (m_config.coverage_enable)
  begin
    m_item = t;
    m_cov.sample();
    // Check coverage - could use m_cov.option.goal instead of 100 if your simulator supports it
    if (m_cov.get_inst_coverage() >= 100) m_is_covered = 1;
  end
endfunction : write


function void riscv_core_coverage::build_phase(uvm_phase phase);
  if (!uvm_config_db #(riscv_core_config)::get(this, "", "config", m_config))
    `uvm_error(get_type_name(), "riscv_core config not found")
endfunction : build_phase


function void riscv_core_coverage::report_phase(uvm_phase phase);
  if (m_config.coverage_enable)
    `uvm_info(get_type_name(), $sformatf("Coverage score = %3.1f%%", m_cov.get_inst_coverage()), UVM_MEDIUM)
  else
    `uvm_info(get_type_name(), "Coverage disabled for this agent", UVM_MEDIUM)
endfunction : report_phase


`endif // RISCV_CORE_COVERAGE_SV

