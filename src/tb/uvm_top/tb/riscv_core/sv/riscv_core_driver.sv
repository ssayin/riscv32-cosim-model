// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_top
//
// File Name: riscv_core_driver.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug 12 12:32:06 2023
//=============================================================================
// Description: Driver for riscv_core
//=============================================================================

`ifndef RISCV_CORE_DRIVER_SV
`define RISCV_CORE_DRIVER_SV

// Start of inlined include file src/tb/uvm_top/tb/include/riscv_core/riscv_core_driver_inc_before_class.sv
typedef enum logic [1:0] {
  IDLE,
  PREBURST,
  BURST
} axi_state_t;

class axi4_logic;
  axi_state_t       state           = IDLE;
  bit         [7:0] arburst_counter = 0;
  bit         [1:0] arburst;
endclass : axi4_logic
// End of inlined include file

class riscv_core_driver extends uvm_driver #(riscv_core_tx);

  `uvm_component_utils(riscv_core_driver)

  virtual riscv_core_if vif;

  riscv_core_config     m_config;

  extern function new(string name, uvm_component parent);

  // Methods run_phase and do_drive generated by setting driver_inc in file tools/config/uvm/tpl/top/riscv_core.tpl
  extern task run_phase(uvm_phase phase);
  extern task do_drive();

  // Start of inlined include file src/tb/uvm_top/tb/include/riscv_core/riscv_core_driver_inc_inside_class.sv
  uvm_analysis_export #(riscv_core_tx) analysis_port = new("analysis_port", this);
  axi4_logic m_axi4_logic = new();
  // End of inlined include file

endclass : riscv_core_driver 


function riscv_core_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


task riscv_core_driver::run_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "run_phase", UVM_HIGH)

  forever
  begin
    seq_item_port.get_next_item(req);
      `uvm_info(get_type_name(), {"req item\n",req.sprint}, UVM_HIGH)
    do_drive();
    seq_item_port.item_done();
  end
endtask : run_phase


// Start of inlined include file src/tb/uvm_top/tb/include/riscv_core/riscv_core_do_drive.sv
task riscv_core_driver::do_drive();
  case (m_axi4_logic.state)
    IDLE: begin
      if (vif.arvalid) begin
        m_axi4_logic.arburst_counter <= vif.arlen + 1;
        m_axi4_logic.arburst         <= vif.arburst;
        m_axi4_logic.state           <= PREBURST;
        vif.rvalid                   <= 0;
        vif.arready                  <= 1;
      end
      vif.rlast <= 0;
    end
    PREBURST: begin
      if (vif.arvalid && vif.arready) begin
        m_axi4_logic.state <= BURST;
        vif.rdata          <= req.rdata;
        vif.rvalid         <= 1;
        vif.arready        <= 0;
      end
      vif.rlast <= 0;
    end
    BURST: begin
      vif.rlast <= 0;
      if (vif.rvalid && vif.rready) begin
        m_axi4_logic.arburst_counter <= m_axi4_logic.arburst_counter - 1;
        vif.rdata                    <= req.rdata;
        vif.rvalid                   <= 1;
        vif.arready                  <= 0;
      end
      if (m_axi4_logic.arburst_counter == 0) begin
        m_axi4_logic.state <= IDLE;
        vif.rlast          <= 1;
      end
    end
    default: begin
    end
  endcase
  @(posedge vif.clk);
endtask : do_drive
// End of inlined include file

`endif // RISCV_CORE_DRIVER_SV

