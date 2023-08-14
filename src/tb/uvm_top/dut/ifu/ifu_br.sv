// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;
module ifu_br (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [63:0] wordline,
  output logic [31:1] pc_d0,
  output logic [31:1] pc,
  input  logic [ 4:0] seq_next,
  output logic [ 4:0] seq,
  input  logic [31:1] pc_m,
  input  logic        comp_m,
  input  logic        br_misp_m,
  input  logic        br_ataken_m,
  output logic        br_ataken_d0,
  output logic        br_d0
);
  logic        br_0;
  logic        br_1;
  logic        br_2;
  logic        br_3;

  logic        j_0;
  logic        j_1;
  logic        j_2;
  logic        j_3;

  logic [31:0] jimm_0;
  logic [31:0] jimm_1;
  logic [31:0] jimm_2;
  logic [31:0] jimm_3;

  logic        br_ataken;

  decode_jal_imm dec_jal_imm_0 (
    .instr(wordline[63:32]),
    .imm  (jimm_0)
  );

  decode_jal_imm dec_jal_imm_1 (
    .instr({16'h0, wordline[63:48]}),
    .imm  (jimm_1)
  );

  decode_jal_imm dec_jal_imm_2 (
    .instr(wordline[31:0]),
    .imm  (jimm_2)
  );

  decode_jal_imm dec_jal_imm_3 (
    .instr({16'h0, wordline[31:16]}),
    .imm  (jimm_3)
  );

  decode_br dec_br_0 (
    .instr(wordline[47:32]),
    .br   (br_0)
  );

  decode_jal dec_jal_0 (
    .instr(wordline[47:32]),
    .j    (j_0)
  );
  decode_br dec_br_1 (
    .instr(wordline[63:48]),
    .br   (br_1)
  );

  decode_jal dec_jal_1 (
    .instr(wordline[63:48]),
    .j    (j_1)
  );
  decode_br dec_br_2 (
    .instr(wordline[15:0]),
    .br   (br_2)
  );

  decode_jal dec_jal_2 (
    .instr(wordline[15:0]),
    .j    (j_2)
  );

  decode_br dec_br_3 (
    .instr(wordline[31:16]),
    .br   (br_3)
  );

  decode_jal dec_jal_3 (
    .instr(wordline[31:16]),
    .j    (j_3)
  );

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) pc <= 31'h0;
    else begin
      if (br_misp_m && br_ataken_m) pc <= pc_m + (comp_m ? 31'h1 : 31'h2);
      else begin
        case (seq)
          Sel0:    pc[31:1] <= take_jump_0 ? jimm_0[31:1] : (pc[31:1] + (comp_0 ? 31'h1 : 31'h2));
          Sel1:    pc[31:1] <= take_jump_1 ? jimm_1[31:1] : (pc[31:1] + (comp_1 ? 31'h1 : 31'h2));
          Sel2:    pc[31:1] <= take_jump_2 ? jimm_2[31:1] : (pc[31:1] + (comp_2 ? 31'h1 : 31'h2));
          Sel3:    pc[31:1] <= take_jump_3 ? jimm_3[31:1] : (pc[31:1] + (comp_3 ? 31'h1 : 31'h2));
          default: pc <= pc;
        endcase
      end
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) br_d0 <= 0;
    else begin
      if (br_misp_m && br_ataken_m) br_d0 <= 0;
      else begin
        case (seq)
          Sel0:    br_d0 <= br_0;
          Sel1:    br_d0 <= br_1;
          Sel2:    br_d0 <= br_2;
          Sel3:    br_d0 <= br_3;
          default: br_d0 <= 0;
        endcase
      end
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) seq <= SelW;
    else begin
      if (br_misp_m && br_ataken_m) seq <= SelW;
      else begin
        case (seq)
          Sel0:    seq <= take_jump_0 ? SelW : seq_next;
          Sel1:    seq <= take_jump_1 ? SelW : seq_next;
          Sel2:    seq <= take_jump_2 ? SelW : seq_next;
          Sel3:    seq <= take_jump_3 ? SelW : seq_next;
          default: seq <= SelW;
        endcase
      end
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) pc_d0[31:1] <= 31'h0;
    else pc_d0[31:1] <= pc[31:1];
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) br_ataken_d0 <= 0;
    else br_ataken_d0 <= br_ataken;
  end

  assign br_ataken   = 1'b0;
  assign br_d0       = 1'b0;

  assign comp_0      = !(wordline[32] && wordline[33]);
  assign comp_1      = !(wordline[48] && wordline[49]);
  assign comp_2      = !(wordline[0] && wordline[1]);
  assign comp_3      = !(wordline[16] && wordline[17]);

  // always prioritize mispredicted branches and exceptions
  assign take_jump_0 = j_0 && !br_misp_m;
  assign take_jump_1 = j_1 && !br_misp_m;
  assign take_jump_2 = j_2 && !br_misp_m;
  assign take_jump_3 = j_3 && !br_misp_m;

endmodule
