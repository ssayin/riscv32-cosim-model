typedef enum logic [4:0] {
  LOAD    = 5'b00000,
  MISCMEM = 5'b00011,
  AUIPC   = 5'b00101,
  OPIMM32 = 5'b00110,
  STORE   = 5'b01000,
  LUI     = 5'b01101,
  OP32    = 5'b01110,
  BRANCH  = 5'b11000,
  JALR    = 5'b11001,
  JAL     = 5'b11011,
  SYSTEM  = 5'b11100
} opc_t;

module dec (
    input  logic        clk,
    input  logic [31:0] i_instr,
    output logic        o_valid_rv32,
    output logic [ 3:0] o_rd,
    output logic [ 3:0] o_rs1,
    output logic [ 3:0] o_rs2

);


  assign o_valid_rv32 = i_instr[1] & i_instr[0];
  assign o_rd         = i_instr[10:7];
  assign o_rs1        = i_instr[18:15];
  assign o_rs2        = i_instr[23:20];


  always_comb begin
    case (i_instr[6:2])
      LOAD:    o_test = 1;
      STORE:   o_test = 0;
      MISCMEM: o_test = 1;
      AUIPC:   o_test = 0;
      OPIMM32: o_test = 1;
      LUI:     o_test = 1;
      OP32:    o_test = 0;
      BRANCH:  o_test = 1;
      JALR:    o_test = 1;
      JAL:     o_test = 1;
      SYSTEM:  o_test = 1;
      default: o_test = 1;
    endcase
  end


endmodule
