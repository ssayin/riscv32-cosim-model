// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_top
//
// File Name: _monitor.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 02:59:40 2023
//=============================================================================
// Description: Monitor for 
//=============================================================================

`ifndef _MONITOR_SV
`define _MONITOR_SV

class _monitor extends uvm_monitor;

  `uvm_component_utils(_monitor)

  virtual  vif;

  _config     m_config;

  uvm_analysis_port #() analysis_port;

  extern function new(string name, uvm_component parent);

endclass : _monitor 


function _monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new


`endif // _MONITOR_SV

