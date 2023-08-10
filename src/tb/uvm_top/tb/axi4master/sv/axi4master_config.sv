// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : ../tb/uvm_top
//
// File Name: axi4master_config.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Wed Aug  9 22:00:38 2023
//=============================================================================
// Description: Configuration for agent axi4master
//=============================================================================

`ifndef AXI4MASTER_CONFIG_SV
`define AXI4MASTER_CONFIG_SV

// You can insert code here by setting agent_config_inc_before_class in file axi4master.tpl

class axi4master_config extends uvm_object;

  // Do not register config class with the factory

  virtual axi4master_bfm   vif;
                  
  uvm_active_passive_enum  is_active = UVM_ACTIVE;
  bit                      coverage_enable;       
  bit                      checks_enable;         

  // You can insert variables here by setting config_var in file axi4master.tpl

  // You can remove new by setting agent_config_generate_methods_inside_class = no in file axi4master.tpl

  extern function new(string name = "");

  // You can insert code here by setting agent_config_inc_inside_class in file axi4master.tpl

endclass : axi4master_config 


// You can remove new by setting agent_config_generate_methods_after_class = no in file axi4master.tpl

function axi4master_config::new(string name = "");
  super.new(name);
endfunction : new


// You can insert code here by setting agent_config_inc_after_class in file axi4master.tpl

`endif // AXI4MASTER_CONFIG_SV

