// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0


module riscv_decoder
  import param_defs::*;
  import instr_defs::*;
#(
  `include "riscv_opcodes.svh"
) (
  input  logic                    clk,         // unused
  input  logic                    rst_n,       // unused
  input  logic [            31:0] i_instr,
  input  logic [   DataWidth-1:0] i_pc,
  output logic [   DataWidth-1:0] o_imm,
  output logic [RegAddrWidth-1:0] o_rd_addr,   // DO NOT ASSIGN
  output logic [RegAddrWidth-1:0] o_rs1_addr,  // DO NOT ASSIGN
  output logic [RegAddrWidth-1:0] o_rs2_addr,  // DO NOT ASSIGN
  output logic                    o_rd_en,
  output logic                    o_use_imm,
  output logic                    o_alu,
  output logic                    o_lsu,
  output logic                    o_br,
  output logic [  AluOpWidth-1:0] o_alu_op,
  output logic [  LsuOpWidth-1:0] o_lsu_op,
  output logic                    o_illegal,
  output logic [   DataWidth-1:0] o_exp_code
);

  localparam logic [RegAddrWidth-1:0] X0 = 5'b00000;
  localparam logic [RegAddrWidth-1:0] X1 = 5'b00001;
  localparam logic [RegAddrWidth-1:0] X2 = 5'b00010;

  logic [            31:0] i;

  logic [RegAddrWidth-1:0] rd_addr;
  logic [RegAddrWidth-1:0] rs1_addr;
  logic [RegAddrWidth-1:0] rs2_addr;

  // Zero-extended RS2
  // TODO: Remove
  logic [   DataWidth-1:0] ze_rs2;

  logic [             4:0] c_rd_rs1;
  logic [             4:0] c_rs2;

  logic [   DataWidth-1:0] imm_I;
  logic [   DataWidth-1:0] imm_S;
  logic [   DataWidth-1:0] imm_B;
  logic [   DataWidth-1:0] imm_U;
  logic [   DataWidth-1:0] imm_J;

  logic [            11:0] csr;

  // For extracting various C_* fields
  logic [   DataWidth-1:0] c_imm_addi4spn;
  logic [   DataWidth-1:0] c_uimm5;
  logic [   DataWidth-1:0] c_imm6;
  logic [   DataWidth-1:0] c_imm_j;
  logic [   DataWidth-1:0] c_imm_addi16sp;
  logic [   DataWidth-1:0] c_imm_lui;
  logic [   DataWidth-1:0] c_imm_lwsw;
  logic [   DataWidth-1:0] c_imm_lwsp;
  logic [   DataWidth-1:0] c_imm_swsp;
  logic [   DataWidth-1:0] c_imm_b;
  logic [   DataWidth-1:0] c_uimm6;

  logic [             4:0] c_42;
  logic [             4:0] c_62;
  logic [             4:0] c_97;

  assign i[31:0]        = i_instr[31:0];

  // TODO: Remove
  assign ze_rs2         = {27'b0, i[24:20]};

  assign imm_I          = {{20{i[31]}}, i[31:20]};
  assign imm_S          = {{20{i[31]}}, i[31:25], i[11:7]};
  assign imm_B          = {{20{i[31]}}, i[7], i[30:25], i[11:8], 1'b0};
  assign imm_U          = {i[31:12], 12'b0};
  assign imm_J          = {{12{i[31]}}, i[19:12], i[20], i[30:21], 1'b0};

  assign csr            = i[31:20];

  assign c_imm_addi4spn = {22'b0, i[10:7], i[12:11], i[5], i[6], 2'b00};

  assign c_uimm5        = {25'b0, i[6:5], i[12:10], 2'b00};

  assign c_imm6         = {{27{i[12]}}, i[6:2]};

  // imm[5] must be zero
  assign c_uimm6        = {27'b0, i[6:2]};

  assign c_imm_j        = {{21{i[12]}}, i[8], i[10:9], i[6], i[7], i[2], i[10], i[5:3], 1'b0};


  assign c_imm_b        = {{24{i[12]}}, i[6:5], i[2], i[11:10], i[4:3], 1'b0};

  assign c_imm_addi16sp = {{27{i[12]}}, i[4:3], i[5], i[2], i[6], 4'b0};

  assign c_imm_lui      = {{15{i[12]}}, i[6:2], 12'b0};


  assign c_imm_lwsw     = {21'b0, i[5], i[12:10], i[6], 2'b00};
  assign c_imm_lwsp     = {24'b0, i[3:2], i[12], i[6:4], 2'b00};
  assign c_imm_swsp     = {24'b0, i[8:7], i[12:9], 2'b0};

  assign c_42           = {2'b01, i[9:7]};
  assign c_62           = i[6:2];
  assign c_97           = {2'b01, i[4:2]};

  always_comb begin
    o_illegal = 1'b0;
    o_imm     = 32'b0;
    o_use_imm = 1'b0;

    rs1_addr  = i[19:15];
    rs2_addr  = i[24:20];
    rd_addr   = i[11:7];

    o_rd_en   = 1'b0;

    // Default for branches and jumps
    o_alu     = 1'b1;
    o_alu_op  = ALU_ADD;

    o_lsu     = 1'b0;
    o_lsu_op  = 4'bXXXX;

    casez (i)

      //  ╔═╗ ╔╗ ╦═╗╔═╗╔╗╔╔═╗╦ ╦
      //  ║───╠╩╗╠╦╝╠═╣║║║║  ╠═╣
      //  ╚═╝ ╚═╝╩╚═╩ ╩╝╚╝╚═╝╩ ╩
      `C_J: begin
        o_use_imm = 1'b1;
        o_imm     = c_imm_j;
        rd_addr   = X0;
        o_rd_en   = 1'b1;
      end
      `C_JAL: begin
        o_use_imm = 1'b1;
        o_imm     = c_imm_j;
        o_rd_en   = 1'b1;
        rd_addr   = X1;
      end
      `C_JALR: begin
        rs1_addr = rd_addr;
        rd_addr  = X1;
        o_rd_en  = 1'b1;
      end
      `C_JR: begin
        rs1_addr = rd_addr;
        rd_addr  = X0;
      end

      `C_BEQZ: begin
        o_use_imm = 1'b1;
        rs1_addr  = c_42;
        o_imm     = c_imm_b;
      end
      `C_BNEZ: begin
        o_use_imm = 1'b1;
        rs1_addr  = c_42;
        o_imm     = c_imm_b;
      end

      //  ╦   ╔╗ ╦═╗╔═╗╔╗╔╔═╗╦ ╦
      //  ║───╠╩╗╠╦╝╠═╣║║║║  ╠═╣
      //  ╩   ╚═╝╩╚═╩ ╩╝╚╝╚═╝╩ ╩
      `JAL: begin
        o_imm     = imm_J;
        o_rd_en   = 1'b1;
        o_use_imm = 1'b1;
      end
      `JALR: begin
        o_use_imm = 1'b1;
        o_imm     = imm_I;
        o_rd_en   = 1'b1;
      end

      `BEQ:  {o_use_imm, o_imm} = {1'b1, imm_B};
      `BGE:  {o_use_imm, o_imm} = {1'b1, imm_B};
      `BGEU: {o_use_imm, o_imm} = {1'b1, imm_B};
      `BLT:  {o_use_imm, o_imm} = {1'b1, imm_B};
      `BLTU: {o_use_imm, o_imm} = {1'b1, imm_B};
      `BNE:  {o_use_imm, o_imm} = {1'b1, imm_B};

      //  ╦   ╔═╗╦═╗╔═╗  ╔╗ ╦═╗╔═╗╔╗╔╔═╗╦ ╦
      //  ║───╠═╝╠╦╝║╣───╠╩╗╠╦╝╠═╣║║║║  ╠═╣
      //  ╩   ╩  ╩╚═╚═╝  ╚═╝╩╚═╩ ╩╝╚╝╚═╝╩ ╩
      `AUIPC: {o_use_imm, o_imm, o_alu_op, o_rd_en} = {1'b1, imm_U, ALU_ADD, 1'b1};
      `LUI:   {o_use_imm, o_imm, o_alu_op, o_rd_en} = {1'b1, imm_U, ALU_ADD, 1'b1};

      //  ╦  ╔═╗╔═╗╔╦╗
      //  ║  ║ ║╠═╣ ║║
      //  ╩═╝╚═╝╩ ╩═╩╝
      `LW: {o_imm, o_lsu_op, o_rd_en} = {imm_I, LSU_LW, 1'b1};
      `LH: {o_imm, o_lsu_op, o_rd_en} = {imm_I, LSU_LH, 1'b1};
      `LB: {o_imm, o_lsu_op, o_rd_en} = {imm_I, LSU_LB, 1'b1};

      `LHU: {o_imm, o_lsu_op, o_rd_en} = {imm_I, LSU_LHU, 1'b1};
      `LBU: {o_imm, o_lsu_op, o_rd_en} = {imm_I, LSU_LBU, 1'b1};

      //  ╔═╗╔╦╗╔═╗╦═╗╔═╗
      //  ╚═╗ ║ ║ ║╠╦╝║╣
      //  ╚═╝ ╩ ╚═╝╩╚═╚═╝
      `SB: {o_imm, o_lsu_op} = {imm_S, LSU_SB};
      `SH: {o_imm, o_lsu_op} = {imm_S, LSU_SH};
      `SW: {o_imm, o_lsu_op} = {imm_S, LSU_SW};

      //  ╦╔╗╔╔╦╗╔═╗╔═╗╔═╗╦═╗
      //  ║║║║ ║ ║╣ ║ ╦║╣ ╠╦╝
      //  ╩╝╚╝ ╩ ╚═╝╚═╝╚═╝╩╚═
      `ADD: {o_alu_op, o_rd_en} = {ALU_ADD, 1'b1};
      `AND: {o_alu_op, o_rd_en} = {ALU_AND, 1'b1};

      `OR: {o_alu_op, o_rd_en} = {ALU_OR, 1'b1};

      `XOR: {o_alu_op, o_rd_en} = {ALU_XOR, 1'b1};
      `SUB: {o_alu_op, o_rd_en} = {ALU_SUB, 1'b1};

      `ADDI: {o_use_imm, o_imm, o_alu_op, o_rd_en} = {1'b1, imm_I, ALU_ADD, 1'b1};
      `ANDI: {o_use_imm, o_imm, o_alu_op, o_rd_en} = {1'b1, imm_I, ALU_AND, 1'b1};
      `ORI:  {o_use_imm, o_imm, o_alu_op, o_rd_en} = {1'b1, imm_I, ALU_OR, 1'b1};
      `XORI: {o_use_imm, o_imm, o_alu_op, o_rd_en} = {1'b1, imm_I, ALU_XOR, 1'b1};

      `SLL:  {o_alu_op, o_rd_en} = {ALU_SLL, 1'b1};
      `SLT:  {o_alu_op, o_rd_en} = {ALU_SLT, 1'b1};
      `SLTU: {o_alu_op, o_rd_en} = {ALU_SLTU, 1'b1};

      `SRA: {o_alu_op, o_rd_en} = {ALU_SRA, 1'b1};
      `SRL: {o_alu_op, o_rd_en} = {ALU_SRL, 1'b1};

      `SLLI:  {o_use_imm, o_imm, o_alu_op, o_rd_en} = {1'b1, ze_rs2, ALU_SLL, 1'b1};
      `SLTI:  {o_use_imm, o_imm, o_alu_op, o_rd_en} = {1'b1, imm_I, ALU_SLT, 1'b1};
      `SLTIU: {o_use_imm, o_imm, o_alu_op, o_rd_en} = {1'b1, imm_I, ALU_SLTU, 1'b1};

      `SRAI: {o_use_imm, o_imm, o_alu_op, o_rd_en} = {1'b1, ze_rs2, ALU_SRA, 1'b1};
      `SRLI: {o_use_imm, o_imm, o_alu_op, o_rd_en} = {1'b1, ze_rs2, ALU_SRL, 1'b1};


      //  ╔╦╗╦ ╦╦ ╔╦╗╦╔═╗╦  ╦╔═╗╔═╗╔╦╗╦╔═╗╔╗╔
      //  ║║║║ ║║  ║ ║╠═╝║  ║║  ╠═╣ ║ ║║ ║║║║
      //  ╩ ╩╚═╝╩═╝╩ ╩╩  ╩═╝╩╚═╝╩ ╩ ╩ ╩╚═╝╝╚╝
      `MUL:    {o_alu_op, o_rd_en} = {ALU_MUL, 1'b1};
      `MULH:   {o_alu_op, o_rd_en} = {ALU_MULH, 1'b1};
      `MULHSU: {o_alu_op, o_rd_en} = {ALU_MULHSU, 1'b1};
      `MULHU:  {o_alu_op, o_rd_en} = {ALU_MULHU, 1'b1};
      `DIV:    {o_alu_op, o_rd_en} = {ALU_DIV, 1'b1};
      `DIVU:   {o_alu_op, o_rd_en} = {ALU_DIVU, 1'b1};
      `REM:    {o_alu_op, o_rd_en} = {ALU_REM, 1'b1};
      `REMU:   {o_alu_op, o_rd_en} = {ALU_REMU, 1'b1};

      //  ╔═╗╔═╗╔╦╗╔═╗╦═╗╔═╗╔═╗╔═╗╔═╗╔╦╗
      //  ║  ║ ║║║║╠═╝╠╦╝║╣ ╚═╗╚═╗║╣  ║║
      //  ╚═╝╚═╝╩ ╩╩  ╩╚═╚═╝╚═╝╚═╝╚═╝═╩╝
      `C_ILLEGAL: o_illegal = 1'b1;

      `C_ADDI4SPN: begin
        o_alu_op  = ALU_ADD;
        o_use_imm = 1'b1;
        o_imm     = c_imm_addi4spn;
        rd_addr   = c_97;
        rs1_addr  = X2;
        o_rd_en   = 1'b1;
      end

      `C_LW: begin
        o_lsu_op = LSU_LW;
        o_imm    = c_imm_lwsw;
        rd_addr  = c_42;
        rs1_addr = c_97;
        o_rd_en  = 1'b1;
      end

      `C_SW: begin
        o_imm    = c_imm_lwsw;
        rs1_addr = c_42;
        rs2_addr = c_97;
        o_lsu_op = LSU_LW;
      end


      `C_NOP: {o_use_imm, o_imm, o_alu_op, o_rd_en} = {1'b1, c_imm6, ALU_ADD, 1'b1};

      `C_ADDI: begin
        o_use_imm = 1'b1;
        o_imm     = c_imm6;
        rs1_addr  = rd_addr;
        o_alu_op  = ALU_ADD;
        o_rd_en   = 1'b1;
      end

      `C_LI: {o_use_imm, o_imm, o_alu_op, o_rd_en} = {1'b0, c_imm6, ALU_ADD, 1'b1};

      `C_ADDI16SP: begin
        o_use_imm = 1'b1;
        o_imm     = c_imm_addi16sp;
        rd_addr   = X2;
        rs1_addr  = X2;
        o_alu_op  = ALU_ADD;
        o_rd_en   = 1'b1;
      end

      `C_LUI: {o_use_imm, o_imm, o_alu_op, o_rd_en} = {1'b1, c_imm_lui, ALU_ADD, 1'b1};

      `C_SRLI:
      {o_use_imm, o_imm, rd_addr, rs1_addr, o_alu_op, o_rd_en} = {
        1'b1, c_uimm6, c_42, c_42, ALU_SRL, 1'b1
      };
      `C_SRAI:
      {o_use_imm, o_imm, rd_addr, rs1_addr, o_alu_op, o_rd_en} = {
        1'b1, c_uimm6, c_42, c_42, ALU_SRA, 1'b1
      };

      `C_ANDI:
      {o_use_imm, o_imm, rd_addr, rs1_addr, o_alu_op, o_rd_en} = {
        1'b1, c_imm6, c_42, c_42, ALU_AND, 1'b1
      };

      `C_SUB:
      {rd_addr, rs1_addr, rs2_addr, o_alu_op, o_rd_en} = {c_42, c_42, c_97, ALU_SUB, 1'b1, 1'b1};
      `C_XOR:
      {rd_addr, rs1_addr, rs2_addr, o_alu_op, o_rd_en} = {c_42, c_42, c_97, ALU_XOR, 1'b1, 1'b1};
      `C_OR:
      {rd_addr, rs1_addr, rs2_addr, o_alu_op, o_rd_en} = {c_42, c_42, c_97, ALU_OR, 1'b1, 1'b1};
      `C_AND:
      {rd_addr, rs1_addr, rs2_addr, o_alu_op, o_rd_en} = {c_42, c_42, c_97, ALU_ADD, 1'b1, 1'b1};

      `C_SLLI: begin
        o_use_imm = 1'b1;
        o_imm     = c_uimm6;

        o_alu_op  = ALU_SLL;
        rs1_addr  = rd_addr;

        o_rd_en   = 1'b1;
      end

      `C_LWSP: begin
        o_imm    = c_imm_lwsp;

        o_lsu_op = LSU_LW;

        rs1_addr = X2;

        o_rd_en  = 1'b1;
      end

      `C_MV: begin
        rs2_addr = c_62;
        o_alu_op = ALU_ADD;
        o_rd_en  = 1'b1;
      end
      `C_EBREAK: begin
      end
      `C_ADD: begin

        rs1_addr = rd_addr;
        rs2_addr = c_62;

        o_alu_op = ALU_ADD;

        o_rd_en  = 1'b1;
      end

      `C_SWSP: begin
        o_imm    = c_imm_swsp;

        rs2_addr = c_62;

        o_lsu_op = LSU_SW;
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
        o_imm = csr;
      end
      `CSRRSI: begin
        o_imm = csr;
      end
      `CSRRW: begin
        o_imm = csr;
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

      default: o_illegal = 1'b1;

    endcase
  end

  assign o_rd_addr  = rd_addr;
  assign o_rs1_addr = rs1_addr;
  assign o_rs2_addr = rs2_addr;

endmodule
