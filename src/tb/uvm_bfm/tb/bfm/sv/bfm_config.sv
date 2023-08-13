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
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 01:57:09 2023
//=============================================================================
// Description: Configuration for bfm
//=============================================================================

`ifndef BFM_CONFIG_SV
`define BFM_CONFIG_SV

class bfm_config extends uvm_object;

  // Do not register config class with the factory

  rand axi4ar_config  m_axi4ar_config;
  rand axi4aw_config  m_axi4aw_config;
  rand axi4b_config   m_axi4b_config; 
  rand axi4r_config   m_axi4r_config; 
  rand axi4w_config   m_axi4w_config; 

  // You can insert variables here by setting config_var in file tools/config/uvm/tpl/bfm.tpl

  extern function new(string name = "");

endclass : bfm_config 


function bfm_config::new(string name = "");
  super.new(name);

  m_axi4ar_config                 = new("m_axi4ar_config");
  m_axi4ar_config.is_active       = UVM_ACTIVE;            
  m_axi4ar_config.checks_enable   = 1;                     
  m_axi4ar_config.coverage_enable = 1;                     

  m_axi4aw_config                 = new("m_axi4aw_config");
  m_axi4aw_config.is_active       = UVM_ACTIVE;            
  m_axi4aw_config.checks_enable   = 1;                     
  m_axi4aw_config.coverage_enable = 1;                     

  m_axi4b_config                  = new("m_axi4b_config"); 
  m_axi4b_config.is_active        = UVM_ACTIVE;            
  m_axi4b_config.checks_enable    = 1;                     
  m_axi4b_config.coverage_enable  = 1;                     

  m_axi4r_config                  = new("m_axi4r_config"); 
  m_axi4r_config.is_active        = UVM_ACTIVE;            
  m_axi4r_config.checks_enable    = 1;                     
  m_axi4r_config.coverage_enable  = 1;                     

  m_axi4w_config                  = new("m_axi4w_config"); 
  m_axi4w_config.is_active        = UVM_ACTIVE;            
  m_axi4w_config.checks_enable    = 1;                     
  m_axi4w_config.coverage_enable  = 1;                     

endfunction : new


`endif // BFM_CONFIG_SV

