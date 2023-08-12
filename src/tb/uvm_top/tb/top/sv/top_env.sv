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
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 07:41:55 2023
//=============================================================================
// Description: Environment for top
//=============================================================================

`ifndef TOP_ENV_SV
`define TOP_ENV_SV

class top_env extends uvm_env;

  `uvm_component_utils(top_env)

  extern function new(string name, uvm_component parent);


  // Child agents
  riscv_core_config    m_riscv_core_config;  
  riscv_core_agent     m_riscv_core_agent;   
  riscv_core_coverage  m_riscv_core_coverage;

  top_config           m_config;
            
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern task          run_phase(uvm_phase phase);

  // Start of inlined include file src/tb/uvm_top/tb/include/top/top_env_inc_inside_class.sv
    riscv_core_ref_model  m_ref_model;
    riscv_core_scoreboard m_scoreboard;
  
    // riscv_core_coverage #(riscv_core_transaction) coverage;
  // End of inlined include file

endclass : top_env 


function top_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void top_env::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "In build_phase", UVM_HIGH)

  if (!uvm_config_db #(top_config)::get(this, "", "config", m_config)) 
    `uvm_error(get_type_name(), "Unable to get top_config")

  m_riscv_core_config = m_config.m_riscv_core_config;

  uvm_config_db #(riscv_core_config)::set(this, "m_riscv_core_agent", "config", m_riscv_core_config);
  if (m_riscv_core_config.is_active == UVM_ACTIVE )
    uvm_config_db #(riscv_core_config)::set(this, "m_riscv_core_agent.m_sequencer", "config", m_riscv_core_config);
  uvm_config_db #(riscv_core_config)::set(this, "m_riscv_core_coverage", "config", m_riscv_core_config);


  m_riscv_core_agent    = riscv_core_agent   ::type_id::create("m_riscv_core_agent", this);
  m_riscv_core_coverage = riscv_core_coverage::type_id::create("m_riscv_core_coverage", this);

  // Start of inlined include file src/tb/uvm_top/tb/include/top/top_env_append_to_build_phase.sv
  m_ref_model = riscv_core_ref_model::type_id::create("m_ref_model", this);
  //coverage =
  //    riscv_core_coverage#(riscv_core_transaction)::type_id::create("coverage", this);
  m_scoreboard = riscv_core_scoreboard::type_id::create("m_scoreboard", this);
  
  // End of inlined include file

endfunction : build_phase


function void top_env::connect_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "In connect_phase", UVM_HIGH)

  m_riscv_core_agent.analysis_port.connect(m_riscv_core_coverage.analysis_export);


  // Start of inlined include file src/tb/uvm_top/tb/include/top/top_env_append_to_connect_phase.sv
  m_riscv_core_agent.m_driver.analysis_port.connect(m_ref_model.rm_export);
  m_riscv_core_agent.m_monitor.analysis_port.connect(m_scoreboard.mon2sb_export);
  //m_ref_model.rm2sb_port.connect(coverage.analysis_export);
  m_ref_model.rm2sb_port.connect(m_scoreboard.rm2sb_export);
  // End of inlined include file

endfunction : connect_phase


function void top_env::end_of_elaboration_phase(uvm_phase phase);
  uvm_factory factory = uvm_factory::get();
  `uvm_info(get_type_name(), "Information printed from top_env::end_of_elaboration_phase method", UVM_MEDIUM)
  `uvm_info(get_type_name(), $sformatf("Verbosity threshold is %d", get_report_verbosity_level()), UVM_MEDIUM)
  uvm_top.print_topology();
  factory.print();
endfunction : end_of_elaboration_phase


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

endtask : run_phase


`endif // TOP_ENV_SV

