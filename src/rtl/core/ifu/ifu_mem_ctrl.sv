// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

// Ensure instructions are aligned to 2 byte boundaries.
// Buffer size = 64
module ifu_mem_ctrl (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [31:1] pc,
  output logic        start_fetch,
  output logic        done_fetch,
  output logic [31:0] instr,
  output logic        compressed,

  // AXI Channels
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
  input  logic [AxiIdWidth-1:0] axi_rid_f,
  input  logic [          63:0] axi_rdata_f,
  input  logic [           1:0] axi_rresp_f,
  input  logic                  axi_rlast_f,
  input  logic                  axi_rvalid_f,
  output logic                  axi_rready_f,
  output logic                  empty
);

  localparam int FifoDepth = 16;
  assign axi_arlen_f   = FifoDepth;
  assign axi_arburst_f = INCR;

  // FIFO signals
  logic        full;
  logic [63:0] din;
  logic [63:0] dout;
  logic        flush;
  logic        wren;
  logic        rden;
  logic        almost_empty;

  logic        row_flush;

  logic [ 3:0] slicer;

  sync_fifo #(
      .RW   (64),
      .DEPTH(FifoDepth)
  ) sync_fifo_0 (
    .*
  );

  typedef enum logic [1:0] {
    IDLE  = 2'b00,
    FETCH = 2'b01
  } axi_state_t;

  axi_state_t axi_state = IDLE;
  axi_state_t axi_state_next = IDLE;

  assign axi_rready_f = ~full;
  assign wren         = axi_rready_f && axi_rvalid_f;

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
        if (wren) begin
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


  assign din[63:0]           = axi_rdata_f[63:0];
  assign rden                = !empty && row_flush;

  assign instr[31:0]         = empty ? 32'h13 : dout[31:0];
  assign compressed          = empty ? 0 : ~(instr[0] & instr[1]);

  assign axi_arid_f          = 0;
  assign axi_arlock_f        = 0;
  assign axi_arsize_f[2:0]   = 0;
  assign axi_arcache_f[3:0]  = 0;
  assign axi_arprot_f[2:0]   = 0;
  assign axi_arqos_f[3:0]    = 0;
  assign axi_arregion_f[3:0] = 0;

endmodule
