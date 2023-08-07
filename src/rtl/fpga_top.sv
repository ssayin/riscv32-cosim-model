// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0


// USE AT YOUR OWN RISK
module fpga_top (
  clk_clk,
  rst_n_reset_n,
  PIN_133,
  PIN_135,
  PIN_136,
  PIN_137,
  PIN_128,
  PIN_121,
  PIN_125,
  PIN_129,
  PIN_132,
  PIN_126,
  PIN_124,
  PIN_127,
  PIN_114,
  PIN_115,
  PIN_87,
  PIN_86,
  PIN_85,
  PIN_84
);

  logic altpll_0_locked_conduit_export;

  output logic PIN_133;
  output logic PIN_135;
  output logic PIN_136;
  output logic PIN_137;
  output logic PIN_128;
  output logic PIN_121;
  output logic PIN_125;
  output logic PIN_129;
  output logic PIN_132;
  output logic PIN_126;
  output logic PIN_124;
  output logic PIN_127;
  output logic PIN_114;
  output logic PIN_115;
  output logic PIN_87;
  output logic PIN_86;
  output logic PIN_85;
  output logic PIN_84;

  /*input*/logic        altpll_0_pll_slave_read;
  /*input*/logic        altpll_0_pll_slave_write;
  /*input*/logic [ 1:0] altpll_0_pll_slave_address;
  /*output*/logic [31:0] altpll_0_pll_slave_readdata;
  /*input*/logic [31:0] altpll_0_pll_slave_writedata;

  assign altpll_0_pll_slave_read      = 0;
  assign altpll_0_pll_slave_write     = 0;
  assign altpll_0_pll_slave_address   = 2'b00;
  assign altpll_0_pll_slave_writedata = 32'h0;

  input logic clk_clk;
  input logic rst_n_reset_n;

  logic altpll_0_c1_clk;
  logic clock_bridge_0_in_clk_clk;

  assign clock_bridge_0_in_clk_clk = altpll_0_c1_clk;

  logic [ 1:0] axi_bridge_0_s0_awid;
  logic [31:0] axi_bridge_0_s0_awaddr;
  logic [ 7:0] axi_bridge_0_s0_awlen;
  logic [ 2:0] axi_bridge_0_s0_awsize;
  logic [ 1:0] axi_bridge_0_s0_awburst;
  logic [ 0:0] axi_bridge_0_s0_awlock;
  logic [ 3:0] axi_bridge_0_s0_awcache;
  logic [ 2:0] axi_bridge_0_s0_awprot;
  logic [ 3:0] axi_bridge_0_s0_awqos;
  logic [ 3:0] axi_bridge_0_s0_awregion;
  logic        axi_bridge_0_s0_awvalid;
  logic        axi_bridge_0_s0_awready;
  logic [63:0] axi_bridge_0_s0_wdata;
  logic [ 7:0] axi_bridge_0_s0_wstrb;
  logic        axi_bridge_0_s0_wlast;
  logic        axi_bridge_0_s0_wvalid;
  logic        axi_bridge_0_s0_wready;
  logic [ 1:0] axi_bridge_0_s0_bid;
  logic [ 1:0] axi_bridge_0_s0_bresp;
  logic        axi_bridge_0_s0_bvalid;
  logic        axi_bridge_0_s0_bready;
  logic [ 1:0] axi_bridge_0_s0_arid;
  logic [31:0] axi_bridge_0_s0_araddr;
  logic [ 7:0] axi_bridge_0_s0_arlen;
  logic [ 2:0] axi_bridge_0_s0_arsize;
  logic [ 1:0] axi_bridge_0_s0_arburst;
  logic [ 0:0] axi_bridge_0_s0_arlock;
  logic [ 3:0] axi_bridge_0_s0_arcache;
  logic [ 2:0] axi_bridge_0_s0_arprot;
  logic [ 3:0] axi_bridge_0_s0_arqos;
  logic [ 3:0] axi_bridge_0_s0_arregion;
  logic        axi_bridge_0_s0_arvalid;
  logic        axi_bridge_0_s0_arready;
  logic [ 1:0] axi_bridge_0_s0_rid;
  logic [63:0] axi_bridge_0_s0_rdata;
  logic [ 1:0] axi_bridge_0_s0_rresp;
  logic        axi_bridge_0_s0_rlast;
  logic        axi_bridge_0_s0_rvalid;
  logic        axi_bridge_0_s0_rready;

  cycloneiv top (.*);

  riscv_core riscv_core_0 (
    .clk           (altpll_0_c1_clk),
    .rst_n         (rst_n_reset_n),
    .axi_awid_f    (axi_bridge_0_s0_awid),
    .axi_awaddr_f  (axi_bridge_0_s0_awaddr),
    .axi_awlen_f   (axi_bridge_0_s0_awlen),
    .axi_awsize_f  (axi_bridge_0_s0_awsize),
    .axi_awburst_f (axi_bridge_0_s0_awburst),
    .axi_awlock_f  (axi_bridge_0_s0_awlock),
    .axi_awcache_f (axi_bridge_0_s0_awcache),
    .axi_awprot_f  (axi_bridge_0_s0_awprot),
    .axi_awvalid_f (axi_bridge_0_s0_awvalid),
    .axi_awregion_f(axi_bridge_0_s0_awregion),
    .axi_awqos_f   (axi_bridge_0_s0_awqos),
    .axi_awready_f (axi_bridge_0_s0_awready),

    // WD Channel
    .axi_wdata_f (axi_bridge_0_s0_wdata),
    .axi_wstrb_f (axi_bridge_0_s0_wstrb),
    .axi_wlast_f (axi_bridge_0_s0_wlast),
    .axi_wvalid_f(axi_bridge_0_s0_wvalid),
    .axi_wready_f(axi_bridge_0_s0_wready),

    // Write Response Channel
    .axi_bid_f   (axi_bridge_0_s0_bid),
    .axi_bresp_f (axi_bridge_0_s0_bresp),
    .axi_bvalid_f(axi_bridge_0_s0_bvalid),
    .axi_bready_f(axi_bridge_0_s0_bready),

    // RA Channel
    .axi_arid_f    (axi_bridge_0_s0_arid),
    .axi_araddr_f  (axi_bridge_0_s0_araddr),
    .axi_arlen_f   (axi_bridge_0_s0_arlen),
    .axi_arsize_f  (axi_bridge_0_s0_arsize),
    .axi_arburst_f (axi_bridge_0_s0_arburst),
    .axi_arlock_f  (axi_bridge_0_s0_arlock),
    .axi_arcache_f (axi_bridge_0_s0_arcache),
    .axi_arprot_f  (axi_bridge_0_s0_arprot),
    .axi_arvalid_f (axi_bridge_0_s0_arvalid),
    .axi_arqos_f   (axi_bridge_0_s0_arqos),
    .axi_arregion_f(axi_bridge_0_s0_arregion),
    .axi_arready_f (axi_bridge_0_s0_arready),

    // RD Channel
    .axi_rid_f   (axi_bridge_0_s0_rid),
    .axi_rdata_f (axi_bridge_0_s0_rdata),
    .axi_rresp_f (axi_bridge_0_s0_rresp),
    .axi_rlast_f (axi_bridge_0_s0_rlast),
    .axi_rvalid_f(axi_bridge_0_s0_rvalid),
    .axi_rready_f(axi_bridge_0_s0_rready)

    /*
  // WA Channel
   axi_awid_m,
   axi_awaddr_m,
   axi_awlen_m,
   axi_awsize_m,
   axi_awburst_m,
   axi_awlock_m,
   axi_awcache_m,
   axi_awprot_m,
   axi_awvalid_m,
   axi_awregion_m,
   axi_awqos_m,
   axi_awready_m,

  // WD Channel
   axi_wdata_m,
   axi_wstrb_m,
   axi_wlast_m,
   axi_wvalid_m,
   axi_wready_m,

  // Write Response Channel
   axi_bid_m,
   axi_bresp_m,
   axi_bvalid_m,
   axi_bready_m,

  // RA Channel
   axi_arid_m,
   axi_araddr_m,
   axi_arlen_m,
   axi_arsize_m,
   axi_arburst_m,
   axi_arlock_m,
   axi_arcache_m,
   axi_arprot_m,
   axi_arvalid_m,
   axi_arqos_m,
   axi_arregion_m,
   axi_arready_m,

  // RD Channel
   axi_rid_m,
   axi_rdata_m,
   axi_rresp_m,
   axi_rlast_m,
   axi_rvalid_m,
   axi_rready_m
   */


  );

endmodule
