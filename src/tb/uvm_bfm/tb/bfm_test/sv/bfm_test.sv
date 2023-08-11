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
// Code created by Easier UVM Code Generator version 2017-01-19 on Fri Aug 11 09:33:51 2023
//=============================================================================
// Description: Test class for bfm (included in package bfm_test_pkg)
//=============================================================================

`ifndef BFM_TEST_SV
`define BFM_TEST_SV

// You can insert code here by setting test_inc_before_class in file tools/gen/axi4bfm/common.tpl

class bfm_test extends uvm_test;

  `uvm_component_utils(bfm_test)

  bfm_env m_env;

  extern function new(string name, uvm_component parent);

  // You can remove build_phase method by setting test_generate_methods_inside_class = no in file tools/gen/axi4bfm/common.tpl

  extern function void build_phase(uvm_phase phase);

  // You can insert code here by setting test_inc_inside_class in file tools/gen/axi4bfm/common.tpl

endclass : bfm_test


function bfm_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


// You can remove build_phase method by setting test_generate_methods_after_class = no in file tools/gen/axi4bfm/common.tpl

function void bfm_test::build_phase(uvm_phase phase);

  // You can insert code here by setting test_prepend_to_build_phase in file tools/gen/axi4bfm/common.tpl

  // You could modify any test-specific configuration object variables here



  m_env = bfm_env::type_id::create("m_env", this);

  // You can insert code here by setting test_append_to_build_phase in file tools/gen/axi4bfm/common.tpl

endfunction : build_phase


// You can insert code here by setting test_inc_after_class in file tools/gen/axi4bfm/common.tpl

`endif // BFM_TEST_SV

