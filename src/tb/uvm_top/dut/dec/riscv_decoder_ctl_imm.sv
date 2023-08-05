// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module riscv_decoder_imm (
  input  logic                     clk,         // unused
  input  logic                     rst_n,       // unused
  input  logic [             31:0] instr,
  input  logic                     compressed,
  output logic [    DataWidth-1:0] imm,
  output logic                     rd_en,
  output logic                     use_imm,
  output logic                     use_pc,
  output logic [   AluOpWidth-1:0] alu_op,
  output logic [   LsuOpWidth-1:0] lsu_op,
  output logic [BranchOpWidth-1:0] br_op,
  output logic                     br,
  output logic                     alu,
  output logic                     lsu
);

  logic [31:0] i;

  assign i[31:0] = instr[31:0];

  logic [15:0] in16;

  assign in16 = instr[15:0];

  // Zero-extended RS2
  // TODO: Remove
  logic [DataWidth-1:0] ze_rs2;

  logic [          4:0] c_rd_rs1;
  logic [          4:0] c_rs2;

  logic [DataWidth-1:0] imm_I;
  logic [DataWidth-1:0] imm_S;
  logic [DataWidth-1:0] imm_B;
  logic [DataWidth-1:0] imm_U;
  logic [DataWidth-1:0] imm_J;

  logic [         11:0] csr;

  // For extracting various C_* fields
  logic [DataWidth-1:0] c_imm_addi4spn;
  // logic [   DataWidth-1:0] c_uimm5;
  logic [DataWidth-1:0] c_imm6;
  logic [DataWidth-1:0] c_imm_j;
  logic [DataWidth-1:0] c_imm_addi16sp;
  logic [DataWidth-1:0] c_imm_lui;
  logic [DataWidth-1:0] c_imm_lwsw;
  logic [DataWidth-1:0] c_imm_lwsp;
  logic [DataWidth-1:0] c_imm_swsp;
  logic [DataWidth-1:0] c_imm_b;
  logic [DataWidth-1:0] c_uimm6;

  // TODO: Remove
  assign ze_rs2         = {27'b0, i[24:20]};

  assign imm_I          = {{20{i[31]}}, i[31:20]};
  assign imm_S          = {{20{i[31]}}, i[31:25], i[11:7]};
  assign imm_B          = {{20{i[31]}}, i[7], i[30:25], i[11:8], 1'b0};
  assign imm_U          = {i[31:12], 12'b0};
  assign imm_J          = {{12{i[31]}}, i[19:12], i[20], i[30:21], 1'b0};

  assign csr            = i[31:20];

  assign c_imm_addi4spn = {22'b0, i[10:7], i[12:11], i[5], i[6], 2'b00};

  // assign c_uimm5        = {25'b0, i[6:5], i[12:10], 2'b00};

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

  always_comb begin
    use_imm = 1'b0;
    use_pc  = 1'b0;

    rd_en   = 1'b0;

    lsu_op  = 4'bXXXX;

    alu     = 0;
    lsu     = 0;
    lui     = 0;
    auipc   = 0;
    csr     = 0;
    fencei  = 0;
    fence   = 0;
    illegal = 0;

    alu_op  = ALU_ADD;

    imm     = 'bX;
    br_op   = 'h0;

    if (compressed) begin
      casez (i)

        //  ╔═╗ ╔╗ ╦═╗╔═╗╔╗╔╔═╗╦ ╦
        //  ║───╠╩╗╠╦╝╠═╣║║║║  ╠═╣
        //  ╚═╝ ╚═╝╩╚═╩ ╩╝╚╝╚═╝╩ ╩
        `C_J: begin
          use_imm = 1'b1;
          rd_en   = 1'b1;
          alu_op  = ALU_ADD;
          alu     = 1'b1;
          imm     = c_imm_j;

        end
        `C_JAL: begin
          use_imm = 1'b1;
          rd_en   = 1'b1;
          alu_op  = ALU_ADD;
          alu     = 1'b1;
          imm     = c_imm_j;

        end
        `C_JALR: begin
          use_imm = 1'b1;
          rd_en   = 1'b1;
          alu_op  = ALU_ADD;
          alu     = 1'b1;
          imm     = 'h0;
        end
        `C_JR: begin
          use_imm = 1'b1;
          alu_op  = ALU_ADD;
          alu     = 1'b1;
          imm     = 'h0;
        end

        `C_BEQZ: begin
          use_imm = 1'b1;
          imm     = c_imm_b;
          br_op   = BR_BEQZ;

        end
        `C_BNEZ: begin
          use_imm = 1'b1;
          imm     = c_imm_b;
          br_op   = BR_BNEZ;
        end

        //  ╔═╗╔═╗╔╦╗╔═╗╦═╗╔═╗╔═╗╔═╗╔═╗╔╦╗
        //  ║  ║ ║║║║╠═╝╠╦╝║╣ ╚═╗╚═╗║╣  ║║
        //  ╚═╝╚═╝╩ ╩╩  ╩╚═╚═╝╚═╝╚═╝╚═╝═╩╝
        `C_ILLEGAL: illegal = 1'b1;

        `C_ADDI4SPN: begin
          alu_op  = ALU_ADD;
          use_imm = 1'b1;
          rd_en   = 1'b1;
          alu     = 1'b1;
          imm     = c_imm_addi4spn;

        end

        `C_LW: begin
          lsu_op = LSU_LW;
          rd_en  = 1'b1;
          lsu    = 1'b1;
          imm    = c_imm_lwsw;

        end

        `C_SW: begin
          lsu_op = LSU_LW;
          lsu    = 1'b1;
          imm    = c_imm_lwsw;

        end


        `C_NOP: {use_imm, alu_op, rd_en, alu, imm} = {1'b1, ALU_ADD, 1'b1, 1'b1, c_imm6};

        `C_ADDI: begin
          use_imm = 1'b1;
          alu_op  = ALU_ADD;
          rd_en   = 1'b1;
          alu     = 1'b1;
          imm     = c_imm6;

        end

        `C_LI: {use_imm, alu_op, rd_en, alu, imm} = {1'b1, ALU_ADD, 1'b1, 1'b1, c_imm6};

        `C_ADDI16SP: begin
          use_imm = 1'b1;
          alu_op  = ALU_ADD;
          rd_en   = 1'b1;
          alu     = 1'b1;
          imm     = c_imm_addi16sp;

        end

        `C_LUI: {use_imm, alu_op, rd_en, alu, lui, imm} = {1'b1, ALU_ADD, 1'b1, 1'b1, 1'b1, c_imm_lui};

        `C_SRLI: {use_imm, alu_op, rd_en, alu, imm} = {1'b1, ALU_SRL, 1'b1, 1'b1, c_imm6};
        `C_SRAI: {use_imm, alu_op, rd_en, alu, imm} = {1'b1, ALU_SRA, 1'b1, 1'b1, c_imm6};

        `C_ANDI: {use_imm, alu_op, rd_en, alu, imm} = {1'b1, ALU_AND, 1'b1, 1'b1, c_imm6};

        `C_SUB: {alu_op, rd_en, alu} = {ALU_SUB, 1'b1, 1'b1};
        `C_XOR: {alu_op, rd_en, alu} = {ALU_XOR, 1'b1, 1'b1};
        `C_OR:  {alu_op, rd_en, alu} = {ALU_OR, 1'b1, 1'b1};
        `C_AND: {alu_op, rd_en, alu} = {ALU_ADD, 1'b1, 1'b1};

        `C_SLLI: begin
          use_imm = 1'b1;

          alu_op  = ALU_SLL;

          rd_en   = 1'b1;
          alu     = 1'b1;
          imm     = c_imm6;
        end

        `C_LWSP: begin

          lsu_op = LSU_LW;

          rd_en  = 1'b1;
          lsu    = 1'b1;
          imm    = c_imm_lwsp;

        end

        `C_MV: begin
          alu_op = ALU_ADD;
          rd_en  = 1'b1;
          alu    = 1'b1;
        end
        `C_EBREAK: begin
        end
        `C_ADD: begin

          alu_op = ALU_ADD;

          rd_en  = 1'b1;
          alu    = 1'b1;
        end

        `C_SWSP: begin


          lsu_op = LSU_SW;
          lsu    = 1'b1;
          imm    = c_imm_swsp;

        end

        default: illegal = 1'b1;

      endcase
    end else begin
      casez (i)

        //  ╦   ╔╗ ╦═╗╔═╗╔╗╔╔═╗╦ ╦
        //  ║───╠╩╗╠╦╝╠═╣║║║║  ╠═╣
        //  ╩   ╚═╝╩╚═╩ ╩╝╚╝╚═╝╩ ╩
        `JAL: begin
          rd_en   = 1'b1;
          use_imm = 1'b1;
          alu_op  = ALU_ADD;
          alu     = 1'b1;
          imm     = imm_J;

        end
        `JALR: begin
          use_imm = 1'b1;
          rd_en   = 1'b1;
          alu_op  = ALU_ADD;
          alu     = 1'b1;

          imm     = imm_I;

        end

        `BEQ:  {br_op, imm, use_pc, use_imm} = {BR_BEQ, imm_B, 1'b1, 1'b1};
        `BGE:  {br_op, imm, use_pc, use_imm} = {BR_BGE, imm_B, 1'b1, 1'b1};
        `BGEU: {br_op, imm, use_pc, use_imm} = {BR_BGEU, imm_B, 1'b1, 1'b1};
        `BLT:  {br_op, imm, use_pc, use_imm} = {BR_BLT, imm_B, 1'b1, 1'b1};
        `BLTU: {br_op, imm, use_pc, use_imm} = {BR_BLTU, imm_B, 1'b1, 1'b1};
        `BNE:  {br_op, imm, use_pc, use_imm} = {BR_BNE, imm_B, 1'b1, 1'b1};

        //  ╦   ╔═╗╦═╗╔═╗  ╔╗ ╦═╗╔═╗╔╗╔╔═╗╦ ╦
        //  ║───╠═╝╠╦╝║╣───╠╩╗╠╦╝╠═╣║║║║  ╠═╣
        //  ╩   ╩  ╩╚═╚═╝  ╚═╝╩╚═╩ ╩╝╚╝╚═╝╩ ╩
        `AUIPC: {use_imm, use_pc, alu_op, alu, auipc, rd_en, imm} = {1'b1, 1'b1, ALU_ADD, 1'b1, 1'b1, 1'b1, imm_U};
        `LUI:   {use_imm, alu_op, alu, lui, rd_en, imm} = {1'b1, ALU_ADD, 1'b1, 1'b1, 1'b1, imm_U};

        //  ╦  ╔═╗╔═╗╔╦╗
        //  ║  ║ ║╠═╣ ║║
        //  ╩═╝╚═╝╩ ╩═╩╝
        `LW: {lsu_op, rd_en, lsu, imm, use_imm} = {LSU_LW, 1'b1, 1'b1, imm_I, 1'b1};
        `LH: {lsu_op, rd_en, lsu, imm, use_imm} = {LSU_LH, 1'b1, 1'b1, imm_I, 1'b1};
        `LB: {lsu_op, rd_en, lsu, imm, use_imm} = {LSU_LB, 1'b1, 1'b1, imm_I, 1'b1};

        `LHU: {lsu_op, rd_en, lsu, imm, use_imm} = {LSU_LHU, 1'b1, 1'b1, imm_I, 1'b1};
        `LBU: {lsu_op, rd_en, lsu, imm, use_imm} = {LSU_LBU, 1'b1, 1'b1, imm_I, 1'b1};

        //  ╔═╗╔╦╗╔═╗╦═╗╔═╗
        //  ╚═╗ ║ ║ ║╠╦╝║╣
        //  ╚═╝ ╩ ╚═╝╩╚═╚═╝
        `SB: {lsu_op, lsu, imm, use_imm} = {LSU_SB, 1'b1, imm_S, 1'b1};
        `SH: {lsu_op, lsu, imm, use_imm} = {LSU_SH, 1'b1, imm_S, 1'b1};
        `SW: {lsu_op, lsu, imm, use_imm} = {LSU_SW, 1'b1, imm_S, 1'b1};

        //  ╦╔╗╔╔╦╗╔═╗╔═╗╔═╗╦═╗
        //  ║║║║ ║ ║╣ ║ ╦║╣ ╠╦╝
        //  ╩╝╚╝ ╩ ╚═╝╚═╝╚═╝╩╚═
        `ADD: {alu_op, rd_en, alu} = {ALU_ADD, 1'b1, 1'b1};
        `AND: {alu_op, rd_en, alu} = {ALU_AND, 1'b1, 1'b1};

        `OR: {alu_op, rd_en, alu} = {ALU_OR, 1'b1, 1'b1};

        `XOR: {alu_op, rd_en, alu} = {ALU_XOR, 1'b1, 1'b1};
        `SUB: {alu_op, rd_en, alu} = {ALU_SUB, 1'b1, 1'b1};

        `ADDI: {use_imm, alu_op, rd_en, alu, imm} = {1'b1, ALU_ADD, 1'b1, 1'b1, imm_I};
        `ANDI: {use_imm, alu_op, rd_en, alu, imm} = {1'b1, ALU_AND, 1'b1, 1'b1, imm_I};
        `ORI:  {use_imm, alu_op, rd_en, alu, imm} = {1'b1, ALU_OR, 1'b1, 1'b1, imm_I};
        `XORI: {use_imm, alu_op, rd_en, alu, imm} = {1'b1, ALU_XOR, 1'b1, 1'b1, imm_I};

        `SLL:  {alu_op, rd_en, alu} = {ALU_SLL, 1'b1, 1'b1};
        `SLT:  {alu_op, rd_en, alu} = {ALU_SLT, 1'b1, 1'b1};
        `SLTU: {alu_op, rd_en, alu} = {ALU_SLTU, 1'b1, 1'b1};

        `SRA: {alu_op, rd_en, alu} = {ALU_SRA, 1'b1, 1'b1};
        `SRL: {alu_op, rd_en, alu} = {ALU_SRL, 1'b1, 1'b1};

        `SLLI:  {use_imm, alu_op, rd_en, alu, imm} = {1'b1, ALU_SLL, 1'b1, 1'b1, ze_rs2};
        `SLTI:  {use_imm, alu_op, rd_en, alu, imm} = {1'b1, ALU_SLT, 1'b1, 1'b1, imm_I};
        `SLTIU: {use_imm, alu_op, rd_en, alu, imm} = {1'b1, ALU_SLTU, 1'b1, 1'b1, imm_I};

        `SRAI: {use_imm, alu_op, rd_en, alu, imm} = {1'b1, ALU_SRA, 1'b1, 1'b1, ze_rs2};
        `SRLI: {use_imm, alu_op, rd_en, alu, imm} = {1'b1, ALU_SRL, 1'b1, 1'b1, ze_rs2};


        //  ╔╦╗╦ ╦╦ ╔╦╗╦╔═╗╦  ╦╔═╗╔═╗╔╦╗╦╔═╗╔╗╔
        //  ║║║║ ║║  ║ ║╠═╝║  ║║  ╠═╣ ║ ║║ ║║║║
        //  ╩ ╩╚═╝╩═╝╩ ╩╩  ╩═╝╩╚═╝╩ ╩ ╩ ╩╚═╝╝╚╝
        `MUL:    {alu_op, rd_en, alu} = {ALU_MUL, 1'b1, 1'b1};
        `MULH:   {alu_op, rd_en, alu} = {ALU_MULH, 1'b1, 1'b1};
        `MULHSU: {alu_op, rd_en, alu} = {ALU_MULHSU, 1'b1, 1'b1};
        `MULHU:  {alu_op, rd_en, alu} = {ALU_MULHU, 1'b1, 1'b1};
        `DIV:    {alu_op, rd_en, alu} = {ALU_DIV, 1'b1, 1'b1};
        `DIVU:   {alu_op, rd_en, alu} = {ALU_DIVU, 1'b1, 1'b1};
        `REM:    {alu_op, rd_en, alu} = {ALU_REM, 1'b1, 1'b1};
        `REMU:   {alu_op, rd_en, alu} = {ALU_REMU, 1'b1, 1'b1};

        //  ╔═╗╔═╗╦═╗
        //  ║  ╚═╗╠╦╝
        //  ╚═╝╚═╝╩╚═
        `CSRRC: begin
          csr = 1'b1;
          imm = csr;

        end
        `CSRRCI: begin
          csr = 1'b1;
          imm = csr;

        end
        `CSRRS: begin
          csr = 1'b1;
          imm = csr;

        end
        `CSRRSI: begin
          csr = 1'b1;
          imm = csr;

        end
        `CSRRW: begin
          csr = 1'b1;
          imm = csr;

        end
        `CSRRWI: begin
          csr = 1'b1;
          imm = csr;

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
        `FENCE, `FENCEI: begin  // insert NOP
          alu_op  = ALU_ADD;
          use_imm = 1'b1;
          alu     = 1'b1;
        end
        `WFI: begin
        end

        default: illegal = 1'b1;

      endcase
    end
  end

  riscv_decoder_br comb_br (
    .instr(in16),
    .br   (br)
  );
  riscv_decoder_j comb_j (
    .instr(in16),
    .j    (jal)
  );

endmodule
