// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module exu (
  input  logic                 clk,
  input  logic                 rst_n,
  input  logic [         31:0] rs1_data_e,
  input  logic [         31:0] rs2_data_e,
  output logic                 br_misp_m,
  output logic                 exu_pc_redir_en,
  output logic                 exu_pc_redir_en_d,
  input  logic [         31:1] pc_e,
  input  logic                 comp_e,
  input  logic                 br_e,
  input  logic                 br_ataken_e,
  input  logic                 use_imm_e,
  input  logic                 use_pc_e,
  input  logic [         31:0] imm_e,
  input  logic                 illegal_e,
  input  logic                 alu_e,
  input  logic [   AluOpW-1:0] alu_op_e,
  input  logic [          4:0] rd_addr_e,
  input  logic                 lsu_e,
  input  logic [   LsuOpW-1:0] lsu_op_e,
  input  logic [BranchOpW-1:0] br_op_e,
  input  logic                 rd_en_e,
  input  logic                 valid_e,
  output logic                 comp_m,
  output logic [         31:1] pc_m,
  output logic                 rd_en_m,
  output logic [         31:0] alu_res_m,
  output logic [         31:0] store_data_m,
  output logic                 lsu_m,
  output logic [   LsuOpW-1:0] lsu_op_m,
  output logic                 br_ataken_m,
  output logic                 br_m,
  output logic [          4:0] rd_addr_m,
  input  logic                 jalr_e,
  input  logic                 jal_e,
  output logic                 jal_m,
  output logic                 jalr_m,
  output logic                 valid_m
);

  logic [31:0] alu_o, mul_o, div_o;
  logic       bru_o;
  logic       br_misp_d;

  logic [1:0] alu_op_prep;
  logic       base;
  logic       mul;
  logic       div;

  logic [31:0] alu_a, alu_b;

  assign alu_op_prep = alu_op_e[AluOpW-1:AluOpW-2];

  always_comb begin
    casez ({
      alu_op_prep, alu_op_e[2]
    })
      {AluBasePrepend, 1'b?}, {AluSubSraPrepend, 1'b?} : {base, mul, div} = 3'b100;
      {AluMulPrepend, 1'b1} :                            {base, mul, div} = 3'b010;
      {AluMulPrepend, 1'b0} :                            {base, mul, div} = 3'b001;
      default:                                           {base, mul, div} = 3'b100;
    endcase
  end

  assign alu_a = use_pc_e ? {pc_e[31:1], 1'b0} : rs1_data_e;

  always_comb begin
    alu_b = 0;
    if (use_imm_e) alu_b = imm_e;
    else if (!jalr_e) alu_b = rs2_data_e;
  end

  always_comb br_misp_d = br_e & (bru_o ^ br_ataken_e);

  always_comb exu_pc_redir_en_d = (br_misp_d || jalr_e) && valid_e;

  // verilog_format: off
  exu_bru bru_0 (.en (br_e), .br_type(br_op_e), .a (rs1_data_e), .b (rs2_data_e),   .out (bru_o));
  exu_mul mul_0 (.en (mul),  .a (rs1_data_e),   .b (rs2_data_e), .alu_op(alu_op_e), .res (mul_o));
  exu_div div_0 (.en (div),  .a (rs1_data_e),   .b (rs2_data_e), .alu_op(alu_op_e), .res (div_o));
  exu_alu alu_0 (.en (base), .a (alu_a),        .b (alu_b),      .alu_op(alu_op_e), .res (alu_o));

  mydff #(.W(5))  rd_addrff        (.*, .din(rd_addr_e),   .dout(rd_addr_m));
  mydff #(.W(32)) store_dataff     (.*, .din(rs2_data_e),  .dout(store_data_m));

  mydff #(.W(LsuOpW)) lsu_opff (.*, .din(lsu_op_e),    .dout(lsu_op_m));

  mydff #(.W(31), .L(1)) pcff (.*, .din(pc_e), .dout(pc_m));

  mydffsclr rd_enff     (.*, .clr(exu_pc_redir_en), .din(rd_en_e),      .dout(rd_en_m));
  mydffsclr lsuff       (.*, .clr(exu_pc_redir_en), .din(lsu_e),        .dout(lsu_m));

  // TODO: pack
  mydffsclr     brff        (.*, .clr(exu_pc_redir_en), .din(br_e),         .dout(br_m));
  mydffsclr     compff      (.*, .clr(exu_pc_redir_en), .din(comp_e),       .dout(comp_m));
  mydffsclr     br_atakenff (.*, .clr(exu_pc_redir_en), .din(br_ataken_e),  .dout(br_ataken_m));
  mydffsclr     jalrff      (.*, .clr(exu_pc_redir_en), .din(jalr_e),       .dout(jalr_m));
  mydffsclr     jalff       (.*, .clr(exu_pc_redir_en), .din(jal_e),        .dout(jal_m));
  mydffsclr     br_mispff   (.*, .clr(exu_pc_redir_en), .din(br_misp_d),    .dout(br_misp_m));
  mydffsclr     validff     (.*, .clr(exu_pc_redir_en), .din(valid_e),      .dout(valid_m));
  mydff #(.W(32)) alu_res_ff (.*, .din(base ? alu_o : (mul ? mul_o : (div ? div_o : 32'h0))), .dout(alu_res_m));

  mydff         redirect_ff (.*, .din(exu_pc_redir_en_d), .dout(exu_pc_redir_en));
  // verilog_format: on

endmodule : exu
