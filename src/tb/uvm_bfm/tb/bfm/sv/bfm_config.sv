// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: bfm_config.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 00:42:54 2023
//=============================================================================
// Description: Configuration for bfm
//=============================================================================

`ifndef BFM_CONFIG_SV
`define BFM_CONFIG_SV

// You can insert code here by setting top_env_config_inc_before_class in file tools/gen/axi4bfm/common.tpl

class bfm_config extends uvm_object;

  // Do not register config class with the factory

  rand axi4_config  m_axi4_config;

  // You can insert variables here by setting config_var in file tools/gen/axi4bfm/common.tpl

  // You can remove new by setting top_env_config_generate_methods_inside_class = no in file tools/gen/axi4bfm/common.tpl

  extern function new(string name = "");

  // You can insert code here by setting top_env_config_inc_inside_class in file tools/gen/axi4bfm/common.tpl

endclass : bfm_config 


// You can remove new by setting top_env_config_generate_methods_after_class = no in file tools/gen/axi4bfm/common.tpl

function bfm_config::new(string name = "");
  super.new(name);

  m_axi4_config                 = new("m_axi4_config");
  m_axi4_config.is_active       = UVM_ACTIVE;          
  m_axi4_config.checks_enable   = 1;                   
  m_axi4_config.coverage_enable = 1;                   

  // You can insert code here by setting top_env_config_append_to_new in file tools/gen/axi4bfm/common.tpl

endfunction : new


// You can insert code here by setting top_env_config_inc_after_class in file tools/gen/axi4bfm/common.tpl

`endif // BFM_CONFIG_SV

