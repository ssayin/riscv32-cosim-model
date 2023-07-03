// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`include "riscv_opcodes.svh"
import param_defs::*;
import instr_defs::*;

module riscv_decoder_ctl_imm (
  input  logic                         clk,         // unused
  input  logic                         rst_n,       // unused
  input  logic     [             31:0] instr,
  input  logic                         compressed,
  output logic     [    DataWidth-1:0] imm,
  output logic                         rd_en,
  output ctl_pkt_t                     ctl,
  output logic                         use_imm,
  output logic     [   AluOpWidth-1:0] alu_op,
  output logic     [   LsuOpWidth-1:0] lsu_op,
  output logic     [BranchOpWidth-1:0] br_op
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
    use_imm     = 1'b0;

    rd_en       = 1'b0;

    lsu_op      = 4'bXXXX;

    ctl.alu     = 0;
    ctl.lsu     = 0;
    ctl.lui     = 0;
    ctl.auipc   = 0;
    ctl.csr     = 0;
    ctl.fencei  = 0;
    ctl.fence   = 0;
    ctl.illegal = 0;

    alu_op      = ALU_ADD;

    imm         = 'bX;
    br_op       = 'h0;

    if (compressed) begin
      casez (i)

        //  ╔═╗ ╔╗ ╦═╗╔═╗╔╗╔╔═╗╦ ╦
        //  ║───╠╩╗╠╦╝╠═╣║║║║  ╠═╣
        //  ╚═╝ ╚═╝╩╚═╩ ╩╝╚╝╚═╝╩ ╩
        `C_J: begin
          use_imm = 1'b1;
          rd_en   = 1'b1;
          alu_op  = ALU_ADD;
          ctl.alu = 1'b1;
          imm     = c_imm_j;

        end
        `C_JAL: begin
          use_imm = 1'b1;
          rd_en   = 1'b1;
          alu_op  = ALU_ADD;
          ctl.alu = 1'b1;
          imm     = c_imm_j;

        end
        `C_JALR: begin
          use_imm = 1'b1;
          rd_en   = 1'b1;
          alu_op  = ALU_ADD;
          ctl.alu = 1'b1;
          imm     = 'h0;
        end
        `C_JR: begin
          use_imm = 1'b1;
          alu_op  = ALU_ADD;
          ctl.alu = 1'b1;
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
        `C_ILLEGAL: ctl.illegal = 1'b1;

        `C_ADDI4SPN: begin
          alu_op  = ALU_ADD;
          use_imm = 1'b1;
          rd_en   = 1'b1;
          ctl.alu = 1'b1;
          imm     = c_imm_addi4spn;

        end

        `C_LW: begin
          lsu_op  = LSU_LW;
          rd_en   = 1'b1;
          ctl.lsu = 1'b1;
          imm     = c_imm_lwsw;

        end

        `C_SW: begin
          lsu_op  = LSU_LW;
          ctl.lsu = 1'b1;
          imm     = c_imm_lwsw;

        end


        `C_NOP: {use_imm, alu_op, rd_en, ctl.alu, imm} = {1'b1, ALU_ADD, 1'b1, 1'b1, c_imm6};

        `C_ADDI: begin
          use_imm = 1'b1;
          alu_op  = ALU_ADD;
          rd_en   = 1'b1;
          ctl.alu = 1'b1;
          imm     = c_imm6;

        end

        `C_LI: {use_imm, alu_op, rd_en, ctl.alu, imm} = {1'b1, ALU_ADD, 1'b1, 1'b1, c_imm6};

        `C_ADDI16SP: begin
          use_imm = 1'b1;
          alu_op  = ALU_ADD;
          rd_en   = 1'b1;
          ctl.alu = 1'b1;
          imm     = c_imm_addi16sp;

        end

        `C_LUI:
        {use_imm, alu_op, rd_en, ctl.alu, ctl.lui, imm} = {
          1'b1, ALU_ADD, 1'b1, 1'b1, 1'b1, c_imm_lui
        };

        `C_SRLI: {use_imm, alu_op, rd_en, ctl.alu, imm} = {1'b1, ALU_SRL, 1'b1, 1'b1, c_imm6};
        `C_SRAI: {use_imm, alu_op, rd_en, ctl.alu, imm} = {1'b1, ALU_SRA, 1'b1, 1'b1, c_imm6};

        `C_ANDI: {use_imm, alu_op, rd_en, ctl.alu, imm} = {1'b1, ALU_AND, 1'b1, 1'b1, c_imm6};

        `C_SUB: {alu_op, rd_en, ctl.alu} = {ALU_SUB, 1'b1, 1'b1};
        `C_XOR: {alu_op, rd_en, ctl.alu} = {ALU_XOR, 1'b1, 1'b1};
        `C_OR:  {alu_op, rd_en, ctl.alu} = {ALU_OR, 1'b1, 1'b1};
        `C_AND: {alu_op, rd_en, ctl.alu} = {ALU_ADD, 1'b1, 1'b1};

        `C_SLLI: begin
          use_imm = 1'b1;

          alu_op  = ALU_SLL;

          rd_en   = 1'b1;
          ctl.alu = 1'b1;
          imm     = c_imm6;
        end

        `C_LWSP: begin

          lsu_op  = LSU_LW;

          rd_en   = 1'b1;
          ctl.lsu = 1'b1;
          imm     = c_imm_lwsp;

        end

        `C_MV: begin
          alu_op  = ALU_ADD;
          rd_en   = 1'b1;
          ctl.alu = 1'b1;
        end
        `C_EBREAK: begin
        end
        `C_ADD: begin

          alu_op  = ALU_ADD;

          rd_en   = 1'b1;
          ctl.alu = 1'b1;
        end

        `C_SWSP: begin


          lsu_op  = LSU_SW;
          ctl.lsu = 1'b1;
          imm     = c_imm_swsp;

        end

        default: ctl.illegal = 1'b1;

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
          ctl.alu = 1'b1;
          imm     = imm_J;

        end
        `JALR: begin
          use_imm = 1'b1;
          rd_en   = 1'b1;
          alu_op  = ALU_ADD;
          ctl.alu = 1'b1;

          imm     = imm_I;

        end

        `BEQ:  {br_op, imm} = {BR_BEQ, imm_B};
        `BGE:  {br_op, imm} = {BR_BGE, imm_B};
        `BGEU: {br_op, imm} = {BR_BGEU, imm_B};
        `BLT:  {br_op, imm} = {BR_BLT, imm_B};
        `BLTU: {br_op, imm} = {BR_BLTU, imm_B};
        `BNE:  {br_op, imm} = {BR_BNE, imm_B};

        //  ╦   ╔═╗╦═╗╔═╗  ╔╗ ╦═╗╔═╗╔╗╔╔═╗╦ ╦
        //  ║───╠═╝╠╦╝║╣───╠╩╗╠╦╝╠═╣║║║║  ╠═╣
        //  ╩   ╩  ╩╚═╚═╝  ╚═╝╩╚═╩ ╩╝╚╝╚═╝╩ ╩
        `AUIPC:
        {use_imm, alu_op, ctl.alu, ctl.auipc, rd_en, imm} = {
          1'b1, ALU_ADD, 1'b1, 1'b1, 1'b1, imm_U
        };
        `LUI:
        {use_imm, alu_op, ctl.alu, ctl.lui, rd_en, imm} = {1'b1, ALU_ADD, 1'b1, 1'b1, 1'b1, imm_U};

        //  ╦  ╔═╗╔═╗╔╦╗
        //  ║  ║ ║╠═╣ ║║
        //  ╩═╝╚═╝╩ ╩═╩╝
        `LW: {lsu_op, rd_en, ctl.lsu, imm} = {LSU_LW, 1'b1, 1'b1, imm_I};
        `LH: {lsu_op, rd_en, ctl.lsu, imm} = {LSU_LH, 1'b1, 1'b1, imm_I};
        `LB: {lsu_op, rd_en, ctl.lsu, imm} = {LSU_LB, 1'b1, 1'b1, imm_I};

        `LHU: {lsu_op, rd_en, ctl.lsu, imm} = {LSU_LHU, 1'b1, 1'b1, imm_I};
        `LBU: {lsu_op, rd_en, ctl.lsu, imm} = {LSU_LBU, 1'b1, 1'b1, imm_I};

        //  ╔═╗╔╦╗╔═╗╦═╗╔═╗
        //  ╚═╗ ║ ║ ║╠╦╝║╣
        //  ╚═╝ ╩ ╚═╝╩╚═╚═╝
        `SB: {lsu_op, ctl.lsu, imm} = {LSU_SB, 1'b1, imm_S};
        `SH: {lsu_op, ctl.lsu, imm} = {LSU_SH, 1'b1, imm_S};
        `SW: {lsu_op, ctl.lsu, imm} = {LSU_SW, 1'b1, imm_S};

        //  ╦╔╗╔╔╦╗╔═╗╔═╗╔═╗╦═╗
        //  ║║║║ ║ ║╣ ║ ╦║╣ ╠╦╝
        //  ╩╝╚╝ ╩ ╚═╝╚═╝╚═╝╩╚═
        `ADD: {alu_op, rd_en, ctl.alu} = {ALU_ADD, 1'b1, 1'b1};
        `AND: {alu_op, rd_en, ctl.alu} = {ALU_AND, 1'b1, 1'b1};

        `OR: {alu_op, rd_en, ctl.alu} = {ALU_OR, 1'b1, 1'b1};

        `XOR: {alu_op, rd_en, ctl.alu} = {ALU_XOR, 1'b1, 1'b1};
        `SUB: {alu_op, rd_en, ctl.alu} = {ALU_SUB, 1'b1, 1'b1};

        `ADDI: {use_imm, alu_op, rd_en, ctl.alu, imm} = {1'b1, ALU_ADD, 1'b1, 1'b1, imm_I};
        `ANDI: {use_imm, alu_op, rd_en, ctl.alu, imm} = {1'b1, ALU_AND, 1'b1, 1'b1, imm_I};
        `ORI:  {use_imm, alu_op, rd_en, ctl.alu, imm} = {1'b1, ALU_OR, 1'b1, 1'b1, imm_I};
        `XORI: {use_imm, alu_op, rd_en, ctl.alu, imm} = {1'b1, ALU_XOR, 1'b1, 1'b1, imm_I};

        `SLL:  {alu_op, rd_en, ctl.alu} = {ALU_SLL, 1'b1, 1'b1};
        `SLT:  {alu_op, rd_en, ctl.alu} = {ALU_SLT, 1'b1, 1'b1};
        `SLTU: {alu_op, rd_en, ctl.alu} = {ALU_SLTU, 1'b1, 1'b1};

        `SRA: {alu_op, rd_en, ctl.alu} = {ALU_SRA, 1'b1, 1'b1};
        `SRL: {alu_op, rd_en, ctl.alu} = {ALU_SRL, 1'b1, 1'b1};

        `SLLI:  {use_imm, alu_op, rd_en, ctl.alu, imm} = {1'b1, ALU_SLL, 1'b1, 1'b1, ze_rs2};
        `SLTI:  {use_imm, alu_op, rd_en, ctl.alu, imm} = {1'b1, ALU_SLT, 1'b1, 1'b1, imm_I};
        `SLTIU: {use_imm, alu_op, rd_en, ctl.alu, imm} = {1'b1, ALU_SLTU, 1'b1, 1'b1, imm_I};

        `SRAI: {use_imm, alu_op, rd_en, ctl.alu, imm} = {1'b1, ALU_SRA, 1'b1, 1'b1, ze_rs2};
        `SRLI: {use_imm, alu_op, rd_en, ctl.alu, imm} = {1'b1, ALU_SRL, 1'b1, 1'b1, ze_rs2};


        //  ╔╦╗╦ ╦╦ ╔╦╗╦╔═╗╦  ╦╔═╗╔═╗╔╦╗╦╔═╗╔╗╔
        //  ║║║║ ║║  ║ ║╠═╝║  ║║  ╠═╣ ║ ║║ ║║║║
        //  ╩ ╩╚═╝╩═╝╩ ╩╩  ╩═╝╩╚═╝╩ ╩ ╩ ╩╚═╝╝╚╝
        `MUL:    {alu_op, rd_en, ctl.alu} = {ALU_MUL, 1'b1, 1'b1};
        `MULH:   {alu_op, rd_en, ctl.alu} = {ALU_MULH, 1'b1, 1'b1};
        `MULHSU: {alu_op, rd_en, ctl.alu} = {ALU_MULHSU, 1'b1, 1'b1};
        `MULHU:  {alu_op, rd_en, ctl.alu} = {ALU_MULHU, 1'b1, 1'b1};
        `DIV:    {alu_op, rd_en, ctl.alu} = {ALU_DIV, 1'b1, 1'b1};
        `DIVU:   {alu_op, rd_en, ctl.alu} = {ALU_DIVU, 1'b1, 1'b1};
        `REM:    {alu_op, rd_en, ctl.alu} = {ALU_REM, 1'b1, 1'b1};
        `REMU:   {alu_op, rd_en, ctl.alu} = {ALU_REMU, 1'b1, 1'b1};

        //  ╔═╗╔═╗╦═╗
        //  ║  ╚═╗╠╦╝
        //  ╚═╝╚═╝╩╚═
        `CSRRC: begin
          ctl.csr = 1'b1;
          imm     = csr;

        end
        `CSRRCI: begin
          ctl.csr = 1'b1;
          imm     = csr;

        end
        `CSRRS: begin
          ctl.csr = 1'b1;
          imm     = csr;

        end
        `CSRRSI: begin
          ctl.csr = 1'b1;
          imm     = csr;

        end
        `CSRRW: begin
          ctl.csr = 1'b1;
          imm     = csr;

        end
        `CSRRWI: begin
          ctl.csr = 1'b1;
          imm     = csr;

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
          ctl.alu = 1'b1;
        end
        `WFI: begin
        end

        default: ctl.illegal = 1'b1;

      endcase
    end
  end

  riscv_decoder_br comb_br (
    .instr(in16),
    .br   (ctl.br)
  );
  riscv_decoder_j comb_j (
    .instr(in16),
    .j    (ctl.jal)
  );

endmodule
