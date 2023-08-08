// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

// This module is used mainly as a DUT for testing other decoder modules.

typedef struct {
  logic alu;
  logic lsu;
  logic lui;
  logic auipc;
  logic br;
  logic jal;
  logic csr;
  logic fencei;
  logic fence;
  logic illegal;
} ctl_pkt_t;

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
    .alu       (ctl.alu),
    .lsu       (ctl.lsu),
    .br        (ctl.br),
    .jal       (jal2),
    .fencei    (ctl.fencei),
    .fence     (ctl.fence),
    .illegal   (ctl.illegal),
    .auipc     (ctl.auipc),
    .lui       (ctl.lui),
    .use_imm   (use_imm),
    .alu_op    (alu_op),
    .lsu_op    (lsu_op),
    .csr(ctl.csr)
  );

  riscv_decoder_j_no_rr jnorr (
    .instr(instr[15:0]),
    .j    (jal1)
  );


  assign ctl.jal = jal1 || jal2;

endmodule
