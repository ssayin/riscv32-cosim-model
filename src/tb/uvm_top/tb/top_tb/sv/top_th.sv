// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : ../tb/uvm_top
//
// File Name: top_th.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Jul 15 22:09:49 2023
//=============================================================================
// Description: Test Harness
//=============================================================================

module top_th;

  timeunit      1ns;
  timeprecision 1ps;


  // You can remove clock and reset below by setting th_generate_clock_and_reset = no in file common.tpl

  // Example clock and reset declarations
  logic clock = 0;
  logic reset;

  // Example clock generator process
  always #10 clock = ~clock;

  // Example reset generator process
  initial
  begin
    reset = 0;         // Active low reset in this example
    #75 reset = 1;
  end

  assign riscv_core_if_0.clk = clock;

  // You can insert code here by setting th_inc_inside_module in file common.tpl

  // Pin-level interfaces connected to DUT
  // You can remove interface instances by setting generate_interface_instance = no in the interface template file

  riscv_core_if  riscv_core_if_0 ();

  riscv_core uut (
    .clk         (riscv_core_if_0.clk),
    .rst_n       (riscv_core_if_0.rst_n),
    .mem_data_in (riscv_core_if_0.mem_data_in),
    .mem_ready   (riscv_core_if_0.mem_ready),
    .irq_external(riscv_core_if_0.irq_external),
    .irq_timer   (riscv_core_if_0.irq_timer),
    .irq_software(riscv_core_if_0.irq_software),
    .mem_data_out(riscv_core_if_0.mem_data_out),
    .mem_wr_en   (riscv_core_if_0.mem_wr_en),
    .mem_rd_en   (riscv_core_if_0.mem_rd_en),
    .mem_clk_en  (riscv_core_if_0.mem_clk_en),
    .mem_addr    (riscv_core_if_0.mem_addr)
  );

endmodule
