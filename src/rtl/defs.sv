package defs;
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

  typedef enum logic [3:0] {
    LSU_LB  = 4'b0000,
    LSU_LH  = 4'b0001,
    LSU_LW  = 4'b0010,
    LSU_LBU = 4'b0100,
    LSU_LHU = 4'b0101,
    LSU_SB  = 4'b1000,
    LSU_SH  = 4'b1001,
    LSU_SW  = 4'b1010
  } lsu_op_t;

endpackage
