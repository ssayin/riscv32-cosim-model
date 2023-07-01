// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import instr_defs::*;

module if_stage (
  input  logic                       clk,
  input  logic                       rst_n,
  input  logic     [MemBusWidth-1:0] mem_rd,
  output p_if_id_t                   p_if_id
);


  logic [DataWidth-1:0] pc_next;

  logic                 compressed;
  assign compressed = ~(mem_rd[0] & mem_rd[1]);

  always_comb begin
    pc_next = p_if_id.pc + (compressed ? 'h2 : 'h4);
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      p_if_id.pc         <= 'h0;
      p_if_id.compressed <= 'b0;
    end else begin
      p_if_id.pc         <= pc_next;
      p_if_id.compressed <= compressed;
    end
  end

  always_comb begin
    if (compressed) begin
      p_if_id.instr = {{mem_rd[31:24], mem_rd[23:16], mem_rd[15:8], mem_rd[7:0]}};
    end else begin
      p_if_id.instr = {{16'h0, mem_rd[15:8], mem_rd[7:0]}};
    end
  end

  riscv_decoder_br dec_br (
    .instr(p_if_id.instr[15:0]),
    .br   (p_if_id.br)
  );

  assign p_if_id.br_taken = 'b0;

endmodule : if_stage
