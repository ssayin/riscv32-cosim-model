// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0
import defs_pkg::*;
// This module is used mainly as a DUT for testing other decoder modules.

import svdpi_pkg::ctl_pkt_t;

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

  id0_gpr dec_gpr (.*);

  id1_ctrl_imm dec_ctrl_imm (
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
    .csr       (ctl.csr)
  );

  decode_jal dec_jal_0 (
    .instr(instr[15:0]),
    .j    (jal1)
  );

  assign ctl.jal = jal1 || jal2;
endmodule
