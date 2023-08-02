// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import instr_defs::*;

// Ensure instructions are aligned to 2 byte boundaries.
// Buffer size = 64
module ifu_mctrl (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [31:1] pc,
  output logic        start_fetch,
  output logic        done_fetch,
  output logic [31:0] instr,
  output logic        compressed,

  // AXI Channels
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
  input  logic        axi_rid_f,
  input  logic [63:0] axi_rdata_f,
  input  logic [ 1:0] axi_rresp_f,
  input  logic        axi_rlast_f,
  input  logic        axi_rvalid_f,
  output logic        axi_rready_f
);

  assign axi_arlen_f   = 8;
  assign axi_arburst_f = 2'b01;

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
      instr[31:0] <= 32'h13;
      compressed  <= 0;
    end else begin
      if (axi_rvalid_f && axi_rready_f) begin
        instr[31:0] <= axi_rdata_f[31:0];
        compressed  <= ~(instr[0] & instr[1]);
      end else begin
        instr[31:0] <= 32'h13;
        compressed  <= 0;
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

  assign axi_arid_f          = 0;
  assign axi_arlock_f        = 0;
  assign axi_arsize_f[2:0]   = 0;
  assign axi_arcache_f[3:0]  = 0;
  assign axi_arprot_f[2:0]   = 0;
  assign axi_arqos_f[3:0]    = 0;
  assign axi_arregion_f[3:0] = 0;

endmodule

