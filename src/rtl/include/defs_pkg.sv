// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0
package defs_pkg;
  `include "riscv_opcodes.svh"

  localparam logic [2:0] AluAddFunct3 = 3'b000;
  localparam logic [2:0] AluSubFunct3 = 3'b000;

  localparam logic [2:0] AluSllFunct3 = 3'b001;
  localparam logic [2:0] AluSltFunct3 = 3'b010;
  localparam logic [2:0] AluSltuFunct3 = 3'b011;
  localparam logic [2:0] AluXorFunct3 = 3'b100;

  localparam logic [2:0] AluSrlFunct3 = 3'b101;
  localparam logic [2:0] AluSraFunct3 = 3'b101;

  localparam logic [2:0] AluOrFunct3 = 3'b110;
  localparam logic [2:0] AluAndFunct3 = 3'b111;



  localparam logic [2:0] AluMulFunct3 = 3'b000;
  localparam logic [2:0] AluMulhFunct3 = 3'b001;
  localparam logic [2:0] AluMulhsuFunct3 = 3'b010;
  localparam logic [2:0] AluMulhuFunct3 = 3'b011;

  localparam logic [2:0] AluDivFunct3 = 3'b100;
  localparam logic [2:0] AluDivuFunct3 = 3'b101;
  localparam logic [2:0] AluRemFunct3 = 3'b110;
  localparam logic [2:0] AluRemuFunct3 = 3'b111;


  localparam logic [1:0] AluBasePrepend = 2'b00;
  localparam logic [1:0] AluSubSraPrepend = 2'b01;
  localparam logic [1:0] AluMulPrepend = 2'b11;

  typedef enum logic [4:0] {
    ALU_ADD    = {{AluBasePrepend, AluAddFunct3}},
    ALU_SUB    = {{AluSubSraPrepend, AluSubFunct3}},
    ALU_SLT    = {{AluBasePrepend, AluSltFunct3}},
    ALU_SLTU   = {{AluBasePrepend, AluSltuFunct3}},
    ALU_XOR    = {{AluBasePrepend, AluXorFunct3}},
    ALU_OR     = {{AluBasePrepend, AluOrFunct3}},
    ALU_AND    = {{AluBasePrepend, AluAndFunct3}},
    ALU_SLL    = {{AluBasePrepend, AluSllFunct3}},
    ALU_SRL    = {{AluBasePrepend, AluSrlFunct3}},
    ALU_SRA    = {{AluSubSraPrepend, AluSraFunct3}},
    ALU_MUL    = {{AluMulPrepend, AluMulFunct3}},
    ALU_MULH   = {{AluMulPrepend, AluMulhFunct3}},
    ALU_MULHSU = {{AluMulPrepend, AluMulhsuFunct3}},
    ALU_MULHU  = {{AluMulPrepend, AluMulhuFunct3}},
    ALU_DIV    = {{AluMulPrepend, AluDivFunct3}},
    ALU_DIVU   = {{AluMulPrepend, AluDivuFunct3}},
    ALU_REM    = {{AluMulPrepend, AluRemFunct3}},
    ALU_REMU   = {{AluMulPrepend, AluRemuFunct3}}
  } alu_op_t;
  /*
   * Logic[3]: 0 -> Load, 1 -> Store
   * Logic[2]: 0 -> Signed, 1 -> Unsigned (LBU and LHU only)
   * Logic[1-0]: 00 -> Byte,  ?1 -> Half, 10 -> Word
   */
  typedef enum logic [3:0] {
    LSU_LB  = 4'b0000,
    LSU_LH  = 4'b00?1,
    LSU_LW  = 4'b0010,
    LSU_LBU = 4'b0100,
    LSU_LHU = 4'b01?1,
    LSU_SB  = 4'b1000,
    LSU_SH  = 4'b10?1,
    LSU_SW  = 4'b1010
  } lsu_op_t;
  typedef enum logic [2:0] {
    BR_BEQ  = 3'b000,
    BR_BGE  = 3'b101,
    BR_BGEU = 3'b111,
    BR_BNEZ = 3'b011,
    BR_BLT  = 3'b100,
    BR_BLTU = 3'b110,
    BR_BEQZ = 3'b010,
    BR_BNE  = 3'b001
  } br_op_t;
  typedef enum logic [1:0] {
    FIXED = 2'b00,
    INCR  = 2'b01,
    WRAP  = 2'b10
  } axi_burst_t;
  typedef enum logic [1:0] {
    OKAY   = 2'b00,
    EXOKAY = 2'b01,
    SLVERR = 2'b10,
    DECERR = 2'b11
  } axi_resp_t;

  localparam logic [4:0] Sel0 = 5'b11110;
  localparam logic [4:0] Sel1 = 5'b11101;
  localparam logic [4:0] Sel2 = 5'b11011;
  localparam logic [4:0] Sel3 = 5'b10111;
  localparam logic [4:0] SelW = 5'b11111;

  // Do not change these values.
  localparam int AddrWidth = 32;
  localparam int DataWidth = 32;
  localparam int RegCount = 32;
  localparam int RegAddrWidth = (RegCount > 1) ? $clog2(RegCount) : 0;
  localparam int AluOpWidth = 5;
  localparam int LsuOpWidth = 4;
  localparam int BranchOpWidth = 3;
  localparam int MemBusWidth = 32;
  localparam int AxiIdWidth = 2;
endpackage
