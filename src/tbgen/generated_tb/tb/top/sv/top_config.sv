// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Project  : generated_tb
//
// File Name: top_config.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Thu Jul  6 15:14:09 2023
//=============================================================================
// Description: Configuration for top
//=============================================================================

`ifndef TOP_CONFIG_SV
`define TOP_CONFIG_SV

// You can insert code here by setting top_env_config_inc_before_class in file common.tpl

class top_config extends uvm_object;

  // Do not register config class with the factory

  virtual riscv_core_if    riscv_core_vif;            

  uvm_active_passive_enum  is_active_riscv_core       = UVM_ACTIVE;
  bit                      checks_enable_riscv_core;  
  bit                      coverage_enable_riscv_core;

  // You can insert variables here by setting config_var in file common.tpl

  // You can remove new by setting top_env_config_generate_methods_inside_class = no in file common.tpl

  extern function new(string name = "");

  // You can insert code here by setting top_env_config_inc_inside_class in file common.tpl

endclass : top_config 


// You can remove new by setting top_env_config_generate_methods_after_class = no in file common.tpl

function top_config::new(string name = "");
  super.new(name);

  // You can insert code here by setting top_env_config_append_to_new in file common.tpl

endfunction : new


// You can insert code here by setting top_env_config_inc_after_class in file common.tpl

`endif // TOP_CONFIG_SV

