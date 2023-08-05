// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0


import defs_pkg::*;

module riscv_decoder_comp_gpr (
  input  logic        en,
  input  logic [15:0] instr,
  output logic [ 4:0] rd_addr,
  output logic [ 4:0] rs1_addr,
  output logic [ 4:0] rs2_addr
);

  localparam logic [4:0] X0 = 5'b00000;
  localparam logic [4:0] X1 = 5'b00001;
  localparam logic [4:0] X2 = 5'b00010;

  logic [31:0] i;

  logic [ 4:0] c_42;
  logic [ 4:0] c_62;
  logic [ 4:0] c_97;

  assign i[15:0] = instr[15:0];
  assign c_42    = {2'b01, i[9:7]};
  assign c_62    = i[6:2];
  assign c_97    = {2'b01, i[4:2]};

  always_comb begin
    // TODO: explicitly assign when appropriate later for debug
    rd_addr  = i[11:7];
    rs1_addr = 0;
    rs2_addr = 0;

    if (en) begin
      casez (i)
        `C_J: begin
          rd_addr = X0;
        end
        `C_JAL: begin
          rd_addr = X1;
        end
        `C_JALR: begin
          rs1_addr = rd_addr;
          rd_addr  = X1;
        end
        `C_JR: begin
          rs1_addr = rd_addr;
          rd_addr  = X0;
        end

        `C_BEQZ: begin
          rs1_addr = c_42;
          rs2_addr = X0;
        end
        `C_BNEZ: begin
          rs1_addr = c_42;
          rs2_addr = X0;
        end

        `C_ADDI4SPN: begin
          rd_addr  = c_97;
          rs1_addr = X2;
        end

        `C_LW: begin
          rd_addr  = c_42;
          rs1_addr = c_97;
        end

        `C_SW: begin
          rs1_addr = c_42;
          rs2_addr = c_97;
        end


        `C_NOP: {rd_addr, rs1_addr} = {X0, X0};

        `C_ADDI: begin
          rs1_addr = rd_addr;
        end

        `C_LI: {rs1_addr} = {X0};

        `C_ADDI16SP: begin
          rd_addr  = X2;
          rs1_addr = X2;
        end

        `C_SRLI: {rd_addr, rs1_addr} = {c_42, c_42};
        `C_SRAI: {rd_addr, rs1_addr} = {c_42, c_42};

        `C_ANDI: {rd_addr, rs1_addr} = {c_42, c_42};

        `C_SUB: {rd_addr, rs1_addr, rs2_addr} = {c_42, c_42, c_97};
        `C_XOR: {rd_addr, rs1_addr, rs2_addr} = {c_42, c_42, c_97};
        `C_OR:  {rd_addr, rs1_addr, rs2_addr} = {c_42, c_42, c_97};
        `C_AND: {rd_addr, rs1_addr, rs2_addr} = {c_42, c_42, c_97};

        `C_SLLI: begin
          rs1_addr = rd_addr;
        end

        `C_LWSP: begin
          rs1_addr = X2;
        end

        `C_MV: begin
          rs1_addr = X0;
          rs2_addr = c_62;
        end
        `C_EBREAK: begin
        end
        `C_ADD: begin
          rs1_addr = rd_addr;
          rs2_addr = c_62;
        end

        `C_SWSP: begin
          rs2_addr = c_62;
        end

        default: begin
        end
      endcase
    end
  end
endmodule

module riscv_decoder_gpr (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [31:0] instr,
  input  logic        compressed,
  output logic [ 4:0] rd_addr,
  output logic [ 4:0] rs1_addr,
  output logic [ 4:0] rs2_addr
);

  logic [4:0] rd_addr_next;
  logic [4:0] rs1_addr_next;
  logic [4:0] rs2_addr_next;

  riscv_decoder_comp_gpr comp_gpr_0 (
    .en      (compressed),
    .instr   (instr[15:0]),
    .rd_addr (rd_addr_next),
    .rs1_addr(rs1_addr_next),
    .rs2_addr(rs2_addr_next)
  );

  assign rd_addr  = compressed ? rd_addr_next : instr[11:7];
  assign rs1_addr = compressed ? rs1_addr_next : instr[19:15];
  assign rs2_addr = compressed ? rs2_addr_next : instr[24:20];

endmodule
