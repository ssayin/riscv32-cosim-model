// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module _2_ex_stage
  import param_defs::*;
(
  input  logic                  i_clk,
  input  logic                  i_rst_n,
  input  logic [AluOpWidth-1:0] i_alu_op,
  input  logic [ DataWidth-1:0] i_rs1_data,
  input  logic [ DataWidth-1:0] i_rs2_data,
  input  logic [ DataWidth-1:0] i_imm,
  input  logic                  i_use_imm,
  output logic [ DataWidth-1:0] o_res
);
  logic [DataWidth-1:0] res;

  always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      o_res <= 'b0;
    end else begin
      o_res <= res;
    end

  end

  alu alu_0 (
    .i_a     (i_use_imm ? i_imm : i_rs1_data),
    .i_b     (i_rs2_data),
    .i_alu_op(i_alu_op),
    .o_res   (res)
  );

endmodule : _2_ex_stage
