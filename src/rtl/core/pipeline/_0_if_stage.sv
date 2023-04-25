// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module _0_if_stage
  import param_defs::*;
(
  input  logic                   clk,
  input  logic                   rst_n,
  input  logic [            2:0] i_pc_incr,
  input  logic [MemBusWidth-1:0] i_mem_rd,
  output logic [  DataWidth-1:0] o_pc,
  output logic [           31:0] o_instr
);

  logic [DataWidth-1:0] pc_next;
  always_comb begin
    pc_next = o_pc + i_pc_incr;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      o_pc <= 'h0;
    end else begin
      o_pc <= pc_next;
    end
  end

  always_comb begin
    if (i_mem_rd[1:0] == 2'b11) begin
      o_instr = {{i_mem_rd[31:24], i_mem_rd[23:16], i_mem_rd[15:8], i_mem_rd[7:0]}};
    end else begin
      o_instr = {{16'h0, i_mem_rd[15:8], i_mem_rd[7:0]}};
    end
  end

endmodule : _0_if_stage
