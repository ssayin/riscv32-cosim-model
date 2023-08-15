// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

// Ensure instructions are aligned to 2 byte boundaries.
// Buffer size = 64
module ifu_mem_ctrl (
  input  logic              clk,
  input  logic              rst_n,
  //
  // IFU
  //
  input  logic              clr,
  input  logic [      31:1] ifu_fetch_pc,
  input  logic [      31:1] ifu_fetch_pc_d,
  input  logic [      31:1] ifu_last_pc,
  input  logic              ifu_npc_en,
  output logic              illegal,
  input  logic              ic_clear,
  output logic [      63:0] ic_rd,
  output logic              ic_valid,
  input  logic              ic_ready,
  //
  // AR Channel
  //
  output logic [AxiIdW-1:0] axi_arid_f,
  output logic [      31:0] axi_araddr_f,
  output logic [       7:0] axi_arlen_f,
  output logic [       2:0] axi_arsize_f,
  output logic [       1:0] axi_arburst_f,
  output logic              axi_arlock_f,
  output logic [       3:0] axi_arcache_f,
  output logic [       2:0] axi_arprot_f,
  output logic              axi_arvalid_f,
  output logic [       3:0] axi_arqos_f,
  output logic [       3:0] axi_arregion_f,
  input  logic              axi_arready_f,
  //
  // R Channel
  //
  input  logic [AxiIdW-1:0] axi_rid_f,
  input  logic [      63:0] axi_rdata_f,
  input  logic [       1:0] axi_rresp_f,
  input  logic              axi_rlast_f,
  input  logic              axi_rvalid_f,
  output logic              axi_rready_f
);
  ifu_icache ifu_icache_0 (
    .ic_cpu_reset(0),
    .*
  );

  assign axi_arburst_f = WRAP;
  assign axi_arlock_f  = 0;
  assign axi_arcache_f = 4'b0011;
  assign axi_arprot_f  = 3'b100;
  assign axi_arqos_f   = 4'h0000;
  assign axi_arsize_f  = 3'b011;
  assign axi_rready_f  = 1'b1;
  assign axi_arid_f    = 0;

endmodule


