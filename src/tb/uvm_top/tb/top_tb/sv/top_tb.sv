// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_top
//
// File Name: top_tb.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 06:57:02 2023
//=============================================================================
// Description: Testbench
//=============================================================================

module top_tb;

  timeunit      1ns;
  timeprecision 1ps;

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  import top_test_pkg::*;
  import top_pkg::top_config;

  // Configuration object for top-level environment
  top_config top_env_config;

  // Test harness
  top_th th();

  initial
  begin
    // Create and populate top-level configuration object
    top_env_config = new("top_env_config");
    if ( !top_env_config.randomize() )
      `uvm_error("top_tb", "Failed to randomize top-level configuration object" )

    top_env_config.m_riscv_core_config.vif = th.riscv_core_if_0;

    uvm_config_db #(top_config)::set(null, "uvm_test_top", "config", top_env_config);
    uvm_config_db #(top_config)::set(null, "uvm_test_top.m_env", "config", top_env_config);

    run_test();
  end

endmodule

