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
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 04:22:47 2023
//=============================================================================
// Description: Environment for bfm
//=============================================================================

`ifndef BFM_ENV_SV
`define BFM_ENV_SV

class bfm_env extends uvm_env;

  `uvm_component_utils(bfm_env)

  extern function new(string name, uvm_component parent);


  // Child agents
  axi4ar_config    m_axi4ar_config;  
  axi4ar_agent     m_axi4ar_agent;   
  axi4ar_coverage  m_axi4ar_coverage;

  axi4aw_config    m_axi4aw_config;  
  axi4aw_agent     m_axi4aw_agent;   
  axi4aw_coverage  m_axi4aw_coverage;

  axi4b_config     m_axi4b_config;   
  axi4b_agent      m_axi4b_agent;    
  axi4b_coverage   m_axi4b_coverage; 

  axi4r_config     m_axi4r_config;   
  axi4r_agent      m_axi4r_agent;    
  axi4r_coverage   m_axi4r_coverage; 

  axi4w_config     m_axi4w_config;   
  axi4w_agent      m_axi4w_agent;    
  axi4w_coverage   m_axi4w_coverage; 

  bfm_config       m_config;
        
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

  m_axi4ar_config = m_config.m_axi4ar_config;

  uvm_config_db #(axi4ar_config)::set(this, "m_axi4ar_agent", "config", m_axi4ar_config);
  if (m_axi4ar_config.is_active == UVM_ACTIVE )
    uvm_config_db #(axi4ar_config)::set(this, "m_axi4ar_agent.m_sequencer", "config", m_axi4ar_config);
  uvm_config_db #(axi4ar_config)::set(this, "m_axi4ar_coverage", "config", m_axi4ar_config);

  m_axi4aw_config = m_config.m_axi4aw_config;

  uvm_config_db #(axi4aw_config)::set(this, "m_axi4aw_agent", "config", m_axi4aw_config);
  if (m_axi4aw_config.is_active == UVM_ACTIVE )
    uvm_config_db #(axi4aw_config)::set(this, "m_axi4aw_agent.m_sequencer", "config", m_axi4aw_config);
  uvm_config_db #(axi4aw_config)::set(this, "m_axi4aw_coverage", "config", m_axi4aw_config);

  m_axi4b_config = m_config.m_axi4b_config;

  uvm_config_db #(axi4b_config)::set(this, "m_axi4b_agent", "config", m_axi4b_config);
  if (m_axi4b_config.is_active == UVM_ACTIVE )
    uvm_config_db #(axi4b_config)::set(this, "m_axi4b_agent.m_sequencer", "config", m_axi4b_config);
  uvm_config_db #(axi4b_config)::set(this, "m_axi4b_coverage", "config", m_axi4b_config);

  m_axi4r_config = m_config.m_axi4r_config;

  uvm_config_db #(axi4r_config)::set(this, "m_axi4r_agent", "config", m_axi4r_config);
  if (m_axi4r_config.is_active == UVM_ACTIVE )
    uvm_config_db #(axi4r_config)::set(this, "m_axi4r_agent.m_sequencer", "config", m_axi4r_config);
  uvm_config_db #(axi4r_config)::set(this, "m_axi4r_coverage", "config", m_axi4r_config);

  m_axi4w_config = m_config.m_axi4w_config;

  uvm_config_db #(axi4w_config)::set(this, "m_axi4w_agent", "config", m_axi4w_config);
  if (m_axi4w_config.is_active == UVM_ACTIVE )
    uvm_config_db #(axi4w_config)::set(this, "m_axi4w_agent.m_sequencer", "config", m_axi4w_config);
  uvm_config_db #(axi4w_config)::set(this, "m_axi4w_coverage", "config", m_axi4w_config);


  m_axi4ar_agent    = axi4ar_agent   ::type_id::create("m_axi4ar_agent", this);
  m_axi4ar_coverage = axi4ar_coverage::type_id::create("m_axi4ar_coverage", this);

  m_axi4aw_agent    = axi4aw_agent   ::type_id::create("m_axi4aw_agent", this);
  m_axi4aw_coverage = axi4aw_coverage::type_id::create("m_axi4aw_coverage", this);

  m_axi4b_agent     = axi4b_agent    ::type_id::create("m_axi4b_agent", this);
  m_axi4b_coverage  = axi4b_coverage ::type_id::create("m_axi4b_coverage", this);

  m_axi4r_agent     = axi4r_agent    ::type_id::create("m_axi4r_agent", this);
  m_axi4r_coverage  = axi4r_coverage ::type_id::create("m_axi4r_coverage", this);

  m_axi4w_agent     = axi4w_agent    ::type_id::create("m_axi4w_agent", this);
  m_axi4w_coverage  = axi4w_coverage ::type_id::create("m_axi4w_coverage", this);

endfunction : build_phase


function void bfm_env::connect_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "In connect_phase", UVM_HIGH)

  m_axi4ar_agent.analysis_port.connect(m_axi4ar_coverage.analysis_export);

  m_axi4aw_agent.analysis_port.connect(m_axi4aw_coverage.analysis_export);

  m_axi4b_agent.analysis_port.connect(m_axi4b_coverage.analysis_export);

  m_axi4r_agent.analysis_port.connect(m_axi4r_coverage.analysis_export);

  m_axi4w_agent.analysis_port.connect(m_axi4w_coverage.analysis_export);


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
  vseq.m_axi4ar_agent = m_axi4ar_agent;
  vseq.m_axi4aw_agent = m_axi4aw_agent;
  vseq.m_axi4b_agent  = m_axi4b_agent; 
  vseq.m_axi4r_agent  = m_axi4r_agent; 
  vseq.m_axi4w_agent  = m_axi4w_agent; 
  vseq.m_config       = m_config;      
  vseq.set_starting_phase(phase);
  vseq.start(null);

endtask : run_phase


`endif // BFM_ENV_SV

