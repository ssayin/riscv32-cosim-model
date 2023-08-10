// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0
import defs_pkg::*;
module ifu (
  input  logic                  clk,
  input  logic                  rst_n,
  input  logic                  flush_f,
  output logic                  stall_f,
  input  logic [          31:1] pc_in,
  input  logic                  pc_update,
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
  logic [31:1] pc;
  logic        j;
  logic [31:0] jimm;
  logic        br;
  logic        br_ataken;
  logic        take_jump;
  logic [63:0] wordline;
  logic        row_flush;
  logic        start_fetch;
  logic        done_fetch;
  logic        pc_incr;
  logic        empty_ff;
  logic        empty;
  assign stall_f = 1;
  localparam logic [31:0] Nop = 'h13;
  logic [1:0] seq = 2'b00;
  logic [1:0] seq_next = 2'b00;
  logic       comp_d0_next;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) pc_d0 <= 31'b0;
    else pc_d0 <= pc;
  end
  always_ff @(posedge clk or negedge rst_n) begin
    if (clk || !rst_n) illegal_d0 <= 0;
  end
  logic comp[0:3];
  genvar i;
  generate
    for (i = 0; i < 4; i++) begin : g_comp
      assign comp[i] = !(wordline[0] && wordline[1]);
    end : g_comp
  endgenerate
  always_comb begin
    if (empty_ff && empty) begin
      seq_next = 2'b00;
    end else begin
      seq_next = seq;
      case (seq)
        2'b00:   seq_next = (comp[0] && comp[1]) ? 2'b01 : 2'b10;
        2'b01:   seq_next = 2'b10;
        2'b10:   seq_next = (comp[2] && comp[3]) ? 2'b00 : 2'b11;
        2'b11:   seq_next = 2'b00;
        default: seq_next = seq;
      endcase
    end
  end
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      pc <= 31'b0;
    end else begin
      if (empty && (seq[1:0] == 2'b00)) pc <= pc;
      else if (pc_update) pc <= pc_in;
      else if (take_jump) pc[31:1] <= jimm[31:1];
      else begin
        case (seq)
          2'b00:   pc[31:1] <= pc[31:1] + (comp[0] ? 31'h1 : 31'h2);
          2'b01:   pc[31:1] <= pc[31:1] + (comp[1] ? 31'h1 : 31'h2);
          2'b10:   pc[31:1] <= pc[31:1] + (comp[2] ? 31'h1 : 31'h2);
          2'b11:   pc[31:1] <= pc[31:1] + (comp[3] ? 31'h1 : 31'h2);
          default: pc <= pc;
        endcase
      end
    end
  end
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      seq       <= 2'b00;
      row_flush <= 0;
      instr_d0  <= 31'h13;
      comp_d0   <= 0;
    end else begin
      if (empty && (seq[1:0] == 2'b00)) begin
        seq       <= 2'b00;
        row_flush <= 0;
        instr_d0  <= 31'h13;
        comp_d0   <= 0;
      end else begin
        row_flush <= seq[1];
        seq       <= seq_next;
        case (seq)
          2'b00:   {instr_d0, comp_d0} <= {wordline[63:32], comp[0]};
          2'b01:   {instr_d0, comp_d0} <= {{16'b0, wordline[47:16]}, comp[1]};
          2'b10:   {instr_d0, comp_d0} <= {{32'b0, wordline[31:0]}, comp[2]};
          2'b11:   {instr_d0, comp_d0} <= {{48'b0, wordline[31:16]}, comp[3]};
          default: {instr_d0, comp_d0} <= {32'b0, 1'b0};
        endcase
      end
    end
  end
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) br_ataken_d0 <= 0;
    else br_ataken_d0 <= br_ataken;
  end
  assign take_jump = j && !pc_update;  // always prioritize mispredicted branches and exceptions
  // riscv_decoder_br dec_br (
  //  .instr(instr0[15:0]),
  // .br   (br)
  //);
  //riscv_decoder_j_no_rr dec_j_no_rr (
  //.instr(instr0[15:0]),
  //.j    (j)
  //);
  //riscv_decoder_j_no_rr_imm dec_j_no_rr_imm (
  //.instr(instr0[31:0]),
  //.imm  (jimm)
  //);
  assign br_ataken = 'b0;
  assign br_d0     = br;
  ifu_mem_ctrl ctrl (.*);
endmodule : ifu
