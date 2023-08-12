// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_top
//
// File Name: top_test.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 12:32:06 2023
//=============================================================================
// Description: Test class for top (included in package top_test_pkg)
//=============================================================================

`ifndef TOP_TEST_SV
`define TOP_TEST_SV

class top_test extends uvm_test;

  `uvm_component_utils(top_test)

  top_env m_env;

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);

endclass : top_test


function top_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void top_test::build_phase(uvm_phase phase);

  // You could modify any test-specific configuration object variables here


  riscv_core_instr_feed_seq::type_id::set_type_override(riscv_core_default_seq::get_type());

  m_env = top_env::type_id::create("m_env", this);

endfunction : build_phase


`endif // TOP_TEST_SV

