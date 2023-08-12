// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: bfm_test.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 03:33:22 2023
//=============================================================================
// Description: Test class for bfm (included in package bfm_test_pkg)
//=============================================================================

`ifndef BFM_TEST_SV
`define BFM_TEST_SV

class bfm_test extends uvm_test;

  `uvm_component_utils(bfm_test)

  bfm_env m_env;

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);

endclass : bfm_test


function bfm_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void bfm_test::build_phase(uvm_phase phase);

  // You could modify any test-specific configuration object variables here



  m_env = bfm_env::type_id::create("m_env", this);

endfunction : build_phase


`endif // BFM_TEST_SV

