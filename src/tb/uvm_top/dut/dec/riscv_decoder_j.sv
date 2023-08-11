// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0
import defs_pkg::*;
module riscv_decoder_j (
  input  logic [15:0] instr,
  output logic        j
);
  always_comb begin
    casez (instr)
      16'b100??????0000010: j = 1;
      16'b?000?????110?111: j = 1;
      16'b?????????1101111: j = 1;
      16'b?01???????????01: j = 1;
      default:              j = 0;
    endcase
  end
endmodule
