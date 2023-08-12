// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: bfm_env.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 12:32:06 2023
//=============================================================================
// Description: Environment for bfm
//=============================================================================

`ifndef BFM_ENV_SV
`define BFM_ENV_SV

class bfm_env extends uvm_env;

  `uvm_component_utils(bfm_env)

  extern function new(string name, uvm_component parent);


  // Child agents
  axi4_config    m_axi4_config;  
  axi4_agent     m_axi4_agent;   
  axi4_coverage  m_axi4_coverage;

  bfm_config     m_config;
      
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern task          run_phase(uvm_phase phase);

endclass : bfm_env 


function bfm_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void bfm_env::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "In build_phase", UVM_HIGH)

  if (!uvm_config_db #(bfm_config)::get(this, "", "config", m_config)) 
    `uvm_error(get_type_name(), "Unable to get bfm_config")

  m_axi4_config = m_config.m_axi4_config;

  uvm_config_db #(axi4_config)::set(this, "m_axi4_agent", "config", m_axi4_config);
  if (m_axi4_config.is_active == UVM_ACTIVE )
    uvm_config_db #(axi4_config)::set(this, "m_axi4_agent.m_sequencer", "config", m_axi4_config);
  uvm_config_db #(axi4_config)::set(this, "m_axi4_coverage", "config", m_axi4_config);


  m_axi4_agent    = axi4_agent   ::type_id::create("m_axi4_agent", this);
  m_axi4_coverage = axi4_coverage::type_id::create("m_axi4_coverage", this);

endfunction : build_phase


function void bfm_env::connect_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "In connect_phase", UVM_HIGH)

  m_axi4_agent.analysis_port.connect(m_axi4_coverage.analysis_export);


endfunction : connect_phase


function void bfm_env::end_of_elaboration_phase(uvm_phase phase);
  uvm_factory factory = uvm_factory::get();
  `uvm_info(get_type_name(), "Information printed from bfm_env::end_of_elaboration_phase method", UVM_MEDIUM)
  `uvm_info(get_type_name(), $sformatf("Verbosity threshold is %d", get_report_verbosity_level()), UVM_MEDIUM)
  uvm_top.print_topology();
  factory.print();
endfunction : end_of_elaboration_phase


task bfm_env::run_phase(uvm_phase phase);
  bfm_default_seq vseq;
  vseq = bfm_default_seq::type_id::create("vseq");
  vseq.set_item_context(null, null);
  if ( !vseq.randomize() )
    `uvm_fatal(get_type_name(), "Failed to randomize virtual sequence")
  vseq.m_axi4_agent = m_axi4_agent;
  vseq.m_config     = m_config;    
  vseq.set_starting_phase(phase);
  vseq.start(null);

endtask : run_phase


`endif // BFM_ENV_SV

