// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0





module riscv_decoder
  import param_defs::*;
  import instr_defs::*;
#(
  `include "riscv_opcodes.svh"
) (
  input  logic                        clk,       // unused
  input  logic                        rst_n,     // unused
  input  logic     [            31:0] instr,
  input  logic     [   DataWidth-1:0] pc,
  output logic     [   DataWidth-1:0] imm,
  output logic     [RegAddrWidth-1:0] rd_addr,   // DO NOT ASSIGN
  output logic     [RegAddrWidth-1:0] rs1_addr,  // DO NOT ASSIGN
  output logic     [RegAddrWidth-1:0] rs2_addr,  // DO NOT ASSIGN
  output logic                        rd_en,
  output ctl_pkt_t                    ctl,
  output logic                        use_imm,
  output logic     [  AluOpWidth-1:0] alu_op,
  output logic     [  LsuOpWidth-1:0] lsu_op,
  output logic     [   DataWidth-1:0] exp_code
);

  localparam logic [RegAddrWidth-1:0] X0 = 5'b00000;
  localparam logic [RegAddrWidth-1:0] X1 = 5'b00001;
  localparam logic [RegAddrWidth-1:0] X2 = 5'b00010;

  logic [            31:0] i;

  logic [RegAddrWidth-1:0] rd_addr_next;
  logic [RegAddrWidth-1:0] rs1_addr_next;
  logic [RegAddrWidth-1:0] rs2_addr_next;

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

  assign i[31:0]        = instr[31:0];

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
    ctl.illegal   = 1'b0;
    imm           = 32'b0;
    use_imm       = 1'b0;

    rs1_addr_next = i[19:15];
    rs2_addr_next = i[24:20];
    rd_addr_next  = i[11:7];

    rd_en         = 1'b0;

    // Default for branches and jumps
    ctl.alu       = 1'b0;

    ctl.lsu       = 1'b0;
    lsu_op        = 4'bXXXX;

    ctl.csr       = 1'b0;
    ctl.lui       = 1'b0;
    ctl.auipc     = 1'b0;
    ctl.br        = 1'b0;
    ctl.jal       = 1'b0;

    ctl.fencei    = 1'b0;
    ctl.fence     = 1'b0;

    casez (i)

      //  ╔═╗ ╔╗ ╦═╗╔═╗╔╗╔╔═╗╦ ╦
      //  ║───╠╩╗╠╦╝╠═╣║║║║  ╠═╣
      //  ╚═╝ ╚═╝╩╚═╩ ╩╝╚╝╚═╝╩ ╩
      `C_J: begin
        use_imm      = 1'b1;
        imm          = c_imm_j;
        rd_addr_next = X0;
        rd_en        = 1'b1;
        alu_op       = ALU_ADD;
        ctl.alu      = 1'b1;
        ctl.jal      = 1'b1;
      end
      `C_JAL: begin
        use_imm      = 1'b1;
        imm          = c_imm_j;
        rd_en        = 1'b1;
        rd_addr_next = X1;
        alu_op       = ALU_ADD;
        ctl.alu      = 1'b1;
        ctl.jal      = 1'b1;
      end
      `C_JALR: begin
        use_imm       = 1'b1;
        imm           = 'h0;
        rs1_addr_next = rd_addr_next;
        rd_addr_next  = X1;
        rd_en         = 1'b1;
        alu_op        = ALU_ADD;
        ctl.alu       = 1'b1;
      end
      `C_JR: begin
        use_imm       = 1'b1;
        imm           = 'h0;
        rs1_addr_next = rd_addr_next;
        rd_addr_next  = X0;
        alu_op        = ALU_ADD;
        ctl.alu       = 1'b1;
      end

      `C_BEQZ: begin
        use_imm       = 1'b1;
        rs1_addr_next = c_42;
        rs2_addr_next = X0;
        imm           = c_imm_b;
        ctl.br        = 1'b1;
      end
      `C_BNEZ: begin
        use_imm       = 1'b1;
        rs1_addr_next = c_42;
        rs2_addr_next = X0;
        imm           = c_imm_b;
        ctl.br        = 1'b1;
      end

      //  ╦   ╔╗ ╦═╗╔═╗╔╗╔╔═╗╦ ╦
      //  ║───╠╩╗╠╦╝╠═╣║║║║  ╠═╣
      //  ╩   ╚═╝╩╚═╩ ╩╝╚╝╚═╝╩ ╩
      `JAL: begin
        imm     = imm_J;
        rd_en   = 1'b1;
        use_imm = 1'b1;
        alu_op  = ALU_ADD;
        ctl.alu = 1'b1;
        ctl.jal = 1'b1;
      end
      `JALR: begin
        use_imm = 1'b1;
        imm     = imm_I;
        rd_en   = 1'b1;
        alu_op  = ALU_ADD;
        ctl.alu = 1'b1;
      end

      `BEQ:  {use_imm, imm, ctl.br} = {1'b1, imm_B, 1'b1};
      `BGE:  {use_imm, imm, ctl.br} = {1'b1, imm_B, 1'b1};
      `BGEU: {use_imm, imm, ctl.br} = {1'b1, imm_B, 1'b1};
      `BLT:  {use_imm, imm, ctl.br} = {1'b1, imm_B, 1'b1};
      `BLTU: {use_imm, imm, ctl.br} = {1'b1, imm_B, 1'b1};
      `BNE:  {use_imm, imm, ctl.br} = {1'b1, imm_B, 1'b1};

      //  ╦   ╔═╗╦═╗╔═╗  ╔╗ ╦═╗╔═╗╔╗╔╔═╗╦ ╦
      //  ║───╠═╝╠╦╝║╣───╠╩╗╠╦╝╠═╣║║║║  ╠═╣
      //  ╩   ╩  ╩╚═╚═╝  ╚═╝╩╚═╩ ╩╝╚╝╚═╝╩ ╩
      `AUIPC:
      {use_imm, imm, alu_op, ctl.alu, ctl.auipc, rd_en} = {1'b1, imm_U, ALU_ADD, 1'b1, 1'b1, 1'b1};
      `LUI:
      {use_imm, imm, alu_op, ctl.alu, ctl.lui, rd_en} = {1'b1, imm_U, ALU_ADD, 1'b1, 1'b1, 1'b1};

      //  ╦  ╔═╗╔═╗╔╦╗
      //  ║  ║ ║╠═╣ ║║
      //  ╩═╝╚═╝╩ ╩═╩╝
      `LW: {imm, lsu_op, rd_en, ctl.lsu} = {imm_I, LSU_LW, 1'b1, 1'b1};
      `LH: {imm, lsu_op, rd_en, ctl.lsu} = {imm_I, LSU_LH, 1'b1, 1'b1};
      `LB: {imm, lsu_op, rd_en, ctl.lsu} = {imm_I, LSU_LB, 1'b1, 1'b1};

      `LHU: {imm, lsu_op, rd_en, ctl.lsu} = {imm_I, LSU_LHU, 1'b1, 1'b1};
      `LBU: {imm, lsu_op, rd_en, ctl.lsu} = {imm_I, LSU_LBU, 1'b1, 1'b1};

      //  ╔═╗╔╦╗╔═╗╦═╗╔═╗
      //  ╚═╗ ║ ║ ║╠╦╝║╣
      //  ╚═╝ ╩ ╚═╝╩╚═╚═╝
      `SB: {imm, lsu_op, ctl.lsu} = {imm_S, LSU_SB, 1'b1};
      `SH: {imm, lsu_op, ctl.lsu} = {imm_S, LSU_SH, 1'b1};
      `SW: {imm, lsu_op, ctl.lsu} = {imm_S, LSU_SW, 1'b1};

      //  ╦╔╗╔╔╦╗╔═╗╔═╗╔═╗╦═╗
      //  ║║║║ ║ ║╣ ║ ╦║╣ ╠╦╝
      //  ╩╝╚╝ ╩ ╚═╝╚═╝╚═╝╩╚═
      `ADD: {alu_op, rd_en, ctl.alu} = {ALU_ADD, 1'b1, 1'b1};
      `AND: {alu_op, rd_en, ctl.alu} = {ALU_AND, 1'b1, 1'b1};

      `OR: {alu_op, rd_en, ctl.alu} = {ALU_OR, 1'b1, 1'b1};

      `XOR: {alu_op, rd_en, ctl.alu} = {ALU_XOR, 1'b1, 1'b1};
      `SUB: {alu_op, rd_en, ctl.alu} = {ALU_SUB, 1'b1, 1'b1};

      `ADDI: {use_imm, imm, alu_op, rd_en, ctl.alu} = {1'b1, imm_I, ALU_ADD, 1'b1, 1'b1};
      `ANDI: {use_imm, imm, alu_op, rd_en, ctl.alu} = {1'b1, imm_I, ALU_AND, 1'b1, 1'b1};
      `ORI:  {use_imm, imm, alu_op, rd_en, ctl.alu} = {1'b1, imm_I, ALU_OR, 1'b1, 1'b1};
      `XORI: {use_imm, imm, alu_op, rd_en, ctl.alu} = {1'b1, imm_I, ALU_XOR, 1'b1, 1'b1};

      `SLL:  {alu_op, rd_en, ctl.alu} = {ALU_SLL, 1'b1, 1'b1};
      `SLT:  {alu_op, rd_en, ctl.alu} = {ALU_SLT, 1'b1, 1'b1};
      `SLTU: {alu_op, rd_en, ctl.alu} = {ALU_SLTU, 1'b1, 1'b1};

      `SRA: {alu_op, rd_en, ctl.alu} = {ALU_SRA, 1'b1, 1'b1};
      `SRL: {alu_op, rd_en, ctl.alu} = {ALU_SRL, 1'b1, 1'b1};

      `SLLI:  {use_imm, imm, alu_op, rd_en, ctl.alu} = {1'b1, ze_rs2, ALU_SLL, 1'b1, 1'b1};
      `SLTI:  {use_imm, imm, alu_op, rd_en, ctl.alu} = {1'b1, imm_I, ALU_SLT, 1'b1, 1'b1};
      `SLTIU: {use_imm, imm, alu_op, rd_en, ctl.alu} = {1'b1, imm_I, ALU_SLTU, 1'b1, 1'b1};

      `SRAI: {use_imm, imm, alu_op, rd_en, ctl.alu} = {1'b1, ze_rs2, ALU_SRA, 1'b1, 1'b1};
      `SRLI: {use_imm, imm, alu_op, rd_en, ctl.alu} = {1'b1, ze_rs2, ALU_SRL, 1'b1, 1'b1};


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

      //  ╔═╗╔═╗╔╦╗╔═╗╦═╗╔═╗╔═╗╔═╗╔═╗╔╦╗
      //  ║  ║ ║║║║╠═╝╠╦╝║╣ ╚═╗╚═╗║╣  ║║
      //  ╚═╝╚═╝╩ ╩╩  ╩╚═╚═╝╚═╝╚═╝╚═╝═╩╝
      `C_ILLEGAL: ctl.illegal = 1'b1;

      `C_ADDI4SPN: begin
        alu_op        = ALU_ADD;
        use_imm       = 1'b1;
        imm           = c_imm_addi4spn;
        rd_addr_next  = c_97;
        rs1_addr_next = X2;
        rd_en         = 1'b1;
        ctl.alu       = 1'b1;
      end

      `C_LW: begin
        lsu_op        = LSU_LW;
        imm           = c_imm_lwsw;
        rd_addr_next  = c_42;
        rs1_addr_next = c_97;
        rd_en         = 1'b1;
        ctl.lsu       = 1'b1;
      end

      `C_SW: begin
        imm           = c_imm_lwsw;
        rs1_addr_next = c_42;
        rs2_addr_next = c_97;
        lsu_op        = LSU_LW;
        ctl.lsu       = 1'b1;
      end


      `C_NOP:
      {use_imm, imm, rd_addr_next, rs1_addr_next, alu_op, rd_en, ctl.alu} = {
        1'b1, c_imm6, X0, X0, ALU_ADD, 1'b1, 1'b1
      };

      `C_ADDI: begin
        use_imm       = 1'b1;
        imm           = c_imm6;
        rs1_addr_next = rd_addr_next;
        alu_op        = ALU_ADD;
        rd_en         = 1'b1;
        ctl.alu       = 1'b1;
      end

      `C_LI:
      {use_imm, imm, rs1_addr_next, alu_op, rd_en, ctl.alu} = {
        1'b1, c_imm6, X0, ALU_ADD, 1'b1, 1'b1
      };

      `C_ADDI16SP: begin
        use_imm       = 1'b1;
        imm           = c_imm_addi16sp;
        rd_addr_next  = X2;
        rs1_addr_next = X2;
        alu_op        = ALU_ADD;
        rd_en         = 1'b1;
        ctl.alu       = 1'b1;
      end

      `C_LUI:
      {use_imm, imm, alu_op, rd_en, ctl.alu, ctl.lui} = {
        1'b1, c_imm_lui, ALU_ADD, 1'b1, 1'b1, 1'b1
      };

      `C_SRLI:
      {use_imm, imm, rd_addr_next, rs1_addr_next, alu_op, rd_en, ctl.alu} = {
        1'b1, c_uimm6, c_42, c_42, ALU_SRL, 1'b1, 1'b1
      };
      `C_SRAI:
      {use_imm, imm, rd_addr_next, rs1_addr_next, alu_op, rd_en, ctl.alu} = {
        1'b1, c_uimm6, c_42, c_42, ALU_SRA, 1'b1, 1'b1
      };

      `C_ANDI:
      {use_imm, imm, rd_addr_next, rs1_addr_next, alu_op, rd_en, ctl.alu} = {
        1'b1, c_imm6, c_42, c_42, ALU_AND, 1'b1, 1'b1
      };

      `C_SUB:
      {rd_addr_next, rs1_addr_next, rs2_addr_next, alu_op, rd_en, ctl.alu} = {
        c_42, c_42, c_97, ALU_SUB, 1'b1, 1'b1
      };
      `C_XOR:
      {rd_addr_next, rs1_addr_next, rs2_addr_next, alu_op, rd_en, ctl.alu} = {
        c_42, c_42, c_97, ALU_XOR, 1'b1, 1'b1
      };
      `C_OR:
      {rd_addr_next, rs1_addr_next, rs2_addr_next, alu_op, rd_en, ctl.alu} = {
        c_42, c_42, c_97, ALU_OR, 1'b1, 1'b1
      };
      `C_AND:
      {rd_addr_next, rs1_addr_next, rs2_addr_next, alu_op, rd_en, ctl.alu} = {
        c_42, c_42, c_97, ALU_ADD, 1'b1, 1'b1
      };

      `C_SLLI: begin
        use_imm       = 1'b1;
        imm           = c_uimm6;

        alu_op        = ALU_SLL;
        rs1_addr_next = rd_addr_next;

        rd_en         = 1'b1;
        ctl.alu       = 1'b1;
      end

      `C_LWSP: begin
        imm           = c_imm_lwsp;

        lsu_op        = LSU_LW;

        rs1_addr_next = X2;

        rd_en         = 1'b1;
        ctl.lsu       = 1'b1;
      end

      `C_MV: begin
        rs1_addr_next = X0;
        rs2_addr_next = c_62;
        alu_op        = ALU_ADD;
        rd_en         = 1'b1;
        ctl.alu       = 1'b1;
      end
      `C_EBREAK: begin
      end
      `C_ADD: begin
        rs1_addr_next = rd_addr_next;
        rs2_addr_next = c_62;

        alu_op        = ALU_ADD;

        rd_en         = 1'b1;
        ctl.alu       = 1'b1;
      end

      `C_SWSP: begin
        imm           = c_imm_swsp;

        rs2_addr_next = c_62;

        lsu_op        = LSU_SW;
        ctl.lsu       = 1'b1;
      end

      //  ╔═╗╔═╗╦═╗
      //  ║  ╚═╗╠╦╝
      //  ╚═╝╚═╝╩╚═
      `CSRRC: begin
        imm     = csr;
        ctl.csr = 1'b1;
      end
      `CSRRCI: begin
        imm     = csr;
        ctl.csr = 1'b1;
      end
      `CSRRS: begin
        imm     = csr;
        ctl.csr = 1'b1;
      end
      `CSRRSI: begin
        imm     = csr;
        ctl.csr = 1'b1;
      end
      `CSRRW: begin
        imm     = csr;
        ctl.csr = 1'b1;
      end
      `CSRRWI: begin
        imm     = csr;
        ctl.csr = 1'b1;
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
        alu_op        = ALU_ADD;
        use_imm       = 1'b1;
        rd_addr_next  = X0;
        rs1_addr_next = X0;
        ctl.alu       = 1'b1;
      end
      `WFI: begin
      end

      default: ctl.illegal = 1'b1;

    endcase
  end

  assign rd_addr  = rd_addr_next;
  assign rs1_addr = rs1_addr_next;
  assign rs2_addr = rs2_addr_next;

endmodule
