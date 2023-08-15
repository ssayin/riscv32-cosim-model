// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module decode_jal (
  input  logic [15:0] instr,
  output logic        jal
);
  always_comb begin
    casez ({
      16'h0, instr
    })
      C_J, C_JAL, JAL: jal = 1;
      default:         jal = 0;
    endcase
  end
endmodule
