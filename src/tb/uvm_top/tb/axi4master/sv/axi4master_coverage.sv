// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : ../tb/uvm_top
//
// File Name: axi4master_coverage.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Jul 31 20:36:58 2023
//=============================================================================
// Description: Coverage for agent axi4master
//=============================================================================

`ifndef AXI4MASTER_COVERAGE_SV
`define AXI4MASTER_COVERAGE_SV

// You can insert code here by setting agent_cover_inc_before_class in file axi4master.tpl

class axi4master_coverage extends uvm_subscriber #(axi4_tx);

  `uvm_component_utils(axi4master_coverage)

  axi4master_config m_config;    
  bit               m_is_covered;
  axi4_tx           m_item;
     
  // You can replace covergroup m_cov by setting agent_cover_inc in file axi4master.tpl
  // or remove covergroup m_cov by setting agent_cover_generate_methods_inside_class = no in file axi4master.tpl

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

    cp_wdata: coverpoint m_item.wdata;
    //  Add bins here if required

    cp_wstrb: coverpoint m_item.wstrb;
    //  Add bins here if required

    cp_wlast: coverpoint m_item.wlast;
    //  Add bins here if required

    cp_wvalid: coverpoint m_item.wvalid;
    //  Add bins here if required

    cp_wready: coverpoint m_item.wready;
    //  Add bins here if required

    cp_bid: coverpoint m_item.bid;
    //  Add bins here if required

    cp_bresp: coverpoint m_item.bresp;
    //  Add bins here if required

    cp_bvalid: coverpoint m_item.bvalid;
    //  Add bins here if required

    cp_bready: coverpoint m_item.bready;
    //  Add bins here if required

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

  // You can remove new, write, and report_phase by setting agent_cover_generate_methods_inside_class = no in file axi4master.tpl

  extern function new(string name, uvm_component parent);
  extern function void write(input axi4_tx t);
  extern function void build_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);

  // You can insert code here by setting agent_cover_inc_inside_class in file axi4master.tpl

endclass : axi4master_coverage 


// You can remove new, write, and report_phase by setting agent_cover_generate_methods_after_class = no in file axi4master.tpl

function axi4master_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  m_is_covered = 0;
  m_cov = new();
endfunction : new


function void axi4master_coverage::write(input axi4_tx t);
  if (m_config.coverage_enable)
  begin
    m_item = t;
    m_cov.sample();
    // Check coverage - could use m_cov.option.goal instead of 100 if your simulator supports it
    if (m_cov.get_inst_coverage() >= 100) m_is_covered = 1;
  end
endfunction : write


function void axi4master_coverage::build_phase(uvm_phase phase);
  if (!uvm_config_db #(axi4master_config)::get(this, "", "config", m_config))
    `uvm_error(get_type_name(), "axi4master config not found")
endfunction : build_phase


function void axi4master_coverage::report_phase(uvm_phase phase);
  if (m_config.coverage_enable)
    `uvm_info(get_type_name(), $sformatf("Coverage score = %3.1f%%", m_cov.get_inst_coverage()), UVM_MEDIUM)
  else
    `uvm_info(get_type_name(), "Coverage disabled for this agent", UVM_MEDIUM)
endfunction : report_phase


// You can insert code here by setting agent_cover_inc_after_class in file axi4master.tpl

`endif // AXI4MASTER_COVERAGE_SV

