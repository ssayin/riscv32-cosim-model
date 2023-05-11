// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module id_stage
  import param_defs::*;
  import instr_defs::*;
(
  input logic        clk,
  input logic        rst_n,
  input logic [31:0] instr,
  input logic [31:0] pc,

  // Outputs to other pipeline stages
  output logic     [   DataWidth-1:0] imm,
  output logic     [RegAddrWidth-1:0] rd_addr,
  output logic     [RegAddrWidth-1:0] rs1_addr,
  output logic     [RegAddrWidth-1:0] rs2_addr,
  output logic                        rd_en,
  output logic                        use_imm,
  output ctl_pkt_t                    ctl,
  output logic     [   DataWidth-1:0] exp_code,
  output logic     [  AluOpWidth-1:0] alu_op,
  output logic     [  LsuOpWidth-1:0] lsu_op
);


  // Internal Signal Wires
  logic     [   DataWidth-1:0] imm_next;
  logic                        use_imm_next;
  ctl_pkt_t                    ctl_next;
  logic                        rd_en_next;
  logic     [   DataWidth-1:0] exp_code_next;
  logic     [RegAddrWidth-1:0] rs1_addr_next;
  logic     [RegAddrWidth-1:0] rs2_addr_next;
  logic     [RegAddrWidth-1:0] rd_addr_next;
  logic     [  AluOpWidth-1:0] alu_op_next;
  logic     [  LsuOpWidth-1:0] lsu_op_next;

  riscv_decoder riscv_decoder_0 (
    .clk     (clk),
    .rst_n   (rst_n),
    .instr   (instr),
    .pc      (pc),
    .imm     (imm_next),
    .rd_addr (rd_addr_next),
    .rs1_addr(rs1_addr_next),
    .rs2_addr(rs2_addr_next),
    .rd_en   (rd_en_next),
    .use_imm (use_imm_next),
    .ctl     (ctl_next),
    .alu_op  (alu_op_next),
    .lsu_op  (lsu_op_next),
    .exp_code(exp_code_next)
  );

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      imm      <= 'h0;
      use_imm  <= 'b0;
      exp_code <= 'h0;
      alu_op   <= 'h0;
      lsu_op   <= 'h0;
      rs1_addr <= 'h0;
      rs2_addr <= 'h0;
      rd_addr  <= 'h0;
      ctl      <= '{default: 0};
    end else begin
      imm      <= imm_next;
      use_imm  <= use_imm_next;
      exp_code <= exp_code_next;
      alu_op   <= alu_op_next;
      lsu_op   <= lsu_op_next;
      rs1_addr <= rs1_addr_next;
      rs2_addr <= rs2_addr_next;
      rd_addr  <= rd_addr_next;
      rd_en    <= rd_en_next;
      ctl      <= ctl_next;
    end
  end

endmodule : id_stage
