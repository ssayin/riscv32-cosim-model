// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_top
//
// File Name: riscv_core_config.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 03:07:16 2023
//=============================================================================
// Description: Configuration for agent riscv_core
//=============================================================================

`ifndef RISCV_CORE_CONFIG_SV
`define RISCV_CORE_CONFIG_SV

class riscv_core_config extends uvm_object;

  // Do not register config class with the factory

  virtual riscv_core_if    vif;
                  
  uvm_active_passive_enum  is_active = UVM_ACTIVE;
  bit                      coverage_enable;       
  bit                      checks_enable;         

  // You can insert variables here by setting config_var in file tools/config/uvm/tpl/top/riscv_core.tpl

  extern function new(string name = "");

endclass : riscv_core_config 


function riscv_core_config::new(string name = "");
  super.new(name);
endfunction : new


`endif // RISCV_CORE_CONFIG_SV

