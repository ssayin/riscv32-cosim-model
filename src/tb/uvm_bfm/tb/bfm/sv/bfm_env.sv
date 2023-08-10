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
// Code created by Easier UVM Code Generator version 2017-01-19 on Fri Aug 11 03:44:41 2023
//=============================================================================
// Description: Environment for bfm
//=============================================================================

`ifndef BFM_ENV_SV
`define BFM_ENV_SV

// You can insert code here by setting top_env_inc_before_class in file tools/gen/axi4bfm/common.tpl

class bfm_env extends uvm_env;

  `uvm_component_utils(bfm_env)

  extern function new(string name, uvm_component parent);


  // Child agents
  axi4_config    m_axi4_config;  
  axi4_agent     m_axi4_agent;   
  axi4_coverage  m_axi4_coverage;

  bfm_config     m_config;
      
  // You can remove build/connect/run_phase by setting top_env_generate_methods_inside_class = no in file tools/gen/axi4bfm/common.tpl

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern task          run_phase(uvm_phase phase);

  // You can insert code here by setting top_env_inc_inside_class in file tools/gen/axi4bfm/common.tpl

endclass : bfm_env 


function bfm_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


// You can remove build/connect/run_phase by setting top_env_generate_methods_after_class = no in file tools/gen/axi4bfm/common.tpl

function void bfm_env::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "In build_phase", UVM_HIGH)

  // You can insert code here by setting top_env_prepend_to_build_phase in file tools/gen/axi4bfm/common.tpl

  if (!uvm_config_db #(bfm_config)::get(this, "", "config", m_config)) 
    `uvm_error(get_type_name(), "Unable to get bfm_config")

  m_axi4_config = m_config.m_axi4_config;

  // You can insert code here by setting agent_copy_config_vars in file tools/gen/axi4bfm/axi4.tpl

  uvm_config_db #(axi4_config)::set(this, "m_axi4_agent", "config", m_axi4_config);
  if (m_axi4_config.is_active == UVM_ACTIVE )
    uvm_config_db #(axi4_config)::set(this, "m_axi4_agent.m_sequencer", "config", m_axi4_config);
  uvm_config_db #(axi4_config)::set(this, "m_axi4_coverage", "config", m_axi4_config);


  m_axi4_agent    = axi4_agent   ::type_id::create("m_axi4_agent", this);
  m_axi4_coverage = axi4_coverage::type_id::create("m_axi4_coverage", this);

  // You can insert code here by setting top_env_append_to_build_phase in file tools/gen/axi4bfm/common.tpl

endfunction : build_phase


function void bfm_env::connect_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "In connect_phase", UVM_HIGH)

  m_axi4_agent.analysis_port.connect(m_axi4_coverage.analysis_export);


  // You can insert code here by setting top_env_append_to_connect_phase in file tools/gen/axi4bfm/common.tpl

endfunction : connect_phase


// You can remove end_of_elaboration_phase by setting top_env_generate_end_of_elaboration = no in file tools/gen/axi4bfm/common.tpl

function void bfm_env::end_of_elaboration_phase(uvm_phase phase);
  uvm_factory factory = uvm_factory::get();
  `uvm_info(get_type_name(), "Information printed from bfm_env::end_of_elaboration_phase method", UVM_MEDIUM)
  `uvm_info(get_type_name(), $sformatf("Verbosity threshold is %d", get_report_verbosity_level()), UVM_MEDIUM)
  uvm_top.print_topology();
  factory.print();
endfunction : end_of_elaboration_phase


// You can remove run_phase by setting top_env_generate_run_phase = no in file tools/gen/axi4bfm/common.tpl

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

  // You can insert code here by setting top_env_append_to_run_phase in file tools/gen/axi4bfm/common.tpl

endtask : run_phase


// You can insert code here by setting top_env_inc_after_class in file tools/gen/axi4bfm/common.tpl

`endif // BFM_ENV_SV

