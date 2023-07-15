// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module top_level
  import param_defs::*;
(
  input logic clk,
  input logic rst_n
);

  // logic [            3:0] mem_wr_en;  // TODO: Change this after cache impl.
  // Source
  logic [MemBusWidth-1:0] mem_data_in  [2];
  logic                   mem_ready;
  // IRQs
  logic                   irq_external;
  logic                   irq_timer;
  logic                   irq_software;
  // Memory signals
  logic                   mem_clk_en;
  logic [           10:0] address      [2];
  logic [           31:0] data         [2];
  logic                   rden         [2];
  logic                   wren         [2];
  logic [           31:0] q            [2];
  logic [           31:0] mem_addr     [2];

  // TODO: Drive these in TB
  //assign irq_external = 'b0;
  // assign irq_timer    = 'b0;
  // assign irq_software = 'b0;
  // TODO: Sync
  //assign mem_ready    = 'b1;

  //assign address[0] = mem_addr[0][10:0];
  // assign address[1] = mem_addr[1][10:0];


  // intel_ocram_drw_sedge intel_ocram_drw_sedge_inst (
  //     .address_a(address[0]),
  //    .address_b(address[1]),
  //   .clock    (clk),
  //  .data_a   (data[0]),
  // .data_b   (data[1]),
  //  .enable   (mem_clk_en),
  //   .rden_a   (rden[0]),
  //   .rden_b   (rden[1]),
  //   .wren_a   (wren[0]),
  //   .wren_b   (wren[1]),
  //  .q_a      (q[0]),
  //   .q_b      (q[1])
  // );


  // riscv_core core_0 (
  //     .clk         (clk),
  //     .rst_n       (rst_n),
  //     .mem_addr    (mem_addr),
  //     .mem_data_in (q),
  //     .mem_data_out(data),
  //     .mem_wr_en   (wren),
  //    .mem_rd_en   (rden),
  //   .mem_ready   (mem_ready),
  //  .irq_external(irq_external),
  //   .irq_timer   (irq_timer),
  //    .irq_software(irq_software),
  //    .mem_clk_en  (mem_clk_en)
  // );

endmodule : top_level
