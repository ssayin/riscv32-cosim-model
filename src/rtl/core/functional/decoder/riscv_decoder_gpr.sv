// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`include "riscv_opcodes.svh"
import param_defs::*;
import instr_defs::*;

module riscv_decoder_gpr (
    input  logic                    clk,
    input  logic                    rst_n,
    input  logic [            31:0] instr,
    input  logic                    compressed,
    output logic [RegAddrWidth-1:0] rd_addr,
    output logic [RegAddrWidth-1:0] rs1_addr,
    output logic [RegAddrWidth-1:0] rs2_addr
);

  localparam logic [RegAddrWidth-1:0] X0 = 5'b00000;
  localparam logic [RegAddrWidth-1:0] X1 = 5'b00001;
  localparam logic [RegAddrWidth-1:0] X2 = 5'b00010;

  logic [31:0] i;
  assign i[31:0] = instr[31:0];

  logic [RegAddrWidth-1:0] rd_addr_next;
  logic [RegAddrWidth-1:0] rs1_addr_next;
  logic [RegAddrWidth-1:0] rs2_addr_next;

  logic [             4:0] c_42;
  logic [             4:0] c_62;
  logic [             4:0] c_97;


  assign c_42 = {2'b01, i[9:7]};
  assign c_62 = i[6:2];
  assign c_97 = {2'b01, i[4:2]};

  always_comb begin
    rs1_addr_next = i[19:15];
    rs2_addr_next = i[24:20];
    rd_addr_next  = i[11:7];
    if (compressed) begin
      casez (i)
        `C_J: begin
          rd_addr_next = X0;
        end
        `C_JAL: begin
          rd_addr_next = X1;
        end
        `C_JALR: begin
          rs1_addr_next = rd_addr_next;
          rd_addr_next  = X1;
        end
        `C_JR: begin
          rs1_addr_next = rd_addr_next;
          rd_addr_next  = X0;
        end

        `C_BEQZ: begin
          rs1_addr_next = c_42;
          rs2_addr_next = X0;
        end
        `C_BNEZ: begin
          rs1_addr_next = c_42;
          rs2_addr_next = X0;
        end

        `C_ADDI4SPN: begin
          rd_addr_next  = c_97;
          rs1_addr_next = X2;
        end

        `C_LW: begin
          rd_addr_next  = c_42;
          rs1_addr_next = c_97;
        end

        `C_SW: begin
          rs1_addr_next = c_42;
          rs2_addr_next = c_97;
        end


        `C_NOP: {rd_addr_next, rs1_addr_next} = {X0, X0};

        `C_ADDI: begin
          rs1_addr_next = rd_addr_next;
        end

        `C_LI: {rs1_addr_next} = {X0};

        `C_ADDI16SP: begin
          rd_addr_next  = X2;
          rs1_addr_next = X2;
        end

        `C_SRLI: {rd_addr_next, rs1_addr_next} = {c_42, c_42};
        `C_SRAI: {rd_addr_next, rs1_addr_next} = {c_42, c_42};

        `C_ANDI: {rd_addr_next, rs1_addr_next} = {c_42, c_42};

        `C_SUB: {rd_addr_next, rs1_addr_next, rs2_addr_next} = {c_42, c_42, c_97};
        `C_XOR: {rd_addr_next, rs1_addr_next, rs2_addr_next} = {c_42, c_42, c_97};
        `C_OR:  {rd_addr_next, rs1_addr_next, rs2_addr_next} = {c_42, c_42, c_97};
        `C_AND: {rd_addr_next, rs1_addr_next, rs2_addr_next} = {c_42, c_42, c_97};

        `C_SLLI: begin
          rs1_addr_next = rd_addr_next;
        end

        `C_LWSP: begin
          rs1_addr_next = X2;
        end

        `C_MV: begin
          rs1_addr_next = X0;
          rs2_addr_next = c_62;
        end
        `C_EBREAK: begin
        end
        `C_ADD: begin
          rs1_addr_next = rd_addr_next;
          rs2_addr_next = c_62;
        end

        `C_SWSP: begin
          rs2_addr_next = c_62;
        end

        default: begin
        end
      endcase
    end
  end

  assign rd_addr  = rd_addr_next;
  assign rs1_addr = rs1_addr_next;
  assign rs2_addr = rs2_addr_next;

endmodule
