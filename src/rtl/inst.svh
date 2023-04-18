// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef INST_OPCODES
`define INST_OPCODES

`define ADD                 32'b0000000??????????000?????0110011
`define ADDI                32'b?????????????????000?????0010011
`define AND                 32'b0000000??????????111?????0110011
`define ANDI                32'b?????????????????111?????0010011
`define AUIPC               32'b?????????????????????????0010111
`define BEQ                 32'b?????????????????000?????1100011
`define BGE                 32'b?????????????????101?????1100011
`define BGEU                32'b?????????????????111?????1100011
`define BLT                 32'b?????????????????100?????1100011
`define BLTU                32'b?????????????????110?????1100011
`define BNE                 32'b?????????????????001?????1100011
`define C_ADD               32'b????????????????1001??????????10
`define C_ADDI              32'b????????????????000???????????01
`define C_ADDI16SP          32'b????????????????011?00010?????01
`define C_ADDI4SPN          32'b????????????????000???????????00
`define C_AND               32'b????????????????100011???11???01
`define C_ANDI              32'b????????????????100?10????????01
`define C_BEQZ              32'b????????????????110???????????01
`define C_BNEZ              32'b????????????????111???????????01
`define C_EBREAK            32'b????????????????1001000000000010
`define C_JALR              32'b????????????????1001?????0000010
`define C_JAL               32'b????????????????001???????????01
`define C_JR                32'b????????????????1000?????0000010
`define C_LI                32'b????????????????010???????????01
`define C_LUI               32'b????????????????011???????????01
`define C_LW                32'b????????????????010???????????00
`define C_LWSP              32'b????????????????010???????????10
`define C_MV                32'b????????????????1000??????????10
`define C_NOP               32'b????????????????000?00000?????01
`define C_OR                32'b????????????????100011???10???01
`define C_SUB               32'b????????????????100011???00???01
`define C_SW                32'b????????????????110???????????00
`define C_SWSP              32'b????????????????110???????????10
`define C_XOR               32'b????????????????100011???01???01
`define CSRRC               32'b?????????????????011?????1110011
`define CSRRCI              32'b?????????????????111?????1110011
`define CSRRS               32'b?????????????????010?????1110011
`define CSRRSI              32'b?????????????????110?????1110011
`define CSRRW               32'b?????????????????001?????1110011
`define CSRRWI              32'b?????????????????101?????1110011
`define DIV                 32'b0000001??????????100?????0110011
`define DIVU                32'b0000001??????????101?????0110011
`define EBREAK              32'b00000000000100000000000001110011
`define ECALL               32'b00000000000000000000000001110011
`define FENCE               32'b?????????????????000?????0001111
`define JALR                32'b?????????????????000?????1100111
`define LB                  32'b?????????????????000?????0000011
`define LBU                 32'b?????????????????100?????0000011
`define LH                  32'b?????????????????001?????0000011
`define LHU                 32'b?????????????????101?????0000011
`define LUI                 32'b?????????????????????????0110111
`define LW                  32'b?????????????????010?????0000011
`define MRET                32'b00110000001000000000000001110011
`define MUL                 32'b0000001??????????000?????0110011
`define MULH                32'b0000001??????????001?????0110011
`define MULHSU              32'b0000001??????????010?????0110011
`define MULHU               32'b0000001??????????011?????0110011
`define OR                  32'b0000000??????????110?????0110011
`define ORI                 32'b?????????????????110?????0010011
`define REM                 32'b0000001??????????110?????0110011
`define REMU                32'b0000001??????????111?????0110011
`define SB                  32'b?????????????????000?????0100011
`define SH                  32'b?????????????????001?????0100011
`define SLL                 32'b0000000??????????001?????0110011
`define SLLI                32'b0000000??????????001?????0010011
`define SLT                 32'b0000000??????????010?????0110011
`define SLTI                32'b?????????????????010?????0010011
`define SLTIU               32'b?????????????????011?????0010011
`define SLTU                32'b0000000??????????011?????0110011
`define SRA                 32'b0100000??????????101?????0110011
`define SRAI                32'b0100000??????????101?????0010011
`define SRL                 32'b0000000??????????101?????0110011
`define SRLI                32'b0000000??????????101?????0010011
`define SUB                 32'b0100000??????????000?????0110011
`define SW                  32'b?????????????????010?????0100011
`define WFI                 32'b00010000010100000000000001110011
`define XOR                 32'b0000000??????????100?????0110011
`define XORI                32'b?????????????????100?????0010011
`define C_J                 32'b????????????????101???????????01
`define JAL                 32'b?????????????????????????1101111
`define C_ILLEGAL           32'b????????????????0000000000000000
`define C_SLLI              32'b????????????????000???????????10

`define C_SRAI              32'b????????????????100?01????????01
`define C_SRLI              32'b????????????????100?00????????01

`define FENCEI              32'b00000000000000000001000000001111

`endif
