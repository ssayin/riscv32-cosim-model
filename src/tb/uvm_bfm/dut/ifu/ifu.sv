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
  logic        br_ataken;
  logic        take_jump;
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

  localparam logic [31:0] Nop = 'h13;

  logic [2:0] seq = 3'b111;
  logic [2:0] seq_next = 3'b111;
  logic       comp_d0_next;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) pc_d0 <= 31'b0;
    else pc_d0 <= pc;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (clk || !rst_n) illegal_d0 <= 0;
  end

  logic        comp[0:3];
  logic        br  [0:3];
  logic        j   [0:3];
  logic [31:0] jimm[0:3];

  genvar i;

  generate
    for (i = 0; i < 4; i++) begin : g_comp
      assign comp[i] = !(wordline[16*(i+1)-1] && wordline[16*(i+1)-2]);
    end : g_comp
  endgenerate

  generate
    for (i = 0; i < 4; i++) begin : g_branch_early
      riscv_decoder_br dec_br (
        .instr(wordline[(4-i)*16-1:(3-i)*16]),
        .br   (br[i])
      );

      riscv_decoder_j_no_rr dec_j_no_rr (
        .instr(wordline[(4-i)*16-1:(3-i)*16]),
        .j    (j[i])
      );

      riscv_decoder_j_no_rr_imm dec_j_no_rr_imm (
        .instr(wordline[(4-i)*16-1:(3-i)*16]),
        .imm  (jimm[i])
      );
    end
  endgenerate

  always_comb begin
    seq_next       = seq;
    row_flush_next = 0;
    case (seq)
      3'b000:  seq_next = (comp[0] && comp[1]) ? 3'b001 : 3'b010;
      3'b001:  seq_next = 3'b010;
      3'b010:  {seq_next, row_flush_next} = (comp[2] && comp[3]) ? {3'b011, 1'b0} : {3'b000, 1'b1};
      3'b011:  {seq_next, row_flush_next} = {3'b000, 1'b1};
      3'b111:  {seq_next, row_flush_next} = (flush || empty) ? {3'b111, 1'b1} : {3'b000, 1'b0};
      default: seq_next = seq;
    endcase
    if ((empty == 1'b1) && (seq_next == 1'b111)) {seq_next, row_flush_next} = {3'b111, 1'b1};
  end

  assign flush = ((seq == 3'b000) && (take_jump_0)) || ((seq == 3'b001) && (take_jump_1)) || ((seq == 3'b010) && (take_jump_2)) || ((seq == 3'b011) && (take_jump_3)) || (pc_update == 1'b1);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      pc  <= 31'b0;
      seq <= 3'b111;
    end else begin
      if (pc_update) begin
        pc  <= pc_in;
        seq <= 3'b111;
      end else begin
        case (seq)
          3'b000: begin
            if (take_jump_0) begin
              pc[31:1] <= jimm[0][31:1];
              seq      <= 3'b111;
            end else begin
              pc[31:1] <= pc[31:1] + (comp[0] ? 31'h1 : 31'h2);
              seq      <= seq_next;
            end
          end
          3'b001: begin
            if (take_jump_1) begin
              pc[31:1] <= jimm[1][31:1];
              seq      <= 3'b111;
            end else begin
              pc[31:1] <= pc[31:1] + (comp[1] ? 31'h1 : 31'h2);
              seq      <= seq_next;
            end
          end
          3'b010: begin
            if (take_jump_2) begin
              pc[31:1] <= jimm[2][31:1];
              seq      <= 3'b111;
            end else begin
              pc[31:1] <= pc[31:1] + (comp[2] ? 31'h1 : 31'h2);
              seq      <= seq_next;
            end
          end
          3'b011: begin
            if (take_jump_3) begin
              pc[31:1] <= jimm[3][31:1];
              seq      <= 3'b111;
            end else begin
              pc[31:1] <= pc[31:1] + (comp[3] ? 31'h1 : 31'h2);
              seq      <= seq_next;
            end
          end
          default: begin
            pc  <= pc;
            seq <= seq_next;
          end
        endcase
      end
    end
  end
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      row_flush <= 1;
      instr_d0  <= 31'h13;
      comp_d0   <= 0;
    end else begin
      row_flush <= row_flush_next;
      case (seq)
        3'b000:  {instr_d0, comp_d0} <= {wordline[63:32], comp[0]};
        3'b001:  {instr_d0, comp_d0} <= {{16'b0, wordline[63:48]}, comp[1]};
        3'b010:  {instr_d0, comp_d0} <= {wordline[31:0], comp[2]};
        3'b011:  {instr_d0, comp_d0} <= {{16'b0, wordline[31:16]}, comp[3]};
        default: {instr_d0, comp_d0} <= {32'h13, 1'b0};
      endcase
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) br_ataken_d0 <= 0;
    else br_ataken_d0 <= br_ataken;
  end
  assign take_jump_0 = j[0] && !pc_update;  // always prioritize mispredicted branches and exceptions
  assign take_jump_1 = j[1] && !pc_update;  // always prioritize mispredicted branches and exceptions
  assign take_jump_2 = j[2] && !pc_update;  // always prioritize mispredicted branches and exceptions
  assign take_jump_3 = j[3] && !pc_update;  // always prioritize mispredicted branches and exceptions
  assign br_ataken   = 'b0;
  assign br_d0       = 'b0;
  ifu_mem_ctrl ctrl (.*);
endmodule : ifu
