// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module exu_bru (
  input  logic        en,
  input  logic [ 2:0] br_type,
  input  logic [31:0] a,
  input  logic [31:0] b,
  output logic        out
);
  always_comb begin
    if (en) begin
      case (br_type)
        BR_BEQ:  out = (a == b);
        BR_BGE:  out = ($signed(a) >= $signed(b));
        BR_BGEU: out = (a >= b);
        BR_BNEZ: out = (a != 0);
        BR_BLTU: out = (a < b);
        BR_BEQZ: out = (a == 0);
        BR_BLT:  out = ($signed(a) < $signed(b));
        BR_BNE:  out = (a != b);
        default: out = 'b0;
      endcase
    end else begin
      out = 'b0;
    end
  end
endmodule
