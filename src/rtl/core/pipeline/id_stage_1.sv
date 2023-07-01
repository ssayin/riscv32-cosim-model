// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import instr_defs::*;

module id_stage_1 (
  input  logic      clk,
  input  logic      rst_n,
  input  reg_addr_t rd_addr,
  input  p_if_id_t  p_if_id,
  output p_id_ex_t  p_id_ex
);


  // Internal Signal Wires
  logic     [ DataWidth-1:0] imm_next;
  logic                      use_imm_next;
  ctl_pkt_t                  ctl_next;
  logic                      rd_en_next;

  logic     [AluOpWidth-1:0] alu_op_next;
  logic     [LsuOpWidth-1:0] lsu_op_next;

  riscv_decoder_ctl_imm dec_ctl_imm (
    .clk       (clk),
    .rst_n     (rst_n),
    .instr     (p_if_id.instr),
    .compressed(p_if_id.compressed),
    .imm       (imm_next),
    .rd_en     (rd_en_next),
    .ctl       (ctl_next),
    .use_imm   (use_imm_next),
    .alu_op    (alu_op_next),
    .lsu_op    (lsu_op_next)
  );

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      p_id_ex.imm      <= 'h0;
      p_id_ex.use_imm  <= 'b0;
      p_id_ex.alu_op   <= 'h0;
      p_id_ex.lsu_op   <= 'h0;
      p_id_ex.rd_addr  <= 'h0;
      p_id_ex.lsu      <= 'h0;
      p_id_ex.alu      <= 'h0;
      p_id_ex.br       <= 'h0;
      p_id_ex.br_taken <= 'h0;
    end else begin
      p_id_ex.imm      <= imm_next;
      p_id_ex.use_imm  <= use_imm_next;
      p_id_ex.alu_op   <= alu_op_next;
      p_id_ex.lsu_op   <= lsu_op_next;
      p_id_ex.rd_addr  <= rd_addr;
      p_id_ex.rd_en    <= rd_en_next;
      p_id_ex.lsu      <= ctl_next.lsu;
      p_id_ex.alu      <= ctl_next.alu;
      p_id_ex.br       <= p_if_id.br;
      p_id_ex.br_taken <= p_if_id.br_taken;
    end
  end

endmodule : id_stage_1
