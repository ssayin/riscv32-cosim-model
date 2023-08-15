// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

// AXI4 Full SSRAM Controller Slave

import defs_pkg::*;

module ssram_ctrl #(
    parameter int AW = 32,
    parameter int DW = 64
) (
  input  logic              clk,
  input  logic              rst_n,
  // AW
  input  logic [AxiIdW-1:0] m_axi_awid,
  input  logic [      31:0] m_axi_awaddr,
  input  logic [       7:0] m_axi_awlen,
  input  logic [       2:0] m_axi_awsize,
  input  logic [       1:0] m_axi_awburst,
  input  logic              m_axi_awlock,
  input  logic [       3:0] m_axi_awcache,
  input  logic [       2:0] m_axi_awprot,
  input  logic              m_axi_awvalid,
  input  logic [       3:0] m_axi_awregion,
  input  logic [       3:0] m_axi_awqos,
  output logic              m_axi_awready,
  // W
  input  logic [      63:0] m_axi_wdata,
  input  logic [       7:0] m_axi_wstrb,
  input  logic              m_axi_wlast,
  input  logic              m_axi_wvalid,
  output logic              m_axi_wready,
  // B
  output logic [AxiIdW-1:0] m_axi_bid,
  output logic [       1:0] m_axi_bresp,
  output logic              m_axi_bvalid,
  input  logic              m_axi_bready,
  // AR
  input  logic [AxiIdW-1:0] m_axi_arid,
  input  logic [      31:0] m_axi_araddr,
  input  logic [       7:0] m_axi_arlen,
  input  logic [       2:0] m_axi_arsize,
  input  logic [       1:0] m_axi_arburst,
  input  logic              m_axi_arlock,
  input  logic [       3:0] m_axi_arcache,
  input  logic [       2:0] m_axi_arprot,
  input  logic              m_axi_arvalid,
  input  logic [       3:0] m_axi_arqos,
  input  logic [       3:0] m_axi_arregion,
  output logic              m_axi_arready,
  // R
  output logic [AxiIdW-1:0] m_axi_rid,
  output logic [      63:0] m_axi_rdata,
  output logic [       1:0] m_axi_rresp,
  output logic              m_axi_rlast,
  output logic              m_axi_rvalid,
  input  logic              m_axi_rready,
  // SRAM PORT A
  output logic              ena,
  output logic              rdena,
  output logic              wrena,
  output logic [       7:0] byteena,
  output logic [       9:0] addra,
  output logic [      63:0] dina,
  input  logic [      63:0] douta,
  // SRAM PORT B
  output logic              enb,
  output logic              rdenb,
  output logic              wrenb,
  output logic [       7:0] byteenb,
  output logic [       9:0] addrb,
  output logic [      63:0] dinb,
  input  logic [      63:0] doutb
);

  logic       o_we;
  logic       o_rd;

  logic [7:0] o_wstrb;
  logic [9:0] o_waddr;
  logic [9:0] o_raddr;

  assign addra[9:0] = o_raddr[9:0];
  assign addrb[9:0] = o_waddr[9:0];

  assign byteenb    = o_wstrb;

  assign ena        = 1;
  assign enb        = 1;
  assign rdena      = o_rd;
  assign rdenb      = 0;
  assign wdena      = 0;
  assign wdenb      = o_we;

  demofull #(
      .IW          (2),
      .DW          (64),
      .AW          (10),
      .OPT_LOCK    (1'b0),
      .OPT_LOCKID  (1'b1),
      .OPT_LOWPOWER(1'b0)
  ) full_0 (
    .*,
    .o_wdata     (dinb),
    .i_rdata     (douta),
    .m_axi_awaddr(m_axi_awaddr[9:0]),
    .m_axi_araddr(m_axi_araddr[9:0])
  );

endmodule
