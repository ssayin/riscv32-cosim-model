// typedef enum logic [4:0] {
//   LOAD    = 5'b00000,
//   MISCMEM = 5'b00011,
//  AUIPC   = 5'b00101,
//  OPIMM32 = 5'b00110,
//  STORE   = 5'b01000,
//  LUI     = 5'b01101,
//  OP32    = 5'b01110,
//  BRANCH  = 5'b11000,
//  JALR    = 5'b11001,
//  JAL     = 5'b11011,
//  SYSTEM  = 5'b11100
// } opc_t;

typedef struct packed {
  logic alu;
  logic mul;
  logic lsu;
  logic br;
  logic illegal;
} pipeline_t;

typedef enum logic [4:0] {
  ALU_ADD    = 5'b00000,
  ALU_SUB    = 5'b01000,
  ALU_SLT    = 5'b00010,
  ALU_SLTU   = 5'b00011,
  ALU_XOR    = 5'b00100,
  ALU_OR     = 5'b00110,
  ALU_AND    = 5'b00111,
  ALU_SLL    = 5'b00001,
  ALU_SRL    = 5'b00101,
  ALU_SRA    = 5'b01101,
  ALU_MUL    = 5'b11000,
  ALU_MULH   = 5'b11001,
  ALU_MULHSU = 5'b11010,
  ALU_MULHU  = 5'b11011,
  ALU_DIV    = 5'b11100,
  ALU_DIVU   = 5'b11101,
  ALU_REM    = 5'b11110,
  ALU_REMU   = 5'b11111
} alu_op_t;


module decoder #(
    `include "inst.svh"
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic      [31:0] instr,
    output logic             is_compressed,
    output logic      [31:0] pc_target,
    output logic      [ 4:0] rs1_addr,
    output logic      [ 4:0] rs2_addr,
    output logic      [ 4:0] rd_addr,
    output logic      [31:0] rd_data,
    output logic      [31:0] imm,
    output logic             rd_en,
    output logic             mem_rd_en,
    output logic             mem_wr_en,
    output logic             use_imm,
    output logic             load_upper,
    output pipeline_t        pt,
    // TODO: remove these
    output logic      [ 2:0] funct3,
    output logic      [ 6:0] funct7
);

  logic [6:0] opcode;

  logic [2:0] imm_type;

  logic [1:0] c_opcode;
  logic [1:0] c_funct2;

  logic [4:0] alu_op;

  assign opcode        = instr[6:0];
  assign c_opcode      = instr[1:0];
  assign c_funct2      = instr[15:14];

  assign funct3        = instr[14:12];
  assign funct7        = instr[31:25];

  // Compressed instruction identification
  assign is_compressed = opcode[1:0] != 2'b11;

  // 32-bit sign extension
  assign imm_type      = opcode[4:2];

  always_comb begin
    casez (instr)
      `ADD: begin
        alu_op = ALU_ADD;
      end
      `ADDI: begin
        alu_op = ALU_ADD;
      end
      `AND: begin
        alu_op = ALU_AND;
      end
      `ANDI: begin
        alu_op = ALU_AND;
      end
      `AUIPC: begin
      end
      `BEQ: begin
      end
      `BGE: begin
      end
      `BGEU: begin
      end
      `BLT: begin
      end
      `BLTU: begin
      end
      `BNE: begin
      end
      `C_ADD: begin
        alu_op = ALU_ADD;
      end
      `C_ADDI: begin
        alu_op = ALU_ADD;
      end
      `C_ADDI16SP: begin
        alu_op = ALU_ADD;
      end
      `C_ADDI4SPN: begin
        alu_op = ALU_ADD;
      end
      `C_AND: begin
        alu_op = ALU_AND;
      end
      `C_ANDI: begin
        alu_op = ALU_AND;
      end
      `C_BEQZ: begin
      end
      `C_BNEZ: begin
      end
      `C_EBREAK: begin
      end
      `C_J: begin
      end
      `C_JALR: begin
      end
      `C_JR: begin
      end
      `C_LI: begin
      end
      `C_LUI: begin
      end
      `C_LW: begin
      end
      `C_LWSP: begin
      end
      `C_MV: begin
      end
      `C_NOP: begin
      end
      `C_OR: begin
      end
      `C_SUB: begin
      end
      `C_SW: begin
      end
      `C_SWSP: begin
      end
      `C_XOR: begin
        alu_op = ALU_XOR;
      end
      `CSRRC: begin
      end
      `CSRRCI: begin
      end
      `CSRRS: begin
      end
      `CSRRSI: begin
      end
      `CSRRW: begin
      end
      `CSRRWI: begin
      end
      `DIV: begin
        alu_op = ALU_DIV;
      end
      `DIVU: begin
        alu_op = ALU_DIVU;
      end
      `EBREAK: begin
      end
      `ECALL: begin
      end
      `FENCE: begin
      end
      `JAL: begin
      end
      `JALR: begin
      end
      `LB: begin
      end
      `LBU: begin
      end
      `LH: begin
      end
      `LHU: begin
      end
      `LUI: begin
      end
      `LW: begin
      end
      `MRET: begin
      end
      `MUL: begin
        alu_op = ALU_MUL;
      end
      `MULH: begin
        alu_op = ALU_MULH;
      end
      `MULHSU: begin
        alu_op = ALU_MULHSU;
      end
      `MULHU: begin
        alu_op = ALU_MULHU;
      end
      `OR: begin
        alu_op = ALU_OR;
      end
      `ORI: begin
        alu_op = ALU_OR;
      end
      `REM: begin
        alu_op = ALU_REM;
      end
      `REMU: begin
        alu_op = ALU_REMU;
      end
      `SB: begin
      end
      `SH: begin
      end
      `SLL: begin
        alu_op = ALU_SLL;
      end
      `SLLI: begin
        alu_op = ALU_SLL;
      end
      `SLT: begin
        alu_op = ALU_SLT;
      end
      `SLTI: begin
        alu_op = ALU_SLT;
      end
      `SLTIU: begin
        alu_op = ALU_SLTU;
      end
      `SLTU: begin
        alu_op = ALU_SLTU;
      end
      `SRA: begin
        alu_op = ALU_SRA;
      end
      `SRAI: begin
        alu_op = ALU_SRA;
      end
      `SRL: begin
        alu_op = ALU_SRL;
      end
      `SRLI: begin
        alu_op = ALU_SRL;
      end
      `SUB: begin
        alu_op = ALU_SUB;
      end
      `SW: begin
      end
      `WFI: begin
      end
      `XOR: begin
        alu_op = ALU_XOR;
      end
      `XORI: begin
        alu_op = ALU_XOR;
      end
      default: begin
      end
    endcase
  end


  // Instantiate the sign_extend_imm module
  sign_extend_imm sign_ext_imm (
      .instr(instr),
      .imm_type(imm_type),
      .imm_out(imm)
  );

endmodule

