module mem_stage (
  input  logic                       clk,
  input  logic                       rst_n,
  input  logic      [          31:0] mem_in,
  input  logic                       compressed_m,
  input  logic                       rd_en_m,
  input  reg_data_t                  alu_res_m,
  input  reg_data_t                  store_data_m,
  input  logic                       lsu_m,
  input  logic      [LsuOpWidth-1:0] lsu_op_m,
  input  logic                       br_taken_m,
  input  logic                       br_m,
  input  reg_addr_t                  rd_addr_m,
  output logic                       rd_en_wb,
  output reg_addr_t                  rd_addr_wb,
  output reg_data_t                  rd_data_wb,

  // WA Channel
  output logic        axi_awid_m,
  output logic [31:0] axi_awaddr_m,
  output logic [ 7:0] axi_awlen_m,
  output logic [ 2:0] axi_awsize_m,
  output logic [ 1:0] axi_awburst_m,
  output logic        axi_awlock_m,
  output logic [ 3:0] axi_awcache_m,
  output logic [ 2:0] axi_awprot_m,
  output logic        axi_awvalid_m,
  output logic [ 3:0] axi_awregion_m,
  output logic [ 3:0] axi_awqos_m,
  input  logic        axi_awready_m,

  // WD Channel
  output logic [63:0] axi_wdata_m,
  output logic [ 7:0] axi_wstrb_m,
  output logic        axi_wlast_m,
  output logic        axi_wvalid_m,
  input  logic        axi_wready_m,

  // Write Response Channel
  input  logic       axi_bid_m,
  input  logic [1:0] axi_bresp_m,
  input  logic       axi_bvalid_m,
  output logic       axi_bready_m,

  // RA Channel
  output logic        axi_arid_m,
  output logic [31:0] axi_araddr_m,
  output logic [ 7:0] axi_arlen_m,
  output logic [ 2:0] axi_arsize_m,
  output logic [ 1:0] axi_arburst_m,
  output logic        axi_arlock_m,
  output logic [ 3:0] axi_arcache_m,
  output logic [ 2:0] axi_arprot_m,
  output logic        axi_arvalid_m,
  output logic [ 3:0] axi_arqos_m,
  output logic [ 3:0] axi_arregion_m,
  input  logic        axi_arready_m,

  // RD Channel
  input  logic        axi_rid_m,
  input  logic [63:0] axi_rdata_m,
  input  logic [ 1:0] axi_rresp_m,
  input  logic        axi_rlast_m,
  input  logic        axi_rvalid_m,
  output logic        axi_rready_m
);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rd_data_wb <= 32'h0;
      rd_addr_wb <= 32'h0;
      rd_en_wb   <= 1'b0;
    end else begin
      rd_data_wb <= lsu_m ? mem_in : alu_res_m;
      rd_addr_wb <= rd_addr_m;
      rd_en_wb   <= rd_en_m;
    end
  end

endmodule
