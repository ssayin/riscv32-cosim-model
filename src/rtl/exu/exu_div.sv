// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module exu_div (
  input  logic              en,
  input  logic [      31:0] a,
  input  logic [      31:0] b,
  input  logic [AluOpW-1:0] alu_op,
  output logic [      31:0] res
);

  always_comb begin
    if (en) begin
      case (alu_op)
        //ALU_DIV:
        //ALU_DIVU:
        //ALU_REM:
        //ALU_REMU:
        default: res = 32'h0;
      endcase
    end else res = 32'h0;
  end
endmodule

