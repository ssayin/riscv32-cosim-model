// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module decode_jalr (
  input  logic [15:0] instr,
  output logic        jalr
);
  always_comb begin
    casez ({
      16'h0, instr
    })
      C_JALR, C_JR, JALR: jalr = 1;
      default:            jalr = 0;
    endcase
  end
endmodule
