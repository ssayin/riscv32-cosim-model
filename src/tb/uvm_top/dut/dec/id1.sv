// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module id1 (
  input  logic                     clk,
  input  logic                     rst_n,
  input  logic                     flush_d1,
  input  logic [              4:0] rd_addr_d1,
  input  logic [             31:0] instr_d1,
  input  logic [             31:1] pc_d1,
  input  logic                     compressed_d1,
  input  logic                     br_d1,
  input  logic                     br_taken_d1,
  input  logic                     illegal_d1,
  output logic [             31:1] pc_e,
  output logic                     compressed_e,
  output logic                     br_e,
  output logic                     br_taken_e,
  output logic                     use_imm_e,
  output logic                     use_pc_e,
  output logic [             31:0] imm_e,
  output logic                     illegal_e,
  output logic                     alu_e,
  output logic [   AluOpWidth-1:0] alu_op_e,
  output logic [              4:0] rd_addr_e,
  output logic                     lsu_e,
  output logic [   LsuOpWidth-1:0] lsu_op_e,
  output logic [BranchOpWidth-1:0] br_op_e,
  output logic                     rd_en_e
);

  // Internal Signal Wires
  logic [             31:0] imm_next;
  logic                     use_imm_next;
  logic                     rd_en_next;
  logic                     use_pc_next;

  logic [   AluOpWidth-1:0] alu_op_next;
  logic [   LsuOpWidth-1:0] lsu_op_next;
  logic [BranchOpWidth-1:0] br_op_next;

  logic                     lsu_next;
  logic                     illegal_next;
  logic                     alu_next;

  riscv_decoder_ctl_imm dec_ctl_imm (
    .clk       (clk),
    .rst_n     (rst_n),
    .instr     (instr_d1),
    .compressed(compressed_d1),
    .imm       (imm_next),
    .rd_en     (rd_en_next),
    .use_imm   (use_imm_next),
    .use_pc    (use_pc_next),
    .alu_op    (alu_op_next),
    .lsu_op    (lsu_op_next),
    .br_op     (br_op_next),
    .lsu       (lsu_next),
    .alu       (alu_next),
    .illegal   (illegal_next)
  );

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      imm_e        <= 'h0;
      use_imm_e    <= 'b0;
      use_pc_e     <= 'b0;
      alu_op_e     <= 'h0;
      lsu_op_e     <= 'h0;
      rd_addr_e    <= 'h0;
      lsu_e        <= 'h0;
      alu_e        <= 'h0;
      br_e         <= 'h0;
      br_taken_e   <= 'h0;
      br_op_e      <= 'b0;
      pc_e         <= 'b0;
      compressed_e <= 'b0;
      illegal_e    <= 'b0;
      rd_en_e      <= 'b0;
    end else begin
      imm_e        <= imm_next;
      use_imm_e    <= use_imm_next;
      use_pc_e     <= use_pc_next;
      alu_op_e     <= alu_op_next;
      lsu_op_e     <= lsu_op_next;
      rd_addr_e    <= rd_addr_d1;
      rd_en_e      <= rd_en_next;
      br_op_e      <= br_op_next;
      br_e         <= br_d1;
      br_taken_e   <= br_taken_d1;
      pc_e         <= pc_d1;
      compressed_e <= compressed_d1;
    end
  end

endmodule : id1
