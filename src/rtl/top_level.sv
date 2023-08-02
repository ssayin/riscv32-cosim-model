module top_level (
  input logic clk,
  input logic rst_n
);

  logic        axi_awid;
  logic [31:0] axi_awaddr;
  logic [ 7:0] axi_awlen;
  logic [ 2:0] axi_awsize;
  logic [ 1:0] axi_awburst;
  logic        axi_awlock;
  logic [ 3:0] axi_awcache;
  logic [ 2:0] axi_awprot;
  logic        axi_awvalid;
  logic [ 3:0] axi_awregion;
  logic [ 3:0] axi_awqos;
  logic        axi_awready;
  logic [63:0] axi_wdata;
  logic [ 7:0] axi_wstrb;
  logic        axi_wlast;
  logic        axi_wvalid;
  logic        axi_wready;
  logic        axi_bid;
  logic [ 1:0] axi_bresp;
  logic        axi_bvalid;
  logic        axi_bready;
  logic        axi_arid;
  logic [31:0] axi_araddr;
  logic [ 7:0] axi_arlen;
  logic [ 2:0] axi_arsize;
  logic [ 1:0] axi_arburst;
  logic        axi_arlock;
  logic [ 3:0] axi_arcache;
  logic [ 2:0] axi_arprot;
  logic        axi_arvalid;
  logic [ 3:0] axi_arqos;
  logic [ 3:0] axi_arregion;
  logic        axi_arready;
  logic        axi_rid;
  logic [63:0] axi_rdata;
  logic [ 1:0] axi_rresp;
  logic        axi_rlast;
  logic        axi_rvalid;
  logic        axi_rready;

  ssram_ctrl ssram_ctrl_0(.*);

  //riscv_core core_0 (.*);

endmodule
