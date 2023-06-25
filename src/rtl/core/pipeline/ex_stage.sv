// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module ex_stage
  import param_defs::*;
(
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic [AluOpWidth-1:0] alu_op,
    input  logic [ DataWidth-1:0] rs1_data,
    input  logic [ DataWidth-1:0] rs2_data,
    input  logic [ DataWidth-1:0] imm,
    input  logic                  use_imm,
    output logic [ DataWidth-1:0] res
);
  logic [DataWidth-1:0] res_next;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      res <= 'b0;
    end else begin
      res <= res_next;
    end

  end

  alu alu_0 (
      .a     (use_imm ? imm : rs1_data),
      .b     (rs2_data),
      .alu_op(alu_op),
      .res   (res_next)
  );

endmodule : ex_stage
