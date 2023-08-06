// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module riscv_decoder_br (
  input  logic [15:0] instr,
  output logic        br
);

  always_comb begin
    casez (instr)
      16'b11????????????01, 16'b?1???????1100011, 16'b??0??????1100011: br = 1;
      default:                                                          br = 0;
    endcase
  end

endmodule
