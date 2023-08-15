// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;
// This module is used mainly as a DUT for testing other decoder modules.

import svdpi_pkg::ctl_pkt_t;

module riscv_decoder (
  input  logic                    clk,       // unused
  input  logic                    rst_n,     // unused
  input  logic     [        31:0] instr,
  input  logic     [   DataW-1:0] pc,
  output logic     [   DataW-1:0] imm,
  output logic     [RegAddrW-1:0] rd_addr,   // DO NOT ASSIGN
  output logic     [RegAddrW-1:0] rs1_addr,  // DO NOT ASSIGN
  output logic     [RegAddrW-1:0] rs2_addr,  // DO NOT ASSIGN
  output logic                    rd_en,
  output ctl_pkt_t                ctl,
  output logic                    use_imm,
  output logic     [  AluOpW-1:0] alu_op,
  output logic     [  LsuOpW-1:0] lsu_op
);

  logic comp;

  assign comp = ~(instr[0] & instr[1]);

  decode_gpr dec_gpr (.*);

  decode_ctrl_imm dec_ctrl_imm (
    .clk    (clk),
    .rst_n  (rst_n),
    .instr  (instr),
    .comp   (comp),
    .imm    (imm),
    .rd_en  (rd_en),
    .alu    (ctl.alu),
    .lsu    (ctl.lsu),
    .br     (ctl.br),
    .jal    (jal2),
    .fencei (ctl.fencei),
    .fence  (ctl.fence),
    .illegal(ctl.illegal),
    .auipc  (ctl.auipc),
    .lui    (ctl.lui),
    .use_imm(use_imm),
    .alu_op (alu_op),
    .lsu_op (lsu_op),
    .csr    (ctl.csr)
  );

  decode_jal dec_jal_0 (
    .instr(instr[15:0]),
    .jal  (jal1)
  );


  decode_jalr dec_jalr_0 (
    .instr(instr[15:0]),
    .jalr (jal3)
  );


  assign ctl.jal = jal1 || jal2 || jal3;
endmodule
