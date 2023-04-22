// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module _1_id_stage
  import param_defs::*;
(
  input logic                 i_clk,
  input logic                 i_rst_n,
  input logic [WordWidth-1:0] i_instr,
  input logic [WordWidth-1:0] i_pc,

  // Outputs to other pipeline stages
  output logic [   DataWidth-1:0] o_imm,
  output logic [RegAddrWidth-1:0] o_rd_addr,
  output logic [RegAddrWidth-1:0] o_rs1_addr,
  output logic [RegAddrWidth-1:0] o_rs2_addr,
  output logic                    o_rd_en,
  output logic                    o_mem_rd_en,
  output logic                    o_mem_wr_en,
  output logic                    o_use_imm,
  output logic                    o_alu,
  output logic                    o_lsu,
  output logic                    o_br,
  output logic                    o_illegal,
  output logic [   DataWidth-1:0] o_exp_code,
  output logic [  AluOpWidth-1:0] o_alu_op,
  output logic [  LsuOpWidth-1:0] o_lsu_op
);


  // Internal Signal Wires
  logic [   DataWidth-1:0] imm_next;
  logic                    mem_rd_en_next;
  logic                    mem_wr_en_next;
  logic                    use_imm_next;
  logic                    alu_next;
  logic                    lsu_next;
  logic                    br_next;
  logic                    illegal_next;
  logic                    rd_en_next;
  logic [   DataWidth-1:0] exp_code_next;
  logic [RegAddrWidth-1:0] rs1_addr_next;
  logic [RegAddrWidth-1:0] rs2_addr_next;
  logic [RegAddrWidth-1:0] rd_addr_next;
  logic [  AluOpWidth-1:0] alu_op_next;
  logic [  LsuOpWidth-1:0] lsu_op_next;

  dec_decode dec_decode_0 (
    .i_clk      (i_clk),
    .i_rst_n    (i_rst_n),
    .i_instr    (i_instr),
    .i_pc       (i_pc),
    .o_imm      (imm_next),
    .o_rd_addr  (rd_addr_next),
    .o_rs1_addr (rs1_addr_next),
    .o_rs2_addr (rs2_addr_next),
    .o_rd_en    (rd_en_next),
    .o_mem_rd_en(mem_rd_en_next),
    .o_mem_wr_en(mem_wr_en_next),
    .o_use_imm  (use_imm_next),
    .o_alu      (alu_next),
    .o_lsu      (lsu_next),
    .o_br       (br_next),
    .o_alu_op   (alu_op_next),
    .o_lsu_op   (lsu_op_next),
    .o_illegal  (illegal_next),
    .o_exp_code (exp_code_next)
  );

  always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      o_imm       <= 'h0;
      o_mem_rd_en <= 'b0;
      o_mem_wr_en <= 'b0;
      o_use_imm   <= 'b0;
      o_alu       <= 'b0;
      o_lsu       <= 'b0;
      o_br        <= 'b0;
      o_illegal   <= 'b0;
      o_exp_code  <= 'h0;
      o_alu_op    <= 'h0;
      o_lsu_op    <= 'h0;
      o_rs1_addr  <= 'h0;
      o_rs2_addr  <= 'h0;
      o_rd_addr   <= 'h0;
    end else begin
      o_imm       <= imm_next;
      o_mem_rd_en <= mem_rd_en_next;
      o_mem_wr_en <= mem_wr_en_next;
      o_use_imm   <= use_imm_next;
      o_alu       <= alu_next;
      o_lsu       <= lsu_next;
      o_br        <= br_next;
      o_illegal   <= illegal_next;
      o_exp_code  <= exp_code_next;
      o_alu_op    <= alu_op_next;
      o_lsu_op    <= lsu_op_next;
      o_rs1_addr  <= rs1_addr_next;
      o_rs2_addr  <= rs2_addr_next;
      o_rd_addr   <= rd_addr_next;
      o_rd_en     <= rd_en_next;
    end
  end

endmodule : _1_id_stage
