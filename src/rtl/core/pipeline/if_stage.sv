// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module if_stage (
    input  logic                   clk,
    input  logic                   rst_n,
    input  logic [MemBusWidth-1:0] mem_rd,
    output logic [  DataWidth-1:0] pc,
    output logic [           31:0] instr,
    output logic                   br,
    output logic                   br_taken
);

  import param_defs::*;

  logic [DataWidth-1:0] pc_next;

  logic compressed;
  assign compressed = ~(mem_rd[0] & mem_rd[1]);

  always_comb begin
    pc_next = pc + (compressed ? 'h2 : 'h4);
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      pc <= 'h0;
    end else begin
      pc <= pc_next;
    end
  end

  always_comb begin
    if (compressed) begin
      instr = {{mem_rd[31:24], mem_rd[23:16], mem_rd[15:8], mem_rd[7:0]}};
    end else begin
      instr = {{16'h0, mem_rd[15:8], mem_rd[7:0]}};
    end
  end

  riscv_decoder_br dec_br (
      .instr(instr[15:0]),
      .br(br)
  );

  assign br_taken = 'b0;

endmodule : if_stage
