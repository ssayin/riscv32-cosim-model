// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

package instr_defs;
  import param_defs::*;


  localparam logic [2:0] AluAddFunct3 = 3'b000;

  localparam logic [2:0] AluSubFunct3 = 3'b000;
  localparam logic [2:0] AluSltFunct3 = 3'b010;
  localparam logic [2:0] AluSltuFunct3 = 3'b011;
  localparam logic [2:0] AluXorFunct3 = 3'b100;
  localparam logic [2:0] AluOrFunct3 = 3'b110;
  localparam logic [2:0] AluAndFunct3 = 3'b111;

  localparam logic [2:0] AluSllFunct3 = 3'b001;

  localparam logic [2:0] AluSrlFunct3 = 3'b101;
  localparam logic [2:0] AluSraFunct3 = 3'b101;

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
  localparam logic [1:0] AluMPrepend = 2'b11;

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
    ALU_MUL    = {{AluMPrepend, AluMulFunct3}},
    ALU_MULH   = {{AluMPrepend, AluMulhFunct3}},
    ALU_MULHSU = {{AluMPrepend, AluMulhsuFunct3}},
    ALU_MULHU  = {{AluMPrepend, AluMulhuFunct3}},
    ALU_DIV    = {{AluMPrepend, AluDivFunct3}},
    ALU_DIVU   = {{AluMPrepend, AluDivuFunct3}},
    ALU_REM    = {{AluMPrepend, AluRemFunct3}},
    ALU_REMU   = {{AluMPrepend, AluRemuFunct3}}
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

  typedef struct {
    logic alu;
    logic lsu;
    logic lui;
    logic auipc;
    logic br;
    logic jal;
    logic csr;
    logic fencei;
    logic fence;
    logic illegal;
  } ctl_pkt_t;

  typedef logic [RegAddrWidth-1:0] reg_addr_t;
  typedef logic [MemBusWidth-1:0] mem_data_t;
  typedef logic [DataWidth-1:0] reg_data_t;

  typedef struct {
    reg_data_t instr;
    reg_data_t pc;
    logic      compressed;
    logic      br;
    logic      br_taken;
  } p_if_id_t;

  typedef struct {
    reg_data_t                pc;
    logic                     compressed;
    logic                     br;
    logic                     br_taken;
    logic                     use_imm;
    reg_data_t                imm;
    logic                     illegal;
    logic                     alu;
    logic [AluOpWidth-1:0]    alu_op;
    reg_addr_t                rd_addr;
    logic                     lsu;
    logic [LsuOpWidth-1:0]    lsu_op;
    logic [BranchOpWidth-1:0] br_op;
    logic                     rd_en;
  } p_id_ex_t;

  typedef struct {
    logic                  compressed;
    logic                  rd_en;
    reg_data_t             alu_res;
    logic                  lsu;
    logic [LsuOpWidth-1:0] lsu_op;
    logic                  br_taken;
    logic                  br;
    reg_addr_t             rd_addr;
  } p_ex_mem_t;

  typedef struct {
    logic      rd_en;
    reg_addr_t rd_addr;
    reg_data_t rd_data;
  } p_mem_wb_t;

endpackage
