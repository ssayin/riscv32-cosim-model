// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module top_level (
  input  logic        clk,
  input  logic        clk0,
  input  logic        clk1,
  input  logic        rst_n,
  // BRAM PORT A
  output logic        ena,
  output logic        rdena,
  output logic        wrena,
  output logic [ 7:0] byteena,
  output logic [ 9:0] addra,
  output logic [63:0] dina,
  input  logic [63:0] douta,
  // BRAM PORT B
  output logic        enb,
  output logic        rdenb,
  output logic        wrenb,
  output logic [ 7:0] byteenb,
  output logic [ 9:0] addrb,
  output logic [63:0] dinb,
  input  logic [63:0] doutb
);

  // AXI SLAVE
  logic [AxiIdW-1:0] m_axi_awid;
  logic [      31:0] m_axi_awaddr;
  logic [       7:0] m_axi_awlen;
  logic [       2:0] m_axi_awsize;
  logic [       1:0] m_axi_awburst;
  logic              m_axi_awlock;
  logic [       3:0] m_axi_awcache;
  logic [       2:0] m_axi_awprot;
  logic              m_axi_awvalid;
  logic [       3:0] m_axi_awregion;
  logic [       3:0] m_axi_awqos;
  logic              m_axi_awready;
  logic [      63:0] m_axi_wdata;
  logic [       7:0] m_axi_wstrb;
  logic              m_axi_wlast;
  logic              m_axi_wvalid;
  logic              m_axi_wready;
  logic [AxiIdW-1:0] m_axi_bid;
  logic [       1:0] m_axi_bresp;
  logic              m_axi_bvalid;
  logic              m_axi_bready;
  logic [AxiIdW-1:0] m_axi_arid;
  logic [      31:0] m_axi_araddr;
  logic [       7:0] m_axi_arlen;
  logic [       2:0] m_axi_arsize;
  logic [       1:0] m_axi_arburst;
  logic              m_axi_arlock;
  logic [       3:0] m_axi_arcache;
  logic [       2:0] m_axi_arprot;
  logic              m_axi_arvalid;
  logic [       3:0] m_axi_arqos;
  logic [       3:0] m_axi_arregion;
  logic              m_axi_arready;
  logic [AxiIdW-1:0] m_axi_rid;
  logic [      63:0] m_axi_rdata;
  logic [       1:0] m_axi_rresp;
  logic              m_axi_rlast;
  logic              m_axi_rvalid;
  logic              m_axi_rready;

  // AXI MASTER
  logic [AxiIdW-1:0] axi_awid_f;
  logic [      31:0] axi_awaddr_f;
  logic [       7:0] axi_awlen_f;
  logic [       2:0] axi_awsize_f;
  logic [       1:0] axi_awburst_f;
  logic              axi_awlock_f;
  logic [       3:0] axi_awcache_f;
  logic [       2:0] axi_awprot_f;
  logic              axi_awvalid_f;
  logic [       3:0] axi_awregion_f;
  logic [       3:0] axi_awqos_f;
  logic              axi_awready_f;
  logic [      63:0] axi_wdata_f;
  logic [       7:0] axi_wstrb_f;
  logic              axi_wlast_f;
  logic              axi_wvalid_f;
  logic              axi_wready_f;
  logic [AxiIdW-1:0] axi_bid_f;
  logic [       1:0] axi_bresp_f;
  logic              axi_bvalid_f;
  logic              axi_bready_f;
  logic [AxiIdW-1:0] axi_arid_f;
  logic [      31:0] axi_araddr_f;
  logic [       7:0] axi_arlen_f;
  logic [       2:0] axi_arsize_f;
  logic [       1:0] axi_arburst_f;
  logic              axi_arlock_f;
  logic [       3:0] axi_arcache_f;
  logic [       2:0] axi_arprot_f;
  logic              axi_arvalid_f;
  logic [       3:0] axi_arqos_f;
  logic [       3:0] axi_arregion_f;
  logic              axi_arready_f;
  logic [AxiIdW-1:0] axi_rid_f;
  logic [      63:0] axi_rdata_f;
  logic [       1:0] axi_rresp_f;
  logic              axi_rlast_f;
  logic              axi_rvalid_f;
  logic              axi_rready_f;
  // AXI MASTER
  logic [AxiIdW-1:0] axi_awid_m;
  logic [      31:0] axi_awaddr_m;
  logic [       7:0] axi_awlen_m;
  logic [       2:0] axi_awsize_m;
  logic [       1:0] axi_awburst_m;
  logic              axi_awlock_m;
  logic [       3:0] axi_awcache_m;
  logic [       2:0] axi_awprot_m;
  logic              axi_awvalid_m;
  logic [       3:0] axi_awregion_m;
  logic [       3:0] axi_awqos_m;
  logic              axi_awready_m;
  logic [      63:0] axi_wdata_m;
  logic [       7:0] axi_wstrb_m;
  logic              axi_wlast_m;
  logic              axi_wvalid_m;
  logic              axi_wready_m;
  logic [AxiIdW-1:0] axi_bid_m;
  logic [       1:0] axi_bresp_m;
  logic              axi_bvalid_m;
  logic              axi_bready_m;
  logic [AxiIdW-1:0] axi_arid_m;
  logic [      31:0] axi_araddr_m;
  logic [       7:0] axi_arlen_m;
  logic [       2:0] axi_arsize_m;
  logic [       1:0] axi_arburst_m;
  logic              axi_arlock_m;
  logic [       3:0] axi_arcache_m;
  logic [       2:0] axi_arprot_m;
  logic              axi_arvalid_m;
  logic [       3:0] axi_arqos_m;
  logic [       3:0] axi_arregion_m;
  logic              axi_arready_m;
  logic [AxiIdW-1:0] axi_rid_m;
  logic [      63:0] axi_rdata_m;
  logic [       1:0] axi_rresp_m;
  logic              axi_rlast_m;
  logic              axi_rvalid_m;
  logic              axi_rready_m;


  ssram_ctrl ssram_ctrl_0 (.*);


  riscv_core core_0 (.*);

  axixbar #(
      .C_AXI_DATA_WIDTH(64),
      .C_AXI_ADDR_WIDTH(32),
      .C_AXI_ID_WIDTH  (AxiIdW),
      .NM              (2),
      .NS              (2)
  ) axixbar_0 (
    .S_AXI_ACLK   (clk1),
    .S_AXI_ARESETN(rst_n),
    .S_AXI_AWID   ({axi_awid_m, axi_awid_f}),
    .S_AXI_AWADDR ({axi_awaddr_m, axi_awaddr_f}),
    .S_AXI_AWLEN  ({axi_awlen_m, axi_awlen_f}),
    .S_AXI_AWSIZE ({axi_awsize_m, axi_awsize_f}),
    .S_AXI_AWBURST({axi_awburst_m, axi_awburst_f}),
    .S_AXI_AWLOCK ({axi_awlock_m, axi_awlock_f}),
    .S_AXI_AWCACHE({axi_awcache_m, axi_awcache_f}),
    .S_AXI_AWPROT ({axi_awprot_m, axi_awprot_f}),
    .S_AXI_AWVALID({axi_awvalid_m, axi_awvalid_f}),
    //.S_AXI_AWREGION({axi_awregion_m, axi_awregion_f}),
    .S_AXI_AWQOS  ({axi_awqos_m, axi_awqos_f}),
    .S_AXI_AWREADY({axi_awready_m, axi_awready_f}),
    .S_AXI_WDATA  ({axi_wdata_m, axi_wdata_f}),
    .S_AXI_WSTRB  ({axi_wstrb_m, axi_wstrb_f}),
    .S_AXI_WLAST  ({axi_wlast_m, axi_wlast_f}),
    .S_AXI_WVALID ({axi_wvalid_m, axi_wvalid_f}),
    .S_AXI_WREADY ({axi_wready_m, axi_wready_f}),
    .S_AXI_BID    ({axi_bid_m, axi_bid_f}),
    .S_AXI_BRESP  ({axi_bresp_m, axi_bresp_f}),
    .S_AXI_BVALID ({axi_bvalid_m, axi_bvalid_f}),
    .S_AXI_BREADY ({axi_bready_m, axi_bready_f}),
    .S_AXI_ARID   ({axi_arid_m, axi_arid_f}),
    .S_AXI_ARADDR ({axi_araddr_m, axi_araddr_f}),
    .S_AXI_ARLEN  ({axi_arlen_m, axi_arlen_f}),
    .S_AXI_ARSIZE ({axi_arsize_m, axi_arsize_f}),
    .S_AXI_ARBURST({axi_arburst_m, axi_arburst_f}),
    .S_AXI_ARLOCK ({axi_arlock_m, axi_arlock_f}),
    .S_AXI_ARCACHE({axi_arcache_m, axi_arcache_f}),
    .S_AXI_ARPROT ({axi_arprot_m, axi_arprot_f}),
    .S_AXI_ARVALID({axi_arvalid_m, axi_arvalid_f}),
    .S_AXI_ARQOS  ({axi_arqos_m, axi_arqos_f}),
    //.S_AXI_ARREGION({axi_arregion_m, axi_arregion_f}),
    .S_AXI_ARREADY({axi_arready_m, axi_arready_f}),
    .S_AXI_RID    ({axi_rid_m, axi_rid_f}),
    .S_AXI_RDATA  ({axi_rdata_m, axi_rdata_f}),
    .S_AXI_RRESP  ({axi_rresp_m, axi_rresp_f}),
    .S_AXI_RLAST  ({axi_rlast_m, axi_rlast_f}),
    .S_AXI_RVALID ({axi_rvalid_m, axi_rvalid_f}),
    .S_AXI_RREADY ({axi_rready_m, axi_rready_f}),
    .M_AXI_AWID   (m_axi_awid),
    .M_AXI_AWADDR (m_axi_awaddr),
    .M_AXI_AWLEN  (m_axi_awlen),
    .M_AXI_AWSIZE (m_axi_awsize),
    .M_AXI_AWBURST(m_axi_awburst),
    .M_AXI_AWLOCK (m_axi_awlock),
    .M_AXI_AWCACHE(m_axi_awcache),
    .M_AXI_AWPROT (m_axi_awprot),
    .M_AXI_AWVALID(m_axi_awvalid),
    //.M_AXI_AWREGION(m_axi_awregion),
    .M_AXI_AWQOS  (m_axi_awqos),
    .M_AXI_AWREADY(m_axi_awready),
    .M_AXI_WDATA  (m_axi_wdata),
    .M_AXI_WSTRB  (m_axi_wstrb),
    .M_AXI_WLAST  (m_axi_wlast),
    .M_AXI_WVALID (m_axi_wvalid),
    .M_AXI_WREADY (m_axi_wready),
    .M_AXI_BID    (m_axi_bid),
    .M_AXI_BRESP  (m_axi_bresp),
    .M_AXI_BVALID (m_axi_bvalid),
    .M_AXI_BREADY (m_axi_bready),
    .M_AXI_ARID   (m_axi_arid),
    .M_AXI_ARADDR (m_axi_araddr),
    .M_AXI_ARLEN  (m_axi_arlen),
    .M_AXI_ARSIZE (m_axi_arsize),
    .M_AXI_ARBURST(m_axi_arburst),
    .M_AXI_ARLOCK (m_axi_arlock),
    .M_AXI_ARCACHE(m_axi_arcache),
    .M_AXI_ARPROT (m_axi_arprot),
    .M_AXI_ARVALID(m_axi_arvalid),
    .M_AXI_ARQOS  (m_axi_arqos),
    //.M_AXI_ARREGION(m_axi_arregion),
    .M_AXI_ARREADY(m_axi_arready),
    .M_AXI_RID    (m_axi_rid),
    .M_AXI_RDATA  (m_axi_rdata),
    .M_AXI_RRESP  (m_axi_rresp),
    .M_AXI_RLAST  (m_axi_rlast),
    .M_AXI_RVALID (m_axi_rvalid),
    .M_AXI_RREADY (m_axi_rready)
  );

  assign axi_awid_f[AxiIdW-1:0] = 0;
  assign axi_awaddr_f[31:0]     = 0;
  assign axi_awlen_f[7:0]       = 0;
  assign axi_awsize_f[2:0]      = 0;
  assign axi_awburst_f[1:0]     = 0;
  assign axi_awlock_f           = 0;
  assign axi_awcache_f[3:0]     = 0;
  assign axi_awprot_f[2:0]      = 0;
  assign axi_awvalid_f          = 0;
  assign axi_awregion_f[3:0]    = 0;
  assign axi_awqos_f[3:0]       = 0;
  assign axi_wdata_f[63:0]      = 0;
  assign axi_wstrb_f[7:0]       = 0;
  assign axi_wlast_f            = 0;
  assign axi_wvalid_f           = 0;
  assign axi_bready_f           = 0;

endmodule
