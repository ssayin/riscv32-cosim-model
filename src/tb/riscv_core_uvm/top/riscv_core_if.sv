// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

interface riscv_core_if (
  input logic clk,
  input logic rst_n
);


  logic [31:0] mem_data_in  [2];
  logic        mem_ready;
  logic        irq_external;
  logic        irq_timer;
  logic        irq_software;
  logic [31:0] mem_data_out [2];
  //output logic [            3:0] mem_wr_en,     // TODO: Alter after cache impl
  logic        mem_wr_en    [2];
  logic        mem_rd_en    [2];
  //output logic                   mem_valid[2],
  logic        mem_clk_en;
  logic [31:0] mem_addr     [2];

  clocking dr_cb @(posedge clk);
    input mem_data_in;
    input mem_ready;
    input irq_external;
    input irq_timer;
    input irq_software;

    output mem_data_out;
    output mem_wr_en;
    output mem_rd_en;
    output mem_clk_en;
    output mem_addr;
  endclocking : dr_cb


  modport DRV(clocking dr_cb, input clk, input rst_n);
endinterface : riscv_core_if

