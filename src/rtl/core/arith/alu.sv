// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module alu
  import instr_defs::*;
  import param_defs::*;
(
  input  logic [ DataWidth-1:0] i_a,
  input  logic [ DataWidth-1:0] i_b,
  input  logic [AluOpWidth-1:0] i_alu_op,
  output logic [ DataWidth-1:0] o_res
);

  always_comb begin
    case (i_alu_op)
      ALU_ADD:  o_res = i_a + i_b;
      ALU_SUB:  o_res = i_a - i_b;
      ALU_SLL:  o_res = i_a << i_b[4:0];
      ALU_SLT:  o_res = ($signed(i_a) < $signed(i_b)) ? 32'h1 : 32'h0;
      ALU_SLTU: o_res = (i_a < i_b) ? 32'h1 : 32'h0;
      ALU_XOR:  o_res = i_a ^ i_b;
      ALU_SRL:  o_res = i_a >> i_b[4:0];
      ALU_SRA:  o_res = $signed(i_a) >>> i_b[4:0];
      ALU_OR:   o_res = i_a | i_b;
      ALU_AND:  o_res = i_a & i_b;

      // TODO
      ALU_MUL:    o_res = i_a * i_b;
      ALU_MULH:   o_res = i_a * i_b;
      ALU_MULHSU: o_res = i_a * i_b;
      ALU_MULHU:  o_res = i_a * i_b;
      ALU_DIV:    o_res = i_a * i_b;
      ALU_DIVU:   o_res = i_a * i_b;
      ALU_REM:    o_res = i_a * i_b;
      ALU_REMU:   o_res = i_a * i_b;
      default:    o_res = 'h0;
    endcase
  end

endmodule
