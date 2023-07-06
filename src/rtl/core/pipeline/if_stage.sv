// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import instr_defs::*;

module if_stage (
  input  logic                       clk,
  input  logic                       rst_n,
  input  logic                       flush,      // TODO: decide if this is really needed
  input  logic     [MemBusWidth-1:0] mem_rd,
  input  logic     [  DataWidth-1:0] pc_in,
  input  logic                       pc_update,
  output logic     [  DataWidth-1:0] pc_out,
  output p_if_id_t                   p_if_id
);

  logic [31:1] pc;
  logic                 compressed;
  logic                 j;
  logic [         31:0] jimm;
  logic                 br;
  logic                 br_taken;
  logic                 take_jump;

  localparam logic [31:0] Nop = 'h13;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      pc                 <= 'h0;  // boot sector
      p_if_id.pc         <= 'h0;
      p_if_id.compressed <= 'b0;
      p_if_id.instr      <= 'h0;  // maybe nop?
      p_if_id.br_taken   <= 'b0;
      //end else if (flush) begin  // TODO: decide what to do here
      //  p_if_id.pc         <= 'h0;
      //  p_if_id.compressed <= 'b0;
      //  p_if_id.instr      <= 'h0;
      //  p_if_id.br_taken   <= 'b0;
    end else begin
      if (pc_update) begin
        p_if_id.pc         <= pc;
        p_if_id.compressed <= 'b0;
        pc                 <= pc_in;
        p_if_id.instr      <= Nop;
      end else if (take_jump) begin
        p_if_id.pc         <= pc;
        p_if_id.compressed <= 'b0;
        pc                 <= jimm;
        p_if_id.instr      <= Nop;
      end else begin
        p_if_id.pc         <= pc;
        p_if_id.compressed <= compressed;
        pc                 <= pc + (compressed ? 'h2 : 'h4);
        p_if_id.instr      <= {{mem_rd[31:24], mem_rd[23:16], mem_rd[15:8], mem_rd[7:0]}};
        p_if_id.br_taken   <= br_taken;
      end
    end
  end

  assign take_jump = j && !pc_update;  // always prioritize mispredicted branches and exceptions

  riscv_decoder_br dec_br (
    .instr(mem_rd[15:0]),
    .br   (br)
  );

  riscv_decoder_j_no_rr dec_j_no_rr (
    .instr(mem_rd[15:0]),
    .j    (j)
  );

  riscv_decoder_j_no_rr_imm dec_j_no_rr_imm (
    .instr(mem_rd),
    .imm  (jimm)
  );

  assign br_taken   = 'b0;
  assign pc_out     = pc;
  assign compressed = ~(mem_rd[0] & mem_rd[1]);
  assign p_if_id.br = br;

endmodule : if_stage
