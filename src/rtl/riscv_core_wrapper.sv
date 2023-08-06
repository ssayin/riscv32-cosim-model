`timescale 1 ps / 1 ps

module chip (
  aresetn,

  aclk
);
  input aclk;
  input aresetn;


  logic        aclk;
  logic        aresetn;

  logic [ 1:0] S_AXI_0_awid;
  logic [31:0] S_AXI_0_awaddr;
  logic [ 7:0] S_AXI_0_awlen;
  logic [ 2:0] S_AXI_0_awsize;
  logic [ 1:0] S_AXI_0_awburst;
  logic        S_AXI_0_awlock;
  logic [ 3:0] S_AXI_0_awcache;
  logic [ 2:0] S_AXI_0_awprot;
  logic        S_AXI_0_awvalid;
  logic [ 3:0] S_AXI_0_awregion;
  logic [ 3:0] S_AXI_0_awqos;
  logic        S_AXI_0_awready;

  logic [63:0] S_AXI_0_wdata;
  logic [ 7:0] S_AXI_0_wstrb;
  logic        S_AXI_0_wlast;
  logic        S_AXI_0_wvalid;
  logic        S_AXI_0_wready;

  logic [ 1:0] S_AXI_0_bid;
  logic [ 1:0] S_AXI_0_bresp;
  logic        S_AXI_0_bvalid;
  logic        S_AXI_0_bready;

  logic [ 1:0] S_AXI_0_arid;
  logic [31:0] S_AXI_0_araddr;
  logic [ 7:0] S_AXI_0_arlen;
  logic [ 2:0] S_AXI_0_arsize;
  logic [ 1:0] S_AXI_0_arburst;
  logic        S_AXI_0_arlock;
  logic [ 3:0] S_AXI_0_arcache;
  logic [ 2:0] S_AXI_0_arprot;
  logic        S_AXI_0_arvalid;
  logic [ 3:0] S_AXI_0_arqos;
  logic [ 3:0] S_AXI_0_arregion;
  logic        S_AXI_0_arready;

  logic [ 1:0] S_AXI_0_rid;
  logic [63:0] S_AXI_0_rdata;
  logic [ 1:0] S_AXI_0_rresp;
  logic        S_AXI_0_rlast;
  logic        S_AXI_0_rvalid;
  logic        S_AXI_0_rready;

  riscv_core riscv_core_0 (
    .clk          (aclk),
    .rst_n        (aresetn),
    .axi_araddr_f (S_AXI_0_araddr),
    .axi_arburst_f(S_AXI_0_arburst),
    .axi_arcache_f(S_AXI_0_arcache),
    .axi_arlen_f  (S_AXI_0_arlen),
    .axi_arlock_f (S_AXI_0_arlock),
    .axi_arprot_f (S_AXI_0_arprot),
    .axi_arready_f(S_AXI_0_arready),
    .axi_arsize_f (S_AXI_0_arsize),
    .axi_arvalid_f(S_AXI_0_arvalid),
    .axi_awaddr_f (S_AXI_0_awaddr),
    .axi_awburst_f(S_AXI_0_awburst),
    .axi_awcache_f(S_AXI_0_awcache),
    .axi_awlen_f  (S_AXI_0_awlen),
    .axi_awlock_f (S_AXI_0_awlock),
    .axi_awprot_f (S_AXI_0_awprot),
    .axi_awready_f(S_AXI_0_awready),
    .axi_awsize_f (S_AXI_0_awsize),
    .axi_awvalid_f(S_AXI_0_awvalid),
    .axi_bready_f (S_AXI_0_bready),
    .axi_bresp_f  (S_AXI_0_bresp),
    .axi_bvalid_f (S_AXI_0_bvalid),
    .axi_rdata_f  (S_AXI_0_rdata),
    .axi_rlast_f  (S_AXI_0_rlast),
    .axi_rready_f (S_AXI_0_rready),
    .axi_rresp_f  (S_AXI_0_rresp),
    .axi_rvalid_f (S_AXI_0_rvalid),
    .axi_wdata_f  (S_AXI_0_wdata),
    .axi_wlast_f  (S_AXI_0_wlast),
    .axi_wready_f (S_AXI_0_wready),
    .axi_wstrb_f  (S_AXI_0_wstrb),
    .axi_wvalid_f (S_AXI_0_wvalid)
  );


  ex_sim ex_design (
    .aresetn(aresetn),
    .aclk   (aclk),
    .*
  );
endmodule


