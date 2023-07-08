// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Project  : generated_tb
//
// File Name: riscv_core_monitor.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sun Jul  9 00:13:28 2023
//=============================================================================
// Description: Monitor for riscv_core
//=============================================================================

`ifndef RISCV_CORE_MONITOR_SV
`define RISCV_CORE_MONITOR_SV

// You can insert code here by setting monitor_inc_before_class in file riscv_core.tpl

class riscv_core_monitor extends uvm_monitor;

  `uvm_component_utils(riscv_core_monitor)

  virtual riscv_core_if vif;

  riscv_core_config     m_config;

  uvm_analysis_port #(riscv_core_tx) analysis_port;

  riscv_core_tx m_trans;

  extern function new(string name, uvm_component parent);

  // Methods run_phase, and do_mon generated by setting monitor_inc in file riscv_core.tpl
  extern task run_phase(uvm_phase phase);
  extern task do_mon();

  // You can insert code here by setting monitor_inc_inside_class in file riscv_core.tpl

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


// Start of inlined include file generated_tb/tb/include/riscv_core_do_mon.sv
task riscv_core_monitor::do_mon;
  forever
    @(posedge vif.clk) begin
      m_trans                 = riscv_core_tx::type_id::create("m_trans");
      m_trans.mem_data_out[1] = vif.mem_data_out[1];
      m_trans.mem_wr_en[1]    = vif.mem_wr_en[1];
      m_trans.mem_rd_en[0]    = vif.mem_rd_en[0];
      m_trans.mem_rd_en[1]    = vif.mem_rd_en[1];
      m_trans.mem_clk_en      = vif.mem_clk_en;
      m_trans.mem_addr[0]     = vif.mem_addr[0];
      m_trans.mem_addr[1]     = vif.mem_addr[1];
      analysis_port.write(m_trans);
    end
endtask
// End of inlined include file

// You can insert code here by setting monitor_inc_after_class in file riscv_core.tpl

`endif // RISCV_CORE_MONITOR_SV

