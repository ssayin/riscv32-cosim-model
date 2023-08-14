// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4r_coverage.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 18:56:08 2023
//=============================================================================
// Description: Coverage for agent axi4r
//=============================================================================

`ifndef AXI4R_COVERAGE_SV
`define AXI4R_COVERAGE_SV

class axi4r_coverage extends uvm_subscriber #(axi4r_tx);

  `uvm_component_utils(axi4r_coverage)

  axi4r_config m_config;    
  bit          m_is_covered;
  axi4r_tx     m_item;
     
  covergroup m_cov;
    option.per_instance = 1;
    // You may insert additional coverpoints here ...

    cp_rid: coverpoint m_item.rid;
    //  Add bins here if required

    cp_rdata: coverpoint m_item.rdata;
    //  Add bins here if required

    cp_rresp: coverpoint m_item.rresp;
    //  Add bins here if required

    cp_rlast: coverpoint m_item.rlast;
    //  Add bins here if required

    cp_rvalid: coverpoint m_item.rvalid;
    //  Add bins here if required

    cp_rready: coverpoint m_item.rready;
    //  Add bins here if required

  endgroup

  extern function new(string name, uvm_component parent);
  extern function void write(input axi4r_tx t);
  extern function void build_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);

endclass : axi4r_coverage 


function axi4r_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  m_is_covered = 0;
  m_cov = new();
endfunction : new


function void axi4r_coverage::write(input axi4r_tx t);
  if (m_config.coverage_enable)
  begin
    m_item = t;
    m_cov.sample();
    // Check coverage - could use m_cov.option.goal instead of 100 if your simulator supports it
    if (m_cov.get_inst_coverage() >= 100) m_is_covered = 1;
  end
endfunction : write


function void axi4r_coverage::build_phase(uvm_phase phase);
  if (!uvm_config_db #(axi4r_config)::get(this, "", "config", m_config))
    `uvm_error(get_type_name(), "axi4r config not found")
endfunction : build_phase


function void axi4r_coverage::report_phase(uvm_phase phase);
  if (m_config.coverage_enable)
    `uvm_info(get_type_name(), $sformatf("Coverage score = %3.1f%%", m_cov.get_inst_coverage()), UVM_MEDIUM)
  else
    `uvm_info(get_type_name(), "Coverage disabled for this agent", UVM_MEDIUM)
endfunction : report_phase


`endif // AXI4R_COVERAGE_SV

