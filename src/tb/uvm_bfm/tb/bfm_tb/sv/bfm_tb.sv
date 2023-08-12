// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: bfm_tb.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 12:32:06 2023
//=============================================================================
// Description: Testbench
//=============================================================================

module bfm_untimed_tb;

  timeunit      1ns;
  timeprecision 1ps;

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  import bfm_test_pkg::*;
  import bfm_pkg::bfm_config;

  // Configuration object for top-level environment
  bfm_config top_env_config;

  initial
  begin
    // Create and populate top-level configuration object
    top_env_config = new("top_env_config");
    if ( !top_env_config.randomize() )
      `uvm_error("bfm_untimed_tb", "Failed to randomize top-level configuration object" )

    top_env_config.m_axi4_config.vif = bfm_hdl_th.axi4_bfm_0;

    uvm_config_db #(bfm_config)::set(null, "uvm_test_top", "config", top_env_config);
    uvm_config_db #(bfm_config)::set(null, "uvm_test_top.m_env", "config", top_env_config);

    run_test();
  end

endmodule

