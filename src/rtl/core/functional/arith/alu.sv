// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import instr_defs::*;
import param_defs::*;

module alu (
    input  logic [ DataWidth-1:0] a,
    input  logic [ DataWidth-1:0] b,
    input  logic [AluOpWidth-1:0] alu_op,
    output logic [ DataWidth-1:0] res
);

  logic [DataWidth*2-1:0] mul_res;

  always_comb begin
    mul_res = 'h0;
    case (alu_op)
      ALU_ADD:  res = a + b;
      ALU_SUB:  res = a - b;
      ALU_SLL:  res = a << b[4:0];
      ALU_SLT:  res = ($signed(a) < $signed(b)) ? 32'h1 : 32'h0;
      ALU_SLTU: res = (a < b) ? 32'h1 : 32'h0;
      ALU_XOR:  res = a ^ b;
      ALU_SRL:  res = a >> b[4:0];
      ALU_SRA:  res = $signed(a) >>> b[4:0];
      ALU_OR:   res = a | b;
      ALU_AND:  res = a & b;

      // TODO: check if mult. result is already available
      // H first, L second
      ALU_MUL: begin
        mul_res = ($signed(a) * $signed(b));
        res     = mul_res[DataWidth-1:0];
      end
      ALU_MULH: begin
        mul_res = ($signed(a) * $signed(b));
        res     = mul_res[DataWidth*2-1:DataWidth];
      end
      ALU_MULHSU: begin
        mul_res = $signed(a) * b;
        res     = mul_res[DataWidth*2-1:DataWidth];
      end
      ALU_MULHU: begin
        mul_res = a * b;
        res     = mul_res[DataWidth*2-1:DataWidth];
      end
      ALU_DIV: begin
        res = $signed(a) / $signed(b);
      end
      ALU_DIVU: begin
        res = a / b;
      end
      ALU_REM: begin
        res = $signed(a) % $signed(b);
      end
      ALU_REMU: begin
        res = a % b;
      end
      default: begin
        res = 'h0;
      end
    endcase
  end

endmodule
