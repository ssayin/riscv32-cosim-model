// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Project  : generated_tb
//
// File Name: riscv_core_config.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sun Jul  9 00:04:34 2023
//=============================================================================
// Description: Configuration for agent riscv_core
//=============================================================================

`ifndef RISCV_CORE_CONFIG_SV
`define RISCV_CORE_CONFIG_SV

// You can insert code here by setting agent_config_inc_before_class in file riscv_core.tpl

class riscv_core_config extends uvm_object;

  // Do not register config class with the factory

  virtual riscv_core_if    vif;
                  
  uvm_active_passive_enum  is_active = UVM_ACTIVE;
  bit                      coverage_enable;       
  bit                      checks_enable;         

  // You can insert variables here by setting config_var in file riscv_core.tpl

  // You can remove new by setting agent_config_generate_methods_inside_class = no in file riscv_core.tpl

  extern function new(string name = "");

  // You can insert code here by setting agent_config_inc_inside_class in file riscv_core.tpl

endclass : riscv_core_config 


// You can remove new by setting agent_config_generate_methods_after_class = no in file riscv_core.tpl

function riscv_core_config::new(string name = "");
  super.new(name);
endfunction : new


// You can insert code here by setting agent_config_inc_after_class in file riscv_core.tpl

`endif // RISCV_CORE_CONFIG_SV

