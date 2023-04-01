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

typedef struct packed {
  logic alu;
  logic mul;
  logic lsu;
  logic br;
  logic illegal;
} pipeline_t;

module decoder (
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

  assign opcode        = instr[6:0];
  assign c_opcode      = instr[1:0];
  assign c_funct2      = instr[15:14];

  assign funct3        = instr[14:12];
  assign funct7        = instr[31:25];

  // Compressed instruction identification
  assign is_compressed = opcode[1:0] != 2'b11;

  // 32-bit sign extension
  assign imm_type      = opcode[4:2];

  // Control signal assignments for pt structure
  always_comb begin
    pt.alu     = 1'b0;
    pt.mul     = 1'b0;
    pt.lsu     = 1'b0;
    pt.br      = 1'b0;
    pt.illegal = 1'b0;

    if (is_compressed) begin
      case (c_opcode)
        2'b00: begin
          case (c_funct2)
            2'b00: begin
              pt.lsu = 1'b1;
            end
            default: begin
            end
          endcase
        end
        2'b01: begin  // C.ADDI
          pt.alu = 1'b1;
        end
        default: begin
        end
      endcase
    end else begin
      // ...
    end
  end

  // Register mapping for compressed instructions
  always_comb begin
    if (is_compressed) begin
      case (c_opcode)
        2'b00: begin
          case (c_funct2)
            2'b00: begin

            end
            default: begin
            end
          endcase
        end
        2'b01: begin

        end
        default: begin
        end
      endcase
    end else begin
      rd_addr  = instr[11:7];
      rs1_addr = instr[19:15];
      rs2_addr = instr[24:20];
    end
  end

  // Instantiate the sign_extend_imm module
  sign_extend_imm sign_ext_imm (
      .instr(instr),
      .imm_type(imm_type),
      .imm_out(imm)
  );

endmodule

