// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0
import defs_pkg::*;

module exu_alu (
  input  logic                  en,
  input  logic [          31:0] a,
  input  logic [          31:0] b,
  input  logic [AluOpWidth-1:0] alu_op,
  output logic [          31:0] res
);
  always_comb begin
    if (en) begin
      case (alu_op)
        ALU_ADD:  res = a + b;
        ALU_SUB:  res = a - b;
        ALU_XOR:  res = a ^ b;
        ALU_OR:   res = a | b;
        ALU_AND:  res = a & b;
        ALU_SLL:  res = a << b[4:0];
        ALU_SLT:  res = ($signed(a) < $signed(b)) ? 32'h1 : 32'h0;
        ALU_SLTU: res = (a < b) ? 32'h1 : 32'h0;
        ALU_SRL:  res = a >> b[4:0];
        ALU_SRA:  res = $signed(a) >>> b[4:0];
        default:  res = 32'h0;
      endcase
    end else res = 32'h0;
  end
endmodule


module exu_mul (
  input  logic                  en,
  input  logic [          31:0] a,
  input  logic [          31:0] b,
  input  logic [AluOpWidth-1:0] alu_op,
  output logic [          31:0] res
);
  always_comb begin
    if (en) begin
      case (alu_op)
        //ALU_MUL:
        //ALU_MULH:
        //ALU_MULHSU:
        //ALU_MULHU:
        default: res = 32'h0;
      endcase
    end else res = 32'h0;
  end
endmodule

module exu_div (
  input  logic                  en,
  input  logic [          31:0] a,
  input  logic [          31:0] b,
  input  logic [AluOpWidth-1:0] alu_op,
  output logic [          31:0] res
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

