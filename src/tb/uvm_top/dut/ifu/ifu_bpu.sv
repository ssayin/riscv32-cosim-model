// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module ifu_bpu_pred_fsm (
  input  logic       valid_n,
  input  logic       taken,
  input  logic [1:0] state_in,
  output logic [1:0] state_out
);

  localparam logic [1:0] ST = 2'b00;
  localparam logic [1:0] WT = 2'b01;
  localparam logic [1:0] WNT = 2'b10;
  localparam logic [1:0] SNT = 2'b11;

  always_comb begin
    state_out = state_in;
    if (~valid_n) begin
      case (state_in)
        ST:      state_out = taken ? ST : WT;
        WT:      state_out = taken ? ST : WNT;
        WNT:     state_out = taken ? WT : SNT;
        SNT:     state_out = taken ? WNT : SNT;
        default: state_out = state_in;
      endcase
    end
  end

endmodule

module ifu_bpu_pred (
  input  logic [1:0] state_in,
  output logic       take
);

  assign take = ~state_in[1];

endmodule

module ifu_btb #(
    parameter int LS = 32
) (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [31:1] pc,
  input  logic        ready,
  input  logic        misp,
  output logic        valid,
  output logic [31:1] target
);

  logic [63:0] btbline[LS];

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
    end else begin
    end
  end

endmodule


module ifu_bpu (
  input  logic         clk,
  input  logic         rst_n,
  input  logic         clr,
  output logic         br_ataken,
  input  logic         exu_pc_redir_en_d,
  input  logic         exu_pc_redir_en,
  input  logic         exu_pc_redir_en_q0,
  input  logic [  3:0] ifu_algn_valid,
  input  logic [127:0] ifu_algn_pkt,
  input  logic [127:0] ifu_algn_pc_pkt,
  output logic         jal_en,
  input  logic [ 31:1] ifu_fetch_pc,
  input  logic [ 31:1] ifu_fetch_pc_q0,
  output logic [ 31:1] jal_target,
  input  logic [ 31:0] alu_res_m,
  input  logic         jalr_m,
  output logic [  3:0] wren,
  input  logic [ 31:1] pc_m,
  input  logic         br_misp_m,
  input  logic         comp_m,
  input  logic         valid_m,
  input  logic         br_ataken_m,
  output logic         jal_en_q0
);
  logic [127:0] jimm;
  logic [  3:0] jal;
  logic [  3:0] valid_mask;

  always_comb valid_mask[3:0] = ifu_algn_valid[3:0];
  // & {{4}{/*~br_misp_m_q0 | */~exu_pc_redir_en || ~exu_pc_redir_en_q0}};
  // & {{4}{~br_misp_m_q0 | ~exu_pc_redir_en | ~jal_en_q0}}) >> ifu_fetch_pc_q0[2:1]; //& };
  // & ~{{4}{br_misp_m_q0}} & ~{{4}{jal_en_q0}} & ~{{4}{jalr_m_q0 & ~br_misp_m_q0}};

  // verilog_format: off
  genvar i;
  generate
    for (i = 0; i < 4; i++) begin : g_jal
      decode_jal_imm   dec_jal_imm   (.instr (ifu_algn_pkt[i*32+:32]),    .imm  (jimm[i*32+:32]));
      decode_jal       dec_jal       (.instr (ifu_algn_pkt[i*32+:16]),    .jal  (jal[i]));
    end
  endgenerate

  // verilog_format: on

  logic [3:0] jal_mask;

  always_comb jal_mask = jal & valid_mask;
  always_comb jal_en = |jal_mask;

  mydffsclr #(
      .W(1)
  ) jalenff (
    .*,
    .clr (exu_pc_redir_en_d),
    .din (jal_en),
    .dout(jal_en_q0)
  );

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) wren <= 4'b0000;
    else
      casez (jal_mask)
        4'b???1: wren <= 4'b0001;
        4'b??10: wren <= 4'b0011;
        4'b?100: wren <= 4'b0111;
        4'b1000: wren <= 4'b1111;
        default: wren <= valid_mask;
      endcase
  end

  always_comb begin
    casez (jal_mask)
      4'b???1: jal_target[31:1] = jimm[31:1] + ifu_algn_pc_pkt[31:1];
      4'b??10: jal_target[31:1] = jimm[63:33] + ifu_algn_pc_pkt[63:33];
      4'b?100: jal_target[31:1] = jimm[95:65] + ifu_algn_pc_pkt[95:65];
      4'b1000: jal_target[31:1] = jimm[127:97] + ifu_algn_pc_pkt[127:97];
      default: jal_target[31:1] = {ifu_fetch_pc[31:3] + 29'h1, 2'b00};
    endcase
  end

  assign br_ataken = 1'b0;

endmodule
