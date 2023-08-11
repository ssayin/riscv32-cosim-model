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
// Code created by Easier UVM Code Generator version 2017-01-19 on Fri Aug 11 07:29:11 2023
//=============================================================================
// Description: Driver for riscv_core
//=============================================================================

`ifndef RISCV_CORE_DRIVER_SV
`define RISCV_CORE_DRIVER_SV

// You can insert code here by setting driver_inc_before_class in file tools/gen/riscv_core/riscv_core.tpl

class riscv_core_driver extends uvm_driver #(riscv_core_tx);

  `uvm_component_utils(riscv_core_driver)

  virtual riscv_core_if vif;

  riscv_core_config     m_config;

  extern function new(string name, uvm_component parent);

  // Start of inlined include file src/tb/uvm_top/tb/include/riscv_core_driver_inc_inside_class.sv
  typedef enum logic [1:0] {
    IDLE,
    PREBURST,
    BURST
  } axi_state_t;
  
  axi_state_t state = IDLE;
  
  bit [7:0] arburst_counter = 0;
  bit [1:0] arburst;
  
  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info(get_type_name(), {"req item\n", req.sprint}, UVM_HIGH)
      do_drive();
      seq_item_port.item_done();
    end
  endtask : run_phase
  
  task do_drive();
    case (state)
      IDLE: begin
        if (vif.arvalid) begin
          arburst_counter <= vif.arlen + 1;
          arburst         <= vif.arburst;
          state           <= PREBURST;
          vif.rvalid      <= 0;
          vif.arready     <= 1;
        end
        vif.rlast <= 0;
      end
      PREBURST: begin
        if (vif.arvalid && vif.arready) begin
          state       <= BURST;
          vif.rdata   <= req.rdata;
          vif.rvalid  <= 1;
          vif.arready <= 0;
        end
        vif.rlast <= 0;
      end
      BURST: begin
        vif.rlast <= 0;
        if (vif.rvalid && vif.rready) begin
          arburst_counter <= arburst_counter - 1;
          vif.rdata       <= req.rdata;
          vif.rvalid      <= 1;
          vif.arready     <= 0;
        end
        if (arburst_counter == 0) begin
          state     <= IDLE;
          vif.rlast <= 1;
        end
      end
      default: begin
      end
    endcase
    @(posedge vif.clk);
  endtask : do_drive
  
  // End of inlined include file

endclass : riscv_core_driver 


function riscv_core_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


// You can insert code here by setting driver_inc_after_class in file tools/gen/riscv_core/riscv_core.tpl

`endif // RISCV_CORE_DRIVER_SV

