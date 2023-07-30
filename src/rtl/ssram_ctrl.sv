module ssram_ctrl (
  output logic        clk,
  // WA Channel
  input  logic        axi_awid,
  input  logic [31:0] axi_awaddr,
  input  logic [ 7:0] axi_awlen,
  input  logic [ 2:0] axi_awsize,
  input  logic [ 1:0] axi_awburst,
  input  logic        axi_awlock,
  input  logic [ 3:0] axi_awcache,
  input  logic [ 2:0] axi_awprot,
  input  logic        axi_awvalid,
  input  logic [ 3:0] axi_awregion,
  input  logic [ 3:0] axi_awqos,
  output logic        axi_awready,

  // WD Channel
  input  logic [63:0] axi_wdata,
  input  logic [ 7:0] axi_wstrb,
  input  logic        axi_wlast,
  input  logic        axi_wvalid,
  output logic        axi_wready,

  // Write Response Channel
  output logic       axi_bid,
  output logic [1:0] axi_bresp,
  output logic       axi_bvalid,
  input  logic       axi_bready,

  // RA Channel
  input  logic        axi_arid,
  input  logic [31:0] axi_araddr,
  input  logic [ 7:0] axi_arlen,
  input  logic [ 2:0] axi_arsize,
  input  logic [ 1:0] axi_arburst,
  input  logic        axi_arlock,
  input  logic [ 3:0] axi_arcache,
  input  logic [ 2:0] axi_arprot,
  input  logic        axi_arvalid,
  input  logic [ 3:0] axi_arqos,
  input  logic [ 3:0] axi_arregion,
  output logic        axi_arready,

  // RD Channel
  output logic        axi_rid,
  output logic [63:0] axi_rdata,
  output logic [ 1:0] axi_rresp,
  output logic        axi_rlast,
  output logic        axi_rvalid,
  input  logic        axi_rready

);

endmodule
