// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module alu

(
  input  logic [ DataWidth-1:0] i_a,
  input  logic [ DataWidth-1:0] i_b,
  input  logic [AluOpWidth-1:0] i_alu_op,
  output logic [ DataWidth-1:0] o_res
);

  import instr_defs::*;
  import param_defs::*;
  
  logic [DataWidth*2-1:0] mul_res;

  always_comb begin
  mul_res = 'h0;
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

      // TODO: check if mult. result is already available
      // H first, L second
      ALU_MUL: begin
        mul_res = ($signed(i_a) * $signed(i_b));
        o_res   = mul_res[DataWidth-1:0];
      end
      ALU_MULH: begin
        mul_res = ($signed(i_a) * $signed(i_b));
        o_res   = mul_res[DataWidth*2-1:DataWidth];
      end
      ALU_MULHSU: begin
        mul_res = $signed(i_a) * i_b;
        o_res   = mul_res[DataWidth*2-1:DataWidth];
      end
      ALU_MULHU: begin
        mul_res = i_a * i_b;
        o_res   = mul_res[DataWidth*2-1:DataWidth];
      end
      ALU_DIV: begin
        o_res = $signed(i_a) / $signed(i_b);
      end
      ALU_DIVU: begin
        o_res = i_a / i_b;
      end
      ALU_REM: begin
        o_res = $signed(i_a) % $signed(i_b);
      end
      ALU_REMU: begin
        o_res = i_a % i_b;
      end
      default: begin
			o_res = 'h0;
		end
    endcase
  end

endmodule
