// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module dec_decode
  import defs::*;
#(
  `include "inst.svh"
) (
  input  logic        i_clk,
  input  logic        i_rst_n,
  input  logic [31:0] i_instr,
  input  logic [31:0] i_pc,
  output logic [31:0] o_pc,
  output logic [31:0] o_imm,
  output logic [ 4:0] o_rs1_addr,
  output logic [ 4:0] o_rs2_addr,
  output logic [ 4:0] o_rd_addr,
  output logic        o_rd_en,
  output logic        o_rs1_en,
  output logic        o_rs2_en,
  output logic        o_mem_rd_en,
  output logic        o_mem_wr_en,
  output logic        o_use_imm,
  output logic        alu,
  output logic        lsu,
  output logic        br,
  output logic        illegal,
  output logic [31:0] o_exp_code
);

  logic    [ 4:0] c_rd_rs1;
  logic    [ 4:0] c_rs2;

  alu_op_t        alu_op;

  lsu_op_t        lsu_op;

  logic    [31:0] imm_I;
  logic    [31:0] imm_S;
  logic    [31:0] imm_B;
  logic    [31:0] imm_U;
  logic    [31:0] imm_J;

  logic    [12:0] csr;

  logic    [31:0] c_imm_addi4spn;
  logic    [31:0] c_uimm5;
  logic    [31:0] c_imm6;
  logic    [31:0] c_imm_j;
  logic    [31:0] c_imm_addi16sp;
  logic    [31:0] c_imm_lui;
  logic    [31:0] c_imm_lwsw;
  logic    [31:0] c_imm_lwsp;
  logic    [31:0] c_imm_swsp;
  logic    [31:0] c_imm_b;
  logic    [31:0] c_uimm6;

  // Extract o_immediate values from the i_instruction
  assign imm_I = {{20{i_instr[31]}}, i_instr[31:20]};
  assign imm_S = {{20{i_instr[31]}}, i_instr[31:25], i_instr[11:7]};
  assign imm_B = {{20{i_instr[31]}}, i_instr[7], i_instr[30:25], i_instr[11:8], 1'b0};
  assign imm_U = {i_instr[31:12], 12'b0};
  assign imm_J = {{12{i_instr[31]}}, i_instr[19:12], i_instr[20], i_instr[30:21], 1'b0};

  assign csr = i_instr[31:20];

  assign c_imm_addi4spn = {22'b0, i_instr[10:7], i_instr[12:11], i_instr[5], i_instr[6], 2'b00};

  assign c_uimm5 = {25'b0, i_instr[6:5], i_instr[12:10], 2'b00};

  assign c_imm6 = {{27{i_instr[12]}}, i_instr[6:2]};

  // imm[5] must be zero
  assign c_uimm6 = {27'b0, i_instr[6:2]};

  assign c_imm_j = {
    {21{i_instr[12]}},
    i_instr[8],
    i_instr[10:9],
    i_instr[6],
    i_instr[7],
    i_instr[2],
    i_instr[10],
    i_instr[5:3],
    1'b0
  };


  assign c_imm_b = {
    {24{i_instr[12]}}, i_instr[6:5], i_instr[2], i_instr[11:10], i_instr[4:3], 1'b0
  };

  assign c_imm_addi16sp = {
    {27{i_instr[12]}}, i_instr[4:3], i_instr[5], i_instr[2], i_instr[6], 4'b0
  };

  assign c_imm_lui = {{15{i_instr[12]}}, i_instr[6:2], 12'b0};


  assign c_imm_lwsw = {21'b0, i_instr[5], i_instr[12:10], i_instr[6], 2'b00};
  assign c_imm_lwsp = {24'b0, i_instr[3:2], i_instr[12], i_instr[6:4], 2'b00};
  assign c_imm_swsp = {24'b0, i_instr[8:7], i_instr[12:9], 2'b0};

  logic [4:0] c_42;
  logic [4:0] c_62;
  logic [4:0] c_97;

  assign c_42 = {2'b01, i_instr[9:7]};
  assign c_62 = i_instr[6:2];
  assign c_97 = {2'b01, i_instr[4:2]};

  logic [4:0] rd_addr;
  logic [4:0] rs1_addr;
  logic [4:0] rs2_addr;

  assign o_rd_addr  = rd_addr;
  assign o_rs1_addr = rs1_addr;
  assign o_rs2_addr = rs2_addr;

  always_comb begin
    illegal   = 1'b0;
    o_imm     = 32'b0;
    o_use_imm = 1'b0;

    rs1_addr  = i_instr[19:15];
    rs2_addr  = i_instr[24:20];
    rd_addr   = i_instr[11:7];

    o_rd_en   = 1'b0;
    o_rs1_en  = 1'b0;
    o_rs2_en  = 1'b0;

    casez (i_instr)

      //  ╔═╗ ╔╗ ╦═╗╔═╗╔╗╔╔═╗╦ ╦
      //  ║───╠╩╗╠╦╝╠═╣║║║║  ╠═╣
      //  ╚═╝ ╚═╝╩╚═╩ ╩╝╚╝╚═╝╩ ╩
      `C_J: begin
        o_use_imm = 1'b1;  // remove later
        o_imm     = c_imm_j;
        rd_addr   = 5'b0;
        o_rd_en   = 1'b1;
      end
      `C_JAL: begin
        o_use_imm = 1'b1;  // remove later
        o_imm     = c_imm_j;
        o_rd_en   = 1'b1;
        rd_addr   = 5'b00001;
      end
      `C_JALR: begin
        rs1_addr = rd_addr;
        rd_addr  = 5'b00001;
        o_rd_en  = 1'b1;
        o_rs1_en = 1'b1;
      end
      `C_JR: begin
        o_rs1_en = 1'b1;
        rs1_addr = rd_addr;
        rd_addr  = 5'b0;
      end

      `C_BEQZ: begin
        o_use_imm = 1'b1;
        rs1_addr  = c_42;
        o_imm     = c_imm_b;
        o_rs1_en  = 1'b1;
      end
      `C_BNEZ: begin
        o_use_imm = 1'b1;
        rs1_addr  = c_42;
        o_imm     = c_imm_b;
        o_rs1_en  = 1'b1;
      end

      //  ╦   ╔╗ ╦═╗╔═╗╔╗╔╔═╗╦ ╦
      //  ║───╠╩╗╠╦╝╠═╣║║║║  ╠═╣
      //  ╩   ╚═╝╩╚═╩ ╩╝╚╝╚═╝╩ ╩
      `JAL: begin
        o_imm     = imm_J;
        o_rd_en   = 1'b1;
        o_use_imm = 1'b1;  // remove later
      end
      `JALR: begin
        o_use_imm = 1'b1;  // remove later
        o_imm     = imm_I;
        o_rd_en   = 1'b1;
        o_rs1_en  = 1'b1;
      end

      `BEQ:  {o_imm, o_rs1_en, o_rs2_en} = {imm_B, 1'b1, 1'b1};
      `BGE:  {o_imm, o_rs1_en, o_rs2_en} = {imm_B, 1'b1, 1'b1};
      `BGEU: {o_imm, o_rs1_en, o_rs2_en} = {imm_B, 1'b1, 1'b1};
      `BLT:  {o_imm, o_rs1_en, o_rs2_en} = {imm_B, 1'b1, 1'b1};
      `BLTU: {o_imm, o_rs1_en, o_rs2_en} = {imm_B, 1'b1, 1'b1};
      `BNE:  {o_imm, o_rs1_en, o_rs2_en} = {imm_B, 1'b1, 1'b1};

      //  ╦   ╔═╗╦═╗╔═╗  ╔╗ ╦═╗╔═╗╔╗╔╔═╗╦ ╦
      //  ║───╠═╝╠╦╝║╣───╠╩╗╠╦╝╠═╣║║║║  ╠═╣
      //  ╩   ╩  ╩╚═╚═╝  ╚═╝╩╚═╩ ╩╝╚╝╚═╝╩ ╩
      `AUIPC: {o_use_imm, o_imm, alu_op, o_rd_en} = {1'b1, imm_U, ALU_ADD, 1'b1};
      `LUI:   {o_use_imm, o_imm, alu_op, o_rd_en} = {1'b1, imm_U, ALU_ADD, 1'b1};

      //  ╦  ╔═╗╔═╗╔╦╗
      //  ║  ║ ║╠═╣ ║║
      //  ╩═╝╚═╝╩ ╩═╩╝
      `LW: {o_imm, lsu_op, o_rd_en, o_rs1_en} = {imm_I, LSU_LW, 1'b1, 1'b1};
      `LH: {o_imm, lsu_op, o_rd_en, o_rs1_en} = {imm_I, LSU_LH, 1'b1, 1'b1};
      `LB: {o_imm, lsu_op, o_rd_en, o_rs1_en} = {imm_I, LSU_LB, 1'b1, 1'b1};

      `LHU: {o_imm, lsu_op, o_rd_en, o_rs1_en} = {imm_I, LSU_LHU, 1'b1, 1'b1};
      `LBU: {o_imm, lsu_op, o_rd_en, o_rs1_en} = {imm_I, LSU_LBU, 1'b1, 1'b1};

      //  ╔═╗╔╦╗╔═╗╦═╗╔═╗
      //  ╚═╗ ║ ║ ║╠╦╝║╣
      //  ╚═╝ ╩ ╚═╝╩╚═╚═╝
      `SB: {o_imm, lsu_op, o_rs1_en, o_rs2_en} = {imm_S, LSU_SB, 1'b1, 1'b1};
      `SH: {o_imm, lsu_op, o_rs1_en, o_rs2_en} = {imm_S, LSU_SH, 1'b1, 1'b1};
      `SW: {o_imm, lsu_op, o_rs1_en, o_rs2_en} = {imm_S, LSU_SW, 1'b1, 1'b1};

      //  ╦╔╗╔╔╦╗╔═╗╔═╗╔═╗╦═╗
      //  ║║║║ ║ ║╣ ║ ╦║╣ ╠╦╝
      //  ╩╝╚╝ ╩ ╚═╝╚═╝╚═╝╩╚═
      `ADD: {alu_op, o_rd_en, o_rs1_en, o_rs2_en} = {ALU_ADD, 1'b1, 1'b1, 1'b1};
      `AND: {alu_op, o_rd_en, o_rs1_en, o_rs2_en} = {ALU_AND, 1'b1, 1'b1, 1'b1};

      `OR: {alu_op, o_rd_en, o_rs1_en, o_rs2_en} = {ALU_OR, 1'b1, 1'b1, 1'b1};

      `XOR: {alu_op, o_rd_en, o_rs1_en, o_rs2_en} = {ALU_XOR, 1'b1, 1'b1, 1'b1};
      `SUB: {alu_op, o_rd_en, o_rs1_en, o_rs2_en} = {ALU_SUB, 1'b1, 1'b1, 1'b1};

      `ADDI: {o_use_imm, o_imm, alu_op, o_rd_en, o_rs1_en} = {1'b1, imm_I, ALU_ADD, 1'b1, 1'b1};
      `ANDI: {o_use_imm, o_imm, alu_op, o_rd_en, o_rs1_en} = {1'b1, imm_I, ALU_AND, 1'b1, 1'b1};
      `ORI:  {o_use_imm, o_imm, alu_op, o_rd_en, o_rs1_en} = {1'b1, imm_I, ALU_OR, 1'b1, 1'b1};
      `XORI: {o_use_imm, o_imm, alu_op, o_rd_en, o_rs1_en} = {1'b1, imm_I, ALU_XOR, 1'b1, 1'b1};

      `SLL:  {alu_op, o_rd_en, o_rs1_en, o_rs2_en} = {ALU_SLL, 1'b1, 1'b1, 1'b1};
      `SLT:  {alu_op, o_rd_en, o_rs1_en, o_rs2_en} = {ALU_SLT, 1'b1, 1'b1, 1'b1};
      `SLTU: {alu_op, o_rd_en, o_rs1_en, o_rs2_en} = {ALU_SLTU, 1'b1, 1'b1, 1'b1};

      `SRA: {alu_op, o_rd_en, o_rs2_en} = {ALU_SRA, 1'b1, 1'b1};
      `SRL: {alu_op, o_rd_en, o_rs2_en} = {ALU_SRL, 1'b1, 1'b1};

      `SLLI:
      {o_use_imm, o_imm, alu_op, o_rd_en, o_rs1_en} = {
        1'b1, {27'b0, i_instr[24:20]}, ALU_SLL, 1'b1, 1'b1
      };
      `SLTI: {o_use_imm, o_imm, alu_op, o_rd_en, o_rs1_en} = {1'b1, imm_I, ALU_SLT, 1'b1, 1'b1};
      `SLTIU: {o_use_imm, o_imm, alu_op, o_rd_en, o_rs1_en} = {1'b1, imm_I, ALU_SLTU, 1'b1, 1'b1};

      `SRAI:
      {o_use_imm, o_imm, alu_op, o_rd_en, o_rs1_en} = {
        1'b1, {27'b0, i_instr[24:20]}, ALU_SRA, 1'b1, 1'b1
      };
      `SRLI:
      {o_use_imm, o_imm, alu_op, o_rd_en, o_rs1_en} = {
        1'b1, {27'b0, i_instr[24:20]}, ALU_SRL, 1'b1, 1'b1
      };


      //  ╔╦╗╦ ╦╦ ╔╦╗╦╔═╗╦  ╦╔═╗╔═╗╔╦╗╦╔═╗╔╗╔
      //  ║║║║ ║║  ║ ║╠═╝║  ║║  ╠═╣ ║ ║║ ║║║║
      //  ╩ ╩╚═╝╩═╝╩ ╩╩  ╩═╝╩╚═╝╩ ╩ ╩ ╩╚═╝╝╚╝
      `MUL:    {alu_op, o_rd_en, o_rs1_en, o_rs2_en} = {ALU_MUL, 1'b1, 1'b1, 1'b1};
      `MULH:   {alu_op, o_rd_en, o_rs1_en, o_rs2_en} = {ALU_MULH, 1'b1, 1'b1, 1'b1};
      `MULHSU: {alu_op, o_rd_en, o_rs1_en, o_rs2_en} = {ALU_MULHSU, 1'b1, 1'b1, 1'b1};
      `MULHU:  {alu_op, o_rd_en, o_rs1_en, o_rs2_en} = {ALU_MULHU, 1'b1, 1'b1, 1'b1};
      `DIV:    {alu_op, o_rd_en, o_rs1_en, o_rs2_en} = {ALU_DIV, 1'b1, 1'b1, 1'b1};
      `DIVU:   {alu_op, o_rd_en, o_rs1_en, o_rs2_en} = {ALU_DIVU, 1'b1, 1'b1, 1'b1};
      `REM:    {alu_op, o_rd_en, o_rs1_en, o_rs2_en} = {ALU_REM, 1'b1, 1'b1, 1'b1};
      `REMU:   {alu_op, o_rd_en, o_rs1_en, o_rs2_en} = {ALU_REMU, 1'b1, 1'b1, 1'b1};

      //  ╔═╗╔═╗╔╦╗╔═╗╦═╗╔═╗╔═╗╔═╗╔═╗╔╦╗
      //  ║  ║ ║║║║╠═╝╠╦╝║╣ ╚═╗╚═╗║╣  ║║
      //  ╚═╝╚═╝╩ ╩╩  ╩╚═╚═╝╚═╝╚═╝╚═╝═╩╝
      `C_ILLEGAL: illegal = 1'b1;

      `C_ADDI4SPN: begin
        alu_op    = ALU_ADD;
        o_use_imm = 1'b1;
        o_imm     = c_imm_addi4spn;
        rd_addr   = c_97;
        rs1_addr  = 5'b00010;
        o_rd_en   = 1'b1;
        o_rs1_en  = 1'b1;
      end

      `C_LW: begin
        lsu_op   = LSU_LW;
        o_imm    = c_imm_lwsw;
        rd_addr  = c_42;
        rs1_addr = c_97;
        o_rd_en  = 1'b1;
        o_rs1_en = 1'b1;
      end

      `C_SW: begin
        o_imm    = c_imm_lwsw;
        rs1_addr = c_42;
        rs2_addr = c_97;
        lsu_op   = LSU_LW;
        o_rs1_en = 1'b1;
        o_rs2_en = 1'b1;
      end


      `C_NOP: {o_use_imm, o_imm, alu_op, o_rd_en} = {1'b1, c_imm6, ALU_ADD, 1'b1};
      `C_ADDI: begin
        o_use_imm = 1'b1;
        o_imm     = c_imm6;
        rs1_addr  = rd_addr;
        alu_op    = ALU_ADD;
        o_rd_en   = 1'b1;
        o_rs1_en  = 1'b1;
      end

      `C_LI:  {o_use_imm, o_imm, alu_op, o_rd_en} = {1'b0, c_imm6, ALU_ADD, 1'b1};
      `C_ADDI16SP: begin
        o_use_imm = 1'b1;
        o_imm     = c_imm_addi16sp;
        rd_addr   = 5'b00010;
        rs1_addr  = 5'b00010;
        alu_op    = ALU_ADD;
        o_rd_en   = 1'b1;
        o_rs1_en  = 1'b1;
      end
      `C_LUI: {o_use_imm, o_imm, alu_op, o_rd_en} = {1'b1, c_imm_lui, ALU_ADD, 1'b1};

      `C_SRLI:
      {o_use_imm, o_imm, rd_addr, rs1_addr, alu_op, o_rd_en, o_rs1_en} = {
        1'b1, c_uimm6, c_42, c_42, ALU_SRL, 1'b1, 1'b1
      };
      `C_SRAI:
      {o_use_imm, o_imm, rd_addr, rs1_addr, alu_op, o_rd_en, o_rs1_en} = {
        1'b1, c_uimm6, c_42, c_42, ALU_SRA, 1'b1, 1'b1
      };

      `C_ANDI:
      {o_use_imm, o_imm, rd_addr, rs1_addr, alu_op, o_rd_en, o_rs1_en} = {
        1'b1, c_imm6, c_42, c_42, ALU_AND, 1'b1, 1'b1
      };

      `C_SUB:
      {rd_addr, rs1_addr, rs2_addr, alu_op, o_rd_en, o_rs1_en, o_rs2_en} = {
        c_42, c_42, c_97, ALU_SUB, 1'b1, 1'b1, 1'b1
      };
      `C_XOR:
      {rd_addr, rs1_addr, rs2_addr, alu_op, o_rd_en, o_rs1_en, o_rs2_en} = {
        c_42, c_42, c_97, ALU_XOR, 1'b1, 1'b1, 1'b1
      };
      `C_OR:
      {rd_addr, rs1_addr, rs2_addr, alu_op, o_rd_en, o_rs1_en, o_rs2_en} = {
        c_42, c_42, c_97, ALU_OR, 1'b1, 1'b1, 1'b1
      };
      `C_AND:
      {rd_addr, rs1_addr, rs2_addr, alu_op, o_rd_en, o_rs1_en, o_rs2_en} = {
        c_42, c_42, c_97, ALU_ADD, 1'b1, 1'b1, 1'b1
      };

      `C_SLLI: begin
        o_use_imm = 1'b1;
        o_imm     = c_uimm6;

        alu_op    = ALU_SLL;
        rs1_addr  = rd_addr;

        o_rd_en   = 1'b1;
        o_rs1_en  = 1'b1;
      end

      `C_LWSP: begin
        o_imm    = c_imm_lwsp;

        lsu_op   = LSU_LW;

        rs1_addr = 5'b00010;

        o_rd_en  = 1'b1;
        o_rs1_en = 1'b1;
      end

      `C_MV: begin
        rs2_addr = c_62;
        alu_op   = ALU_ADD;
        o_rd_en  = 1'b1;
        o_rs2_en = 1'b1;
      end
      `C_EBREAK: begin
      end
      `C_ADD: begin

        rs1_addr = rd_addr;

        rs1_addr = rd_addr;
        rs2_addr = c_62;

        alu_op   = ALU_ADD;

        o_rd_en  = 1'b1;
        o_rs1_en = 1'b1;
        o_rs2_en = 1'b1;
      end

      `C_SWSP: begin
        o_imm    = c_imm_swsp;

        rs2_addr = c_62;
        o_rs2_en = 1'b1;

        lsu_op   = LSU_SW;
      end

      //  ╔═╗╔═╗╦═╗
      //  ║  ╚═╗╠╦╝
      //  ╚═╝╚═╝╩╚═
      `CSRRC: begin
        o_imm = csr;
      end
      `CSRRCI: begin
        o_imm = csr;
      end
      `CSRRS: begin
        o_imm    = csr;
        o_rs1_en = 1'b1;
      end
      `CSRRSI: begin
        o_imm    = csr;
        o_rs1_en = 1'b1;
      end
      `CSRRW: begin
        o_imm    = csr;
        o_rs1_en = 1'b1;
      end
      `CSRRWI: begin
        o_imm = csr;
      end

      //  ╔═╗╦ ╦╔═╗
      //  ╚═╗╚╦╝╚═╗
      //  ╚═╝ ╩ ╚═╝
      `EBREAK: begin
      end
      `ECALL: begin
      end
      `MRET: begin
      end
      `FENCE: begin
      end
      `FENCEI: begin
      end
      `WFI: begin
      end

      default: illegal = 1'b1;

    endcase
  end

endmodule

