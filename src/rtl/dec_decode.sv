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

  logic [4:0] rd;
  logic [4:0] rs1;
  logic [4:0] rs2;

  alu_op_t alu_op;

  lsu_op_t lsu_op;

  logic [31:0] imm_I, imm_S, imm_B, imm_U, imm_J;
  logic [12:0] csr;

  logic [31:0]
      c_imm_addi4spn,
      c_uimm5,
      c_imm6,
      c_imm11,
      c_imm_addi16sp,
      c_imm_lui,
      c_imm_lwsw,
      c_imm_lwsp,
      c_imm_swsp,
      c_imm_b;

  // Extract immediate values from the instruction
  assign imm_I = {{20{instr[31]}}, instr[31:20]};
  assign imm_S = {{20{instr[31]}}, instr[31:25], instr[11:7]};
  assign imm_B = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
  assign imm_U = {instr[31:12], 12'b0};
  assign imm_J = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};

  assign csr = instr[31:20];

  assign c_imm_addi4spn = {22'b0, instr[10:7], instr[12:11], instr[5], instr[6], 2'b00};
  assign c_uimm5 = {25'b0, instr[6:5], instr[12:10], 2'b00};
  assign c_imm6 = {{27{instr[12]}}, instr[6:2]};
  assign c_imm11 = {
    {21{instr[12]}},
    instr[8],
    instr[10:9],
    instr[6],
    instr[7],
    instr[2],
    instr[10],
    instr[5:3],
    1'b0
  };


  assign c_imm_b = {{24{instr[12]}}, instr[6:5], instr[2], instr[11:10], instr[4:3], 1'b0};

  assign c_imm_addi16sp = {{27{instr[12]}}, instr[4:3], instr[5], instr[2], instr[6], 4'b0};

  assign c_imm_lui = {{15{instr[12]}}, instr[6:2], 12'b0};


  assign c_imm_lwsw = {21'b0, instr[5], instr[12:10], instr[6], 2'b00};
  assign c_imm_lwsp = {24'b0, instr[3:2], instr[12], instr[6:4], 2'b00};
  assign c_imm_swsp = {24'b0, instr[8:7], instr[12:9], 2'b0};



  always_comb begin
    illegal  = 1'b0;
    imm      = 32'b0;
    use_imm  = 1'b0;
    rs1_addr = instr[19:15];
    rs2_addr = instr[24:20];
    rd_addr  = instr[11:7];

    casez (instr)
      `ADDI:           {use_imm, imm, alu_op} = {1'b1, imm_I, ALU_ADD};
      `ANDI:           {use_imm, imm, alu_op} = {1'b1, imm_I, ALU_AND};
      `AUIPC:          {use_imm, imm, alu_op} = {1'b1, imm_U, ALU_ADD};
      `ADD:            alu_op = ALU_ADD;
      `AND:            alu_op = ALU_AND;
      `C_ADDI, `C_NOP: {use_imm, imm, alu_op} = {1'b1, c_imm6, ALU_ADD};
      `C_ANDI:         {use_imm, imm, alu_op} = {1'b1, c_imm6, ALU_AND};

      `C_ADD: alu_op = ALU_ADD;
      `C_AND: alu_op = ALU_AND;

      `C_ADDI16SP: {use_imm, imm, alu_op} = {1'b1, c_imm_addi16sp, ALU_ADD};
      `C_LUI:      {use_imm, imm, alu_op} = {1'b1, c_imm_lui, ALU_ADD};
      `C_ADDI4SPN: {use_imm, imm, alu_op} = {1'b1, c_imm_addi4spn, ALU_ADD};

      `BEQ:  imm = imm_B;
      `BGE:  imm = imm_B;
      `BGEU: imm = imm_B;
      `BLT:  imm = imm_B;
      `BLTU: imm = imm_B;
      `BNE:  imm = imm_B;

      `C_BEQZ: begin
        imm = c_imm_b;
      end
      `C_BNEZ: begin
        imm = c_imm_b;
      end
      `C_EBREAK: begin
      end
      `C_JALR: begin
      end
      `C_JR: begin
      end
      `C_LI:   {use_imm, imm, alu_op} = {1'b0, c_imm6, ALU_ADD};
      `C_LW:   {imm, lsu_op} = {c_imm_lwsw, LSU_LW};
      `C_LWSP: {imm, lsu_op} = {c_imm_lwsp, LSU_LW};
      `C_MV: begin
      end
      `C_OR:   alu_op = ALU_OR;
      `C_SUB:  alu_op = ALU_SUB;
      `C_SW:   {imm, lsu_op} = {c_imm_lwsw, LSU_SW};
      `C_SWSP: {imm, lsu_op} = {c_imm_swsp, LSU_SW};
      `C_XOR:  alu_op = ALU_XOR;
      `C_OR:   alu_op = ALU_OR;
      `CSRRC: begin
        imm = csr;
      end
      `CSRRCI: begin
        imm = csr;
      end
      `CSRRS: begin
        imm = csr;
      end
      `CSRRSI: begin
        imm = csr;
      end
      `CSRRW: begin
        imm = csr;
      end
      `CSRRWI: begin
        imm = csr;
      end
      `DIV:    alu_op = ALU_DIV;
      `DIVU:   alu_op = ALU_DIVU;
      `EBREAK: begin
      end
      `ECALL: begin
      end
      `FENCE: begin
      end
      `FENCEI: begin
      end
      `JALR: begin
        imm = imm_I;
      end
      `LW:     {imm, lsu_op} = {imm_I, LSU_LW};
      `LB:     {imm, lsu_op} = {imm_I, LSU_LB};
      `LBU:    {imm, lsu_op} = {imm_I, LSU_LBU};
      `LH:     {imm, lsu_op} = {imm_I, LSU_LH};
      `LHU:    {imm, lsu_op} = {imm_I, LSU_LHU};
      `LUI:    {use_imm, imm, alu_op} = {1'b1, imm_U, ALU_ADD};
      `MRET: begin
      end
      `MUL:    alu_op = ALU_MUL;
      `MULH:   alu_op = ALU_MULH;
      `MULHSU: alu_op = ALU_MULHSU;
      `MULHU:  alu_op = ALU_MULHU;
      `OR:     alu_op = ALU_OR;
      `ORI:    {use_imm, imm, alu_op} = {1'b1, imm_I, ALU_OR};
      `REM:    alu_op = ALU_REM;
      `REMU:   alu_op = ALU_REMU;
      `SB:     {imm, lsu_op} = {imm_S, LSU_SB};
      `SH:     {imm, lsu_op} = {imm_S, LSU_SH};
      `SLL:    alu_op = ALU_SLL;
      `SLLI:   {use_imm, imm, alu_op} = {1'b1, {27'b0, instr[24:20]}, ALU_SLL};
      `SLT:    alu_op = ALU_SLT;
      `SLTI:   {use_imm, imm, alu_op} = {1'b1, imm_I, ALU_SLT};
      `SLTIU:  {use_imm, imm, alu_op} = {1'b1, imm_I, ALU_SLTU};
      `SLTU:   alu_op = ALU_SLTU;
      `SRA:    alu_op = ALU_SRA;
      `SRAI:   {use_imm, imm, alu_op} = {1'b1, {27'b0, instr[24:20]}, ALU_SRA};
      `SRL:    alu_op = ALU_SRL;
      `SRLI:   {use_imm, imm, alu_op} = {1'b1, {27'b0, instr[24:20]}, ALU_SRL};
      `SUB:    alu_op = ALU_SUB;
      `SW:     {imm, lsu_op} = {imm_S, LSU_SW};
      `WFI: begin
      end
      `XOR:    alu_op = ALU_XOR;
      `XORI:   {use_imm, imm, alu_op} = {1'b1, imm_I, ALU_XOR};
      `C_J: begin
        imm = c_imm11;
      end
      `C_JAL: begin
        imm = c_imm11;
      end
      `JAL: begin
        imm = imm_J;
      end
      `C_SLLI: {use_imm, imm, alu_op} = {1'b1, c_imm6, ALU_SLL};

      `C_SRAI: {use_imm, imm, alu_op} = {1'b1, c_imm6, ALU_SRA};

      `C_ILLEGAL: illegal = 1'b1;
      default:    illegal = 1'b1;

    endcase
  end

endmodule

