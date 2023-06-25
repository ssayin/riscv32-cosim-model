// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`define ADD 32'b0000000??????????000?????0110011
`define ADDI 32'b?????????????????000?????0010011
`define AND 32'b0000000??????????111?????0110011
`define ANDI 32'b?????????????????111?????0010011
`define AUIPC 32'b?????????????????????????0010111
`define BEQ 32'b?????????????????000?????1100011
`define BGE 32'b?????????????????101?????1100011
`define BGEU 32'b?????????????????111?????1100011
`define BLT 32'b?????????????????100?????1100011
`define BLTU 32'b?????????????????110?????1100011
`define BNE 32'b?????????????????001?????1100011
`define C_ADD 32'b????????????????1001??????????10
`define C_ADDI 32'b????????????????000???????????01
`define C_ADDI16SP 32'b????????????????011?00010?????01
`define C_ADDI4SPN 32'b????????????????000???????????00
`define C_AND 32'b????????????????100011???11???01
`define C_ANDI 32'b????????????????100?10????????01
`define C_BEQZ 32'b????????????????110???????????01
`define C_BNEZ 32'b????????????????111???????????01
`define C_EBREAK 32'b????????????????1001000000000010
`define C_JALR 32'b????????????????1001?????0000010
`define C_JAL 32'b????????????????001???????????01
`define C_JR 32'b????????????????1000?????0000010
`define C_LI 32'b????????????????010???????????01
`define C_LUI 32'b????????????????011???????????01
`define C_LW 32'b????????????????010???????????00
`define C_LWSP 32'b????????????????010???????????10
`define C_MV 32'b????????????????1000??????????10
`define C_NOP 32'b????????????????000?00000?????01
`define C_OR 32'b????????????????100011???10???01
`define C_SUB 32'b????????????????100011???00???01
`define C_SW 32'b????????????????110???????????00
`define C_SWSP 32'b????????????????110???????????10
`define C_XOR 32'b????????????????100011???01???01
`define CSRRC 32'b?????????????????011?????1110011
`define CSRRCI 32'b?????????????????111?????1110011
`define CSRRS 32'b?????????????????010?????1110011
`define CSRRSI 32'b?????????????????110?????1110011
`define CSRRW 32'b?????????????????001?????1110011
`define CSRRWI 32'b?????????????????101?????1110011
`define DIV 32'b0000001??????????100?????0110011
`define DIVU 32'b0000001??????????101?????0110011
`define EBREAK 32'b00000000000100000000000001110011
`define ECALL 32'b00000000000000000000000001110011
`define FENCE 32'b?????????????????000?????0001111
`define JALR 32'b?????????????????000?????1100111
`define LB 32'b?????????????????000?????0000011
`define LBU 32'b?????????????????100?????0000011
`define LH 32'b?????????????????001?????0000011
`define LHU 32'b?????????????????101?????0000011
`define LUI 32'b?????????????????????????0110111
`define LW 32'b?????????????????010?????0000011
`define MRET 32'b00110000001000000000000001110011
`define MUL 32'b0000001??????????000?????0110011
`define MULH 32'b0000001??????????001?????0110011
`define MULHSU 32'b0000001??????????010?????0110011
`define MULHU 32'b0000001??????????011?????0110011
`define OR 32'b0000000??????????110?????0110011
`define ORI 32'b?????????????????110?????0010011
`define REM 32'b0000001??????????110?????0110011
`define REMU 32'b0000001??????????111?????0110011
`define SB 32'b?????????????????000?????0100011
`define SH 32'b?????????????????001?????0100011
`define SLL 32'b0000000??????????001?????0110011
`define SLLI 32'b0000000??????????001?????0010011
`define SLT 32'b0000000??????????010?????0110011
`define SLTI 32'b?????????????????010?????0010011
`define SLTIU 32'b?????????????????011?????0010011
`define SLTU 32'b0000000??????????011?????0110011
`define SRA 32'b0100000??????????101?????0110011
`define SRAI 32'b0100000??????????101?????0010011
`define SRL 32'b0000000??????????101?????0110011
`define SRLI 32'b0000000??????????101?????0010011
`define SUB 32'b0100000??????????000?????0110011
`define SW 32'b?????????????????010?????0100011
`define WFI 32'b00010000010100000000000001110011
`define XOR 32'b0000000??????????100?????0110011
`define XORI 32'b?????????????????100?????0010011
`define C_J 32'b????????????????101???????????01
`define JAL 32'b?????????????????????????1101111
`define C_ILLEGAL 32'b????????????????0000000000000000
`define C_SLLI 32'b????????????????000???????????10

`define C_SRAI 32'b????????????????100?01????????01
`define C_SRLI 32'b????????????????100?00????????01

`define FENCEI 32'b00000000000000000001000000001111


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

  logic [4:0] c_42;
  logic [4:0] c_62;
  logic [4:0] c_97;


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

module riscv_decoder_ctl_imm (
    input  logic                      clk,         // unused
    input  logic                      rst_n,       // unused
    input  logic     [          31:0] instr,
    input  logic                      compressed,
    output logic     [ DataWidth-1:0] imm,
    output logic                      rd_en,
    output ctl_pkt_t                  ctl,
    output logic                      use_imm,
    output logic     [AluOpWidth-1:0] alu_op,
    output logic     [LsuOpWidth-1:0] lsu_op
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

        end
        `C_BNEZ: begin
          use_imm = 1'b1;
          imm     = c_imm_b;

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

        `BEQ:  {use_imm, imm} = {1'b1, imm_B};
        `BGE:  {use_imm, imm} = {1'b1, imm_B};
        `BGEU: {use_imm, imm} = {1'b1, imm_B};
        `BLT:  {use_imm, imm} = {1'b1, imm_B};
        `BLTU: {use_imm, imm} = {1'b1, imm_B};
        `BNE:  {use_imm, imm} = {1'b1, imm_B};

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
      .br(ctl.br)
  );
  riscv_decoder_j comb_j (
      .instr(in16),
      .j(ctl.jal)
  );

endmodule

module riscv_decoder (
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
    output logic     [  LsuOpWidth-1:0] lsu_op
);

  logic compressed;

  assign compressed = ~(instr[0] & instr[1]);

  riscv_decoder_gpr dec_gpr (
      .clk       (clk),
      .rst_n     (rst_n),
      .instr     (instr),
      .compressed(compressed),
      .rd_addr   (rd_addr),
      .rs1_addr  (rs1_addr),
      .rs2_addr  (rs2_addr)
  );

  riscv_decoder_ctl_imm dec_ctl_imm (
      .clk       (clk),
      .rst_n     (rst_n),
      .instr     (instr),
      .compressed(compressed),
      .imm       (imm),
      .rd_en     (rd_en),
      .ctl       (ctl),
      .use_imm   (use_imm),
      .alu_op    (alu_op),
      .lsu_op    (lsu_op)
  );



endmodule
