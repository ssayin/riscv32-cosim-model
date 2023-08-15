// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module dec (
  input  logic                 clk,
  input  logic                 rst_n,
  input  logic [          4:0] rd_addr_d,
  input  logic [         31:0] instr_d,
  input  logic                 jal_d,
  output logic                 jal_e,
  input  logic [         31:1] pc_d,
  input  logic                 exu_pc_redir_en,
  input  logic                 comp_d,
  input  logic                 br_d,
  input  logic                 br_ataken_d,
  input  logic                 illegal_d,
  input  logic                 br_misp_m,
  input  logic                 valid_d,
  output logic [         31:1] pc_e,
  output logic                 comp_e,
  output logic                 br_e,
  output logic                 br_ataken_e,
  output logic                 use_imm_e,
  output logic                 use_pc_e,
  output logic [         31:0] imm_e,
  output logic                 illegal_e,
  output logic                 alu_e,
  output logic [   AluOpW-1:0] alu_op_e,
  output logic [          4:0] rd_addr_e,
  output logic                 lsu_e,
  output logic [   LsuOpW-1:0] lsu_op_e,
  output logic [BranchOpW-1:0] br_op_e,
  output logic                 rd_en_e,
  input  logic                 jalr_d,
  output logic                 jalr_e,
  output logic                 valid_e
);

  // Internal Signal Wires
  logic [         31:0] imm;
  logic                 use_imm;
  logic                 rd_en;
  logic                 use_pc;
  logic [   AluOpW-1:0] alu_op;
  logic [   LsuOpW-1:0] lsu_op;
  logic [BranchOpW-1:0] br_op;
  logic                 lsu;
  logic                 illegal;
  logic                 alu;
  // Debug
  logic                 br;
  logic                 jal;
  logic                 csr;
  logic                 fence;
  logic                 fencei;
  logic                 auipc;
  logic                 lui;

  decode_ctrl_imm dec_ctrl_imm (
    .instr(instr_d),
    .comp (comp_d),
    .*
  );

  // verilog_format: off
  mydff #(.W(5))  rd_addrff (.*, .din(rd_addr_d), .dout(rd_addr_e));
  mydff #(.W(32)) immff     (.*, .din(imm),  .dout(imm_e));

  mydff #(.W(AluOpW))    alu_opff (.*, .din(alu_op), .dout(alu_op_e));
  mydff #(.W(LsuOpW))    lsu_opff (.*, .din(lsu_op), .dout(lsu_op_e));
  mydff #(.W(BranchOpW)) br_opff  (.*, .din(br_op),  .dout(br_op_e));

  mydff #(.W(31), .L(1)) pcff (.*, .din(pc_d), .dout(pc_e));

  mydffsclr rd_enff     (.*, .clr(exu_pc_redir_en), .din(rd_en),      .dout(rd_en_e));
  mydffsclr aluff       (.*, .clr(exu_pc_redir_en), .din(alu),        .dout(alu_e));
  mydffsclr lsuff       (.*, .clr(exu_pc_redir_en), .din(lsu),        .dout(lsu_e));
  mydffsclr brff        (.*, .clr(exu_pc_redir_en), .din(br_d),       .dout(br_e));
  mydffsclr validff     (.*, .clr(exu_pc_redir_en), .din(valid_d),    .dout(valid_e));
  mydffsclr jalff       (.*, .clr(exu_pc_redir_en), .din(jal_d),      .dout(jal_e));
  mydffsclr jalrff      (.*, .clr(exu_pc_redir_en), .din(jalr_d),     .dout(jalr_e));

  mydff br_atakenff (.*, .din(br_ataken_d),  .dout(br_ataken_e));
  mydff compff      (.*, .din(comp_d),       .dout(comp_e));
  mydff illegalff   (.*, .din(illegal),      .dout(illegal_e));
  mydff use_immff   (.*, .din(use_imm),      .dout(use_imm_e));
  mydff use_pcff    (.*, .din(use_pc),       .dout(use_pc_e));
  // verilog_format: on

endmodule : dec
