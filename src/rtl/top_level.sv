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
  logic [           31:0] mem_addr;
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
    .clk      (clk),
    .rst_n    (rst_n),
    .i_addr   (mem_addr),
    .i_wr_data(mem_data_out),
    .i_wr_en  (mem_wr_en),
    .o_rd_data(mem_data_in),
    .i_rd_en  (mem_rd_en)
  );

  riscv_core core_0 (
    .clk           (clk),
    .rst_n         (rst_n),
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

  logic [63:0] testA;
  logic [63:0] testB;

  intel_ocram_drw_sedge intel_ocram_drw_sedge_inst (
    .address_a('h2),
    .address_b('h2),
    .clock    (clk),
    .data_a   (1),
    .data_b   (1),
    .enable   (1),
    .rden_a   (1),
    .rden_b   (1),
    .wren_a   (1),
    .wren_b   (1),
    .q_a      (testA),
    .q_b      (testB)
  );

endmodule : top_level