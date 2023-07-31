// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import instr_defs::*;

module ifu (
  input  logic clk,
  input  logic rst_n,
  input  logic flush_f,  // TODO: decide if this is really needed
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
  output logic [31:1] pc_out,
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

  logic [63:0] instr;

  logic        start_fetch;
  logic        done_fetch;


  assign axi_arlen_f   = 1;
  assign axi_arburst_f = 2'b01;

  assign stall_f       = 1;

  typedef enum logic [1:0] {
    IDLE  = 2'b00,
    FETCH = 2'b01
  } axi_state_t;

  axi_state_t axi_state = IDLE;
  axi_state_t axi_state_next = IDLE;

  always_comb begin
    start_fetch    = 0;
    axi_state_next = axi_state;

    case (axi_state)
      IDLE: begin
        axi_state_next = FETCH;
        start_fetch    = 1;
      end
      FETCH: begin
        axi_state_next = IDLE;
        if (axi_rready_f && axi_rvalid_f) begin
          if (axi_rlast_f) axi_state_next = IDLE;
          else axi_state_next = FETCH;
        end
      end
      default: axi_state_next = axi_state;
    endcase
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      axi_state <= IDLE;
    end else begin
      axi_state <= axi_state_next;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      axi_araddr_f <= 0;
    end else begin
      case (axi_state)
        IDLE, FETCH: axi_araddr_f <= {pc[31:1], 1'b0};
        default:     axi_araddr_f <= 0;
      endcase
    end
  end


  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      axi_arvalid_f <= 0;
    end else begin
      if (start_fetch) axi_arvalid_f <= 1'b1;
      if (axi_arready_f && axi_arvalid_f) axi_arvalid_f <= 1'b0;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      instr[63:0] <= 64'h13;
    end else begin
      if (axi_rvalid_f && axi_rready_f) begin
        instr[63:0] <= axi_rdata_f[63:0];
      end else begin
        instr[63:0] <= 64'h13;
      end
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      axi_rready_f <= 0;
    end else begin
      axi_rready_f <= 1'b1;
    end
  end


  localparam logic [31:0] Nop = 'h13;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) pc_d0 <= 31'b0;
    else pc_d0 <= pc;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    illegal_d0 <= 0;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      pc            <= 30'h0;  // boot sector
      compressed_d0 <= 0;
      instr_d0      <= Nop;
      br_taken_d0   <= 0;
    end else begin
      if (start_fetch) begin
        $display("IF bubble");
        instr_d0      <= Nop;
        compressed_d0 <= 0;
        pc[31:1]      <= pc[31:1];
      end else if (pc_update) begin
        $display("pc_update = 1");
        compressed_d0 <= 'b0;
        pc            <= pc_in;
        instr_d0      <= Nop;
      end else if (take_jump) begin
        $display("take_jump = 1");
        compressed_d0 <= compressed;
        pc[31:1]      <= jimm[31:1];
        instr_d0      <= Nop;
      end else begin
        $display("pc = %d", pc);
        compressed_d0 <= compressed;
        pc[31:1]      <= pc[31:1] + (compressed ? 31'h1 : 31'h2);
        instr_d0      <= {{instr[31:24], instr[23:16], instr[15:8], instr[7:0]}};
        br_taken_d0   <= br_taken;
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

  assign br_taken            = 'b0;
  assign pc_out              = pc;
  assign compressed          = ~(instr[0] & instr[1]);
  assign br_d0               = br;

  assign axi_arid_f          = 0;
  assign axi_arlock_f        = 0;
  assign axi_arsize_f[2:0]   = 0;
  assign axi_arcache_f[3:0]  = 0;
  assign axi_arprot_f[2:0]   = 0;
  assign axi_arqos_f[3:0]    = 0;
  assign axi_arregion_f[3:0] = 0;

endmodule : ifu
