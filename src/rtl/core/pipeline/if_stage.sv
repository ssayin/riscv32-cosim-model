// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module if_stage
  import param_defs::*;
(
  input  logic                   clk,
  input  logic                   rst_n,
  input  logic [            2:0] pc_incr,
  input  logic [MemBusWidth-1:0] mem_rd,
  output logic [  DataWidth-1:0] pc,
  output logic [           31:0] instr
);

  logic [DataWidth-1:0] pc_next;
  always_comb begin
    pc_next = pc + pc_incr;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      pc <= 'h0;
    end else begin
      pc <= pc_next;
    end
  end

  always_comb begin
    if (mem_rd[1:0] == 2'b11) begin
      instr = {{mem_rd[31:24], mem_rd[23:16], mem_rd[15:8], mem_rd[7:0]}};
    end else begin
      instr = {{16'h0, mem_rd[15:8], mem_rd[7:0]}};
    end
  end

endmodule : if_stage
