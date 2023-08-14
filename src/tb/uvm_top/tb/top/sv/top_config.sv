// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_top
//
// File Name: top_config.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 04:22:47 2023
//=============================================================================
// Description: Configuration for top
//=============================================================================

`ifndef TOP_CONFIG_SV
`define TOP_CONFIG_SV

class top_config extends uvm_object;

  // Do not register config class with the factory

  rand riscv_core_config  m_riscv_core_config;

  // You can insert variables here by setting config_var in file tools/config/uvm/tpl/top.tpl

  extern function new(string name = "");

endclass : top_config 


function top_config::new(string name = "");
  super.new(name);

  m_riscv_core_config                 = new("m_riscv_core_config");
  m_riscv_core_config.is_active       = UVM_ACTIVE;                
  m_riscv_core_config.checks_enable   = 1;                         
  m_riscv_core_config.coverage_enable = 1;                         

endfunction : new


`endif // TOP_CONFIG_SV

