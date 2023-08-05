// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module axi4crossbar #(
    parameter int DW = 64,
    parameter int AW = 32,
    parameter int IW = 4,
    parameter int M  = 2,
    parameter int S  = 1
) (
  input logic clk,
  input logic rst_n,

  input  logic [M*IW-1:0] s_axi_awid,
  input  logic [M*AW-1:0] s_axi_awaddr,
  input  logic [ M*8-1:0] s_axi_awlen,
  input  logic [ M*3-1:0] s_axi_awsize,
  input  logic [ M*2-1:0] s_axi_awburst,
  input  logic [   M-1:0] s_axi_awlock,
  input  logic [ M*4-1:0] s_axi_awcache,
  input  logic [ M*3-1:0] s_axi_awprot,
  input  logic [   M-1:0] s_axi_awvalid,
  input  logic [ M*4-1:0] s_axi_awregion,
  input  logic [ M*4-1:0] s_axi_awqos,
  output logic [   M-1:0] s_axi_awready,

  input  logic [  M*DW-1:0] s_axi_wdata,
  input  logic [M*DW/8-1:0] s_axi_wstrb,
  input  logic [     M-1:0] s_axi_wlast,
  input  logic [     M-1:0] s_axi_wvalid,
  output logic [     M-1:0] s_axi_wready,

  output logic [M*IW-1:0] s_axi_bid,
  output logic [ M*2-1:0] s_axi_bresp,
  output logic [   M-1:0] s_axi_bvalid,
  input  logic [   M-1:0] s_axi_bready,

  input  logic [M*IW-1:0] s_axi_arid,
  input  logic [M*AW-1:0] s_axi_araddr,
  input  logic [ M*8-1:0] s_axi_arlen,     // 4KB max
  input  logic [ M*3-1:0] s_axi_arsize,
  input  logic [ M*2-1:0] s_axi_arburst,
  input  logic [   M-1:0] s_axi_arlock,
  input  logic [ M*4-1:0] s_axi_arcache,
  input  logic [ M*3-1:0] s_axi_arprot,
  input  logic [   M-1:0] s_axi_arvalid,
  input  logic [ M*4-1:0] s_axi_arqos,
  input  logic [ M*4-1:0] s_axi_arregion,
  output logic [   M-1:0] s_axi_arready,

  output logic [M*IW-1:0] s_axi_rid,
  output logic [M*DW-1:0] s_axi_rdata,
  output logic [ M*2-1:0] s_axi_rresp,
  output logic [   M-1:0] s_axi_rlast,
  output logic [   M-1:0] s_axi_rvalid,
  input  logic [   M-1:0] s_axi_rready,

  output logic [S*IW-1:0] m_axi_awid,
  output logic [S*AW-1:0] m_axi_awaddr,
  output logic [ S*8-1:0] m_axi_awlen,
  output logic [ S*3-1:0] m_axi_awsize,
  output logic [ S*2-1:0] m_axi_awburst,
  output logic [   S-1:0] m_axi_awlock,
  output logic [ S*4-1:0] m_axi_awcache,
  output logic [ S*3-1:0] m_axi_awprot,
  output logic [   S-1:0] m_axi_awvalid,
  output logic [ S*4-1:0] m_axi_awregion,
  output logic [ S*4-1:0] m_axi_awqos,
  input  logic [   S-1:0] m_axi_awready,

  // WD Channel
  output logic [  S*DW-1:0] m_axi_wdata,
  output logic [S*DW/8-1:0] m_axi_wstrb,
  output logic [     S-1:0] m_axi_wlast,
  output logic [     S-1:0] m_axi_wvalid,
  input  logic [     S-1:0] m_axi_wready,

  // Write Response Channel
  input  logic [S*IW-1:0] m_axi_bid,
  input  logic [ S*2-1:0] m_axi_bresp,
  input  logic [   S-1:0] m_axi_bvalid,
  output logic [   S-1:0] m_axi_bready,

  // RA Channel
  output logic [S*IW-1:0] m_axi_arid,
  output logic [S*AW-1:0] m_axi_araddr,
  output logic [ S*8-1:0] m_axi_arlen,
  output logic [ S*3-1:0] m_axi_arsize,
  output logic [ S*2-1:0] m_axi_arburst,
  output logic [   S-1:0] m_axi_arlock,
  output logic [ S*4-1:0] m_axi_arcache,
  output logic [ S*3-1:0] m_axi_arprot,
  output logic [   S-1:0] m_axi_arvalid,
  output logic [ S*4-1:0] m_axi_arqos,
  output logic [ S*4-1:0] m_axi_arregion,
  input  logic [   S-1:0] m_axi_arready,

  // RD Channel
  input  logic [S*IW-1:0] m_axi_rid,
  input  logic [S*DW-1:0] m_axi_rdata,
  input  logic [ S*2-1:0] m_axi_rresp,
  input  logic [   S-1:0] m_axi_rlast,
  input  logic [   S-1:0] m_axi_rvalid,
  output logic [   S-1:0] m_axi_rready
);

endmodule
