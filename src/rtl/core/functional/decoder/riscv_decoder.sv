// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`include "riscv_opcodes.svh"
import param_defs::*;
import instr_defs::*;

// This module is used mainly as a TB.
module riscv_decoder (
    input  logic                        clk,       // unused
    input  logic                        rst_n,     // unused
    input  logic     [            31:0] instr,
    input  logic     [   DataWidth-1:0] pc,
    output logic     [   DataWidth-1:0] imm,
    output logic     [RegAddrWidth-1:0] rd_addr,   // DO NOT ASSIGN
    output logic     [RegAddrWidth-1:0] rs1_addr,  // DO NOT ASSIGN
    output logic     [RegAddrWidth-1:0] rs2_addr,  // DO NOT ASSIGN
    output logic                        rd_en,
    output ctl_pkt_t                    ctl,
    output logic                        use_imm,
    output logic     [  AluOpWidth-1:0] alu_op,
    output logic     [  LsuOpWidth-1:0] lsu_op
);

  logic compressed;

  assign compressed = ~(instr[0] & instr[1]);

  riscv_decoder_gpr dec_gpr (
      .clk       (clk),
      .rst_n     (rst_n),
      .instr     (instr),
      .compressed(compressed),
      .rd_addr   (rd_addr),
      .rs1_addr  (rs1_addr),
      .rs2_addr  (rs2_addr)
  );

  riscv_decoder_ctl_imm dec_ctl_imm (
      .clk       (clk),
      .rst_n     (rst_n),
      .instr     (instr),
      .compressed(compressed),
      .imm       (imm),
      .rd_en     (rd_en),
      .ctl       (ctl),
      .use_imm   (use_imm),
      .alu_op    (alu_op),
      .lsu_op    (lsu_op)
  );

endmodule
