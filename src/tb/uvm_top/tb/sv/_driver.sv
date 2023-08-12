// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_top
//
// File Name: _driver.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 02:59:40 2023
//=============================================================================
// Description: Driver for 
//=============================================================================

`ifndef _DRIVER_SV
`define _DRIVER_SV

class _driver extends uvm_driver #();

  `uvm_component_utils(_driver)

  virtual  vif;

  _config     m_config;

  extern function new(string name, uvm_component parent);

endclass : _driver 


function _driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


`endif // _DRIVER_SV

