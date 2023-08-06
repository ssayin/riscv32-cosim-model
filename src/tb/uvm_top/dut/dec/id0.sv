// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module id0 (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        flush_d0,
  output logic [ 4:0] rd_addr_d1,
  output logic [ 4:0] rs1_addr_r,
  output logic [ 4:0] rs2_addr_r,
  input  logic [31:0] instr_d0,
  input  logic [31:1] pc_d0,
  input  logic        compressed_d0,
  input  logic        br_d0,
  input  logic        br_taken_d0,
  input  logic        illegal_d0,
  output logic [31:0] instr_d1,
  output logic [31:1] pc_d1,
  output logic        compressed_d1,
  output logic        br_d1,
  output logic        br_taken_d1,
  output logic        illegal_d1
);


  // Internal Signal Wires

  logic [4:0] rs1_addr_next;
  logic [4:0] rs2_addr_next;
  logic [4:0] rd_addr_next;

  riscv_decoder_gpr dec_gpr (
    .clk       (clk),
    .rst_n     (rst_n),
    .instr     (instr_d0),
    .compressed(compressed_d0),
    .rd_addr   (rd_addr_next),
    .rs1_addr  (rs1_addr_next),
    .rs2_addr  (rs2_addr_next)
  );

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      instr_d1      <= 32'h13;
      pc_d1         <= 0;
      compressed_d1 <= 0;
      br_d1         <= 0;
      br_taken_d1   <= 0;
      rd_addr_d1    <= 'h0;
      rs1_addr_r    <= 'h0;
      rs2_addr_r    <= 'h0;
      illegal_d1    <= 0;
    end else begin
      instr_d1      <= instr_d0;
      pc_d1         <= pc_d0;
      compressed_d1 <= compressed_d0;
      br_d1         <= br_d0;
      br_taken_d1   <= br_taken_d0;
      rd_addr_d1    <= rd_addr_next;
      rs1_addr_r    <= rs1_addr_next;
      rs2_addr_r    <= rs2_addr_next;
      illegal_d1    <= illegal_d0;
    end
  end

endmodule : id0
