// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

interface riscv_core_if (
  input logic clk,
  input logic rst_n
);

  // Memory interface
  logic [31:0] mem_addr;
  logic [31:0] mem_data_out;
  logic [31:0] mem_data_in;
  logic [ 3:0] mem_wr_en;
  logic        mem_rd_en;
  logic        mem_valid;
  logic        mem_ready;

  // Interrupts
  logic        irq_external;
  logic        irq_timer;
  logic        irq_software;


  clocking dr_cb @(posedge clk);
    output mem_addr, mem_data_out, mem_wr_en, mem_rd_en, mem_valid;
    input mem_data_in, mem_ready, irq_external, irq_timer, irq_software;
  endclocking : dr_cb


  modport DRV(clocking dr_cb, input clk, input rst_n);

  clocking rc_cb @(negedge clk);
    input mem_addr, mem_data_out, mem_wr_en, mem_rd_en, mem_valid;
    output mem_data_in, mem_ready, irq_external, irq_timer, irq_software;
  endclocking : rc_cb


  modport RCV(clocking rc_cb, input clk, input rst_n);


endinterface : riscv_core_if

