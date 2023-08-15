// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module ifu_dec #(
    parameter int W = 1
) (
  input  logic            clk,
  input  logic            rst_n,
  input  logic [W*32-1:0] i32,
  output logic [W*32-1:0] jimm,
  output logic [   W-1:0] br,
  output logic [   W-1:0] jal,
  output logic [   W-1:0] jalr,
  output logic [   W-1:0] comp,
  output logic [ W*5-1:0] rd_addr,
  output logic [ W*5-1:0] rs1_addr,
  output logic [ W*5-1:0] rs2_addr
);

  genvar i;

  generate
    for (i = 0; i < W; i++) begin : g_ifu_dec_wide
      assign comp[i] = !(&i32[i*32+:2]);

      // verilog_format: off
      decode_jal_imm   dec_jal_imm   (.instr (i32[i*32+:32]),       .imm  (jimm[i*32+:32]));
      decode_br        dec_br        (.instr (i32[i*32+:16]),       .br   (br[i]));
      decode_jal       dec_jal       (.instr (i32[i*32+:16]),       .jal  (jal[i]));
      decode_jalr      dec_jalr      (.instr (i32[i*32+:16]),       .jalr (jalr[i]));
      // verilog_format: on

      decode_gpr dec_gpr (
        .clk     (clk),
        .rst_n   (rst_n),
        .instr   (i32[i*32+:32]),
        .comp    (comp[i]),
        .rd_addr (rd_addr[i*5+:5]),
        .rs1_addr(rs1_addr[i*5+:5]),
        .rs2_addr(rs2_addr[i*5+:5])
      );
    end

  endgenerate
endmodule
