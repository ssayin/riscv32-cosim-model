// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module top_level (
  input logic clk,
  input logic rst_n
);

  logic [AxiIdWidth-1:0] axi_awid;
  logic [          31:0] axi_awaddr;
  logic [           7:0] axi_awlen;
  logic [           2:0] axi_awsize;
  logic [           1:0] axi_awburst;
  logic                  axi_awlock;
  logic [           3:0] axi_awcache;
  logic [           2:0] axi_awprot;
  logic                  axi_awvalid;
  logic [           3:0] axi_awregion;
  logic [           3:0] axi_awqos;
  logic                  axi_awready;
  logic [          63:0] axi_wdata;
  logic [           7:0] axi_wstrb;
  logic                  axi_wlast;
  logic                  axi_wvalid;
  logic                  axi_wready;
  logic [AxiIdWidth-1:0] axi_bid;
  logic [           1:0] axi_bresp;
  logic                  axi_bvalid;
  logic                  axi_bready;
  logic [AxiIdWidth-1:0] axi_arid;
  logic [          31:0] axi_araddr;
  logic [           7:0] axi_arlen;
  logic [           2:0] axi_arsize;
  logic [           1:0] axi_arburst;
  logic                  axi_arlock;
  logic [           3:0] axi_arcache;
  logic [           2:0] axi_arprot;
  logic                  axi_arvalid;
  logic [           3:0] axi_arqos;
  logic [           3:0] axi_arregion;
  logic                  axi_arready;
  logic [AxiIdWidth-1:0] axi_rid;
  logic [          63:0] axi_rdata;
  logic [           1:0] axi_rresp;
  logic                  axi_rlast;
  logic                  axi_rvalid;
  logic                  axi_rready;

  // Internal wires that connect SSRAM
  logic                  clka;
  logic                  rsta;
  logic                  ena;
  logic                  regcea;
  logic [           7:0] wea;
  logic [          31:0] addra;
  logic [          63:0] dina;
  logic [          63:0] douta;
  logic                  clkb;
  logic                  rstb;
  logic                  enb;
  logic                  regceb;
  logic [           7:0] web;
  logic [          31:0] addrb;
  logic [          63:0] dinb;
  logic [          63:0] doutb;

  logic [AxiIdWidth-1:0] axi_awid_f;
  logic [          31:0] axi_awaddr_f;
  logic [           7:0] axi_awlen_f;
  logic [           2:0] axi_awsize_f;
  logic [           1:0] axi_awburst_f;
  logic                  axi_awlock_f;
  logic [           3:0] axi_awcache_f;
  logic [           2:0] axi_awprot_f;
  logic                  axi_awvalid_f;
  logic [           3:0] axi_awregion_f;
  logic [           3:0] axi_awqos_f;
  logic                  axi_awready_f;

  // WD Channel
  logic [          63:0] axi_wdata_f;
  logic [           7:0] axi_wstrb_f;
  logic                  axi_wlast_f;
  logic                  axi_wvalid_f;
  logic                  axi_wready_f;

  // Write Response Channel
  logic [AxiIdWidth-1:0] axi_bid_f;
  logic [           1:0] axi_bresp_f;
  logic                  axi_bvalid_f;
  logic                  axi_bready_f;

  // RA Channel
  logic [AxiIdWidth-1:0] axi_arid_f;
  logic [          31:0] axi_araddr_f;
  logic [           7:0] axi_arlen_f;
  logic [           2:0] axi_arsize_f;
  logic [           1:0] axi_arburst_f;
  logic                  axi_arlock_f;
  logic [           3:0] axi_arcache_f;
  logic [           2:0] axi_arprot_f;
  logic                  axi_arvalid_f;
  logic [           3:0] axi_arqos_f;
  logic [           3:0] axi_arregion_f;
  logic                  axi_arready_f;

  // RD Channel
  logic [AxiIdWidth-1:0] axi_rid_f;
  logic [          63:0] axi_rdata_f;
  logic [           1:0] axi_rresp_f;
  logic                  axi_rlast_f;
  logic                  axi_rvalid_f;
  logic                  axi_rready_f;


  // WA Channel
  logic [AxiIdWidth-1:0] axi_awid_m;
  logic [          31:0] axi_awaddr_m;
  logic [           7:0] axi_awlen_m;
  logic [           2:0] axi_awsize_m;
  logic [           1:0] axi_awburst_m;
  logic                  axi_awlock_m;
  logic [           3:0] axi_awcache_m;
  logic [           2:0] axi_awprot_m;
  logic                  axi_awvalid_m;
  logic [           3:0] axi_awregion_m;
  logic [           3:0] axi_awqos_m;
  logic                  axi_awready_m;

  // WD Channel
  logic [          63:0] axi_wdata_m;
  logic [           7:0] axi_wstrb_m;
  logic                  axi_wlast_m;
  logic                  axi_wvalid_m;
  logic                  axi_wready_m;

  // Write Response Channel
  logic [AxiIdWidth-1:0] axi_bid_m;
  logic [           1:0] axi_bresp_m;
  logic                  axi_bvalid_m;
  logic                  axi_bready_m;

  // RA Channel
  logic [AxiIdWidth-1:0] axi_arid_m;
  logic [          31:0] axi_araddr_m;
  logic [           7:0] axi_arlen_m;
  logic [           2:0] axi_arsize_m;
  logic [           1:0] axi_arburst_m;
  logic                  axi_arlock_m;
  logic [           3:0] axi_arcache_m;
  logic [           2:0] axi_arprot_m;
  logic                  axi_arvalid_m;
  logic [           3:0] axi_arqos_m;
  logic [           3:0] axi_arregion_m;
  logic                  axi_arready_m;

  // RD Channel
  logic [AxiIdWidth-1:0] axi_rid_m;
  logic [          63:0] axi_rdata_m;
  logic [           1:0] axi_rresp_m;
  logic                  axi_rlast_m;
  logic                  axi_rvalid_m;
  logic                  axi_rready_m;


  ssram #(
      .ADDR_WIDTH(32),
      .DATA_WIDTH(64)
  ) ssram_0 (
    .*
  );

  assign regcea = 0;
  assign regceb = 0;

  assign clka   = clk;
  assign clkb   = clk;
  assign rsta   = rst_n;
  assign rstb   = rst_n;


  riscv_core core_0 (.*);

  ssram_ctrl ssram_ctrl_0 (
    .clk         (clk),
    .rst_n       (rst_n),
    .axi_awid    (axi_awid_m),
    .axi_awaddr  (axi_awaddr_m),
    .axi_awlen   (axi_awlen_m),
    .axi_awsize  (axi_awsize_m),
    .axi_awburst (axi_awburst_m),
    .axi_awlock  (axi_awlock_m),
    .axi_awcache (axi_awcache_m),
    .axi_awprot  (axi_awprot_m),
    .axi_awvalid (axi_awvalid_m),
    .axi_awregion(axi_awregion_m),
    .axi_awqos   (axi_awqos_m),
    .axi_awready (axi_awready_m),
    .axi_wdata   (axi_wdata_m),
    .axi_wstrb   (axi_wstrb_m),
    .axi_wlast   (axi_wlast_m),
    .axi_wvalid  (axi_wvalid_m),
    .axi_wready  (axi_wready_m),
    .axi_bid     (axi_bid_m),
    .axi_bresp   (axi_bresp_m),
    .axi_bvalid  (axi_bvalid_m),
    .axi_bready  (axi_bready_m),
    .axi_arid    (axi_arid_f),
    .axi_araddr  (axi_araddr_f),
    .axi_arlen   (axi_arlen_f),
    .axi_arsize  (axi_arsize_f),
    .axi_arburst (axi_arburst_f),
    .axi_arlock  (axi_arlock_f),
    .axi_arcache (axi_arcache_f),
    .axi_arprot  (axi_arprot_f),
    .axi_arvalid (axi_arvalid_f),
    .axi_arqos   (axi_arqos_f),
    .axi_arregion(axi_arregion_f),
    .axi_arready (axi_arready_f),
    .axi_rid     (axi_rid_f),
    .axi_rdata   (axi_rdata_f),
    .axi_rresp   (axi_rresp_f),
    .axi_rlast   (axi_rlast_f),
    .axi_rvalid  (axi_rvalid_f),
    .axi_rready  (axi_rready_f),
    .clka        (clka),
    .rsta        (rsta),
    .ena         (ena),
    .wea         (wea),
    .addra       (addra),
    .dina        (dina),
    .douta       (douta),
    .clkb        (clkb),
    .rstb        (rstb),
    .enb         (enb),
    .web         (web),
    .addrb       (addrb),
    .dinb        (dinb),
    .doutb       (doutb)
  );
endmodule
