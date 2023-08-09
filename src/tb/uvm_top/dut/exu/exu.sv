// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0
module exu
  import defs_pkg::*;
(
  input  logic                     clk,
  input  logic                     rst_n,
  input  logic [             31:0] rs1_data_e,
  input  logic [             31:0] rs2_data_e,
  output logic                     should_br,
  output logic                     br_misp,
  input  logic [             31:1] pc_e,
  input  logic                     comp_e,
  input  logic                     br_e,
  input  logic                     br_ataken_e,
  input  logic                     use_imm_e,
  input  logic                     use_pc_e,
  input  logic [             31:0] imm_e,
  input  logic                     illegal_e,
  input  logic                     alu_e,
  input  logic [   AluOpWidth-1:0] alu_op_e,
  input  logic [              4:0] rd_addr_e,
  input  logic                     lsu_e,
  input  logic [   LsuOpWidth-1:0] lsu_op_e,
  input  logic [BranchOpWidth-1:0] br_op_e,
  input  logic                     rd_en_e,
  output logic                     comp_m,
  output logic                     rd_en_m,
  output logic [             31:0] alu_res_m,
  output logic [             31:0] store_data_m,
  output logic                     lsu_m,
  output logic [   LsuOpWidth-1:0] lsu_op_m,
  output logic                     br_ataken_m,
  output logic                     br_m,
  output logic [              4:0] rd_addr_m
);
  logic [31:0] res_next;
  logic [31:0] alu_out;
  logic        bru_out;
  logic        should_br_next;
  exu_bru exu_bru_0 (
    .en     (br_e),
    .br_type(br_op_e),
    .a      (rs1_data_e),
    .b      (rs2_data_e),
    .out    (bru_out)
  );
  exu_alu alu_0 (
    .a     (use_pc_e ? pc_e : rs1_data_e),
    .b     (use_imm_e ? imm_e : rs2_data_e),
    .alu_op(alu_op_e),
    .res   (alu_out)
  );
  assign should_br_next = !br_ataken_e && bru_out;
  assign br_misp        = !bru_out && br_ataken_e;
  always_comb begin
    if (br_misp) res_next = comp_e ? pc_e + 2 : pc_e + 4;
    else res_next = alu_out;
  end
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      alu_res_m    <= 'b0;
      should_br    <= 'b0;
      br_ataken_m  <= 'b0;
      br_m         <= 'b0;
      comp_m       <= 'b0;
      lsu_op_m     <= 'h0;
      lsu_m        <= 'b0;
      rd_addr_m    <= 'h0;
      rd_en_m      <= 'b0;
      store_data_m <= 'h0;
    end else begin
      alu_res_m    <= res_next;
      should_br    <= should_br_next;
      br_ataken_m  <= br_ataken_e;
      br_m         <= br_e;
      comp_m       <= comp_e;
      lsu_op_m     <= lsu_op_e;
      lsu_m        <= lsu_e;
      rd_addr_m    <= rd_addr_e;
      rd_en_m      <= rd_en_e;
      store_data_m <= rs2_data_e;
    end
  end
endmodule : exu
