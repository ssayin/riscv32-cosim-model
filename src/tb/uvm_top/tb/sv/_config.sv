// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_top
//
// File Name: _config.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 02:59:40 2023
//=============================================================================
// Description: Configuration for agent 
//=============================================================================

`ifndef _CONFIG_SV
`define _CONFIG_SV

class _config extends uvm_object;

  // Do not register config class with the factory

  virtual _if              vif;
                  
  uvm_active_passive_enum  is_active = UVM_ACTIVE;
  bit                      coverage_enable;       
  bit                      checks_enable;         

  // You can insert variables here by setting config_var in file 

  extern function new(string name = "");

endclass : _config 


function _config::new(string name = "");
  super.new(name);
endfunction : new


`endif // _CONFIG_SV

