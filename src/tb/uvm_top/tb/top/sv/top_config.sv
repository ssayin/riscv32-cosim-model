// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : ../tb/uvm_top
//
// File Name: top_config.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Jul 31 18:05:18 2023
//=============================================================================
// Description: Configuration for top
//=============================================================================

`ifndef TOP_CONFIG_SV
`define TOP_CONFIG_SV

// You can insert code here by setting top_env_config_inc_before_class in file common.tpl

class top_config extends uvm_object;

  // Do not register config class with the factory

  rand busf_config  m_busf_config;
  rand busm_config  m_busm_config;

  // You can insert variables here by setting config_var in file common.tpl

  // You can remove new by setting top_env_config_generate_methods_inside_class = no in file common.tpl

  extern function new(string name = "");

  // You can insert code here by setting top_env_config_inc_inside_class in file common.tpl

endclass : top_config 


// You can remove new by setting top_env_config_generate_methods_after_class = no in file common.tpl

function top_config::new(string name = "");
  super.new(name);

  m_busf_config                 = new("m_busf_config");
  m_busf_config.is_active       = UVM_ACTIVE;          
  m_busf_config.checks_enable   = 1;                   
  m_busf_config.coverage_enable = 1;                   

  m_busm_config                 = new("m_busm_config");
  m_busm_config.is_active       = UVM_ACTIVE;          
  m_busm_config.checks_enable   = 1;                   
  m_busm_config.coverage_enable = 1;                   

  // You can insert code here by setting top_env_config_append_to_new in file common.tpl

endfunction : new


// You can insert code here by setting top_env_config_inc_after_class in file common.tpl

`endif // TOP_CONFIG_SV

