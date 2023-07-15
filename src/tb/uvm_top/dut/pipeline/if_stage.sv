// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import instr_defs::*;

module if_stage (
  input  logic                   clk,
  input  logic                   rst_n,
  input  logic                   flush_f,        // TODO: decide if this is really needed
  input  logic [MemBusWidth-1:0] mem_rd,
  input  logic [  DataWidth-1:0] pc_in,
  input  logic                   pc_update,
  output logic [  DataWidth-1:0] pc_out,
  output logic [           31:0] instr_d0,
  output logic [           31:1] pc_d0,
  output logic                   compressed_d0,
  output logic                   br_d0,
  output logic                   br_taken_d0
);

  logic [31:1] pc;
  logic        compressed;
  logic        j;
  logic [31:0] jimm;
  logic        br;
  logic        br_taken;
  logic        take_jump;

  localparam logic [31:0] Nop = 'h13;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      pc            <= 'h0;  // boot sector
      pc_d0         <= 'h0;
      compressed_d0 <= 'b0;
      instr_d0      <= 'h0;  // maybe nop?
      br_taken_d0   <= 'b0;
      //end else if (flush) begin  // TODO: decide what to do here
      //  p_if_id.pc         <= 'h0;
      //  p_if_id.compressed <= 'b0;
      //  p_if_id.instr      <= 'h0;
      //  p_if_id.br_taken   <= 'b0;
    end else begin
      if (pc_update) begin
        pc_d0         <= pc;
        compressed_d0 <= 'b0;
        pc            <= pc_in;
        instr_d0      <= Nop;
      end else if (take_jump) begin
        pc_d0         <= pc;
        compressed_d0 <= 'b0;
        pc            <= jimm;
        instr_d0      <= Nop;
      end else begin
        pc_d0         <= pc;
        compressed_d0 <= compressed;
        pc            <= pc + (compressed ? 'h2 : 'h4);
        instr_d0      <= {{mem_rd[31:24], mem_rd[23:16], mem_rd[15:8], mem_rd[7:0]}};
        br_taken_d0   <= br_taken;
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
  assign br_d0      = br;

endmodule : if_stage
