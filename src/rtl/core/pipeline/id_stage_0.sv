// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import instr_defs::*;

module id_stage_0 (
  input  logic      clk,
  input  logic      rst_n,
  input  p_if_id_t  p_if_id_0,
  input  logic      flush,
  output p_if_id_t  p_id_0_id_1,
  output reg_addr_t rd_addr,
  output reg_addr_t rs1_addr,
  output reg_addr_t rs2_addr
);


  // Internal Signal Wires

  logic [RegAddrWidth-1:0] rs1_addr_next;
  logic [RegAddrWidth-1:0] rs2_addr_next;
  logic [RegAddrWidth-1:0] rd_addr_next;

  riscv_decoder_gpr dec_gpr (
    .clk       (clk),
    .rst_n     (rst_n),
    .instr     (p_if_id_0.instr),
    .compressed(p_if_id_0.compressed),
    .rd_addr   (rd_addr_next),
    .rs1_addr  (rs1_addr_next),
    .rs2_addr  (rs2_addr_next)
  );

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      p_id_0_id_1 <= '{default: '0};
      rd_addr     <= 'h0;
      rs1_addr    <= 'h0;
      rs2_addr    <= 'h0;
    end else begin
      p_id_0_id_1 <= p_if_id_0;
      rs1_addr    <= rs1_addr_next;
      rs2_addr    <= rs2_addr_next;
      rd_addr     <= rd_addr_next;
    end
  end

endmodule : id_stage_0
