// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_top
//
// File Name: riscv_core_monitor.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 07:41:55 2023
//=============================================================================
// Description: Monitor for riscv_core
//=============================================================================

`ifndef RISCV_CORE_MONITOR_SV
`define RISCV_CORE_MONITOR_SV

class riscv_core_monitor extends uvm_monitor;

  `uvm_component_utils(riscv_core_monitor)

  virtual riscv_core_if vif;

  riscv_core_config     m_config;

  uvm_analysis_port #(riscv_core_tx) analysis_port;

  riscv_core_tx m_trans;

  extern function new(string name, uvm_component parent);

  // Methods run_phase, and do_mon generated by setting monitor_inc in file tools/config/uvm/tpl/top/riscv_core.tpl
  extern task run_phase(uvm_phase phase);
  extern task do_mon();

endclass : riscv_core_monitor 


function riscv_core_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new


task riscv_core_monitor::run_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "run_phase", UVM_HIGH)

  m_trans = riscv_core_tx::type_id::create("m_trans");
  do_mon();
endtask : run_phase


// Start of inlined include file src/tb/uvm_top/tb/include/riscv_core/riscv_core_do_mon.sv
task riscv_core_monitor::do_mon;
  forever @(posedge vif.clk)
  begin
    m_trans = riscv_core_tx::type_id::create("m_trans");
    m_trans.rdata = vif.rdata;
    analysis_port.write(m_trans);
  end
endtask
// End of inlined include file

`endif // RISCV_CORE_MONITOR_SV

