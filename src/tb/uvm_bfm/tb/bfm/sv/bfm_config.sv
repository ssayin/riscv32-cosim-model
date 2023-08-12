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
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 06:44:54 2023
//=============================================================================
// Description: Configuration for bfm
//=============================================================================

`ifndef BFM_CONFIG_SV
`define BFM_CONFIG_SV

class bfm_config extends uvm_object;

  // Do not register config class with the factory

  rand axi4_config  m_axi4_config;

  // You can insert variables here by setting config_var in file tools/config/uvm/tpl/bfm.tpl

  extern function new(string name = "");

endclass : bfm_config 


function bfm_config::new(string name = "");
  super.new(name);

  m_axi4_config                 = new("m_axi4_config");
  m_axi4_config.is_active       = UVM_ACTIVE;          
  m_axi4_config.checks_enable   = 1;                   
  m_axi4_config.coverage_enable = 1;                   

endfunction : new


`endif // BFM_CONFIG_SV

