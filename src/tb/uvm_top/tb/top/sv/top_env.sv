// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_top
//
// File Name: top_env.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Fri Aug 11 07:29:11 2023
//=============================================================================
// Description: Environment for top
//=============================================================================

`ifndef TOP_ENV_SV
`define TOP_ENV_SV

// You can insert code here by setting top_env_inc_before_class in file tools/gen/riscv_core/common.tpl

class top_env extends uvm_env;

  `uvm_component_utils(top_env)

  extern function new(string name, uvm_component parent);


  // Child agents
  riscv_core_config    m_riscv_core_config;  
  riscv_core_agent     m_riscv_core_agent;   
  riscv_core_coverage  m_riscv_core_coverage;

  top_config           m_config;
            
  // You can remove build/connect/run_phase by setting top_env_generate_methods_inside_class = no in file tools/gen/riscv_core/common.tpl

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern task          run_phase(uvm_phase phase);

  // You can insert code here by setting top_env_inc_inside_class in file tools/gen/riscv_core/common.tpl

endclass : top_env 


function top_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


// You can remove build/connect/run_phase by setting top_env_generate_methods_after_class = no in file tools/gen/riscv_core/common.tpl

function void top_env::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "In build_phase", UVM_HIGH)

  // You can insert code here by setting top_env_prepend_to_build_phase in file tools/gen/riscv_core/common.tpl

  if (!uvm_config_db #(top_config)::get(this, "", "config", m_config)) 
    `uvm_error(get_type_name(), "Unable to get top_config")

  m_riscv_core_config = m_config.m_riscv_core_config;

  // You can insert code here by setting agent_copy_config_vars in file tools/gen/riscv_core/riscv_core.tpl

  uvm_config_db #(riscv_core_config)::set(this, "m_riscv_core_agent", "config", m_riscv_core_config);
  if (m_riscv_core_config.is_active == UVM_ACTIVE )
    uvm_config_db #(riscv_core_config)::set(this, "m_riscv_core_agent.m_sequencer", "config", m_riscv_core_config);
  uvm_config_db #(riscv_core_config)::set(this, "m_riscv_core_coverage", "config", m_riscv_core_config);


  m_riscv_core_agent    = riscv_core_agent   ::type_id::create("m_riscv_core_agent", this);
  m_riscv_core_coverage = riscv_core_coverage::type_id::create("m_riscv_core_coverage", this);

  // You can insert code here by setting top_env_append_to_build_phase in file tools/gen/riscv_core/common.tpl

endfunction : build_phase


function void top_env::connect_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "In connect_phase", UVM_HIGH)

  m_riscv_core_agent.analysis_port.connect(m_riscv_core_coverage.analysis_export);


  // You can insert code here by setting top_env_append_to_connect_phase in file tools/gen/riscv_core/common.tpl

endfunction : connect_phase


// You can remove end_of_elaboration_phase by setting top_env_generate_end_of_elaboration = no in file tools/gen/riscv_core/common.tpl

function void top_env::end_of_elaboration_phase(uvm_phase phase);
  uvm_factory factory = uvm_factory::get();
  `uvm_info(get_type_name(), "Information printed from top_env::end_of_elaboration_phase method", UVM_MEDIUM)
  `uvm_info(get_type_name(), $sformatf("Verbosity threshold is %d", get_report_verbosity_level()), UVM_MEDIUM)
  uvm_top.print_topology();
  factory.print();
endfunction : end_of_elaboration_phase


// You can remove run_phase by setting top_env_generate_run_phase = no in file tools/gen/riscv_core/common.tpl

task top_env::run_phase(uvm_phase phase);
  top_default_seq vseq;
  vseq = top_default_seq::type_id::create("vseq");
  vseq.set_item_context(null, null);
  if ( !vseq.randomize() )
    `uvm_fatal(get_type_name(), "Failed to randomize virtual sequence")
  vseq.m_riscv_core_agent = m_riscv_core_agent;
  vseq.m_config           = m_config;          
  vseq.set_starting_phase(phase);
  vseq.start(null);

  // You can insert code here by setting top_env_append_to_run_phase in file tools/gen/riscv_core/common.tpl

endtask : run_phase


// You can insert code here by setting top_env_inc_after_class in file tools/gen/riscv_core/common.tpl

`endif // TOP_ENV_SV

