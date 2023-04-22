// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module top_level
  import param_defs::*;
(
  input logic clk,
  input logic rst_n
);
  // Sink
  logic [MemBusWidth-1:0] mem_data_out;
  logic [  WordWidth-1:0] mem_addr;
  logic [            3:0] mem_wr_en;  // TODO: Change this after cache impl.
  logic                   mem_rd_en;
  logic                   mem_valid;

  // Source
  logic [MemBusWidth-1:0] mem_data_in;
  logic                   mem_ready;

  // IRQs
  logic                   irq_external;
  logic                   irq_timer;
  logic                   irq_software;

  // TODO: Drive these in TB
  assign irq_external = 'b0;
  assign irq_timer    = 'b0;
  assign irq_software = 'b0;


  // TODO: Sync
  assign mem_ready    = 'b1;

  memory_model memory_model_O (
    .i_clk    (clk),
    .i_rst_n  (rst_n),
    .i_addr   (mem_addr),
    .i_wr_data(mem_data_out),
    .i_wr_en  (mem_wr_en),
    .o_rd_data(mem_data_in),
    .i_rd_en  (mem_rd_en)
  );

  riscv_core core_0 (
    .i_clk         (clk),
    .i_rst_n       (rst_n),
    .o_mem_addr    (mem_addr),
    .i_mem_data    (mem_data_in),
    .o_mem_data    (mem_data_out),
    .o_mem_wr_en   (mem_wr_en),
    .o_mem_rd_en   (mem_rd_en),
    .o_mem_valid   (mem_valid),
    .i_mem_ready   (mem_ready),
    .i_irq_external(irq_external),
    .i_irq_timer   (irq_timer),
    .i_irq_software(irq_software)
  );

endmodule : top_level
