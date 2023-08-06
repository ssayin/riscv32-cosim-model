// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module riscv_decoder_j_no_rr_imm (
  input  logic [31:0] instr,
  output logic [31:0] imm
);
  logic [31:0] i;
  assign i[31:0] = instr[31:0];

  always_comb begin
    casez (instr)
      32'b?????????????????????????1101111: imm = {{12{i[31]}}, i[19:12], i[20], i[30:21], 1'b0};
      32'b?????????????????01???????????01: imm = {{21{i[12]}}, i[8], i[10:9], i[6], i[7], i[2], i[10], i[5:3], 1'b0};
      default:                              imm = 'h0;
    endcase
  end

endmodule
