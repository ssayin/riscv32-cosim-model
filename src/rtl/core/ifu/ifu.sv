// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import instr_defs::*;

module ifu (
  input  logic clk,
  input  logic rst_n,
  input  logic flush_f,
  output logic stall_f,

  // RA Channel
  output logic        axi_arid_f,
  output logic [31:0] axi_araddr_f,
  output logic [ 7:0] axi_arlen_f,
  output logic [ 2:0] axi_arsize_f,
  output logic [ 1:0] axi_arburst_f,
  output logic        axi_arlock_f,
  output logic [ 3:0] axi_arcache_f,
  output logic [ 2:0] axi_arprot_f,
  output logic        axi_arvalid_f,
  output logic [ 3:0] axi_arqos_f,
  output logic [ 3:0] axi_arregion_f,
  input  logic        axi_arready_f,

  // RD Channel
  input  logic        axi_rid_f,
  input  logic [63:0] axi_rdata_f,
  input  logic [ 1:0] axi_rresp_f,
  input  logic        axi_rlast_f,
  input  logic        axi_rvalid_f,
  output logic        axi_rready_f,

  input  logic [31:1] pc_in,
  input  logic        pc_update,
  output logic [31:0] instr_d0,
  output logic [31:1] pc_d0,
  output logic        compressed_d0,
  output logic        br_d0,
  output logic        br_taken_d0,
  output logic        illegal_d0
);

  logic [31:1] pc;
  logic        compressed;
  logic        j;
  logic [31:0] jimm;
  logic        br;
  logic        br_taken;
  logic        take_jump;

  logic [31:0] instr;

  logic        start_fetch;
  logic        done_fetch;

  assign stall_f = 1;

  localparam logic [31:0] Nop = 'h13;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) pc_d0 <= 31'b0;
    else pc_d0 <= pc;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    illegal_d0 <= 0;
  end

  assign instr_d0      = {{instr[31:24], instr[23:16], instr[15:8], instr[7:0]}};
  assign compressed_d0 = compressed;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      br_taken_d0 <= 0;
    end else begin
      br_taken_d0 <= br_taken;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      pc <= 31'h0;  // boot sector
    end else begin
      if (!start_fetch) begin
        $display("IF bubble");
        pc[31:1] <= pc[31:1];
      end else if (pc_update) begin
        $display("pc_update = 1");
        pc <= pc_in;
      end else if (take_jump) begin
        $display("take_jump = 1");
        pc[31:1] <= jimm[31:1];
      end else begin
        $display("pc = %d", pc);
        pc[31:1] <= pc[31:1] + (compressed ? 31'h1 : 31'h2);
      end
    end
  end

  assign take_jump = j && !pc_update;  // always prioritize mispredicted branches and exceptions

  riscv_decoder_br dec_br (
    .instr(instr[15:0]),
    .br   (br)
  );

  riscv_decoder_j_no_rr dec_j_no_rr (
    .instr(instr[15:0]),
    .j    (j)
  );

  riscv_decoder_j_no_rr_imm dec_j_no_rr_imm (
    .instr(instr[31:0]),
    .imm  (jimm)
  );

  assign br_taken = 'b0;
  assign br_d0    = br;

  ifu_mctrl ctrl (.*);

endmodule : ifu
