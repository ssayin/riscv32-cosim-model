// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4aw_config.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Thu Mar 21 22:59:05 2024
//=============================================================================
// Description: Configuration for agent axi4aw
//=============================================================================

`ifndef AXI4AW_CONFIG_SV
`define AXI4AW_CONFIG_SV

class axi4aw_config extends uvm_object;

  // Do not register config class with the factory

  virtual axi4aw_bfm       vif;
                  
  uvm_active_passive_enum  is_active = UVM_ACTIVE;
  bit                      coverage_enable;       
  bit                      checks_enable;         

  // You can insert variables here by setting config_var in file tools/config//uvm/tpl/bfm/axi4aw.tpl

  extern function new(string name = "");

endclass : axi4aw_config 


function axi4aw_config::new(string name = "");
  super.new(name);
endfunction : new


`endif // AXI4AW_CONFIG_SV

