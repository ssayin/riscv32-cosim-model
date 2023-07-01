// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module ex_stage
  import param_defs::*;
(
  input  logic      clk,
  input  logic      rst_n,
  input  logic      rs1_data,
  input  logic      rs2_data,
  input  p_id_ex_t  p_id_ex,
  output p_ex_mem_t p_ex_mem
);
  logic [DataWidth-1:0] res_next;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      p_ex_mem.alu_res <= 'b0;
    end else begin
      p_ex_mem.alu_res <= res_next;
    end

  end

  alu alu_0 (
    .a     (use_imm ? imm : rs1_data),
    .b     (rs2_data),
    .alu_op(alu_op),
    .res   (res_next)
  );

endmodule : ex_stage
