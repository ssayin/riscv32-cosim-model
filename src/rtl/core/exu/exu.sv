// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module bru (
  input  logic        en,
  input  logic [ 2:0] br_type,
  input  logic [31:0] a,
  input  logic [31:0] b,
  output logic        out
);

  always_comb begin
    if (en) begin
      case (br_type)
        BR_BEQ:  out = (a == b);
        BR_BGE:  out = ($signed(a) >= $signed(b));
        BR_BGEU: out = (a >= b);
        BR_BNEZ: out = (a != 0);
        BR_BLTU: out = (a < b);
        BR_BEQZ: out = (a == 0);
        BR_BLT:  out = ($signed(a) < $signed(b));
        BR_BNE:  out = (a != b);
        default: out = 'b0;
      endcase
    end else begin
      out = 'b0;
    end
  end

endmodule



module exu
  import param_defs::*;
(
  input  logic                          clk,
  input  logic                          rst_n,
  input  reg_data_t                     rs1_data_e,
  input  reg_data_t                     rs2_data_e,
  output logic                          should_br,
  output logic                          br_mispredictd,
  input  logic      [             31:1] pc_e,
  input  logic                          compressed_e,
  input  logic                          br_e,
  input  logic                          br_taken_e,
  input  logic                          use_imm_e,
  input  logic                          use_pc_e,
  input  reg_data_t                     imm_e,
  input  logic                          illegal_e,
  input  logic                          alu_e,
  input  logic      [   AluOpWidth-1:0] alu_op_e,
  input  reg_addr_t                     rd_addr_e,
  input  logic                          lsu_e,
  input  logic      [   LsuOpWidth-1:0] lsu_op_e,
  input  logic      [BranchOpWidth-1:0] br_op_e,
  input  logic                          rd_en_e,
  output logic                          compressed_m,
  output logic                          rd_en_m,
  output reg_data_t                     alu_res_m,
  output reg_data_t                     store_data_m,
  output logic                          lsu_m,
  output logic      [   LsuOpWidth-1:0] lsu_op_m,
  output logic                          br_taken_m,
  output logic                          br_m,
  output reg_addr_t                     rd_addr_m
);
  logic [DataWidth-1:0] res_next;
  logic [DataWidth-1:0] alu_out;
  logic                 bru_out;
  logic                 should_br_next;

  bru bru_0 (
    .en     (br_e),
    .br_type(br_op_e),
    .a      (rs1_data_e),
    .b      (rs2_data_e),
    .out    (bru_out)
  );

  alu alu_0 (
    .a     (use_pc_e ? pc_e : rs1_data_e),
    .b     (use_imm_e ? imm_e : rs2_data_e),
    .alu_op(alu_op_e),
    .res   (alu_out)
  );

  assign should_br_next = !br_taken_e && bru_out;
  assign br_mispredictd = !bru_out && br_taken_e;

  always_comb begin
    if (br_mispredictd) res_next = compressed_e ? pc_e + 2 : pc_e + 4;
    else res_next = alu_out;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      alu_res_m    <= 'b0;
      should_br    <= 'b0;
      br_taken_m   <= 'b0;
      br_m         <= 'b0;
      compressed_m <= 'b0;
      lsu_op_m     <= 'h0;
      lsu_m        <= 'b0;
      rd_addr_m    <= 'h0;
      rd_en_m      <= 'b0;
      store_data_m <= 'h0;
    end else begin
      alu_res_m    <= res_next;
      should_br    <= should_br_next;
      br_taken_m   <= br_taken_e;
      br_m         <= br_e;
      compressed_m <= compressed_e;
      lsu_op_m     <= lsu_op_e;
      lsu_m        <= lsu_e;
      rd_addr_m    <= rd_addr_e;
      rd_en_m      <= rd_en_e;
      store_data_m <= rs2_data_e;
    end
  end

endmodule : exu
