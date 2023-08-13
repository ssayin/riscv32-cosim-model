// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4ar_coverage.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 01:57:09 2023
//=============================================================================
// Description: Coverage for agent axi4ar
//=============================================================================

`ifndef AXI4AR_COVERAGE_SV
`define AXI4AR_COVERAGE_SV

class axi4ar_coverage extends uvm_subscriber #(axi4ar_tx);

  `uvm_component_utils(axi4ar_coverage)

  axi4ar_config m_config;    
  bit           m_is_covered;
  axi4ar_tx     m_item;
     
  covergroup m_cov;
    option.per_instance = 1;
    // You may insert additional coverpoints here ...

    cp_arid: coverpoint m_item.arid;
    //  Add bins here if required

    cp_araddr: coverpoint m_item.araddr;
    //  Add bins here if required

    cp_arlen: coverpoint m_item.arlen;
    //  Add bins here if required

    cp_arsize: coverpoint m_item.arsize;
    //  Add bins here if required

    cp_arburst: coverpoint m_item.arburst;
    //  Add bins here if required

    cp_arlock: coverpoint m_item.arlock;
    //  Add bins here if required

    cp_arcache: coverpoint m_item.arcache;
    //  Add bins here if required

    cp_arprot: coverpoint m_item.arprot;
    //  Add bins here if required

    cp_arvalid: coverpoint m_item.arvalid;
    //  Add bins here if required

    cp_arqos: coverpoint m_item.arqos;
    //  Add bins here if required

    cp_arregion: coverpoint m_item.arregion;
    //  Add bins here if required

    cp_arready: coverpoint m_item.arready;
    //  Add bins here if required

  endgroup

  extern function new(string name, uvm_component parent);
  extern function void write(input axi4ar_tx t);
  extern function void build_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);

endclass : axi4ar_coverage 


function axi4ar_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  m_is_covered = 0;
  m_cov = new();
endfunction : new


function void axi4ar_coverage::write(input axi4ar_tx t);
  if (m_config.coverage_enable)
  begin
    m_item = t;
    m_cov.sample();
    // Check coverage - could use m_cov.option.goal instead of 100 if your simulator supports it
    if (m_cov.get_inst_coverage() >= 100) m_is_covered = 1;
  end
endfunction : write


function void axi4ar_coverage::build_phase(uvm_phase phase);
  if (!uvm_config_db #(axi4ar_config)::get(this, "", "config", m_config))
    `uvm_error(get_type_name(), "axi4ar config not found")
endfunction : build_phase


function void axi4ar_coverage::report_phase(uvm_phase phase);
  if (m_config.coverage_enable)
    `uvm_info(get_type_name(), $sformatf("Coverage score = %3.1f%%", m_cov.get_inst_coverage()), UVM_MEDIUM)
  else
    `uvm_info(get_type_name(), "Coverage disabled for this agent", UVM_MEDIUM)
endfunction : report_phase


`endif // AXI4AR_COVERAGE_SV

