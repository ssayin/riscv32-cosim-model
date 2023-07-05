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

module ex_stage
  import param_defs::*;
(
  input  logic      clk,
  input  logic      rst_n,
  input  logic      rs1_data,
  input  logic      rs2_data,
  input  p_id_ex_t  p_id_ex,
  output p_ex_mem_t p_ex_mem,
  output logic      should_br,
  output logic      br_mispredictd
);
  logic [DataWidth-1:0] res_next;
  logic [DataWidth-1:0] alu_out;
  logic                 bru_out;
  logic                 should_br_next;

  bru bru_0 (
    .en     (p_id_ex.br),
    .br_type(p_id_ex.br_op),
    .a      (rs1_data),
    .b      (rs2_data),
    .out    (bru_out)
  );

  alu alu_0 (
    .a     (p_id_ex.use_pc ? p_id_ex.pc : rs1_data),
    .b     (p_id_ex.use_imm ? p_id_ex.imm : rs2_data),
    .alu_op(p_id_ex.alu_op),
    .res   (alu_out)
  );

  assign should_br_next = !p_id_ex.br_taken && bru_out;
  assign br_mispredictd = !bru_out && p_id_ex.br_taken;

  always_comb begin
    if (br_mispredictd) res_next = p_id_ex.compressed ? p_id_ex.pc + 2 : p_id_ex.pc + 4;
    else res_next = alu_out;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      p_ex_mem.alu_res    <= 'b0;
      should_br           <= 'b0;
      p_ex_mem.br_taken   <= 'b0;
      p_ex_mem.br         <= 'b0;
      p_ex_mem.compressed <= 'b0;
      p_ex_mem.lsu_op     <= 'h0;
      p_ex_mem.lsu        <= 'b0;
      p_ex_mem.rd_addr    <= 'h0;
      p_ex_mem.rd_en      <= 'b0;
      p_ex_mem.store_data <= 'h0;
    end else begin
      p_ex_mem.alu_res    <= res_next;
      should_br           <= should_br_next;
      p_ex_mem.br_taken   <= p_id_ex.br_taken;
      p_ex_mem.br         <= p_id_ex.br;
      p_ex_mem.compressed <= p_id_ex.compressed;
      p_ex_mem.lsu_op     <= p_id_ex.lsu_op;
      p_ex_mem.lsu        <= p_id_ex.lsu;
      p_ex_mem.rd_addr    <= p_id_ex.rd_addr;
      p_ex_mem.rd_en      <= p_id_ex.rd_en;
      p_ex_mem.store_data <= rs2_data;
    end
  end

endmodule : ex_stage
