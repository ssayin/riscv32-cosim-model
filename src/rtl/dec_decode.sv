module dec_decode
  import defs::*;
#(
    `include "inst.svh"
) (

    input  logic        clk,
    input  logic        rst_n,
    input  logic [31:0] instr,
    input  logic [31:0] pc_in,
    output logic [31:0] pc_target,
    output logic [ 4:0] rs1_addr,
    output logic [ 4:0] rs2_addr,
    output logic [ 4:0] rd_addr,
    output logic [31:0] rd_data,
    output logic [31:0] imm,
    output logic        rd_en,
    output logic        mem_rd_en,
    output logic        mem_wr_en,
    output logic        use_imm,
    output logic        alu,
    output logic        lsu,
    output logic        br,
    output logic        illegal
);

  logic [6:0] opcode;

  alu_op_t alu_op;
  lsu_op_t lsu_op;

  logic [31:0] imm_I, imm_S, imm_B, imm_U, imm_J, imm_CIW, imm_CSRI;

  logic [4:0] rd;
  logic [4:0] rs1;
  logic [4:0] rs2;

  // Extract immediate values from the instruction
  assign imm_I    = {{20{instr[31]}}, instr[31:20]};
  assign imm_S    = {{20{instr[31]}}, instr[31:25], instr[11:7]};
  assign imm_B    = {{19{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
  assign imm_U    = {instr[31:12], 12'b0};
  assign imm_J    = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
  assign imm_CIW  = {{20{instr[12]}}, instr[12], instr[6:2], 2'b0};
  assign imm_CSRI = {{20{instr[31]}}, instr[31:20], instr[19:15]};

  assign rs1 = instr[19:15];
  assign rs2 = instr[24:20];
  assign rd  = instr[11:7];

  always_comb begin
    casez (opcode)
      7'b0010011: begin
        use_imm = 1'b1;
        imm = imm_I;
      end
      7'b1100011: begin
        imm = imm_B;
      end
      7'b0000011: begin
        imm = imm_I;
      end
      7'b0100011: begin
        imm = imm_S;
      end
      default: begin
        use_imm = 0;
      end
    endcase
  end

  //always_comb begin
  // casez (instr)
  //  default: begin
  //   rd_addr  = rd;
  //  rs1_addr = rs1;
  // rs2_addr = rs2;
  // end
  // endcase
  // end

  always_comb begin
    $display("rtl: %x", instr);

    casez (instr)
      `ADD, `ADDI:         alu_op = ALU_ADD;
      `AND, `ANDI:         alu_op = ALU_AND;
      `AUIPC:              alu_op = ALU_ADD;
      `C_ADD:              alu_op = ALU_ADD;
      `C_ADDI, `C_NOP:     alu_op = ALU_ADD;
      `C_ADDI16SP, `C_LUI: alu_op = ALU_ADD;
      `C_ADDI4SPN:         alu_op = ALU_ADD;
      `C_AND:              alu_op = ALU_AND;
      `C_ANDI:             alu_op = ALU_AND;

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
      `C_BEQZ: begin
      end
      `C_BNEZ: begin
      end
      `C_EBREAK: begin
      end
      `C_JALR: begin
      end
      `C_JR: begin
      end
      `C_LI:   alu_op = ALU_ADD;
      `C_LW:   lsu_op = LSU_LW;
      `C_LWSP: lsu_op = LSU_LW;
      `C_MV: begin
      end
      `C_OR:   alu_op = ALU_OR;
      `C_SUB:  alu_op = ALU_SUB;
      `C_SW:   lsu_op = LSU_SW;
      `C_SWSP: lsu_op = LSU_SW;
      `C_XOR:  alu_op = ALU_XOR;
      `C_OR:   alu_op = ALU_OR;
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
      `DIV:    alu_op = ALU_DIV;
      `DIVU:   alu_op = ALU_DIVU;
      `EBREAK: begin
      end
      `ECALL: begin
      end
      `FENCE: begin
      end
      `JALR: begin
      end
      `LB:     lsu_op = LSU_LB;
      `LBU:    lsu_op = LSU_LBU;
      `LH:     lsu_op = LSU_LH;
      `LHU:    lsu_op = LSU_LHU;
      `LUI:    alu_op = ALU_ADD;
      `LW:     lsu_op = LSU_LW;
      `MRET: begin
      end
      `MUL:    alu_op = ALU_MUL;
      `MULH:   alu_op = ALU_MULH;
      `MULHSU: alu_op = ALU_MULHSU;
      `MULHU:  alu_op = ALU_MULHU;
      `OR:     alu_op = ALU_OR;
      `ORI:    alu_op = ALU_OR;
      `REM:    alu_op = ALU_REM;
      `REMU:   alu_op = ALU_REMU;
      `SB:     lsu_op = LSU_SB;
      `SH:     lsu_op = LSU_SH;
      `SLL:    alu_op = ALU_SLL;
      `SLLI:   alu_op = ALU_SLL;
      `SLT:    alu_op = ALU_SLT;
      `SLTI:   alu_op = ALU_SLT;
      `SLTIU:  alu_op = ALU_SLTU;
      `SLTU:   alu_op = ALU_SLTU;
      `SRA:    alu_op = ALU_SRA;
      `SRAI:   alu_op = ALU_SRA;
      `SRL:    alu_op = ALU_SRL;
      `SRLI:   alu_op = ALU_SRL;
      `SUB:    alu_op = ALU_SUB;
      `SW:     lsu_op = LSU_SW;
      `WFI: begin
      end
      `XOR:    alu_op = ALU_XOR;
      `XORI:   alu_op = ALU_XOR;
      `C_J: begin
      end
      `JAL: begin
      end
      default: illegal = 1'b1;

    endcase
  end

endmodule

