module sign_extend_imm (
    input  logic [31:0] instr,
    input  logic [ 2:0] imm_type,
    output logic [31:0] imm_out
);

  // Extract immediate values from the instruction
  logic [31:0] imm_I, imm_S, imm_B, imm_U, imm_J, imm_CIW, imm_CSRI;

  assign imm_I = {{20{instr[31]}}, instr[31:20]};
  assign imm_S = {{20{instr[31]}}, instr[31:25], instr[11:7]};
  assign imm_B = {{19{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
  assign imm_U = {instr[31:12], 12'b0};
  assign imm_J = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
  assign imm_CIW = {{20{instr[12]}}, instr[12], instr[6:2], 2'b0};
  assign imm_CSRI = {{20{instr[31]}}, instr[31:20], instr[19:15]};

  // Select the appropriate immediate value based on the immediate type
  always_comb begin
    case (imm_type)
      3'b000:  imm_out = imm_I;
      3'b001:  imm_out = imm_S;
      3'b010:  imm_out = imm_B;
      3'b011:  imm_out = imm_U;
      3'b100:  imm_out = imm_J;
      3'b101:  imm_out = imm_CIW;
      3'b110:  imm_out = imm_CSRI;
      default: imm_out = 32'h0;
    endcase
  end

endmodule
