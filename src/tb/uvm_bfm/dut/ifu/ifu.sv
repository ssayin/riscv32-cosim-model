// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0
import defs_pkg::*;
module ifu (
  input  logic                  clk,
  input  logic                  rst_n,
  input  logic                  flush_f,
  output logic                  stall_f,
  input  logic [          31:1] pc_m,
  input  logic                  comp_m,
  input  logic                  br_misp_m,
  input  logic                  br_ataken_m,
  output logic [          31:0] instr_d0,
  output logic [          31:1] pc_d0,
  output logic                  comp_d0,
  output logic                  br_d0,
  output logic                  br_ataken_d0,
  output logic                  illegal_d0,
  // AR Channel
  output logic [AxiIdWidth-1:0] axi_arid_f,
  output logic [          31:0] axi_araddr_f,
  output logic [           7:0] axi_arlen_f,
  output logic [           2:0] axi_arsize_f,
  output logic [           1:0] axi_arburst_f,
  output logic                  axi_arlock_f,
  output logic [           3:0] axi_arcache_f,
  output logic [           2:0] axi_arprot_f,
  output logic                  axi_arvalid_f,
  output logic [           3:0] axi_arqos_f,
  output logic [           3:0] axi_arregion_f,
  input  logic                  axi_arready_f,
  // R Channel
  input  logic [AxiIdWidth-1:0] axi_rid_f,
  input  logic [          63:0] axi_rdata_f,
  input  logic [           1:0] axi_rresp_f,
  input  logic                  axi_rlast_f,
  input  logic                  axi_rvalid_f,
  output logic                  axi_rready_f
);

  localparam logic [31:0] Nop = 'h13;

  logic        br_ataken;
  logic        take_jump_0;
  logic        take_jump_1;
  logic        take_jump_2;
  logic        take_jump_3;
  logic [63:0] wordline;
  logic        flush;
  logic        row_flush;
  logic        row_flush_next;
  logic        start_fetch;
  logic        done_fetch;
  logic        pc_incr;
  logic        empty_ff;
  logic        empty;

  assign stall_f = 1;


  logic [31:1] pc;

  logic [ 4:0] seq = SelW;
  logic [ 4:0] seq_next = SelW;

  always_ff @(posedge clk or negedge rst_n) begin
    if (clk || !rst_n) illegal_d0 <= 0;
  end

  logic comp_0;
  logic comp_1;
  logic comp_2;
  logic comp_3;


  always_comb begin
    seq_next       = seq;
    row_flush_next = 0;
    case (seq)
      Sel0:    seq_next = (comp_0 && comp_1) ? Sel1 : Sel2;
      Sel1:    seq_next = Sel2;
      Sel2:    {seq_next, row_flush_next} = (comp_2 && comp_3) ? {Sel3, 1'b0} : {Sel0, 1'b1};
      Sel3:    {seq_next, row_flush_next} = {Sel0, 1'b1};
      default: {seq_next, row_flush_next} = (flush || empty) ? {SelW, 1'b1} : {Sel0, 1'b0};
    endcase
    if ((empty == 1'b1) && (seq_next == SelW)) {seq_next, row_flush_next} = {SelW, 1'b1};
  end

  assign flush = ((seq == Sel0) && (take_jump_0)) || ((seq == Sel1) && (take_jump_1)) || ((seq == Sel2) && (take_jump_2)) || ((seq == Sel3) && (take_jump_3)) || (br_misp_m == 1'b1);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      row_flush <= 1;
      instr_d0  <= 31'h13;
      comp_d0   <= 0;
    end else begin
      row_flush <= row_flush_next;
      case (seq)
        Sel0:    {instr_d0, comp_d0} <= {wordline[63:32], comp_0};
        Sel1:    {instr_d0, comp_d0} <= {{16'b0, wordline[63:48]}, comp_1};
        Sel2:    {instr_d0, comp_d0} <= {wordline[31:0], comp_2};
        Sel3:    {instr_d0, comp_d0} <= {{16'b0, wordline[31:16]}, comp_3};
        default: {instr_d0, comp_d0} <= {32'h13, 1'b0};
      endcase
    end
  end

  ifu_mem_ctrl ctrl (.*);
  ifu_br ifu_br_0 (.*);

endmodule : ifu
