// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4aw_coverage.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 03:07:16 2023
//=============================================================================
// Description: Coverage for agent axi4aw
//=============================================================================

`ifndef AXI4AW_COVERAGE_SV
`define AXI4AW_COVERAGE_SV

class axi4aw_coverage extends uvm_subscriber #(axi4aw_tx);

  `uvm_component_utils(axi4aw_coverage)

  axi4aw_config m_config;    
  bit           m_is_covered;
  axi4aw_tx     m_item;
     
  covergroup m_cov;
    option.per_instance = 1;
    // You may insert additional coverpoints here ...

    cp_awid: coverpoint m_item.awid;
    //  Add bins here if required

    cp_awaddr: coverpoint m_item.awaddr;
    //  Add bins here if required

    cp_awlen: coverpoint m_item.awlen;
    //  Add bins here if required

    cp_awsize: coverpoint m_item.awsize;
    //  Add bins here if required

    cp_awburst: coverpoint m_item.awburst;
    //  Add bins here if required

    cp_awlock: coverpoint m_item.awlock;
    //  Add bins here if required

    cp_awcache: coverpoint m_item.awcache;
    //  Add bins here if required

    cp_awprot: coverpoint m_item.awprot;
    //  Add bins here if required

    cp_awvalid: coverpoint m_item.awvalid;
    //  Add bins here if required

    cp_awregion: coverpoint m_item.awregion;
    //  Add bins here if required

    cp_awqos: coverpoint m_item.awqos;
    //  Add bins here if required

    cp_awready: coverpoint m_item.awready;
    //  Add bins here if required

  endgroup

  extern function new(string name, uvm_component parent);
  extern function void write(input axi4aw_tx t);
  extern function void build_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);

endclass : axi4aw_coverage 


function axi4aw_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  m_is_covered = 0;
  m_cov = new();
endfunction : new


function void axi4aw_coverage::write(input axi4aw_tx t);
  if (m_config.coverage_enable)
  begin
    m_item = t;
    m_cov.sample();
    // Check coverage - could use m_cov.option.goal instead of 100 if your simulator supports it
    if (m_cov.get_inst_coverage() >= 100) m_is_covered = 1;
  end
endfunction : write


function void axi4aw_coverage::build_phase(uvm_phase phase);
  if (!uvm_config_db #(axi4aw_config)::get(this, "", "config", m_config))
    `uvm_error(get_type_name(), "axi4aw config not found")
endfunction : build_phase


function void axi4aw_coverage::report_phase(uvm_phase phase);
  if (m_config.coverage_enable)
    `uvm_info(get_type_name(), $sformatf("Coverage score = %3.1f%%", m_cov.get_inst_coverage()), UVM_MEDIUM)
  else
    `uvm_info(get_type_name(), "Coverage disabled for this agent", UVM_MEDIUM)
endfunction : report_phase


`endif // AXI4AW_COVERAGE_SV

